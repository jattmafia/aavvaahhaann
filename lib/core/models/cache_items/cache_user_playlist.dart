import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:hive/hive.dart';

part 'cache_user_playlist.g.dart';

@HiveType(typeId: 10)
class CacheUserPlaylist extends HiveObject{
  @HiveField(0)
  final UserPlaylist playlist;
  @HiveField(1)
  final List<Track> tracks;

  CacheUserPlaylist({
    required this.playlist,
    required this.tracks,
  });
}
