import 'package:avahan/admin/notify/notify_page.dart';
import 'package:avahan/admin/notify/providers/notifications_provider.dart';
import 'package:avahan/admin/notify/widgets/push_notification_card.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifyCalendarPage extends HookConsumerWidget {
  const NotifyCalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = useState(true);

    useEffect((){
      // tz.initializeTimeZone();
      return null;
    });

    final start = useState(
      Dates.today.subtract(
        Duration(days: DateTime.now().weekday),
      ),
    );

    final end = useState(
      Dates.today.add(
        Duration(days: DateTime.daysPerWeek - DateTime.now().weekday),
      ),
    );

    final notiProvider = pushNotificationsProvider(
      date: start.value,
      endDate: end.value,
    );

    final scheduleProvider = pushNotificationsProvider(scheduled: true);

    final notifications = ref.watch(notiProvider).asData?.value ?? [];

    final scheduled = ref.watch(scheduleProvider).asData?.value ?? [];

    print('notifications: ${notifications.length}');
    print('scheduled: ${scheduled.length}');

    final all = [
      ...notifications.where((e) => e.active == active.value),
      ...scheduled.where((e) => e.active == active.value),
    ];

    _AppointmentDataSource getCalendarDataSource(BuildContext context) {
      List<Appointment> appointments = <Appointment>[];

      appointments.addAll([
        ...all.map(
          (e) {
            final at = (e.date ?? e.createdAt)
                .copyWith(hour: e.time?.hour, minute: e.time?.minute);

            final String? frequency = switch (e.frequency) {
              NotifyFrequency.daily => 'FREQ=DAILY',
              NotifyFrequency.weekly =>
                'FREQ=WEEKLY;BYDAY=${e.weekday!.substring(0, 2).toUpperCase()}',
              NotifyFrequency.monthly => 'FREQ=MONTHLY;BYMONTHDAY=${e.day}',
              _ => null,
            };

            //         final at = e.frequency == null?  e.date
            //     ?.copyWith(hour: e.time?.hour, minute: e.time?.minute) ??
            // e.createdAt: e.frequency == NotifyFrequency.daily? e.createdAt.copyWith(
            //   hour: e.time?.hour,
            //   minute: e.time?.minute
            // ): e.frequency == NotifyFrequency.once? e.date!.copyWith(hour: e.time?.hour, minute: e.time?.minute): e.frequency == NotifyFrequency.;
            return Appointment(
              startTime: at,
              endTime: at.add(const Duration(hours: 1)),
              id: e.id,
              subject: e.title,
              color: e.active
                  ? (context.scheme.tertiaryContainer)
                  : context.scheme.outline.withOpacity(0.25),
              recurrenceRule: frequency,
            );
          },
        ),
      ]);

      print(appointments.length);

      return _AppointmentDataSource(appointments);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify'),
        actions: [
          SegmentedButton(
            multiSelectionEnabled: false,
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Active'),
              ),
              ButtonSegment(
                value: false,
                label: Text('Inactive'),
              ),
            ],
            selected: {
              active.value,
            },
            onSelectionChanged: (v) {
              active.value = v.first;
            },
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () async {
              final v = await showDialog(
                  context: context, builder: (context) => NotifyPage());
              if (v == true) {
                ref.refresh(notiProvider);
              } else if (v == false) {
                ref.refresh(scheduleProvider);
              }
            },
            label: const Text('New Notification'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SfCalendar(
        // timeSlotViewSettings: const TimeSlotViewSettings(numberOfDaysInView: 3,),
        view: CalendarView.week,
        onTap: (calendarTapDetails) async {
          final a = calendarTapDetails.appointments?.firstOrNull;
          if (a is Appointment) {
            final n = all.where((e) => e.id == a.id).firstOrNull;
            if (n != null) {
              final v = await showDialog(
                context: context,
                builder: (context) => PushNotificationDialog(
                    e: n,
                    provider: notifications.any((e) => e.id == n.id)
                        ? notiProvider
                        : scheduleProvider),
              );

              if (v is PushNotification) {
                final e = await showDialog(
                  context: context,
                  builder: (context) => NotifyPage(
                    initial: v,
                  ),
                );
                if (e == true) {
                  ref.refresh(notiProvider);
                } else if (e == false) {
                  ref.refresh(scheduleProvider);
                }
              }
            }
          }
        },
        onSelectionChanged: (calendarSelectionDetails) {
          print(calendarSelectionDetails.date);
        },
        onViewChanged: (viewChangedDetails) {
          start.value = viewChangedDetails.visibleDates.first;
          end.value = viewChangedDetails.visibleDates.last;
        },
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final color = calendarAppointmentDetails.appointments.first.color;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color == context.scheme.tertiaryContainer &&
                      calendarAppointmentDetails.date.date ==
                          DateTime.now().date
                  ? context.scheme.primaryContainer
                  : color,
              // borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              children: [
                Text(
                  calendarAppointmentDetails.appointments.first.subject,
                  style: TextStyle(
                    color: context.scheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
                if (calendarAppointmentDetails
                        .appointments.first.recurrenceRule !=
                    null)
                  const Positioned(
                    bottom: 4,
                    right: 0,
                    child: Icon(Icons.schedule, size: 12),
                  ),
              ],
            ),
          );
        },

        appointmentTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 11,
        ),
        dataSource: getCalendarDataSource(context),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
