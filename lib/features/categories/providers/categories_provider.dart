import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/repositories/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<MusicCategory>> categories(CategoriesRef ref) {
  return ref.read(categoryRepositoryProvider).listActive();
}
