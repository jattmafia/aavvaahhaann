import 'package:flutter/material.dart';

class BottomButtonWrapper extends StatelessWidget {
  const BottomButtonWrapper({super.key, required this.child});

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return child != null? SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16).copyWith(top: 0),
        child: child,
      ),
    ): const SizedBox();
  }
}
