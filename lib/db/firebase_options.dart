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
    apiKey: 'AIzaSyDLeG2vZQddutCriJAfZbGFSbdj0piLQbQ',
    appId: '1:427202038466:web:b9203cbff67f5a69b8495b',
    messagingSenderId: '427202038466',
    projectId: 'dream-diary-ecf74',
    authDomain: 'dream-diary-ecf74.firebaseapp.com',
    storageBucket: 'dream-diary-ecf74.appspot.com',
    measurementId: 'G-R0Z8BWN3D6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDA361wHoNJd4ydNWVbPRT4QwG7F7whDNU',
    appId: '1:427202038466:android:3f24e1c21ea5524bb8495b',
    messagingSenderId: '427202038466',
    projectId: 'dream-diary-ecf74',
    storageBucket: 'dream-diary-ecf74.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8bl_9FYTYeEX-gUxroib1NLQX6IGpFXs',
    appId: '1:427202038466:ios:f7e18fb33e433cbab8495b',
    messagingSenderId: '427202038466',
    projectId: 'dream-diary-ecf74',
    storageBucket: 'dream-diary-ecf74.appspot.com',
    iosBundleId: 'com.example.dreamDiary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8bl_9FYTYeEX-gUxroib1NLQX6IGpFXs',
    appId: '1:427202038466:ios:ee59c2680d17f4f9b8495b',
    messagingSenderId: '427202038466',
    projectId: 'dream-diary-ecf74',
    storageBucket: 'dream-diary-ecf74.appspot.com',
    iosBundleId: 'com.example.dreamDiary.RunnerTests',
  );
}
