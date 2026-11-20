import 'package:app/common/app_config/app_config.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension AppConfigLegacy on AppConfig {
  /// Erzeugt eine Kopie der aktuellen Konfiguration mit optionalen neuen Werten.
  AppConfig legacyCopyWith({
    String? kommuneId,
    String? backendUrl,
    bool? prozessPromptOnSkip,
    bool? saveFieldValues,
  }) {
    return AppConfig(
      backendUrl: backendUrl ?? this.backendUrl,
      kommuneId: kommuneId ?? this.kommuneId,
      prozessPromptOnSkip: prozessPromptOnSkip ?? this.prozessPromptOnSkip,
      saveFieldValues: saveFieldValues ?? this.saveFieldValues,
    );
  }
}
