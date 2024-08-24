import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/repositories/notifications_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

@riverpod
FutureOr<List<PushNotification>> pushNotifications(
  PushNotificationsRef ref, {
  DateTime? date,
  DateTime? endDate,
  bool scheduled = false,
  bool template = false,
}) {
  return ref.read(notificationsRepositoryProvider).list(
        date: date,
        endDate: endDate,
        scheduled: scheduled,
        template: template,
      );
}
