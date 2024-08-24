import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/repositories/playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlists_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Playlist>> playlists(PlaylistsRef ref) {
  return ref.read(playlistRepositoryProvider).listActive();
}
