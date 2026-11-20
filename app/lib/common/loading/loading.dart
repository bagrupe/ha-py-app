// ignore_for_file: prefer_asserts_with_message, inference_failure_on_instance_creation, inference_failure_on_function_invocation

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Repräsentiert den Zustand des globalen Lade-Dialogs mit optionaler Nachricht.
class GlobalLoadingState {
  /// Erstellt einen neuen Zustand mit optionaler Anzeige-Nachricht.
  const GlobalLoadingState([this.message]);
  final String? message;
}

/// Steuert das Anzeigen und Verbergen des globalen Lade-Dialogs.
class GlobalLoadingController extends Notifier<GlobalLoadingState> {
  BuildContext? _dialogContext;
  DateTime? _openedAt;

  /// Zeigt den Lade-Dialog mit optionaler Nachricht an.
  /// [context] ist der BuildContext für das Anzeigen des Dialogs.
  /// [message] ist eine optionale Nachricht, die im Dialog angezeigt wird.
  Future<void> show(BuildContext context, [String? message]) async {
    if (_dialogContext != null && _dialogContext!.mounted) {
      throw Exception(
        'Dialog is already showing! If you want to change the displayed message, use setMessage instead',
      );
    }

    state = GlobalLoadingState(message);

    _openedAt = DateTime.now();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        _dialogContext = dialogContext;

        return const GlobalLoadingDialog();
      },
    );
  }

  /// Verbirgt den Lade-Dialog und stellt sicher, dass er mindestens [minimumShowDurationMs] Millisekunden angezeigt wurde.
  /// [minimumShowDurationMs] gibt die minimale Anzeigedauer in Millisekunden an (Standard: 500).
  Future<void> hide([int minimumShowDurationMs = 500]) async {
    assert(minimumShowDurationMs > 0);

    final now = DateTime.now();
    final dialogShown =
        now.millisecondsSinceEpoch - _openedAt!.millisecondsSinceEpoch;
    final requiredWaitTime = minimumShowDurationMs - dialogShown;
    if (requiredWaitTime > 0) {
      await Future.delayed(Duration(milliseconds: requiredWaitTime));
    }

    _dialogContext?.pop();
    _dialogContext = null;
    _openedAt = null;
  }

  /// Aktualisiert die im Lade-Dialog angezeigte Nachricht.
  /// [message] ist die neue Nachricht oder null zum Entfernen.
  void setMessage(String? message) {
    state = GlobalLoadingState(message);
  }

  @override
  GlobalLoadingState build() => const GlobalLoadingState();
}

/// Widget für den globalen Lade-Dialog mit optionaler Nachricht und Fortschrittsanzeige.
class GlobalLoadingDialog extends ConsumerWidget {
  const GlobalLoadingDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(globalLoadingControllerProvider).message;

    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Provider für den globalen Lade-Dialog-Controller.
final globalLoadingControllerProvider =
    NotifierProvider<GlobalLoadingController, GlobalLoadingState>(
      GlobalLoadingController.new,
    );
