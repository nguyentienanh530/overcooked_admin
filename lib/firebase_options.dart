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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC-Hvr2eMGEkWvEMhhfmjed_KOR2bWP6dY',
    appId: '1:83984534471:web:228c7fd3ef36f65b8827e2',
    messagingSenderId: '83984534471',
    projectId: 'overcooked-d5f12',
    authDomain: 'overcooked-d5f12.firebaseapp.com',
    storageBucket: 'overcooked-d5f12.appspot.com',
    measurementId: 'G-WXXYE8LS10',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCe1QYo8EBWGl76RlVG8DENrD7FFCOZ4W0',
    appId: '1:83984534471:android:cbd20634f2212ca98827e2',
    messagingSenderId: '83984534471',
    projectId: 'overcooked-d5f12',
    storageBucket: 'overcooked-d5f12.appspot.com',
  );
}