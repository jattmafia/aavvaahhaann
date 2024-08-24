// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive/hive.dart';

part 'cache_category.g.dart';

@HiveType(typeId: 7)
class CacheMusicCategory extends HiveObject{
  @HiveField(0)
  final MusicCategory category;
  @HiveField(1)
  final List<Track> tracks;
  CacheMusicCategory({
    required this.category,
    required this.tracks,
  });
}
