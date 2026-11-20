part of 'profil_personal_data.dart';

/// Displays an additional saved attachment or date field.
class _ProfileAdditionalField extends StatelessWidget {
  /// Creates a field whose label originates from the saved form definition.
  const _ProfileAdditionalField({required this.field});

  /// Stored field with its backend-defined name.
  final PersonalData field;

  @override
  Widget build(BuildContext context) {
    if (field.key.startsWith('image_')) {
      final label = field.key.replaceFirst(
        RegExp('^image_(single|multi)_'),
        '',
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label),
          if (field.key.startsWith('image_multi'))
            MultiImagePicker(name: field.key)
          else
            SingleImagePicker(name: field.key),
        ],
      );
    }
    if (field.key.startsWith('date_')) {
      return FormBuilderDateTimePicker(
        name: field.key,
        format: DateFormat.yMd(context.locale.toString()),
        decoration: InputDecoration(
          labelText: field.key.replaceFirst('date_', ''),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
