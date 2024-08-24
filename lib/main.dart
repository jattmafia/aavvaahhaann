import 'dart:async';
import 'dart:io';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/app_session.dart';
import 'package:avahan/core/models/play_session.dart';
import 'package:avahan/core/models/search_history_item.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_app_sessions_provider.dart';
import 'package:avahan/core/providers/cache_play_sessions_provider.dart';
// import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/cache_search_history_items_provider.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/core/providers/device_info_provider.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/core/topics.dart';
import 'package:avahan/features/notifications/notification_writer.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
// import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:avahan/app.dart';
import 'package:avahan/config.dart';
import 'package:avahan/core/models/app_notification.dart';
import 'package:avahan/firebase_options_dev.dart' as dev;
import 'package:avahan/firebase_options_prod.dart' as prod;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  if (message.notification != null) {
    final notification = AppNotification.fromMessage(message, false);
    try {
      await NotificationWriter.writeNotification(notification);
      print('Notification written');
    } catch (e) {
      print(e);
    }
    // await Supabase.initialize(
    //   url: Config.supabaseProjectUrl,
    //   anonKey: Config.supabaseAnonKey,
    // );
    // final container = ProviderContainer();
    // if (message.messageId != null) {
    //   try {
    //     int? uid;

    //     final cache = await container.read(cacheProvider.future);

    //     final id = cache.getInt('uid');

    //     if (id != null) {
    //       uid = id;
    //     } else {
    //       print('uid not found');
    //       try {
    //         final profile = await container.read(yourProfileProvider.future);
    //         uid = profile.id;
    //         cache.setInt('uid', uid);
    //       } catch (e) {
    //         debugPrint("$e");
    //       }
    //     }
    //     await container.read(notificationsRepositoryProvider).createSend(
    //           NotifyEvent(
    //             messageId: message.messageId!,
    //             uid: uid,
    //           ),
    //         );
    //   } catch (e) {
    //     debugPrint("$e");
    //   }
    // }
  }
}

void main() async {
  Config.setProd();
  run();
}

final initProvider = FutureProvider<bool>((ref) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: {
      Env.dev: defaultTargetPlatform == TargetPlatform.iOS
          ? prod.DefaultFirebaseOptions.currentPlatform
          : dev.DefaultFirebaseOptions.currentPlatform,
      Env.prod: prod.DefaultFirebaseOptions.currentPlatform
    }[Config.env]!,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  await Supabase.initialize(
    url: Config.supabaseProjectUrl,
    anonKey: Config.supabaseAnonKey,
  );

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationClickStartsActivity: true,
    androidResumeOnClick: true,
    androidShowNotificationBadge: true,
    androidStopForegroundOnPause: true,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TrackAdapter());
  Hive.registerAdapter(PlaySessionAdapter());
  Hive.registerAdapter(AppSessionAdapter());
  Hive.registerAdapter(AvahanDataTypeAdapter());
  Hive.registerAdapter(SearchHistoryItemAdapter());

  try {
    // await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(Config.androidPurchaseApiKey);
      // if (buildingForAmazon) {
      //   // use your preferred way to determine if this build is for Amazon store
      //   // checkout our MagicWeather sample for a suggestion
      //   configuration = AmazonConfiguration(<revenuecat_project_amazon_api_key>);
      // }
      await Purchases.configure(configuration);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(Config.iosPurchaseApiKey);
      await Purchases.configure(configuration);
    }
    // await Purchases.configure(configuration);
  } catch (e) {
    debugPrint("$e");
  }

  // Hive.registerAdapter(ArtistAdapter());
  // Hive.registerAdapter(ArtistTypeAdapter());
  // Hive.registerAdapter(MoodAdapter());
  // Hive.registerAdapter(MusicCategoryAdapter());
  // Hive.registerAdapter(PlaylistAdapter());
  // Hive.registerAdapter(UserPlaylistAdapter());
  // Hive.registerAdapter(CacheArtistAdapter());
  // Hive.registerAdapter(CachePlaylistAdapter());
  // Hive.registerAdapter(CacheUserPlaylistAdapter());
  // Hive.registerAdapter(CacheMusicCategoryAdapter());
  // Hive.registerAdapter(CacheMoodAdapter());
  // await Hive.openBox<CacheArtist>(DownloadKeys.artists);
  // await Hive.openBox<CachePlaylist>(DownloadKeys.playlists);
  // await Hive.openBox<CacheUserPlaylist>(DownloadKeys.userPlaylists);
  // await Hive.openBox<CacheMusicCategory>(DownloadKeys.categories);
  // await Hive.openBox<CacheMood>(DownloadKeys.moods);
  try {
    await ref.read(cacheProvider.future);
  } catch (e) {
    debugPrint("$e");
  }

  try {
    await ref.read(deviceInfoProvider.future);
  } catch (e) {
    debugPrint("$e");
  }
  try {
    await ref.read(masterDataProvider.future);
  } catch (e) {
    debugPrint("$e");
  }

  try {
    await ref.read(cacheTracksProvider.future);
  } catch (e) {
    debugPrint("$e");
  }

  try {
    await ref.read(cacheSearchHistoryItemsProvider.future);
  } catch (e) {
    debugPrint("$e");
  }
  try {
    await ref.read(cachePlaySessionsProvider.future);
  } catch (e) {
    debugPrint("$e");
  }

  try {
    await ref.read(cacheAppSessionsProvider.future);
  } catch (e) {
    debugPrint("$e");
  }

  if (!kIsWeb) {
    try {
      final messaging = ref.read(messagingProvider);

      await messaging.subscribeToTopic(Topics.all);

      messaging.subscribeToTopic(defaultTargetPlatform.name);
    } catch (e) {
      debugPrint("$e");
    }
    try {
      await ref.read(yourProfileProvider.future);
    } catch (e) {
      try {
        final messaging = ref.read(messagingProvider);
        await messaging.subscribeToTopic(Topics.guest);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }
  return true;
});

void run() async {
  runZonedGuarded<Future<void>>(
    () async {
      final ref = ProviderContainer();
      runApp(
        UncontrolledProviderScope(
          container: ref,
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxHeight == 0.0 && constraints.maxWidth == 0.0) {
              return Container();
            } else {
              return FutureBuilder(
                future: ref.read(initProvider.future),
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? const MyApp()
                      : Container(
                          color: context.theme.colorScheme.background,
                          child: SafeArea(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SvgPicture.asset(
                                  Assets.logo,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                          ),
                        );
                },
              );
            }
          }),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}
