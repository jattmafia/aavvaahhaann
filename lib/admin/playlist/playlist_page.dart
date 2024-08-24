// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/components/data_status_view.dart';
import 'package:avahan/admin/components/delete_dialog.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/data/widgets/root_statitics_view.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/widgets/tracks_view.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/repositories/playlist_repository.dart';
import 'package:avahan/features/components/lang_segmented_button.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminPlaylistPage extends ConsumerWidget {
  const AdminPlaylistPage({super.key, required this.playlist});

  final Playlist playlist;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final repository = ref.read(playlistRepositoryProvider);
    final playlistsState = ref.watch(adminPlaylistNotifierProvider);
    final playlistsNotifier = ref.read(adminPlaylistNotifierProvider.notifier);

    final playlist = playlistsState.playlists.firstWhere(
      (element) => element.id == this.playlist.id,
      orElse: () => this.playlist,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          playlist.name(lang),
        ),
        actions: [
         if(ref.permissions.updatePlaylists) Switch(
            value: playlist.active,
            onChanged: (v) async {
              try {
                final updated = playlist.copyWith(
                  active: !playlist.active,
                );
                await repository.updateActive(playlist.id, updated.active);
                playlistsNotifier.writePlaylist(updated);
                playlistsNotifier.refresh();
              } catch (e) {
                context.error(e);
              }
            },
          ),
         if (ref.permissions.updatePlaylists) IconButton(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite(playlist);
            },
            icon: const Icon(Icons.edit),
          ),
        if (ref.permissions.deletePlaylists)  IconButton(
            onPressed: () async {
              final value = await showDialog(
                context: context,
                builder: (context) => const DeleteDialog(label: 'playlist'),
              );
              if (value == true) {
                try {
                  await repository.delete(playlist.id);
                  playlistsNotifier.removePlaylist(playlist);
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
                              imageUrl: playlist.cover(lang),
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: SizedBox(
                                height: 64,
                                width: 64,
                                child: CachedNetworkImage(
                                  imageUrl: playlist.icon(lang),
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
                      playlist.name(lang),
                      style: context.style.titleLarge,
                    ),
                    if (playlist.description(lang) != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        playlist.description(lang)!,
                        style: TextStyle(color: context.scheme.outline),
                      ),
                    ],
                    const SizedBox(height: 16),
                    RootStatiticsView(
                      type: AvahanDataType.playlist,
                      id: playlist.id,
                    ),
                    const SizedBox(height: 16),
                    DataStatusView(
                      createdAt: playlist.createdAt,
                      createdBy: playlist.createdBy,
                      updatedAt: playlist.updatedAt,
                      updatedBy: playlist.updatedBy,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text(
                      'Tracks',
                      style: context.style.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: AdminTracksView(
                      tracks: ref
                          .read(adminTracksNotifierProvider)
                          .tracks
                          .where(
                              (element) => playlist.tracks.contains(element.id))
                          .toList(),
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
