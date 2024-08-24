import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/features/categories/category_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryTile extends ConsumerWidget {
  const CategoryTile({
    super.key,
    required this.e,
    this.onTapExtra,
    this.dense = false,
  });

  final MusicCategory e;
  final bool dense;
  final VoidCallback? onTapExtra;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    return ListTile(
      dense: dense,
      title: Text(e.name(lang)),
      subtitle: Text(context.labels.category),
            contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,

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
        context.push(CategoryPage.route, extra: e, ref: ref);
      },
    );
  }
}
