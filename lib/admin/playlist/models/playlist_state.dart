// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/playlist.dart';

class AdminPlayListState {
  final bool loading;
  final String searchKey;
  final List<Playlist> playlists;
  final int page;
  final bool? active;
  final bool desending;

  // final int count;




  AdminPlayListState({
    required this.loading,
    required this.playlists,
    required this.page,
    // required this.count,
    required this.searchKey,
    this.active,
    this.desending = false,
  });

  int get count => results.length;

  List<Playlist> get results {
   var values = playlists
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

  List<Playlist> get pageResults => results
      .skip(page * 10)
      .take(10)
      .toList();

  AdminPlayListState copyWith({
    bool? loading,
    String? searchKey,
    List<Playlist>? playlists,
    int? page,
    bool? active,
    bool clearActive = false,
    bool? desending,
    // int? count,
  }) {
    return AdminPlayListState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      playlists: playlists ?? this.playlists,
      page: page ?? this.page,
      active: clearActive ? null : active ?? this.active,
      desending: desending ?? this.desending,
      // count: count ?? this.count,
    );
  }
}
