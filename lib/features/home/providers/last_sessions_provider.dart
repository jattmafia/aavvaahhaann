


import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/repositories/session_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'last_sessions_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<MapEntry<AvahanDataType,int>>> lastSessions(LastSessionsRef ref) {
  final userId = ref.watch(yourProfileProvider.select((value) => value.asData?.value.id));
  if (userId == null) {
    return [];
  }
  return ref.read(sessionRepositoryProvider).getLastSessions(userId);
}