import 'dart:math';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/root_play_session_metrics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_play_session_analytics_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<RootPlaySessionMetrics> rootPlaySessionMetrics(
    RootPlaySessionMetricsRef ref,
    int id,
    AvahanDataType type,
    DateTime start,
    DateTime end) {
  return ref.read(sessionRepositoryProvider).getRootPlaySessionAnalytics(
        type,
        id,
        start,
        end,
      );
}
