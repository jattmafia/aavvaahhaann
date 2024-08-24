



import 'package:avahan/core/models/track_metrics.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track_metrics_provider.g.dart';

@riverpod
FutureOr<TrackMetrics> trackMetrics(TrackMetricsRef ref, int id, DateTime start, DateTime end) {
  return ref.read(sessionRepositoryProvider).getTrackMetrics(id, start, end);
}