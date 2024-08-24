import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/repositories/artist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artists_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Artist>> artists(ArtistsRef ref) {
  return ref.read(artistRepositoryProvider).listActive();
}
