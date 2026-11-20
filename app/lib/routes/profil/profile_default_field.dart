part of 'profil_personal_data.dart';

/// Renders one configured profile field using localized labels.
class _ProfileDefaultField extends StatelessWidget {
  /// Creates the input for a profile field definition.
  const _ProfileDefaultField({required this.field});

  /// Definition containing stable names and translated presentation text.
  final DefaultField field;

  @override
  Widget build(BuildContext context) {
    final definition = field;
    final decoration = InputDecoration(
      hintText: field.anweisung,
      labelText: field.label,
    );
    return switch (definition) {
      DefaultTextField(:final options) when options.isNotEmpty =>
        AppDropdownFormField<String>(
          name: field.name,
          label: field.label,
          hintText: field.anweisung,
          items: [
            for (final option in options.entries)
              DropdownMenuItem(
                value: option.key,
                child: Text(option.value.tr()),
              ),
          ],
        ),
      DefaultTextField() => FormBuilderTextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: decoration,
        name: field.name,
      ),
      DefaultDateField() => FormBuilderDateTimePicker(
        inputType: InputType.date,
        decoration: decoration,
        name: field.name,
        format: DateFormat.yMd(context.locale.toString()),
      ),
      DefaultSelectField() => GemeindeSelectField(
        name: field.name,
        label: field.label,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
