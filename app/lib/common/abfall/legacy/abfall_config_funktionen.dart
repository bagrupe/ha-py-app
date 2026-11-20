import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_config.dart';
import 'package:app/common/abfall/abfall_filter.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension LegacyAbfallConfig on AbfallConfig {
  /// Gibt eine Kopie der Konfiguration mit optional neuen Werten zurück.
  AbfallConfig legacyCopyWith({
    AbfallFilter? filter,
    AbfallBenachrichtigungen? benachrichtigungen,
  }) {
    return AbfallConfig(
      filter: filter ?? this.filter,
      benachrichtigungen: benachrichtigungen ?? this.benachrichtigungen,
    );
  }
}
