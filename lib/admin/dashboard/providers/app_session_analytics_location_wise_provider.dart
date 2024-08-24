import 'package:avahan/core/models/app_session_analytics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_session_analytics_location_wise_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<AppSessionAnalytics>> appSessionAnalyticsLocationWise(
    AppSessionAnalyticsLocationWiseRef ref, DateTime startDate, DateTime endDate) {
  return ref
      .read(sessionRepositoryProvider)
      .getAppSessionAnalyticsLocationWise(startDate, endDate);
}
