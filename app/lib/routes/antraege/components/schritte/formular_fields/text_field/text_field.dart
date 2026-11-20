// ignore_for_file: strict_raw_type, inference_failure_on_function_invocation

import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/validators/string_validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Typalias für die Daten eines String-Formularfelds aus dem GraphQL-Fragment.
typedef FormularTextFeldData = Fragment_FormularFeld__StringFormularFeld;

/// Typalias für die Optionen eines String-Formularfelds.
typedef TextFeldOption =
    Fragment_FormularFeld__StringFormularFeld_stringOptions;

/// Widget zur Darstellung eines Textformularfelds mit optionalen Validierungen und Auswahlmöglichkeiten.
class FormularTextField extends ConsumerWidget {
  /// Erstellt ein Textformularfeld mit den angegebenen Felddaten und Optionalität.
  FormularTextField({
    required this.feld,
    super.key,
    this.optional = false,
    this.highlightDropdown = false,
    this.showsNextDropdown = false,
    this.onDropdownCleared,
    List<TextFeldOption>? sichtbareOptionen,
  }) : sichtbareOptionen = sichtbareOptionen ?? feld.stringOptions,
       assert(
         !(feld.multiline && feld.stringOptions.isNotEmpty),
         'options cannot be used with multiline',
       );

  /// Die Daten des Textformularfelds.
  final FormularTextFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  final bool highlightDropdown;

  final bool showsNextDropdown;

  final VoidCallback? onDropdownCleared;

  /// Options actually shown to the user; may be pre-filtered by the caller.
  final List<TextFeldOption> sichtbareOptionen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validators = FormBuilderValidators.compose([
      if (!optional)
        FormBuilderValidators.required(
          errorText: 'Diese Angabe ist zwingend notwendig',
        ),
      if (feld.validationType == Enum_StringValidationType.IBAN)
        CustomStringValidators.iban(),
    ]);

    final inputFormatters = [
      if (feld.validationType == Enum_StringValidationType.IBAN)
        CustomStringValidators.ibanFormatter,
    ];

    final decoration = InputDecoration(
      labelText: feld.angezeigterName,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      isDense: true,
      border: const OutlineInputBorder(borderRadius: formularFieldBorderRadius),
      labelStyle: const TextStyle(color: Colors.black),
      hintText: feld.anweisung,
    );

    if (feld.stringOptions.isNotEmpty) {
      return FormularDropdownField(
        feld: feld,
        sichtbareOptionen: sichtbareOptionen,
        inputDecoration: decoration,
        validators: validators,
        highlighted: highlightDropdown,
        showsNextDropdown: showsNextDropdown,
        onCleared: onDropdownCleared,
      );
    }

    return FormBuilderTextField(
      name: feld.slotName,
      minLines: feld.multiline ? 3 : null,
      maxLines: feld.multiline ? null : 1,
      decoration: decoration,
      validator: validators,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: inputFormatters,
    );
  }
}

class FormularDropdownField extends StatefulWidget {
  FormularDropdownField({
    required this.feld,
    required this.inputDecoration,
    required this.validators,
    this.highlighted = false,
    this.showsNextDropdown = false,
    this.onCleared,
    List<TextFeldOption>? sichtbareOptionen,
    super.key,
  }) : sichtbareOptionen = sichtbareOptionen ?? feld.stringOptions;
  final FormularTextFeldData feld;
  final InputDecoration inputDecoration;
  final FormFieldValidator<String>? validators;
  final List<TextFeldOption> sichtbareOptionen;
  final bool highlighted;
  final bool showsNextDropdown;
  final VoidCallback? onCleared;

  @override
  State<FormularDropdownField> createState() => _FormularDropdownFieldState();
}

class _FormularDropdownFieldState extends State<FormularDropdownField> {
  String? selectedValue;

  FormBuilderFieldState? get _fieldState =>
      FormBuilder.of(context)?.fields[widget.feld.slotName];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && (_fieldState?.mounted ?? false)) {
        final fieldValue = _fieldState?.value as String?;
        final isVisible =
            fieldValue == null ||
            widget.sichtbareOptionen.any((o) => o.key == fieldValue);
        setState(() {
          selectedValue = isVisible ? fieldValue : null;
        });
        if (!isVisible) _fieldState?.didChange(null);
      }
    });
  }

  @override
  void didUpdateWidget(FormularDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final fieldValue = _fieldState?.value as String?;
    final value = selectedValue ?? fieldValue;
    if (value != null && !widget.sichtbareOptionen.any((o) => o.key == value)) {
      selectedValue = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            _fieldState?.value != value ||
            widget.sichtbareOptionen.any((option) => option.key == value)) {
          return;
        }
        _fieldState?.didChange(null);
      });
      return;
    }

    if (fieldValue != null && fieldValue != selectedValue) {
      selectedValue = fieldValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.sichtbareOptionen;
    final form = FormBuilder.of(context);
    final formInitialValue =
        form?.initialValue[widget.feld.slotName] as String?;
    if (formInitialValue != null &&
        !options.any((option) => option.key == formInitialValue)) {
      form?.initialValue[widget.feld.slotName] = null;
    }
    final visibleSelectedValue = options.any((o) => o.key == selectedValue)
        ? selectedValue
        : null;
    final anweisung = widget.feld.anweisung;
    final theme = Theme.of(context);

    final decoration = widget.inputDecoration.copyWith(
      hintText: '',
      filled: widget.highlighted,
      fillColor: widget.highlighted ? highlightedFieldBackground(theme) : null,
      labelStyle: widget.highlighted
          ? theme.textTheme.bodyLarge?.copyWith(
              color: DesignTokens.gray900,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            )
          : null,
      floatingLabelStyle: widget.highlighted
          ? theme.textTheme.bodyLarge?.copyWith(
              color: DesignTokens.gray900,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            )
          : null,
      enabledBorder: widget.highlighted
          ? OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
              borderRadius: formularFieldBorderRadius,
            )
          : null,
      focusedBorder: widget.highlighted
          ? OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
              borderRadius: formularFieldBorderRadius,
            )
          : null,
    );
    final showsNextLevelHint =
        widget.highlighted &&
        widget.showsNextDropdown &&
        visibleSelectedValue == null;

    final dropdownArrow = Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 28,
      color: widget.highlighted ? theme.primaryColor : DesignTokens.gray500,
    );

    Widget clearButton() => IconButton(
      key: Key('${widget.feld.slotName}_clear'),
      tooltip: 'application.antraege.formular_schritt.clear_category'.tr(),
      padding: EdgeInsets.zero,
      alignment: Alignment.centerRight,
      onPressed: () {
        setState(() {
          selectedValue = null;
        });
        _fieldState?.didChange(null);
        widget.onCleared?.call();
      },
      icon: const Icon(Icons.clear, size: 25, color: DesignTokens.gray500),
    );

    final dropdown = FormBuilderDropdown(
      icon: widget.highlighted
          ? visibleSelectedValue != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [clearButton(), dropdownArrow],
                  )
                : dropdownArrow
          : visibleSelectedValue != null
          ? clearButton()
          : dropdownArrow,
      initialValue: visibleSelectedValue,
      style: widget.highlighted
          ? theme.textTheme.bodyLarge?.copyWith(color: DesignTokens.gray900)
          : null,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      name: widget.feld.slotName,
      decoration: decoration,
      validator: widget.validators,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(
        (anweisung != null && anweisung.isNotEmpty)
            ? anweisung
            : 'Bitte wählen Sie eine Option',
        overflow: TextOverflow.ellipsis,
      ),
      items: options
          .map(
            (o) => DropdownMenuItem(
              value: o.key,
              child: Text(
                o.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );

    if (!showsNextLevelHint) return dropdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        dropdown,
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
          child: Text(
            'application.antraege.formular_schritt.select_to_continue'.tr(),
            maxLines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
