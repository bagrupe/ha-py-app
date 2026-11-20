// ignore_for_file: cascade_invocations

import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Historie = Query_MyMitteilungen_my__Buerger_mitteilungen_historie;

/// Repräsentiert eine einzelne Mitteilung mit zugehöriger Historie und Prozessnamen.
@immutable
class MitteilungData {
  /// Erzeugt eine Instanz von MitteilungData mit ID, Prozessnamen und Historie.
  const MitteilungData({
    required this.id,
    required this.prozessName,
    required this.historie,
  });
  final String id;
  final String prozessName;
  final Historie historie;
}

/// Lädt einen Stream von Mitteilungen für den aktuellen Benutzer.
Stream<List<MitteilungData>> _loadMitteilungData(Ref ref) {
  final client = ref.watch(graphqlClientProvider);
  final buergerId = ref.watch(authProvider).buergerId;

  return client
      .watchQuery_MyMitteilungen(
        WatchOptions_Query_MyMitteilungen(fetchResults: true),
      )
      .stream
      .where((res) => res.isNotLoading)
      .map((res) => res.parsedData!.my)
      .where(
        (my) => my is Query_MyMitteilungen_my__Buerger && my.id == buergerId,
      )
      .cast<Query_MyMitteilungen_my__Buerger>()
      .map(
        (b) => b.mitteilungen
            .map(
              (mitteilung) => mitteilung.historie.map(
                (historie) => MitteilungData(
                  id: mitteilung.id,
                  prozessName: mitteilung.prozessVersion.prozess.name,
                  historie: historie,
                ),
              ),
            )
            .expand((e) => e)
            .toList(),
      );
}

/// Provider für asynchrone Liste von Mitteilungen.
final asyncMitteilungenProvider = StreamProvider<List<MitteilungData>>(
  _loadMitteilungData,
);

/// Provider für synchronen Zugriff auf die Mitteilungen, gibt null bei Ladezustand zurück.
final mitteilungenDataProvider = Provider<List<MitteilungData>?>((ref) {
  final asyncMitteilungen = ref.watch(asyncMitteilungenProvider);

  return switch (asyncMitteilungen) {
    AsyncData(:final value) => value,
    AsyncError() => [],
    _ => null,
  };
});

const mitteilungenLastReadKey = 'mitteilungen_last_read';

/// Notifier zur Verwaltung der Anzahl ungelesener Mitteilungen.
class MitteilungenCountNotifier extends Notifier<int> {
  @override
  int build() {
    return _getUnreadCount();
  }

  /// Ermittelt die Anzahl der ungelesenen Mitteilungen basierend auf dem letzten Lesezeitpunkt.
  int _getUnreadCount() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final mitteilungData = ref.watch(mitteilungenDataProvider);

    final lastRead = prefs.getString(mitteilungenLastReadKey);

    if (lastRead != null) {
      final lastReadDate = DateTime.parse(lastRead);
      final unread = mitteilungData?.where(
        (m) => m.historie.createdAt.isAfter(lastReadDate),
      );
      return unread?.length ?? 0;
    }

    return mitteilungData?.length ?? 0;
  }

  /// Setzt den aktuellen Zeitpunkt als letzten Lesezeitpunkt und aktualisiert den Status.
  void setLastRead() {
    final prefs = ref.watch(sharedPreferencesProvider);
    prefs.setString(mitteilungenLastReadKey, DateTime.now().toIso8601String());

    state = _getUnreadCount();
  }
}

/// Provider für den Notifier der ungelesenen Mitteilungenanzahl.
final mitteilungenCountNotifierProvider =
    NotifierProvider<MitteilungenCountNotifier, int>(() {
      return MitteilungenCountNotifier();
    });
