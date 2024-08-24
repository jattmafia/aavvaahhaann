import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/tracks/models/tracks_state.dart';
import 'package:avahan/core/models/track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/core/repositories/track_repository.dart';

part 'tracks_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminTracksNotifier extends _$AdminTracksNotifier {
  @override
  AdminTracksState build() {
    Future.delayed(Duration.zero, () {
      _fetch();
    });
    return AdminTracksState(
      loading: true,
      tracks: [],
      page: 0,
      searchKey: '',
    );
  }

  TrackRepository get _repository => ref.read(trackRepositoryProvider);

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v,page: 0);
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v);
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

  void activeChanged(bool? v) {
    state = state.copyWith(active: v, clearActive: v == null, page: 0);
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
        tracks: result,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void writeTrack(Track track) {
    if (state.tracks.where((element) => element.id == track.id).isNotEmpty) {
      state = state.copyWith(
        tracks: state.tracks.map((e) => e.id == track.id ? track : e).toList(),
      );
    } else {
      state = state.copyWith(
        tracks: [...state.tracks, track],
      );
    }
  }

  void removeTracks(Track track) {
    state = state.copyWith(
      tracks: state.tracks.where((e) => e.id != track.id).toList(),
    );
  }
}
