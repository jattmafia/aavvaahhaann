








import 'package:avahan/core/download_keys.dart';
import 'package:avahan/core/models/app_session.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cacheAppSessionsProvider = FutureProvider(
    (ref) => Hive.openBox<AppSession>(DownloadKeys.appSessions));
