import 'dart:io';
import 'package:avahan/core/enums/artist_type.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/app_notification.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/features/artists/artist_root_page.dart';
import 'package:avahan/features/auth/onboard_page.dart';
import 'package:avahan/features/categories/category_root_page.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/features/moods/mood_root_page.dart';
import 'package:avahan/features/playlists/playlist_root_page.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/providers/navigator_provider.dart';
import 'package:avahan/features/root.dart';
import 'package:avahan/features/subscriptions/providers/subscription_notifier.dart';
import 'package:avahan/features/tracks/track_root_page.dart';
import 'package:avahan/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:timezone/standalone.dart' as tz;

extension BuildContextExtension on BuildContext {
  Size get size_ => MediaQuery.sizeOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get padding => MediaQuery.viewPaddingOf(this);

  bool get large => size_.width >= 1240;
  bool get medium => size_.width > 900 && size_.width < 1240;
  bool get small => size_.width <= 900;
  bool get extraSmall => size_.width < 600;

  ThemeData get theme => Theme.of(this);
  ColorScheme get scheme => theme.colorScheme;
  TextTheme get style => theme.textTheme;

  AppLocalizations get labels => AppLocalizations.of(this)!;

  AppLocalizations get hi => AppLocalizationsHi();
  AppLocalizations get en => AppLocalizationsEn();

  AppLocalizations locale(Lang value) {
    return switch (value) {
      Lang.hi => hi,
      Lang.en => en,
    };
  }

  Future<dynamic> push(String name, {Object? extra, WidgetRef? ref}) async {
    if (ref != null) {
      ref.read(dashboardNotifierProvider.notifier).setData(extra);
    } else {
      return Navigator.pushNamed(this, name, arguments: extra);
    }
  }

  void pop([Object? result]) {
    return Navigator.pop(this, result);
  }

  bool get canPop => Navigator.canPop(this);

  Future<dynamic> replace(String name, {Object? extra}) {
    return Navigator.pushReplacementNamed(this, name, arguments: extra);
  }

    Future<dynamic> replacewithoutanimate(String name, {Object? extra}) {
    return Navigator.pushReplacementNamed(this, name, arguments: extra,);
  }

  void go([WidgetRef? ref]) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      Root.route,
      (route) => false,
    );
  }

  void message(dynamic value) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: scheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$value',
          style: TextStyle(color: scheme.onInverseSurface),
        ),
      ),
    );
  }

  Future<dynamic> showDialogSheet(
    Widget child,
  ) {
    if (extraSmall) {
      return showModalBottomSheet(
        context: this,
        isScrollControlled: true,
        builder: (context) => child,
      );
    } else {
      return showDialog(
        context: this,
        builder: (context) => Dialog(
          child: SizedBox(
            width: 576,
            child: child,
          ),
        ),
      );
    }
  }

  void error(dynamic e) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: scheme.onErrorContainer,
        behavior: SnackBarBehavior.floating,
        content: Text(
          e is SocketException ? e.message : '$e',
          style: TextStyle(color: scheme.errorContainer),
        ),
      ),
    );
  }

  void handleRoute(AppNotification notification, WidgetRef ref) async {
    try {
      final type = AvahanDataType.values.firstWhere(
          (element) => element.name == notification.type,
          orElse: () => AvahanDataType.unknown);

      if (type != AvahanDataType.unknown && notification.ids != null) {
        final routes = {
          AvahanDataType.artist: ArtistRootPage.route,
          AvahanDataType.category: CategoryRootPage.route,
          AvahanDataType.mood: MoodRootPage.route,
          AvahanDataType.playlist: PlayListRootPage.route,
          AvahanDataType.track: TrackRootPage.route,
        };
        final route = routes[type];
        if (route != null && notification.ids != null) {
          push(route, extra: MapEntry(type, notification.ids), ref: ref);
        }
      } else if (notification.link != null) {
        try {
          await launchUrlString(notification.link!,
              mode: LaunchMode.externalApplication);
        } catch (e) {
          error(e);
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  void showPremiumSnackbar(WidgetRef ref) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: scheme.inverseSurface,
        behavior: SnackBarBehavior.floating,

        // action: SnackBarAction(
        //   label: labels.premium,
        //   onPressed: () async {
        //     try {
        //       await ref.read(subscriptionProvider).init();
        //     } catch (e) {
        //       error(e);
        //     }
        //   },
        // ),
        padding: EdgeInsets.zero,
        content: ListTile(
          onTap: () async {
            try {
              await ref.read(subscriptionProvider).init();
            } catch (e) {
              error(e);
            }
          },
          title: Text(
            labels.unlockAndDownloadAllContent,
            style: TextStyle(
                color: scheme.onInverseSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          leading: Icon(
            Icons.workspace_premium_rounded,
            color: scheme.inversePrimary,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: scheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}

extension DoubleExtension on double {
  String get asRupee =>
      NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 0)
          .format(toInt());
}

extension IntExtension on int {
  int calculateNumberOfPlays(int trackDuration, int totalListeningTime) {
  if (trackDuration <= 0) {
   return 0;
  }
  if (totalListeningTime < 0) {
   return 0;
  }
  print(totalListeningTime / trackDuration);
  
  // Calculate the number of full plays
  return (totalListeningTime / trackDuration).ceil();
}
  String get asRupee =>
      NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 0)
          .format(this);

  int? get crim => this == 0 ? null : this;

  String get ordinal {
    if (this % 100 >= 11 && this % 100 <= 13) {
      return "${this}th";
    }

    switch (this % 10) {
      case 1:
        return "${this}st";
      case 2:
        return "${this}nd";
      case 3:
        return "${this}rd";
      default:
        return "${this}th";
    }
  }
}

extension StringExtension on String {
  String? get crim => trim().isEmpty ? null : trim();

  String formatDuration(int totalSeconds) {
  if (totalSeconds < 0) {
    return 'Invalid duration';
  }

  final int days = totalSeconds ~/ 86400; // 86400 seconds in a day
  final int hours = (totalSeconds % 86400) ~/ 3600; // 3600 seconds in an hour
  final int minutes = (totalSeconds % 3600) ~/ 60; // 60 seconds in a minute
  final int seconds = totalSeconds % 60;

  final StringBuffer buffer = StringBuffer();

  if (days > 0) {
    buffer.write('$days day${days > 1 ? 's' : ''} ');
  }
  if (hours > 0) {
    buffer.write('$hours hr${hours > 1 ? 's' : ''} ');
  }
  if (minutes > 0) {
    buffer.write('$minutes min${minutes > 1 ? 's' : ''} ');
  }
  if (seconds > 0 || buffer.isEmpty) {
    buffer.write('$seconds sec${seconds > 1 ? 's' : ''}');
  }

  return buffer.toString().trim();
}

  String get initial {
    if (trim().isEmpty) {
      return "";
    }
    List<String> nameParts = trim().split(' ');
    if (nameParts.isNotEmpty) {
      String initials = nameParts[0][0];
      if (nameParts.length > 1) {
        initials += nameParts[1][0];
      }
      return initials;
    } else {
      return "";
    }
  }

  String get capLabel {
    String result = replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return ' ${match.group(0)!}';
    });
    return result[0].toUpperCase() + result.substring(1);
  }
}

extension DateTimeExtension on DateTime {
  String get dateLabel => DateFormat("dd-MM-yyyy").format(this);
  String get dateLabel2 => DateFormat("dd MMM, yyyy").format(this);
  String get dateLabel4 => DateFormat("dd MMM").format(this);
  String get dateTimeLabel => DateFormat("dd MMM yyyy hh:mm a").format(this);
  String get timeLabel => DateFormat("hh:mm a").format(this);
  String get timeData => DateFormat("hh:mm a").format(this);

  String get dateMonth => DateFormat("dd MMM").format(this);

  String get date => DateFormat("yyyy-MM-dd").format(this);

  String get dateLabel3 {
    final today = Dates.today;
    if (year == today.year && month == today.month && day == today.day) {
      return "Today";
    } else if (year == today.year &&
        month == today.month &&
        day == today.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMM, yyyy").format(this);
    }
  }

  Duration timezoneDifference(String timezone)  {
    
    const String indiaTimeZone = 'Asia/Kolkata';

    tz.TZDateTime easternNow = tz.TZDateTime.now(tz.getLocation(timezone));
    tz.TZDateTime indiaNow = tz.TZDateTime.now(tz.getLocation(indiaTimeZone));

    // Calculate the offset between the two time zones
    Duration easternOffset = easternNow.timeZoneOffset;
    Duration indiaOffset = indiaNow.timeZoneOffset;

    // Calculate the duration difference by adjusting the times manually
    Duration difference = indiaOffset - easternOffset;
    return difference;
  }

  DateTime forTimezone(String timezone)  {
    return add( timezoneDifference(timezone));
  }

  DateTime fromTimezone(String timezone) {
    return subtract( timezoneDifference(timezone));
  }
}

extension DurationExtension on Duration {
  String get mini {
    final hours = inHours.remainder(24);
    final min = inMinutes.remainder(60);
    return inDays != 0
        ? "${inDays}d "
        : hours != 0
            ? "${hours}h"
            : min != 0
                ? "${min}m"
                : "Now";
  }

  String get label {
    final hours = inHours.remainder(24);
    final min = inMinutes.remainder(60);
    final sec = inSeconds.remainder(60);
    return inDays != 0
        ? "${inDays}d "
        : hours != 0
            ? "${hours}h"
            : min != 0
                ? "${min}m"
                : sec != 0
                    ? "${sec}s"
                    : "";
  }

  String get playLabel {
   final int hours = inHours.remainder(24);
    final int minutes = inMinutes.remainder(60);
    final int seconds = inSeconds.remainder(60);
final String formattedMinutes = (minutes < 10 ? '0' : '') + minutes.toString();
final String formattedSeconds = (seconds < 10 ? '0' : '') + seconds.toString();

    if (inDays != 0) {
        return "$inDays:$hours:$formattedMinutes:$formattedSeconds";
    } else if (hours != 0) {
        return "$hours:$formattedMinutes:$formattedSeconds";
    } else if (minutes != 0) {
        return "$minutes:$formattedSeconds";
    } else if (seconds != 0) {
        return "0:$formattedSeconds";
    } else {
        return "";
    }
  }

  String get duration {
    final hours = inHours.remainder(24);
    final min = inMinutes.remainder(60);
    final sec = inSeconds.remainder(60);

    final minL = "0${inMinutes.remainder(60)}".split('').take(2).join('');
    final secL = "0${inSeconds.remainder(60)}".split('').take(2).join('');
    return inDays != 0
        ? "${inDays}d:${hours}h:${minL}m:${secL}s"
        : hours != 0
            ? "${hours}h:${minL}m:${secL}s"
            : min != 0
                ? "${min}m:${secL}s"
                : sec != 0
                    ? "0:${secL}s"
                    : "";
  }
}

extension AppLocalizationsExtension on AppLocalizations {
  String labelByArtistType(ArtistType type) {
    return {
          ArtistType.singer: singer,
          ArtistType.composer: composer,
          ArtistType.lyricist: lyricist,
          ArtistType.astrologer: astrologer,
          ArtistType.pandit: pandit,
          ArtistType.contributor: contributor,
          ArtistType.soundEngineer: soundEngineer,
          ArtistType.team: team,
          ArtistType.narrator: narrator,
          ArtistType.author: author,
        }[type] ??
        "";
  }

  String labelByGender(Gender gender) {
    return {
          Gender.female: female,
          Gender.male: male,
          Gender.other: other,
          Gender.preferNotToSay: preferNotToSay,
          Gender.nonBinary: nonBinary,
          Gender.unknown: "-",
        }[gender] ??
        "";
  }

  String labelsByAvahanDataType(AvahanDataType type) {
    return {
          AvahanDataType.artist: "Artists",
          AvahanDataType.category: "Categories",
          AvahanDataType.mood: "Moods",
          AvahanDataType.playlist: "Playlists",
          AvahanDataType.track: "Tracks",
        }[type] ??
        "";
  }

  String labelByAvahanDataType(AvahanDataType type) {
    return {
          AvahanDataType.artist: "Artist",
          AvahanDataType.category: "Category",
          AvahanDataType.mood: "Mood",
          AvahanDataType.playlist: "Playlist",
          AvahanDataType.track: "Track",
        }[type] ??
        "";
  }

  String labelsByNotifyFrequency(NotifyFrequency frequency) {
    return {
          NotifyFrequency.daily: "Daily",
          NotifyFrequency.weekly: "Weekly",
          NotifyFrequency.monthly: "Monthly",
          NotifyFrequency.once: "Once",
        }[frequency] ??
        "";
  }

  // String labelsByAvahanDataType(AvahanDataType type) {
  //   return {
  //         AvahanDataType.artist: artists,
  //         AvahanDataType.category: categories,
  //         AvahanDataType.mood: moods,
  //         AvahanDataType.playlist: playlists,
  //         AvahanDataType.track: tracks,
  //       }[type] ??
  //       "";
  // }

  // String labelByAvahanDataType(AvahanDataType type) {
  //   return {
  //         AvahanDataType.artist: artist,
  //         AvahanDataType.category: category,
  //         AvahanDataType.mood: mood,
  //         AvahanDataType.playlist: playlist,
  //         AvahanDataType.track: track,
  //       }[type] ??
  //       "";
  // }
}

extension WidgetRefExtension on WidgetRef {
  Lang get lang => watch(langProvider);

  NavigatorState? get state => read(navigatorProvider).currentState;

  Future<dynamic> push(String name, {Object? extra, WidgetRef? ref}) async {
    if (ref != null) {
      ref.read(dashboardNotifierProvider.notifier).setData(extra);
    } else {
      return state?.pushNamed(name, arguments: extra);
    }
  }

  void pop([Object? result]) {
    return state?.pop(result);
  }

  Future<dynamic> replace(String name, {Object? extra}) {
    return state?.pushReplacementNamed(name, arguments: extra) ??
        Future.value();
  }

  void go([WidgetRef? ref]) {
    state?.pushNamedAndRemoveUntil(
      Root.route,
      (route) => false,
    );
  }

  void authorized(WidgetRef ref, VoidCallback onAuthorized) {
    final guest = ref.read(yourProfileProvider).asData?.value.isGuest ?? true;
    if (guest) {
      push(OnboardPage.route);
    } else {
      onAuthorized();
    }
  }
}
