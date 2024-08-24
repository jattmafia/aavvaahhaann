import 'package:avahan/admin/playlist/models/write_playlist_state.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/repositories/playlist_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_playlist_notifier.g.dart';

@riverpod
class WritePlaylist extends _$WritePlaylist {
  @override
  WritePlayListState build(Playlist? playlist) {
    return WritePlayListState(
      loading: false,
      playlist: playlist ?? Playlist.empty(),
    );
  }

  PlaylistRepository get _repository => ref.read(playlistRepositoryProvider);

  bool get isEdit => playlist != null;

  void nameChanged(String value, Lang lang) {
    state = state = state.copyWith(
      playlist: state.playlist.copyWith(
        nameEn: lang == Lang.en ? value : null,
        nameHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void descriptionChanged(String value, Lang lang) {
    state = state = state.copyWith(
      playlist: state.playlist.copyWith(
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

  void coverUrlChanged(String? value, Lang lang) {
    state = state = state.copyWith(
      playlist: state.playlist.copyWith(
        coverEn: lang == Lang.en ? value : null,
        coverHi: lang == Lang.hi ? value : null,
        clearCoverEn: value == null && lang == Lang.en,
        clearCoverHi: value == null && lang == Lang.hi,
      ),
      clearCoverEn: lang == Lang.en,
      clearCoverHi: lang == Lang.hi,
    );
  }

  void iconUrlChanged(String? value, Lang lang) {
    state = state = state.copyWith(
      playlist: state.playlist.copyWith(
        iconEn: lang == Lang.en ? value : null,
        iconHi: lang == Lang.hi ? value : null,
        clearIconEn: value == null && lang == Lang.en,
        clearIconHi: value == null && lang == Lang.hi,
      ),
      clearIconEn: lang == Lang.en,
      clearIconHi: lang == Lang.hi,
    );
  }

  void toggleTrack(int id) {
    if (state.playlist.tracks.contains(id)) {
      state = state.copyWith(
        playlist: state.playlist.copyWith(
          tracks:
              state.playlist.tracks.where((element) => element != id).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        playlist: state.playlist.copyWith(
          tracks: [...state.playlist.tracks, id],
        ),
      );
    }
  }

  void toggleTag(String value) {
    if (state.playlist.tags.contains(value)) {
      state = state.copyWith(
        playlist: state.playlist.copyWith(
          tags:
              state.playlist.tags.where((element) => element != value).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        playlist: state.playlist.copyWith(
          tags: [...state.playlist.tags, value],
        ),
      );
    }
  }

  Future<void> write(bool publish) async {
    state = state.copyWith(loading: true);
    try {
      final result = await _repository.write(
        state.playlist.copyWith(active: publish ? true : null).clearEmpty().copyWith(
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
      ref.read(adminPlaylistNotifierProvider.notifier).writePlaylist(result);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
