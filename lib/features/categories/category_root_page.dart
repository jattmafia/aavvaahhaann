import 'package:avahan/features/categories/category_page.dart';
import 'package:avahan/features/categories/providers/categories_provider.dart';
import 'package:avahan/features/categories/widgets/category_tile.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryRootPage extends ConsumerWidget {
  const CategoryRootPage({super.key, required this.ids});

  static const route = '/category-root';
  final List<int> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AsyncWidget(
        value: ref.watch(categoriesProvider),
        data: (data) {
          final filtered = data.where((element) => ids.contains(element.id));
          if (filtered.length == 1) {
            return CategoryPage(category: filtered.first);
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: filtered.map((e) => CategoryTile(e: e)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
