// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:image_picker/image_picker.dart';

class WriteArtistState {
  final bool loading;
  final Artist artist;
  final XFile? coverEn;
  final XFile? coverHi;
  final XFile? iconEn;
  final XFile? iconHi;
  
  WriteArtistState({
    required this.loading,
    required this.artist,
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

  WriteArtistState copyWith({
    bool? loading,
    Artist? artist,
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
  }) {
    return WriteArtistState(
      loading: loading ?? this.loading,
      artist: artist ?? this.artist,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      iconEn: clearIconEn ? null : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
    );
  }
}
