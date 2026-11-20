import 'package:app/common/design_tokens.dart';
import 'package:app/common/theme.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef FormularFeldData = Fragment_FormularFeld;

/// Basiskomponente zur Darstellung eines Formularfeld-Übersichtsbereichs mit Titel, optionaler Fehlermeldung und beliebigem Inhalt.
class BaseFieldUebersicht extends ConsumerWidget {
  /// Erstellt eine Übersichtskomponente mit Titel, Fehleranzeige und Inhalt.
  const BaseFieldUebersicht({
    required this.title,
    required this.error,
    required this.child,
    super.key,
  });

  /// Titel des Übersichtsbereichs.
  final String title;

  /// Optionale Fehlermeldung, die angezeigt wird.
  final String? error;

  /// Inhalt des Übersichtsbereichs.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = ref.watch(themeProvider).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (error != null)
                const Icon(Icons.warning, color: DesignTokens.red500, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          child,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                style: textTheme.labelSmall!.copyWith(
                  color: DesignTokens.red500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Einfache Übersichtskomponente zur Anzeige eines Titels, eines Werts und optionaler Fehlermeldung.
class SimpleFieldUebersicht extends StatelessWidget {
  /// Erstellt eine einfache Übersicht mit Titel, Wert und Fehleranzeige.
  const SimpleFieldUebersicht({
    required this.title,
    required this.error,
    required this.value,
    super.key,
  });

  /// Titel der Übersicht.
  final String title;

  /// Optionale Fehlermeldung.
  final String? error;

  /// Anzuzeigender Wert als Text.
  final String value;

  @override
  Widget build(BuildContext context) {
    return BaseFieldUebersicht(title: title, error: error, child: Text(value));
  }
}
