import 'package:avahan/admin/notify/providers/notifications_provider.dart';
import 'package:avahan/admin/profiles/providers/profile_provider.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/repositories/notifications_repository.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PushNotificationDialog extends ConsumerWidget {
  const PushNotificationDialog(
      {super.key,
      required this.e,
      required this.provider,
      this.onDublicate,
      this.onEdit});

  final PushNotification e;
  final PushNotificationsProvider provider;
  final VoidCallback? onDublicate;
  final VoidCallback? onEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(notificationsRepositoryProvider);

    final e = ref
            .watch(provider)
            .asData
            ?.value
            .firstWhere((e) => e.id == this.e.id) ??
        this.e;
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 600,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    shape: const StadiumBorder(),
                    color: context.scheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Created on ${e.createdAt.dateTimeLabel}",
                        style: context.style.labelSmall?.copyWith(
                            color: context.scheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (e.image != null) ...[
                        SizedBox(
                          height: 56,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: e.image!,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              e.title,
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.body,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    "To",
                    style: context.style.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (e.topic != null) 'Topic: ${e.topic}',
                      if (e.users != null)
                        'Users: ${e.users!.map((i) => "#$i ${ref.watch(adminProfileProvider(i)).asData?.value.name ?? ""}").join(', ')}',
                      if (e.topic == null && e.users == null) ...[
                        if (e.country != null) 'Country: ${e.country?.name}',
                        if (e.state != null) 'State: ${e.state?.name}',
                        if (e.state != null) 'City: ${e.city}',
                        if (e.ageMin != null)
                          'Age: ${Utils.labelByAgeRange((
                                min: e.ageMin!,
                                max: e.ageMax
                              ))}',
                        if (e.gender != null)
                          context.labels.labelByGender(e.gender!),
                        if (e.birthday ?? false) 'Birthday',
                        if (e.premium != null)
                          e.premium! ? 'Premium' : 'Free Trial',
                        if (e.expired != null)
                          e.expired! ? 'Expired' : 'Active',
                      ]
                    ].join(', '),
                    style: context.style.bodySmall!.copyWith(
                      color: context.scheme.outline,
                    ),
                  ),
                  if (e.frequency != null) ...[
                    const Divider(),
                    Text(
                      "Frequency",
                      style: context.style.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        context.labels.labelsByNotifyFrequency(e.frequency!),
                        if (e.frequency == NotifyFrequency.monthly)
                          "${e.day?.ordinal ?? ''} day of each month",
                        if (e.frequency == NotifyFrequency.weekly)
                          'Each ${e.weekday}',
                        'at ${e.time!.fromTimezone(e.timezone).timeLabel} (${e.timezone})',
                        if (e.date != null) "on ${e.date!.dateLabel3}"
                      ].join(', '),
                      style: context.style.bodySmall!.copyWith(
                        color: context.scheme.outline,
                      ),
                    ),
                  ],
                  const Divider(),
                  Text(
                    "Results",
                    style: context.style.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: context.scheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Column(
                        children: e.results
                            .map(
                              (e) => Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      e.createdAt?.dateTimeLabel ?? "",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.success.toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.failure.toString(),
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.frequency != null)
                    IconButton(
                      onPressed: () {
                        onEdit?.call();
                        Navigator.pop(context, e);
                      },
                      icon: Icon(Icons.edit_rounded),
                    ),
                  if (onDublicate != null)
                    IconButton(
                      onPressed: () {
                        onDublicate?.call();
                        Navigator.pop(context, e.copyWith(id: 0));
                      },
                      icon: Icon(Icons.copy),
                    ),
                  if (e.frequency != null) ...[
                    Switch(
                      value: e.active,
                      onChanged: (v) async {
                        await repository.updateActive(e.id, v);
                        ref.refresh(provider);
                      },
                    ),
                    // const SizedBox(width: 8),
                  ],
                  // ChoiceChip(
                  //   showCheckmark: false,
                  //   label: Text("T"),
                  //   selected: e.template,
                  //   onSelected: (v) async {
                  //     await repository.updateTemplate(e.id, v);
                  //     ref.refresh(provider);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
