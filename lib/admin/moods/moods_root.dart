import 'package:avahan/admin/artists/artist_page.dart';
import 'package:avahan/admin/artists/artists_page.dart';
import 'package:avahan/admin/artists/write_artist_page.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/moods/mood_page.dart';
import 'package:avahan/admin/moods/moods_page.dart';
import 'package:avahan/admin/moods/write_mood_page.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminMoodsRoot extends HookConsumerWidget {
  const AdminMoodsRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    return Navigator(
      pages: [
        const MaterialPage(
          child: AdminMoodsPage(),
        ),
        if (state.selected != null)
          MaterialPage(
              child: AdminMoodPage(
            mood: state.selected as Mood,
          )),
        if (state.write)
          MaterialPage(
            child: WriteMoodPage(
              initial: state.selected as Mood?,
            ),
          ),

        // if (state.profile != null)
        //   MaterialPage(
        //     key: const ValueKey('profile'),
        //     child: AdminProfilePage(
        //       profile: state.profile!,
        //       role: role,
        //     ),
        //   ),
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

        if (state.write) {
          notifier.closeWrite();
        } else if (state.selected != null) {
          notifier.show(null);
        }
        return true;
      },
    );
  }
}
