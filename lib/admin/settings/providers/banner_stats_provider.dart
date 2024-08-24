

import 'package:avahan/core/models/banner_stats.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'banner_stats_provider.g.dart';

@riverpod
FutureOr<Map<String, BannerStats>> bannerStats(BannerStatsRef ref, List<String> bannerIds) {
  return ref.read(masterDataRepositoryProvider).getBannerStats(bannerIds);
}