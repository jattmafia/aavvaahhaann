import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/core/repositories/user_playlist_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/empty_track_view.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/features/user_playlists/create_playlist_page.dart';
import 'package:avahan/features/user_playlists/providers/user_playlists_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserPlaylistPage extends HookConsumerWidget {
  const UserPlaylistPage({super.key, required this.playlist});

  final UserPlaylist playlist;

  static const route = '/user-playlist';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = useState(playlist.tracks);

    final name = useState(playlist.name);

    Future<void> write(UserPlaylist v) async {
      await ref.read(userPlaylistRepositoryProvider).writeUserPlaylist(v);
      ref.refresh(userPlaylistsProvider);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(name.value),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePlaylistPage(
                      suggestedName: name.value,
                      edit: true,
                    ),
                  ),
                );
                if (value is String) {
                  await write(playlist.copyWith(name: value));
                  name.value = value;
                }
              },
            ),
          ],
        ),
        body: AsyncWidget(
          value: ref.watch(tracksProvider(ids: playlist.tracks)),
          data: (data) {
            final list = data
                .where((element) => ids.value.contains(element.id))
                .toList()
                .sortByNamePremium(ref);
            return list.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: list
                        .map(
                          (e) => TrackTile(
                            e: e,
                            removeFromPlaylist: () async {
                              await write(playlist.copyWith(
                                  tracks: playlist.tracks
                                      .where(
                                        (element) => element != e.id,
                                      )
                                      .toList()));
                              ids.value = playlist.tracks
                                  .where(
                                    (element) => element != e.id,
                                  )
                                  .toList();
                            },
                            onTap: () {
                              ref
                                  .read(playNotifierProvider.notifier)
                                  .startPlaySession(
                                    PlayGroup(
                                      data: playlist,
                                      tracks: list,
                                      start: e,
                                    ),
                                  );
                            },
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox(
                    child: EmptyTrackView(),
                  );
          },
        ));
  }
}
