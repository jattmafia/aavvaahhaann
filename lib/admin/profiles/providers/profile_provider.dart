import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Profile> adminProfile(AdminProfileRef ref, int id) {
  return ref.read(profileRepositoryProvider).getProfile(id);
}
