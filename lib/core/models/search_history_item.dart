// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive/hive.dart';

import 'package:avahan/core/enums/avahan_data_type.dart';

part 'search_history_item.g.dart';

@HiveType(typeId: 15)
class SearchHistoryItem extends HiveObject {
  @HiveField(0)
  final AvahanDataType type;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final String data;

  SearchHistoryItem({
    required this.type,
    required this.createdAt,
    required this.data,
  });

  dynamic get parse {
    final map = jsonDecode(data);
    return switch (type) {
      AvahanDataType.artist => Artist.fromMap(map),
      AvahanDataType.track => Track.fromMap(map),
      AvahanDataType.category => MusicCategory.fromMap(map),
      AvahanDataType.mood => Mood.fromMap(map),
      AvahanDataType.playlist => Playlist.fromMap(map),
      _ => Object(),
    };
  }
}
