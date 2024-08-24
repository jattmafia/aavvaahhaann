import 'package:avahan/features/notifications/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:avahan/features/notifications/notifications_page.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/svg_icon.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref
            .watch(notificationsProvider)
            .asData
            ?.value
            .where((element) => element.seen == false)
            .length ??
        0;

    return IconButton(
      onPressed: () {
        ref.push(NotificationsPage.route);
      },
      icon: Stack(
        children: [
          const SvgIcon(
            IconAssets.notification,
          ),
          if (count != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Transform.translate(
                offset: const Offset(4, -4),
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: context.scheme.primary,
                  child: Text(
                    "$count",
                    style: TextStyle(
                      fontSize: 10,
                      color: context.scheme.onPrimary,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
