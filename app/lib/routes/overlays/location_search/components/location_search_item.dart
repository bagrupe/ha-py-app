import 'package:app/common/mapbox_search_suggestions/models.dart';
import 'package:app/routes/overlays/location_search/components/result_card.dart';
import 'package:flutter/material.dart';

/// Widget zur Darstellung eines einzelnen Suchergebnisses für einen Ort.
/// Zeigt den Namen und die vollständige Adresse der vorgeschlagenen Location an.
/// Reagiert auf Benutzereingaben durch Auslösen der übergebenen Callback-Funktion.
class LocationSearchItem extends StatelessWidget {
  /// Erstellt ein LocationSearchItem mit den erforderlichen Vorschlagsdaten und Auswahl-Callback.
  const LocationSearchItem({
    required this.suggestion,
    required this.onSelect,
    super.key,
  });

  /// Die Vorschlagsdaten des Ortes, die angezeigt werden sollen.
  final MapboxSuggestion suggestion;

  /// Callback, der ausgeführt wird, wenn der Eintrag ausgewählt wird.
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ResultCard(
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(suggestion.name, style: textTheme.bodySmall),
              Text(
                suggestion.fullAddress ?? suggestion.placeFormatted ?? '',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
