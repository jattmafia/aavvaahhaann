// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/artist.dart';

class AdminArtistsState {
  final bool loading;
  final String searchKey;
  final List<Artist> artists;
  final int page;
  final bool? active;
  final bool desending;

  AdminArtistsState({
    required this.loading,
    required this.artists,
    required this.page,
    required this.searchKey,
    this.active,
    this.desending = false,
  });

  int get count => results.length;

  List<Artist> get results {
    var values = artists
        .where(
          (e) => e.searchString.contains(searchKey),
        )
        .where((element) => active == null || element.active == active)
        .toList();

    // values.sort((a, b) => desending
    //     ? b.name().compareTo(a.name())
    //     : a.name().compareTo(b.name()));

    return values.sortByName(desending: desending);
  }

  List<Artist> get pageResults => results.skip(page * 10).take(10).toList();

  AdminArtistsState copyWith({
    bool? loading,
    String? searchKey,
    List<Artist>? artists,
    int? page,
    bool? active,
    bool clearActive = false,
    bool? desending,
  }) {
    return AdminArtistsState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      artists: artists ?? this.artists,
      page: page ?? this.page,
      active: clearActive ? null : active ?? this.active,
      desending: desending ?? this.desending,
    );
  }
}
