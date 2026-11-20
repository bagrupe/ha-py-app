import 'package:app/common/design_tokens.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/components/pdf_display.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/document_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/multi_image_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/passfoto_image_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/single_image_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/unterschrift_image_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/uebersicht_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:mime/mime.dart';

typedef FormularImageFeldData = Fragment_FormularFeld__UploadFormularFeld;

/// Erweiterung für FormularImageFeldData zur Identifikation spezieller Feldtypen.
extension FormularImageFeldDataExtension on FormularImageFeldData {
  /// Prüft, ob das Feld ein Passfoto ist.
  bool get isPassfoto => slotName == 'foto';

  /// Prüft, ob das Feld eine Unterschrift ist.
  bool get isUnterschrift => slotName == 'unterschrift';
}

/// Widget zur Darstellung eines Upload-Formularfelds mit passender Bildauswahl-Komponente.
class FormularUploadField extends StatelessWidget {
  /// Erstellt ein FormularUploadField mit den angegebenen Felddaten.
  const FormularUploadField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Upload-Formularfelds.
  final FormularImageFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context) {
    if (feld.isPassfoto) {
      return PassfotoImageField(feld: feld, optional: optional);
    }
    if (feld.isUnterschrift) {
      return UnterschriftImageField(name: feld.slotName, optional: optional);
    }

    if (feld.document) {
      return DocumentField(feld: feld, required: !optional);
    }

    return feld.multi
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (feld.angezeigterName != null) ...{
                SubHeading(feld.angezeigterName!, paddingLeft: 0),
                const SizedBox(height: 12),
              },
              if (feld.anweisung != null) ...{
                Text(feld.anweisung!),
                const SizedBox(height: 12),
              },
              MultiImageField(feld: feld, optional: optional),
            ],
          )
        : SingleImageField(feld: feld, optional: optional);
  }
}

/// Widget zur Übersicht und Anzeige der hochgeladenen Bilder oder Dokumente.
class UploadFieldUebersicht extends StatelessWidget {
  /// Erstellt eine Übersichtskomponente für das Upload-Feld mit den angegebenen Daten.
  const UploadFieldUebersicht({
    required this.slot,
    required this.feld,
    super.key,
    this.error,
  });

  /// Die Daten des Upload-Formularfelds.
  final FormularImageFeldData feld;

  /// Der Inhalt des Slots, der die hochgeladenen Dateien repräsentiert.
  final dynamic slot;

  /// Der Fehler des Slots.
  final String? error;

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    final slot = this.slot;

    if (slot == null) return const Text('---');

    if (slot is List<dynamic>) {
      imageWidget = BaseFieldUebersicht(
        title: feld.angezeigterName ?? feld.slotName,
        error: error,
        child: GridView.extent(
          primary: false,
          shrinkWrap: true,
          maxCrossAxisExtent: 150,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: slot
              .map((f) {
                if (f is XFile) {
                  return lookupMimeType(f.path) == 'application/pdf'
                      ? const PDFDisplay()
                      : XFileImage(file: f, fit: BoxFit.cover);
                }
                return null;
              })
              .whereType<Widget>()
              .toList(),
        ),
      );
    }

    imageWidget ??= ColoredBox(
      color: DesignTokens.gray100,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(feld.document ? 'Kein Dokument' : 'Kein Bild'),
            const SizedBox(width: 4),
            const Icon(Icons.warning, color: DesignTokens.red500, size: 20),
          ],
        ),
      ),
    );

    return Column(
      children: [
        imageWidget,
        if (error != null)
          ColoredBox(
            color: DesignTokens.gray50,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning,
                      color: DesignTokens.red500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(error!, softWrap: true)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
