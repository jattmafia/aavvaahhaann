// ignore_for_file: unused_result

import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/sharer_provider.dart';
import 'package:avahan/core/repositories/library_item_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/library/providers/library_items_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/features/view/models/view_state.dart';
import 'package:avahan/features/view/view_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryPage extends HookConsumerWidget {
  const CategoryPage({super.key, required this.category});

  final MusicCategory category;

  static const route = '/category';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langProvider);

    final library = ref.watch(libraryItemsProvider).asData?.value ?? [];

    final profile = ref.read(yourProfileProvider).value!;
    final labels = context.labels;

    final libraryItem = library
        .where((element) =>
            element.itemId == category.id &&
            element.type == LibraryItemType.category)
        .firstOrNull;

    final isInLibrary = libraryItem != null;

    final tracksAsync = ref.watch(tracksProvider(categoryId: category.id));

    void play(List<Track> data, Track e) {
      ref.read(playNotifierProvider.notifier).startPlaySession(
            PlayGroup(
              data: category,
              tracks: data,
              start: e,
            ),
          );
    }
        final player = ref.watch(playNotifierProvider);




    final viewState = ViewState(
      tracks: tracksAsync.asData?.value ?? [],
      name: category.name(lang),
      description: category.description(lang),
      cover: category.cover(lang),
      isInLibrary: isInLibrary,
      onShareTap: () {
        ref.read(shareProvider).shareCategory(category);
      },
      onLibraryTap: () async {
        final repository = ref.read(libraryItemRepositoryProvider);
        if (isInLibrary) {
          await repository.deleteLibraryItem(libraryItem);
        } else {
          await repository.writeLibraryItem(
            LibraryItem(
              id: 0,
              createdAt: DateTime.now(),
              createdBy: profile.id,
              type: LibraryItemType.category,
              itemId: category.id,
            ),
          );
        }
        ref.refresh(libraryItemsProvider);
      },
      onDownloadTap: () {},
      isPlaying: player.session?.data is MusicCategory &&
          player.session?.data.id == category.id,
      onPlayTap: () {
        final tracks = tracksAsync.asData?.value ?? [];
        if (tracks.isNotEmpty) {
          play(tracks.sortByNamePremium(ref), tracks.first);
        }
      },
      tracksCount: 10,
      child: AsyncWidget(
          value: tracksAsync,
          data: (data) {
            data = data.sortByNamePremium(ref);
            return Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  ...data,
                ]
                    .map(
                      (e) => TrackTile(
                        e: e,
                        onTap: () {
                          play(data, e);
                        },
                      ),
                    )
                    .toList(),
              ),
            );
          }),
    );

    return ViewPage(
      body: ViewPageBody(view: viewState),
      view: viewState,
    );
  }
}
