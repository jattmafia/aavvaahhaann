import 'package:hive/hive.dart';

part 'artist_type.g.dart';

@HiveType(typeId: 12)
enum ArtistType {
  @HiveField(0)
  singer,
  @HiveField(1)
  composer,
  @HiveField(2)
  lyricist,
  @HiveField(3)
  astrologer,
  @HiveField(4)
  pandit,
  @HiveField(5)
  contributor,
  @HiveField(6)
  soundEngineer,
  @HiveField(7)
  team,
  @HiveField(8)
  narrator,
  @HiveField(9)
  author,
  @HiveField(10)
  unknown,
}
