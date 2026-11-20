import 'package:flutter/material.dart';

/// Text field for a German mobile number with a fixed "+49" prefix. Strips a pasted or autofilled
/// country code and leading zeros so only the local part is reported.
class AppPhoneNumberField extends StatefulWidget {
  /// Creates the phone number field.
  const AppPhoneNumberField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.errorText,
    this.textInputAction,
    super.key,
  });

  /// The label displayed in the text field.
  final String label;

  /// The initial local-number value (without the "+49" prefix).
  final String? initialValue;

  /// The optional validation error text.
  final String? errorText;

  /// The input action shown on the keyboard.
  final TextInputAction? textInputAction;

  /// Called with the corrected local number (leading zero(s) stripped) whenever it changes.
  final ValueChanged<String> onChanged;

  @override
  State<AppPhoneNumberField> createState() => _AppPhoneNumberFieldState();
}

class _AppPhoneNumberFieldState extends State<AppPhoneNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final corrected = value
        .replaceFirst(RegExp(r'^\s*(\+|00)49\s*'), '')
        .replaceFirst(RegExp('^0+'), '');
    if (corrected != value) {
      _controller.value = TextEditingValue(
        text: corrected,
        selection: TextSelection.collapsed(offset: corrected.length),
      );
    }
    widget.onChanged(corrected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const borderRadius = 5.0;
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      autofillHints: const [AutofillHints.telephoneNumber],
      onChanged: _handleChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: '+49 ',
        errorMaxLines: 5,
        errorText: widget.errorText,
        errorStyle: theme.textTheme.titleLarge!.copyWith(color: scheme.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: scheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      ),
    );
  }
}
