import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_overlay.dart';
import 'package:app/common/keys.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/antrag_layout.dart';
import 'package:app/routes/antraege/components/schritte/uebersicht/schritte_uebersicht.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seite zur Bestätigung der Antragsdaten mit Übersicht und Navigation zu Korrekturen oder Abschluss.
class AntragBestaetigenPage extends ConsumerWidget {
  const AntragBestaetigenPage({super.key});

  /// Baut die Benutzeroberfläche der Bestätigungsseite basierend auf dem aktuellen Antragsfortschritt.
  /// [context] ist der Build-Kontext, [ref] ermöglicht den Zugriff auf Provider.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(antragProgressProvider);
    final progressNotifier = ref.read(antragProgressProvider.notifier);

    if (progress == null) return const SizedBox.shrink();

    final hasErrors = progress.hasErrors;

    return AntragLayout(
      onPopScope: (_, __) async {
        // needs to be wrapped in Future to avoid "Tried to modify a provider while the widget tree was building."
        await Future(progressNotifier.bearbeiten);
      },
      canPop: false,
      children: [
        const SizedBox(height: 16),
        SubHeading('application.antraege.bestaetigen.summary'.tr()),
        const SizedBox(height: 24),
        SchritteUebersicht(
          schritte: progress.schritte,
          slots: progress.slots,
          slotErrors: progress.slotErrors,
          onTapSchritt: (i) => progressNotifier.korrigieren(index: i),
        ),
        const SizedBox(height: 16),
        if (hasErrors) ...[
          _DatenUnvollstaendigWarning(),
          const SizedBox(height: 16),
        ],
        _AutomatischAusfuellen(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton(
            key: K.confirmSummary,
            onPressed: () async {
              if (hasPendingImageCompressions()) {
                unawaited(
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const PopScope(
                      canPop: false,
                      child: ImageCompressionOverlay(),
                    ),
                  ),
                );
                try {
                  await awaitPendingImageCompressions();
                } finally {
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              }
              if (!context.mounted) return;
              if (hasErrors) {
                progressNotifier.korrigieren();
              } else {
                unawaited(progressNotifier.bestaetigen());
              }
            },
            child: Text(
              hasErrors
                  ? 'application.antraege.bestaetigen.correct_data_now'.tr()
                  : progress.hasBezahlenSchritt
                  ? 'application.antraege.bestaetigen.confirm_and_pay'.tr()
                  : 'application.antraege.bestaetigen.confirm_data'.tr(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Widget zur Anzeige einer Warnung, wenn der Antrag unvollständig ist.
class _DatenUnvollstaendigWarning extends StatelessWidget {
  /// Baut die Warnmeldung mit Icon und Text.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning, color: DesignTokens.red500, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'application.antraege.bestaetigen.incomplete_warning'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget zur Steuerung der Option, Formularfelder automatisch bei zukünftigen Anträgen auszufüllen.
class _AutomatischAusfuellen extends ConsumerWidget {
  /// Baut die Checkbox zur Aktivierung der automatischen Ausfüllfunktion.
  /// Nutzt den aktuellen Antragsfortschritt und die App-Konfiguration.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(antragProgressProvider);

    final formularSchritte = progress?.schritte
        .whereType<Fragment_Schritt__FormularSchritt>()
        .toList();

    final formularFelderMitInhaltsTag = formularSchritte
        ?.map(
          (schritt) => schritt.felder.where((feld) => feld.inhaltsTag != null),
        )
        .flattened
        .toList();

    if (formularFelderMitInhaltsTag == null ||
        formularFelderMitInhaltsTag.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: ref.watch(appConfigProvider).saveFieldValues,
              onChanged: (bool? value) {
                ref
                    .read(appConfigProvider.notifier)
                    .setSaveFieldValues(value ?? false);
              },
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'application.antraege.bestaetigen.auto_fill_future'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
