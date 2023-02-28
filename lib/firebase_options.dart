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
    apiKey: 'AIzaSyDq-hngRzaqEKILaoV4pYBl6zdZEru5Iw0',
    appId: '1:157033744202:web:1332f9816ba8619e21a3b3',
    messagingSenderId: '157033744202',
    projectId: 'olxapp-b5dbc',
    authDomain: 'olxapp-b5dbc.firebaseapp.com',
    storageBucket: 'olxapp-b5dbc.appspot.com',
    measurementId: 'G-VN3TR7RP7F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnYdLGxpiiiQ1ab1xmr8hlQ8WpO431Ts0',
    appId: '1:157033744202:android:bdad8c3cb0042e2f21a3b3',
    messagingSenderId: '157033744202',
    projectId: 'olxapp-b5dbc',
    storageBucket: 'olxapp-b5dbc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWYlwkAYYb-5eFlyhrKUg8OTal2BgInns',
    appId: '1:157033744202:ios:565bea767d441daf21a3b3',
    messagingSenderId: '157033744202',
    projectId: 'olxapp-b5dbc',
    storageBucket: 'olxapp-b5dbc.appspot.com',
    androidClientId: '157033744202-dvnlool8na6861b7ho3hkf0cek6g79kf.apps.googleusercontent.com',
    iosClientId: '157033744202-isa7khtuuue1lqqdmudr7fm0ebki8h5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.olx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWYlwkAYYb-5eFlyhrKUg8OTal2BgInns',
    appId: '1:157033744202:ios:565bea767d441daf21a3b3',
    messagingSenderId: '157033744202',
    projectId: 'olxapp-b5dbc',
    storageBucket: 'olxapp-b5dbc.appspot.com',
    androidClientId: '157033744202-dvnlool8na6861b7ho3hkf0cek6g79kf.apps.googleusercontent.com',
    iosClientId: '157033744202-isa7khtuuue1lqqdmudr7fm0ebki8h5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.olx',
  );
}