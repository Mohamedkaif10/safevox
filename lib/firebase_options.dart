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
    apiKey: 'AIzaSyCMY9PwfZ1XTMRudkZ4oWNtgwNTbFjvsb8',
    appId: '1:688634038320:web:fae9a7ffc78661df7c05f5',
    messagingSenderId: '688634038320',
    projectId: 'soss-a2b8e',
    authDomain: 'soss-a2b8e.firebaseapp.com',
    storageBucket: 'soss-a2b8e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZD1MZruMl-fGjLGPIhKOo8YC5LW2Wx64',
    appId: '1:688634038320:android:fd76209116b8215b7c05f5',
    messagingSenderId: '688634038320',
    projectId: 'soss-a2b8e',
    storageBucket: 'soss-a2b8e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsSNeG0amk0pFAtIIpPXOs1jxvY8Dhe3E',
    appId: '1:688634038320:ios:ae8bd5c5e81470087c05f5',
    messagingSenderId: '688634038320',
    projectId: 'soss-a2b8e',
    storageBucket: 'soss-a2b8e.firebasestorage.app',
    iosBundleId: 'com.example.safevoxx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsSNeG0amk0pFAtIIpPXOs1jxvY8Dhe3E',
    appId: '1:688634038320:ios:ae8bd5c5e81470087c05f5',
    messagingSenderId: '688634038320',
    projectId: 'soss-a2b8e',
    storageBucket: 'soss-a2b8e.firebasestorage.app',
    iosBundleId: 'com.example.safevoxx',
  );
}
