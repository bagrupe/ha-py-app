// ignore_for_file: unawaited_futures, type_annotate_public_apis, avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'package:app/common/abfall/abfall_benachrichtigungen.dart';
import 'package:app/common/abfall/abfall_notifications.dart';
import 'package:app/common/abfall/abfall_provider.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/theme.dart';
import 'package:app/common/util/open_app_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Verwaltung und Anzeige der Müllabfuhr-Benachrichtigungen im Profilbereich.
class AbfallBenachrichtigungen extends ConsumerStatefulWidget {
  const AbfallBenachrichtigungen({super.key});

  @override
  ConsumerState<AbfallBenachrichtigungen> createState() =>
      _AbfallBenachrichtigungen();
}

/// State-Klasse für das [AbfallBenachrichtigungen]-Widget, die die Logik und Darstellung steuert.
class _AbfallBenachrichtigungen
    extends ConsumerState<AbfallBenachrichtigungen> {
  /// Aktiviert oder deaktiviert die Benachrichtigung über den übergebenen [notifier].
  /// [nextValue] gibt an, ob die Benachrichtigung aktiviert (true) oder deaktiviert (false) werden soll.
  void toggleBenachrichtigung(nextValue, notifier) {
    notifier.setEnabled(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    final abfallConfig = ref.watch(abfallConfigProvider);
    final abfallConfigNotifier = ref.watch(abfallConfigProvider.notifier);
    final notificationsProvider = ref.watch(abfallNotificationsProvider);
    final benachrichtigungen = abfallConfig.benachrichtigungen;
    final zeitpunkt = benachrichtigungen.zeitpunkt.format(context);

    final theme = ref.watch(themeProvider);
    final colorTextTheme = theme.colorTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: DesignTokens.gray100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Benachrichtigung erhalten',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Switch(
                value: benachrichtigungen.enabled,
                onChanged: (value) async {
                  if (!value) {
                    abfallConfigNotifier.setEnabled(false);
                    return;
                  }

                  final hasPermission = await notificationsProvider
                      .requestPermission();
                  if (!hasPermission && context.mounted) {
                    await showModalBottomSheet<String?>(
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: false,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => const OpenAppSettingsModal(
                        title: 'Push-Benachrichtigungen',
                        description:
                            'Derzeit kann die App noch keine Push-Benachrichtigungen senden. Bitte geben Sie in den Einstellungen die notwendige Erlaubnis um Benachrichtigungen zu erhalten.',
                      ),
                    );
                  }
                  await abfallConfigNotifier.setEnabled(
                    await notificationsProvider.hasPermission(),
                  );
                },
                activeThumbColor: theme.primaryColor,
              ),
            ],
          ),
          RadioGroup<AbfallBenachrichtigungenPresets>(
            groupValue: benachrichtigungen.preset,
            onChanged: (value) {
              if (value == null) return;
              abfallConfigNotifier.setPreset(value);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...AbfallBenachrichtigungenPresets.values.map((value) {
                  final title = switch (value) {
                    AbfallBenachrichtigungenPresets.previousDay =>
                      '$zeitpunkt Uhr am Tag vor der Abholung',
                  };
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: DesignTokens.gray900,
                        ),
                        const SizedBox(width: 8),
                        Text(title),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OutlinedButton(
              onPressed: () async {
                final nextZeitpunkt = await showTimePicker(
                  context: context,
                  initialTime: benachrichtigungen.zeitpunkt,
                );
                await abfallConfigNotifier.setZeitpunkt(nextZeitpunkt);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: DesignTokens.white,
              ),
              child: Text(
                'Zeitpunkt individualisieren',
                style: colorTextTheme.labelLarge,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
