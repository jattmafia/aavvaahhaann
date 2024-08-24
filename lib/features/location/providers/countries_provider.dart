import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/repositories/location_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countries_provider.g.dart';

@riverpod
FutureOr<List<LocObj>> countries(CountriesRef ref) {
  return ref.read(locationRepositoryProvider).getCountries();
}
