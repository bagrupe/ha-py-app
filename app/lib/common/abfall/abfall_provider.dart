import 'package:app/common/abfall/abfall_config.dart';
import 'package:app/common/abfall/abfall_config_notifier.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider für die Abfallkonfiguration, der den zugehörigen Notifier verwaltet.
final abfallConfigProvider =
    NotifierProvider<AbfallConfigNotifier, AbfallConfig>(
      AbfallConfigNotifier.new,
    );

/// Provider für das Repository zur Speicherung und Wiederherstellung der Abfallkonfiguration.
final abfallConfigRepositoryProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AbfallConfigRepository(sharedPreferences);
});
