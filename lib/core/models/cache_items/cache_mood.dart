// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive/hive.dart';


part 'cache_mood.g.dart';

@HiveType(typeId: 8)
class CacheMood extends HiveObject{
  @HiveField(0)
  final Mood mood;
  @HiveField(1)
  final List<Track> tracks;
  CacheMood({
    required this.mood,
    required this.tracks,
  });
}
