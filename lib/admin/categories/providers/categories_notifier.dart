import 'package:avahan/admin/categories/models/categories_state.dart';
import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/repositories/category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'categories_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminCategoriesNotifier extends _$AdminCategoriesNotifier {
  @override
  AdminCategoriesState build() {
    Future.delayed(Duration.zero, () {
      _fetch();
    });
    return AdminCategoriesState(
      loading: true,
      categories: [],
      page: 0,
      // count: 0,
      searchKey: '',
    );
  }

  CategoryRepository get _repository => ref.read(categoryRepositoryProvider);

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v);
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v);
    // _fetch();
  }

  void activeChanged(bool? v) {
    state = state.copyWith(active: v, clearActive: v == null);
    // _fetch();
  }

  void toggleSort() {
    state = state.copyWith(desending: !state.desending);
  }

  AdminDashboardState get dashboardState =>
      ref.read(adminDashboardNotifierProvider);
  AdminDashboardNotifier get dashboardNotifier =>
      ref.read(adminDashboardNotifierProvider.notifier);

  void refresh() {
    // _fetch();
  }

  void _fetch() async {
    try {
      if (!state.loading) {
        state = state.copyWith(loading: true);
      }
      final result = await _repository.list();
      state = state.copyWith(
        loading: false,
        categories: result,
        // count: result.length,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void writeCategory(MusicCategory category) {
    if (state.categories
        .where((element) => element.id == category.id)
        .isNotEmpty) {
      state = state.copyWith(
        categories: state.categories
            .map((e) => e.id == category.id ? category : e)
            .toList(),
      );
    } else {
      state = state.copyWith(
        categories: [...state.categories, category],
      );
    }
  }

  void removeCategory(MusicCategory category) {
    state = state.copyWith(
      categories: state.categories.where((e) => e.id != category.id).toList(),
    );
  }
}
