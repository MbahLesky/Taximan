// Shared Taximan Firebase project options.
// Regenerate this file with FlutterFire CLI after registering driver-specific
// platform apps in Firebase.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHM5DK9xsWmRkzgHEjqyw6aP11qRLovDo',
    appId: '1:385844694654:web:712a2c57326a96b84b522f',
    messagingSenderId: '385844694654',
    projectId: 'taximan-835d2',
    authDomain: 'taximan-835d2.firebaseapp.com',
    storageBucket: 'taximan-835d2.firebasestorage.app',
    measurementId: 'G-F50FHHCB5Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJPCfLMfuGkXNwyfn95x78sAFypDfLjaM',
    appId: '1:385844694654:android:88d5b55fa115ad014b522f',
    messagingSenderId: '385844694654',
    projectId: 'taximan-835d2',
    storageBucket: 'taximan-835d2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzmvD-cq-vN37ocu7uyhEGF99gDOVL8IU',
    appId: '1:385844694654:ios:fd21fd709daf4c9e4b522f',
    messagingSenderId: '385844694654',
    projectId: 'taximan-835d2',
    storageBucket: 'taximan-835d2.firebasestorage.app',
    iosBundleId: 'com.iamlespa.taximanDriver',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzmvD-cq-vN37ocu7uyhEGF99gDOVL8IU',
    appId: '1:385844694654:ios:fd21fd709daf4c9e4b522f',
    messagingSenderId: '385844694654',
    projectId: 'taximan-835d2',
    storageBucket: 'taximan-835d2.firebasestorage.app',
    iosBundleId: 'com.iamlespa.taximanDriver',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHM5DK9xsWmRkzgHEjqyw6aP11qRLovDo',
    appId: '1:385844694654:web:d6dd6bb1c1a6b4124b522f',
    messagingSenderId: '385844694654',
    projectId: 'taximan-835d2',
    authDomain: 'taximan-835d2.firebaseapp.com',
    storageBucket: 'taximan-835d2.firebasestorage.app',
    measurementId: 'G-Z3GK1M6Z63',
  );
}
