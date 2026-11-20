import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/notifications/notification_channel.dart';
import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/graphql/__generated__/login.graphql.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String pushNotificationRequestedKey = 'push_notification_requested';

/// Ermittelt die initiale Navigationsroute basierend auf einer Benachrichtigung beim App-Start.
Future<String?> getInitialRouteFromNotification() async {
  if (!isFirebasePushAvailable) return null;

  final notificationsAllowed = await Permission.notification.isGranted;
  if (!notificationsAllowed) return null;

  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    return NotificationService._getRouteFromMessage(initialMessage.data);
  }

  return null;
}

/// Dienst zur Verwaltung von Push-Benachrichtigungen und lokalen Benachrichtigungen.
class NotificationService {
  @visibleForTesting
  NotificationService({
    required this.graphQLClient,
    required this.kommuneBereichAId,
    required this.routerRef,
  });
  final GraphQLClient graphQLClient;
  final String kommuneBereichAId;
  final Ref routerRef;
  String _token = '';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialisiert die Benachrichtigungsdienste und registriert Listener.
  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      androidDefaultNotificationIcon,
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    if (!kIsWeb) {
      final androidLocal = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidLocal != null) {
        await androidLocal.createNotificationChannel(
          androidHighImportanceChannel,
        );
        await androidLocal.createNotificationChannel(
          androidAbfallNotificationChannel,
        );
      }

      if (!isFirebasePushAvailable) return;

      FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteNotificationTap);

      FirebaseMessaging.onMessage.listen(_refreshMitteilungen);
      FirebaseMessaging.onMessageOpenedApp.listen(_refreshMitteilungen);

      FirebaseMessaging.onMessage.listen(
        _handleRemoteMessageReceivedWhileForegrounded,
      );

      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        _token = token;
        await _submitPushToken(token);
      });

      if (await hasPermission()) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          _token = token;
          await _submitPushToken(token);
        }
      }

      // iOS
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _refreshMitteilungen(RemoteMessage _) {
    unawaited(graphQLClient.refetchByName('MyMitteilungen'));
  }

  /// Prüft, ob die Benachrichtigungsberechtigung erteilt wurde.
  Future<bool> hasPermission() async {
    return Permission.notification.isGranted;
  }

  /// Fordert die Benachrichtigungsberechtigung an und registriert das Token.
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (!isFirebasePushAvailable) {
      return (await Permission.notification.request()).isGranted;
    }

    final result = await FirebaseMessaging.instance.requestPermission();

    final isAuthorized =
        result.authorizationStatus == AuthorizationStatus.authorized ||
        result.authorizationStatus == AuthorizationStatus.provisional;

    if (!isAuthorized) return false;

    try {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.getAPNSToken();
      }

      final token = await FirebaseMessaging.instance.getToken();

      if (token == null) return false;

      await _submitPushToken(token);
    } on Exception catch (e) {
      await Sentry.captureException(e);
      return false;
    }

    return true;
  }

  /// Zeigt eine lokale Benachrichtigung an.
  void show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) {
    _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  /// Plant eine Benachrichtigung zu einem bestimmten Zeitpunkt.
  Future<void> schedule(
    int id,
    String title,
    String description,
    tz.TZDateTime scheduledDate,
    String channelId,
    String channelName,
    String channelDescription,
  ) async {
    if (!await hasPermission()) return;

    tz.initializeTimeZones();

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge: true,
      // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    );

    final androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // Required for scheduled notifications: ScheduledNotificationReceiver runs
      // without Flutter and does not inherit AndroidInitializationSettings icon.
      icon: androidDefaultNotificationIcon,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      await _localNotifications.zonedSchedule(
        id: id,
        title: title,
        body: description,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'scheduledDate: $scheduledDate',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Löscht alle geplanten und angezeigten Benachrichtigungen.
  Future<void> deleteAllNotifications() {
    return _localNotifications.cancelAll();
  }

  /// Gibt alle ausstehenden Benachrichtigungen in der Konsole aus (nur Debug).
  Future<void> printPendingNotifications() async {
    if (kDebugMode) {
      final pendingNotificationRequests = await _localNotifications
          .pendingNotificationRequests();
      print('-----------------------');
      print('Pending Notifications');
      print(pendingNotificationRequests.length);
      for (final pendingNot in pendingNotificationRequests) {
        print(
          '${pendingNot.payload} Id: ${pendingNot.id}  ${pendingNot.title}',
        );
      }
      print('-----------------------');
    }
  }

  /// Setzt das Push-Token zurück und registriert es neu.
  Future<void> resetToken() async {
    if (!isFirebasePushAvailable) return;
    await FirebaseMessaging.instance.deleteToken();
    _token = await FirebaseMessaging.instance.getToken() ?? '';
    await _submitPushToken(_token);
  }

  /// Sendet das Push-Token an den Server zur Registrierung.
  Future<void> _submitPushToken(String token) async {
    final registerOptions = Options_Mutation_RegisterToken(
      variables: Variables_Mutation_RegisterToken(
        input: Input_NotificationTokenRegisterInput(
          token: token,
          kommuneId: kommuneBereichAId,
        ),
      ),
    );

    await graphQLClient.mutate_RegisterToken(registerOptions);
  }

  /// Behandelt eingehende Nachrichten im Vordergrund auf Android durch lokale Benachrichtigung.
  void _handleRemoteMessageReceivedWhileForegrounded(RemoteMessage event) {
    if (kIsWeb || !Platform.isAndroid) {
      return;
    }

    final notification = event.notification;

    if (notification == null) return;

    // Firebase Android SDK blocks displaying notifications when the app is
    // in the foreground. The workaround is to trigger a local notification,
    // which does not have this limitation.
    // See: https://firebase.flutter.dev/docs/messaging/notifications/#application-in-foreground

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      payload: jsonEncode(event.data),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidHighImportanceChannel.id,
          androidHighImportanceChannel.name,
          channelDescription: androidHighImportanceChannel.description,
          importance: androidHighImportanceChannel.importance,
          icon: androidDefaultNotificationIcon,
          fullScreenIntent: true,
        ),
      ),
    );
  }

  /// Behandelt das Antippen einer lokalen Benachrichtigung.
  void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) {
      return;
    }
    final data = jsonDecode(payload);
    if (data is Map<String, dynamic>) {
      _handleNotificationTap(data);
    }
  }

  /// Behandelt das Antippen einer Remote-Benachrichtigung.
  void _handleRemoteNotificationTap(RemoteMessage message) {
    _handleNotificationTap(message.data);
  }

  /// Verarbeitet die Navigation basierend auf den Daten einer Benachrichtigung.
  Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    String? resultLocation;

    switch (data['type']) {
      case 'mangel':
        final mangelId = data['id'] as String;
        await graphQLClient.query_Mangel(
          Options_Query_Mangel(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            variables: Variables_Query_Mangel(
              mangelId: mangelId,
              kommuneId: kommuneBereichAId,
            ),
          ),
        );

        resultLocation = _getRouteFromMessage(data);
      case 'ausfuehrung':
        final ausfuehrungId = data['id'] as String;
        await graphQLClient.query_AusfuehrungHistorie(
          Options_Query_AusfuehrungHistorie(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            variables: Variables_Query_AusfuehrungHistorie(id: ausfuehrungId),
          ),
        );

        resultLocation = _getRouteFromMessage(data);
      case 'newsartikel':
        resultLocation = _getRouteFromMessage(data);
      case 'sensor':
        final sensorId = data['id'] as String;
        await graphQLClient.query_Sensor(
          Options_Query_Sensor(
            fetchPolicy: FetchPolicy.cacheAndNetwork,
            variables: Variables_Query_Sensor(
              sensorId: sensorId,
              duration: Enum_HistoryMode.LAST_DAY,
            ),
          ),
        );

        resultLocation = _getRouteFromMessage(data);
    }

    if (resultLocation != null) {
      routerRef.read(routerProvider).go(resultLocation);
    }

    return;
  }

  /// Ermittelt die Navigationsroute aus den Benachrichtigungsdaten.
  static String? _getRouteFromMessage(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'mangel':
        final mangelId = data['id'];
        return '/karte/maengel/detail/$mangelId';
      case 'ausfuehrung':
        final ausfuehrungId = data['id'];
        return '/antraege/detail/$ausfuehrungId';
      case 'newsartikel':
        final newsId = data['id'];
        return '/aktuelles/news/$newsId';
      case 'sensor':
        final sensorId = data['id'];
        return '/karte/sensor/$sensorId';
    }

    return null;
  }

  /// Liefert das aktuell registrierte Push-Token.
  String? get token {
    return _token;
  }
}

/// Provider für den NotificationService.
final notificationsProvider = Provider((ref) {
  final graphqlClient = ref.watch(graphqlClientProvider);
  final kommuneBereichAId = ref.watch(appConfigProvider).kommuneId;

  final notificationService = NotificationService(
    graphQLClient: graphqlClient,
    kommuneBereichAId: kommuneBereichAId,
    routerRef: ref,
  );

  return notificationService;
});
