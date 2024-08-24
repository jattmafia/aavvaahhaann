class Guest {
  final int id;
  final String? deviceId;
  final String? deviceName;
  final String? fcmToken;
  final String? lang;
  final String? channel;
  final DateTime createdAt;
  final DateTime? expiryAt;

  Guest({
    required this.id,
    this.deviceId,
    this.deviceName,
    this.fcmToken,
    this.lang,
    this.channel,
    required this.createdAt,
    this.expiryAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != 0) 'id': id,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'fcmToken': fcmToken,
      'lang': lang,
      'createdAt': createdAt.toIso8601String(),
      'channel': channel,
      'expiryAt': expiryAt?.toIso8601String()
    };
  }

    bool get expired => expiryAt != null && expiryAt!.isBefore(DateTime.now());


  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'] as int,
      deviceId: map['deviceId'] != null ? map['deviceId'] as String : null,
      deviceName:
          map['deviceName'] != null ? map['deviceName'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      lang: map['lang'] != null ? map['lang'] as String : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      channel: map['channel'] != null ? map['channel'] as String : null,
      expiryAt: map['expiryAt'] != null
          ? DateTime.parse(map['expiryAt']).toLocal()
          : null,
    );
  }
}
