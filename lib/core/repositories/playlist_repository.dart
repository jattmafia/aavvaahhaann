import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final playlistRepositoryProvider = Provider(
  (ref) => PlaylistRepository(ref),
);

class PlaylistRepository {
  final Ref _ref;

  PlaylistRepository(this._ref);

  static const _playlists = 'playlists';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Playlist> write(
    Playlist playlist, {
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
  }) async {
    try {
      if (coverEn != null) {
        final url = await _storage.upload(
          _playlists,
          coverEn,
        );
        playlist = playlist.copyWith(coverEn: url);
      }

      if (coverHi != null) {
        final url = await _storage.upload(
          _playlists,
          coverHi,
        );
        playlist = playlist.copyWith(coverHi: url);
      }

      if (iconEn != null) {
        final url = await _storage.upload(
          _playlists,
          iconEn,
        );
        playlist = playlist.copyWith(iconEn: url);
      }

      if (iconHi != null) {
        final url = await _storage.upload(
          _playlists,
          iconHi,
        );
        playlist = playlist.copyWith(iconHi: url);
      }

      final result = await _client
          .from(_playlists)
          .upsert(playlist.toMap())
          .select()
          .single();
      return Playlist.fromMap(result as Map<String, dynamic>);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Playlist>> list() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_playlists).select();
      return result
          .map(
            (e) => Playlist.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Playlist>> listActive() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_playlists).select().eq('active', true);
      return result
          .map(
            (e) => Playlist.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _client.from(_playlists).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_playlists).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
