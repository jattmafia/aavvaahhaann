import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/core/repositories/user_playlist_repository.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/artists/widgets/artist_tile.dart';
import 'package:avahan/features/cache/cache_tracks_page.dart';
import 'package:avahan/features/categories/providers/categories_provider.dart';
import 'package:avahan/features/categories/widgets/category_tile.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/features/library/liked_musics_page.dart';
import 'package:avahan/features/library/providers/library_items_provider.dart';
import 'package:avahan/features/moods/providers/moods_provider.dart';
import 'package:avahan/features/moods/widgets/mood_tile.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/features/playlists/widgets/playlist_tile.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/tracks/providers/track_provider.dart';
import 'package:avahan/features/user_playlists/providers/user_playlists_provider.dart';
import 'package:avahan/features/user_playlists/user_playlist_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/nav_keys.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final items = ref.watch(libraryItemsProvider).asData?.value ?? [];
    final list = items
        .where((element) =>
            element.type != LibraryItemType.track &&
            element.type != LibraryItemType.unknown)
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final playlists = ref.watch(playlistsProvider).asData?.value ?? [];
    final artists = ref.watch(artistsProvider).asData?.value ?? [];
    final moods = ref.watch(moodsProvider).asData?.value ?? [];
    final categories = ref.watch(categoriesProvider).asData?.value ?? [];
    final libraryTracks =
        items.where((element) => element.type == LibraryItemType.track);

    final userPlaylists = ref.watch(userPlaylistsProvider).asData?.value ?? [];
    final premium = ref.read(premiumProvider).asData?.value ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.yourLibrary),
        leading: BackButton(
          onPressed: () {
            ref.read(dashboardNotifierProvider.notifier).setIndex(0);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          ValueListenableBuilder(
            valueListenable: ref.read(cacheTracksProvider).value!.listenable(),
            builder: (context, Box<Track> box, child) {
              return ListTile(
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: context.scheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(
                      Icons.download_done_rounded,
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                onTap: () {
                  ref.push(CacheTracksPage.route,
                      extra: NavKeys.downloads, ref: ref);
                },
                title: Text(
                  labels.downloads,
                ),
                subtitle: Text(
                  labels.songs(box.values.length),
                ),
              );
            },
          ),
          ListTile(
            leading: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: context.scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6)),
                child: Icon(
                  Icons.favorite,
                  color: context.scheme.onPrimaryContainer,
                ),
              ),
            ),
            onTap: () {
              ref.push(LikedMusicsPage.route,
                  extra: NavKeys.likedMusic, ref: ref);
            },
            title: Text(
              labels.likedMusic,
            ),
            subtitle: Text(labels.songs(libraryTracks.length)),
          ),
          ...userPlaylists.map(
            (e) => ListTile(
              onTap: () {
                if (premium) {
                  context.push(UserPlaylistPage.route, extra: e, ref: ref);
                } else {
                  context.showPremiumSnackbar(ref);
                }
              },
              leading: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: e.tracks.isNotEmpty
                      ? AsyncWidget(
                          value: ref.watch(trackProvider(e.tracks.first)),
                          data: (track) {
                            return CachedNetworkImage(
                              imageUrl: track.icon(ref.lang),
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Container(
                          color: context.scheme.surfaceTint.withOpacity(0.05),
                          child: const Center(
                            child: Icon(
                              Icons.audiotrack,
                            ),
                          ),
                        ),
                ),
              ),
              title: Text(e.name),
              subtitle: Text(
                labels.songs(e.tracks.length),
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (premium) {
                    await ref
                        .read(userPlaylistRepositoryProvider)
                        .deleteUserPlaylist(e);
                    ref.refresh(userPlaylistsProvider);
                  } else {
                    context.showPremiumSnackbar(ref);
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'delete-playlist',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete_outline_rounded),
                          SizedBox(width: 8),
                          Text("Delete playlist"),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
          ...list.map(
            (e) {
              return switch (e.type) {
                LibraryItemType.category => () {
                    final category = categories
                        .where((element) => element.id == e.itemId)
                        .firstOrNull;
                    if (category != null) {
                      return CategoryTile(e: category);
                    } else {
                      return const SizedBox();
                    }
                  }(),
                LibraryItemType.playlist => () {
                    final playlist = playlists
                        .where((element) => element.id == e.itemId)
                        .firstOrNull;
                    if (playlist != null) {
                      return PlaylistTile(e: playlist);
                    } else {
                      return const SizedBox();
                    }
                  }(),
                LibraryItemType.artist => () {
                    final artist = artists
                        .where((element) => element.id == e.itemId)
                        .firstOrNull;
                    if (artist != null) {
                      return ArtistTile(e: artist);
                    } else {
                      return const SizedBox();
                    }
                  }(),
                LibraryItemType.mood => () {
                    final mood = moods
                        .where((element) => element.id == e.itemId)
                        .firstOrNull;
                    if (mood != null) {
                      return MoodTile(e: mood);
                    } else {
                      return const SizedBox();
                    }
                  }(),
                _ => const SizedBox(),
              };
            },
          ),
        ],
      ),
    );
  }
}
