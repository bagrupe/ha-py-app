import 'dart:convert';

import 'package:app/common/mapbox_search_suggestions/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

/// Stellt Funktionen zur Verfügung, um Suchvorschläge von Mapbox abzurufen und Details zu einzelnen Features zu laden.
class MapboxSearchSuggestions {
  /// Initialisiert eine neue Instanz mit einem eindeutigen Sitzungstoken.
  MapboxSearchSuggestions()
    : _sessionToken = const Uuid().v4(),
      _mapboxToken = const String.fromEnvironment('MAPBOX_TOKEN'),
      _mapboxBoundingBox = const String.fromEnvironment('MAPBOX_BBOX');
  String _sessionToken;
  final String _mapboxToken;
  final String _mapboxBoundingBox;

  /// Erzeugt die vollständige URI für eine Mapbox-API-Anfrage basierend auf dem Pfad und optionalen Abfrageparametern.
  Uri _getRequestUri(String path, [Map<String, String> query = const {}]) {
    const base = 'https://api.mapbox.com/search/searchbox/v1/';

    return Uri.parse(base).resolve(path).replace(queryParameters: query);
  }

  /// Holt Suchvorschläge für den angegebenen Suchbegriff und geografischen Mittelpunkt.
  /// [search] ist der Suchtext, [center] die geografische Nähe für die Priorisierung der Ergebnisse.
  /// Liefert ein Future mit den Suchvorschlägen.
  Future<MapboxSuggestions> getSuggestions(String search, LatLng center) async {
    final query = {
      'q': search,
      'language': 'de',
      'country': 'de',
      'types': 'address,street,city,postcode', //poi
      'limit': '10',
      'proximity': '${center.longitude},${center.latitude}',
      'session_token': _sessionToken,
      'access_token': _mapboxToken,
      'bbox': _mapboxBoundingBox,
    };

    final requestUri = _getRequestUri('suggest', query);
    final response = await http.get(requestUri);
    final responseJson = jsonDecode(response.body);

    return MapboxSuggestions.fromJson(responseJson as Map<String, dynamic>);
  }

  /// Ruft detaillierte Informationen zu einem Feature anhand seiner ID ab.
  /// [id] ist die eindeutige Kennung des Features.
  /// Liefert ein Future mit dem Feature.
  Future<MapboxRetrievalFeature> retrieveFeature(String id) async {
    final query = {
      'session_token': _sessionToken,
      'access_token': _mapboxToken,
    };

    final requestUri = _getRequestUri('retrieve/$id', query);
    final response = await http.get(requestUri);
    final responseJson = jsonDecode(response.body);

    _resetSession();

    final retrievals = MapboxRetrievals.fromJson(
      responseJson as Map<String, dynamic>,
    );

    return retrievals.features.single;
  }

  /// Setzt das Sitzungstoken zurück, um eine neue Sitzung zu starten.
  void _resetSession() {
    _sessionToken = const Uuid().v4();
  }
}

/// Provider für die Instanz von MapboxSearchSuggestions.
final mapboxSearchSuggestions = Provider((ref) => MapboxSearchSuggestions());
