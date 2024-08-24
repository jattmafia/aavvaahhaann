import 'package:avahan/config.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/links_provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final shareProvider = Provider((ref) => ShareViewModel(ref));

class ShareViewModel {
  final Ref _ref;

  ShareViewModel(this._ref);

  Lang get lang => _ref.read(langProvider);

  Future<Uri> create({
    required String title,
    required String? description,
    required String? image,
    required String id,
    required String? type,
    required Map<String, dynamic>? params,
  }) async {
    final paramline = params != null
        ? "&${params.entries.map((e) => "${e.key}=${e.value}").join('&')}"
        : "";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://avahan.app/?id=$id${type != null ? "&type=$type" : ""}$paramline"),
      uriPrefix: "https://${Config.pageLink}",
      androidParameters: AndroidParameters(
        packageName: Config.packageId,
      ),
      iosParameters: IOSParameters(
        appStoreId: '6449548456',
        bundleId: Config.packageId,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: image != null
            ? Uri.parse(
                image,
              )
            : null,
      ),
    );
    final dynamicLink =
        await _ref.read(linksProvider).buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl;
  }

  Future<String> createTrackLink(Track track) async {
    try {
      final shortUrl = await create(
        title: track.name(lang),
        description: track.artistsLabelRef(_ref, lang),
        id: "${track.id}",
        image: track.cover(lang),
        type: AvahanDataType.track.name,
        params: {},
      );
      return shortUrl.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> shareTrack(Track track) async {
    try {
      final shortUrl = await createTrackLink(track);
      await Share.share(
        "Listen to ${track.name(lang)} by ${track.artistsLabelRef(_ref, lang)} on Avahan. $shortUrl",
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> createCategoryLink(MusicCategory category) async {
    try {
      final shortUrl = await create(
        title: category.name(lang),
        description: category.description(lang),
        id: "${category.id}",
        image: category.cover(lang),
        type: AvahanDataType.category.name,
        params: {},
      );
      return shortUrl.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> shareCategory(MusicCategory category) async {
    try {
      final shortUrl = await createCategoryLink(category);
      await Share.share(
        "Listen to ${category.name(lang)} songs on Avahan. $shortUrl",
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> createPlaylistLink(Playlist playlist) async {
    try {
      final shortUrl = await create(
        title: playlist.name(lang),
        description: playlist.description(lang),
        id: "${playlist.id}",
        image: playlist.cover(lang),
        type: AvahanDataType.playlist.name,
        params: {},
      );
      return shortUrl.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> sharePlaylist(Playlist playlist) async {
    try {
      final shortUrl = await createPlaylistLink(playlist);
      await Share.share(
        "Listen to ${playlist.name(lang)} playlist on Avahan. $shortUrl",
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> createArtistLink(Artist artist) async {
    try {
      final shortUrl = await create(
        title: artist.name(lang),
        description: artist.description(lang),
        id: "${artist.id}",
        image: artist.cover(lang),
        type: AvahanDataType.artist.name,
        params: {},
      );
      return shortUrl.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> shareArtist(Artist artist) async {
    try {
      final shortUrl = await createArtistLink(artist);
      await Share.share(
        "Listen songs by ${artist.name(lang)} on Avahan. $shortUrl",
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> createMoodLink(Mood mood) async {
    try {
      final shortUrl = await create(
        title: mood.name(lang),
        description: mood.description(lang),
        id: "${mood.id}",
        image: mood.cover(lang),
        type: AvahanDataType.mood.name,
        params: {},
      );
      return shortUrl.toString();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> shareMood(Mood mood) async {
    try {
      final shortUrl = await createMoodLink(mood);
      await Share.share(
        "Listen ${mood.name(lang)} songs on Avahan. $shortUrl",
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  // Future<void> shareApp() async {
  //   try {
  //     await Share.share(
  //       "Avahan is a music streaming app with a focus on Indian music. Enjoy music in your language. Download now: Download now: ${Config.appLink}",
  //     );
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  // }
}
