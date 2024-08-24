import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/debouncer.dart';
import 'package:avahan/core/models/search_history_item.dart';
import 'package:avahan/core/providers/cache_search_history_items_provider.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/artists/widgets/artist_tile.dart';
import 'package:avahan/features/categories/providers/categories_provider.dart';
import 'package:avahan/features/categories/widgets/category_tile.dart';
import 'package:avahan/features/components/empty_search_result_view.dart';
import 'package:avahan/features/moods/providers/moods_provider.dart';
import 'package:avahan/features/moods/widgets/mood_tile.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/features/playlists/widgets/playlist_tile.dart';
import 'package:avahan/features/providers/flow_provider.dart';
import 'package:avahan/features/tracks/providers/tracks_provider.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllSearchDelegate extends SearchDelegate<dynamic> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          color: context.scheme.onSurface,
          icon: const Icon(Icons.clear),
          onPressed: () {
            showSuggestions(context);
            query = "";
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return BackButton(
        color: context.scheme.onSurface,
        onPressed: () {
          close(context, null);
        },
      );
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
        appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
            backgroundColor: context.scheme.surfaceTint.withOpacity(0.1)));
  }

  Widget view(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final searchKey = useState<String>('');

        final debouncer = useRef(
          Debouncer(
            const Duration(milliseconds: 500),
            (value) {
              searchKey.value = value;
            },
          ),
        );

        if (query != debouncer.value.value) {
          debouncer.value.value = query;
        }

        final categories = ref.read(categoriesProvider).asData?.value ?? [];
        final moods = ref.read(moodsProvider).asData?.value ?? [];
        final artists = ref.read(artistsProvider).asData?.value ?? [];
        final playlists = ref.read(playlistsProvider).asData?.value ?? [];
        final tracks = searchKey.value.length >= 3
            ? ref
                    .watch(tracksProvider(searchKey: searchKey.value))
                    .asData
                    ?.value ??
                []
            : [];

        final resultCategories = categories
            .where(
                (element) => element.searchString.contains(query.toLowerCase()))
            .toList();
        final resultMoods = moods
            .where(
                (element) => element.searchString.contains(query.toLowerCase()))
            .toList();
        final resultArtists = artists
            .where(
                (element) => element.searchString.contains(query.toLowerCase()))
            .toList();
        final resultPlaylists = playlists
            .where(
                (element) => element.searchString.contains(query.toLowerCase()))
            .toList();
        final resultTracks = tracks.toList();

        void addInHistory(String id, SearchHistoryItem item) async {
          final box = await ref.read(cacheSearchHistoryItemsProvider.future);
          box.put(
            id,
            item,
          );
        }

        if ([
          ...resultCategories,
          ...resultMoods,
          ...resultArtists,
          ...resultPlaylists,
          ...resultTracks
        ].isEmpty) {
          if (ref.read(tracksProvider(searchKey: searchKey.value)).isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const EmptySearchResultView();
        }

        return ListView(
          children: [
            ...resultCategories.map(
              (e) => CategoryTile(
                e: e,
                onTapExtra: () {
                  addInHistory(
                    "category-${e.id}",
                    SearchHistoryItem(
                      type: AvahanDataType.category,
                      createdAt: DateTime.now(),
                      data: e.toJson(),
                    ),
                  );
                },
              ),
            ),
            ...resultMoods.map(
              (e) => MoodTile(
                e: e,
                onTapExtra: () {
                  addInHistory(
                    "mood-${e.id}",
                    SearchHistoryItem(
                      type: AvahanDataType.mood,
                      createdAt: DateTime.now(),
                      data: e.toJson(),
                    ),
                  );
                },
              ),
            ),
            ...resultArtists.map(
              (e) => ArtistTile(
                e: e,
                onTapExtra: () {
                  addInHistory(
                    "artist-${e.id}",
                    SearchHistoryItem(
                      type: AvahanDataType.artist,
                      createdAt: DateTime.now(),
                      data: e.toJson(),
                    ),
                  );
                },
              ),
            ),
            ...resultPlaylists.map(
              (e) => PlaylistTile(
                e: e,
                onTapExtra: () {
                  addInHistory(
                    "playlist-${e.id}",
                    SearchHistoryItem(
                      type: AvahanDataType.playlist,
                      createdAt: DateTime.now(),
                      data: e.toJson(),
                    ),
                  );
                },
              ),
            ),
            if (ref
                .read(tracksProvider(searchKey: searchKey.value))
                .isLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            ],
            ...resultTracks.map(
              (e) => TrackTile(
                e: e,
                onTapExtra: () {
                  addInHistory(
                    "track-${e.id}",
                    SearchHistoryItem(
                      type: AvahanDataType.track,
                      createdAt: DateTime.now(),
                      data: e.toJson(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return view(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return view(context);
  }
}

/// category
/// moood
/// artist
/// playlist
/// track