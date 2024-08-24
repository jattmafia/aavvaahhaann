// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:image_picker/image_picker.dart';

class WritePlayListState {
  final bool loading;
  final Playlist playlist;
  final XFile? coverEn;
  final XFile? coverHi;
  final XFile? iconEn;
  final XFile? iconHi;

  WritePlayListState({
    required this.loading,
    required this.playlist,
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

  WritePlayListState copyWith({
    bool? loading,
    Playlist? playlist,
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
  }) {
    return WritePlayListState(
      loading: loading ?? this.loading,
      playlist: playlist ?? this.playlist,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      iconEn: clearIconEn ? null : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
    );
  }
}
