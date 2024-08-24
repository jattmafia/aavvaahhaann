

import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final libraryItemRepositoryProvider = Provider(LibraryItemRepository.new);

class LibraryItemRepository {
  final Ref _ref;

  LibraryItemRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  static const _libraryItems = 'library_items';

  Future<List<LibraryItem>> getLibraryItems(int id) async {
    try {
      final supabase.PostgrestList result =
          await _client.from(_libraryItems).select().eq('createdBy', id);

      return result.map((e) => LibraryItem.fromMap(e)).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> writeLibraryItem(LibraryItem libraryItem) async {
    try {
      await _client
          .from(_libraryItems)
          .upsert(libraryItem.toMap())
          .eq('id', libraryItem.id);
    } on Exception catch (e) {
            print(e);

      return Future.error(e.parse);
    }
  }

  Future<void> deleteLibraryItem(LibraryItem libraryItem) async {
    try {
      await _client.from(_libraryItems).delete().eq('id', libraryItem.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
  
}
