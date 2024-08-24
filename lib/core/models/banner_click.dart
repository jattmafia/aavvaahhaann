// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BannerClick {
  final String bannerId;
  final int? userId;
  final String? country;
  final String? state;
  final String? city;
  final String? gender;
  final int? age;
  final String? channel;


  BannerClick({
    required this.bannerId,
    required this.userId,
    this.country,
    this.state,
    this.city,
    this.gender,
    this.age,
    this.channel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bannerId': bannerId,
      'userId': userId,
      'country': country,
      'state': state,
      'city': city,
      'gender': gender,
      'age': age,
      'channel': channel,
    };
  }

  factory BannerClick.fromMap(Map<String, dynamic> map) {
    return BannerClick(
      bannerId: map['bannerId'] as String,
      userId: map['userId'] as int,
      country: map['country'] != null ? map['country'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      age: map['age'] != null ? map['age'] as int : null,
      channel: map['channel'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerClick.fromJson(String source) => BannerClick.fromMap(json.decode(source) as Map<String, dynamic>);
}
