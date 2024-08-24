import 'dart:developer';

import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final trackRepositoryProvider = Provider(
  (ref) => TrackRepository(ref),
);

class TrackRepository {
  final Ref _ref;

  TrackRepository(this._ref);

  static const _tracks = 'tracks';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Track> write(
    Track track, {
    XFile? coverEn,
    XFile? coverHi,
    XFile? iconEn,
    XFile? iconHi,
    PlatformFile? file,
  }) async {
    try {
      if (coverEn != null) {
        final url = await _storage.upload(
          _tracks,
          coverEn,
        );
        track = track.copyWith(coverEn: url);
      }

      if (coverHi != null) {
        final url = await _storage.upload(
          _tracks,
          coverHi,
        );
        track = track.copyWith(coverHi: url);
      }

      if (iconEn != null) {
        final url = await _storage.upload(
          _tracks,
          iconEn,
        );
        track = track.copyWith(iconEn: url);
      }

      if (iconHi != null) {
        final url = await _storage.upload(
          _tracks,
          iconHi,
        );
        track = track.copyWith(iconHi: url);
      }

      if (file != null) {
        final url = await _storage.uploadPlatformFile(
          _tracks,
          file,
        );
        final size = file.size;
        final type = file.extension;
        final duration = await AudioPlayer().setUrl(url);
        track = track.copyWith(url: url, fileSize: size, fileType: type,duration: duration?.inSeconds);
      }

      final result =
          await _client.from(_tracks).upsert(track.toMap()).select().single();
      return Track.fromMap(result);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Track>> list() async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_tracks).select();
      return result
          .map(
            (e) => Track.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<Track> read(int id) async {
    try {
     
      final result = await _client.from(_tracks).select().eq('id', id).single();
      return Track.fromMap(result);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<Track>> listActive({
    int? categoryId,
    int? artistId,
    int? moodId,
    List<int>? ids,
    String? searchKey,
  }) async {
    try {
      var query = _client.from(_tracks).select().eq('active', true);

      if (categoryId != null) {
        query = query.contains('categories', [categoryId]);
      }

      if (artistId != null) {
        query = query.contains('artists', [artistId]);
      }

      if (moodId != null) {
        query = query.contains('moods', [moodId]);
      }

      if (ids != null) {
        query = query.inFilter('id', ids);
      }
      // if(searchKey != null){
      //   query = query.ilike('nameEn', "%$searchKey%");
      // }
      if (searchKey != null) {
        print(searchKey);
        query = query.ilike('searchKey', '%$searchKey%');
      }

      final supabase.PostgrestList result = await query;

      return result
          .map(
            (e) => Track.fromMap(
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
      await _client.from(_tracks).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_tracks).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateDuration(int id, int duration) async {
    try {
      await _client.from(_tracks).update({
        'duration': duration,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
