

import 'package:hive_flutter/hive_flutter.dart';

part 'avahan_data_type.g.dart';

@HiveType(typeId: 14)
enum AvahanDataType {
  @HiveField(0)
  track,
  @HiveField(1)
  artist,
  @HiveField(2)
  playlist,
  @HiveField(3)
  category,
  @HiveField(4)
  mood,
  @HiveField(5)
  unknown,
}