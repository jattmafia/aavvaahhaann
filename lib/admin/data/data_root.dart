import 'package:avahan/admin/artists/artist_page.dart';
import 'package:avahan/admin/artists/artists_page.dart';
import 'package:avahan/admin/artists/write_artist_page.dart';
import 'package:avahan/admin/categories/categories_page.dart';
import 'package:avahan/admin/categories/category_page.dart';
import 'package:avahan/admin/categories/write_category_page.dart';
import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/mood_page.dart';
import 'package:avahan/admin/moods/moods_page.dart';
import 'package:avahan/admin/moods/write_mood_page.dart';
import 'package:avahan/admin/playlist/playlist_page.dart';
import 'package:avahan/admin/playlist/playlists_page.dart';
import 'package:avahan/admin/playlist/write_playlist_page.dart';
import 'package:avahan/admin/tracks/track_page.dart';
import 'package:avahan/admin/tracks/tracks_page.dart';
import 'package:avahan/admin/tracks/write_track_page.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminDataRoot extends HookConsumerWidget {
  const AdminDataRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    final views = [
      if (ref.permissions.viewCategories) AdminView.categories,
      if (ref.permissions.viewArtists) AdminView.artists,
      if (ref.permissions.viewPlaylists) AdminView.playlists,
      if (ref.permissions.viewTracks) AdminView.tracks,
      if (ref.permissions.viewMoods) AdminView.moods,
    ];

    return Navigator(
      pages: [
        MaterialPage(
            child: views.contains(state.view)? switch (state.view) {
          AdminView.categories => const AdminCategoriesPage(),
          AdminView.artists => const AdminArtistsPage(),
          AdminView.moods => const AdminMoodsPage(),
          AdminView.playlists => const AdminPlayListsPage(),
          AdminView.tracks => const AdminTracksPage(),
          _ => const Scaffold(),
        }: const Scaffold()),
        for (var i in state.list)
          MaterialPage(
            child: () {
              if (i is MusicCategory) {
                return AdminCategoryPage(category: i);
              } else if (i is Artist) {
                return AdminArtistPage(artist: i);
              } else if (i is Track) {
                return AdminTrackPage(track: i);
              } else if (i is Playlist) {
                return AdminPlaylistPage(playlist: i);
              } else if (i is Mood) {
                return AdminMoodPage(mood: i);
              } else {
                return const Scaffold();
              }
            }(),
          ),
        if (state.write)
          MaterialPage(
            child: () {
              final i = state.selected;
              if (i is MusicCategory ||
                  (i == null && state.view == AdminView.categories)) {
                return WriteCategoryPage(
                  initial: state.selected as MusicCategory?,
                );
              } else if (i is Artist ||
                  (i == null && state.view == AdminView.artists)) {
                return WriteArtistPage(
                  initial: i,
                );
              } else if (i is Track ||
                  (i == null && state.view == AdminView.tracks)) {
                return WriteTrackPage(initial: i);
              } else if (i is Playlist ||
                  (i == null && state.view == AdminView.playlists)) {
                return WritePlaylistPage(initial: i);
              } else if (i is Mood ||
                  (i == null && state.view == AdminView.moods)) {
                return WriteMoodPage(initial: i);
              } else {
                return const Scaffold();
              }
            }(),
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
