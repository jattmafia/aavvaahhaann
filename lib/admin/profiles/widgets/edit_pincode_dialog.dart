import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';

class EditPincodeDialog extends StatelessWidget {
  EditPincodeDialog({
    super.key,
    required this.initial,
  });

  final String initial;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(initial.isEmpty ? "Enter Pincode" : 'Edit Pincode'),
      content: Form(
        key: formKey,
        child: TextFormField(
          initialValue: initial,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (value) {
            return Validators.required(value) ??
                (value!.length != 6 ? "Enter valid Pincode" : null);
          },
          onSaved: (value) {
            context.pop(value);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
