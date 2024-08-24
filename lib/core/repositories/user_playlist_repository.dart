import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/user_playlist.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final userPlaylistRepositoryProvider = Provider(UserPlaylistRepository.new);

class UserPlaylistRepository {
  final Ref _ref;

  UserPlaylistRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  static const _userPlaylists = 'user_playlists';

  Future<List<UserPlaylist>> getUserPlaylists(int id) async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_userPlaylists).select().eq('createdBy', id).order('createdAt');
      return result.map((e) => UserPlaylist.fromMap(e)).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> writeUserPlaylist(UserPlaylist userPlaylist) async {
    try {
      await _client
          .from(_userPlaylists)
          .upsert(userPlaylist.toMap())
          .eq('id', userPlaylist.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }


  Future<void> deleteUserPlaylist(UserPlaylist userPlaylist) async {
    try {
      await _client.from(_userPlaylists).delete().eq('id', userPlaylist.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
