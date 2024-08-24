// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/utils/extensions.dart';

class GallaryItem {
  final String name;
  final String subname;
  final String url;
  final AvahanDataType type;

  GallaryItem({
    required this.name,
    required this.subname,
    required this.url,
    required this.type,
  });
}

class GallaryImagesSearchDeledate extends SearchDelegate<String?> {
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
    return BackButton(
      color: context.scheme.onSurface,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
        appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
            backgroundColor: context.scheme.surfaceTint.withOpacity(0.1)));
  }

  Widget view(BuildContext context) {
    final labels = context.labels;
    return HookConsumer(
      builder: (context, ref, child) {
        // final lang = ref.lang;

        final categories = ref.read(adminCategoriesNotifierProvider).categories;
        final moods = ref.read(adminMoodsNotifierProvider).moods;
        final artists = ref.read(adminArtistsNotifierProvider).artists;
        final playlists = ref.read(adminPlaylistNotifierProvider).playlists;
        final tracks = ref.read(adminTracksNotifierProvider).tracks;

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
        final resultTracks = tracks
            .where(
                (element) => element.searchString.contains(query.toLowerCase()))
            .toList();

        final selected = useState<AvahanDataType?>(null);

        List<GallaryItem> items = [];

        for (var item in resultCategories) {
          items.add(
            GallaryItem(
              name: item.nameEn,
              subname: "Icon-En",
              url: item.iconEn,
              type: AvahanDataType.category,
            ),
          );
          if (item.iconHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Icon-Hi",
                url: item.iconHi!,
                type: AvahanDataType.category,
              ),
            );
          }
          if (item.coverEn != null) {
            items.add(
              GallaryItem(
                name: item.nameEn,
                subname: "Cover-En",
                url: item.coverEn!,
                type: AvahanDataType.category,
              ),
            );
          }
          if (item.coverHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Cover-Hi",
                url: item.coverHi!,
                type: AvahanDataType.category,
              ),
            );
          }
        }

        for (var item in resultMoods) {
          items.add(
            GallaryItem(
              name: item.nameEn,
              subname: "Icon-En",
              url: item.iconEn,
              type: AvahanDataType.mood,
            ),
          );
          if (item.iconHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Icon-Hi",
                url: item.iconHi!,
                type: AvahanDataType.mood,
              ),
            );
          }
          if (item.coverEn != null) {
            items.add(
              GallaryItem(
                name: item.nameEn,
                subname: "Cover-En",
                url: item.coverEn!,
                type: AvahanDataType.mood,
              ),
            );
          }
          if (item.coverHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Cover-Hi",
                url: item.coverHi!,
                type: AvahanDataType.mood,
              ),
            );
          }
        }

        for (var item in resultArtists) {
          items.add(
            GallaryItem(
              name: item.nameEn,
              subname: "Icon-En",
              url: item.iconEn,
              type: AvahanDataType.artist,
            ),
          );
          if (item.iconHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Icon-Hi",
                url: item.iconHi!,
                type: AvahanDataType.artist,
              ),
            );
          }
          if (item.coverEn != null) {
            items.add(
              GallaryItem(
                name: item.nameEn,
                subname: "Cover-En",
                url: item.coverEn!,
                type: AvahanDataType.artist,
              ),
            );
          }
          if (item.coverHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Cover-Hi",
                url: item.coverHi!,
                type: AvahanDataType.artist,
              ),
            );
          }
        }

        for (var item in resultPlaylists) {
          items.add(
            GallaryItem(
              name: item.nameEn,
              subname: "Icon-En",
              url: item.iconEn,
              type: AvahanDataType.playlist,
            ),
          );
          if (item.iconHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Icon-Hi",
                url: item.iconHi!,
                type: AvahanDataType.playlist,
              ),
            );
          }
          if (item.coverEn != null) {
            items.add(
              GallaryItem(
                name: item.nameEn,
                subname: "Cover-En",
                url: item.coverEn!,
                type: AvahanDataType.playlist,
              ),
            );
          }
          if (item.coverHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Cover-Hi",
                url: item.coverHi!,
                type: AvahanDataType.playlist,
              ),
            );
          }
        }

        for (var item in resultTracks) {
          items.add(
            GallaryItem(
              name: item.nameEn,
              subname: "Icon-En",
              url: item.iconEn,
              type: AvahanDataType.track,
            ),
          );
          if (item.iconHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Icon-Hi",
                url: item.iconHi!,
                type: AvahanDataType.track,
              ),
            );
          }
          if (item.coverEn != null) {
            items.add(
              GallaryItem(
                name: item.nameEn,
                subname: "Cover-En",
                url: item.coverEn!,
                type: AvahanDataType.track,
              ),
            );
          }
          if (item.coverHi != null) {
            items.add(
              GallaryItem(
                name: item.nameHi!,
                subname: "Cover-Hi",
                url: item.coverHi!,
                type: AvahanDataType.track,
              ),
            );
          }
        }

        // final searchKey = useState(query);
        // final debouncer =
        //     useRef(Debouncer(const Duration(milliseconds: 500), (value) {
        //   searchKey.value = value;
        // }));

        // if (debouncer.value.value != query) {
        //   debouncer.value.value = query;
        // }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  null,
                  ...AvahanDataType.values
                      .where((element) => element != AvahanDataType.unknown)
                ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ChoiceChip(
                          label: Text(
                            e == null
                                ? "All"
                                : context.labels.labelsByAvahanDataType(e),
                          ),
                          selected: selected.value == e,
                          onSelected: (v) {
                            selected.value = e;
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 200,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: items
                    .where((element) =>
                        selected.value == null ||
                        element.type == selected.value)
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          color: context.scheme.surfaceTint.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            close(context, e.url);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: e.url,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.name,
                                  style: context.style.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  e.subname,
                                  style: context.style.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
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