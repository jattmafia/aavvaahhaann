import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';




class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, required this.label});
  
  final String label;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $label?'),
      content: Text('Are you sure you want to delete this $label?'),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(false);
          },
          child: const Text('No'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: context.scheme.error,
          ),
          onPressed: () {
            context.pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}