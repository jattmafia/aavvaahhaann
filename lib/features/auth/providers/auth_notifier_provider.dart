// ignore_for_file: unused_result

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:avahan/config.dart';
import 'package:avahan/core/models/guest.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/device_info_provider.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:avahan/core/repositories/functions_repository.dart';
import 'package:avahan/core/repositories/guest_repository.dart';
import 'package:avahan/core/topics.dart';
import 'package:avahan/features/notifications/notification_writer.dart';
import 'package:avahan/features/profile/providers/guest_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/cache_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/auth/models/auth_state.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';

part 'auth_notifier_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(
      phoneNumber: '',
      loading: false,
      email: '',
      password: '',
    );
  }

  FirebaseMessaging get _messaging => ref.read(messagingProvider);

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void phoneNumberChanged(String v) {
    state = state.copyWith(phoneNumber: v);
  }

  void emailChanged(String v) {
    state = state.copyWith(email: v);
  }

  void passwordChanged(String v) {
    state = state.copyWith(password: v);
  }

  final _google = GoogleSignIn(
    serverClientId: Config.serverClientId,
    clientId: defaultTargetPlatform == TargetPlatform.iOS? "906533537374-1tp55hmr5tthc5acgpa7n7plpmh71nib.apps.googleusercontent.com": null,
    scopes: [
      'openid',
      'email',
    ],
  );

  supabase.SupabaseClient get _client => ref.read(clientProvider);

  supabase.Session? get _session => ref.read(sessionProvider);

  Future<void> sendOtp() async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.signInWithOtp(
        phone: "+91${state.phoneNumber}",
        channel: supabase.OtpChannel.sms,
      );
      state = state.copyWith(loading: false, otpSentAt: DateTime.now());
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> resendOTP() async {
    state = state.copyWith(loading: true);
    try {
      await _client.auth.resend(
        type: supabase.OtpType.sms,
        phone: "+91${state.phoneNumber}",
      );
      state = state.copyWith(loading: false, otpSentAt: DateTime.now());
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> loginWithEmail() async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.signInWithPassword(
        email: state.email,
        password: state.password,
      );
      ref.refresh(sessionProvider);
      await check();
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<bool> createAccount() async {
    try {
      state = state.copyWith(loading: true);
      final res = await _client.auth.signUp(
        email: state.email,
        password: state.password,
      );
      state = state.copyWith(loading: false);
      return res.user?.emailConfirmedAt != null;
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> verifyOtp(String code) async {
    try {
      state = state.copyWith(loading: true);
      if (_session == null) {
        await _client.auth.verifyOTP(
          token: code,
          type: supabase.OtpType.sms,
          phone: "+91${state.phoneNumber}",
        );
      } else {
        if (state.generatedOtp == code) {
          await _client.auth.updateUser(
            supabase.UserAttributes(
              phone: "91${state.phoneNumber}",
            ),
          );
        } else {
          throw "Invalid OTP";
        }
      }
      ref.refresh(sessionProvider);

      await check();
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loading: true);
    try {
      final GoogleSignInAccount? googleUser = await _google.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null &&
          googleAuth.accessToken != null &&
          googleAuth.idToken != null) {
        await _client.auth.signInWithIdToken(
          provider: supabase.OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
          // nonce: googleAuth.
        );
      }

      ref.refresh(sessionProvider);
      ref.read(cacheProvider).asData?.value.setBool(CacheKeys.guest, false);
      await check();
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      print(e);
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(loading: true);

    if (!kIsWeb) {
      ref.read(playerProvider).dispose();
      ref.invalidate(playerProvider);
      if (!await Purchases.isAnonymous) {
        await Purchases.logOut();
      }
      await _messaging.deleteToken();
      NotificationWriter.clearNotifications();
      ref.read(profileRepositoryProvider).updateDeviceDetails();
    }

   final cache = await  ref.read(cacheProvider.future);

   cache.remove('uid');

    await _client.auth.signOut();
    if (!kIsWeb) {
      try {
        await _google.signOut();
        print("Google Signout");
      } catch (e) {
        debugPrint("Google Signout Error: $e");
      }
    }

    ref.refresh(sessionProvider);
    state = state.copyWith(loading: false);
  }


    Future<void> deleteAccount() async {
    state = state.copyWith(loading: true);

    if (!kIsWeb) {
      ref.read(playerProvider).dispose();
      ref.invalidate(playerProvider);
      if (!await Purchases.isAnonymous) {
        await Purchases.logOut();
      }
      await _messaging.deleteToken();
      NotificationWriter.clearNotifications();
      ref.read(profileRepositoryProvider).delete();
    }

    ref.read(functionsRepositoryProvider).delete(_session!.user.id);

    await _client.auth.signOut();
    if (!kIsWeb) {
      try {
        await _google.signOut();
        print("Google Signout");
      } catch (e) {
        debugPrint("Google Signout Error: $e");
      }
    }

    ref.refresh(sessionProvider);
    state = state.copyWith(loading: false);
  }

  Future<void> check() async {
    final info = await ref.read(deviceInfoProvider.future);

    try {
      final profile = await ref.read(yourProfileProvider.future);

      if (profile.deviceId != info.key && profile.deviceId != null) {
        return Future.error('device-unmatched');
      } else {
        await update();
      }
    } catch (e) {
      if (e == "device-unmatched") {
        return Future.error(e);
      }
    }
  }

  Future<void> update([bool logout = false]) async {
    _messaging.unsubscribeFromTopic(Topics.guest);
    _messaging.subscribeToTopic(Topics.user);
    ref.read(cacheProvider).asData?.value.setBool(CacheKeys.guest, false);
    final info = await ref.read(deviceInfoProvider.future);
    final token = await _messaging.getToken();
    if (logout) {
      final profile = await ref.read(yourProfileProvider.future);
      if (profile.fcmToken != null) {
        ref
            .read(functionsRepositoryProvider)
            .logoutFromAnotherDevice(profile.fcmToken!);
      }
    }
    await ref.read(profileRepositoryProvider).updateDeviceDetails(
          deviceId: info.key,
          deviceName: info.value,
          fcmToken: token,
          channel: defaultTargetPlatform.name,
        );
    await ref.refresh(yourProfileProvider.future);
  }

  Future<void> skip() async {
    try {
      state = state.copyWith(loading: true);
      final info = await ref.read(deviceInfoProvider.future);
      final token = await _messaging.getToken();
      final guest = await ref.read(guestProvider.future);
      if (guest == null) {
        await ref.read(guestRepositoryProvider).writeGuest(
              Guest(
                id: 0,
                createdAt: DateTime.now(),
                channel: defaultTargetPlatform.name,
                deviceId: info.key,
                deviceName: info.value,
                fcmToken: token,
                expiryAt: DateTime.now().add(
                  Duration(
                      days: ref
                              .read(masterDataProvider)
                              .asData
                              ?.value
                              .freeTrailDays ??
                          0),
                ),
              ),
            );
        await ref.refresh(guestProvider.future);
      }
      final cache = await ref.read(cacheProvider.future);
      await cache.setBool(CacheKeys.guest, true);
      await ref.refresh(yourProfileProvider.future);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> changeEmail() async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.updateUser(
        supabase.UserAttributes(
          email: state.email,
        ),
      );
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> refresh() async {
    await _client.auth.refreshSession();
  }

  Future<void> forgotPasssword() async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.resetPasswordForEmail(
        state.email,
        redirectTo: "avahan://confirm",
      );
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }

  Future<void> updatePassword() async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.updateUser(
        supabase.UserAttributes(
          password: state.password,
        ),
      );
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> updatePhoneNumber() async {
    try {
      state = state.copyWith(loading: true);

      await _client.auth.updateUser(
        supabase.UserAttributes(
          phone: "91${state.phoneNumber}",
        ),
      );
      state = state.copyWith(loading: false, otpSentAt: DateTime.now());
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> verifyPhoneUpdate(
    String code,
  ) async {
    try {
      state = state.copyWith(loading: true);
      await _client.auth.verifyOTP(
        token: code,
        type: supabase.OtpType.phoneChange,
        phone: "+91${state.phoneNumber}",
      );
      ref.refresh(sessionProvider);
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(loading: true);
    try {
      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      if(credential.familyName != null || credential.givenName != null){
        ref.read(cacheProvider).asData?.value.setString('full_name', [credential.familyName, credential.givenName].where((e)=> e != null).join(' '));
      }
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const supabase.AuthException(
            'Could not find ID Token from generated credential.');
      }
      // print(credential.);
      await _client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      ref.refresh(sessionProvider);
      ref.read(cacheProvider).asData?.value.setBool(CacheKeys.guest, false);
      await check();
      state = state.copyWith(loading: false);
    } on Exception catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e.parse);
    }
  }
}

