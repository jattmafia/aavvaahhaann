// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/utils/extensions.dart';

class Profile {
  final int id;
  final String? uuid;
  final String name;
  final String? phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final Gender gender;
  final String? country;
  final String? isoCode;
  final String? state;
  final String? stateCode;
  final String? city;
  final String? fcmToken;
  final bool premium;
  final DateTime? expiryAt;
  final DateTime? createdAt;
  final String? deviceId;
  final String? deviceName;
  final String? lang;
  final bool active;
  final String? channel;
  final bool oldPurchase;
  final String? periodType;
  final DateTime? purchasedAt;
  final bool lifetime;

  Profile({
    required this.id,
    this.uuid,
    required this.name,
    this.phoneNumber,
    this.email,
    this.city,
    this.country,
    this.dateOfBirth,
    required this.gender,
    this.state,
    this.fcmToken,
    this.createdAt,
    this.isoCode,
    this.stateCode,
    this.premium = false,
    this.expiryAt,
    this.active = true,
    this.lang,
    this.deviceId,
    this.deviceName,
    this.channel,
    this.oldPurchase = false,
    this.periodType,
    this.purchasedAt,
    this.lifetime = false,
  });

  String? get address {
    if (country == null && state == null && city == null) return null;
    final address = StringBuffer();
    if (city != null) {
      address.write(city);
    }
    if (state != null) {
      address.write(', $state');
    }
    if (country != null) {
      address.write(', $country');
    }
    return address.toString();
  }

  bool get birthday => dateOfBirth?.dateMonth == DateTime.now().dateMonth;


  bool get isGuest => uuid == null;

  Profile copyWith({
    int? id,
    String? uuid,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? dateOfBirth,
    Gender? gender,
    String? country,
    String? state,
    String? city,
    bool clearDateOfBirth = false,
    DateTime? createdAt,
    String? fcmToken,
    String? isoCode,
    String? stateCode,
    bool? premium,
    DateTime? expiryAt,
    bool? active,
    String? lang,
    String? deviceId,
    String? deviceName,
    String? channel,
    bool? oldPurchase,
    String? periodType,
    DateTime? purchasedAt,
    bool? lifetime,
    bool clearPurchasedAt = false,
    bool clearExpiryAt = false,
  }) {
    return Profile(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: clearDateOfBirth ? null : dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
      isoCode: isoCode ?? this.isoCode,
      stateCode: stateCode ?? this.stateCode,
      expiryAt: clearExpiryAt? null: expiryAt ?? this.expiryAt,
      premium: premium ?? this.premium,
      active: active ?? this.active,
      lang: lang ?? this.lang,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      channel: channel ?? this.channel,
      oldPurchase:  oldPurchase ?? this.oldPurchase,
      periodType: periodType ?? this.periodType,
      purchasedAt: clearPurchasedAt? null: purchasedAt ?? this.purchasedAt,
      lifetime: lifetime ?? this.lifetime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != 0) 'id': id,
      'uuid': uuid,
      'name': name,
      'phoneNumber': phoneNumber?.crim,
      'email': email,
      'dateOfBirth': dateOfBirth?.toUtc().toIso8601String(),
      'gender': gender.name,
      'country': country,
      'state': state,
      'city': city,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'fcmToken': fcmToken,
      'isoCode': isoCode,
      'stateCode': stateCode,
      'premium': premium,
      'expiryAt': expiryAt?.toUtc().toIso8601String(),
      'birthday': dateOfBirth?.toUtc().dateMonth,
      'active': active,
      'lang': lang,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'channel': channel,
      'oldPurchase': oldPurchase,
      'periodType': periodType,
      'purchasedAt': purchasedAt?.toUtc().toIso8601String(),
      'lifetime': lifetime,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    print(map['dateOfBirth']);
    return Profile(
      id: map['id'] as int,
      uuid: map['uuid'] as String?,
      name: map['name'] as String,
      phoneNumber: (map['phoneNumber'] as String?)?.crim,
      email: map['email'] as String?,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth']).toLocal()
          : null,
      gender: Gender.values.firstWhere(
        (element) => element.name == map['gender'],
        orElse: () => Gender.unknown,
      ),
      country: map['country'] as String?,
      state: map['state'] as String?,
      city: map['city'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt']).toLocal()
          : null,
      fcmToken: map['fcmToken'] as String?,
      isoCode: map['isoCode'] as String?,
      stateCode: map['stateCode'] as String?,
      premium: map['premium'] as bool? ?? false,
      expiryAt: map['expiryAt'] != null
          ? DateTime.parse(map['expiryAt']).toLocal()
          : null,
      active: map['active'] as bool? ?? true,
      lang: map['lang'] as String?,
      deviceId: map['deviceId'] as String?,
      deviceName: map['deviceName'] as String?,
      channel: map['channel'] as String?,
      oldPurchase: map['oldPurchase'] as bool? ?? false,
      periodType: map['periodType'] as String?,
      purchasedAt: map['purchasedAt'] != null
          ? DateTime.parse(map['purchasedAt']).toLocal()
          : null,
      lifetime: map['lifetime'] as bool? ?? false,
    );
  }

  factory Profile.empty(
    String uuid, {
    String? phoneNumber,
    String? email,
    String? name,
    String? lang,
    DateTime? expiryAt,
  }) {
    return Profile(
      uuid: uuid,
      id: 0,
      name: name ?? '',
      phoneNumber: phoneNumber,
      email: email,
      gender: Gender.unknown,
      createdAt: DateTime.now(),
      lang: lang,
      expiryAt: expiryAt,
      premium: false,
    );
  }

  bool get expired => expiryAt != null && expiryAt!.isBefore(DateTime.now());

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    final age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      return age - 1;
    }
    return age;
  }
}
