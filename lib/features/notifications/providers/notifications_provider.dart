import 'dart:io';

import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/models/app_notification.dart';

final notificationsProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) async {
  final directory = await getApplicationDocumentsDirectory();
  List<AppNotification> notifications = [];
  final files = directory
      .listSync()
      .map((e) => e.path)
      .where((element) => element.endsWith('.json'))
      .map((e) => File(e))
      .toList();
  for (var file in files) {
    final json = await file.readAsString();
    if (json.contains('messageId')) {
      final notification = AppNotification.fromJson(json);
      notifications.add(notification);
    }
  }
  return notifications;
});


  // final int id;
  // final String title;
  // final String body;
  // final String? image;
  // final AvahanDataType? type;
  // final List<int>? ids;
  // final DateTime? clearAt;
  // final DateTime createdAt;
  // final DateTime? updatedAt;
  // final int? ageMin;
  // final int? ageMax;
  // final Gender? gender;
  // final Lang? lang;
  // final LocObj? country;
  // final LocObj? state;
  // final String? city;
  // final bool? premium;
  // final bool? expired;
  // final bool? birthday;
  // final List<int>? users;
  // final String? topic;
  // final NotifyFrequency? frequency;
  // final DateTime? date;
  // final int? day;
  // final String? weekday;
  // final DateTime? time;
  // final List<NotifyResult> results;
  // final bool active;
  // final bool template;
  // final String? link;