import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final artistRepositoryProvider = Provider(
  (ref) => ArtistRepository(ref),
);

class ArtistRepository {
  final Ref _ref;

  ArtistRepository(this._ref);

  static const _artists = 'artists';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Artist> write(
    Artist artists, {
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
  }) async {
    try {
      if (coverEn != null) {
        final url = await _storage.upload(
          _artists,
          coverEn,
        );
        artists = artists.copyWith(coverEn: url);
      }

      if (coverHi != null) {
        final url = await _storage.upload(
          _artists,
          coverHi,
        );
        artists = artists.copyWith(coverHi: url);
      }

      if (iconEn != null) {
        final url = await _storage.upload(
          _artists,
          iconEn,
        );
        artists = artists.copyWith(iconEn: url);
      }

      if (iconHi != null) {
        final url = await _storage.upload(
          _artists,
          iconHi,
        );
        artists = artists.copyWith(iconHi: url);
      }

      final result = await _client
          .from(_artists)
          .upsert(artists.toMap())
          .select()
          .single();
      return Artist.fromMap(result as Map<String, dynamic>);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Artist>> list() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_artists).select();
      return result
          .map(
            (e) => Artist.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }


    Future<List<Artist>> listActive() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_artists).select().eq('active', true);
      return result
          .map(
            (e) => Artist.fromMap(
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
      await _client.from(_artists).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_artists).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
