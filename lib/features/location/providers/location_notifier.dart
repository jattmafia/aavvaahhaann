// ignore_for_file: unused_result

import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/location.dart';
import 'package:avahan/core/repositories/location_repository.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/profile/providers/welcome_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_notifier.g.dart';

@riverpod
class LocationNotifier extends _$LocationNotifier {
  @override
  FutureOr<Location> build() async {
    return ref.read(locationRepositoryProvider).getLocation();
  }

  void countryChanged(String country, String isoCode) {
    state = AsyncValue.data(
      state.value!.copyWith(
        country: country,
        isoCode: isoCode,
        clearCity: true,
        clearState: true,
      ),
    );
  }

  void stateChanged(String state, String stateCode) {
    this.state = AsyncValue.data(
      this.state.value!.copyWith(
            state: state,
            stateCode: stateCode,
            clearCity: true,
          ),
    );
  }

  void cityChanged(String city) {
    state = AsyncValue.data(state.value!.copyWith(
      city: city,
    ));
  }

  Future<void> skip() async {
    final updated = state.value!.copyWith(
      clearCity: true,
    );
    await write(updated);
  }

  Future<void> write([Location? location]) async {
    var finalLocation = location ?? state.value!;
    state = const AsyncValue.loading();
    try {
      final profile = await ref.read(yourProfileProvider.future);
      
       ref.read(welcomeProvider.notifier).state = true;

      final updated = profile.copyWith(
        country: finalLocation.country,
        state: finalLocation.state,
        city: finalLocation.city,
        isoCode: finalLocation.isoCode,
        stateCode: finalLocation.stateCode,
      );
      await ref.read(profileRepositoryProvider).writeProfile(updated);
      await ref.refresh(yourProfileProvider.future);
    } on Exception catch (e) {
      state = AsyncValue.data(finalLocation);
      return Future.error(e.parse);
    }
  }
}
