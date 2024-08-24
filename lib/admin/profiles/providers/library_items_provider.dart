
import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/repositories/library_item_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_items_provider.g.dart';

@riverpod
FutureOr<List<LibraryItem>> adminLibraryItems(AdminLibraryItemsRef ref, int id) {
  return ref.read(libraryItemRepositoryProvider).getLibraryItems(id);
}
