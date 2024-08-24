// ignore_for_file: public_member_api_docs, sort_constructors_first


class NotificationsViewState {
  final DateTime date;
  NotificationsViewState({
    required this.date,
  });

  NotificationsViewState copyWith({
    DateTime? date,
  }) {
    return NotificationsViewState(
      date: date ?? this.date,
    );
  }
}
