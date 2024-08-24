// ignore_for_file: unused_result

import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/device_info_provider.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/topics.dart';
import 'package:avahan/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/features/profile/models/write_profile_state.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/extensions.dart';

part 'write_profile_notifier.g.dart';

@riverpod
class WriteProfile extends _$WriteProfile {
  @override
  WriteProfileState build(Profile? profile) {
    final user = ref.read(sessionProvider)!.user;
    if (profile?.city == null &&
        profile?.state == null &&
        profile?.country == null) {
      getCurrentLocation();
    }
    return WriteProfileState(
      loading: false,
      profile: profile ??
          Profile.empty(
            user.id,
            phoneNumber: user.phone?.crim,
            email: user.email,
            name: user.userMetadata?['full_name'] ??
                ref.read(cacheProvider).asData?.value.getString('full_name'),
            lang: ref.read(langProvider).name,
            expiryAt: DateTime.now().add(
              Duration(
                days:
                    ref.read(masterDataProvider).asData?.value.freeTrailDays ??
                        0,
              ),
            ),
          ),
    );
  }

  void getCurrentLocation() async {
    try {
      final location = await _repository.getCurrentLocation();
      state = state.copyWith(
        location: location,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  bool get emailEnabled => profile != null
      ? (profile?.email?.crim == null)
      : user.email?.crim == null;

  User get user => ref.read(sessionProvider)!.user;

  void nameChanged(String v) {
    state = state.copyWith(
      profile: state.profile.copyWith(name: v),
    );
  }

  void phoneNumberChanged(String v) {
    state = state.copyWith(
      profile: state.profile.copyWith(phoneNumber: "91$v"),
    );
  }

  void dateOfBirthChanged(DateTime? v) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        dateOfBirth: v,
        clearDateOfBirth: v == null,
      ),
    );
  }

  void genderChanged(Gender? v) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        gender: v ?? Gender.unknown,
      ),
    );
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  bool get continueToCreate => state.profile.name.isNotEmpty;

  Future<void> write() async {
    try {
      state = state.copyWith(loading: true);
      ref.read(cacheProvider).asData?.value.remove('full_name');
      var profile = state.profile;
      if (user.id == state.profile.uuid && this.profile == null) {
        final messaging = ref.read(messagingProvider);
        final fcmToken = await messaging.getToken().catchError((v) => null);
        profile = profile.copyWith(fcmToken: fcmToken);
        messaging.subscribeToTopic(profile.gender.name);
        if (!profile.premium && !profile.expired) {
          messaging.subscribeToTopic(Topics.freetrial);
        }
        if (profile.age != null) {
          messaging.subscribeToTopic(Utils.getRangeByAge(profile.age!));
        }
        if (profile.isoCode != null) {
          messaging.subscribeToTopic(profile.isoCode!);
        }
      }
      final info = ref.read(deviceInfoProvider).asData?.value;
      if (info != null) {
        profile = profile.copyWith(
          deviceId: info.key,
          deviceName: info.value,
          channel: defaultTargetPlatform.name,
        );
      }
      await _repository.writeProfile(profile);
      if (user.id == profile.uuid) {
        await ref.refresh(yourProfileProvider.future);
      }
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
