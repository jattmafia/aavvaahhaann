import 'dart:developer';

import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/core/models/play_session.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_manager_provider.dart';
import 'package:avahan/core/providers/cache_play_sessions_provider.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/subscriptions/track_access_provider.dart';
import 'package:avahan/features/tracks/models/play_state.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'play_notifier_provider.g.dart';

@Riverpod(keepAlive: true)
class PlayNotifier extends _$PlayNotifier {



  @override
  PlayState build() {
    // _player.stream

    Box<PlaySession> box = ref.read(cachePlaySessionsProvider).value!;

    _player.playbackEventStream.listen((event) async {
      if (busy) {
        return;
      }
      busy = true;
      if (event.duration != null && event.currentIndex != null) {
        final track = state.session!.tracks[event.currentIndex!];

        final currentSession = box.isEmpty ? null : box.getAt(box.length - 1);

        if (currentSession?.trackId != track.id) {
          if (currentSession != null) {
            final updated = currentSession.copyWith(
              clearTimer: true,
              duration: currentSession.duration +
                  (currentSession.timerStartedAt
                              ?.difference(DateTime.now())
                              .abs() ??
                          Duration.zero)
                      .inSeconds,
              endedAt: DateTime.now(),
            );
            await box.putAt(box.length - 1, updated);
          }
          if (_player.playing) {
            await box.add(
              PlaySession(
                id: 0,
                userId: profile.id,
                channel: defaultTargetPlatform.name,
                startedAt: DateTime.now(),
                totalDuration: event.duration!.inSeconds,
                duration: event.updatePosition.inSeconds,
                trackId: track.id,
                rootType: root.key,
                rootId: root.value,
                timerStartedAt: DateTime.now(),
                syncNeeded: true,
                age: profile.age,
                city: profile.city,
                state: profile.state,
                country: profile.country,
                gender: profile.gender.name,
              ),
            );
            syncSessions();
          } else {}
        } else {
          final updated = currentSession!.copyWith(
            duration: currentSession.duration +
                (currentSession.timerStartedAt
                            ?.difference(DateTime.now())
                            .abs() ??
                        Duration.zero)
                    .inSeconds,
            timerStartedAt: DateTime.now(),
            clearTimer: !_player.playing,
            syncNeeded: true,
          );
          await box.putAt(box.length - 1, updated);
        }
      }
      busy = false;
    });
    return PlayState();
  }

  bool busy = false;

  void syncSessions() async {
    print("&&&&&&&&&&&& syncing sessions");
    try {
      final repository = ref.read(sessionRepositoryProvider);

      Box<PlaySession> box = ref.read(cachePlaySessionsProvider).value!;
      final sessions = box.values.toList();

      if (sessions.isNotEmpty) {
        final notSynced = sessions.where((element) => element.id == 0).toList();
        print("notSynced: ${notSynced.length}");

        if (notSynced.isNotEmpty) {
          try {
            final syncedInList =
                sessions.where((element) => element.id != 0).toList();

            for (var element in syncedInList) {
              await repository.updatePlaySession(element);
            }

            final inserted = await repository.syncPlaySessions(notSynced);
            final last = box.getAt(box.length - 1);
            if (last?.trackId == inserted.trackId &&
                (last?.startedAt.isAtSameMomentAs(inserted.startedAt) ??
                    false)) {
              await box.clear();
              box.add(last!.copyWith(id: inserted.id, syncNeeded: false));
            }
            print('inserted: $inserted');
          } catch (e) {
            print(e);
          }
        } else {
          final last = box.getAt(0);
          if (last != null && last.syncNeeded) {
            try {
              await repository.updatePlaySession(last);
              print('updated: $last');
            } catch (e) {
              print(e);
            }
          }
        }
      }
    } catch (e) {
      print("-------$e-------");
    }
  }

  MapEntry<AvahanDataType, int> get root {
    late int rootId;
    late AvahanDataType rootType;
    if (state.session!.data is Track) {
      rootType = AvahanDataType.track;
      rootId = (state.session!.data as Track).id;
    } else if (state.session!.data is Playlist) {
      rootType = AvahanDataType.playlist;
      rootId = (state.session!.data as Playlist).id;
    } else if (state.session!.data is Artist) {
      rootType = AvahanDataType.artist;
      rootId = (state.session!.data as Artist).id;
    } else if (state.session!.data is MusicCategory) {
      rootType = AvahanDataType.category;
      rootId = (state.session!.data as MusicCategory).id;
    } else if (state.session!.data is Mood) {
      rootType = AvahanDataType.mood;
      rootId = (state.session!.data as Mood).id;
    } else {
      rootType = AvahanDataType.unknown;
      rootId = 0;
    }
    return MapEntry(rootType, rootId);
  }

  AudioPlayer get _player => ref.read(playerProvider);

  Profile get profile => ref.read(yourProfileProvider).value!;

  Lang get lang => ref.read(langProvider);



  Track track(int index) => state.session!.tracks[index];

  void startPlaySession(PlayGroup session) async {
    final tracks = [
      session.start,
      ...session.tracks.sublist(session.tracks.indexOf(session.start) + 1),
      ...session.tracks.sublist(0, session.tracks.indexOf(session.start))
    ].where((element) => ref.read(trackAccessProvider(element.id))).toList();
    state = state.copyWith(
      session: session.copyWith(
        tracks: tracks,
      ),
    );

    final box = ref.read(cacheTracksProvider).value!;
    Map<int, String> files = {};
    for (var track in tracks) {
      final cacheTrack = box.get('track_${track.id}');
      if (cacheTrack != null) {
        final cacheManager = ref.read(cacheManagerProvider);
        try {
          final file = await cacheManager.getFileStream(cacheTrack.url).first;
          if (file is FileInfo) {
            files[track.id] = file.file.path;
          }
        } catch (e) {
          debugPrint("$e");
        }
      }
    }
    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: tracks
            .map(
              (track) => ClippingAudioSource(
                start: Duration.zero,
                tag: MediaItem(
                  id: "${track.id}",
                  title: track.name(lang),
                  artUri: Uri.parse(track.icon(lang)),
                  album: track.name(lang),
                  artist: track.artistsLabelRef(ref, lang),
                ),
                child: files[track.id] != null
                    ? AudioSource.file(files[track.id]!)
                    : AudioSource.uri(
                        Uri.parse(track.url),
                      ),
              ),
            )
            .toList(),
      ),
    );
    await _player.play();
  }

  void pausePlaySession() async {
    await _player.pause();
  }

  void replayPlaySession() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  void resumePlaySession() async {
    await _player.play();
  }

  void nextPlaySession() async {
    _player.seekToNext();
    
  }

  void previousPlaySession() async {
   
    
    _player.seekToPrevious();
  }


  Future<void>  setloop() async {
    if(_player.loopMode == LoopMode.off)
    {
    await   _player.setLoopMode(LoopMode.one);
    }else{
    await  _player.setLoopMode(LoopMode.off);
    }
   
  }


}
