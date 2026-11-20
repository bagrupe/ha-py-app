// ignore_for_file: cascade_invocations

import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String selectedGemeindeFilterPrefKey = 'selectedGemeindeFilter';

/// Repräsentiert den Zustand des Gemeinde-Filters mit der aktuellen Auswahl.
class GemeindeFilterState {
  /// Erstellt einen neuen Zustand mit der gegebenen Liste von Gemeinde-IDs.
  const GemeindeFilterState(this.currentGemeindePrefs);
  final List<String> currentGemeindePrefs;
}

/// Verwalter für den Zustand des Gemeinde-Filters mit Persistierung in SharedPreferences.
class GemeindeFilterNotifier extends Notifier<GemeindeFilterState> {
  @override
  GemeindeFilterState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final gemeindeFilter =
        prefs.getStringList(selectedGemeindeFilterPrefKey) ?? [];

    return GemeindeFilterState(gemeindeFilter);
  }

  /// Aktualisiert den Gemeinde-Filter und speichert die Auswahl persistent.
  /// [nextGemeindeFilter] ist die neue Liste der ausgewählten Gemeinden.
  void updateGemeindeFilter(List<String> nextGemeindeFilter) {
    state = GemeindeFilterState(nextGemeindeFilter);

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setStringList(selectedGemeindeFilterPrefKey, nextGemeindeFilter);
  }
}

/// Provider für den Gemeinde-Filter-Zustand und dessen Notifier.
final gemeindeFilterProvider =
    NotifierProvider<GemeindeFilterNotifier, GemeindeFilterState>(
      GemeindeFilterNotifier.new,
    );
