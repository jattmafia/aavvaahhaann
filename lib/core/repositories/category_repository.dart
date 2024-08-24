import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;


final categoryRepositoryProvider = Provider(
  (ref) => CategoryRepository(ref),
);

class CategoryRepository {
  final Ref _ref;

  CategoryRepository(this._ref);

  static const _categories = 'categories';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<MusicCategory> write(
    MusicCategory category, {
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
  }) async {
    try {
      if (coverEn != null) {
        final url = await _storage.upload(
          _categories,
          coverEn,
        );
        category = category.copyWith(coverEn: url);
      }
      
      if (coverHi != null) {
        final url = await _storage.upload(
          _categories,
          coverHi,
        );
        category = category.copyWith(coverHi: url);
      }

      if (iconEn != null) {
        final url = await _storage.upload(
          _categories,
          iconEn,
        );
        category = category.copyWith(iconEn: url);
      }

      if (iconHi != null) {
        final url = await _storage.upload(
          _categories,
          iconHi,
        );
        category = category.copyWith(iconHi: url);
      }

      final result = await _client
          .from(_categories)
          .upsert(category.toMap())
          .select()
          .single();
      return MusicCategory.fromMap(result as Map<String, dynamic>);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<MusicCategory>> list() async {
    try {
      final supabase.PostgrestList result = await _client.from(_categories).select();
      return result
          .map(
            (e) => MusicCategory.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }



    Future<List<MusicCategory>> listActive() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_categories).select().eq('active', true);
      return result
          .map(
            (e) => MusicCategory.fromMap(
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
      await _client.from(_categories).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_categories).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
