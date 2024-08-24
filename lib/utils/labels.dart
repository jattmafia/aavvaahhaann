import 'package:avahan/config.dart';
import 'package:avahan/core/enums/lang.dart';

class Labels {
  static String lang(Lang lang) {
    return switch (lang) {
      Lang.en => 'English',
      Lang.hi => 'Hindi',
    };
  }



  static String appShareMessage = 'Download the app now and enjoy the music\n${Config.appLink}';
}
