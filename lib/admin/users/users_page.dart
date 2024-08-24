import 'package:avahan/admin/components/table_bottom_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/users/invite_dialog.dart';
import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:avahan/admin/users/user_dialog.dart';
import 'package:avahan/core/repositories/admin_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminUsersPage extends HookConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchKey = useState<String>('');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: SearchField(
                        initial: searchKey.value,
                        hintText: "Search by name, email",
                        onChanged: (value) {
                          searchKey.value = value;
                        },
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ref.refresh(adminUsersProvider);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const InviteDialog());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Invite User"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncWidget(
                  value: ref.watch(adminUsersProvider),
                  data: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: TableWrapper(
                                child: DataTable(
                                  dataRowMaxHeight: 100,
                                  dataRowMinHeight: 56,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('Name'),
                                    ),
                                    DataColumn(
                                      label: Text('E-mail'),
                                    ),
                                    DataColumn(
                                      label: Text('Permissions'),
                                    ),
                                    DataColumn(
                                      label: SizedBox.shrink(),
                                    ),
                                  ],
                                  rows: data
                                      .where((e) => "${e.name}${e.email}"
                                          .toLowerCase()
                                          .contains(
                                              searchKey.value.toLowerCase()))
                                      .map(
                                    (e) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(e.name),
                                          ),
                                          DataCell(
                                            Text(e.email),
                                          ),
                                          DataCell(
                                            Text(e.permissions
                                                .map((e) => e
                                                    .split('-')
                                                    .map((e) => e.capLabel)
                                                    .join(' '))
                                                .join(", ")),
                                            onTap: e.owner == true? null: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AdminUserDialog(
                                                  user: e,
                                                ),
                                              );
                                            },
                                          ),
                                          DataCell(
                                            e.owner == true? const SizedBox.shrink()
                                            :  const Icon(Icons.delete_outline),
                                            onTap: e.owner == true? null: () async {
                                              final value = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Delete ${e.name}?'),
                                                    content: const Text(
                                                      'Are you sure you want to delete this user?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                                foregroundColor:
                                                                    context
                                                                        .scheme
                                                                        .error),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (value == true) {
                                                await ref
                                                    .read(
                                                        adminRepositoryProvider)
                                                    .deleteUser(
                                                        id: e.id, uid: e.uid);
                                                ref.refresh(adminUsersProvider);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
