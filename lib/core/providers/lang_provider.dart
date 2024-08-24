


import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final langProvider = StateProvider<Lang>((ref) {
  return ref.watch(cacheProvider).asData?.value.lang ?? Lang.en;
});



