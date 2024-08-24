// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:avahan/core/enums/lang.dart';
import 'package:image_picker/image_picker.dart';

import 'package:avahan/core/models/music_category.dart';

class WriteCategoryState {
  final bool loading;
  final MusicCategory category;
  final XFile? coverEn;
  final XFile? coverHi;
  final XFile? iconEn;
  final XFile? iconHi;
  
  WriteCategoryState({
    required this.loading,
    required this.category,
    this.coverEn,
    this.coverHi,
    this.iconEn,
    this.iconHi,
  });

  XFile? cover([Lang? lang]) {
    return switch (lang) {
      Lang.en => coverEn,
      Lang.hi => coverHi,
      _ => coverEn,
    };
  }

  XFile? icon([Lang? lang]) {
    return switch (lang) {
      Lang.en => iconEn,
      Lang.hi => iconHi,
      _ => iconEn,
    };
  }

  WriteCategoryState copyWith({
    bool? loading,
    MusicCategory? category,
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
  }) {
    return WriteCategoryState(
      loading: loading ?? this.loading,
      category: category ?? this.category,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      iconEn: clearIconEn ? null : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
    );
  }
}
