import 'package:avahan/admin/components/date_range_chips_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/data/providers/root_play_session_analytics_provider.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RootStatiticsView extends HookConsumerWidget {
  const RootStatiticsView({super.key, required this.type, required this.id});

  final AvahanDataType type;
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
          value: ref.watch(rootPlaySessionMetricsProvider(
              id, type, dateRange.value.start, dateRange.value.end)),
          data: (data) {
            return TableWrapper(
              child: DataTable(
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: 32,
                  columns: const [
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Plays'),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(
                          Text("Total"),
                        ),
                        DataCell(
                          Text("${data.count}"),
                        ),
                      ],
                    ),
                    ...data.tracks.entries.map((e) {
                      final track = ref
                          .watch(adminTracksNotifierProvider)
                          .tracks
                          .where((element) => element.id == e.key)
                          .firstOrNull;
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(track?.name(lang) ?? "#${e.key}"),
                          ),
                          DataCell(
                            Text("${e.value}"),
                          ),
                        ],
                      );
                    }),
                  ]),
            );
          },
        )
      ],
    );
  }
}
