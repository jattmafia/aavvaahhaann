

import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/core/repositories/user_playlist_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_playlists_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<UserPlaylist>> userPlaylists(UserPlaylistsRef ref) {
  final id = ref.watch(yourProfileProvider.select((value) => value.asData?.value.id));
  if(id == null){
    return Future.error('user-not-logined');
  }
  return ref.read(userPlaylistRepositoryProvider).getUserPlaylists(id);
}