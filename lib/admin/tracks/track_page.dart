// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/artists/widgets/artists_view.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/categories/widgets/categories_view.dart';
import 'package:avahan/admin/components/data_status_view.dart';
import 'package:avahan/admin/components/delete_dialog.dart';
import 'package:avahan/admin/components/xfile_audio_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/moods/widgets/moods_view.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/playlist/widgets/playlist_view.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/widgets/tracks_statitics_view.dart';

import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/repositories/playlist_repository.dart';
import 'package:avahan/core/repositories/track_repository.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AdminTrackPage extends HookConsumerWidget {
  const AdminTrackPage({super.key, required this.track});

  final Track track;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final controller = useTabController(initialLength: 4);
    final repository = ref.read(trackRepositoryProvider);
    final trackState = ref.watch(adminTracksNotifierProvider);
    final tracksNotifier = ref.read(adminTracksNotifierProvider.notifier);

    final track = trackState.tracks.firstWhere(
      (element) => element.id == this.track.id,
      orElse: () => this.track,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          track.name(lang),
        ),
        actions: [
         if(ref.permissions.updateTracks) Switch(
            value: track.active,
            onChanged: (v) async {
              try {
                final updated = track.copyWith(
                  active: !track.active,
                );
                await repository.updateActive(track.id, updated.active);
                tracksNotifier.writeTrack(updated);
                tracksNotifier.refresh();
              } catch (e) {
                context.error(e);
              }
            },
          ),
        if (ref.permissions.updateTracks)  IconButton(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite(track);
            },
            icon: const Icon(Icons.edit),
          ),
        if (ref.permissions.deleteTracks)  IconButton(
            onPressed: () async {
              final value = await showDialog(
                context: context,
                builder: (context) => const DeleteDialog(label: 'Tracks'),
              );
              if (value == true) {
                try {
                  await repository.delete(track.id);
                  tracksNotifier.removeTracks(track);
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.scheme.surfaceTint.withOpacity(0.05)),
        child: XFileAudioView(
          url: track.url,
        ),
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
                              imageUrl: track.cover(lang),
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: SizedBox(
                                height: 64,
                                width: 64,
                                child: CachedNetworkImage(
                                  imageUrl: track.icon(lang),
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
                      track.name(lang),
                      style: context.style.titleLarge,
                    ),
                    if (track.description(lang) != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        track.description(lang)!,
                        style: TextStyle(color: context.scheme.outline),
                      ),
                    ],
                    ...(track.links ?? []).map(
                      (e) => GestureDetector(
                        onTap: (){
                          launchUrlString(e.split('|').last);
                        },
                        child: Row(
                          children: [
                            Text(
                              e.split('|').first,
                              style: const TextStyle(
                                color: Colors.blueAccent
                              ),
                            ),
                            Icon(Icons.open_in_new,size: 16, color: Colors.blueGrey.withOpacity(0.5),),
                          ],
                        ),
                      ),
                    ),
                    if (track.lyrics(lang) != null) ...[
                      const SizedBox(height: 16),
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        color: context.scheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            track.lyrics(lang)!,
                            style: TextStyle(
                                color: context.scheme.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TrackStatiticsView(id: track.id),
                    const SizedBox(height: 16),
                    DataStatusView(
                      createdAt: track.createdAt,
                      createdBy: track.createdBy,
                      updatedAt: track.updatedAt,
                      updatedBy: track.updatedBy,
                      size: track.fileSize,
                      type: track.fileType,
                    ),
                    const SizedBox(height: 16),
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
                        text: "Artists",
                      ),
                      Tab(
                        text: "Playlists",
                      ),
                      Tab(
                        text: "Categories",
                      ),
                      Tab(
                        text: "Moods",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        AdminArtistsView(
                          artists: ref
                              .read(adminArtistsNotifierProvider)
                              .artists
                              .where((element) =>
                                  track.artists.contains(element.id))
                              .toList(),
                        ),
                        AdminPlaylistsView(
                          playlists: ref
                              .read(adminPlaylistNotifierProvider)
                              .playlists
                              .where(
                                (element) => element.tracks.contains(track.id),
                              )
                              .toList(),
                          onRemove: (plalist) {
                            try {
                              final updated = plalist.copyWith(
                                tracks: plalist.tracks
                                    .where((element) => element != track.id)
                                    .toList(),
                              );
                              ref
                                  .read(playlistRepositoryProvider)
                                  .write(updated);
                              ref
                                  .read(adminPlaylistNotifierProvider.notifier)
                                  .writePlaylist(updated);
                            } catch (e) {
                              context.error(e);
                            }
                          },
                        ),
                        AdminCategoriesView(
                          categories: ref
                              .read(adminCategoriesNotifierProvider)
                              .categories
                              .where((element) =>
                                  track.categories.contains(element.id))
                              .toList(),
                        ),
                        AdminMoodsView(
                          moods: ref
                              .read(adminMoodsNotifierProvider)
                              .moods
                              .where(
                                  (element) => track.moods.contains(element.id))
                              .toList(),
                        ),
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
