import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_count_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<({int total, int premium, int lifetime})> usersCount(
    UsersCountRef ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final f1 = repo.totalProfiles();
  final f2 = repo.totalPremiumProfiles();
  final f3 = repo.totalLifetimeProfiles();
  final list = await Future.wait([f1, f2, f3]);
  return (total: list[0], premium: list[1], lifetime: list[2]);
}
