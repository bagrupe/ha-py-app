// ignore_for_file: cascade_invocations

import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repräsentiert die Konfiguration der App mit Backend-URL, Kommune und weiteren Einstellungen.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_config.freezed.dart';

/// Repräsentiert die Konfiguration der App mit Backend-URL, Kommune und weiteren Einstellungen.
@freezed
abstract class AppConfig with _$AppConfig {
  /// Erstellt eine neue AppConfig mit den angegebenen Parametern.
  const factory AppConfig({
    required String backendUrl,
    required String kommuneId,
    @Default(true) bool prozessPromptOnSkip,
    @Default(true) bool saveFieldValues,
  }) = _AppConfig;

  const AppConfig._();

  /// Gibt die Basis-URL für Schriftarten zurück, abgeleitet von der Backend-URL.
  String get fontsBaseUrl => '$backendUrl/fonts';
}

/// Verwalter für den Zustand der AppConfig mit Methoden zur Aktualisierung und Persistierung.
class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() {
    return ref.read(appConfigRepositoryProvider).read();
  }

  /// Setzt die Kommune und speichert die Änderung, falls sie sich unterscheidet.
  void setKommune(String kommuneId) {
    if (state.kommuneId == kommuneId) {
      return;
    }
    state = state.copyWith(kommuneId: kommuneId);
    _persistChanges();
  }

  /// Setzt die Backend-URL und speichert die Änderung.
  void setBackendUrl(String backendUrl) {
    state = state.copyWith(backendUrl: backendUrl);
    _persistChanges();
  }

  /// Setzt die Einstellung, ob beim Überspringen eines Schritts nachgefragt wird, und speichert sie.
  void setProzessPromptOnSkip(bool value) {
    state = state.copyWith(prozessPromptOnSkip: value);
    _persistChanges();
  }

  /// Setzt die Einstellung, ob bestimmte Feldwerte lokal gespeichert werden, und speichert sie.
  void setSaveFieldValues(bool value) {
    state = state.copyWith(saveFieldValues: value);
    _persistChanges();
  }

  /// Setzt die Konfiguration auf Standardwerte zurück und speichert die Änderung.
  void reset() {
    state = state.copyWith(prozessPromptOnSkip: true);
    _persistChanges();
  }

  /// Speichert den aktuellen Zustand der Konfiguration persistent.
  void _persistChanges() {
    final repository = ref.read(appConfigRepositoryProvider);
    repository.write(state);
  }
}

/// Repository zur Verwaltung der persistenten Speicherung der AppConfig in SharedPreferences.
class AppConfigRepository {
  /// Erstellt ein Repository mit der gegebenen SharedPreferences-Instanz.
  AppConfigRepository(SharedPreferences prefs) : _sharedPreferences = prefs;

  final SharedPreferences _sharedPreferences;
  static const _backendUrlKey = 'backend_url';
  static const _kommuneIdKey = 'kommune_id';
  static const _prozessPromptOnSkipKey = 'prozess_prompt_on_skip';

  /// Liest die gespeicherte Konfiguration aus den SharedPreferences aus.
  AppConfig read() {
    final prefs = _sharedPreferences;

    final backendUrl = getBackendUrl(prefs);
    final kommuneId = getKommuneId(prefs);
    return AppConfig(
      backendUrl: backendUrl,
      kommuneId: kommuneId,
      prozessPromptOnSkip: prefs.getBool(_prozessPromptOnSkipKey) ?? true,
    );
  }

  /// Schreibt die gegebene Konfiguration in die SharedPreferences.
  void write(AppConfig config) {
    final prefs = _sharedPreferences;

    prefs.setString(_backendUrlKey, config.backendUrl);
    prefs.setString(_kommuneIdKey, config.kommuneId);
    prefs.setBool(_prozessPromptOnSkipKey, config.prozessPromptOnSkip);
  }

  /// Liefert die Backend-URL aus den SharedPreferences oder den Standardwert.
  static String getBackendUrl(SharedPreferences prefs) {
    const defaultBackendUrl = String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: 'http://localhost:3000',
    );

    return prefs.getString(_backendUrlKey) ?? defaultBackendUrl;
  }

  /// Liefert die Kommune-ID aus den SharedPreferences oder den Standardwert.
  static String getKommuneId(SharedPreferences prefs) {
    const defaultKommuneId = String.fromEnvironment(
      'KOMMUNE_ID',
      defaultValue: KommuneIds.hapy,
    );

    return prefs.getString(_kommuneIdKey) ?? defaultKommuneId;
  }
}

/// Provider für den AppConfigNotifier zur Verwaltung des AppConfig-Zustands.
final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(
  AppConfigNotifier.new,
);

/// Provider für das AppConfigRepository zur persistenten Speicherung.
final appConfigRepositoryProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AppConfigRepository(sharedPreferences);
});
