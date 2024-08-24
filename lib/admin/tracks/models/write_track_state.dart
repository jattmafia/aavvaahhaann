// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/enums/lang.dart';

import 'package:avahan/core/models/track.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class WriteTracksState {
  final bool loading;
  final Track track;
  final XFile? coverEn;
  final XFile? coverHi;
  final XFile? iconEn;
  final XFile? iconHi;
  final PlatformFile? file;

  WriteTracksState({
    required this.loading,
    required this.track,
    this.coverEn,
    this.coverHi,
    this.iconEn,
    this.iconHi,
    this.file,
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

  WriteTracksState copyWith({
    bool? loading,
    Track? track,
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
    PlatformFile? file,
    bool clearFile = false,
  }) {
    return WriteTracksState(
      loading: loading ?? this.loading,
      track: track ?? this.track,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      iconEn: clearIconEn ? null : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
      file: clearFile ? null : file ?? this.file,
    );
  }
}
