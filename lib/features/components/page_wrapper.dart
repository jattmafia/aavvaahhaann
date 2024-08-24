import 'package:flutter/cupertino.dart';
import 'package:avahan/utils/extensions.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({super.key, required this.child, this.height, this.width});

  final Widget child;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.scheme.surface,
      child: Container(
        color: context.scheme.surfaceVariant.withOpacity(0.5),
        child: Center(
          child: Container(
            height: context.large ? (height ?? 574) : null,
            width: context.large ? (width ?? 947) : null,
            decoration: BoxDecoration(
              color: context.scheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 24, color: context.scheme.outlineVariant)
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
