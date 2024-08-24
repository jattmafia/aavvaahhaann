// ignore_for_file: unused_result

import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/playlist/widgets/playlists_table_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminPlayListsPage extends HookConsumerWidget {
  const AdminPlayListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Playlist"),
        actions: [
        if (ref.permissions.createPlaylists)  TextButton.icon(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add playlist"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const AdminPlaylistTableView(),
    );
  }
}
