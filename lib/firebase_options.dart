// Mock Firebase options for development/testing
// This file allows the app to run with mock data when Firebase is not configured
// To use real Firebase, run: flutterfire configure --project <your-project-id>

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// These are mock options - replace with real Firebase configuration
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
        return web; // Use web config as fallback
      case TargetPlatform.linux:
        return web; // Use web config as fallback
      default:
        return web; // Use web config as fallback
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'mock-api-key',
    appId: 'mock-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
    authDomain: 'mock-project-id.firebaseapp.com',
    storageBucket: 'mock-project-id.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'mock-android-api-key',
    appId: 'mock-android-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
    storageBucket: 'mock-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'mock-ios-api-key',
    appId: 'mock-ios-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
    storageBucket: 'mock-project-id.appspot.com',
    iosClientId: 'mock-ios-client-id',
    iosBundleId: 'com.example.mock',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'mock-macos-api-key',
    appId: 'mock-macos-app-id',
    messagingSenderId: 'mock-sender-id',
    projectId: 'mock-project-id',
    storageBucket: 'mock-project-id.appspot.com',
    iosClientId: 'mock-macos-client-id',
    iosBundleId: 'com.example.mock',
  );
}
