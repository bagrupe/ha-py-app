import 'package:app/components/image_picker/single_image_picker.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Formularfeld zur Auswahl eines einzelnen Bildes.
/// Nutzt den SingleImagePicker zur Bildauswahl.
class SingleImageField extends ConsumerWidget {
  /// Erstellt ein SingleImageField mit den angegebenen Felddaten.
  const SingleImageField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Formularfelds.
  final FormularImageFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleImagePicker(name: feld.slotName, required: !optional);
  }
}
