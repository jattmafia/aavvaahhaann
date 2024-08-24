


import 'package:avahan/core/repositories/track_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/track.dart';

part 'track_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Track> track(TrackRef ref, int id) {
  return ref.read(trackRepositoryProvider).read(id);
}