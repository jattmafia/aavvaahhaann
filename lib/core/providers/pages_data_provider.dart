


import 'package:avahan/core/models/pages_data.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pagesDataProvider = FutureProvider<PagesData>(
  (ref) => ref.read(masterDataRepositoryProvider).getPagesData(),
);
