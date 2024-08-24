// ignore_for_file: unused_result
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/repositories/track_repository.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'widgets/tracks_table_view.dart';

class AdminTracksPage extends HookConsumerWidget {
  const AdminTracksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final tracks = ref.read(adminTracksNotifierProvider).tracks.where((e)=>e.duration == null);

      //     // final totalDuration = tracks.fold<int>(0, (previousValue, element) => previousValue + (element.duration ?? 0));

      //     // print('totalDuration: $totalDuration');

      //     final audio = AudioPlayer();

      //     for (var track in tracks) {
      //       try {
      //         final duration = await audio.setUrl(track.url);
      //         if (duration != null) {
      //           ref
      //               .read(trackRepositoryProvider)
      //               .updateDuration(track.id, duration.inSeconds);
      //           print('track: ${track.id} duration: ${duration.inSeconds}');
      //         }
      //       } catch (e) {
      //         print("Error: track: ${track.id} error: $e");
      //       }
      //     }
      //     print('done');
      //   },
      // ),
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Tracks"),
        actions: [
          if (ref.permissions.createTracks)
            TextButton.icon(
              onPressed: () {
                ref.read(dataViewProvider.notifier).showWrite();
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Tracks"),
            ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const AdminTracksTableView(),
    );
  }
}
