import 'package:avahan/core/models/play_session_analytics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_sessions_analytics_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<PlaySessionAnalytics> playSessionAnalytics(
    PlaySessionAnalyticsRef ref, DateTime startDate, DateTime endDate) {
  return ref
      .read(sessionRepositoryProvider)
      .getPlaySessionAnalytics(startDate, endDate);
}
