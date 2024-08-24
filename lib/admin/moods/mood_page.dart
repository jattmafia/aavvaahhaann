// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/components/data_status_view.dart';
import 'package:avahan/admin/components/delete_dialog.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/data/widgets/root_statitics_view.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/widgets/tracks_view.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/repositories/mood_repository.dart';
import 'package:avahan/core/repositories/track_repository.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminMoodPage extends ConsumerWidget {
  const AdminMoodPage({super.key, required this.mood});

  final Mood mood;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final repository = ref.read(moodRepositoryProvider);
    final moodsState = ref.watch(adminMoodsNotifierProvider);
    final artistsNotifier = ref.read(adminMoodsNotifierProvider.notifier);

    final mood = moodsState.moods.firstWhere(
      (element) => element.id == this.mood.id,
      orElse: () => this.mood,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mood.name(lang),
        ),
        actions: [
          if (ref.permissions.updateMoods)
            IconButton(
              onPressed: () {
                ref.read(dataViewProvider.notifier).showWrite(mood);
              },
              icon: const Icon(Icons.edit),
            ),
          if (ref.permissions.deleteMoods)
            IconButton(
              onPressed: () async {
                final value = await showDialog(
                  context: context,
                  builder: (context) => const DeleteDialog(label: 'Moods'),
                );
                if (value == true) {
                  try {
                    await repository.delete(mood.id);
                    artistsNotifier.removeMood(mood);
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
                              imageUrl: mood.cover(lang),
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: SizedBox(
                                height: 64,
                                width: 64,
                                child: CachedNetworkImage(
                                  imageUrl: mood.icon(lang),
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
                      mood.name(lang),
                      style: context.style.titleLarge,
                    ),
                    if (mood.description(lang) != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        mood.description(lang)!,
                        style: TextStyle(color: context.scheme.outline),
                      ),
                    ],
                    const SizedBox(height: 16),
                    RootStatiticsView(
                      type: AvahanDataType.mood,
                      id: mood.id,
                    ),
                    const SizedBox(height: 16),
                    DataStatusView(
                      createdAt: mood.createdAt,
                      createdBy: mood.createdBy,
                      updatedAt: mood.updatedAt,
                      updatedBy: mood.updatedBy,
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
                    child: Stack(
                      children: [
                        AdminTracksView(
                          bottomPadding: 56,
                          tracks: ref
                              .watch(adminTracksNotifierProvider)
                              .tracks
                              .where((element) => element.moods.contains(mood.id))
                              .toList(),
                          onRemove: ref.permissions.updateMoods
                              ? (track) async {
                                  final value = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Remove ${track.name(lang)} from ${mood.name(lang)}?',
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
                                  if (value == true) {
                                    try {
                                      final updated = track.copyWith(
                                        moods: track.moods
                                            .where((element) => element != mood.id)
                                            .toList(),
                                      );
                                      await ref
                                          .read(trackRepositoryProvider)
                                          .write(updated);
                                      ref
                                          .read(
                                              adminTracksNotifierProvider.notifier)
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
                                  .where((element) =>
                                      !element.moods.contains(mood.id))
                                  .toList(),
                              onSelected: (id) async {
                                try {
                                  final track = ref
                                      .watch(adminTracksNotifierProvider)
                                      .tracks
                                      .firstWhere(
                                          (element) => element.id == id);
                                  final updated = track.copyWith(
                                    moods: [...track.moods, mood.id],
                                  );
                                  await ref
                                      .read(trackRepositoryProvider)
                                      .write(updated);
                                  ref
                                      .read(
                                          adminTracksNotifierProvider.notifier)
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
