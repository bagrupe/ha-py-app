import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:flutter/material.dart';

/// Typalias für die Daten eines Anzeige-Textblockfelds aus dem GraphQL-Fragment.
typedef TextBlockFeldData = Fragment_FormularFeld__AnzeigeTextBlockFeld;

/// Widget zur Darstellung eines Textblocks mit Titel und Inhalt.
class TextBlockField extends StatelessWidget {
  /// Erstellt ein Textblock-Widget mit den angegebenen Felddaten.
  const TextBlockField({required this.feld, super.key});

  /// Die Daten des Textblocks, die angezeigt werden sollen.
  final TextBlockFeldData feld;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(feld.angezeigterName ?? '', style: textTheme.titleMedium),
        Text(feld.text),
      ],
    );
  }
}
