import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/schritt.dart';
import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_overlay.dart';
import 'package:app/common/keys.dart';
import 'package:app/components/daten_unvollstaendig_sheet.dart';
import 'package:app/components/error_screen.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/antrag_layout.dart';
import 'package:app/routes/antraege/components/schritte/abstract_schritt.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Cache für Schritt-Instanzen, damit der FormKey nicht bei jedem Rebuild neu erstellt wird.
/// Cache-Key kombiniert Route + Prozessversion + Schritt-ID für Eindeutigkeit über Routes hinweg.
final _schrittCache = <String, AbstractSchritt>{};

/// Leert den Schritt-Cache für eine bestimmte Route.
void clearSchrittCacheForRoute(String routePath) {
  final keys = _schrittCache.keys
      .where((key) => key.startsWith('$routePath:'))
      .toList();
  for (final key in keys) {
    _schrittCache.remove(key)?.dispose();
  }
}

/// Seite zur Darstellung eines einzelnen Schritts im Antragsprozess.
/// Baut die UI für den aktuellen Schritt und verwaltet die Navigation zwischen Schritten.
class AntragSchrittPage extends ConsumerWidget {
  const AntragSchrittPage({super.key});

  /// Erzeugt das passende Schritt-Widget basierend auf den übergebenen Schritt-Daten.
  /// [schritt] sind die Daten des aktuellen Schritts.
  /// [routePath] ist der aktuelle Routenpfad (z.B. "/karte/maengel/schritt").
  /// [prozessVersionId] ist die ID der Prozessversion.
  /// Gibt null zurück, wenn der Schritt-Typ nicht unterstützt wird.
  AbstractSchritt? _getSchritt(
    SchrittData schritt,
    String routePath,
    String prozessVersionId,
  ) {
    final cacheKey = '$routePath:$prozessVersionId:${schritt.id}';

    final cached = _schrittCache[cacheKey];
    if (cached != null) return cached;

    AbstractSchritt? neuerSchritt;
    if (schritt is FormularSchrittData) {
      neuerSchritt = FormularSchritt(schritt);
    }

    if (neuerSchritt != null) {
      _schrittCache[cacheKey] = neuerSchritt;
    }

    return neuerSchritt;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(antragProgressProvider);
    final progressNotifier = ref.read(antragProgressProvider.notifier);

    final textTheme = Theme.of(context).textTheme;

    if (progress == null) return const SizedBox.shrink();

    final currentRoute = GoRouterState.of(context).uri.path;

    final schrittData = progress.schritt;
    final schritt = _getSchritt(
      schrittData,
      currentRoute,
      progress.prozessVersion.id,
    );

    // Zeige Fehlermeldung, wenn der Schritt-Typ nicht unterstützt wird
    if (schritt == null) {
      return AntragLayout(
        canPop: true,
        onPopScope: (didPop, _) {
          if (!didPop) {
            context.pop();
          }
        },
        children: [
          ErrorScreen(
            message: 'Unbekannter Schritt-Typ',
            onRetry: () => context.pop(),
          ),
        ],
      );
    }

    return AntragLayout(
      canPop: false,
      contentReadyListenable: schritt.contentReadyListenable,
      onPopScope: (didPop, _) async {
        if (didPop) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final shouldPop = !progressNotifier.vorigerSchritt();
          if (shouldPop && context.mounted) {
            context.pop();
          }
        });
      },
      children: [
        if (progress.schritt.informationstext != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DesignTokens.orange500),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    progress.schritt.informationstext!,
                    style: textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        },
        SubHeading(progress.schritt.defaultedTitel),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (schrittData.anweisung != null) ...{
                Text(schrittData.anweisung!),
                const SizedBox(height: 36),
              },
              schritt.build(context, ref),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
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
                    if (!schritt.isComplete() &&
                        (await promptSkip(context, ref)) != true) {
                      return;
                    }
                    final (slots, errors) = schritt.getSlots();
                    progressNotifier.completeStep(slots, errors);
                  },
                  child: const Text('Bestätigen und Weiter', key: K.nextStep),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  /// Zeigt ein Bestätigungsdialog an, wenn der Nutzer einen Schritt überspringen möchte.
  /// [context] ist der Build-Kontext, [ref] ermöglicht den Zugriff auf Provider.
  /// Gibt zurück, ob der Schritt übersprungen werden soll (true) oder nicht (false).
  Future<bool?> promptSkip(BuildContext context, WidgetRef ref) {
    final appConfig = ref.read(appConfigProvider);

    if (!appConfig.prozessPromptOnSkip) {
      return Future.value(true);
    }

    return showModalBottomSheet<bool>(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return DatenUnvollstaendigSheet(
          onSkip: () {
            Navigator.pop(context, true);
          },
          onAmend: () {
            Navigator.pop(context, false);
          },
        );
      },
    );
  }
}
