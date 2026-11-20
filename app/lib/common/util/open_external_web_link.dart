import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';

/// Tries to open an HTTP or HTTPS link in an external application.
Future<bool> tryOpenExternalWebLink(String link) async {
  final uri = Uri.tryParse(link.trim());
  if (uri == null ||
      !(uri.isScheme('http') || uri.isScheme('https')) ||
      uri.host.isEmpty) {
    return false;
  }

  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException {
    return false;
  }
}
