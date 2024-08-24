import 'package:avahan/core/repositories/location_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cities_provider.g.dart';

@riverpod
FutureOr<List<String>> cities(CitiesRef ref, String ciso, String siso) {
  return ref.read(locationRepositoryProvider).getCities(ciso, siso);
}