import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Whether Firebase Push is initialized on the current platform.
bool get isFirebasePushAvailable => !kIsWeb && Firebase.apps.isNotEmpty;

/// Initializes Firebase Push when the native configuration is provided.
Future<void> initializeFirebasePush() async {
  // TODO: Restore the native Firebase configuration and uncomment this for Firebase Push notifications.
  // if (!kIsWeb) await Firebase.initializeApp();
}
