// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:avahan/utils/utils.dart';

class AppSessionAnalytics {
  final int sessionsCount;
  final int activeUsers;
  final Duration totalSessionDuration; 
  final double averageSessions;
  final String? country;
  final String? state;
  final String? city;
  final Color? color;
  final List? useridsList;
  
  AppSessionAnalytics({
    required this.sessionsCount,
    required this.activeUsers,
    required this.totalSessionDuration,
    required this.averageSessions,
    this.country,
    this.state,
    this.city,
    this.color,
    this.useridsList
  });

  factory AppSessionAnalytics.fromMap(Map<String, dynamic> map) {
    print(map);
    return AppSessionAnalytics(
      sessionsCount: map['sessions_count'] as int? ?? 0,
      activeUsers: map['active_users'] as int? ?? 0,
      totalSessionDuration: map['total_session_duration']  != null? Utils.parseDuration(map['total_session_duration']): Duration.zero,
      averageSessions: map['average_sessions'] as double? ?? 0,
      country: map['country'],
      state: map['state'],
      city: map['city'],
      useridsList: map['user_ids_list']
    );
  }

  AppSessionAnalytics copyWith({
    int? sessionsCount,
    int? activeUsers,
    Duration? totalSessionDuration,
    double? averageSessions,
    String? country,
    String? state,
    String? city,
    Color? color,
    List? useridsList
  }) {
    return AppSessionAnalytics(
      sessionsCount: sessionsCount ?? this.sessionsCount,
      activeUsers: activeUsers ?? this.activeUsers,
      totalSessionDuration: totalSessionDuration ?? this.totalSessionDuration,
      averageSessions: averageSessions ?? this.averageSessions,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      color: color ?? this.color,
      useridsList: useridsList ?? this.useridsList
    );
  }
}
