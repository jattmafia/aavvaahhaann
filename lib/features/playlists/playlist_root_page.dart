import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/features/playlists/widgets/playlist_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayListRootPage extends ConsumerWidget {
  const PlayListRootPage({super.key, required this.ids});

  static const route = '/playlist-root';
  final List<int> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AsyncWidget(
        value: ref.watch(playlistsProvider),
        data: (data) {
          final filtered = data.where((element) => ids.contains(element.id));
          if (filtered.length == 1) {
            return PlaylistPage(playlist: filtered.first);
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: filtered.map((e) => PlaylistTile(e: e)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}