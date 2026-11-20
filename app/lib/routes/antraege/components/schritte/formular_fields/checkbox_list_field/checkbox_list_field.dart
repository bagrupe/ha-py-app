import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/uebersicht_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Typalias für die Daten eines Checkbox-Listenformularfelds.
typedef FormularCheckboxFeldData =
    Fragment_FormularFeld__CheckboxListFormularFeld;

/// Typalias für die Optionen einer Checkbox-Liste.
typedef CheckOptions =
    Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions;

/// Widget zur Darstellung eines Formularfelds mit einer Liste von Checkboxen.
class FormularCheckboxListField extends ConsumerWidget {
  /// Erstellt ein Formularfeld mit Checkbox-Liste.
  /// [feld] enthält die Felddefinition, [optional] gibt an, ob das Feld optional ist.
  const FormularCheckboxListField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Die Daten des Formularfelds.
  final FormularCheckboxFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? initialValue;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (feld.inhaltsTag != null) {
      final prefs = ref.watch(sharedPreferencesProvider);
      initialValue = prefs.getString('field_${feld.inhaltsTag}');
    }

    return FormBuilderField<String>(
      name: feld.slotName,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: optional
          ? null
          : FormBuilderValidators.required(
              errorText: 'Diese Angabe ist zwingend notwendig',
            ),
      builder: (field) {
        final checkedKeys = {
          ...field.value?.split(',').where((k) => k.isNotEmpty) ?? [],
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (feld.anweisung != null) Text(feld.anweisung!),
            Text(feld.angezeigterName ?? '', style: textTheme.titleMedium),
            ...feld.checkOptions.map(
              (o) => FormularCheckboxListTile(
                label: o.label,
                value: checkedKeys.contains(o.key),
                onChanged: (newValue) {
                  if (newValue ?? false) {
                    checkedKeys.add(o.key);
                  } else {
                    checkedKeys.remove(o.key);
                  }

                  field.didChange(checkedKeys.join(','));
                },
              ),
            ),
            if (field.hasError)
              Text(
                field.errorText ?? 'Fehler',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Übersichtsdarstellung eines Checkbox-Listenfelds im Formular.
class CheckboxListFieldUebersicht extends StatelessWidget {
  /// Erstellt eine Übersicht für ein Checkbox-Listenfeld.
  /// [feld] enthält die Felddefinition, [slot] den aktuellen Wert, [error] eine Fehlermeldung.
  const CheckboxListFieldUebersicht({
    required this.feld,
    required this.slot,
    required this.error,
    super.key,
  });

  /// Die Daten des Formularfelds.
  final FormularCheckboxFeldData feld;

  /// Der aktuelle Wert des Felds.
  final dynamic slot;

  /// Eine mögliche Fehlermeldung.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final checkedKeys = {
      ...slot.toString().split(',').where((k) => k.isNotEmpty),
    };

    return BaseFieldUebersicht(
      title: feld.angezeigterName ?? feld.slotName,
      error: error,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: feld.checkOptions
            .map(
              (o) => FormularCheckboxListTile(
                label: o.label,
                value: checkedKeys.contains(o.key),
                onChanged: null,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Einzelne Checkbox mit Label für die Checkbox-Liste.
class FormularCheckboxListTile extends StatelessWidget {
  /// Erstellt eine Checkbox mit Label.
  /// [label] ist die Beschriftung, [value] der aktuelle Wert, [onChanged] der Änderungs-Callback.
  const FormularCheckboxListTile({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Beschriftung der Checkbox.
  final String label;

  /// Aktueller Wert der Checkbox (true, false oder null).
  final bool? value;

  /// Callback bei Änderung des Werts.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      // Forces rendering of enabled state for proper contrast
      //   The tile is still not reacting to input if onChanged == null so we
      //   can use that to disable the visuals.
      enabled: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: onChanged,
      title: Text(label),
    );
  }
}
