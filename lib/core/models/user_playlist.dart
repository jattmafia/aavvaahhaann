import 'package:hive/hive.dart';

part 'user_playlist.g.dart';

@HiveType(typeId: 5)
class UserPlaylist extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final int createdBy;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final List<int> tracks;


  UserPlaylist({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.name,
    required this.tracks,
  });

  UserPlaylist copyWith({
    int? id,
    DateTime? createdAt,
    int? createdBy,
    String? name,
    List<int>? tracks,
    String? image,
  }) {
    return UserPlaylist(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
     if (id != 0)  'id': id,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'name': name,
      'tracks': tracks,
    };
  }

  factory UserPlaylist.fromMap(Map<String, dynamic> map) {
    return UserPlaylist(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      createdBy: map['createdBy'] as int,
      name: map['name'] as String,
      tracks: List<int>.from(
        (map['tracks'] as Iterable<dynamic>).map((e) => e as int)
      ),
    );
  }
}
