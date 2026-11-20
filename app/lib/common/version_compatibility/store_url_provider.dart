import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provides the store URL for the currently installed application.
class StoreUrlProvider {
  /// Creates a store URL provider.
  const StoreUrlProvider({http.Client? client}) : _client = client;

  final http.Client? _client;

  /// Resolves the application URL in the platform-specific store.
  Future<Uri?> getStoreUrl() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      return Uri.https('play.google.com', '/store/apps/details', {
        'id': packageInfo.packageName,
      });
    }

    if (Platform.isIOS) {
      return _getAppStoreUrl(packageInfo.packageName);
    }

    return null;
  }

  static Future<void> launchStore() async {
    final uri = await const StoreUrlProvider().getStoreUrl();
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<Uri?> _getAppStoreUrl(String bundleId) async {
    final client = _client ?? http.Client();
    final shouldCloseClient = _client == null;
    try {
      final lookupUri = Uri.https('itunes.apple.com', '/lookup', {
        'bundleId': bundleId,
        'entity': 'software',
        'country': 'de',
      });
      final response = await client
          .get(lookupUri)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      final responseBody = jsonDecode(response.body);
      if (responseBody is! Map<String, dynamic>) {
        return null;
      }

      final results = responseBody['results'];
      if (results is! List || results.isEmpty) {
        return null;
      }

      final firstResult = results.first;
      if (firstResult is! Map<String, dynamic>) {
        return null;
      }

      final trackViewUrl = firstResult['trackViewUrl'];
      if (trackViewUrl is! String) {
        return null;
      }

      return Uri.tryParse(trackViewUrl);
    } catch (_) {
      return null;
    } finally {
      if (shouldCloseClient) {
        client.close();
      }
    }
  }
}
