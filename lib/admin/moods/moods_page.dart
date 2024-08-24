// ignore_for_file: unused_result

import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/widgets/moods_table_view.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminMoodsPage extends HookConsumerWidget {
  const AdminMoodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Moods"),
        actions: [
        if(ref.permissions.createMoods)  TextButton.icon(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Mood"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const AdminMoodsTableView(),
    );
  }
}
