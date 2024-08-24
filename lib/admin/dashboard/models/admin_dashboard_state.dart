// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/core/models/profile.dart';

class AdminDashboardState {
  final AdminView view;


  AdminDashboardState({
    required this.view,
  });

  AdminDashboardState copyWith({
    AdminView? view,
    Profile? profile,
    Profile? secondProfile,
  }) {
    return AdminDashboardState(
      view: view ?? this.view,
    );
  }
}
