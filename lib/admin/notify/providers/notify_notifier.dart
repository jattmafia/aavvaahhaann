import 'dart:developer';

import 'package:avahan/admin/notify/models/notify_state.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/repositories/functions_repository.dart';
import 'package:avahan/core/repositories/notifications_repository.dart';
import 'package:avahan/core/topics.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notify_notifier.g.dart';

@riverpod
class NotifyNotifier extends _$NotifyNotifier {
  @override
  NotifyState build(PushNotification? notification) {
    final n = notification ??
        PushNotification(
          title: "",
          body: "",
          createdAt: DateTime.now(),
          topic: Topics.all,
          timezone: 'Asia/Kolkata',
        );
    return NotifyState(
      notification: n.copyWith(
        results: n.id == 0 ? [] : null,
      ),
      loading: false,
      topic: n.topic != null,
    );
  }

  void titleChanged(String v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        title: v,
      ),
    );
  }

  void bodyChanged(String v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        body: v,
      ),
    );
  }

  void imageChanged(String? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        image: v,
        clearImage: v == null,
      ),
    );
  }

  void fileChanged(XFile? file) {
    state = state.copyWith(xFile: file, clearFile: file == null);
  }

  void modeChanged(bool topic) {
    state = state.copyWith(
      topic: topic,
      notification: state.notification.copyWith(
        clearAgeMax: topic,
        clearAgeMin: topic,
        clearCountry: topic,
        clearState: topic,
        clearCity: topic,
        clearGender: topic,
        clearLang: topic,
        clearPremium: topic,
        clearExpired: topic,
        clearBirthday: topic,
        clearUsers: topic,
        clearTopic: !topic,
      ),
    );
  }

  void topicChanged(String v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        topic: v,
      ),
    );
  }

  void timezoneChanged(String v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        timezone: v,
        time: state.notification.time?.fromTimezone(state.notification.timezone).forTimezone(v),
      ),
    );
  }

  void ageMinMaxChanged(int? min, int? max) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        ageMin: min,
        ageMax: max,
        clearAgeMin: min == null,
        clearAgeMax: max == null,
      ),
    );
  }

  void countryChanged(LocObj? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        country: v,
        clearCountry: v == null,
        clearState: true,
        clearCity: true,
      ),
    );
  }

  void stateChanged(LocObj? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        state: v,
        clearState: v == null,
        clearCity: true,
      ),
    );
  }

  void cityChanged(String? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        city: v,
        clearCity: v == null,
      ),
    );
  }

  void genderChanged(Gender? gender) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        gender: gender,
        clearGender: gender == null,
      ),
    );
  }

  void langChanged(Lang? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        lang: v,
        clearLang: v == null,
      ),
    );
  }

  void channelChanged(String? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        channel: v,
        clearChannel: v == null,
      ),
    );
  }

  void premiumChanged(bool? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        premium: v,
        clearPremium: v == null,
      ),
    );
  }

  void expiredChanged(bool? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        expired: v,
        clearExpired: v == null,
      ),
    );
  }

  void birthdayChanged(bool? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        birthday: v,
        clearBirthday: v == null,
      ),
    );
  }

  void userToggle(int id) {
    final users = state.notification.users ?? [];
    final result = users.contains(id)
        ? users.where((element) => element != id).toList()
        : [...users, id];
    state = state.copyWith(
      notification: state.notification.copyWith(
        users: result,
        clearUsers: result.isEmpty,
      ),
    );
  }

  void usersAdd(List<int> ids) {
    final users = state.notification.users ?? [];
    final result = [...users, ...ids];
    state = state.copyWith(
      notification: state.notification.copyWith(
        users: result.toSet().toList(),
        clearUsers: result.isEmpty,
      ),
    );
  }

  void frequencyChanged(NotifyFrequency? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
          frequency: v,
          clearFrequency: v == null,
          clearTime: true,
          clearDay: true,
          clearWeekday: true,
          clearDate: true,
          timezone: state.notification.timezone ?? 'Asia/Kolkata'),
    );
  }

  void dateChanged(DateTime? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        date: v,
        clearDate: v == null,
      ),
    );
  }

  void dayChanged(int? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        day: v,
        clearDay: v == null,
      ),
    );
  }

  void weekdayChanged(String? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        weekday: v,
        clearWeekday: v == null,
      ),
    );
  }

  void timeChanged(DateTime? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        time: v,
        clearTime: v == null,
      ),
    );
  }

  void activeChanged(bool? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        active: v,
      ),
    );
  }

  void clearAtChanged(DateTime? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        clearAt: v,
        clearClearAt: v == null,
      ),
    );
  }

  void typeChanged(AvahanDataType? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        type: v,
        clearType: v == null,
        clearIds: true,
        clearLink: v != AvahanDataType.unknown,
      ),
    );
  }

  void linkChanged(String? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        link: v,
        clearLink: v == null,
      ),
    );
  }

  void idsChanged(List<int>? v) {
    state = state.copyWith(
      notification: state.notification.copyWith(
        ids: v,
        clearIds: v == null,
      ),
    );
  }

  void idToggled(int? v) {
    final list = state.notification.ids ?? [];
    final result = list.contains(v)
        ? list.where((element) => element != v).toList()
        : [...list, if (v != null) v];
    state = state.copyWith(
      notification: state.notification.copyWith(
        ids: result,
        clearIds: result.isEmpty,
      ),
    );
  }

  FunctionsRepository get _functions => ref.read(functionsRepositoryProvider);

  Future<void> create(bool schedule) async {
    state = state.copyWith(loading: true);
    PushNotification updated = state.notification;
    try {
      await ref
          .read(notificationsRepositoryProvider)
          .write(updated, image: state.xFile);
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
