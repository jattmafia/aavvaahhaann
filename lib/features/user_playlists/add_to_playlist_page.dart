// ignore_for_file: unused_result

import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/core/repositories/user_playlist_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/search_card.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/tracks/providers/track_provider.dart';
import 'package:avahan/features/user_playlists/create_playlist_page.dart';
import 'package:avahan/features/user_playlists/providers/user_playlists_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddToPlaylistPage extends HookConsumerWidget {
  const AddToPlaylistPage({super.key, required this.track});

  static const route = "/add-to-playlist";

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final playlistsAsync = ref.watch(userPlaylistsProvider);
    final profile = ref.read(yourProfileProvider).value!;
    final repository = ref.read(userPlaylistRepositoryProvider);

    final searchKey = useState('');

    final selected = useState<List<int>>([]);

    useEffect(() {
      ref.read(userPlaylistsProvider.future).then((value) {
        selected.value = value
            .where((element) => element.tracks.contains(track.id))
            .map((e) => e.id)
            .toList();
      });
      return null;
    }, [playlistsAsync.value?.length]);

    final previous = (playlistsAsync.asData?.value ?? [])
        .where((element) => element.tracks.contains(track.id))
        .map((e) => e.id)
        .toList();
    final toRemove =
        previous.where((element) => !selected.value.contains(element)).toList();
    final toAdd =
        selected.value.where((element) => !previous.contains(element)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(labels.addToPlaylist),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: toRemove.isNotEmpty || toAdd.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: context.scheme.primary,
              foregroundColor: context.scheme.onPrimary,
              onPressed: () async {
                for (final id in toRemove) {
                  final playlist = playlistsAsync.asData?.value
                      .firstWhere((element) => element.id == id);
                  if (playlist != null) {
                    await repository.writeUserPlaylist(playlist.copyWith(
                        tracks: playlist.tracks
                            .where((element) => element != track.id)
                            .toList()));
                  }
                }
                for (final id in toAdd) {
                  final playlist = playlistsAsync.asData?.value
                      .firstWhere((element) => element.id == id);
                  if (playlist != null) {
                    await repository.writeUserPlaylist(playlist
                        .copyWith(tracks: [...playlist.tracks, track.id]));
                  }
                }
                ref.refresh(userPlaylistsProvider);
                ref.pop();
              },
              shape: const StadiumBorder(),
              extendedPadding: const EdgeInsets.symmetric(horizontal: 40),
              label: Text(labels.done),
            )
          : null,
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton.tonal(
                onPressed: () async {
                  final totalPlaylists =
                      playlistsAsync.asData?.value.length ?? 0;
                  final value = await ref.push(CreatePlaylistPage.route,
                      extra: "My playlist #${totalPlaylists + 1}");
                  if (value is String) {
                    await repository.writeUserPlaylist(
                      UserPlaylist(
                        id: 0,
                        createdAt: DateTime.now(),
                        createdBy: profile.id,
                        name: value,
                        tracks: [
                          track.id,
                        ],
                      ),
                    );
                    ref.refresh(userPlaylistsProvider);
                    // ref.pop();
                  }
                },
                child: Text(labels.newPlaylist),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchField(
              initial: searchKey.value,
              hintText: labels.findPlaylist,
              onChanged: (v){
                searchKey.value = v;
              },
            ),
          ),
          AsyncWidget(
            value: playlistsAsync,
            data: (data) {
              return Column(
                children: data.where((element) => element.name.toLowerCase().contains(searchKey.value.toLowerCase().trim()))
                    .map(
                      (e) => ListTile(
                        onTap: () {
                          if (selected.value.contains(e.id)) {
                            selected.value = selected.value
                                .where((element) => element != e.id)
                                .toList();
                          } else {
                            selected.value = [...selected.value, e.id];
                          }
                        },
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: e.tracks.isNotEmpty
                                ? AsyncWidget(
                                    value: ref
                                        .watch(trackProvider(e.tracks.first)),
                                    data: (track) {
                                      return CachedNetworkImage(
                                        imageUrl: track.icon(ref.lang),
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Container(
                                    color: context.scheme.surfaceTint
                                        .withOpacity(0.05),
                                    child: const Center(
                                      child: Icon(
                                        Icons.audiotrack,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        title: Text(e.name),
                        subtitle: Text(labels.songs(e.tracks.length)),
                        trailing: selected.value.contains(e.id)
                            ? Icon(
                                Icons.check_circle,
                                color: context.scheme.primary,
                              )
                            : const Icon(Icons.circle_outlined),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
