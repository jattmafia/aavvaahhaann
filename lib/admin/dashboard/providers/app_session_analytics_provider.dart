import 'package:avahan/core/models/app_session_analytics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_session_analytics_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<AppSessionAnalytics> appSessionAnalytics(AppSessionAnalyticsRef ref, DateTime startDate, DateTime endDate) {
  return ref.read(sessionRepositoryProvider).getAppSessionAnalytics(startDate, endDate);
}




