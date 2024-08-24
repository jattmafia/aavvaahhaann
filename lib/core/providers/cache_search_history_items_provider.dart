





import 'package:avahan/core/download_keys.dart';
import 'package:avahan/core/models/search_history_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cacheSearchHistoryItemsProvider =
    FutureProvider((ref) => Hive.openBox<SearchHistoryItem>(DownloadKeys.searchHistoryItems));
