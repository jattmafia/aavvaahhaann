import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/playlist/playlist_page.dart';
import 'package:avahan/admin/playlist/playlists_page.dart';
import 'package:avahan/admin/playlist/write_playlist_page.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminPlaylistRoot extends HookConsumerWidget {
  const AdminPlaylistRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    return Navigator(
      pages: [
        const MaterialPage(
          child: AdminPlayListsPage(),
        ),
        if (state.selected != null)
          MaterialPage(
            child: AdminPlaylistPage(
              playlist: state.selected as Playlist,
            ),
          ),
        if (state.write)
          MaterialPage(
            child: WritePlaylistPage(
              initial: state.selected as Playlist?,
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
