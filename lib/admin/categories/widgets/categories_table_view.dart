import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/table_bottom_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/components/visibility_filter_field.dart';
import 'package:avahan/admin/components/visibility_icon.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';

class AdminCategoriesTableView extends ConsumerWidget {
  const AdminCategoriesTableView({
    super.key,
    this.selection = false,
  });

  final bool selection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final lang = ref.lang;

    final provider = adminCategoriesNotifierProvider;

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    final dashboardNotifier = ref.read(adminDashboardNotifierProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 400,
                  child: SearchField(
                    initial: state.searchKey,
                    hintText: "Search by name",
                    onChanged: (value) => notifier.searchKeyChanged(value),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    notifier.refresh();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                ),
                const Spacer(),
                const SizedBox(width: 8),
                VisibilityFilterField(
                  status: state.active,
                  statusChanged: notifier.activeChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: state.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: TableWrapper(
                        child: DataTable(
                          sortColumnIndex: 1,
                          showCheckboxColumn: false,
                          dataRowMaxHeight: 56,
                          sortAscending: !state.desending,
                          columns:  [
                            DataColumn(
                              label: Text('Image'),
                            ),
                            DataColumn(
                              onSort: (columnIndex, ascending) {
                                notifier.toggleSort();
                              },
                              label: Text('Name')
                            ),
                            DataColumn(
                              label: Text('Tracks'),
                            ),
                            DataColumn(
                              label: Text('Status'),
                            ),
                          ],
                          rows: state.pageResults.map((e) {
                            return DataRow(
                              onSelectChanged: (value) {
                                if (selection) {
                                  context.pop(e);
                                } else {
                                  ref.read(dataViewProvider.notifier).show(e);
                                }
                              },
                              cells: [
                                DataCell(
                                  Image.network(
                                    e.icon(lang),
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                                DataCell(Text(e.name(lang))),
                                DataCell(Text("${e.tracksCount(ref)}")),
                                DataCell(VisibilityIcon(e.active)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
          TableBottomView(
            count: state.count,
            page: state.page,
            pageChanged: (v) {
              notifier.pageChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
