// ignore_for_file: unreachable_switch_case

import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/termine/common/model/termin_art_filter_type.dart';
import 'package:app/routes/termine/common/termine_provider.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_filter_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider, der die Anzahl der aktiven Filter als String zurückgibt.
/// Ermittelt die Filteranzahl basierend auf den aktuellen Einstellungen für Abfall, Veranstaltung und Gemeinde.
final filterCountProvider = Provider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final abfallFilter = ref.watch(abfallConfigProvider).filter;
  final terminArtFilter = ref.watch(terminArtFilterProvider);
  final kategorien = prefs.getStringList(selectedCategoriesPrefsKey) ?? [];
  final gemeinden = ref.watch(gemeindeFilterProvider).currentGemeindePrefs;
  final tempGemeinden = ref.watch(tempGemeindeProvider);
  final fraktionen = abfallFilter.fraktionen
      ?.split(',')
      .where((s) => s.isNotEmpty)
      .toList();

  final filterCount = switch (terminArtFilter) {
    TerminArtFilterType.abfall => fraktionen?.length ?? 0,
    TerminArtFilterType.veranstaltung =>
      kategorien.length +
          (tempGemeinden.isNotEmpty ? tempGemeinden.length : gemeinden.length),
    TerminArtFilterType.alle => 0,
    // TODO: Handle this case.
    Object() => throw UnimplementedError(),
  };

  final filterText = filterCount > 0 ? 'Filter ($filterCount)' : 'Filter';

  return filterText;
});
