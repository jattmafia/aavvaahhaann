// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:avahan/core/enums/avahan_data_type.dart';

part 'play_session.g.dart';

@HiveType(typeId: 13)
class PlaySession extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int userId;
  @HiveField(2)
  final String channel;
  @HiveField(3)
  final DateTime startedAt;
  @HiveField(4)
  final DateTime? timerStartedAt;
  @HiveField(5)
  final DateTime? endedAt;
  @HiveField(6)
  final int totalDuration;
  @HiveField(7)
  final int duration;
  @HiveField(8)
  final int trackId;
  @HiveField(9)
  final AvahanDataType rootType;
  @HiveField(10)
  final int rootId;
  @HiveField(11)
  final bool syncNeeded;
  @HiveField(12)
  final String? country;
  @HiveField(13)
  final String? state;
  @HiveField(14)
  final String? city;
  @HiveField(15)
  final String? gender;
  @HiveField(16)
  final int? age;

  PlaySession({
    required this.id,
    required this.userId,
    required this.channel,
    required this.startedAt,
    this.endedAt,
    required this.totalDuration,
    required this.duration,
    required this.trackId,
    required this.rootType,
    required this.rootId,
    this.timerStartedAt,
    this.syncNeeded = true,
    this.country,
    this.state,
    this.city,
    this.age,
    this.gender,
  });

  static const android = "android";
  static const ios = "ios";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != 0) 'id': id,
      'userId': userId,
      'channel': channel,
      'startedAt': startedAt.toUtc().toIso8601String(),
      'endedAt': endedAt?.toUtc().toIso8601String(),
      'totalDuration': totalDuration,
      'duration': duration,
      'trackId': trackId,
      'rootType': rootType.name,
      'rootId': rootId,
      'age': age,
      'gender': gender,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  factory PlaySession.fromMap(Map<String, dynamic> map) {
    return PlaySession(
      id: map['id'] as int,
      userId: map['userId'] as int,
      channel: map['channel'] as String,
      startedAt: DateTime.parse(map['startedAt']).toLocal(),
      endedAt: map['endedAt'] != null
          ? DateTime.parse(map['endedAt']).toLocal()
          : null,
      totalDuration: map['totalDuration'] as int,
      duration: map['duration'] as int,
      trackId: map['trackId'] as int,
      rootType: AvahanDataType.values
          .firstWhere((element) => element.name == map['rootType']),
      rootId: map['rootId'] as int,
      age: map['age'] as int?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      gender: map['gender'] as String?,
    );
  }

  PlaySession copyWith({
    int? id,
    int? userId,
    String? channel,
    DateTime? startedAt,
    DateTime? endedAt,
    int? totalDuration,
    int? duration,
    int? trackId,
    AvahanDataType? rootType,
    int? rootId,
    DateTime? timerStartedAt,
    bool clearTimer = false,
    bool? syncNeeded,
    String? country,
    String? state,
    String? city,
    int? age,
    String? gender,
  }) {
    return PlaySession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      totalDuration: totalDuration ?? this.totalDuration,
      duration: duration ?? this.duration,
      trackId: trackId ?? this.trackId,
      rootType: rootType ?? this.rootType,
      rootId: rootId ?? this.rootId,
      timerStartedAt: clearTimer ? null : timerStartedAt ?? this.timerStartedAt,
      syncNeeded: syncNeeded ?? this.syncNeeded,
      age: age ?? this.age,
      city: city ?? this.city,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      state: state ?? this.state,
    );
  }

  @override
  String toString() {
    return 'PlaySession(id: $id, userId: $userId, channel: $channel, startedAt: $startedAt, timerStartedAt: $timerStartedAt, endedAt: $endedAt, totalDuration: $totalDuration, duration: $duration, trackId: $trackId, rootType: $rootType, rootId: $rootId, syncNeeded: $syncNeeded, country: $country, state: $state, city: $city, gender: $gender, age: $age)';
  }
}
