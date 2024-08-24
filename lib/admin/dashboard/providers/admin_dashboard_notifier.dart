import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
part 'admin_dashboard_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminDashboardNotifier extends _$AdminDashboardNotifier {
  @override
  AdminDashboardState build() {
    return AdminDashboardState(view: AdminView.dashboard);
  }

  void viewChanged(AdminView value) async {
    state = AdminDashboardState(view: value);
  }

  // void profileChanged(Profile? profile) async {
  //   if (profile == null) {
  //     state.profile = null;
  //   } else {
  //     state = state.copyWith(
  //       profile: profile,
  //     );
  //   }
  // }

  // void secondProfileChanged(Profile? profile) async {
  //   if (profile == null) {
  //     state.secondProfile = null;
  //   } else {
  //     state = state.copyWith(
  //       secondProfile: profile,
  //     );
  //   }
  // }
}
