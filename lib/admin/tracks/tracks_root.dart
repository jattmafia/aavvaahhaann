import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/tracks/track_page.dart';
import 'package:avahan/admin/tracks/tracks_page.dart';
import 'package:avahan/admin/tracks/write_track_page.dart';

import 'package:avahan/core/models/track.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminTrackRoot extends HookConsumerWidget {
  const AdminTrackRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    return Navigator(
      pages: [
        const MaterialPage(
          child: AdminTracksPage(),
        ),
        if (state.selected != null)
          MaterialPage(
              child: AdminTrackPage(
            track: state.selected as Track,
          )),
        if (state.write)
          MaterialPage(
            child: WriteTrackPage(
              initial: state.selected as Track?,
            ),
          ),
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
