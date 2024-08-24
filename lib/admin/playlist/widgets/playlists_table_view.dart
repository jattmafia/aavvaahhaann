import 'package:avahan/admin/components/table_bottom_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/components/visibility_filter_field.dart';
import 'package:avahan/admin/components/visibility_icon.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';

class AdminPlaylistTableView extends ConsumerWidget {
  const AdminPlaylistTableView({
    super.key,
    this.selection = false,
  });

  final bool selection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final lang = ref.lang;

    final provider = adminPlaylistNotifierProvider;

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
                VisibilityFilterField(
                  status: state.active,
                  statusChanged: notifier.activeChanged,
                ),
                //                 SizedBox(
                //   width: 160,
                //   child: DropdownButtonFormField<Status?>(
                //     value: state.status,
                //     decoration: const InputDecoration(labelText: "Status"),
                //     items: [Status.active, Status.blocked, null]
                //         .map(
                //           (e) => DropdownMenuItem(
                //             value: e,
                //             child: Text(
                //               e != null ? labels.labelByStatus(e) : 'All',
                //             ),
                //           ),
                //         )
                //         .toList(),
                //     onChanged: (v) {
                //       notifier.statusChanged(v);
                //     },
                //   ),
                // ),
                // if (roleIsBorrowerOrLender) ...[
                //   const SizedBox(width: 8),
                //   SizedBox(
                //     width: 160,
                //     child: DropdownButtonFormField<KycStatus>(
                //       value: state.kycStatus,
                //       decoration:
                //           const InputDecoration(labelText: "Kyc Status"),
                //       items: [
                //         KycStatus.verified,
                //         KycStatus.inProgress,
                //         KycStatus.rejected,
                //         null,
                //       ]
                //           .map(
                //             (e) => DropdownMenuItem(
                //               value: e,
                //               child: Text(
                //                 e != null ? labels.labelByKycStatus(e) : 'All',
                //               ),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (v) {
                //         notifier.kycStatusChanged(v);
                //       },
                //     ),
                //   ),
                // ],
                // const SizedBox(width: 8),
                // if (roleIsBorrowerOrLender)
                //   SizedBox(
                //     width: 200,
                //     child: DropdownButtonFormField<bool?>(
                //       value: state.membership,
                //       decoration:
                //           const InputDecoration(labelText: "Membership"),
                //       items: [
                //         true,
                //         false,
                //         null,
                //       ]
                //           .map(
                //             (e) => DropdownMenuItem(
                //               value: e,
                //               child: Text(
                //                 {
                //                       true: "Active",
                //                       false: "Not Purchased",
                //                       null: "All"
                //                     }[e] ??
                //                     "",
                //               ),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (v) {
                //         notifier.membershipChanged(v);
                //       },
                //     ),
                //   ),
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
                          dataRowMaxHeight: 56,
                          showCheckboxColumn: false,
                          sortAscending: !state.desending,
                          columns:  [
                            DataColumn(
                              label: Text('Image'),
                            ),
                            DataColumn(
                              onSort: (columnIndex, ascending) {
                                notifier.toggleSort();
                              },
                              label: Text('Name'),
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
                                DataCell(Text("${e.tracks.length}")),
                                DataCell(VisibilityIcon(e.active)),
                                // DataCell(
                                //   IconButton(
                                //     onPressed: () {},
                                //     icon: const Icon(Icons.delete),
                                //   ),
                                // ),
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
            pageChanged: notifier.pageChanged,
          ),
        ],
      ),
    );
  }
}
