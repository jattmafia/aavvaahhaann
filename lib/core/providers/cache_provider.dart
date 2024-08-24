import 'package:avahan/core/enums/lang.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cacheProvider = FutureProvider((ref) => SharedPreferences.getInstance());

extension SharedPreferencesExtension on SharedPreferences {
  Lang get lang => Lang.values.firstWhere(
        (element) => element.name == getString('lang'),
        orElse: () => Lang.en,
      );

  Future<void> setLang(Lang lang) {
    return setString('lang', lang.name);
  }

  DateTime? get infoAskedAt {
    final value = getInt('infoAskedAt');
    return value == null ? null : DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> setInfoAskedAt(DateTime value) {
    return setInt('infoAskedAt', value.millisecondsSinceEpoch);
  }
}
