import 'package:avahan/core/models/library_item.dart';
import 'package:avahan/core/repositories/library_item_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_items_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<LibraryItem>> libraryItems(LibraryItemsRef ref) {
  final id =
      ref.watch(yourProfileProvider.select((value) => value.asData?.value.id));
  if (id == null) {
    return Future.error('user-not-logined');
  }
  return ref.read(libraryItemRepositoryProvider).getLibraryItems(id);
}
