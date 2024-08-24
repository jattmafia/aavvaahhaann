import 'package:avahan/core/models/mood.dart';
import 'package:avahan/features/moods/mood_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MoodTile extends ConsumerWidget {
  const MoodTile({super.key, required this.e,this.onTapExtra,this.dense = false});

  final Mood e;

    final VoidCallback? onTapExtra;

    final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    return ListTile(
      dense: dense,
                  contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,
      title: Text(e.name(lang)),
      subtitle: Text(context.labels.mood),
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
        context.push(MoodPage.route, extra: e,ref: ref);
      },
    );
  }
}
