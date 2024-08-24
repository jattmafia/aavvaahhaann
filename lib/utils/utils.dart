import 'package:avahan/utils/dates.dart';
import 'package:flutter/material.dart';

class Utils {
  static const ageRangeSet = {
    (min: 15, max: 20),
    (min: 21, max: 30),
    (min: 31, max: 45),
    (min: 45, max: null),
  };

  static String labelByAgeRange(({int min, int? max}) e) =>
      "${e.min}${e.max != null ? "-${e.max}" : "+"}";

  static String getRangeByAge(int age) {
    if (age <= 20) {
      return "a1520";
    } else if (age <= 30) {
      return "a2130";
    } else if (age <= 45) {
      return "a3145";
    } else {
      return "a45plus";
    }
  }

  static Duration parseDuration(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    List<String> secondsAndMicros = parts[2].split('.');
    int seconds = int.parse(secondsAndMicros[0]);
    int micros = int.parse(secondsAndMicros[1].padRight(6, '0'));

    return Duration(
        hours: hours, minutes: minutes, seconds: seconds, microseconds: micros);
  }

  static Map<String, DateTimeRange> dateTimeRanges = {
    "Today": DateTimeRange(
      start: Dates.today,
      end: Dates.today.add(const Duration(days: 1)).subtract(
            const Duration(microseconds: 1),
          ),
    ),
    "Yesterday": DateTimeRange(
      start: Dates.today.subtract(const Duration(days: 1)),
      end: Dates.today.subtract(
        const Duration(microseconds: 1),
      ),
    ),
    "Last 7 Days": DateTimeRange(
      start: Dates.today.subtract(const Duration(days: 7)),
      end: Dates.today.add(const Duration(days: 1)).subtract(
            const Duration(microseconds: 1),
          ),
    ),
    "Last 30 Days": DateTimeRange(
      start: Dates.today.subtract(const Duration(days: 30)),
      end: Dates.today.add(const Duration(days: 1)).subtract(
            const Duration(microseconds: 1),
          ),
    ),
    "This Month": DateTimeRange(
      start: Dates.firstDayOfMonth,
      end: Dates.lastDayOfMonth.add(const Duration(days: 1)).subtract(
            const Duration(microseconds: 1),
          ),
    ),
  };
}
