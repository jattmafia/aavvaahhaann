// ignore_for_file: unused_result

import 'package:avahan/admin/profiles/providers/profiles_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/admin/profiles/widgets/profiles_table_view.dart';

class AdminProfilesPage extends HookConsumerWidget {
  const AdminProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminProfilesNotifierProvider;

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:  Text("Listeners ${state.loading? "": " (${state.count})"}"),
      ),
      body: const AdminProfilesTableView(),
    );
  }
}
