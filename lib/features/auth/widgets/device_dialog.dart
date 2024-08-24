import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class DeviceDialog extends StatelessWidget {
  const DeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return AlertDialog(
      title: Text(
        labels.youAreAlreadyLoggedInOnAnotherDevice,
      ),
      content: Text(
        labels.byContinuingYouWillBeLoggedOutFromTheOtherDevice,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            labels.cancel,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(labels.continue_),
        ),
      ],
    );
  }
}
