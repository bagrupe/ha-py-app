import 'package:url_launcher/url_launcher.dart';

/// Opens WhatsApp conversations for volunteer matches.
abstract final class VolunteerWhatsAppLauncher {
  /// Opens a WhatsApp chat with an optional introduction [message].
  static Future<bool> open({required String phoneNumber, String? message}) {
    final normalizedPhone = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    if (normalizedPhone.isEmpty) return Future.value(false);
    final uri = Uri.https(
      'wa.me',
      '/$normalizedPhone',
      message == null ? null : {'text': message},
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
