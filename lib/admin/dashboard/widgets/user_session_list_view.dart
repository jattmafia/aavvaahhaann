import 'dart:developer';

import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/dashboard/providers/sessionuser_notifier.dart';
import 'package:avahan/admin/profiles/providers/selected_profile_provider.dart';
import 'package:avahan/admin/profiles/providers/selecteduser_list_detail_provider.dart';
import 'package:avahan/core/models/app_session_analytics.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';






class UserListPage extends ConsumerWidget {
   final AppSessionAnalytics data;
  const UserListPage({super.key, required this.data,this.selection = false});
final bool selection;
  @override
  Widget build(BuildContext context, ref) {
      final provider = sessionUserNotifierProvider(data.useridsList as List);

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    

    return Scaffold(
      appBar: AppBar(leading:const BackButton(),),
      body: 
      state.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : 
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: TableWrapper(
                          child: DataTable(
                          
                         
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(
                              
                                label: Text('Id'),
                              ),
                              DataColumn(
                               
                                label: Text('Name'),
                              ),
                               DataColumn(
                                label: Text('Phone/E-mail'),
                              ),
                               DataColumn(
                                label: Text('Subscription'),
                              ),
                               DataColumn(
                                label: Text('Status'),
                              ),
                              DataColumn(
                                label: Text('Joined On'),
                                
                              ),
                            ],
                            
                            rows: state.profiles.map((e) {
                              
                              
                              return DataRow(
                              onSelectChanged: (value) {
                                if (selection) {
                                  context.pop(e);
                                } else {
                                  ref
                                      .read(selecteduserslistdetailProvider.notifier)
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
                ],
              )
    );
  }
}