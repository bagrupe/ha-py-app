import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Displays a consistently styled dropdown field backed by FormBuilder.
class AppDropdownFormField<T> extends StatelessWidget {
  /// Creates an application dropdown form field.
  const AppDropdownFormField({
    required this.name,
    required this.label,
    required this.items,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.enabled = true,
    super.key,
  });

  /// Form field identifier.
  final String name;

  /// Label displayed by the input decoration.
  final String label;

  /// Optional guidance displayed when no value is selected.
  final String? hintText;

  /// Initially selected value.
  final T? initialValue;

  /// Available dropdown entries.
  final List<DropdownMenuItem<T>> items;

  /// Callback invoked when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Optional field validator.
  final FormFieldValidator<T>? validator;

  /// Whether the dropdown accepts user interaction.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<T>(
      name: name,
      initialValue: initialValue,
      items: items,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
