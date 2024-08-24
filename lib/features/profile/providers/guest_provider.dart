import 'package:avahan/core/models/guest.dart';
import 'package:avahan/core/providers/device_info_provider.dart';
import 'package:avahan/core/repositories/guest_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final guestProvider = FutureProvider.autoDispose<Guest?>((ref) async {
  final deviceInfo = await ref.read(deviceInfoProvider.future);
   try {
   return await ref
      .read(guestRepositoryProvider)
      .getGuestFromDeviceId(deviceInfo.key);
   } catch (e) {
     return null;
   }
});
