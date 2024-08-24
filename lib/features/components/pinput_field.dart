import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:avahan/utils/extensions.dart';

class PinPutField extends StatelessWidget {
  final Function(String v)? onCompleted;
  const PinPutField({super.key, this.onCompleted, this.controller, this.focusNode});
  final TextEditingController? controller;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: context.scheme.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.scheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: context.scheme.primary,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration
          ?.copyWith(color: context.scheme.primaryContainer.withOpacity(0.25)),
    );
    return Pinput(
      controller: controller,
      length: 6,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: onCompleted,
    );
  }
}
