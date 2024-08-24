import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track_access_provider.g.dart';

@riverpod
bool trackAccess(TrackAccessRef ref, int trackId) {
  try {
    final premium = ref.watch(premiumProvider).asData?.value;
    if (premium == true) {
      return true;
    }
    final masterData = ref.read(masterDataProvider).value!;
    if (masterData.freeSlots
        .where((element) =>
            element.start.isAfter(DateTime.now()) &&
            element.end.isBefore(DateTime.now()))
        .isNotEmpty) {
      return true;
    }
    final profile = ref.read(yourProfileProvider).asData?.value;

    if (profile?.lifetime == true) {
      return true;
    }

    if (masterData.freeTrialTracks.contains(trackId)) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
