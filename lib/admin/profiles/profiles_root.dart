import 'package:avahan/admin/profiles/profile_page.dart';
import 'package:avahan/admin/profiles/providers/selected_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/profiles/profiles_page.dart';

class AdminProfilesRoot extends HookConsumerWidget {
  const AdminProfilesRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectedProfileProvider);    
    final notifier = ref.read(selectedProfileProvider.notifier);
    return Navigator(
      pages: [
        const MaterialPage(
          child: AdminProfilesPage(),
        ),
        if (state != null)
          MaterialPage(
            key: const ValueKey('profile'),
            child: AdminProfilePage(
              profile: state,
            ),
          ),
        // if (state.secondProfile != null)
        //   MaterialPage(
        //     key: const ValueKey('profile-2'),
        //     child: AdminProfilePage(
        //       profile: state.secondProfile!,
        //       role: state.secondRole!,
        //     ),
        //   ),
        // if (state.loan != null)
        //   MaterialPage(
        //     key: const ValueKey('loan'),
        //     child: AdminLoanPage(loan: state.loan!),
        //   ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (state != null) {
          notifier.state = null;
        }

        return true;
      },
    );
  }
}
