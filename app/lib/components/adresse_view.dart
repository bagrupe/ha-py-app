import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget zur Darstellung einer Adresse mit optionalen Kontaktinformationen.
/// Zeigt Name, Straße, PLZ, Ort, Telefon, E-Mail und URL an und ermöglicht Interaktionen.
class AdresseView extends StatelessWidget {
  /// Erstellt eine Adresse-Ansicht mit den angegebenen Adress- und Kontaktdaten.
  const AdresseView({
    super.key,
    this.name,
    this.strasse,
    this.plz,
    this.ort,
    this.telefon,
    this.email,
    this.url,
  });

  /// Erzeugt eine AdresseView aus einem GraphQL-Fragment.
  factory AdresseView.fromFragment(Fragment_Adresse fragment) {
    return AdresseView(
      name: fragment.name,
      strasse: fragment.strasse,
      plz: fragment.plz,
      ort: fragment.ort,
      telefon: fragment.telefon,
      email: fragment.email,
      url: fragment.url,
    );
  }
  final String? name;
  final String? strasse;
  final String? plz;
  final String? ort;
  final String? telefon;
  final String? email;
  final String? url;

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 4);
    const interactiveStyle = TextStyle(color: DesignTokens.green500);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) Text(name!),
        if (strasse != null) ...[spacing, Text(strasse!)],
        if (plz != null || ort != null) ...[
          spacing,
          Text('${plz ?? ''} ${ort ?? ''}'),
        ],
        if (telefon != null) ...[
          spacing,
          InkWell(
            onTap: () => _launchTelephone(telefon!),
            child: Text(telefon!, style: interactiveStyle),
          ),
        ],
        if (email != null) ...[
          spacing,
          InkWell(
            onTap: () => _launchEmail(email!),
            child: Text(email!, style: interactiveStyle),
          ),
        ],
        if (url != null) ...[
          spacing,
          InkWell(
            onTap: () => _launchUrl(url!),
            child: Text(url!, style: interactiveStyle),
          ),
        ],
      ],
    );
  }

  /// Öffnet die Telefon-App mit der angegebenen Telefonnummer.
  static Future<bool> _launchTelephone(String tel) =>
      launchUrl(Uri(scheme: 'tel', path: tel));

  /// Öffnet den E-Mail-Client mit der angegebenen E-Mail-Adresse.
  static Future<bool> _launchEmail(String email) =>
      launchUrl(Uri(scheme: 'mailto', path: email));

  /// Öffnet die angegebene URL im externen Browser.
  static Future<bool> _launchUrl(String url) async {
    try {
      return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } on FormatException {
      debugPrint('FormatException on launchUrl. Url: $url');
      return false;
    }
  }
}
