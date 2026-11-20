part of 'formular_schritt.dart';

/// Provides initial values for a form step.
extension _FormularInitialValues on FormularSchritt {
  /// Restores initial form values from saved data and current slots.
  Map<String, dynamic> _buildInitialValue(
    Map<String, dynamic> slots,
    WidgetRef ref,
  ) {
    final initialValues = <String, dynamic>{};
    final prefs = ref.read(sharedPreferencesProvider);
    final userStoredInhalte = UserStoredInhalte(prefs: prefs);
    for (final feld in schritt.felder) {
      final inhaltsTag = feld.inhaltsTag;
      final valueFromUserInput = slots[feld.slotName.toLowerCase()];
      switch (feld) {
        case FormularCheckboxFeldData _:
          final defaultChecked = feld.checkOptions
              .where((o) => o.defaultChecked)
              .map((o) => o.key)
              .join(',');
          initialValues[feld.slotName] =
              valueFromUserInput ??
              (defaultChecked.isEmpty ? null : defaultChecked);
        case FormularDateFieldData _ || FormularTimeFieldData _:
          final rawValue =
              valueFromUserInput ??
              (inhaltsTag != null
                  ? userStoredInhalte.getSimpleValue(inhaltsTag)
                  : null);
          initialValues[feld.slotName] = rawValue is String
              ? DateTime.tryParse(rawValue)
              : rawValue;
        case FormularSignatureFeldData() when inhaltsTag != null:
          initialValues[feld.slotName] =
              valueFromUserInput ??
              userStoredInhalte.getSignatureValue(inhaltsTag);
        case FormularImageFeldData() when inhaltsTag != null:
          initialValues[feld.slotName] =
              valueFromUserInput ??
              userStoredInhalte.getSavedDocuments(inhaltsTag);
        default:
          final valueFromPreferences = inhaltsTag != null
              ? userStoredInhalte.getSimpleValue(inhaltsTag)
              : null;
          final rawValue = valueFromUserInput ?? valueFromPreferences;

          if (rawValue is String && rawValue.isIsoDate) {
            final date = DateTime.tryParse(rawValue);
            if (date != null) {
              initialValues[feld.slotName] = DateFormat(
                'dd.MM.yyyy',
              ).format(date);
              continue;
            }
          }

          initialValues[feld.slotName] = rawValue;
      }
    }

    return initialValues;
  }
}
