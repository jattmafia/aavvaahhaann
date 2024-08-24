import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/playlist/models/playlist_state.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/repositories/playlist_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'playlists_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminPlaylistNotifier extends _$AdminPlaylistNotifier {
  @override
  AdminPlayListState build() {
    Future.delayed(Duration.zero, () {
      _fetch();
    });
    // return AdminPlaylistState(
    //   loading: true,
    //   playlist: [],
    //   page: 0,
    //   count: 0,
    //   searchKey: '',
    // );
    return AdminPlayListState(
      loading: true,
      playlists: [],
      page: 0,
      searchKey: '',
    );
  }

  PlaylistRepository get _repository => ref.read(playlistRepositoryProvider);

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v);
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v);
    // _fetch();
  }

  void toggleSort() {
    state = state.copyWith(desending: !state.desending);
  }


  void activeChanged(bool? value) {
    state = state = state.copyWith(
      active: value,
      clearActive: value == null,
    );
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
        state = state.copyWith(loading: true);
      }
      final result = await _repository.list();
      state = state.copyWith(
        loading: false,
        playlists: result,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void writePlaylist(Playlist playlist) {
    if (state.playlists
        .where((element) => element.id == playlist.id)
        .isNotEmpty) {
      state = state.copyWith(
        playlists: state.playlists
            .map((e) => e.id == playlist.id ? playlist : e)
            .toList(),
      );
    } else {
      state = state.copyWith(
        playlists: [...state.playlists, playlist],
      );
    }
  }

  void removePlaylist(Playlist playlist) {
    state = state.copyWith(
      playlists: state.playlists.where((e) => e.id != playlist.id).toList(),
    );
  }
}
