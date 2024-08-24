class Dates {
  static List<String> get weekdays =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  static DateTime get now => DateTime.now();
  static DateTime get today => DateTime(now.year, now.month, now.day);

  static DateTime get firstDayOfMonth => DateTime(now.year, now.month, 1);

  static DateTime get lastDayOfMonth => DateTime(now.year, now.month + 1, 0);

  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
