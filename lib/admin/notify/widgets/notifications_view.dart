import 'package:avahan/admin/notify/providers/notifications_provider.dart';
import 'package:avahan/admin/notify/providers/notifications_view_notifier.dart';
import 'package:avahan/admin/notify/widgets/push_notification_card.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsView extends HookConsumerWidget {
  const NotificationsView({super.key, this.onDublicate, this.onEdit});

  final Function(PushNotification notification)? onDublicate;
  final Function(PushNotification notification)? onEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final state = ref.watch(notificationsViewNotifierProvider);
    final notifier = ref.read(notificationsViewNotifierProvider.notifier);
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Sent'),
            Tab(text: 'Scheduled'),
            Tab(text: 'Templates'),
          ],
        ),
        Expanded(
          child: TabBarView(
              controller: tabController,
              children: {
                pushNotificationsProvider(date: state.date),
                pushNotificationsProvider(scheduled: true),
                pushNotificationsProvider(template: true),
              }
                  .map(
                    (provider) => Column(
                      children: [
                        if (provider.date != null)
                          ListTile(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.date,
                                firstDate: DateTime(2023),
                                lastDate: Dates.today,
                              );
                              if (picked != null) {
                                notifier.dateChanged(picked);
                              }
                            },
                            title: Text(state.date.dateLabel3),
                            trailing: const Icon(Icons.calendar_month),
                          ),
                        Expanded(
                          child: NotificationAsyncWidget(
                            provider: provider,
                            onDublicate: onDublicate?.call,
                            onEdit: onEdit?.call,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()),
        ),
      ],
    );
  }
}

class NotificationAsyncWidget extends ConsumerWidget {
  const NotificationAsyncWidget(
      {super.key, required this.provider, this.onDublicate, this.onEdit});
  final PushNotificationsProvider provider;
  final Function(PushNotification notification)? onDublicate;
  final Function(PushNotification notification)? onEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncWidget(
      value: ref.watch(
        provider,
      ),
      data: (data) {
        var list = data;
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return ListView(
          padding: const EdgeInsets.all(12),
          children: list
              .map(
                (e) => PushNotificationDialog(
                  e: e,
                  provider: provider,
                  onDublicate: onDublicate != null
                      ? () {
                          onDublicate!(e);
                        }
                      : null,
                  onEdit: () => onEdit?.call(e),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
