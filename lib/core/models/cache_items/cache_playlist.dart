


import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive/hive.dart';

part 'cache_playlist.g.dart';

@HiveType(typeId: 9)
class CachePlaylist extends HiveObject{
  @HiveField(0)
  final Playlist playlist;
  @HiveField(1)
  final List<Track> tracks;

  CachePlaylist({required this.playlist, required this.tracks});
}
