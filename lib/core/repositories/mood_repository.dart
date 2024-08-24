import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final moodRepositoryProvider = Provider(
  (ref) => MoodRepository(ref),
);

class MoodRepository {
  final Ref _ref;

  MoodRepository(this._ref);

  static const _moods = 'moods';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Mood> write(
    Mood mood, {
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
  }) async {
    try {
      if (coverEn != null) {
        final url = await _storage.upload(
          _moods,
          coverEn,
        );
        mood = mood.copyWith(coverEn: url);
      }

      if (coverHi != null) {
        final url = await _storage.upload(
          _moods,
          coverHi,
        );
        mood = mood.copyWith(coverHi: url);
      }

      if (iconEn != null) {
        final url = await _storage.upload(
          _moods,
          iconEn,
        );
        mood = mood.copyWith(iconEn: url);
      }

      if (iconHi != null) {
        final url = await _storage.upload(
          _moods,
          iconHi,
        );
        mood = mood.copyWith(iconHi: url);
      }

      final result =
          await _client.from(_moods).upsert(mood.toMap()).select().single();
      return Mood.fromMap(result as Map<String, dynamic>);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Mood>> list() async {
    try {
      final supabase.PostgrestList result = await _client.from(_moods).select();
      return result
          .map(
            (e) => Mood.fromMap(
              e
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _client.from(_moods).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_moods).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
