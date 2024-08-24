import 'package:flutter/material.dart';

class VisibilityIcon extends StatelessWidget {
  const VisibilityIcon( this.active, {super.key});

  final bool active;
  @override
  Widget build(BuildContext context) {
    return active
        ? const Icon(
            Icons.visibility_rounded,
            color: Colors.green,
          )
        : const Icon(
            Icons.visibility_off_outlined,
            color: Colors.red,
          );
  }
}
