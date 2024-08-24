import 'dart:developer';

import 'package:avahan/admin/components/table_bottom_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/admin/profiles/models/profiles_state.dart';
import 'package:avahan/admin/profiles/providers/selected_profile_provider.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/features/location/search_city_delegate.dart';
import 'package:avahan/features/location/search_country_delegate.dart';
import 'package:avahan/features/location/search_state_delegate.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/profiles/providers/profiles_notifier.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';

class AdminProfilesTableView extends ConsumerWidget {
  const AdminProfilesTableView({
    super.key,
    this.selection = false,
  });

  final bool selection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final provider = adminProfilesNotifierProvider;

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
                  width: 390,
                  child: SearchField(
                    initial: state.searchKey,
                    hintText: "Search by ID, name, phone, email, city, region",
                    onChanged: (value) =>
                        notifier.debouncer.value = value.trim().toLowerCase(),
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.filter_list_rounded),
                   
                      const SizedBox(width: 12),
                      Flexible(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...state.sort
                                .map<Widget?>((e) {
                                  return switch (e) {
                                    "country" => state.country != null
                                        ? Chip(
                                            shape: const StadiumBorder(),
                                            label: Text(
                                              "Country: ${state.country!.name}",
                                            ),
                                            onDeleted: () {
                                              notifier.countryChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "state" => state.state != null
                                        ? Chip(
                                            label: Text(
                                              "State: ${state.state!.name}",
                                            ),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.stateChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "city" => state.city != null
                                        ? Chip(
                                            label: Text(
                                              "City: ${state.city}",
                                            ),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.cityChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "gender" => state.gender != null
                                        ? Chip(
                                            label: Text(
                                              'Gender: ${context.labels.labelByGender(state.gender!)}',
                                            ),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.genderChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "age" => state.age != null
                                        ? Chip(
                                            label: Text(
                                              'Age: ${Utils.labelByAgeRange(state.age!)}',
                                            ),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.ageChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "birthday" => state.birthday != null
                                        ? Chip(
                                            label: Text('Birthday'),
                                            shape: StadiumBorder(),
                                            onDeleted: () {
                                              notifier.birthdayChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "premium" => state.premium != null
                                        ? Chip(
                                            label: Text(state.premium!
                                                ? 'Premium'
                                                : "Free Trail"),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.premiumChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "lifetime" => state.lifetime == true
                                        ? Chip(
                                            label: const Text('Lifetime'),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.lifetimeChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "lang" => state.lang != null
                                        ? Chip(
                                            label: Text(
                                              'Language: ${Labels.lang(state.lang!)}',
                                            ),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.langChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "expired" => state.expired != null
                                        ? Chip(
                                            label: Text(state.expired!
                                                ? 'Expired'
                                                : 'Active'),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.expiredChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    "joined" => state.joined != null
                                        ? Chip(
                                            label: const Text('Joined'),
                                            shape: const StadiumBorder(),
                                            onDeleted: () {
                                              notifier.joinedChanged(null);
                                            },
                                            deleteIcon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    _ => null,
                                  };
                                })
                                .where((element) => element != null)
                                .cast<Widget>(),
                            PopupMenuButton<String>(
                              tooltip: "Add Filter",
                              onSelected: (v) async {
                                if (v == "country") {
                                  final value = await showSearch(
                                      context: context,
                                      delegate: SearchCountryDelegate());
                                  notifier.countryChanged(value);
                                } else if (v == "state") {
                                  final value = await showSearch(
                                      context: context,
                                      delegate: SearchStateDelegate(
                                          state.country!.iso));
                                  notifier.stateChanged(value);
                                } else if (v == "city") {
                                  final value = await showSearch(
                                    context: context,
                                    delegate: SearchCityDelegate(
                                      state.country!.iso,
                                      state.state!.iso,
                                    ),
                                  );
                                  if (value != null) {
                                    notifier.cityChanged(value);
                                  }
                                } else if (v == "birthday") {
                                  notifier.birthdayChanged(true);
                                } else if (v == "joined") {
                                  notifier.joinedChanged(true);
                                }
                              },
                              itemBuilder: (context) => [
                                if (state.country == null &&
                                    state.joined == null)
                                  const PopupMenuItem(
                                    value: "country",
                                    child: Text("Country"),
                                  )
                                else if (state.state == null)
                                  const PopupMenuItem(
                                    value: "state",
                                    child: Text("State"),
                                  )
                                else if (state.city == null)
                                  const PopupMenuItem(
                                    value: "city",
                                    child: Text("City"),
                                  ),
                                if (state.gender == null)
                                  PopupMenuItem(
                                    value: "gender",
                                    child: PopupMenuButton<Gender>(
                                      child: const Text("Gender"),
                                      onSelected: (v) {
                                        notifier.genderChanged(v);
                                        context.pop();
                                      },
                                      itemBuilder: (context) => [
                                        Gender.male,
                                        Gender.female,
                                      ]
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: e,
                                              child: Text(context.labels
                                                  .labelByGender(e)),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                if (state.age == null)
                                  PopupMenuItem(
                                    value: "age",
                                    child:
                                        PopupMenuButton<({int min, int? max})>(
                                      onSelected: (v) {
                                        notifier.ageChanged(v);
                                        context.pop();
                                      },
                                      itemBuilder: (context) =>
                                          Utils.ageRangeSet
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    Utils.labelByAgeRange(e),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      child: const Text("Age"),
                                    ),
                                  ),
                                if (state.birthday == null)
                                  const PopupMenuItem(
                                    value: "birthday",
                                    child: Text("Birthday"),
                                  ),
                                PopupMenuItem(
                                  value: "subscription",
                                  child: PopupMenuButton(
                                    child: const Text("Subscription"),
                                    onSelected: (v) {},
                                    itemBuilder: (context) => [
                                      if (state.premium == null)
                                        PopupMenuItem(
                                          child: PopupMenuButton<String>(
                                            child: const Text('Type'),
                                            onSelected: (v) {
                                              if (v == "free") {
                                                notifier.premiumChanged(false);
                                              } else if (v == "premium") {
                                                notifier.premiumChanged(true);
                                              } else if(v == "lifetime") {
                                                notifier.lifetimeChanged(true);
                                              }
                                              context.pop();
                                              context.pop();
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: "free",
                                                child: Text('Free Trial'),
                                              ),
                                              const PopupMenuItem(
                                                value: "premium",
                                                child: Text('Premium'),
                                              ),
                                              const PopupMenuItem(
                                                value: "lifetime",
                                                child: Text('Lifetime'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (state.expired == null && state.premium == true && state.lifetime != true)
                                        PopupMenuItem(
                                          child: PopupMenuButton<bool>(
                                            child: const Text("Status"),
                                            onSelected: (v) {
                                              notifier.expiredChanged(v);
                                              context.pop();
                                              context.pop();
                                            },
                                            itemBuilder: (context) => [
                                              false,
                                              true,
                                            ]
                                                .map(
                                                  (e) => PopupMenuItem(
                                                    value: e,
                                                    child: Text(e
                                                        ? "Expired"
                                                        : "Active"),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (state.lang == null)
                                  PopupMenuItem(
                                    value: "lang",
                                    child: PopupMenuButton<Lang>(
                                      child: const Text("Language"),
                                      onSelected: (v) {
                                        notifier.langChanged(v);
                                        context.pop();
                                      },
                                      itemBuilder: (context) => Lang.values
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: e,
                                              child: Text(Labels.lang(e)),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                if (state.joined == null &&
                                    state.country == null)
                                  const PopupMenuItem(
                                    value: "joined",
                                    child: Text('Joined'),
                                  ),
                              ],
                              icon:
                                  const Icon(Icons.add_circle_outline_rounded),
                            ),
                          ],
                        ),
                      ),
                
    //                DropdownButton<Map<String, dynamic>>(
    //   hint: Text('Select Sort Option'),
    //   value: notifier.selectedSortOption,
    //   items: notifier.sortOptions.map((option) {
    //     return DropdownMenuItem<Map<String, dynamic>>(
    //       value: option,
    //       child: Text(option['name']),
    //     );
    //   }).toList(),
    //   onChanged: (selectedOption) {
    //     print(selectedOption.toString());
    //     notifier.sortOptionChange(selectedOption);
    //     print(notifier.selectedSortOption.toString());
    //   },
    // )
    const DropdownExample()
                    
                
                
                
                 ],
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
                //             child: const Text(
                //               'All',
                //             ),
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
                          sortColumnIndex: {
                            AdminProfilesState.id: 0,
                            AdminProfilesState.name: 1,
                            AdminProfilesState.createdAt: 5,
                          }[state.sortKey],
                          sortAscending: !state.desending,
                          showCheckboxColumn: false,
                          columns: [
                            DataColumn(
                              onSort: (columnIndex, ascending) {
                                notifier.sortChanged(
                                  AdminProfilesState.id,
                                  !ascending,
                                );
                              },
                              label: const Text('Id'),
                            ),
                            DataColumn(
                              onSort: (columnIndex, ascending) {
                                notifier.sortChanged(
                                  AdminProfilesState.name,
                                  !ascending,
                                );
                              },
                              label: const Text('Name'),
                            ),
                            const DataColumn(
                              label: Text('Phone/E-mail'),
                            ),
                            const DataColumn(
                              label: Text('Subscription'),
                            ),
                            const DataColumn(
                              label: Text('Status'),
                            ),
                            DataColumn(
                              label: const Text('Joined On'),
                              onSort: (columnIndex, ascending) {
                                notifier.sortChanged(
                                  AdminProfilesState.createdAt,
                                  !ascending,
                                );
                              },
                            ),
                          ],
                          rows: state.profiles.map((e) {
                            return DataRow(
                              onSelectChanged: (value) {
                                if (selection) {
                                  context.pop(e);
                                } else {
                                  ref
                                      .read(selectedProfileProvider.notifier)
                                      .state = e;
                                }
                              },
                              cells: [
                                DataCell(Text("#${e.id}")),
                                DataCell(Text(e.name)),
                                DataCell(Text(e.phoneNumber ?? e.email ?? "")),
                                DataCell(
                                  e.lifetime
                                      ? Text(
                                          "Lifetime",
                                          style: context.style.labelMedium
                                              ?.copyWith(
                                            color: Colors.pink,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              e.premium
                                                  ? "Premium"
                                                  : "Free Trial",
                                              style: context.style.labelMedium
                                                  ?.copyWith(
                                                color: e.premium
                                                    ? Colors.teal
                                                    : Colors.orange,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (e.expiryAt != null && e.premium)
                                              Text(
                                                e.expired
                                                    ? "Expired"
                                                    : "Active",
                                                style: context.style.labelMedium
                                                    ?.copyWith(
                                                  color: e.expired
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                              ),
                                          ],
                                        ),
                                ),
                                DataCell(
                                  Text(
                                    e.active ? "Active" : "Blocked",
                                    style: context.style.labelMedium?.copyWith(
                                      color:
                                          e.active ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e.createdAt?.dateLabel3 ?? "",
                                  ),
                                ),
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


class DropdownExample extends StatefulWidget {
  const DropdownExample({super.key});

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
     void sortOptionChange(newValue) {
    selectedSortOption = newValue;
    setState(() {
      
    });
  } List sortOptions =[];
  //  [
  //   {'name': 'Name a - z', 'key': 'name', 'decending': false},
  //   {'name': 'Name z - a', 'key': 'name', 'decending': true},
  //   {'name': 'New joined', 'key': 'createdAt', 'decending': true},


  // ];
var selectedSortOption ;
     

 

  @override
  Widget build(BuildContext context) {


    
    
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) { 
         final provider = adminProfilesNotifierProvider;
    final notifier = ref.read(provider.notifier);
      sortOptions = notifier.sortOptions;
    //  selectedSortOption ??= notifier.sortOptions[0];
    
        return DropdownButton(
          focusColor: Colors.white,
          dropdownColor: Colors.white,
          isDense: false,
          underline:const SizedBox(),
        hint:const  Text('sort by '),
        value: selectedSortOption,
        items: sortOptions.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option['name']),
          );
        }).toList(),
        onChanged: (selectedOption) {
         
          notifier.sortOptionChange(selectedOption);
          sortOptionChange(selectedOption);
        },
      );
   
       },
      );
  }
}