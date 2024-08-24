// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/admin/artists/artists_root.dart';
import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/cateogories_root.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/admin/data/data_root.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/moods_root.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/playlist_root.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/root.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/tracks_root.dart';

import 'package:flutter/material.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DataMenuItem {
  final String label;
  final int count;
  final AdminView view;

  DataMenuItem({
    required this.label,
    required this.count,
    required this.view,
  });
}

class DataPage extends ConsumerWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = [
     if(ref.permissions.viewCategories) AdminView.categories,
    if (ref.permissions.viewArtists)  AdminView.artists,
   if (ref.permissions.viewPlaylists)   AdminView.playlists,
   if (ref.permissions.viewTracks)   AdminView.tracks,
   if (ref.permissions.viewMoods)  AdminView.moods,
    ];

    final list = views.map(
      (e) {
        return switch (e) {
          AdminView.categories => DataMenuItem(
              label: 'Categories',
              count:
                  ref.watch(adminCategoriesNotifierProvider).categories.length,
              view: e,
            ),
          AdminView.artists => DataMenuItem(
              label: 'Artists',
              count: ref.watch(adminArtistsNotifierProvider).artists.length,
              view: e,
            ),
          AdminView.playlists => DataMenuItem(
              label: 'Playlists',
              count: ref.watch(adminPlaylistNotifierProvider).playlists.length,
              view: e,
            ),
          AdminView.tracks => DataMenuItem(
              label: 'Tracks',
              count: ref.watch(adminTracksNotifierProvider).tracks.length,
              view: e,
            ),
          AdminView.moods => DataMenuItem(
              label: 'Moods',
              count: ref.watch(adminMoodsNotifierProvider).moods.length,
              view: e,
            ),
          _ => DataMenuItem(label: "", count: 0, view: e)
        };
      },
    ).toList();

    final viewState = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 240,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: list.map(
                  (e) {
                    return ListTile(
                      onTap: () {
                        notifier.viewChanged(e.view);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      selected: e.view == viewState.view,
                      selectedTileColor:
                          context.scheme.surfaceTint.withOpacity(0.05),
                      title: Text(e.label),
                      trailing: Text(
                        "${e.count}",
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Container(
            width: 4,
            color: context.scheme.surfaceTint.withOpacity(0.05),
          ),
          const Expanded(
            child: AdminDataRoot(),
          ),
        ],
      ),
    );
  }
}
