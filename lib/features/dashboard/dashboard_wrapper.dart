// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/device_info_provider.dart';
import 'package:avahan/core/providers/links_provider.dart';
import 'package:avahan/core/repositories/guest_repository.dart';
import 'package:avahan/features/artists/artist_page.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/features/categories/category_page.dart';
import 'package:avahan/features/categories/providers/categories_provider.dart';
import 'package:avahan/features/moods/mood_page.dart';
import 'package:avahan/features/moods/providers/moods_provider.dart';
import 'package:avahan/features/notifications/providers/notifications_provider.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/features/profile/enter_remaining_details_page.dart';
import 'package:avahan/features/profile/providers/welcome_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/profile/widgets/welcome_dialog.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/subscriptions/track_access_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:avahan/features/tracks/track_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/dashboard/widgets/message_dialog.dart';
import 'package:avahan/features/dashboard/widgets/update_dialog.dart';
import 'package:avahan/features/notifications/notification_writer.dart';
import 'package:avahan/utils/extensions.dart';

import '../../config.dart';
import '../../core/models/app_notification.dart';
import '../../core/providers/master_data_provider.dart';
import '../../core/providers/messaging_provider.dart';

class DashboardWrapper extends HookConsumerWidget {
  const DashboardWrapper({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final seen = useRef(<String>{});
    final labels = context.labels;

    final messaging = ref.read(messagingProvider);

    void checkUpdate() async {
      ref.read(masterDataProvider.future).then(
        (value) async {
          final updateAvailable =
              defaultTargetPlatform == TargetPlatform.android
                  ? value.version > Config.version
                  : value.versionIos > Config.versionIos;
          if (updateAvailable) {
            await Future.delayed(
              Duration.zero,
              () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      (defaultTargetPlatform == TargetPlatform.android
                              ? value.force
                              : value.forceIos)
                          ? const ForceVersionUpdateDialog()
                          : const VersionUpdateDialog(),
                );
              },
            );
          }
        },
      ).catchError((e) {
        print(e);
      });
    }

    void handleLink(PendingDynamicLinkData link) async {
      final data = link.link.queryParameters;
      final id = data['id'];
      final type = data['type'];

      if (id != null && type != null) {
        if (type == AvahanDataType.category.name) {
          final category = await ref.read(categoriesProvider.future).then(
              (value) => value
                  .where((element) => element.id == int.parse(id))
                  .firstOrNull);
          if (category != null) {
            context.push(CategoryPage.route, extra: category, ref: ref);
          }
        } else if (type == AvahanDataType.playlist.name) {
          final playlist = await ref.read(playlistsProvider.future).then(
              (value) => value
                  .where((element) => element.id == int.parse(id))
                  .firstOrNull);
          if (playlist != null) {
            context.push(PlaylistPage.route, extra: playlist, ref: ref);
          }
        } else if (type == AvahanDataType.artist.name) {
          final artist = await ref.read(artistsProvider.future).then((value) =>
              value
                  .where((element) => element.id == int.parse(id))
                  .firstOrNull);
          if (artist != null) {
            context.push(ArtistPage.route, extra: artist, ref: ref);
          }
        } else if (type == AvahanDataType.mood.name) {
          final mood = await ref.read(moodsProvider.future).then((value) =>
              value
                  .where((element) => element.id == int.parse(id))
                  .firstOrNull);
          if (mood != null) {
            context.push(MoodPage.route, extra: mood, ref: ref);
          }
        } else if (type == AvahanDataType.track.name) {
          final trackId = int.tryParse(id);
          if (trackId != null) {
            final access = ref.read(trackAccessProvider(trackId));
            if (access) {
              final track = await ref
                  .read(tracksProvider(ids: [int.parse(id)]).future)
                  .then(
                    (value) => value.firstOrNull,
                  );
              if (track != null) {
                ref.read(playNotifierProvider.notifier).startPlaySession(
                      PlayGroup(
                        data: null,
                        tracks: [track],
                        start: track,
                      ),
                    );
                context.push(TrackPage.route);
              }
            } else {
              context.showPremiumSnackbar(ref);
            }
          }
        }
      }
    }

    Future<void> logout() async {
      await ref.read(authNotifierProvider.notifier).logout();
      context.go();
    }

    Future<void> checkDevice() async {
      final value = await ref.read(yourProfileProvider.future);
      final info = await ref.read(deviceInfoProvider.future);
      if (value.deviceId != info.key) {
        await logout();
      }
    }

    void getInitialMessage() async {
      final messaging = ref.read(messagingProvider);
      final message = await messaging.getInitialMessage();
      if (message != null) {
        final notification = AppNotification.fromMessage(message, true);
        context.handleRoute(notification, ref);
      }
    }

    void getInitialLink() async {
      final value = await ref.read(linksProvider).getInitialLink();
      if (value != null) {
        handleLink(value);
      }
    }

    useOnAppLifecycleStateChange((previous, current) {
      final playerNotifier = ref.read(playNotifierProvider.notifier);
      if (previous == AppLifecycleState.resumed &&
          [
            AppLifecycleState.paused,
            AppLifecycleState.detached,
            AppLifecycleState.hidden,
            AppLifecycleState.inactive
          ].contains(current)) {
        playerNotifier.syncSessions();
        // checkDevice();
      } else if (current == AppLifecycleState.resumed &&
          [
            AppLifecycleState.paused,
            AppLifecycleState.detached,
            AppLifecycleState.hidden,
            AppLifecycleState.inactive
          ].contains(previous)) {
        checkDevice();
        playerNotifier.syncSessions();
        if (ref.exists(notificationsProvider)) {
          print('refreshing notifications');
          ref.refresh(notificationsProvider);
        }
      }
    });

    void checkNotificationSettings() async {
      NotificationSettings value = await messaging.getNotificationSettings();
      if ([AuthorizationStatus.denied, AuthorizationStatus.notDetermined]
          .contains(value.authorizationStatus)) {
        value = await messaging.requestPermission();
      }
      if (value.authorizationStatus == AuthorizationStatus.denied) {
        showAdaptiveDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text(
              labels.notificationPermissionDenied,
            ),
            content: Text(
              labels.pleaseGoToSettingsAndEnable,
            ),
            actions: [
              if (defaultTargetPlatform == TargetPlatform.android) ...[
                TextButton(
                  onPressed: () async {
                    AndroidIntent intent = const AndroidIntent(
                      action: 'action_application_details_settings',
                      data:
                          'package:com.', // replace com.example.app with your applicationId
                    );
                    await intent.launch();
                    Navigator.pop(context);
                  },
                  child: Text(labels.settings),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(labels.skip),
                ),
              ],
              if (defaultTargetPlatform != TargetPlatform.android) ...[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(labels.ok),
                ),
              ],
            ],
          ),
        );
      }
    }

    void welcome() {
      showDialog(context: context, builder: (context) => const WelcomeDialog());
    }

    useEffect(() {
      if (ref.read(welcomeProvider)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          welcome();
        });
      }
      final profile = ref.read(yourProfileProvider).value!;

      checkNotificationSettings();
      final tokenSubscription = messaging.onTokenRefresh.listen(
        (event) {
          if (profile.isGuest) {
            ref.read(guestRepositoryProvider).updateFcmToken(profile.id, event);
          } else {
            ref.read(profileRepositoryProvider).updateFcmToken(event);
          }
        },
      );
      if (!profile.isGuest) {
        checkDevice();
      }
      getInitialMessage();
      getInitialLink();
      if (!profile.isGuest) {
        ref.read(premiumProvider);
      }
      checkUpdate();
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        ref.refresh(notificationsProvider);
        final notification = AppNotification.fromMessage(event, true);
        context.handleRoute(notification, ref);
      });
      final messageSubscription =
          FirebaseMessaging.onMessage.listen((event) async {
        if (event.notification != null) {
          final notification = AppNotification.fromMessage(event, false);
          NotificationWriter.writeNotification(notification).whenComplete(() {
            ref.refresh(notificationsProvider);
          });
          final value = await showAdaptiveDialog(
            context: context,
            builder: (context) => MessageDialog(
              notification: notification,
            ),
          );
          if (value == true) {
            context.handleRoute(notification, ref);
          }
        } else {
          if (event.data['type'] == "logout") {
            logout();
          }
        }
      });
      final linkSubscription = ref.read(linksProvider).onLink.listen((event) {
        handleLink(event);
      });
      final cache = ref.read(cacheProvider).value!;
      if ((profile.city == null ||
              profile.state == null ||
              profile.dateOfBirth == null) &&
          (cache.infoAskedAt != null &&
              cache.infoAskedAt!.isBefore(
                  DateTime.now().subtract(const Duration(days: 7))))) {
        cache.setInfoAskedAt(DateTime.now());
        Future.delayed(const Duration(microseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => const EnterRemainingDetailsPage(),
            ),
          );
        });
      } else if (cache.infoAskedAt == null) {
        cache.setInfoAskedAt(DateTime.now());
      }
      return () {
        tokenSubscription?.cancel();
        messageSubscription.cancel();
        linkSubscription.cancel();
      };
    }, []);
    return child;
  }
}
