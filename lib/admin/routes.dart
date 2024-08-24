import 'package:flutter/material.dart';
import 'package:avahan/admin/root.dart';

class AdminRouter {
  static Route<dynamic> on(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return switch (settings.name) {
          AdminRoot.route => const AdminRoot(),
          _ => const Scaffold(),
        };
      },
    );
  }
}
