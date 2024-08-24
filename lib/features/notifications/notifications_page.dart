// ignore_for_file: unused_result

import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/delete_dismissable.dart';
import 'package:avahan/features/notifications/notification_writer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/utils/extensions.dart';

import '../../../utils/dates.dart';
import 'providers/notifications_provider.dart';

class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  static const route = "/notifications";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    useEffect(() {
      ref.read(notificationsProvider).whenData((value) async {
        for (var n in value.where((element) => !element.seen)) {
           NotificationWriter.writeNotification(n.copyWith(seen: true));
        }
      });
      return null;
    }, []);
    return PopScope(
      onPopInvoked: (didPop) {
        ref.refresh(notificationsProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(labels.notifications),
        ),
        body: AsyncWidget(
          value: ref.watch(notificationsProvider),
          data: (data) {
            if (data.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    labels.noNotificationAvailable,
                    style: context.style.titleLarge!
                        .copyWith(color: context.scheme.outline),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            data.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
            return ListView(
              children: data
                  .map(
                    (e) => DeleteDismissible(
                      onDismissed: ()async{
                        await NotificationWriter.deleteNotification(e.messageId);
                        ref.refresh(notificationsProvider);
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        leading: e.imageUrl != null
                            ? AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: e.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : null,
                        title: Text(e.title),
                        subtitle: Text(e.body),
                        onTap: e.type != null
                            ? () {
                                context.handleRoute(e, ref);
                                Future.delayed(const Duration(microseconds: 200),
                                    () {
                                  context.pop();
                                });
                              }
                            : null,
                        trailing: Text(
                          Dates.now.difference(e.receivedAt).mini,
                          style: context.style.bodySmall!.copyWith(
                            color: context.scheme.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
