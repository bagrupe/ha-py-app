import 'package:app/common/app_config/app_config.dart';
import 'package:app/graphql/__generated__/geoflaeche.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Bietet Funktionen zur Geodatenabfrage und -verarbeitung.
class GeoService {
  /// Erstellt eine Instanz von GeoService mit dem gegebenen Riverpod-Ref.
  GeoService(this.ref);
  final Ref ref;

  final Map<String, bool> _cache = {};
  final Map<String, Future<bool>> _pendingRequests = {};

  /// Prüft, ob ein gegebener Punkt innerhalb einer benannten Geofläche liegt.
  /// [name] ist der Name der Geofläche, [position] die geografische Position.
  Future<bool> isPointInGeoflaeche(String name, LatLng position) async {
    final appConfig = ref.watch(appConfigProvider);
    final kommuneId = appConfig.kommuneId;
    final cacheKey =
        '$kommuneId|$name|${position.latitude}|${position.longitude}';

    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final pendingRequest = _pendingRequests[cacheKey];
    if (pendingRequest != null) return pendingRequest;

    final request = _loadIsInside(kommuneId, name, position, cacheKey);
    _pendingRequests[cacheKey] = request;
    try {
      return await request;
    } finally {
      if (identical(_pendingRequests[cacheKey], request)) {
        _pendingRequests.remove(cacheKey)?.ignore();
      }
    }
  }

  Future<bool> _loadIsInside(
    String kommuneId,
    String name,
    LatLng position,
    String cacheKey,
  ) async {
    final graphqlClient = ref.watch(graphqlClientProvider);
    final result = await graphqlClient.query_IsInside(
      Options_Query_IsInside(
        variables: Variables_Query_IsInside(
          kommuneId: kommuneId,
          name: name,
          position: Input_Position(
            lat: position.latitude,
            long: position.longitude,
          ),
        ),
      ),
    );
    final geoResult = result.parsedData?.kommune.isPointInGeoflaeche;
    if (geoResult == null || geoResult.message != null) return false;

    final isInside = geoResult.isInside ?? false;
    _cache[cacheKey] = isInside;
    return isInside;
  }
}

/// Provider für die Bereitstellung von GeoService.
final Provider<GeoService> geoServiceProvider = Provider(GeoService.new);
