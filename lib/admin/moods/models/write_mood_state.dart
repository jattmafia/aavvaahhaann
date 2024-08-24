// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:image_picker/image_picker.dart';

class WriteMoodState {
  final bool loading;
  final Mood mood;
  final XFile? coverEn;
  final XFile? coverHi;
  final XFile? iconEn;
  final XFile? iconHi;

  WriteMoodState({
    required this.loading,
    required this.mood,
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

  WriteMoodState copyWith({
    bool? loading,
    Mood? moods,
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
  }) {
    return WriteMoodState(
      loading: loading ?? this.loading,
      mood: moods ?? this.mood,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      iconEn: clearIconEn ? null : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
    );
  }
}
