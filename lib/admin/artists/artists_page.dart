// ignore_for_file: unused_result

import 'package:avahan/admin/artists/widgets/artists_table_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminArtistsPage extends HookConsumerWidget {
  const AdminArtistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Artists"),
        actions: [
          TextButton.icon(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Artist"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const AdminArtistsTableView(),
    );
  }
}
