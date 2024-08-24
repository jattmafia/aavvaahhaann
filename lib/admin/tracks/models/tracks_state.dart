// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/track.dart';

class AdminTracksState {
  final bool loading;
  final String searchKey;
  final List<Track> tracks;
  final int page;
  final bool? active;
  final bool desending;

  AdminTracksState({
    required this.loading,
    required this.tracks,
    required this.page,
    required this.searchKey,
    this.active,
    this.desending = false,
  });

  List<Track> get results {
    var values = tracks
      .where(
        (e) => e.searchString.contains(searchKey.toLowerCase()),
      )
      .where((element) => active == null || element.active == active)
      .toList();

    return values.sortByName(desending: desending);
  }

  int get count => results.length;

  List<Track> get pageResults => results
      .skip(page * 10)
      .take(10)
      .toList();

  AdminTracksState copyWith({
    bool? loading,
    String? searchKey,
    List<Track>? tracks,
    int? page,
    bool? active,
    bool clearActive = false,
    bool? desending,
  }) {
    return AdminTracksState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      tracks: tracks ?? this.tracks,
      page: page ?? this.page,
      active: clearActive ? null : active ?? this.active,
      desending: desending ?? this.desending,
    );
  }
}
