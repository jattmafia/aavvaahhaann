// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/models/track.dart';

class PlayGroup {
  final dynamic data;
  final List<Track> tracks;
  final Track start;

  PlayGroup({
    required this.data,
    required this.tracks,
    required this.start,
  });

  PlayGroup copyWith({
    dynamic? data,
    List<Track>? tracks,
    Track? start,
  }) {
    return PlayGroup(
      data: data ?? this.data,
      tracks: tracks ?? this.tracks,
      start: start ?? this.start,
    );
  }
}
