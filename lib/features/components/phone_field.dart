import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avahan/utils/validators.dart';

class PhoneField extends StatelessWidget {
  const PhoneField(
      {super.key,
      this.onChanged,
      this.initial,
      this.border,
      this.enabled = true,
      this.validator});

  final String? initial;

  final bool enabled;

  final ValueChanged<String>? onChanged;

  final InputBorder? border;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initial,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          prefixText: "+91 ", border: border, enabledBorder: border),
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator ?? Validators.required,
      onChanged: onChanged,
      // validator: (value) => ,
    );
  }
}
