import 'package:avahan/admin/tracks/models/write_track_state.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/lang.dart';

import 'package:avahan/core/models/track.dart';

import 'package:avahan/core/repositories/track_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_track_notifier.g.dart';

@riverpod
class WriteTrack extends _$WriteTrack {
  @override
  WriteTracksState build(Track? tracks) {
    return WriteTracksState(
      loading: false,
      track: tracks ?? Track.empty(),
    );
  }

  // return WriteTracksState(loading: false, tracks: tracks??Track.empty(),)

  TrackRepository get _repository => ref.read(trackRepositoryProvider);

  bool get isEdit => tracks != null;

  void nameChanged(String value, Lang lang) {
    state = state = state.copyWith(
      track: state.track.copyWith(
        nameEn: lang == Lang.en ? value : null,
        nameHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void descriptionChanged(String value, Lang lang) {
    state = state = state.copyWith(
      track: state.track.copyWith(
        descriptionEn: lang == Lang.en ? value : null,
        descriptionHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void lyricsChanged(String value, Lang lang) {
    state = state = state.copyWith(
      track: state.track.copyWith(
        lyricsEn: lang == Lang.en ? value : null,
        lyricsHi: lang == Lang.hi ? value : null,
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
      track: state.track.copyWith(
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
      track: state.track.copyWith(
        coverEn: lang == Lang.en ? value : null,
        coverHi: lang == Lang.hi ? value : null,
        clearCoverEn: value == null && lang == Lang.en,
        clearCoverHi: value == null && lang == Lang.hi,
      ),
      clearCoverEn: lang == Lang.en,
      clearCoverHi: lang == Lang.hi,
    );
  }

  void fileChanged(PlatformFile? value) {
    state = state = state.copyWith(
      file: value,
      clearFile: value == null,
    );
  }

  void toggleArtist(int id) {
    if (state.track.artists.contains(id)) {
      state = state.copyWith(
        track: state.track.copyWith(
          artists:
              state.track.artists.where((element) => element != id).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        track: state.track.copyWith(
          artists: [...state.track.artists, id],
        ),
      );
    }
  }

  void toggleCategory(int id) {
    if (state.track.categories.contains(id)) {
      state = state.copyWith(
        track: state.track.copyWith(
          categories:
              state.track.categories.where((element) => element != id).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        track: state.track.copyWith(
          categories: [...state.track.categories, id],
        ),
      );
    }
  }

  void toggleMood(int id) {
    if (state.track.moods.contains(id)) {
      state = state.copyWith(
        track: state.track.copyWith(
          moods: state.track.moods.where((element) => element != id).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        track: state.track.copyWith(
          moods: [...state.track.moods, id],
        ),
      );
    }
  }

  void toggleTag(String value) {
    if (state.track.tags.contains(value)) {
      state = state.copyWith(
        track: state.track.copyWith(
          tags: state.track.tags.where((element) => element != value).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        track: state.track.copyWith(
          tags: [...state.track.tags, value],
        ),
      );
    }
  }

  void groupIdChanged(String? value) {
    state = state.copyWith(
      track: state.track.copyWith(
        groupId: value,
        clearGroupId:  value == null,
      ),
    );
  }

  void groupIndexChanged(int? value) {
    state = state.copyWith(
      track: state.track.copyWith(
        groupIndex: value,
        clearGroupIndex: value == null,
      ),
    );
  }

  void linksChanged(List<String>? links) {
    state = state.copyWith(
      track: state.track.copyWith(
        links: links,
      ),
    );
  }

  void durationChanged(int value) {
    print('duration: $value');
    state = state.copyWith(
      track: state.track.copyWith(
        duration: value,
      ),
    );
  }

  Future<void> write(bool publish) async {
    state = state.copyWith(loading: true);
    try {
      final result = await _repository.write(
        state.track.copyWith(active: publish ? true : null).clearEmpty().copyWith(
          createdAt:  isEdit? null: DateTime.now(),
          updatedAt: isEdit? DateTime.now(): null,
          createdBy: isEdit? null: 1,
          updatedBy: isEdit? 1: null,
        ),
        coverEn: state.coverEn,
        coverHi: state.coverHi,
        iconEn: state.iconEn,
        iconHi: state.iconHi,
        file: state.file,
      );
      ref.read(adminTracksNotifierProvider.notifier).writeTrack(result);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
