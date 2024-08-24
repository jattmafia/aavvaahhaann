import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/moods/models/moods_state.dart';

import 'package:avahan/core/models/mood.dart';

import 'package:avahan/core/repositories/mood_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'moods_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminMoodsNotifier extends _$AdminMoodsNotifier {
  @override
  AdminMoodState build() {
    Future.delayed(Duration.zero, () {
      _fetch();
    });
    return AdminMoodState(
      loading: true,
      moods: [],
      page: 0,
      count: 0,
      searchKey: '',
    );
  }

  MoodRepository get _repository => ref.read(moodRepositoryProvider);

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v, moods: []);
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v, moods: []);
    // _fetch();
  }

  void toggleSort() {
    state = state.copyWith(desending: !state.desending);
  }

  AdminDashboardState get dashboardState => ref.read(adminDashboardNotifierProvider);
  AdminDashboardNotifier get dashboardNotifier =>
      ref.read(adminDashboardNotifierProvider.notifier);


  void refresh() {
    // _fetch();
  }

  void _fetch() async {
    try {
      if (!state.loading) {
        state = state.copyWith(loading: true, moods: []);
      }
      final result = await _repository.list();
      state = state.copyWith(
        loading: false,
        moods: result,
        count: result.length,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void writeMood(Mood moods) {
    if (state.moods.where((element) => element.id == moods.id).isNotEmpty) {
      state = state.copyWith(
        moods: state.moods.map((e) => e.id == moods.id ? moods : e).toList(),
      );
    } else {
      state = state.copyWith(
        moods: [...state.moods, moods],
      );
    }
  }

  void removeMood(Mood moods) {
    state = state.copyWith(
      moods: state.moods.where((e) => e.id != moods.id).toList(),
    );
  }
}
