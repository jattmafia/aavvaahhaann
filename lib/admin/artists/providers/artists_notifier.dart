import 'package:avahan/admin/artists/models/artists_state.dart';
import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/repositories/artist_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'artists_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminArtistsNotifier extends _$AdminArtistsNotifier {
  @override
  AdminArtistsState build() {
    Future.delayed(Duration.zero, () {
      _fetch();
    });
    return AdminArtistsState(
      loading: true,
      artists: [],
      page: 0,
      searchKey: '',
    );
  }

  ArtistRepository get _repository => ref.read(artistRepositoryProvider);

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v);
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v);
    // _fetch();
  }

  void activeChanged(bool? value) {
    state = state = state.copyWith(
      active: value,
      clearActive: value == null,
    );
  }

  void toggleSort(){
    state = state.copyWith(
      desending: !state.desending,
    );
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
        artists: result,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void writeArtist(Artist artist) {
    if (state.artists.where((element) => element.id == artist.id).isNotEmpty) {
      state = state.copyWith(
        artists:
            state.artists.map((e) => e.id == artist.id ? artist : e).toList(),
      );
    } else {
      state = state.copyWith(
        artists: [...state.artists, artist],
      );
    }
  }

  void removeArtist(Artist artist) {
    state = state.copyWith(
      artists: state.artists.where((e) => e.id != artist.id).toList(),
    );
  }
}
