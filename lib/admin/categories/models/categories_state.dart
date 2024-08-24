// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/music_category.dart';

class AdminCategoriesState {
  final bool loading;
  final String searchKey;
  final List<MusicCategory> categories;
  final int page;
  // final int count;
  final bool? active;
  final bool desending;

  AdminCategoriesState({
    required this.loading,
    required this.categories,
    required this.page,
    // required this.count,
    required this.searchKey,
    this.active,
    this.desending = false,
  });

  int get count => results.length;

  List<MusicCategory> get results {
    var values = categories
      .where(
        (e) => e.searchString.contains(searchKey),
      )
      .where((element) => active == null || element.active == active)
      .toList();


    return values.sortByName(desending: desending);
  }

  List<MusicCategory> get pageResults =>
      results.skip(page * 10).take(10).toList();

  AdminCategoriesState copyWith({
    bool? loading,
    String? searchKey,
    List<MusicCategory>? categories,
    int? page,
    // int? count,
    bool? active,
    bool clearActive = false,
    bool? desending,
  }) {
    return AdminCategoriesState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      categories: categories ?? this.categories,
      page: page ?? this.page,
      // count: count ?? this.count,
      active: clearActive ? null : active ?? this.active,
      desending: desending ?? this.desending,
    );
  }
}
