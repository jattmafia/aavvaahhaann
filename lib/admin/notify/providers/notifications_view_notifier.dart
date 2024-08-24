


import 'package:avahan/admin/notify/models/notifications_view_state.dart';
import 'package:avahan/utils/dates.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_view_notifier.g.dart';

@riverpod
class NotificationsViewNotifier extends _$NotificationsViewNotifier {
  @override
  NotificationsViewState build() {
    return NotificationsViewState(date: Dates.today);
  }



  void dateChanged(DateTime value) {
    state = state.copyWith(date: value);
  }
}