import 'package:app/components/image_picker/multi_image_picker.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Formularfeld zur Auswahl mehrerer Bilder.
/// Nutzt den MultiImagePicker zur Mehrfachauswahl von Bildern.
class MultiImageField extends ConsumerWidget {
  /// Erstellt ein MultiImageField mit den angegebenen Felddaten.
  const MultiImageField({required this.feld, super.key, this.optional = false});

  /// Die Daten des Formularfelds.
  final FormularImageFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiImagePicker(name: feld.slotName, required: !optional);
  }
}
