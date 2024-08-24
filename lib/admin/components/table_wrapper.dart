import 'package:avahan/admin/components/outline.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class TableWrapper extends StatelessWidget {
  const TableWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Outline(
      radius: 6,
      color: context.scheme.surfaceTint.withOpacity(0.05),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Theme(
          data: context.theme.copyWith(
            dividerTheme: const DividerThemeData(
              color: Colors.transparent,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
