// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'app_session.g.dart';

@HiveType(typeId: 16)
class AppSession extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int? userId;
  @HiveField(2)
  final String channel;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? endedAt;
  @HiveField(5)
  final String? country;
  @HiveField(6)
  final String? state;
  @HiveField(7)
  final String? city;
  @HiveField(8)
  final String? gender;
  @HiveField(9)
  final int? age;

  AppSession({
    required this.id,
    required this.userId,
    required this.channel,
    required this.createdAt,
    this.endedAt,
    this.country,
    this.state,
    this.age,
    this.city,
    this.gender,
  });

  static const android = "android";
  static const ios = "ios";

  AppSession copyWith({
    int? id,
    int? userId,
    String? channel,
    DateTime? createdAt,
    DateTime? endedAt,
    String? country,
    String? state,
    String? city,
    String? gender,
    int? age,
  }) {
    return AppSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    if(id != 0)  'id': id,
      'userId': userId,
      'channel': channel,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'endedAt': endedAt?.toUtc().toIso8601String(),
      'country': country,
      'state': state,
      'city': city,
      'gender': gender,
      'age': age,
    };
  }

  factory AppSession.fromMap(Map<String, dynamic> map) {
    return AppSession(
      id: map['id'] as int,
      userId: map['userId'] != null ? map['userId'] as int : null,
      channel: map['channel'] as String,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      endedAt: map['endedAt'] != null
          ? DateTime.parse(map['endedAt']).toLocal()
          : null,
      country: map['country'] != null ? map['country'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      age: map['age'] != null ? map['age'] as int : null,
    );
  }
}
