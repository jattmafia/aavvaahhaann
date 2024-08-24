



import 'package:avahan/core/download_keys.dart';
import 'package:avahan/core/models/track.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cacheTracksProvider = FutureProvider((ref) => Hive.openBox<Track>(DownloadKeys.tracks));