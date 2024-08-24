// ignore_for_file: unused_result

import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/auth/onboard_page.dart';
import 'package:avahan/features/cache/offline_dashboard.dart';
import 'package:avahan/features/dashboard/dashboard.dart';
import 'package:avahan/features/maintenance/maintenance_page.dart';
import 'package:avahan/features/profile/create_profile_page.dart';
import 'package:avahan/features/location/location_page.dart';
import 'package:avahan/utils/cache_keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';

import 'dashboard/dashboard_wrapper.dart';

class Root extends ConsumerWidget {
  const Root({super.key});
  static const route = "/";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cache = ref.read(cacheProvider);

    final masterdata = ref.read(masterDataProvider).asData?.value;

    final guest = cache.value!.getBool(CacheKeys.guest) ?? false;

    final session = ref.read(sessionProvider);
    // if (!flow.splashSeen) {
    //   return const SplashPage();
    // } else
    // if (session == null &&
    //     !(ref.read(cacheProvider).value!.getBool(CacheKeys.onboardSeen) ??
    //         false)) {
    //   if (context.large) {
    //     return const OnboardPage();
    //   }
    //   return const OnboardPage2();
    // } else
    if(masterdata?.maintenance == true){
      return const MaintenancePage();
    }
    if (session == null && !guest) {
      return const OnboardPage();
    } else {
      return Material(
        child: guest
            ? DashboardWrapper(
                child: Dashboard(),
              )
            : AsyncWidget(
                value: ref.watch(yourProfileProvider),
                onRefresh: () {
                  ref.refresh(yourProfileProvider);
                },
                data: (profile) => profile.isoCode == null
                    ? const LocationPage()
                    : DashboardWrapper(
                        child: Dashboard(),
                      ),
                error: const CreateProfilePage(),
                socketError: const OfflineDashboard(),
              ),
      );
    }
  }
}
