import 'package:avahan/core/models/user_today_songs.dart';
import 'package:avahan/core/repositories/userplay_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'userplay_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<UserTodaySongs>> userSongList(
    UserSongListRef ref, String id , String date) {
  return ref
      .read(userplayRepository).getuserPlay(id: id, date: date);
}