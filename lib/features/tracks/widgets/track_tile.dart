// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_manager_provider.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:avahan/core/providers/sharer_provider.dart';
import 'package:avahan/core/repositories/library_item_repository.dart';
import 'package:avahan/features/library/providers/library_items_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/subscriptions/providers/subscription_notifier.dart';
import 'package:avahan/features/subscriptions/track_access_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/track_page.dart';
import 'package:avahan/features/user_playlists/add_to_playlist_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.e,
    this.onTap,
    this.onTapExtra,
    this.dense = false,
    this.removeFromPlaylist,
  });

  final Track e;

  final VoidCallback? onTap;

  final VoidCallback? onTapExtra;

  final bool dense;
  final VoidCallback? removeFromPlaylist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langProvider);
    final labels = context.labels;
    final premium = ref.read(premiumProvider).asData?.value ?? false;
    final access = ref.watch(trackAccessProvider(e.id));

    final library = ref.watch(libraryItemsProvider).asData?.value ?? [];

    final libraryItem = library
        .where((element) =>
            element.itemId == e.id && element.type == LibraryItemType.track)
        .firstOrNull;

    final isInLibrary = libraryItem != null;

    return Material(
      color: Colors.transparent,
      child: ValueListenableBuilder(
          valueListenable: ref.watch(cacheTracksProvider).value!.listenable(),
          builder: (context, Box<Track> box, child) {
            final cacheTrack = box.get('track_${e.id}');

            return StreamBuilder<int?>(
                stream: ref.watch(playerProvider).currentIndexStream,
                builder: (context, snapshot) {
                  final tracks =
                      ref.watch(playNotifierProvider).session?.tracks ?? [];
                  final index =
                      tracks.indexWhere((element) => element.id == e.id);
                  final playing = snapshot.data == index;
                  return ListTile(
                    selected: playing,
                    dense: dense,
                    contentPadding: dense
                        ? const EdgeInsets.symmetric(horizontal: 8)
                        : null,
                    onTap: access
                        ? onTap ??
                            () {
                              onTapExtra?.call();
                              ref
                                  .read(playNotifierProvider.notifier)
                                  .startPlaySession(
                                    PlayGroup(
                                      data: e,
                                      tracks: [e],
                                      start: e,
                                    ),
                                  );
                              ref.push(TrackPage.route);
                            }
                        : () {
                            ref.authorized(ref, () {
                              context.showPremiumSnackbar(ref);
                            });
                          },
                    leading: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkImage(
                          imageUrl: e.icon(lang),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      e.name(lang),
                      maxLines: dense ? 1 : null,
                    ),
                    subtitle: Row(
                      children: [
                        Flexible(
                          child: Text(
                            e.artistsLabel(ref, lang),
                            maxLines: dense ? 1 : null,
                          ),
                        ),
                        if (cacheTrack != null && !dense) ...[
                          const SizedBox(width: 8),
                          StreamBuilder(
                            stream: ref
                                .read(cacheManagerProvider)
                                .getFileStream(e.url, withProgress: true),
                            builder: (context, snapshot) {
                              if (snapshot.data is DownloadProgress) {
                                final progress =
                                    snapshot.data as DownloadProgress;
                                return SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    strokeCap: StrokeCap.round,
                                    value: progress.progress ?? 0,
                                    color: Colors.orange,
                                  ),
                                );
                              } else if (snapshot.data is FileInfo) {
                                return const Icon(
                                  Icons.download_done,
                                  color: Colors.green,
                                  size: 16,
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                    trailing: !dense
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!access)
                                const Icon(
                                  Icons.lock_rounded,
                                  size: 16,
                                ),
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) async {
                                  ref.authorized(ref, () async {
                                    if (value == 'add_to_playlist') {
                                      if (premium) {
                                        ref.push(AddToPlaylistPage.route,
                                            extra: e);
                                      } else {
                                        context.showPremiumSnackbar(ref);
                                      }
                                    } else if (value ==
                                        "remove_from_playlist") {
                                      removeFromPlaylist?.call();
                                    } else if (value == 'download') {
                                      if (premium) {
                                        ref
                                            .read(cacheTracksProvider)
                                            .value
                                            ?.put('track_${e.id}', e);
                                      } else {
                                        context.showPremiumSnackbar(ref);
                                      }
                                      // ref.push(CacheTracksPage.route);
                                    } else if (value == 'like') {
                                      final repository = ref
                                          .read(libraryItemRepositoryProvider);
                                      if (isInLibrary) {
                                        await repository
                                            .deleteLibraryItem(libraryItem);
                                        context.message(
                                            labels.removedFromLikedMusic);
                                      }  else {
                                        await repository.writeLibraryItem(
                                          LibraryItem(
                                            id: 0,
                                            createdAt: DateTime.now(),
                                            createdBy: ref
                                                .read(yourProfileProvider)
                                                .value!
                                                .id,
                                            type: LibraryItemType.track,
                                            itemId: e.id,
                                          ),
                                        );
                                        context
                                            .message(labels.addedToLikedMusic);
                                      }
                                      ref.refresh(libraryItemsProvider);
                                    } else if (value == 'share') {
                                      ref.read(shareProvider).shareTrack(e);
                                    }
                                  });
                                },
                                itemBuilder: (context) {
                                  return [
                                    if (removeFromPlaylist == null)
                                      PopupMenuItem(
                                        value: 'add_to_playlist',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.playlist_add_rounded),
                                            const SizedBox(width: 8),
                                            Text(labels.addToPlaylist),
                                          ],
                                        ),
                                      ),
                                    if (removeFromPlaylist != null)
                                      PopupMenuItem(
                                        value: 'remove_from_playlist',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.playlist_remove_rounded),
                                            const SizedBox(width: 8),
                                            Text("Remove from Playlist"),
                                          ],
                                        ),
                                      ),
                                    PopupMenuItem(
                                      value: 'like',
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isInLibrary
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: isInLibrary
                                                ? context.scheme.primary
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(isInLibrary
                                              ? labels.liked
                                              : labels.like),
                                        ],
                                      ),
                                    ),
                                    if (cacheTrack == null)
                                      PopupMenuItem(
                                        value: 'download',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.download),
                                            const SizedBox(width: 8),
                                            Text(labels.download),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'share',
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.share),
                                            const SizedBox(width: 8),
                                            Text(labels.share),
                                          ],
                                        ),
                                      ),
                                  ];
                                },
                              ),
                            ],
                          )
                        : null,
                  );
                });
          }),
    );
  }
}


// ListTile(

//                                     title: Text(
//                                       track.name(ref.lang),
//                                       maxLines: 1,
//                                     ),
//                                     subtitle: Text(
//                                       track.artistsLabel(ref, ref.lang),
//                                       maxLines: 1,
//                                     ),
//                                   )