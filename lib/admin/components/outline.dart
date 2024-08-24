import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class Outline extends StatelessWidget {
  const Outline({super.key, this.color, required this.child,this.radius});

  final Color? color;
  final Widget child;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius?? 16),
        border: Border.all(
          color: color?? context.scheme.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}
