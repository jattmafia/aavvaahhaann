import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cacheManagerProvider = Provider<CacheManager>(
  (ref) {
    const key = 'libCachedSongs';
    return CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 360),
        maxNrOfCacheObjects: 120,
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
  },
);