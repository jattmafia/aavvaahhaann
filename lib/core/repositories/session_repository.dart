import 'dart:developer';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/app_session_analytics.dart';
import 'package:avahan/core/models/app_session.dart';
import 'package:avahan/core/models/play_session.dart';
import 'package:avahan/core/models/play_session_analytics.dart';
import 'package:avahan/core/models/root_play_session_metrics.dart';
import 'package:avahan/core/models/track_metrics.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final sessionRepositoryProvider = Provider(SessionRepository.new);

class SessionRepository {
  final Ref _ref;

  SessionRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  Future<PlaySession> syncPlaySessions(List<PlaySession> sessions) async {
    try {
      print("sessions: ${sessions.length} syncing");
      final result = await _client
          .from('play_sessions')
          .insert(sessions.map((e) => e.toMap()).toList())
          .select('*');
      
      print("result: ${result.length}");

      return PlaySession.fromMap(result.last);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updatePlaySession(PlaySession session) async {
    try {
      await _client
          .from('play_sessions')
          .update(
            session.toMap(),
          )
          .eq('id', session.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<AppSession> syncAppSessions(List<AppSession> sessions) async {
    try {
      final result = await _client
          .from('app_sessions')
          .insert(sessions.map((e) => e.toMap()).toList())
          .select('*');

      return AppSession.fromMap(result.last);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateAppSession(AppSession session) async {
    try {
      await _client
          .from('app_sessions')
          .update(
            session.toMap(),
          )
          .eq('id', session.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<AppSessionAnalytics> getAppSessionAnalytics(
      DateTime startDate, DateTime endDate) async {
    try {
      final Iterable result =
          await _client.rpc('calculate_session_metrics_new', params: {
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
      });
      if (result.isEmpty) {
        return Future.error('No data found');
      } else {
        log("new result $result");
        return AppSessionAnalytics.fromMap(result.first);
      }
    } on Exception catch (e) {
            log("this is session error $e");

      return Future.error(e.parse);
    }
  }

  Future<List<AppSessionAnalytics>> getAppSessionAnalyticsLocationWise(
      DateTime startDate, DateTime endDate) async {
    try {
      final Iterable result =
          await _client.rpc('calculate_location_session_metrics', params: {
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
      });
      log(result.toString());
      return result.map((e) => AppSessionAnalytics.fromMap(e)).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  // Future<int> getPlaySesssionsCount(
  //     DateTime startDate, DateTime endDate) async {
  //   try {
  //     final result = await _client
  //         .from('play_sessions')
  //         .select('id')
  //         .gte('created_at', startDate.toIso8601String())
  //         .lte('created_at', endDate.toIso8601String())
  //         .count();
  //     return result.count;
  //   } on Exception catch (e) {
  //     return Future.error(e.parse);
  //   }
  // }

  Future<PlaySessionAnalytics> getPlaySessionAnalytics(
      DateTime startDate, DateTime endDate) async {
        log(startDate.toString());
        log(endDate.toString());
    try {
      final Iterable result = await _client.rpc(
        'calculate_play_session_metrics',
        params: {
          'start_date': startDate.toUtc().toIso8601String(),
          'end_date': endDate.toUtc().toIso8601String(),
        },
      );
      if (result.isEmpty) {
        return Future.error('No data found');
      } else {
        return PlaySessionAnalytics.fromMap(result.first);
      }
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<PlaySessionAnalytics> getPlaySessionAnalyticsOfUser(int userId) async {
    try {
      final Iterable result = await _client.rpc(
        'calculate_play_session_metrics_of_user',
        params: {
          'user_id': userId,
        },
      );
      if (result.isEmpty) {
        return Future.error('No data found');
      } else {
        return PlaySessionAnalytics.fromMap(result.first);
      }
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<MapEntry<AvahanDataType, int>>> getLastSessions(
      int userId) async {
    try {
      final res = await _client.rpc(
        'get_last_sessions',
        params: {
          'uid': userId,
        },
      );
      return (res as Iterable)
          .cast<Map<String, dynamic>>()
          .map(
            (e) => MapEntry(
              AvahanDataType.values.firstWhere(
                (element) =>
                    element.name == e['roottype'] ||
                    element.name == e['rootType'],
                orElse: () => AvahanDataType.unknown,
              ),
              (e['rootid'] ?? e['rootId']) as int? ?? 0,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<RootPlaySessionMetrics> getRootPlaySessionAnalytics(
    AvahanDataType type,
    int id,
    DateTime startDate,
    DateTime endDate,
  ) async {
    print({'root_type': type.name,
          'root_id': id,
          'start_date': startDate.toUtc().toIso8601String(),
          'end_date': endDate.toUtc().toIso8601String(),});
    try {
      final Iterable result = await _client.rpc(
        'get_play_session_metrics_of_root',
        params: {
          'root_type': type.name,
          'root_id': id,
          'start_date': startDate.toUtc().toIso8601String(),
          'end_date': endDate.toUtc().toIso8601String(),
        },
      );
      if (result.isEmpty) {
        return Future.error('No data found');
      } else {
        return RootPlaySessionMetrics.fromMap(result.first);
      }
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<TrackMetrics> getTrackMetrics(
    int id,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final Iterable result = await _client.rpc(
        'calculate_track_metrics',
        params: {
          'track_id': id,
          'start_date': startDate.toUtc().toIso8601String(),
          'end_date': endDate.toUtc().toIso8601String(),
        },
      );
      if (result.isEmpty) {
        return Future.error('No data found');
      } else {
        return TrackMetrics.fromMap(result.first);
      }
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
