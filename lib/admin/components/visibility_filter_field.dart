import 'package:flutter/material.dart';

class VisibilityFilterField extends StatelessWidget {
  const VisibilityFilterField(
      {super.key, required this.status, required this.statusChanged});

  final bool? status;
  final Function(bool? value) statusChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<bool?>(
        value: status,
        decoration: const InputDecoration(labelText: "Status"),
        items: [
          null,
          true,
          false,
        ]
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text({
                      null: 'All',
                      true: 'Published',
                      false: 'Unpublished',
                    }[e] ??
                    ""),
              ),
            )
            .toList(),
        onChanged: (v) {
          statusChanged(v);
        },
      ),
    );
  }
}
