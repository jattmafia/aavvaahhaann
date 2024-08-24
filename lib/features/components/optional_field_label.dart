import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class OptionalFieldLabel extends StatelessWidget {
  const OptionalFieldLabel({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return Row(
      children: [
        child,
        Text(
          labels.optional,
          style: context.style.bodySmall!.copyWith(
            color: context.scheme.outline,
          ),
        ),
      ],
    );
  }
}
