// ignore_for_file: unused_result

import 'package:avahan/admin/categories/widgets/categories_table_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/utils/extensions.dart';

class AdminCategoriesPage extends HookConsumerWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Categories"),
        actions: [
          if(ref.permissions.createCategories) TextButton.icon(
            onPressed: () {
              ref.read(dataViewProvider.notifier).showWrite();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Category"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const AdminCategoriesTableView(),
    );
  }
}
