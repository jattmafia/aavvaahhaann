import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/features/profile/providers/guest_provider.dart';
import 'package:avahan/utils/cache_keys.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';

part 'your_profile_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Profile> yourProfile(YourProfileRef ref) async {
  // final cache = await ref.read(cacheProvider.future);
  ref.watch(sessionProvider.select((value) =>
      (value?.user.id).hashCode ^
      (value?.user.email).hashCode ^
      (value?.user.phone).hashCode));
  final session = ref.read(sessionProvider);
  if (session == null) {
    final cache = await ref.read(cacheProvider.future);
    final guest = cache.getBool(CacheKeys.guest);
    if (guest == true) {
      final guest = await ref.read(guestProvider.future);

      if (guest != null) {
        return Profile(
          id: guest.id,
          name: "Guest",
          gender: Gender.unknown,
          channel: guest.channel,
          deviceId: guest.deviceId,
          deviceName: guest.deviceName,
          createdAt: guest.createdAt,
          expiryAt: guest.expiryAt,
        );
      }
    }
    return Future.error('user-not-logined');
  } else {
    try {
      final value = await ref
          .read(profileRepositoryProvider)
          .getProfileFromUUID(session.user.id);

      final cache = await ref.read(cacheProvider.future);
      cache.setInt('uid', value.id);

      if (session.user.email != null && value.email != session.user.email) {
        ref
            .read(profileRepositoryProvider)
            .updateEmail(value.id, session.user.email!);
      }
      if (session.user.phone != null &&
          value.phoneNumber != session.user.phone) {
        ref
            .read(profileRepositoryProvider)
            .updatePhoneNumber(value.id, session.user.phone!);
      }
      return value.copyWith(
        email: session.user.email?.crim,
        phoneNumber: session.user.phone?.crim,
      );
    } catch (e) {
      if (session.user.phone?.crim != null) {
        final value = await ref
            .read(profileRepositoryProvider)
            .getProfileFromPhoneNumber(session.user.phone!, session.user.id);
        final cache = await ref.read(cacheProvider.future);
        cache.setInt('uid', value.id);
        return value;
      } else if (session.user.email?.crim != null) {
        final value = await ref
            .read(profileRepositoryProvider)
            .getProfileFromEmail(session.user.email!, session.user.id);
        final cache = await ref.read(cacheProvider.future);
        cache.setInt('uid', value.id);
        return value;
      } else {
        return Future.error(e);
      }
    }
  }
}
