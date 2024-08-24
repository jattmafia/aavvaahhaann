import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';

class AdminMoodsTableView extends ConsumerWidget {
  const AdminMoodsTableView({
    super.key,
    this.selection = false,
  });

  final bool selection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final lang = ref.lang;

    final provider = adminMoodsNotifierProvider;

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
                // const Spacer(),
                // SizedBox(
                //   width: 160,
                //   child: DropdownButtonFormField<String>(
                //     value: null,
                //     decoration: const InputDecoration(labelText: "Status"),
                //     items: [""]
                //         .map(
                //           (e) => DropdownMenuItem(
                //             value: e,
                //             child: Text('All'),
                //           ),
                //         )
                //         .toList(),
                //     onChanged: (v) {},
                //   ),
                // ),
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
                          sortAscending: !state.desending,
                          showCheckboxColumn: false,
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
                          ],
                          rows: state.results.map((e) {
                            return DataRow(
                              onSelectChanged: (value) {
                                if (selection) {
                                  context.pop(e);
                                } else {
                                  ref.read(dataViewProvider.notifier).show(e);
                                }
                              },
                              cells: [
                                DataCell(CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon(lang)),
                                )),
                                DataCell(Text(e.name(lang))),
                                DataCell(Text("${e.tracksCount(ref)}")),
                                      
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Showing ${state.page * 10 + 1}-${((state.page + 1) * 10) < state.count ? (state.page + 1) * 10 : state.count} of ${state.count} Results"),
              ),
              const Spacer(),
              TextButton(
                onPressed: state.page > 0
                    ? () {
                        notifier.pageChanged(state.page - 1);
                      }
                    : null,
                child: const Row(
                  children: [
                    Icon(Icons.keyboard_arrow_left_rounded),
                    Text(
                      'Previous',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    border: Border.all(color: context.scheme.outlineVariant)),
                child: Center(
                  child: Text("${state.page + 1}"),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'out of ${state.count ~/ 10 + ((state.count % 10) != 0 ? 1 : 0)}',
                style: TextStyle(
                  color: context.scheme.outline,
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: state.count > (10 * (state.page + 1))
                    ? () {
                        notifier.pageChanged(state.page + 1);
                      }
                    : null,
                child: const Row(
                  children: [
                    Text(
                      'Next',
                    ),
                    Icon(Icons.keyboard_arrow_right_rounded),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
