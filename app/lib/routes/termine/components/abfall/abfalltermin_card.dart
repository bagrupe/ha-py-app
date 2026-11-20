import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Karte zur Darstellung eines Abfalltermins mit Titel, Teaser und Datum.
/// Zeigt eine farblich kodierte linke Seite mit Icon und rechts die Termininformationen an.
class AbfallTerminCard extends StatelessWidget {
  /// Erstellt eine AbfallTerminCard mit den angegebenen Informationen.
  const AbfallTerminCard({
    required this.title,
    required this.teaser,
    required this.date,
    super.key,
    this.onTap,
  });

  /// Titel des Abfalltermins
  final String title;

  /// Kurzer Beschreibungstext zum Termin
  final String teaser;

  /// Datum des Abfalltermins als String
  final String date;

  /// Optionaler Tap-Callback für Interaktionen mit der Karte
  final GestureTapCallback? onTap;

  static const double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final lowerCaseTitle = title.toLowerCase();
    final Color backgroundColor;
    if (lowerCaseTitle.contains('gelb')) {
      backgroundColor = DesignTokens.orange100;
    } else if (lowerCaseTitle.contains('papier')) {
      backgroundColor = DesignTokens.blue200;
    } else if (lowerCaseTitle.contains('rest')) {
      backgroundColor = DesignTokens.gray300;
    } else if (lowerCaseTitle.contains('grün') ||
        lowerCaseTitle.contains('bio')) {
      backgroundColor = DesignTokens.green100;
    } else {
      backgroundColor = DesignTokens.orange100;
    }

    return IntrinsicHeight(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
                child: SizedBox(
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: SvgPicture.asset('assets/images/recycling.svg'),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: textTheme.titleSmall),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(title, style: textTheme.headlineSmall),
                    ),
                    Text(teaser, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
