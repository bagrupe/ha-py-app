import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/linkifiers/email_linkifier.dart';
import 'package:app/common/linkifiers/phone_linkifier.dart';
import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart' hide EmailLinkifier;
import 'package:url_launcher/url_launcher.dart';

typedef PoiAdditionalInformation = Query_Poi_poi_additionalInformation;

const urlLinkifier = UrlLinkifier();
const emailLinkifier = EmailLinkifier();
const phoneLinkifier = PhoneNumberLinkifier();

/// Widget zur Darstellung zusätzlicher Informationen eines POI.
/// Zeigt eine Überschrift und einen Text mit erkannten Links, E-Mails und Telefonnummern an.
class PoiAdditionalInformationDisplay extends StatelessWidget {
  /// Erstellt eine Anzeige für zusätzliche POI-Informationen mit den gegebenen Daten.
  const PoiAdditionalInformationDisplay({required this.information, super.key});

  /// Die anzuzeigenden zusätzlichen Informationen.
  final PoiAdditionalInformation information;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTextTheme = theme.colorTextTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(information.heading!, style: colorTextTheme.bodyMedium),
        const SizedBox(height: 16),
        Linkify(
          onOpen: (link) async {
            final url = Uri.parse(link.url);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          text: information.text!,
          linkifiers: const [urlLinkifier, emailLinkifier, phoneLinkifier],
          linkStyle: colorTextTheme.bodyMedium!.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
