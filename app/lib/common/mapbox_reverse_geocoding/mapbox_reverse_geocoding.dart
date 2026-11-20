import 'dart:convert';

import 'package:app/common/mapbox_reverse_geocoding/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

/// Converts geographic coordinates into an address or location name.
class MapboxLatLngToAddress {
  /// Creates a new instance with a unique session token.
  MapboxLatLngToAddress()
    : _sessionToken = const Uuid().v4(),
      _mapboxToken = const String.fromEnvironment('MAPBOX_TOKEN');
  final String _sessionToken;
  final String _mapboxToken;

  /// Builds the URI for the Mapbox Geocoding API request.
  /// [position] geographic coordinates.
  /// [query] optional query parameters.
  Uri _getRequestUri(LatLng position, [Map<String, String> query = const {}]) {
    const base = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';

    final positionAsPathString =
        '${position.longitude},${position.latitude}.json';

    return Uri.parse(
      base,
    ).resolve(positionAsPathString).replace(queryParameters: query);
  }

  /// Retrieves the address string from the given geographic coordinates.
  /// [position] geographic coordinates.
  /// Returns a Future with the geocoding results.
  Future<MapboxReverseGeocodingResults> getAddressString(
    LatLng position,
  ) async {
    final query = {
      'language': 'de',
      'country': 'de',
      'types': 'address,locality,poi',
      'session_token': _sessionToken,
      'access_token': _mapboxToken,
    };

    final requestUri = _getRequestUri(position, query);
    final response = await http.get(requestUri);
    final responseJson = jsonDecode(response.body);

    return MapboxReverseGeocodingResults.fromJson(
      responseJson as Map<String, dynamic>,
    );
  }

  /// Retrieves the location name (locality) from the given geographic coordinates.
  /// [position] geographic coordinates.
  /// Returns a Future with the geocoding results.
  Future<MapboxReverseGeocodingResults> getLocation(LatLng position) async {
    final query = {
      'language': 'de',
      'country': 'de',
      'types': 'place',
      'session_token': _sessionToken,
      'access_token': _mapboxToken,
    };

    final requestUri = _getRequestUri(position, query);
    final response = await http.get(requestUri);
    final responseJson = jsonDecode(response.body);

    return MapboxReverseGeocodingResults.fromJson(
      responseJson as Map<String, dynamic>,
    );
  }
}

/// Provider for the MapboxLatLngToAddress instance.
final mapboxLatLngToAddress = Provider((ref) => MapboxLatLngToAddress());

/// Provider for reverse geocoding a position into a full address.
final mapboxReverseGeocodingProvider = FutureProvider.family<String?, LatLng>((
  ref,
  position,
) async {
  final results = await ref
      .read(mapboxLatLngToAddress)
      .getAddressString(position);

  final feature = results.features.firstOrNull;

  final formattedAddress = feature?.placeNameDe?.split(', ');
  formattedAddress?.removeLast();

  return formattedAddress?.join(', ');
});

/// Provider for reverse geocoding a position into a locality name (for sensors).
final mapboxReverseGeocodingProviderSensors =
    FutureProvider.family<String?, LatLng>((ref, position) async {
      final results = await ref
          .read(mapboxLatLngToAddress)
          .getLocation(position);

      final result = results.features.firstOrNull?.placeNameDe;
      final cityName = result?.split(',').first;
      return cityName;
    });
