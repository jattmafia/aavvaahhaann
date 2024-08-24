import 'package:avahan/core/models/admin_user.dart';
import 'package:avahan/core/repositories/admin_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final adminUsersProvider = FutureProvider<List<AdminUser>>(
  (ref) => ref.read(adminRepositoryProvider).listAdminUsers(),
);
