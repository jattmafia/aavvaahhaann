// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/categories/widgets/categories_view.dart';
import 'package:avahan/admin/components/data_status_view.dart';
import 'package:avahan/admin/components/delete_dialog.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/data/widgets/root_statitics_view.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/widgets/tracks_view.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/repositories/artist_repository.dart';
import 'package:avahan/core/repositories/track_repository.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminArtistPage extends HookConsumerWidget {
  const AdminArtistPage({super.key, required this.artist});

  final Artist artist;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final repository = ref.read(artistRepositoryProvider);
    final artistsState = ref.watch(adminArtistsNotifierProvider);
    final artistsNotifier = ref.read(adminArtistsNotifierProvider.notifier);

    final controller = useTabController(initialLength: 2);

    final artist = artistsState.artists.firstWhere(
      (element) => element.id == this.artist.id,
      orElse: () => this.artist,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          artist.name(lang),
        ),
        actions: [
          Switch(
            value: artist.active,
            onChanged: (v) async {
              try {
                final updated = artist.copyWith(
                  active: !artist.active,
                );
                await repository.updateActive(artist.id, updated.active);
                artistsNotifier.writeArtist(updated);
                artistsNotifier.refresh();
              } catch (e) {
                context.error(e);
              }
            },
          ),
          IconButton(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite(artist);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              final value = await showDialog(
                context: context,
                builder: (context) => const DeleteDialog(label: 'artist'),
              );
              if (value == true) {
                try {
                  await repository.delete(artist.id);
                  artistsNotifier.removeArtist(artist);
                  context.pop();
                } catch (e) {
                  context.error(e);
                }
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 3,
                      child: Material(
                        color: context.scheme.surfaceTint.withOpacity(0.05),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: artist.cover(lang),
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: SizedBox(
                                height: 64,
                                width: 64,
                                child: CachedNetworkImage(
                                  imageUrl: artist.icon(lang),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      artist.name(lang),
                      style: context.style.titleLarge,
                    ),
                    if (artist.description(lang) != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        artist.description(lang)!,
                        style: TextStyle(color: context.scheme.outline),
                      ),
                    ],
                    const SizedBox(height: 16),
                    RootStatiticsView(
                      type: AvahanDataType.artist,
                      id: artist.id,
                    ),
                    const SizedBox(height: 16),
                    DataStatusView(
                      createdAt: artist.createdAt,
                      createdBy: artist.createdBy,
                      updatedAt: artist.updatedAt,
                      updatedBy: artist.updatedBy,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TabBar(
                    controller: controller,
                    tabs: const [
                      Tab(
                        text: "Tracks",
                      ),
                      Tab(
                        text: "Categories",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        Stack(
                          children: [
                            AdminTracksView(
                              bottomPadding: 56,
                              tracks: ref
                                  .watch(adminTracksNotifierProvider)
                                  .tracks
                                  .where((element) =>
                                      element.artists.contains(artist.id))
                                  .toList(),
                              onRemove: (track) async {
                                final value = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Remove ${track.name(lang)} from ${artist.name(lang)}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context.pop(false);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.pop(true);
                                        },
                                        child: Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                                if (value == true) {
                                  try {
                                    final updated = track.copyWith(
                                      artists: track.artists
                                          .where(
                                              (element) => element != artist.id)
                                          .toList(),
                                    );
                                    await ref
                                        .read(trackRepositoryProvider)
                                        .write(updated);
                                    ref
                                        .read(adminTracksNotifierProvider
                                            .notifier)
                                        .writeTrack(updated);
                                  } catch (e) {
                                    context.error(e);
                                  }
                                }
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: SizedBox(
                                width: 200,
                                child: SearchView(
                                  hintText: 'Add track',
                                  tracks: ref
                                      .watch(adminTracksNotifierProvider)
                                      .tracks
                                      .where((element) => !element.artists
                                          .contains(artist.id))
                                      .toList(),
                                  onSelected: (id) async {
                                    try {
                                      final track = ref
                                          .watch(adminTracksNotifierProvider)
                                          .tracks
                                          .firstWhere(
                                              (element) => element.id == id);
                                      final updated = track.copyWith(
                                        artists: [...track.artists, artist.id],
                                      );
                                      await ref
                                          .read(trackRepositoryProvider)
                                          .write(updated);
                                      ref
                                          .read(adminTracksNotifierProvider
                                              .notifier)
                                          .writeTrack(updated);
                                    } catch (e) {
                                      context.error(e);
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        AdminCategoriesView(
                            categories: ref
                                .watch(adminCategoriesNotifierProvider)
                                .categories
                                .where((element) =>
                                    artist.categories.contains(element.id))
                                .toList(),
                            onRemove: (category) async {
                              try {
                                final updated = artist.copyWith(
                                  categories: artist.categories
                                      .where(
                                          (element) => element != category.id)
                                      .toList(),
                                );
                                await repository.write(updated);
                                ref
                                    .read(adminArtistsNotifierProvider.notifier)
                                    .writeArtist(updated);
                              } catch (e) {
                                context.error(e);
                              }
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
