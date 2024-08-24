import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/date_range_chips_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/tracks/providers/track_metrics_provider.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrackStatiticsView extends HookConsumerWidget {
  const TrackStatiticsView({super.key, required this.id});

  final int id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final dateRange = useState(
      DateTimeRange(
        start: Dates.today.subtract(const Duration(days: 30)),
        end: Dates.today.add(const Duration(days: 1)).subtract(
              const Duration(microseconds: 1),
            ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateRangeChipsView(dateRange: dateRange),
        const SizedBox(height: 8),
        AsyncWidget(
          value: ref.watch(trackMetricsProvider(
              id, dateRange.value.start, dateRange.value.end)),
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TableWrapper(
                  child: DataTable(
                      dataRowMinHeight: 32,
                      dataRowMaxHeight: 32,
                      columns: const [
                        DataColumn(
                          label: Text('Key'),
                        ),
                        DataColumn(
                          label: Text('Value'),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            const DataCell(
                              Text("Likes"),
                            ),
                            DataCell(
                              Text("${data.likes}"),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text("Plays"),
                            ),
                            DataCell(
                              Text("${data.count}"),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text("Skips"),
                            ),
                            DataCell(
                              Text("${data.skips}"),
                            ),
                          ],
                        ),
                      ]),
                ),
                const SizedBox(height: 16),
                TableWrapper(
                  child: DataTable(
                      dataRowMinHeight: 32,
                      dataRowMaxHeight: 32,
                      columns: const [
                        DataColumn(
                          label: Text('With'),
                        ),
                        DataColumn(
                          label: Text('Type'),
                        ),
                        DataColumn(
                          label: Text('Plays'),
                        ),
                      ],
                      rows: data.roots
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(Text(() {
                                  if (e.rootType == AvahanDataType.artist) {
                                    return ref
                                            .read(adminArtistsNotifierProvider)
                                            .artists
                                            .where((element) =>
                                                element.id == e.rootId)
                                            .firstOrNull
                                            ?.name(lang) ??
                                        "Unknown";
                                  } else if (e.rootType ==
                                      AvahanDataType.playlist) {
                                    return ref
                                            .read(adminPlaylistNotifierProvider)
                                            .playlists
                                            .where((element) =>
                                                element.id == e.rootId)
                                            .firstOrNull
                                            ?.name(lang) ??
                                        "Unknown";
                                  } else if (e.rootType ==
                                      AvahanDataType.mood) {
                                    return ref
                                            .read(adminMoodsNotifierProvider)
                                            .moods
                                            .where((element) =>
                                                element.id == e.rootId)
                                            .firstOrNull
                                            ?.name(lang) ??
                                        "Unknown";
                                  } else if (e.rootType ==
                                      AvahanDataType.category) {
                                    return ref
                                            .read(adminCategoriesNotifierProvider)
                                            .categories
                                            .where((element) =>
                                                element.id == e.rootId)
                                            .firstOrNull
                                            ?.name(lang) ??
                                        "Unknown";
                                  } else if (e.rootType ==
                                      AvahanDataType.track) {
                                    return "Direct";
                                  } else {
                                    return "Unknown";
                                  }
                                }())),
                                DataCell(Text(context.labels.labelByAvahanDataType(e.rootType),),),
                                DataCell(Text("${e.count}")),
                              ],
                            ),
                          )
                          .toList()),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
