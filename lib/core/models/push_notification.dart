// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/loc_obj.dart';

class PushNotification {
  final int id;
  final String title;
  final String body;
  final String? image;
  final AvahanDataType? type;
  final List<int>? ids;
  final DateTime? clearAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? ageMin;
  final int? ageMax;
  final Gender? gender;
  final Lang? lang;
  final LocObj? country;
  final LocObj? state;
  final String? city;
  final bool? premium;
  final bool? expired;
  final bool? birthday;
  final List<int>? users;
  final String? topic;
  final NotifyFrequency? frequency;
  final DateTime? date;
  final int? day;
  final String? weekday;
  final DateTime? time;
  final List<NotifyResult> results;
  final bool active;
  final bool template;
  final String? link;
  final String timezone;
  final String? channel;


  PushNotification({
    this.id = 0,
    required this.title,
    required this.body,
    this.image,
    this.type,
    this.ids,
    this.clearAt,
    required this.createdAt,
    this.updatedAt,
    this.ageMax,
    this.ageMin,
    this.gender,
    this.lang,
    this.country,
    this.state,
    this.city,
    this.premium,
    this.expired,
    this.birthday,
    this.users,
    this.topic,
    this.frequency,
    this.date,
    this.day,
    this.weekday,
    this.time,
    this.results = const [],
    this.active = true,
    this.template = false,
    this.link,
    required this.timezone,
    this.channel,
  });

  bool get grouped => topic != null || (ageMax != null || ageMin != null || gender != null || lang != null || country != null || state != null || city != null || premium != null || expired != null || birthday != null || users != null);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != 0) 'id': id,
      'title': title,
      'body': body,
      'image': image,
      'type': type?.name,
      'ids': ids,
      'clearAt': clearAt?.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
      'ageMax': ageMax,
      'ageMin': ageMin,
      'gender': gender?.name,
      'lang': lang?.name,
      'country': country?.toMap(),
      'state': state?.toMap(),
      'city': city,
      'premium': premium,
      'expired': expired,
      'birthday': birthday,
      'users': users,
      'topic': topic,
      'frequency': frequency?.name,
      'date': date?.toIso8601String(),
      'day': day,
      'weekday': weekday,
      'time': time?.toUtc().toIso8601String().split('T').last,
      'results': results.map((x) => x.toMap()).toList(),
      'active': active,
      'template': template,
      'link': link,
      'timezone': timezone,
      'channel': channel,
    };
  }

  Map<String, dynamic> toFiltersMap() {
    return <String, dynamic>{
      'ageMax': ageMax,
      'ageMin': ageMin,
      'gender': gender?.name,
      'lang': lang?.name,
      'country': country?.name,
      'state': state?.name,
      'city': city,
      'premium': premium,
      'expired': expired,
      'birthday': birthday,
      'channel': channel,
    };
  }

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      type: AvahanDataType.values
          .cast<AvahanDataType?>()
          .firstWhere((e) => e?.name == map['type'], orElse: () => null),
      ids: map['ids'] != null ? List<int>.from((map['ids'] as Iterable)) : null,
      clearAt: map['clearAt'] != null
          ? DateTime.parse(map['clearAt']).toLocal()
          : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']).toLocal()
          : null,
      ageMax: map['ageMax'] as int?,
      ageMin: map['ageMin'] as int?,
      gender: Gender.values.cast<Gender?>().firstWhere(
          (element) => element?.name == map['gender'],
          orElse: () => null),
      lang: map['lang'] != null
          ? Lang.values.firstWhere((element) => element.name == map['lang'])
          : null,
      country: map['country'] != null ? LocObj.fromMap(map['country']) : null,
      state: map['state'] != null ? LocObj.fromMap(map['state']) : null,
      city: map['city'] as String?,
      premium: map['premium'] as bool?,
      expired: map['expired'] as bool?,
      birthday: map['birthday'] as bool?,
      users: map['users'] != null
          ? List<int>.from((map['users'] as Iterable))
          : null,
      topic: map['topic'] as String?,
      frequency: NotifyFrequency.values
          .cast<NotifyFrequency?>()
          .firstWhere((e) => e?.name == map['frequency'], orElse: () => null),
      date: map['date'] != null ? DateTime.parse(map['date']).toLocal() : null,
      day: map['day'] as int?,
      weekday: map['weekday'] as String?,
      time: map['time'] != null
          ? DateTime.parse('2021-01-01T${map['time']}').toLocal()
          : null,
      results: List<NotifyResult>.from(
        (map['results'] as Iterable).map<NotifyResult>(
          (x) => NotifyResult.fromMap(x as Map<String, dynamic>),
        ),
      ),
      active: map['active'] as bool,
      template: map['template'] as bool? ?? false,
      link: map['link'] as String?,
      timezone: map['timezone'] as String? ?? 'Asia/Kolkata',
      channel: map['channel'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PushNotification.fromJson(String source) =>
      PushNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  PushNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? image,
    bool clearImage = false,
    AvahanDataType? type,
    bool clearType = false,
    List<int>? ids,
    bool clearIds = false,
    DateTime? clearAt,
    bool clearClearAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? ageMin,
    bool clearAgeMin = false,
    int? ageMax,
    bool clearAgeMax = false,
    Gender? gender,
    bool clearGender = false,
    Lang? lang,
    bool clearLang = false,
    LocObj? country,
    bool clearCountry = false,
    LocObj? state,
    bool clearState = false,
    String? city,
    bool clearCity = false,
    bool? premium,
    bool clearPremium = false,
    bool? expired,
    bool clearExpired = false,
    bool? birthday,
    bool clearBirthday = false,
    List<int>? users,
    bool clearUsers = false,
    String? topic,
    bool clearTopic = false,
    NotifyFrequency? frequency,
    bool clearFrequency = false,
    DateTime? date,
    bool clearDate = false,
    int? day,
    bool clearDay = false,
    String? weekday,
    bool clearWeekday = false,
    DateTime? time,
    bool clearTime = false,
    List<NotifyResult>? results,
    bool? active,
    String? link,
    bool clearLink = false,
    String? timezone,
    String? channel,
    bool clearChannel = false,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      image: clearImage ? null : (image ?? this.image),
      type: clearType ? null : (type ?? this.type),
      ids: clearIds ? null : (ids ?? this.ids),
      clearAt: clearClearAt ? null : (clearAt ?? this.clearAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ageMin: clearAgeMin ? null : (ageMin ?? this.ageMin),
      ageMax: clearAgeMax ? null : (ageMax ?? this.ageMax),
      gender: clearGender ? null : (gender ?? this.gender),
      lang: clearLang ? null : (lang ?? this.lang),
      country: clearCountry ? null : (country ?? this.country),
      state: clearState ? null : (state ?? this.state),
      city: clearCity ? null : (city ?? this.city),
      premium: clearPremium ? null : (premium ?? this.premium),
      expired: clearExpired ? null : (expired ?? this.expired),
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      users: clearUsers ? null : (users ?? this.users),
      topic: clearTopic ? null : (topic ?? this.topic),
      frequency: clearFrequency ? null : (frequency ?? this.frequency),
      date: clearDate ? null : (date ?? this.date),
      day: clearDay ? null : (day ?? this.day),
      weekday: clearWeekday ? null : (weekday ?? this.weekday),
      time: clearTime ? null : (time ?? this.time),
      results: results ?? this.results,
      active: active ?? this.active,
      link: clearLink? null: link ?? this.link,
      timezone: timezone ?? this.timezone,
      channel: clearChannel? null: channel ?? this.channel,
      
    );
  }
}

class NotifyResult {
  final int success;
  final int failure;
  final DateTime? createdAt;
  NotifyResult({
    required this.success,
    required this.failure,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'failure': failure,
      'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }

  factory NotifyResult.fromMap(Map<String, dynamic> map) {
    return NotifyResult(
      success: map['success'] as int? ?? 0,
      failure: map['failure'] as int? ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'])?.toLocal(),
    );
  }
}
