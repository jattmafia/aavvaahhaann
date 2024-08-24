import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class PlaySessionAnalytics {
  final int totalPlaySessions;
  final Map<int, int> popularTrackIds;
  final Map<int, int> popularCategoryIds;
  final Map<int, int> popularArtistIds;
  final Map<int, int> popularPlaylistIds;
  final Map<int, int> popularMoodIds;
  final Map<int, int> skippedTrackIds;
  final int tracksCount;
  final int categoriesCount;
  final int artistsCount;
  final int moodsCount;
  final int playlistsCount;

  PlaySessionAnalytics({
    required this.totalPlaySessions,
    required this.popularTrackIds,
    required this.skippedTrackIds,
    required this.tracksCount,
    required this.categoriesCount,
    required this.artistsCount,
    required this.moodsCount,
    required this.playlistsCount,
    required this.popularCategoryIds,
    required this.popularArtistIds,
    required this.popularPlaylistIds,
    required this.popularMoodIds,
  });

  factory PlaySessionAnalytics.fromMap(Map<String, dynamic> map) {
    // Clipboard.setData(ClipboardData(text: jsonEncode(map)));
    return PlaySessionAnalytics(
      totalPlaySessions: map['total_play_sessions'] as int,
      popularTrackIds: Map<int, int>.fromEntries(
        (map['popular_track_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
      skippedTrackIds: Map<int, int>.fromEntries(
        (map['skipped_track_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
      tracksCount: map['tracks_count'] as int,
      categoriesCount: map['categories_count'] as int,
      artistsCount: map['artists_count'] as int,
      moodsCount: map['moods_count'] as int,
      playlistsCount: map['playlists_count'] as int,
      popularCategoryIds: Map<int, int>.fromEntries(
        (map['popular_category_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
      popularArtistIds: Map<int, int>.fromEntries(
        (map['popular_artist_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
      popularPlaylistIds: Map<int, int>.fromEntries(
        (map['popular_playlist_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
      popularMoodIds: Map<int, int>.fromEntries(
        (map['popular_mood_ids'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
    );
  }
}
