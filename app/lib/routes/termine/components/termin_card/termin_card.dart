import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget zur Darstellung einer Karte mit Informationen zu einem Veranstaltungstermin.
/// Zeigt Bild, Datum, Titel und Untertitel an und reagiert optional auf Tap-Ereignisse.
class TerminCard extends StatelessWidget {
  /// Erstellt eine TerminCard mit dem gegebenen Termin und optionalem Tap-Handler.
  const TerminCard({required this.termin, super.key, this.onTap});

  /// Der anzuzeigende Veranstaltungstermin
  final VeranstaltungsTermin termin;

  /// Optionaler Callback bei Tap auf die Karte
  final GestureTapCallback? onTap;

  static const double borderRadius = 10;
  static const double borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final imageUrl = termin.thumbnailImageUrl ?? termin.imageUrl;

    return IntrinsicHeight(
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  // needs padding because border lies inside the decorated box, which is ignored by the children
                  child: Padding(
                    padding: const EdgeInsets.all(borderWidth),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(borderRadius - 1.0),
                        bottomLeft: Radius.circular(borderRadius - 1.0),
                      ),
                      child: SizedBox(
                        height: 100,
                        child: LoadingImage(
                          imageUrl: termin.imageUrl != null ? imageUrl : null,
                          fit: BoxFit.cover,
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
                        TerminDisplay(termin: termin),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            termin.titel,
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        Text(termin.subtitel, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget zur Anzeige der Datums- und Uhrzeitinformationen eines Veranstaltungstermins.
/// Zeigt bei mehrtägigen Terminen eine zusammengefasste Darstellung, sonst einzelne Zeiten.
class TerminDisplay extends StatelessWidget {
  /// Erstellt eine TerminDisplay-Komponente für den gegebenen Termin.
  const TerminDisplay({required this.termin, super.key});

  /// Der anzuzeigende Veranstaltungstermin
  final VeranstaltungsTermin termin;

  @override
  Widget build(BuildContext context) {
    if (termin.isMultipleDays) {
      return Text(termin.formattedDateTimeString);
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                termin.formattedDateString,
                style: textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: 8),
            Text(termin.formattedTimeString, style: textTheme.titleSmall),
          ],
        ),
        ...termin.termineOnSameDay.mapIndexed(
          (i, t) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  i == 0 ? 'Weitere Uhrzeiten' : '',
                  style: textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat(VeranstaltungsTermin.timeFormat).format(t.toLocal()),
                style: textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
