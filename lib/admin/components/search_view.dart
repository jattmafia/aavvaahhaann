import 'package:avahan/core/models/artist.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
    this.artists = const [],
    this.categories = const [],
    this.moods = const [],
    this.tracks = const [],
    this.playlists = const [],
    required this.onSelected,
    this.profiles = const [],
    this.hintText,
  });

  final List<Artist> artists;
  final List<MusicCategory> categories;
  final List<Mood> moods;
  final List<Track> tracks;
  final List<Playlist> playlists;
  final List<Profile> profiles;
  final Function(int value) onSelected;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      viewElevation: 4,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          backgroundColor:
              WidgetStatePropertyAll(context.scheme.surfaceContainerHigh),
          hintText: hintText ?? "Search by name",
          // elevation: const WidgetStatePropertyAll(1),
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          ...tracks
              .where((element) =>
                  element.searchString.contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  title: Text(e.name()),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e.icon(),
                    ),
                  ),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
          ...artists
              .where((element) =>
                  element.searchString.contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  title: Text(e.name()),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e.icon(),
                    ),
                  ),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
          ...categories
              .where((element) =>
                  element.searchString.contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  title: Text(e.name()),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e.icon(),
                    ),
                  ),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
          ...moods
              .where((element) =>
                  element.searchString.contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  title: Text(e.name()),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e.icon(),
                    ),
                  ),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
          ...profiles
              .where((element) =>
                  "${element.name}-${element.email ?? ""}-${element.phoneNumber ?? ""}"
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  leading: Text('#${e.id}'),
                  title: Text(e.name),
                  subtitle: Text(e.phoneNumber ?? e.email ?? ""),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
          ...playlists
              .where((element) =>
                  element.searchString.contains(controller.text.toLowerCase()))
              .map(
                (e) => ListTile(
                  title: Text(e.name()),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e.icon(),
                    ),
                  ),
                  onTap: () {
                    onSelected(e.id);
                    controller.closeView('');
                  },
                ),
              ),
        ];
      },
    );
  }
}
