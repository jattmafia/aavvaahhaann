import 'package:avahan/core/models/artist.dart';
import 'package:avahan/features/artists/artist_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArtistTile extends ConsumerWidget {
  const ArtistTile(
      {super.key, required this.e, this.onTapExtra, this.dense = false});

  final Artist e;
  final VoidCallback? onTapExtra;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    return ListTile(
      dense: dense,
      contentPadding: dense? const EdgeInsets.symmetric(horizontal: 8): null,
      title: Text(
        e.name(lang),
        maxLines: dense ? 1 : null,
      ),
      subtitle: Text(context.labels.artist),
      leading: AspectRatio(
        aspectRatio: 1,
        child: CircleAvatar(
          radius: 28,
          backgroundImage: CachedNetworkImageProvider(
            e.icon(lang),
          ),
        ),
      ),
      onTap: () {
        context.push(ArtistPage.route, extra: e, ref: ref);
      },
    );
  }
}
