import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:cross_file/cross_file.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:latlong2/latlong.dart';

/// Repräsentiert einen Mangel mit zugehörigen Informationen wie Standort, Titel und Bildern.
class Mangel {
  /// Erstellt eine neue Instanz von Mangel mit den angegebenen Werten.
  const Mangel({
    required this.id,
    required this.coordinates,
    required this.title,
    required this.kategorie,
    required this.beschreibung,
    this.adresse,
    this.bilder,
    this.bilderSlotId,
  });

  /// Erstellt eine Instanz von Mangel aus einem GraphQL-Fragment der Mangel-Ausführung.
  /// [ausfuehrung] enthält die Datenquelle für die Initialisierung.
  factory Mangel.fromMaengelAusfuehrung(
    Fragment_MangelAusfuehrung ausfuehrung,
  ) {
    final rawAdresse = ausfuehrung.adresse?.value;
    final adresseValue = rawAdresse is Map<String, dynamic> ? rawAdresse : null;
    return Mangel(
      id: ausfuehrung.id,
      adresse: adresseValue?['addressString'] as String?,
      coordinates: adresseValue == null ? null : LatLng.fromJson(adresseValue),
      title: (ausfuehrung.title?.value as String?) ?? 'Mangel',
      kategorie: (ausfuehrung.kategorie?.value as String?) ?? 'Mangel',
      beschreibung: (ausfuehrung.beschreibung?.value as String?) ?? '',
      bilderSlotId: ausfuehrung.bilder?.id,
      bilder: [],
    );
  }

  /// Eindeutige Kennung des Mangels.
  final String id;

  /// Optionale Adresse des Mangels als String.
  final String? adresse;

  /// Null when the address slot is not visible.
  final LatLng? coordinates;

  /// Titel oder Bezeichnung des Mangels.
  final String title;

  /// Kategorie, der der Mangel zugeordnet ist.
  final String kategorie;

  /// Beschreibung des Mangels.
  final String beschreibung;

  /// Optionale Liste von Bildern, die den Mangel dokumentieren.
  final List<XFile>? bilder;

  /// Optionale ID des Bilderslots für die Zuordnung von Bildern.
  final String? bilderSlotId;
}
