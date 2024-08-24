import 'package:avahan/features/components/delete_background.dart';
import 'package:flutter/material.dart';

class DeleteDismissible extends StatelessWidget {
  const DeleteDismissible(
      {super.key,
      required this.child,
      required this.onDismissed,
       this.confirmMessage});

  final Widget child;
  final VoidCallback onDismissed;
  final String? confirmMessage;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed();
      },
      background: const DeleteBackground(),
      confirmDismiss: (direction) async {
        if (confirmMessage == null) {
          return true;
        } else {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(confirmMessage!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        }
      },
      child: child,
    );
  }
}
