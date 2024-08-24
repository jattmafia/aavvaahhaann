import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/repositories/location_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'states_provider.g.dart';

@riverpod
FutureOr<List<LocObj>> states(StatesRef ref, String ciso) {
  return ref.read(locationRepositoryProvider).getStates(ciso);
}
