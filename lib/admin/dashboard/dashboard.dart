// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/admin/data/data_page.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/notify/notify_calendar_page.dart';
import 'package:avahan/admin/notify/notify_page.dart';
import 'package:avahan/admin/profiles/dashboardroot_page.dart';
import 'package:avahan/admin/profiles/profiles_page.dart';
import 'package:avahan/admin/profiles/profiles_root.dart';
import 'package:avahan/admin/settings/settings_page.dart';
import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:avahan/admin/users/users_page.dart';
import 'package:avahan/core/models/admin_user.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/features/auth/reset_password_page.dart';
import 'package:avahan/features/components/lang_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/dashboard/widgets/statistics_view.dart';
import 'package:avahan/features/components/svg_icon.dart';
import 'package:timezone/standalone.dart' as tz;

import 'package:avahan/utils/extensions.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MenuItem {
  final String label;
  final Widget leading;

  MenuItem({
    required this.label,
    required this.leading,
  });
}

class AdminDashboard extends HookConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardNotifierProvider);

    final user = ref.read(sessionProvider)!.user;

    useEffect(() {
      ref.read(adminArtistsNotifierProvider);
      tz.initializeTimeZone();
      return () {
        
      };
    }, []);

    void openResetPassword() {
      showDialog(
        context: context,
        builder: (context) => const Dialog(
          child: SizedBox(
            width: 500,
            height: 500,
            child: ResetPasswordPage(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/logo.png", height: 24),
            const SizedBox(width: 8),
            Text(
              "Avahan".toUpperCase(),
              style: context.style.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: context.scheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          const LangSegmentedButton(),
          const SizedBox(width: 16),
          Material(
            color: context.scheme.primary.withOpacity(0.2),
            shape: const CircleBorder(),
            child: PopupMenuButton<String>(
              // onSelected: (v) async {},
              icon: Icon(Icons.person_outline_rounded),
              offset: const Offset(10, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    onTap: null,
                    value: 'user',
                    child: Row(
                      children: [
                        Icon(Icons.person_outlined),
                        SizedBox(width: 4),
                        Text(user.email ?? ''),
                      ],
                    )),
                PopupMenuItem<String>(
                  onTap: () async {
                    try {
                      await ref.read(authNotifierProvider.notifier).logout();
                      context.go();
                    } catch (e) {
                      context.error(e);
                    }
                  },
                  value: 'logout',
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 4),
                      Text('Logout'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  onTap: () async {
                    openResetPassword();
                  },
                  value: 'password',
                  child: const Row(
                    children: [
                      Icon(Icons.password_rounded),
                      SizedBox(width: 4),
                      Text('Change Password'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Material(
        color: context.scheme.surface,
        surfaceTintColor: context.scheme.surfaceTint,
        elevation: 1,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (context.size_.width > 1240) const AppDrawer(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.scheme.surfaceVariant,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Scaffold(
                        drawer: context.size_.width > 1240
                            ? null
                            : const AppDrawer(),
                        body: switch (state.view) {
                          AdminView.dashboard => const DashboardrootPage(),
                          AdminView.listeners => const AdminProfilesRoot(),
                          AdminView.data => const DataPage(),
                          AdminView.settings => const AdminSettingsPage(),
                          AdminView.notify => const NotifyCalendarPage(),
                          AdminView.users => const AdminUsersPage(),
                          _ => const SizedBox(),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardNotifierProvider);
    final notifier = ref.read(adminDashboardNotifierProvider.notifier);
    print('----');

    print(ref.read(adminUsersProvider).asData?.value);
    final views = [
      AdminView.dashboard,
     if(ref.permissions.viewListners || ref.permissions.updateListners) AdminView.listeners,
      AdminView.data,
     if(ref.permissions.manageSettings) AdminView.settings,
     if(ref.permissions.manageNotifications) AdminView.notify,
     if(ref.permissions.manageUsers) AdminView.users,
    ];

    return Container(
      width: 100,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        border: Border.all(
          color: context.scheme.surfaceVariant,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            ...views.map((e) {
              final isSelected = e == state.view;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: switch (e) {
                  AdminView.dashboard => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Dashboard",
                      icon: const Icon(
                        LucideIcons.squareGantt,
                        size: 28,
                      ),
                    ),
                  AdminView.listeners => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Listeners",
                      icon: const Icon(
                        LucideIcons.users,
                        size: 28,
                      ),
                    ),
                  AdminView.data => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Data",
                      icon: const Icon(
                        LucideIcons.database,
                        size: 28,
                      ),
                    ),
                  AdminView.notify => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Notify",
                      icon: const Icon(
                        LucideIcons.send,
                        size: 28,
                      ),
                    ),
                  AdminView.settings => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Settings",
                      icon: const Icon(
                        LucideIcons.settings,
                        size: 28,
                      ),
                    ),
                  AdminView.users => DashboardTab(
                      isSelected: isSelected,
                      onTap: () {
                        notifier.viewChanged(e);
                      },
                      label: "Users",
                      icon: const Icon(
                        Icons.group_outlined,
                        size: 28,
                      ),
                    ),
                  _ => const SizedBox(),
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.label,
    this.asset,
    this.icon,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String label;
  final String? asset;
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 23 / 21,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Material(
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? context.scheme.primaryContainer
              : context.scheme.surface,
          surfaceTintColor: isSelected
              ? context.scheme.primaryContainer
              : context.scheme.surfaceTint,
          elevation: 1,
          shadowColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ??
                  SvgIcon(
                    asset ?? "",
                    size: 32,
                  ),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.style.labelSmall!.copyWith(
                  letterSpacing: -0.5,
                  color: isSelected
                      ? context.scheme.onPrimaryContainer
                      : context.scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
