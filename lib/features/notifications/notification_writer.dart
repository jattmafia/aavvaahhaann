import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../../core/models/app_notification.dart';

class NotificationWriter {
  static Future<void> writeNotification(AppNotification notification) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${notification.messageId}.json');
    await file.writeAsString(notification.toJson());
  }

  static Future<void> clearNotifications() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .map((e) => e.path)
        .where((element) => element.endsWith('.json'))
        .map((e) => File(e))
        .toList();
    for (var file in files) {
      final json = await file.readAsString();
      if (json.contains('messageId')) {
        file.delete();
      }
    }
  }

  static Future<void> deleteNotification(String messageId) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$messageId.json');
    if (file.existsSync()) {
      file.delete();
    }
  }
}