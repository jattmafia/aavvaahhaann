import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/search_history_item.dart';
import 'package:avahan/core/providers/cache_search_history_items_provider.dart';
import 'package:avahan/features/artists/widgets/artist_tile.dart';
import 'package:avahan/features/categories/widgets/category_tile.dart';
import 'package:avahan/features/components/search_card.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/features/moods/widgets/mood_tile.dart';
import 'package:avahan/features/playlists/widgets/playlist_tile.dart';
import 'package:avahan/features/search/search_delegate.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      pages: const [
        MaterialPage(
          child: SearchPageView(),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }
}

class SearchPageView extends ConsumerWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ref.read(dashboardNotifierProvider.notifier).setIndex(0);
          },
        ),
        title: Text(labels.search),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: AllSearchDelegate());
              },
              child: SearchCard(hint: labels.whatDoYouWantToListenTo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              labels.recentSearches,
              style: TextStyle(
                color: context.scheme.outline,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  ref.read(cacheSearchHistoryItemsProvider).value!.listenable(),
              builder: (context, Box<SearchHistoryItem> box, child) {
                final items = box.values.toList();
                items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return ListView(
                  children: items.map((e) {
                    return switch (e.type) {
                      AvahanDataType.artist => ArtistTile(e: e.parse),
                      AvahanDataType.playlist => PlaylistTile(e: e.parse),
                      AvahanDataType.track => TrackTile(e: e.parse),
                      AvahanDataType.mood => MoodTile(e: e.parse),
                      AvahanDataType.category => CategoryTile(e: e.parse),
                      _ => const SizedBox(),
                    };
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
