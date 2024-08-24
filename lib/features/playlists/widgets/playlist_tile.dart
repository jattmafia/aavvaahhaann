import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaylistTile extends ConsumerWidget {
  const PlaylistTile(
      {super.key, required this.e, this.onTapExtra, this.dense = false});

  final Playlist e;

  final VoidCallback? onTapExtra;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    return ListTile(
      dense: dense,
      contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,
      title: Text(e.name(lang)),
      subtitle: Text(context.labels.playlist),
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
      onTap: () {
        onTapExtra?.call();
        context.push(PlaylistPage.route, extra: e, ref: ref);
      },
    );
  }
}
