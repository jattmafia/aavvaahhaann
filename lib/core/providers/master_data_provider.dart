import 'package:avahan/core/models/master_data.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final masterDataProvider = FutureProvider<MasterData>(
  (ref)=> ref.read(masterDataRepositoryProvider).getMasterData(),
);
