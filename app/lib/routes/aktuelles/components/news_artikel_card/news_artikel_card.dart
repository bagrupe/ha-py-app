import 'package:app/common/design_tokens.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/aktuelles/components/news_artikel_card/news_location_tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('dd.MM.yyyy');

/// Ein Widget, das eine Karte mit Nachrichtenartikel-Daten anzeigt.
/// Zeigt optional ein Bild, Titel, Datum und Quelle an und reagiert auf Tap-Ereignisse.
class NewsArtikelCard extends StatelessWidget {
  /// Erstellt eine neue Instanz von NewsArtikelCard mit den angegebenen Parametern.
  const NewsArtikelCard({
    required this.quelle,
    super.key,
    this.title,
    this.imageUrl,
    this.datum,
    this.onTap,
  });

  /// Der Titel des Artikels, optional.
  final String? title;

  /// Die URL des Bildes, optional.
  final String? imageUrl;

  /// Das Datum des Artikels, optional.
  final DateTime? datum;

  /// Die Quelle des Artikels, erforderlich.
  final String quelle;

  /// Callback, der bei Tap auf die Karte ausgeführt wird, optional.
  final GestureTapCallback? onTap;

  static const double borderRadius = 10;
  static const double borderWidth = 1;
  static final DateFormat dateFormat = DateFormat('dd. MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textPart = Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsLocationTag(source: quelle),
            const SizedBox(height: 6),
            if (datum != null)
              Text(
                dateFormat.format(datum!),
                style: textTheme.bodySmall!.copyWith(
                  color: DesignTokens.gray500,
                ),
              ),
            const SizedBox(height: 6),
            Text(title ?? '', style: textTheme.bodySmall),
          ],
        ),
      ),
    );

    final card = DecoratedBox(
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
                child: ClipRect(
                  child: Transform.scale(
                    scale: 1.3,
                    child: LoadingImage(imageUrl: imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          textPart,
        ],
      ),
    );

    return IntrinsicHeight(
      child: Stack(
        children: [
          card,
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
