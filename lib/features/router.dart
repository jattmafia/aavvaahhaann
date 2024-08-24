import 'package:avahan/admin/dashboard/widgets/user_session_list_view.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/features/artists/artist_root_page.dart';
import 'package:avahan/features/auth/change_email_page.dart';
import 'package:avahan/features/auth/change_phone_page.dart';
import 'package:avahan/features/auth/create_account_page.dart';
import 'package:avahan/features/auth/forgot_password_page.dart';
import 'package:avahan/features/auth/login_page.dart';
import 'package:avahan/features/auth/phone_login_page.dart';
import 'package:avahan/features/auth/reset_password_page.dart';
import 'package:avahan/features/cache/cache_tracks_page.dart';
import 'package:avahan/features/categories/category_page.dart';
import 'package:avahan/features/categories/category_root_page.dart';
import 'package:avahan/features/components/web_page.dart';
import 'package:avahan/features/library/liked_musics_page.dart';
import 'package:avahan/features/moods/mood_page.dart';
import 'package:avahan/features/moods/mood_root_page.dart';
import 'package:avahan/features/notifications/notifications_page.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/features/playlists/playlist_root_page.dart';
import 'package:avahan/features/profile/settings_page.dart';
import 'package:avahan/features/tracks/track_page.dart';
import 'package:avahan/features/tracks/track_root_page.dart';
import 'package:avahan/features/user_playlists/add_to_playlist_page.dart';
import 'package:avahan/features/user_playlists/create_playlist_page.dart';
import 'package:avahan/features/user_playlists/user_playlist_page.dart';
import 'package:flutter/material.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/features/auth/onboard_page.dart';
import 'package:avahan/features/profile/profile_details_page.dart';
import 'package:avahan/features/profile/write_profile_page.dart';
import 'package:avahan/features/root.dart';

class AppRouter {
  static Route<dynamic>? on(RouteSettings settings, [bool stacked = false]) {
    return MaterialPageRoute(
      builder: (context) {
        return switch (settings.name) {
          OnboardPage.route => const OnboardPage(),
          CreateAccountPage.route => const CreateAccountPage(),
          ChangeEmailPage.route => const ChangeEmailPage(),
          ResetPasswordPage.route => const ResetPasswordPage(),
          ChangePhonePage.route => const ChangePhonePage(),
          SettingsPage.route => const SettingsPage(),
          ForgotPasswordPage.route => const ForgotPasswordPage(),
          // VerifyPage.route => const VerifyPage(),
          WriteProfilePage.route => WriteProfilePage(
              profile: settings.arguments as Profile?,
            ),
          LoginPage.route => const LoginPage(),
          Root.route => const Root(),
          ProfileDetailsPage.route => const ProfileDetailsPage(),
          CategoryPage.route => CategoryPage(
              category: settings.arguments as MusicCategory,
            ),
          MoodPage.route => MoodPage(
              mood: settings.arguments as Mood,
            ),
          PlaylistPage.route => PlaylistPage(
              playlist: settings.arguments as Playlist,
            ),
          AddToPlaylistPage.route => AddToPlaylistPage(
              track: settings.arguments as Track,
            ),
          TrackPage.route => const TrackPage(),
          CreatePlaylistPage.route => CreatePlaylistPage(
              suggestedName: settings.arguments as String,
            ),
          CacheTracksPage.route => const CacheTracksPage(),
          PhoneLoginPage.route => const PhoneLoginPage(),
          LikedMusicsPage.route => const LikedMusicsPage(),
          NotificationsPage.route => const NotificationsPage(),
          UserPlaylistPage.route => UserPlaylistPage(
              playlist: settings.arguments as UserPlaylist,
            ),
          CategoryRootPage.route =>
            CategoryRootPage(ids: settings.arguments as List<int>),
          ArtistRootPage.route =>
            ArtistRootPage(ids: settings.arguments as List<int>),
          PlayListRootPage.route =>
            PlayListRootPage(ids: settings.arguments as List<int>),
          MoodRootPage.route =>
            MoodRootPage(ids: settings.arguments as List<int>),
          TrackRootPage.route =>
            TrackRootPage(ids: settings.arguments as List<int>),
          WebPage.route => WebPage(
              entry: settings.arguments as MapEntry<String, String>,
            ),

          
          _ => const Scaffold(),
        };
      },
    );
  }
}
