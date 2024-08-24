import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/auth/admin_login_page.dart';
import 'package:avahan/admin/dashboard/dashboard.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';

class AdminRoot extends ConsumerWidget {
  const AdminRoot({super.key});
  static const route = "/";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(cacheProvider);
    final session = ref.watch(sessionProvider);
    return session == null ? AdminLoginPage() : const AdminDashboard();
  }
}
