import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deviceInfoProvider = FutureProvider<MapEntry<String, String>>(
  (ref) async {
    if(kIsWeb) {
      return MapEntry('web', 'web');
    } else {
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        return MapEntry(info.id, info.model);
      } else if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        return MapEntry(info.identifierForVendor ?? "", info.model);
      } else {
        return const MapEntry("", "");
      }
    }
  },
);
