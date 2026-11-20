// ignore_for_file: unawaited_futures

import 'dart:math';

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/notifications/notifications.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const abfallNotificationIdentifier = '888';

/// Verwalter für die Planung und Verwaltung von Abfall-Benachrichtigungen.
class AbfallNotifications {
  /// Erzeugt eine Instanz mit dem gegebenen Riverpod-Ref.
  AbfallNotifications(this._ref);
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Ref _ref;

  /// Prüft, ob die App die Berechtigung für Benachrichtigungen hat.
  Future<bool> hasPermission() async {
    final notifications = _ref.read(notificationsProvider);
    return notifications.hasPermission();
  }

  /// Fordert die Berechtigung für Benachrichtigungen an.
  Future<bool> requestPermission() async {
    final notifications = _ref.read(notificationsProvider);
    return notifications.requestPermission();
  }

  /// Plant die Abfall-Benachrichtigungen basierend auf der aktuellen Konfiguration.
  Future<void> schedule() async {
    if (kIsWeb) {
      return;
    }
    try {
      final abfallConfigRepo = _ref.read(abfallConfigRepositoryProvider);
      final abfallConfig = abfallConfigRepo.read();
      final filter = abfallConfig.filter;
      final benachrichtigungen = abfallConfig.benachrichtigungen;
      final notifications = _ref.read(notificationsProvider);
      final standortId = filter.standort;

      await deletePending();

      if (!benachrichtigungen.enabled) {
        return;
      }

      if (standortId == null) {
        return;
      }

      final graphQlClient = _ref.read(graphqlClientProvider);
      final kommuneId = _ref.read(kommuneProvider).value?.bereichAId;

      if (kommuneId == null) {
        return;
      }

      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

      final today = tz.TZDateTime.now(tz.getLocation('Europe/Berlin'));
      final in6Month = today.add(const Duration(days: 180));

      final res = await graphQlClient.query_Abfalltermine(
        Options_Query_Abfalltermine(
          variables: Variables_Query_Abfalltermine(
            kommuneIdBereichA: kommuneId,
            standortId: standortId,
            von: today,
            bis: in6Month,
            fraktionen: abfallConfig.filter.fraktionen?.split(',') ?? [],
          ),
        ),
      );

      final abfallkalenderList = res.parsedData?.kommune.abfallkalender ?? [];
      final rng = Random();
      for (final abfalltermin in abfallkalenderList) {
        // for some reason needs to be initialized here, because if initialized outside for loop the time zone is set back to UTZ
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

        final abbholtermin = tz.TZDateTime.parse(tz.local, abfalltermin.datum);
        final notificationDate = switch (benachrichtigungen.preset) {
          AbfallBenachrichtigungenPresets.previousDay => abbholtermin.copyWith(
            day: abbholtermin.day - 1,
            hour: benachrichtigungen.zeitpunkt.hour,
            minute: benachrichtigungen.zeitpunkt.minute,
          ),
        };

        if (notificationDate.isAfter(today)) {
          final nachricht = switch (benachrichtigungen.preset) {
            AbfallBenachrichtigungenPresets.previousDay =>
              'Morgen wird ${abfalltermin.fraktion} abgeholt!',
          };

          final id = int.parse(
            abfallNotificationIdentifier + rng.nextInt(217483).toString(),
          );
          notifications.schedule(
            id,
            abfalltermin.fraktion,
            nachricht,
            tz.TZDateTime.from(notificationDate, tz.local),
            'abfall',
            'Abfall',
            'Benachrichtigungen für die Abfallentsorgungstermine',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Löscht alle noch ausstehenden Abfall-Benachrichtigungen.
  Future<void> deletePending() async {
    final pendingNotificationRequests = await _flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    for (final pendingNotification in pendingNotificationRequests) {
      if (pendingNotification.id.toString().startsWith(
        abfallNotificationIdentifier,
      )) {
        _flutterLocalNotificationsPlugin.cancel(id: pendingNotification.id);
      }
    }
  }
}

/// Riverpod-Provider für die AbfallNotifications-Instanz.
final abfallNotificationsProvider = Provider(AbfallNotifications.new);
