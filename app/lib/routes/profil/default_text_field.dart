part of 'profil_personal_data.dart';

/// Describes a text input or a dropdown with stable stored option values.
class DefaultTextField extends DefaultField {
  /// Creates a text field with optional translated dropdown labels.
  const DefaultTextField(
    super.key,
    super.translationKey, {
    this.options = const {},
    super.showInFirstSetup,
  });

  /// Maps persisted values to their label translation keys.
  final Map<String, String> options;
}
