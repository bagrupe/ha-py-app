import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Small icon for Android notifications; must exist under `android/app/src/.../res/mipmap/`.
const String androidDefaultNotificationIcon = '@mipmap/ic_launcher';

/// Definiert einen Android-Benachrichtigungskanal mit hoher Priorität für die Ha-Py App.
const AndroidNotificationChannel androidHighImportanceChannel =
    AndroidNotificationChannel(
      'hapy_app_channel',
      'Benachrichtigungen',
      description: 'Benachrichtigungen in der Ha-Py App',
      importance: Importance.max,
    );

/// Kanal für lokale Abfallkalender-Erinnerungen (channelId wie in Abfall-Scheduling).
const AndroidNotificationChannel androidAbfallNotificationChannel =
    AndroidNotificationChannel(
      'abfall',
      'Abfall',
      description: 'Benachrichtigungen für die Abfallentsorgungstermine',
      importance: Importance.max,
    );
