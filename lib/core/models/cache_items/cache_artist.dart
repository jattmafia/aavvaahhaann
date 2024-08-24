// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive/hive.dart';

part 'cache_artist.g.dart';

@HiveType(typeId: 6)
class CacheArtist extends HiveObject{
  @HiveField(0)
  final Artist artist;
  @HiveField(1)
  final List<Track> tracks;
  
  CacheArtist({
    required this.artist,
    required this.tracks,
  });
}
