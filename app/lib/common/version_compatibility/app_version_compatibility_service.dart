import 'dart:convert';

import 'package:http/http.dart' as http;

/// Antwort von [fetchAppVersionCompatibility].
class AppVersionCompatibilityPayload {
  const AppVersionCompatibilityPayload({
    required this.backendVersion,
    required this.minimumCompatibleAppVersion,
  });

  final String backendVersion;
  final String minimumCompatibleAppVersion;
}

/// Lädt die Kompatibilitäts-Metadaten vom Backend (ohne Authentifizierung).
Future<AppVersionCompatibilityPayload?> fetchAppVersionCompatibility({
  required String backendBaseUrl,
  Duration timeout = const Duration(seconds: 10),
}) async {
  final base = backendBaseUrl.endsWith('/')
      ? backendBaseUrl.substring(0, backendBaseUrl.length - 1)
      : backendBaseUrl;
  final uri = Uri.parse('$base/api/app-version-compatibility');
  try {
    final response = await http.get(uri).timeout(timeout);
    if (response.statusCode != 200) {
      return null;
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final backendVersion = decoded['backendVersion'];
    final minimum = decoded['minimumCompatibleAppVersion'];
    if (backendVersion is! String || minimum is! String) {
      return null;
    }
    return AppVersionCompatibilityPayload(
      backendVersion: backendVersion,
      minimumCompatibleAppVersion: minimum,
    );
  } on Object {
    return null;
  }
}
