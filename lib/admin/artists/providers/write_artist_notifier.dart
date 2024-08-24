import 'package:avahan/admin/artists/models/write_artist_state.dart';
import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/core/enums/artist_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/repositories/artist_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_artist_notifier.g.dart';

@riverpod
class WriteArtist extends _$WriteArtist {
  @override
  WriteArtistState build(Artist? artist) {
    return WriteArtistState(
      loading: false,
      artist: artist ?? Artist.empty(),
    );
  }

  ArtistRepository get _repository => ref.read(artistRepositoryProvider);

  bool get isEdit => artist != null;

  void nameChanged(String value, Lang lang) {
    state = state = state.copyWith(
      artist: state.artist.copyWith(
        nameEn: lang == Lang.en ? value : null,
        nameHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void descriptionChanged(String value, Lang lang) {
    state = state = state.copyWith(
      artist: state.artist.copyWith(
        descriptionEn: lang == Lang.en ? value : null,
        descriptionHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void coverChanged(XFile? value, Lang lang) {
    state = state = state.copyWith(
      coverEn: lang == Lang.en ? value : null,
      coverHi: lang == Lang.hi ? value : null,
    );
  }

  void iconChanged(XFile? value, Lang lang) {
    state = state = state.copyWith(
      iconEn: lang == Lang.en ? value : null,
      iconHi: lang == Lang.hi ? value : null,
    );
  }

  void coverRemoved(Lang lang) {
    state = state = state.copyWith(
      clearCoverEn: lang == Lang.en,
      clearCoverHi: lang == Lang.hi,
    );
  }

  void iconUrlChanged(String? value, Lang lang) {
    state = state = state.copyWith(
      artist: state.artist.copyWith(
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
      artist: state.artist.copyWith(
        coverEn: lang == Lang.en ? value : null,
        coverHi: lang == Lang.hi ? value : null,
        clearCoverEn: value == null && lang == Lang.en,
        clearCoverHi: value == null && lang == Lang.hi,
      ),
      clearCoverEn: lang == Lang.en,
      clearCoverHi: lang == Lang.hi,
    );
  }

  void iconRemoved(Lang lang) {
    state = state = state.copyWith(
      clearIconEn: lang == Lang.en,
      clearIconHi: lang == Lang.hi,
    );
  }

  void typeChanged(ArtistType value) {
    state = state = state.copyWith(
      artist: state.artist.copyWith(type: value),
    );
  }

  void toggleCategory(int id) {
    if (state.artist.categories.contains(id)) {
      state = state.copyWith(
        artist: state.artist.copyWith(
          categories: state.artist.categories
              .where((element) => element != id)
              .toList(),
        ),
      );
    } else {
      state = state.copyWith(
        artist: state.artist.copyWith(
          categories: [...state.artist.categories, id],
        ),
      );
    }
  }

  Future<void> write(bool publish) async {
    state = state.copyWith(loading: true);
    try {
      final result = await _repository.write(
        state.artist.copyWith(active: publish ? true : null).clearEmpty().copyWith(
          createdAt:  isEdit? null: DateTime.now(),
          updatedAt:  isEdit? DateTime.now(): null,
          createdBy: isEdit? null: 1,
          updatedBy: isEdit? 1: null,
        ),
        coverEn: state.coverEn,
        coverHi: state.coverHi,
        iconEn: state.iconEn,
        iconHi: state.iconHi,
      );
      ref.read(adminArtistsNotifierProvider.notifier).writeArtist(result);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
