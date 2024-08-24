import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_manager_provider.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/features/components/empty_track_view.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CacheTracksPage extends ConsumerWidget {
  const CacheTracksPage({super.key});

  static const route = '/cache-tracks';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final lang = ref.lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          labels.downloadedMusic,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: ref.read(cacheTracksProvider).value!.listenable(),
        builder: (context, Box<Track> box, child) {
          return box.isNotEmpty
              ? ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final track = box.getAt(index)!;
                    return Dismissible(
                      key: ValueKey(track.id),
                      onDismissed: (direction) {
                        ref.read(cacheTracksProvider).value!.deleteAt(index);
                        ref.read(cacheManagerProvider).removeFile(track.url);
                      },
                      background: Container(
                        color: context.scheme.errorContainer,
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  color: context.scheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      child: TrackTile(
                        e: track,
                        onTap: () {
                          ref
                              .read(playNotifierProvider.notifier)
                              .startPlaySession(
                                PlayGroup(
                                  data: null,
                                  tracks: box.values.toList(),
                                  start: track,
                                ),
                              );
                        },
                      ),
                    );
                  },
                )
              : const SizedBox(
                  child: EmptyTrackView(),
                );
        },
      ),
    );
  }
}
