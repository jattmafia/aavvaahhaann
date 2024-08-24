import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/repositories/mood_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'moods_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Mood>> moods(MoodsRef ref) {
  return ref.read(moodRepositoryProvider).list();
}
