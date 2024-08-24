

import 'package:avahan/core/models/play_session_analytics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_sessions_analytics_of_user_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<PlaySessionAnalytics> playSessionAnalyticsOfUser(
    PlaySessionAnalyticsOfUserRef ref, int userId) {
  return ref
      .read(sessionRepositoryProvider).getPlaySessionAnalyticsOfUser(userId);
}
