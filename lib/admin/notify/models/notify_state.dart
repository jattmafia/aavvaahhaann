import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class NotifyState extends Equatable {
  final PushNotification notification;
  final XFile? xFile;
  final bool loading;
  final bool topic;

  const NotifyState({
    required this.notification,
    this.xFile,
    required this.loading,
    this.topic = true,
  });

  NotifyState copyWith({
    PushNotification? notification,
    XFile? xFile,
    bool? loading,
    bool clearFile = false,
    bool? topic,
    List<Profile>? profiles,
    bool clearProfiles = false,
  }) {
    return NotifyState(
      notification: notification ?? this.notification,
      xFile: clearFile ? null : (xFile ?? this.xFile),
      loading: loading ?? this.loading,
      topic: topic ?? this.topic,
    );
  }

  bool get enabled =>
      notification.title.isNotEmpty &&
      notification.body.isNotEmpty &&
      (notification.type != null ? (notification.ids != null || notification.link != null) : true) &&
      (notification.frequency != null
          ? notification.time != null &&
              ({
                    NotifyFrequency.monthly: notification.day != null,
                    NotifyFrequency.weekly: notification.weekday != null,
                  }[notification.frequency] ??
                  true)
          : true) && notification.grouped;

  String? get validatorMessage {
    if (notification.title.isEmpty) {
      return 'Please enter a title';
    }
    if (notification.body.isEmpty) {
      return 'Please enter a body';
    }
    if (notification.type != null && notification.ids == null) {
      return 'Please select ${notification.type!.name} for redirect.';
    }
    if (notification.frequency != null) {
      if (notification.frequency == NotifyFrequency.monthly) {
        if (notification.day == null) {
          return 'Please select a day of month';
        }
      }
      if (notification.frequency == NotifyFrequency.weekly) {
        if (notification.weekday == null) {
          return 'Please select a day of week';
        }
      }
      if (notification.time == null) {
        return 'Please select a time';
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [notification, xFile, loading, topic];
}
