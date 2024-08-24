// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/mood.dart';

class AdminMoodState {
  final bool loading;
  final String searchKey;
  final List<Mood> moods;
  final int page;
  final int count;
  final bool desending;

  AdminMoodState({
    required this.loading,
    required this.moods,
    required this.page,
    required this.count,
    required this.searchKey,
     this.desending = false,
  });

  List<Mood> get results {
    var values = moods
      .where(
        (e) => e.searchString.contains(searchKey),
      )
      .toList();

    // values.sort((a, b) => desending
    //     ? b.name().compareTo(a.name())
    //     : a.name().compareTo(b.name()));

    return values.sortByName(desending: desending);
  }

  AdminMoodState copyWith({
    bool? loading,
    String? searchKey,
    List<Mood>? moods,
    int? page,
    int? count,
    bool? desending,
  }) {
    return AdminMoodState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      moods: moods ?? this.moods,
      page: page ?? this.page,
      count: count ?? this.count,
      desending: desending ?? this.desending,
    );
  }
}
