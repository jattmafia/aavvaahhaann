import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../providers/client_provider.dart';

final storageRepositoryProvider = Provider(StorageRepository.new);

class StorageRepository {
  final Ref _ref;

  StorageRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  Future<String> upload(String bucket, XFile file, [String? name]) async {
    late String path;
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      path = await _client.storage.from(bucket).uploadBinary(
            "${name ?? DateTime.now().millisecondsSinceEpoch}.${file.name.split('.').last}",
            bytes,
            fileOptions: const supabase.FileOptions(upsert: true),
          );
    } else {
      dynamic f = File(file.path);
      path = await _client.storage.from(bucket).upload(
            "${name ?? DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}",
            f,
            fileOptions: const supabase.FileOptions(upsert: true),
          );
    }

    final url = await _client.storage.from(bucket).createSignedUrl(
          path.split('/').last,
          const Duration(days: 365 * 100).inSeconds,
        );
    print(url);
    return url;
  }

  Future<String> uploadPlatformFile(String bucket, PlatformFile file,
      [String? name]) async {
    final bytes = file.bytes!;
    final String path = await _client.storage.from(bucket).uploadBinary(
          "${name ?? DateTime.now().millisecondsSinceEpoch}.${file.name.split('.').last}",
          bytes,
          fileOptions: const supabase.FileOptions(upsert: true),
        );

    final url = await _client.storage.from(bucket).createSignedUrl(
          path.split('/').last,
          const Duration(days: 365 * 100).inSeconds,
        );
    print(url);
    return url;
  }
}
