// ignore_for_file: unused_result

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/artists/widgets/artist_tile.dart';
import 'package:avahan/features/categories/providers/categories_provider.dart';
import 'package:avahan/features/categories/widgets/category_tile.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/banner_view.dart';
import 'package:avahan/features/components/custom_grid_view.dart';
import 'package:avahan/features/components/lang_button.dart';
import 'package:avahan/features/dashboard/widgets/notification_button.dart';
import 'package:avahan/features/home/providers/last_sessions_provider.dart';
import 'package:avahan/features/home/widgets/artists_view.dart';
import 'package:avahan/features/home/widgets/categories_view.dart';
import 'package:avahan/features/home/widgets/moods_view.dart';
import 'package:avahan/features/home/widgets/playlists_view.dart';
import 'package:avahan/features/library/liked_musics_page.dart';
import 'package:avahan/features/moods/providers/moods_provider.dart';
import 'package:avahan/features/moods/widgets/mood_tile.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/features/playlists/widgets/playlist_tile.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/tracks/providers/track_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/nav_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final lang = ref.lang;
    

    useEffect(() {
      if (ref.read(lastSessionsProvider).hasValue) {
        ref.refresh(lastSessionsProvider);
      }
    }, []);

    final profile = ref.watch(yourProfileProvider).value!;

    print(profile.dateOfBirth);
    print(profile.state);
    print(profile.city);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
            "${labels.namaskar}${!profile.isGuest ? " ${profile.name.split(' ').first}" : ""}"),
        actions: [
          const LangButton(),
          IconButton(
            icon: const Icon(Icons.favorite_outline_rounded),
            onPressed: () {
              ref.authorized(ref, () {
                ref.push(LikedMusicsPage.route,
                    extra: NavKeys.likedMusic, ref: ref);
              });
            },
          ),
          const NotificationButton()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(categoriesProvider);
          ref.refresh(artistsProvider);
          ref.refresh(moodsProvider);
          ref.refresh(playlistsProvider);
          ref.refresh(lastSessionsProvider);
        },
        child: ListView(
          children: [
            const BannerView(),
            AsyncWidget(
              value: ref.watch(lastSessionsProvider),
              data: (data) {
                if (data.isEmpty) {
                  return const SizedBox();
                }
                final categories =
                    ref.watch(categoriesProvider).asData?.value ?? [];
                final playlists =
                    ref.watch(playlistsProvider).asData?.value ?? [];
                final artists = ref.watch(artistsProvider).asData?.value ?? [];
                final moods = ref.watch(moodsProvider).asData?.value ?? [];
                final trackIds = data
                    .where((element) => element.key == AvahanDataType.track)
                    .toList();

                final tracks = [
                  for (final e in trackIds)
                    ref.watch(trackProvider(e.value)).asData?.value
                ];

                final filtered = data.where((element) {
                  if (element.key == AvahanDataType.category) {
                    return categories.any((e) => e.id == element.value);
                  }
                  if (element.key == AvahanDataType.playlist) {
                    return playlists.any((e) => e.id == element.value);
                  }
                  if (element.key == AvahanDataType.artist) {
                    return artists.any((e) => e.id == element.value);
                  }
                  if (element.key == AvahanDataType.mood) {
                    return moods.any((e) => e.id == element.value);
                  }
                  if (element.key == AvahanDataType.track) {
                    return tracks.any((e) => e?.id == element.value);
                  }
                  return false;
                });
                return filtered.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.all(16.0).copyWith(bottom: 0),
                            child: Text(
                              labels.recentPlaylist,
                              style: context.style.titleMedium,
                            ),
                          ),
                          CustomGridView(
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.all(12).copyWith(top: 4),
                              children: filtered.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    color: context.scheme.surfaceTint
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(6),
                                    child: switch (e.key) {
                                      AvahanDataType.category => () {
                                          final category = categories
                                              .where((element) =>
                                                  element.id == e.value)
                                              .firstOrNull;
                                          if (category != null) {
                                            return CategoryTile(
                                              e: category,
                                              dense: true,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }(),
                                      AvahanDataType.playlist => () {
                                          final playlist = playlists
                                              .where((element) =>
                                                  element.id == e.value)
                                              .firstOrNull;
                                          if (playlist != null) {
                                            return PlaylistTile(e: playlist);
                                          } else {
                                            return const SizedBox();
                                          }
                                        }(),
                                      AvahanDataType.artist => () {
                                          final artist = artists
                                              .where((element) =>
                                                  element.id == e.value)
                                              .firstOrNull;
                                          if (artist != null) {
                                            return ArtistTile(
                                              e: artist,
                                              dense: true,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }(),
                                      AvahanDataType.mood => () {
                                          final mood = moods
                                              .where((element) =>
                                                  element.id == e.value)
                                              .firstOrNull;
                                          if (mood != null) {
                                            return MoodTile(
                                                e: mood, dense: true);
                                          } else {
                                            return const SizedBox();
                                          }
                                        }(),
                                      AvahanDataType.track => () {
                                          return ref
                                              .watch(trackProvider(e.value))
                                              .when(
                                            data: (track) {
                                              return TrackTile(
                                                e: track,
                                                dense: true,
                                              );
                                            },
                                            error: (e, s) {
                                              return const SizedBox();
                                            },
                                            loading: () {
                                              return const SizedBox();
                                            },
                                          );
                                        }(),
                                      _ => const SizedBox(),
                                    },
                                  ),
                                );
                              }).toList()),
                        ],
                      )
                    : const SizedBox.shrink();
              },
            ),
            const CategoriesView(),
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
              child: Text(
                labels.moods,
                style: context.style.titleMedium,
              ),
            ),
            const MoodsView(),
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
              child: Text(
                labels.playlists,
                style: context.style.titleMedium,
              ),
            ),
            const PlaylistsView(),
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
              child: Text(
                labels.artists,
                style: context.style.titleMedium,
              ),
            ),
            const ArtistsView(),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}





