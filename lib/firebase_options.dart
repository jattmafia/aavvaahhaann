// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBHi5Wm2R5Sw9TWybBAMBQgfnVQlf8qMok',
    appId: '1:906533537374:web:1b64dfc1ea3636c68756cf',
    messagingSenderId: '906533537374',
    projectId: 'avahan-ceff5',
    authDomain: 'avahan-ceff5.firebaseapp.com',
    storageBucket: 'avahan-ceff5.appspot.com',
    measurementId: 'G-FD6DVDP4CL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCm_F-35vHE8No7iZJz5lRCvrrZ4dLrpf0',
    appId: '1:906533537374:android:dcd0b1ff8035fccb8756cf',
    messagingSenderId: '906533537374',
    projectId: 'avahan-ceff5',
    storageBucket: 'avahan-ceff5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtsX1VrXVlEU8Uk0MyXDMvP3qWaSbiqIM',
    appId: '1:906533537374:ios:7af75024cb9a459f8756cf',
    messagingSenderId: '906533537374',
    projectId: 'avahan-ceff5',
    storageBucket: 'avahan-ceff5.appspot.com',
    androidClientId: '906533537374-3shmsli7dfupcqg99d8239fgbc059c2n.apps.googleusercontent.com',
    iosClientId: '906533537374-8japtb1qcuudh4ubdb4i8j7sv5forpui.apps.googleusercontent.com',
    iosBundleId: 'com.avahan.ios',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtsX1VrXVlEU8Uk0MyXDMvP3qWaSbiqIM',
    appId: '1:906533537374:ios:802bd75c853514a68756cf',
    messagingSenderId: '906533537374',
    projectId: 'avahan-ceff5',
    storageBucket: 'avahan-ceff5.appspot.com',
    androidClientId: '906533537374-3shmsli7dfupcqg99d8239fgbc059c2n.apps.googleusercontent.com',
    iosClientId: '906533537374-noej2plmfe7m7ccj667kfv7uq3i3lbon.apps.googleusercontent.com',
    iosBundleId: 'com.avahan.avahan.RunnerTests',
  );
}
