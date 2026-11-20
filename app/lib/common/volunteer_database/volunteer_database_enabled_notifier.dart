import 'package:app/common/volunteer_database/pilot_project_unlock_notifier.dart';
import 'package:app/common/volunteer_database/volunteer_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the volunteer database feature flag, supporting local dev-tools overrides.
final volunteerDatabaseEnabledProvider =
    NotifierProvider<VolunteerDatabaseEnabledNotifier, bool>(
      VolunteerDatabaseEnabledNotifier.new,
    );

/// Notifier to manage the volunteer database feature flag with persistency.
class VolunteerDatabaseEnabledNotifier extends Notifier<bool> {
  /// Temporary feature override controlled by the developer console.
  bool? overrideSetting;

  @override
  bool build() {
    final unlocked = ref.watch(pilotProjectUnlockedProvider);
    return (overrideSetting ?? VolunteerDataBase.isEnabled) || unlocked;
  }

  /// Toggles the volunteer database feature flag override and persists it.
  Future<void> toggle() async {
    if (overrideSetting == null) {
      overrideSetting = !VolunteerDataBase.isEnabled;
    } else {
      overrideSetting = !overrideSetting!;
    }
    state = overrideSetting! || ref.read(pilotProjectUnlockedProvider);
  }

  /// Sets the volunteer database feature flag override and persists it.
  Future<void> setEnabled(bool value) async {
    overrideSetting = value;
    state = overrideSetting! || ref.read(pilotProjectUnlockedProvider);
  }

  /// Resets the override to default environment value.
  Future<void> reset() async {
    overrideSetting = null;
    state =
        VolunteerDataBase.isEnabled || ref.read(pilotProjectUnlockedProvider);
  }
}

/// Redirects to [fallback] when the volunteer database feature is disabled.
String? volunteerDatabaseRedirectIfDisabled(
  Ref ref, {
  String fallback = '/aktuelles',
}) {
  if (ref.read(volunteerDatabaseEnabledProvider)) {
    return null;
  }
  return fallback;
}
