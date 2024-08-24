class UserTrack {
  final int id;
  final String nameEn;

  UserTrack({
    required this.id,
    required this.nameEn,
  });

  factory UserTrack.fromJson(Map<String, dynamic> json) {
    return UserTrack(
      id: json['id'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
    };
  }
}

class UserTodaySongs {
  final int totalDuration;
  final int duration;
  final String rootType;
  final int rootId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int userId;
  final UserTrack userTrack;

  UserTodaySongs({
    required this.totalDuration,
    required this.duration,
    required this.rootType,
    required this.rootId,
    required this.startedAt,
    this.endedAt,
    required this.userId,
    required this.userTrack,
  });

  factory UserTodaySongs.fromJson(Map<String, dynamic> json) {
    return UserTodaySongs(
      totalDuration: json['totalDuration'],
      duration: json['duration'],
      rootType: json['rootType'],
      rootId: json['rootId'],
      startedAt: DateTime.parse(json['startedAt']),
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
      userId: json['userId'],
      userTrack: UserTrack.fromJson(json['tracks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDuration': totalDuration,
      'duration': duration,
      'rootType': rootType,
      'rootId': rootId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'userId': userId,
      'tracks': userTrack.toJson(),
    };
  }
}