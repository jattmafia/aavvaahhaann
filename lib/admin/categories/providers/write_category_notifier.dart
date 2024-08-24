import 'package:avahan/admin/categories/models/write_category_state.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/repositories/category_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_category_notifier.g.dart';

@riverpod
class WriteCategory extends _$WriteCategory {
  @override
  WriteCategoryState build(MusicCategory? category) {
    return WriteCategoryState(
      loading: false,
      category: category ?? MusicCategory.empty(),
    );
  }

  CategoryRepository get _repository => ref.read(categoryRepositoryProvider);

  bool get isEdit => category != null;

  void nameChanged(String value, Lang lang) {
    state = state = state.copyWith(
      category: state.category.copyWith(
        nameEn: lang == Lang.en ? value : null,
        nameHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void descriptionChanged(String value, Lang lang) {
    state = state = state.copyWith(
      category: state.category.copyWith(
        descriptionEn: lang == Lang.en ? value : null,
        descriptionHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void coverChanged(XFile? value, Lang lang) {
    state = state = state.copyWith(
      coverEn: lang == Lang.en ? value : null,
      coverHi: lang == Lang.hi ? value : null,
      clearCoverEn: value == null && lang == Lang.en,
      clearCoverHi: value == null && lang == Lang.hi,
    );
  }

  void iconChanged(XFile? value, Lang lang) {
    state = state = state.copyWith(
      iconEn: lang == Lang.en ? value : null,
      iconHi: lang == Lang.hi ? value : null,
      clearIconEn: value == null && lang == Lang.en,
      clearIconHi: value == null && lang == Lang.hi,
    );
  }

  void iconUrlChanged(String? value, Lang lang) {
    state = state = state.copyWith(
      category: state.category.copyWith(
        iconEn: lang == Lang.en ? value : null,
        iconHi: lang == Lang.hi ? value : null,
        clearIconEn: value == null && lang == Lang.en,
        clearIconHi: value == null && lang == Lang.hi,
      ),
      clearIconEn: lang == Lang.en,
      clearIconHi: lang == Lang.hi,
    );
  }

  void coverUrlChanged(String? value, Lang lang) {
    state = state = state.copyWith(
      category: state.category.copyWith(
        coverEn: lang == Lang.en ? value : null,
        coverHi: lang == Lang.hi ? value : null,
        clearCoverEn: value == null && lang == Lang.en,
        clearCoverHi: value == null && lang == Lang.hi,
      ),
      clearCoverEn: lang == Lang.en,
      clearCoverHi: lang == Lang.hi,
    );
  }


  Future<void> write(bool publish) async {
    state = state.copyWith(loading: true);
    try {
      final result = await _repository.write(
        state.category.copyWith(active: publish ? true : null).clearEmpty()
            .copyWith(
              createdAt: isEdit ? null : DateTime.now(),
              updatedAt: isEdit ? DateTime.now() : null,
              createdBy: isEdit ? null : 1,
              updatedBy: isEdit ? 1 : null,
            ),
        coverEn: state.coverEn,
        coverHi: state.coverHi,
        iconEn: state.iconEn,
        iconHi: state.iconHi,
      );
      ref.read(adminCategoriesNotifierProvider.notifier).writeCategory(result);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
