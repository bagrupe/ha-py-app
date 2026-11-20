// ignore_for_file: cascade_invocations

import 'package:app/common/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_sizer.freezed.dart';

const textSizerPrefsKey = 'text_sizer_modifier';

/// Repräsentiert den Zustand des Textgrößenfaktors mit einer maximalen Begrenzung.
@freezed
abstract class TextSizeState with _$TextSizeState {
  /// Erstellt eine Instanz mit dem gegebenen Textgrößenfaktor.
  const factory TextSizeState(double textSizeModifier) = _TextSizeState;

  const TextSizeState._();

  static const maxModifier = 1.5;
}

/// Verwaltet den Zustand des Textgrößenfaktors und speichert Änderungen persistent.
class TextSizeNotifier extends Notifier<TextSizeState> {
  @override
  TextSizeState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final modifier = prefs.getDouble(textSizerPrefsKey) ?? 1.0;

    return TextSizeState(modifier);
  }

  /// Erhöht den Textgrößenfaktor um 0,25 und setzt ihn zurück, wenn das Maximum überschritten wird.
  void bumpTextSize() {
    final bumpedModifier = state.textSizeModifier + .25;
    final normalizedModifier = bumpedModifier > TextSizeState.maxModifier
        ? 0.75
        : bumpedModifier;

    state = state.copyWith(textSizeModifier: normalizedModifier);

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setDouble(textSizerPrefsKey, normalizedModifier);
  }
}

/// Provider für den Textgrößen-Notifier zur Zustandsverwaltung.
final textSizerProvider = NotifierProvider<TextSizeNotifier, TextSizeState>(
  TextSizeNotifier.new,
);
