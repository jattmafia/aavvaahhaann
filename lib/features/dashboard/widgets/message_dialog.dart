import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'package:avahan/core/models/app_notification.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    Key? key,
    required this.notification,
  }) : super(key: key);
  final AppNotification notification;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(notification.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(notification.body),
          if (notification.imageUrl != null) ...[
            const SizedBox(height: 16),
            Image.network(notification.imageUrl!),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(labels.ok),
        ),
        if (notification.type != null && (notification.ids != null || notification.link != null))
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(labels.view),
          ),
      ],
    );
  }
}
