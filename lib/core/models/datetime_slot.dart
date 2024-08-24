




class DateTimeSlot {
  final DateTime start;
  final DateTime end;
  DateTimeSlot({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }

  factory DateTimeSlot.fromMap(Map<String, dynamic> map) {
    return DateTimeSlot(
      start: DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      end: DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
    );
  }
}
