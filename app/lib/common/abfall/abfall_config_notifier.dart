// ignore_for_file: cascade_invocations

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_config.dart';
import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/abfall_notifications.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Verwalter für die Abfallkonfiguration mit Persistenz und Benachrichtigungsplanung.
class AbfallConfigNotifier extends Notifier<AbfallConfig> {
  @override
  /// Lädt die aktuelle Abfallkonfiguration aus dem Repository.
  AbfallConfig build() {
    return ref.read(abfallConfigRepositoryProvider).read();
  }

  /// Setzt die gesamte Konfiguration mit optionalem Filter und Benachrichtigungen.
  Future<void> setConfig(
    AbfallFilter? filter,
    AbfallBenachrichtigungen? benachrichtigungen,
  ) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(
        filter: filter ?? state.filter,
        benachrichtigungen: benachrichtigungen ?? state.benachrichtigungen,
      ),
    );
  }

  /// Aktualisiert den Filter der Abfallkonfiguration.
  Future<void> setFilter(AbfallFilter? filter) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(filter: filter ?? state.filter),
    );
  }

  /// Setzt den Ort im Filter.
  Future<void> setOrt(String? ort) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(filter: state.filter.copyWith(ort: ort)),
    );
  }

  /// Setzt den Anfangsbuchstaben im Filter.
  Future<void> setAnfangsbuchstabe(String? anfangsbuchstabe) async {
    await _persistChangesAndScheduleNotifications(
      state = state.copyWith(
        filter: state.filter.copyWith(anfangsbuchstabe: anfangsbuchstabe),
      ),
    );
  }

  /// Setzt die Straße im Filter.
  Future<void> setStrasse(String strasse) async {
    await _persistChangesAndScheduleNotifications(
      state = state.copyWith(filter: state.filter.copyWith(strasse: strasse)),
    );
  }

  /// Setzt den Standort im Filter.
  Future<void> setStandort(String standort) async {
    await _persistChangesAndScheduleNotifications(
      state = state.copyWith(filter: state.filter.copyWith(standort: standort)),
    );
  }

  /// Setzt die Fraktionen im Filter.
  Future<void> setFraktionen(String fraktionen) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(filter: state.filter.copyWith(fraktionen: fraktionen)),
    );
  }

  /// Aktiviert oder deaktiviert die Benachrichtigungen.
  Future<void> setEnabled(bool? enabled) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(
        benachrichtigungen: state.benachrichtigungen.copyWith(
          enabled: enabled ?? state.benachrichtigungen.enabled,
        ),
      ),
    );
  }

  /// Setzt den Zeitpunkt der Benachrichtigungen.
  Future<void> setZeitpunkt(TimeOfDay? zeitpunkt) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(
        benachrichtigungen: state.benachrichtigungen.copyWith(
          zeitpunkt: zeitpunkt ?? state.benachrichtigungen.zeitpunkt,
        ),
      ),
    );
  }

  /// Setzt das Preset der Benachrichtigungen.
  Future<void> setPreset(AbfallBenachrichtigungenPresets? preset) async {
    await _persistChangesAndScheduleNotifications(
      state.copyWith(
        benachrichtigungen: state.benachrichtigungen.copyWith(
          preset: preset ?? state.benachrichtigungen.preset,
        ),
      ),
    );
  }

  /// Speichert die Konfiguration und plant die Benachrichtigungen neu.
  Future<void> _persistChangesAndScheduleNotifications(
    AbfallConfig config,
  ) async {
    state = config;
    final benachrichtigungen = ref.read(abfallNotificationsProvider);
    final repository = ref.read(abfallConfigRepositoryProvider);
    repository.write(state);
    await benachrichtigungen.schedule();
  }
}
