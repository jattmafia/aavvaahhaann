import 'dart:io';

import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/features/subscriptions/track_access_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

extension ExceptionExtension on Exception {
  dynamic get parse {
    if (this is SocketException) {
      return const SocketException(
        "No Internet Connection",
      );
    } else if (this is supabase.AuthException) {
      final code = (this as supabase.AuthException).statusCode;

      if (code == "${401}") {
        return "OTP Invalid or Expired";
      }

      return (this as supabase.AuthException).message;
    } else if (this is supabase.PostgrestException) {
      return (this as supabase.PostgrestException).message;
    } else if (this is DioException) {
      return (this as DioException).message;
    } else {
      return toString();
    }
  }
}

extension TracksListExtension on List<Track> {
  List<Track> sortByNamePremium(WidgetRef ref) {
    final unlocked =
        where((element) => ref.read(trackAccessProvider(element.id))).toList();
    final locked =
        where((element) => !ref.read(trackAccessProvider(element.id))).toList();

    return [
      ...unlocked.sortByName(),
      ...locked.sortByName(),
    ];
  }

  List<Track> sortByName({bool desending = false}) {
    Map<String, List<Track>> map = {};

    for (var track in this) {
      final key = track.groupId?.toLowerCase() ?? track.nameEn.toLowerCase();
      if (map.containsKey(key)) {
        map[key]!.add(track);
      } else {
        map[key] = [track];
      }
    }

    var entries = map.entries.toList();

    entries.sort(
        (a, b) => desending ? b.key.compareTo(a.key) : a.key.compareTo(b.key));

    return entries.map((e) => e.value).expand((element) {
      element.sort((a, b) => desending
          ? (b.groupIndex ?? 0).compareTo(a.groupIndex ?? 0)
          : (a.groupIndex ?? 0).compareTo(b.groupIndex ?? 0));
      return element;
    }).toList();
  }
}

extension CategoryListExtension on List<MusicCategory> {
  List<MusicCategory> sortByName({bool desending = false}) {
    sort((a, b) => desending
        ? b.nameEn.toLowerCase().compareTo(a.nameEn.toLowerCase())
        : a.nameEn.toLowerCase().compareTo(b.nameEn.toLowerCase()));

    return this;
  }
}

extension ArtistsListExtension on List<Artist> {
  List<Artist> sortByName({bool desending = false}) {
    sort((a, b) => desending
        ? b.nameEn.toLowerCase().compareTo(a.nameEn.toLowerCase())
        : a.nameEn.toLowerCase().compareTo(b.nameEn.toLowerCase()));

    return this;
  }
}

extension MoodListExtension on List<Mood> {
  List<Mood> sortByName({bool desending = false}) {
    sort((a, b) => desending
        ? b.nameEn.toLowerCase().compareTo(a.nameEn.toLowerCase())
        : a.nameEn.toLowerCase().compareTo(b.nameEn.toLowerCase()));

    return this;
  }
}

extension PlaylistListExtension on List<Playlist> {
  List<Playlist> sortByName({bool desending = false}) {
    sort((a, b) => desending
        ? b.nameEn.toLowerCase().compareTo(a.nameEn.toLowerCase())
        : a.nameEn.toLowerCase().compareTo(b.nameEn.toLowerCase()));

    return this;
  }
}
