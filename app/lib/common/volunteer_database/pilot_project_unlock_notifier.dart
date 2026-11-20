import 'package:app/common/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Persistent device access granted by a pilot project code.
final pilotProjectUnlockedProvider =
    NotifierProvider<PilotProjectUnlockNotifier, bool>(
      PilotProjectUnlockNotifier.new,
    );

/// Validates pilot codes and persists successful activation before publishing it.
class PilotProjectUnlockNotifier extends Notifier<bool> {
  /// Preference key retained independently of the signed-in account.
  static const preferenceKey = 'ehrenamtsbank_unlocked';

  /// Client-side MVP activation code provided by the project team.
  static const _activationCode = '4713 0892';

  /// Matches whitespace anywhere in a pilot code.
  static final _whitespace = RegExp(r'\s+');

  /// Removes whitespace and normalizes case for code comparison.
  static String _normalizeCode(String code) =>
      code.replaceAll(_whitespace, '').toLowerCase();

  @override
  bool build() =>
      ref.watch(sharedPreferencesProvider).getBool(preferenceKey) ?? false;

  /// Returns false for invalid codes and throws if activation cannot be saved.
  Future<bool> redeem(String code) async {
    if (_normalizeCode(code) != _normalizeCode(_activationCode)) {
      return false;
    }
    if (state) return true;
    final preferences = ref.read(sharedPreferencesProvider);
    final saved = await preferences.setBool(preferenceKey, true);
    if (!saved) throw Exception('Pilot activation could not be saved');
    state = true;
    return true;
  }
}
