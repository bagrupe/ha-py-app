part of 'antrag_progress.dart';

/// Handles persistence for the application controller.
mixin _AntragProgressPersistence on _AntragProgressController {
  /// Persistently saves field values in SharedPreferences.
  Future<void> saveFieldValues(Map<String?, dynamic> fields) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final felder =
        state?.schritte.whereType<FormularSchrittData>().expand(
          (s) => s.felder,
        ) ??
        [];
    final feldDefinitionen = {for (final feld in felder) feld.slotName: feld};

    for (final fieldToSave in fields.entries) {
      final feldDefinition = feldDefinitionen[fieldToSave.key];
      var key = 'field_';

      dynamic value = fieldToSave.value;

      if (value == null || (value is List && value.isEmpty)) {
        await prefs.remove('field_image_single_${fieldToSave.key}');
        await prefs.remove('field_image_multi_${fieldToSave.key}');
        await prefs.remove('field_signature_${fieldToSave.key}');
        if (prefs.get(key + fieldToSave.key!) != null) {
          await prefs.remove(key + fieldToSave.key!);
        }

        continue;
      }

      if (value is List && value.every((subValue) => subValue is XFile)) {
        final xFiles = value.cast<XFile>();
        key += 'image_';

        final singleKey = '${key}single_${fieldToSave.key}';
        final multiKey = '${key}multi_${fieldToSave.key}';
        key = xFiles.length == 1 ? singleKey : multiKey;
        await LocalAttachmentStore(prefs).save(
          key,
          await compressImages(xFiles, ImageCompressionProfile.dokument),
        );
        await prefs.remove(xFiles.length == 1 ? multiKey : singleKey);
        continue;
      } else if (feldDefinition is FormularCheckboxFeldData) {
        key += 'checkbox_${fieldToSave.key}';
      } else if (value is Uint8List) {
        key += 'signature_${fieldToSave.key}';
        await LocalAttachmentStore(prefs).save(key, [
          XFile.fromData(value, mimeType: 'image/png', name: 'signature.png'),
        ]);
        continue;
      } else if (value is DateTime) {
        key += 'date_${fieldToSave.key}';
        value = value.toIso8601String();
      } else {
        key += fieldToSave.key!;
      }

      await prefs.setString(key, value.toString());
    }

    ref.invalidate(missingAttachmentsProvider);
    return;
  }

  /// Extracts all form field values mapped by their slot names.
  Map<String, dynamic> extractFormValues() {
    final stateLocal = state;
    if (stateLocal == null) return {};

    final formFieldsList = stateLocal.schritte
        .whereType<Fragment_Schritt__FormularSchritt>()
        .expand((step) => step.felder)
        .toList();

    final inhaltsTagToSlotValues = {
      for (final field in formFieldsList)
        (field.inhaltsTag ?? field.slotName): stateLocal.slots[field.slotName],
    }..removeWhere((key, value) => value == null);
    return inhaltsTagToSlotValues;
  }
}
