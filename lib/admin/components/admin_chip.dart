import 'package:flutter/material.dart';

class AdminChip extends StatelessWidget {
  const AdminChip({
    super.key,
    required this.color,
    required this.label,
  });

  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          label,
          style:  TextStyle(color: color, fontSize: 12),
        ),
      ),
    );
  }
}
