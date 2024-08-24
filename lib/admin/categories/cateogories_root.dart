import 'package:avahan/admin/categories/categories_page.dart';
import 'package:avahan/admin/categories/category_page.dart';
import 'package:avahan/admin/categories/write_category_page.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/core/models/music_category.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminCategoriesRoot extends HookConsumerWidget {
  const AdminCategoriesRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataViewProvider);
    final notifier = ref.watch(dataViewProvider.notifier);

    return Navigator(
      pages: [
        const MaterialPage(
          child: AdminCategoriesPage(),
        ),
        if (state.selected != null)
          MaterialPage(
            child: AdminCategoryPage(
              category: state.selected as MusicCategory,
            ),
          ),
        if (state.write)
          MaterialPage(
            child: WriteCategoryPage(
              initial: state.selected as MusicCategory?,
            ),
          ),

        // if (state.profile != null)
        //   MaterialPage(
        //     key: const ValueKey('profile'),
        //     child: AdminProfilePage(
        //       profile: state.profile!,
        //       role: role,
        //     ),
        //   ),
        // if (state.secondProfile != null)
        //   MaterialPage(
        //     key: const ValueKey('profile-2'),
        //     child: AdminProfilePage(
        //       profile: state.secondProfile!,
        //       role: state.secondRole!,
        //     ),
        //   ),
        // if (state.loan != null)
        //   MaterialPage(
        //     key: const ValueKey('loan'),
        //     child: AdminLoanPage(loan: state.loan!),
        //   ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (state.write) {
          notifier.closeWrite();
        } else if (state.selected != null) {
          notifier.show(null);
        }
        return true;
      },
    );
  }
}
