// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/abfall/abfall_notifications.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/util/open_app_settings_modal.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/termine/components/abfall/abfalltermine_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget, das ein Filter-Sheet für Abfalltermine anzeigt und die Filtereinstellungen verwaltet.
class AbfallFilterSheet extends ConsumerWidget {
  /// Erstellt ein AbfallFilterSheet mit den erforderlichen Callbacks.
  AbfallFilterSheet({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  /// Callback, der bei Bestätigung des Filters mit dem neuen Filterwert aufgerufen wird.
  final Function(String nextFilter) onConfirm;

  /// Callback, der bei Abbruch des Filters aufgerufen wird.
  final VoidCallback onCancel;

  final formKey = GlobalKey<FormBuilderState>();

  /// Bestätigt die Filtereinstellungen und verwaltet die Berechtigungen für Benachrichtigungen.
  /// Aktualisiert die Konfiguration und schließt das Sheet bei Erfolg.
  Future<void> _confirm(
    AbfallFilter nextFilter,
    AbfallBenachrichtigungen nextBenachrichtigungen,
    WidgetRef ref,
  ) async {
    final benachrichtigungenEnabled = nextBenachrichtigungen.enabled;
    final notifications = ref.read(abfallNotificationsProvider);
    final abfallConfigNotifier = ref.read(abfallConfigProvider.notifier);
    if (benachrichtigungenEnabled) {
      final hasPermission = await notifications.requestPermission();
      if (!hasPermission && ref.context.mounted) {
        await showModalBottomSheet<String?>(
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
          useSafeArea: true,
          context: ref.context,
          builder: (context) => const OpenAppSettingsModal(
            title: 'Push-Benachrichtigungen',
            description:
                'Derzeit kann die App noch keine Push-Benachrichtigungen senden. Bitte geben Sie in den Einstellungen die notwendige Erlaubnis um Benachrichtigungen zu erhalten.',
          ),
        );
        // Return here to ensure the user confirms again after making manual changes
        return;
      }
    }

    await abfallConfigNotifier.setConfig(
      AbfallFilter(
        ort: nextFilter.ort,
        strasse: nextFilter.strasse,
        standort: nextFilter.standort,
        fraktionen: nextFilter.fraktionen,
        anfangsbuchstabe: nextFilter.anfangsbuchstabe,
      ),
      nextBenachrichtigungen.copyWith(enabled: benachrichtigungenEnabled),
    );

    if (ref.context.mounted) {
      Navigator.pop(ref.context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(abfallConfigProvider).filter;
    final benachrichtigungen = ref
        .watch(abfallConfigProvider)
        .benachrichtigungen;

    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Heading('Filter'),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: IconButton(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close, color: DesignTokens.black),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(width: 8),
                  FutureBuilder(
                    future: Permission.notification.status,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      return AbfallTermineFilter(
                        initialFilter: filter,
                        onConfirm: (filter, benachrichtigungen) async =>
                            _confirm(filter, benachrichtigungen, ref),
                        initialBenachrichtigungen: benachrichtigungen.copyWith(
                          enabled: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
