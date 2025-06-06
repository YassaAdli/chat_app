// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBDEGkSf4FQZ8x5rPu49NU9Y__CmhvRAuI',
    appId: '1:601826317487:web:62d6d99295ec43ee27f05a',
    messagingSenderId: '601826317487',
    projectId: 'chat-app-c30d0',
    authDomain: 'chat-app-c30d0.firebaseapp.com',
    storageBucket: 'chat-app-c30d0.firebasestorage.app',
    measurementId: 'G-4DDGE772T9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhjnrpOvQOqHtvL0ABL8TlM-D-zp8Io8I',
    appId: '1:601826317487:android:72d407290e460e3b27f05a',
    messagingSenderId: '601826317487',
    projectId: 'chat-app-c30d0',
    storageBucket: 'chat-app-c30d0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAT97n8V-JvmqHcgAMk_IwIWoaZ39kSio4',
    appId: '1:601826317487:ios:711447f709ed1c5527f05a',
    messagingSenderId: '601826317487',
    projectId: 'chat-app-c30d0',
    storageBucket: 'chat-app-c30d0.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );
}
