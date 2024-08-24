import 'dart:developer';

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/date_range_chips_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/dashboard/providers/app_session_analytics_location_wise_provider.dart';
import 'package:avahan/admin/dashboard/providers/app_session_analytics_provider.dart';
import 'package:avahan/admin/dashboard/providers/play_sessions_analytics_provider.dart';
import 'package:avahan/admin/dashboard/providers/users_count_provider.dart';
import 'package:avahan/admin/dashboard/widgets/user_session_list_view.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/profiles/providers/selecteduser_provider.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/models/app_session_analytics.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}

class StatisticsView extends HookConsumerWidget {
  const StatisticsView({super.key});

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

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              AsyncWidget(
                value: ref.watch(usersCountProvider),
                data: (counts) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.scheme.surfaceVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: SfCircularChart(
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                            ),
                            series: <CircularSeries<_ChartData, String>>[
                              DoughnutSeries<_ChartData, String>(
                                dataSource: [
                                  _ChartData(
                                      'Others',
                                      counts.total -
                                          counts.premium -
                                          counts.lifetime),
                                  _ChartData(
                                    'Premium',
                                    counts.premium,
                                  ),
                                  _ChartData(
                                    'Lifetime',
                                    counts.lifetime,
                                  ),
                                ],
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                pointColorMapper: (datum, index) => index == 0
                                    ? context.scheme.surfaceTint
                                        .withOpacity(0.05)
                                    : index == 1
                                        ? context.scheme.primaryContainer
                                        : context.scheme.primary,
                                name: 'Users',
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Users",
                              style: context.style.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${counts.total}",
                              style: context.style.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Premium Users:",
                                  style: context.style.bodyMedium?.copyWith(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                Text(
                                  " ${counts.premium}",
                                  style: context.style.titleSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Lifetime Users:",
                                  style: context.style.bodyMedium?.copyWith(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                Text(
                                  " ${counts.lifetime}",
                                  style: context.style.titleSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'All tracks total duration: ',
                        style: context.style.titleMedium
                            ?.copyWith(color: context.scheme.outline),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Duration(
                          seconds: ref
                              .watch(adminTracksNotifierProvider)
                              .tracks
                              .fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + (element.duration ?? 0),
                              ),
                        ).duration,
                        style: context.style.titleMedium?.copyWith(
                          color: context.scheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DateRangeChipsView(dateRange: dateRange),
                ],
              )
            ],
          ),
        ),
        AsyncWidget(
            value: ref.watch(playSessionAnalyticsProvider(
                dateRange.value.start, dateRange.value.end)),
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                      child: Text('Play Sessions',
                          style: context.style.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(top: 12),
                      child: TableWrapper(
                        child: DataTable(
                          columns: const [
                            DataColumn(
                              label: Text('Total Plays'),
                            ),
                            DataColumn(
                              label: Text('Tracks Played'),
                            ),
                            DataColumn(
                              label: Text('Artists Played'),
                            ),
                            DataColumn(
                              label: Text('Categories Played'),
                            ),
                            DataColumn(
                              label: Text('Playlists Played'),
                            ),
                            DataColumn(
                              label: Text('Moods Played'),
                            ),
                          ],
                          rows: [data]
                              .map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text("${e.totalPlaySessions}")),
                                    DataCell(Text("${e.tracksCount}")),
                                    DataCell(Text("${e.artistsCount}")),
                                    DataCell(Text("${e.categoriesCount}")),
                                    DataCell(Text("${e.playlistsCount}")),
                                    DataCell(Text("${e.moodsCount}")),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Popular Tracks",
                                            style: context.style.titleMedium,
                                          ),
                                          Text(
                                            "  (Track played more than 50% of its duration)",
                                            style: context.style.bodyMedium,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          dataRowMinHeight: 32,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Track'),
                                            ),
                                            DataColumn(
                                              label: Text('Artists'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows:
                                              data.popularTrackIds.entries.map(
                                            (e) {
                                              final track = ref
                                                  .watch(
                                                      adminTracksNotifierProvider)
                                                  .tracks
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.tracks);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(track);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(Text(
                                                    track?.name(lang) ??
                                                        "${e.key}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  DataCell(Text(
                                                    track?.artistsLabel(
                                                            ref, lang) ??
                                                        "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  DataCell(Text("${e.value}")),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Skipped Tracks",
                                            style: context.style.titleMedium,
                                          ),
                                          Text(
                                            "  (Track played less than 25% of its duration)",
                                            style: context.style.bodyMedium,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          dataRowMinHeight: 32,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Track'),
                                            ),
                                            DataColumn(
                                              label: Text('Artists'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows:
                                              data.skippedTrackIds.entries.map(
                                            (e) {
                                              final track = ref
                                                  .watch(
                                                      adminTracksNotifierProvider)
                                                  .tracks
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.tracks);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(track);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(Text(
                                                    track?.name(lang) ??
                                                        "${e.key}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  DataCell(
                                                    Text(
                                                      track?.artistsLabel(
                                                              ref, lang) ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataCell(Text("${e.value}")),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Popular Categories",
                                            style: context.style.titleMedium,
                                          ),
                                          Text(
                                            "Categories played more than 50% of its total duration",
                                            style: context.style.bodySmall,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          dataRowMinHeight: 32,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Category'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows: data.popularCategoryIds.entries
                                              .map(
                                            (e) {
                                              final category = ref
                                                  .watch(
                                                      adminCategoriesNotifierProvider)
                                                  .categories
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.categories);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(category);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      category?.name(lang) ??
                                                          "${e.key}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataCell(Text("${e.value}")),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Popular Artists",
                                            style: context.style.titleMedium,
                                          ),
                                          Text(
                                            "Artists played more than 50% of its total duration",
                                            style: context.style.bodySmall,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          dataRowMinHeight: 32,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Artist'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows:
                                              data.popularArtistIds.entries.map(
                                            (e) {
                                              final artist = ref
                                                  .watch(
                                                      adminArtistsNotifierProvider)
                                                  .artists
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.tracks);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(artist);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      artist?.name(lang) ??
                                                          "${e.key}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text("${e.value}"),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Popular Playlists",
                                            style: context.style.titleMedium,
                                          ),
                                          Text(
                                            "Playlists played more than 50% of its total duration",
                                            style: context.style.bodySmall,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          dataRowMinHeight: 32,
                                          showCheckboxColumn: false,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Playlist'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows: data.popularPlaylistIds.entries
                                              .map(
                                            (e) {
                                              final playlist = ref
                                                  .watch(
                                                      adminPlaylistNotifierProvider)
                                                  .playlists
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.tracks);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(playlist);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      playlist?.name(lang) ??
                                                          "${e.key}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataCell(Text("${e.value}")),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Popular Moods",
                                            style: context.style.titleMedium,
                                          ),
                                           Text(
                            "Moods played more than 50% of its total duration)",
                            style: context.style.bodySmall,
                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TableWrapper(
                                        child: DataTable(
                                          showCheckboxColumn: false,
                                          dataRowMinHeight: 32,
                                          dataRowMaxHeight: 32,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Mood'),
                                            ),
                                            DataColumn(
                                              label: Text('Plays'),
                                            ),
                                          ],
                                          rows: data.popularMoodIds.entries.map(
                                            (e) {
                                              final mood = ref
                                                  .watch(
                                                      adminMoodsNotifierProvider)
                                                  .moods
                                                  .where((element) =>
                                                      element.id == e.key)
                                                  .firstOrNull;

                                              return DataRow(
                                                onSelectChanged: (v) {
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .viewChanged(
                                                          AdminView.tracks);
                                                  ref
                                                      .read(dataViewProvider
                                                          .notifier)
                                                      .show(mood);
                                                  ref
                                                      .read(
                                                          adminDashboardNotifierProvider
                                                              .notifier)
                                                      .viewChanged(
                                                          AdminView.data);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      mood?.name(lang) ??
                                                          "${e.key}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text("${e.value}"),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(24),
          child: AsyncWidget(
            value: ref.watch(
              appSessionAnalyticsProvider(
                dateRange.value.start,
                dateRange.value.end,
              ),
            ),
            data: (all) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('App Sessions', style: context.style.titleLarge),
                  const SizedBox(height: 12),
                  AsyncWidget(
                    value: ref.watch(appSessionAnalyticsLocationWiseProvider(
                      dateRange.value.start,
                      dateRange.value.end,
                    )),
                    data: (data) {
                      var sessions = data;
                      sessions.sort(
                          (a, b) => b.sessionsCount.compareTo(a.sessionsCount));
                      List<AppSessionAnalytics> rowsData = [
                        all.copyWith(
                          country: "All",
                          city: "All",
                          state: "All",
                          color: context.scheme.surfaceTint.withOpacity(0.5),
                        ),
                      ];
                      final countries = sessions
                          .map((e) => e.country)
                          // .where((element) => element != null)
                          .toSet()
                          .toList();

                      for (final country in countries) {
                        final states = sessions
                            .where((e) => e.country == country
                                //  &&
                                //  e.state != null,
                                )
                            .map((e) => e.state)
                            .toSet()
                            .toList();
                        rowsData.add(AppSessionAnalytics(
                            activeUsers: sessions
                                .where((e) => e.country == country)
                                .map((e) => e.activeUsers)
                                .fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element),
                            averageSessions: sessions
                                    .where((e) => e.country == country)
                                    .map((e) => e.sessionsCount)
                                    .fold(0, (a, b) => a + b) /
                                sessions
                                    .where((e) => e.country == country)
                                    .map((e) => e.activeUsers)
                                    .fold(0, (a, b) => a + b),
                            sessionsCount: sessions
                                .where((e) => e.country == country)
                                .map((e) => e.sessionsCount)
                                .fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element),
                            totalSessionDuration: sessions
                                .where((e) => e.country == country)
                                .map((e) => e.totalSessionDuration)
                                .fold(Duration.zero, (previousValue, element) => previousValue + element),
                            country: country,
                            city: "All",
                            state: "All",
                            color: context.scheme.surfaceTint.withOpacity(0.35)));
                        for (final state in states) {
                          final cities = sessions
                              .where((e) =>
                                      e.country == country && e.state == state
                                  // &&
                                  // e.city != null
                                  )
                              .map((e) => e.city)
                              .toSet()
                              .toList();
                          rowsData.add(AppSessionAnalytics(
                              activeUsers: sessions.where((e) => e.country == country && e.state == state).map((e) => e.activeUsers).fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element),
                              averageSessions:
                                  sessions.where((e) => e.country == country && e.state == state).map((e) => e.sessionsCount).fold(
                                          0, (a, b) => a + b) /
                                      sessions.where((e) => e.country == country && e.state == state).map((e) => e.activeUsers).fold(
                                          0, (a, b) => a + b),
                              sessionsCount:
                                  sessions.where((e) => e.country == country && e.state == state).map((e) => e.sessionsCount).fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element),
                              totalSessionDuration: sessions
                                  .where((e) => e.country == country && e.state == state)
                                  .map((e) => e.totalSessionDuration)
                                  .fold(Duration.zero, (previousValue, element) => previousValue + element),
                              country: country,
                              city: "All",
                              state: state,
                              color: context.scheme.surfaceTint.withOpacity(0.2)));
                          for (final city in cities) {
                            final sessionsCount = sessions
                                .where((e) =>
                                    e.country == country &&
                                    e.state == state &&
                                    e.city == city)
                                .map((e) => e.sessionsCount)
                                .reduce((value, element) => value + element);
                            final activeUsers = sessions
                                .where((e) =>
                                    e.country == country &&
                                    e.state == state &&
                                    e.city == city)
                                .map((e) => e.activeUsers)
                                .reduce((value, element) => value + element);
                            final totalDuration = sessions
                                .where((e) =>
                                    e.country == country &&
                                    e.state == state &&
                                    e.city == city)
                                .map((e) => e.totalSessionDuration)
                                .reduce((value, element) => value + element);
                            final avgSessionsPerUser = sessions
                                .where((e) =>
                                    e.country == country &&
                                    e.state == state &&
                                    e.city == city)
                                .map((e) => e.averageSessions)
                                .reduce((value, element) => value + element);
                            rowsData.add(
                              AppSessionAnalytics(
                                activeUsers: activeUsers,
                                averageSessions: avgSessionsPerUser,
                                sessionsCount: sessionsCount,
                                totalSessionDuration: totalDuration,
                                country: country,
                                city: city,
                                state: state,
                              ),
                            );
                          }
                        }
                      }

                      return TableWrapper(
                        child: DataTable(
                          dataRowMinHeight: 32,
                          dataRowMaxHeight: 32,
                          columns: const [
                            DataColumn(
                              label: Text('Country'),
                            ),
                            DataColumn(
                              label: Text('State'),
                            ),
                            DataColumn(
                              label: Text('City'),
                            ),
                            DataColumn(
                              label: Text('Sessions Count'),
                            ),
                            DataColumn(
                              label: Text('All Users'),
                            ),
                            DataColumn(
                              label: Text('Total Duration'),
                            ),
                            DataColumn(
                              label: Text('Avg Sessions per User'),
                            ),
                            DataColumn(
                              label: Text('Active Users'),
                            ),
                          ],
                          rows: rowsData
                              .map(
                                (e) => DataRow(
                                  color: MaterialStatePropertyAll(e.color),
                                  cells: [
                                    DataCell(Text(e.country ?? "Unknown")),
                                    DataCell(Text(e.state ?? "Unknown")),
                                    DataCell(Text(e.city ?? "Unknown")),
                                    DataCell(Text("${e.sessionsCount}")),
                                    DataCell(Text("${e.activeUsers}")),
                                    DataCell(
                                        Text(e.totalSessionDuration.label)),
                                    DataCell(Text(
                                        e.averageSessions.toStringAsFixed(1))),
                                    DataCell(onTap: () {
                                      if (e.useridsList!.isNotEmpty) {
                                        ref
                                            .read(selecteduserslistProvider
                                                .notifier)
                                            .state = e;
                                      }
                                    },
                                        Text(e.useridsList?.length.toString() ??
                                            "0"))
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
    // return AsyncWidget(
    //   value: ref.watch(statisticsProvider),
    //   data: (data) {
    //     return SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(4.0),
    //               child: Row(
    //                 children: [
    //                   ("Total Borrowers", data.borrowers),
    //                   ("Total Lenders", data.lenders),
    //                   ("Total Kyc Agents", data.kycAgents),
    //                 ]
    //                     .map(
    //                       (e) => Expanded(
    //                         child: AspectRatio(
    //                           aspectRatio: 2,
    //                           child: Container(
    //                             clipBehavior: Clip.antiAlias,
    //                             margin: const EdgeInsets.all(12),
    //                             decoration: BoxDecoration(
    //                               color: const Color(0xFFF3EEFF),
    //                               borderRadius: BorderRadius.circular(16),
    //                             ),
    //                             child: Stack(
    //                               children: [
    //                                 Positioned(
    //                                   right: 0,
    //                                   bottom: 0,
    //                                   top: 0,
    //                                   child: Transform.scale(
    //                                     scale: 1.1,
    //                                     child: SvgPicture.asset(Assets.ellipse),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(24.0),
    //                                   child: Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceEvenly,
    //                                     children: [
    //                                       Text(
    //                                         e.$1,
    //                                         style: context.style.titleLarge!
    //                                             .copyWith(
    //                                           color: context.scheme.primary,
    //                                         ),
    //                                       ),
    //                                       Text(
    //                                         "${e.$2}",
    //                                         style: context.style.displayMedium!
    //                                             .copyWith(
    //                                           fontWeight: FontWeight.bold,
    //                                           color: context.scheme.onSurface,
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                     .toList(),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(4.0),
    //               child: Row(
    //                 children: [
    //                   ("Recent User", data.recentUsers),
    //                   ("Pending Kyc Approval", data.pendingKycApprovals),
    //                   ("Active Requests", data.activeRequests),
    //                 ]
    //                     .map(
    //                       (e) => Expanded(
    //                         child: AspectRatio(
    //                           aspectRatio: 2,
    //                           child: Container(
    //                             clipBehavior: Clip.antiAlias,
    //                             margin: const EdgeInsets.all(12),
    //                             decoration: BoxDecoration(
    //                               color: const Color(0xFFF3EEFF),
    //                               borderRadius: BorderRadius.circular(16),
    //                             ),
    //                             child: Stack(
    //                               children: [
    //                                 Positioned(
    //                                   right: 0,
    //                                   bottom: 0,
    //                                   top: 0,
    //                                   child: Transform.scale(
    //                                     scale: 1.1,
    //                                     child: SvgPicture.asset(Assets.ellipse),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(24.0),
    //                                   child: Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceEvenly,
    //                                     children: [
    //                                       Text(
    //                                         e.$1,
    //                                         style: context.style.titleLarge!
    //                                             .copyWith(
    //                                           color: context.scheme.primary,
    //                                         ),
    //                                       ),
    //                                       Text(
    //                                         "${e.$2}",
    //                                         style: context.style.displayMedium!
    //                                             .copyWith(
    //                                           fontWeight: FontWeight.bold,
    //                                           color: context.scheme.onSurface,
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                     .toList(),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
