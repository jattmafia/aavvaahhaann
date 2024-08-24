import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/features/components/empty_track_view.dart';
import 'package:avahan/features/library/providers/library_items_provider.dart';
import 'package:avahan/features/tracks/providers/track_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LikedMusicsPage extends ConsumerWidget {
  const LikedMusicsPage({super.key});
  static const route = '/liked-musics';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final items = ref.watch(libraryItemsProvider).asData?.value ?? [];
    final libraryTracks = items
        .where((element) => element.type == LibraryItemType.track)
        .toList();

    libraryTracks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          labels.likedMusics,
        ),
      ),
      body: libraryTracks.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: libraryTracks.map(
                (e) {
                  final track =
                      ref.watch(trackProvider(e.itemId)).asData?.value;
                  return track == null ? const SizedBox() : TrackTile(e: track);
                },
              ).toList(),
            )
          : const SizedBox(
              child: EmptyTrackView(),
            ),
    );
  }
}
