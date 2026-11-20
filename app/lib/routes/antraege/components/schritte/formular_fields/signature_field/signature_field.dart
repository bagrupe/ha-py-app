// ignore_for_file: inference_failure_on_function_invocation

import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:signature/signature.dart';

/// Typalias für die Daten eines Signaturformularfelds aus dem GraphQL-Fragment.
typedef FormularSignatureFeldData =
    Fragment_FormularFeld__SignatureFormularFeld;

/// Widget zur Darstellung und Eingabe eines Signaturfelds im Formular.
class FormularSignatureField extends StatefulWidget {
  /// Erstellt ein Formular-Signaturfeld mit den gegebenen Feld-Daten.
  const FormularSignatureField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Signaturfelds, die für die Darstellung benötigt werden.
  final FormularSignatureFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  State<FormularSignatureField> createState() => _FormularSignatureFieldState();
}

/// State-Klasse für das Formular-Signaturfeld, verwaltet die Signatur-Eingabe.
class _FormularSignatureFieldState extends State<FormularSignatureField> {
  final _signatureFieldKey = GlobalKey<FormBuilderSignaturePadState>();
  final _controller = SignatureController();
  bool _usesInitialValue = true;

  @override
  Widget build(BuildContext context) {
    final currentValue = _signatureFieldKey.currentState?.value;
    _controller.disabled = _usesInitialValue && currentValue != null;

    final validator = FormBuilderValidators.required(
      errorText: 'Diese Angabe ist zwingend notwendig',
    );

    return ColoredBox(
      color: DesignTokens.white,
      child: FormBuilderSignaturePad(
        validator: widget.optional ? null : validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _signatureFieldKey,
        initialValue: _usesInitialValue ? currentValue : null,
        name: widget.feld.slotName,
        clearButtonText: 'Zurücksetzen',
        onChanged: (newValue) {
          if (_usesInitialValue && newValue == null) {
            setState(() => _usesInitialValue = false);
          }
        },
        controller: _controller,
        border: const Border.fromBorderSide(
          BorderSide(color: DesignTokens.gray500),
        ),
      ),
    );
  }
}
