part of 'profil_personal_data.dart';

/// Describes a profile field with a stable storage key and localized labels.
class DefaultField {
  /// Creates a field without translating its persisted name.
  const DefaultField(
    this._key,
    this.translationKey, {
    this.showInFirstSetup = false,
  });

  /// Stable preference and backend field name.
  final String _key;

  /// Translation namespace containing the label and hint.
  final String translationKey;

  /// Whether the field belongs to the initial profile form.
  final bool showInFirstSetup;

  /// Preference key for this field.
  String get key => 'field_$_key';

  /// Form field identifier used for persistence.
  String get name => _key;

  /// Localized field label.
  String get label => '$translationKey.label'.tr();

  /// Localized instruction shown in the input.
  String get anweisung => '$translationKey.hint'.tr();
}
