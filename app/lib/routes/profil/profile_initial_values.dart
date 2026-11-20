part of 'profil_personal_data.dart';

/// Restores profile values without reading attachment contents into memory.
Map<String, dynamic> _profileInitialValues(
  SharedPreferences prefs,
  Map<String, dynamic> personalData,
) {
  /// Restores preference values to the types expected by the form.
  /// Supports retained attachments and date values.
  dynamic parseInitialValue(String key, String value) {
    if (key.startsWith('image_')) {
      return LocalAttachmentStore(prefs).read('field_$key');
    } else if (key.startsWith('date_')) {
      return DateTime.tryParse(value);
    } else {
      return value;
    }
  }

  final allEntries = prefs.getKeys().map(
    (key) => MapEntry<String, dynamic>(key, prefs.get(key)),
  );

  final filteredEntries = allEntries.where(
    (entry) => entry.key.startsWith('field'),
  );

  final savedValues = Map.fromEntries(filteredEntries);

  return {
    ...personalData,
    ...savedValues.map(
      (key, value) => MapEntry(
        key.startsWith('field_image_')
            ? key.replaceFirst('field_', '')
            : removePrefixes(key.replaceFirst('field_', '')),
        parseInitialValue(key.replaceFirst('field_', ''), value as String),
      ),
    ),
  };
}
