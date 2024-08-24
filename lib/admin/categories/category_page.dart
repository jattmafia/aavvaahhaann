// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/artists/widgets/artists_view.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/data_status_view.dart';
import 'package:avahan/admin/components/delete_dialog.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/components/visibility_icon.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/data/widgets/root_statitics_view.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/widgets/tracks_view.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/repositories/artist_repository.dart';
import 'package:avahan/core/repositories/category_repository.dart';
import 'package:avahan/core/repositories/track_repository.dart';
import 'package:avahan/features/components/lang_segmented_button.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminCategoryPage extends HookConsumerWidget {
  const AdminCategoryPage({super.key, required this.category});

  final MusicCategory category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final repository = ref.read(categoryRepositoryProvider);
    final categoriesState = ref.watch(adminCategoriesNotifierProvider);
    final categoriesNotifier =
        ref.read(adminCategoriesNotifierProvider.notifier);

    final controller = useTabController(initialLength: 2);

    final category = categoriesState.categories.firstWhere(
      (element) => element.id == this.category.id,
      orElse: () => this.category,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name(lang),
        ),
        actions: [
          const SizedBox(width: 8),
          if (ref.permissions.updateCategories)
            Switch(
              value: category.active,
              onChanged: (v) async {
                try {
                  final updated = category.copyWith(
                    active: !category.active,
                  );
                  await repository.updateActive(category.id, updated.active);
                  categoriesNotifier.writeCategory(updated);
                  categoriesNotifier.refresh();
                } catch (e) {
                  context.error(e);
                }
              },
            ),
          if (ref.permissions.updateCategories)
            IconButton(
              onPressed: () {
                ref.read(dataViewProvider.notifier).showWrite(category);
              },
              icon: const Icon(Icons.edit),
            ),
          if (ref.permissions.deleteCategories)
            IconButton(
              onPressed: () async {
                final value = await showDialog(
                  context: context,
                  builder: (context) => const DeleteDialog(label: 'category'),
                );
                if (value == true) {
                  try {
                    await repository.delete(category.id);
                    categoriesNotifier.removeCategory(category);
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
                              imageUrl: category.cover(lang),
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: SizedBox(
                                height: 64,
                                width: 64,
                                child: CachedNetworkImage(
                                  imageUrl: category.icon(lang),
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
                      category.name(lang),
                      style: context.style.titleLarge,
                    ),
                    if (category.description(lang) != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        category.description(lang)!,
                        style: TextStyle(color: context.scheme.outline),
                      ),
                    ],
                    const SizedBox(height: 16),
                    RootStatiticsView(
                      type: AvahanDataType.category,
                      id: category.id,
                    ),
                    const SizedBox(height: 16),
                    DataStatusView(
                      createdAt: category.createdAt,
                      createdBy: category.createdBy,
                      updatedAt: category.updatedAt,
                      updatedBy: category.updatedBy,
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
                    tabs: [
                      Tab(
                        text: "Tracks",
                      ),
                      Tab(
                        text: "Artists",
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
                                      element.categories.contains(category.id))
                                  .toList(),
                              onRemove: ref.permissions.updateCategories
                                  ? (track) async {
                                      final value = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Remove ${track.name(lang)} from ${category.name(lang)}?',
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
                                      if(value == true){
                                        try {
                                          final updated = track.copyWith(
                                            categories: track.categories
                                                .where((element) =>
                                                    element != category.id)
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
                                    }
                                  : null,
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
                                      .where((element) => !element.categories
                                          .contains(category.id))
                                      .toList(),
                                  onSelected: (id) async {
                                    try {
                                      final track = ref
                                          .watch(adminTracksNotifierProvider)
                                          .tracks
                                          .firstWhere(
                                              (element) => element.id == id);
                                      final updated = track.copyWith(
                                          categories: [
                                            ...track.categories,
                                            category.id
                                          ]);
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
                        AdminArtistsView(
                          artists: ref
                              .watch(adminArtistsNotifierProvider)
                              .artists
                              .where((element) =>
                                  element.categories.contains(category.id))
                              .toList(),
                          onRemove: ref.permissions.updateCategories
                              ? (artist) async {
                                  try {
                                    final updated = artist.copyWith(
                                      categories: artist.categories
                                          .where((element) =>
                                              element != category.id)
                                          .toList(),
                                    );
                                    await ref
                                        .read(artistRepositoryProvider)
                                        .write(updated);
                                    ref
                                        .read(adminArtistsNotifierProvider
                                            .notifier)
                                        .writeArtist(updated);
                                  } catch (e) {
                                    context.error(e);
                                  }
                                }
                              : null,
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
