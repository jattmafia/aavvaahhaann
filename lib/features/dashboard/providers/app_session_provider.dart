import 'package:avahan/core/models/app_session.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/providers/cache_app_sessions_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final appSessionProvider = Provider(AppSessionProvider.new);

class AppSessionProvider {
  final Ref _ref;

  AppSessionProvider(this._ref) {
    if(!kIsWeb && kReleaseMode){
      newSession(true);
    }
  }

  Box<AppSession> get _box => _ref.read(cacheAppSessionsProvider).value!;

  Profile? get _profile => _ref.read(yourProfileProvider).asData?.value;

  AudioPlayer get _player => _ref.read(playerProvider);

  void endSession() async {
    print("end session");
    if (!_player.playing && kReleaseMode) {
      final currentSession = _box.values.last;
      final updated = currentSession.copyWith(
        endedAt: DateTime.now(),
      );
      canNew = true;
      await _box.putAt(_box.length - 1, updated);
      syncSessions();
    }
  }

  bool canNew = false;

  void newSession([bool init = false]) async {
    print("new session");
    if(kReleaseMode){
      if (!_player.playing && (canNew || init)) {
        canNew = false;
        await _box.add(
          AppSession(
            id: 0,
            userId: _profile?.id,
            channel: AppSession.android,
            createdAt: DateTime.now(),
            age: _profile?.age,
            city: _profile?.city,
            country: _profile?.country,
            gender: _profile?.gender.name,
            state: _profile?.state,
          ),
        );
        syncSessions();
      }
    }
  }

  void syncSessions() async {
    if(kReleaseMode){
      print("syncing app sessions");
      final repository = _ref.read(sessionRepositoryProvider);
      Box<AppSession> box = _ref.read(cacheAppSessionsProvider).value!;
      final sessions = box.values.toList();

      print(sessions.length);

      if (sessions.isNotEmpty) {
        final notSynced = sessions.where((element) => element.id == 0).toList();

        if (notSynced.isNotEmpty) {
          try {
            final syncedInList =
                sessions.where((element) => element.id != 0).toList();

            for (var element in syncedInList) {
              await repository.updateAppSession(element);
            }

            final inserted = await repository.syncAppSessions(notSynced);
            final last = box.getAt(box.length - 1);
            await box.clear();
            box.add(last!.copyWith(id: inserted.id));
          } catch (e) {
            debugPrint("$e");
          }
        } else {
          final last = box.getAt(0);
          if (last != null) {
            print('last');
            try {
              await repository.updateAppSession(last);
              print('updated: $last');
            } catch (e) {
              print(e);
            }
          }
        }
      }
    }
  }
}
