// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously, unused_result
import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/features/artists/artist_page.dart';
import 'package:avahan/features/artists/artist_root_page.dart';
import 'package:avahan/features/cache/cache_tracks_page.dart';
import 'package:avahan/features/categories/category_page.dart';
import 'package:avahan/features/categories/category_root_page.dart';
import 'package:avahan/features/components/internet_tile.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/features/home/home_page.dart';
import 'package:avahan/features/home/providers/last_sessions_provider.dart';
import 'package:avahan/features/library/library_page.dart';
import 'package:avahan/features/library/liked_musics_page.dart';
import 'package:avahan/features/moods/mood_page.dart';
import 'package:avahan/features/moods/mood_root_page.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/features/playlists/playlist_root_page.dart';
import 'package:avahan/features/search/search_page.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/subscriptions/providers/subscription_notifier.dart';
import 'package:avahan/features/tracks/track_root_page.dart';
import 'package:avahan/features/tracks/widgets/player_tile.dart';
import 'package:avahan/features/user_playlists/user_playlist_page.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/nav_keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/profile/profile_menu_page.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/extensions.dart';

class MenuItem {
  final Widget icon;
  final String label;
  final VoidCallback? callback;
  // final int? flex;
  // final int? sideFlex;
  // final EdgeInsets? largePadding;
  // final EdgeInsets? largeSidePadding;
  // final EdgeInsets? largeMargin;
  // final bool side;

  MenuItem({
    required this.icon,
    required this.label,
    this.callback,
    // this.flex,
    // this.sideFlex,
    // this.largeMargin,
    // this.largePadding,
    // this.largeSidePadding,
    // this.side = false,
  });
}

class Dashboard extends HookConsumerWidget {
  Dashboard({super.key});

  final newKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(yourProfileProvider).value!;
    final labels = context.labels;

    print(DateTime.now().toUtc().toIso8601String());

    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);

    final premium = ref.watch(premiumProvider).asData?.value ?? false;



    final menuItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: labels.home,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: labels.search,
      ),
      if (!profile.isGuest)
        BottomNavigationBarItem(
          icon: const Icon(Icons.library_music_outlined),
          label: labels.yourLibrary,
        ),
      if (!premium)
         BottomNavigationBarItem(
          icon: Image.asset(Assets.premium,height: 24,width: 24,),
          label: "Premium",
        ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_circle_rounded),
        label: labels.profile,
      ),
    ];

    return PopScope(
      canPop: state.data == null,
      onPopInvoked: (v) {
        if (state.data != null) {
          notifier.setData(null);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Navigator(
              // key: ref.read(navProvider),
              pages: [
                MaterialPage(
                    child: [
                  const HomePage(),
                  const SearchPage(),
                  if (!profile.isGuest) const LibraryPage(),
                  if (!premium) const Scaffold(),
                  const ProfileMenuPage(),
                ][state.index]),
                if(state.data is MapEntry)
                  (){
                    final entry = state.data as MapEntry;
                    return MaterialPage(
                      child: Builder(
                        builder: (context) {
                          return switch (entry.key) {
                            AvahanDataType.artist =>
                              ArtistRootPage(ids: entry.value),
                            AvahanDataType.category =>
                              CategoryRootPage(ids: entry.value),
                            AvahanDataType.mood =>
                              MoodRootPage(ids: entry.value),
                            AvahanDataType.playlist =>
                              PlayListRootPage(ids: entry.value),
                            AvahanDataType.track =>
                              TrackRootPage(ids: entry.value),
                            _ => const Scaffold(),
                          };
                        },
                      ),
                    );
                  }(), 
                if (state.data is MusicCategory)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child:
                          CategoryPage(category: state.data as MusicCategory),
                    ),
                  ),
                if (state.data is Mood)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: MoodPage(mood: state.data as Mood),
                    ),
                  ),
                if (state.data is Playlist)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: PlaylistPage(playlist: state.data as Playlist),
                    ),
                  ),
                if (state.data is Artist)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: ArtistPage(artist: state.data as Artist),
                    ),
                  ),
                if (state.data is UserPlaylist)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: UserPlaylistPage(
                          playlist: state.data as UserPlaylist),
                    ),
                  ),
                if (state.data == NavKeys.downloads)
                  const MaterialPage(child: CacheTracksPage()),
                if (state.data == NavKeys.likedMusic)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: const LikedMusicsPage(),
                    ),
                  ),
                if (state.data is MapEntry<AvahanDataType, List<int>>)
                  MaterialPage(
                    child: PopScope(
                      onPopInvoked: (v) {
                        if (v) {
                          ref.refresh(lastSessionsProvider);
                        }
                      },
                      child: Builder(
                        builder: (context) {
                          final entry =
                              state.data as MapEntry<AvahanDataType, List<int>>;
                          return switch (entry.key) {
                            AvahanDataType.artist =>
                              ArtistRootPage(ids: entry.value),
                            AvahanDataType.category =>
                              CategoryRootPage(ids: entry.value),
                            AvahanDataType.mood =>
                              MoodRootPage(ids: entry.value),
                            AvahanDataType.playlist =>
                              PlayListRootPage(ids: entry.value),
                            AvahanDataType.track =>
                              TrackRootPage(ids: entry.value),
                            _ => const Scaffold(),
                          };
                        },
                      ),
                    ),
                  ),
              ],
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }
                if (state.data != null) {
                  notifier.setData(null);
                }
                return true;
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  const PlayerTile(),
                  const InternetTile(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.scheme.surface,
                          context.scheme.surface.withOpacity(0.5),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: BottomNavigationBar(
                      elevation: 0,
                      unselectedItemColor: context.scheme.onSurface,
                      backgroundColor: Colors.transparent,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: state.index,
                      onTap: (v) async {
                        if (v == 3 && !premium) {
                          ref.authorized(ref, () async {
                            try {
                              await ref.read(subscriptionProvider).init();
                              notifier.setIndex(0);
                            } catch (e) {
                              context.error(e);
                            }
                          });
                        } else {
                          notifier.setData(null);

                          notifier.setIndex(v);
                        }
                      },
                      items: menuItems,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
