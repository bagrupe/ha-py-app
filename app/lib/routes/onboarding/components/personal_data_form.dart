import 'package:app/common/auth/personal_data.dart';
import 'package:app/components/gemeinde_select_field/gemeinde_select_field.dart';
import 'package:app/routes/profil/profil_personal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Collects personal data during onboarding.
/// Builds inputs from shared profile field definitions.
class PersonalDataForm extends ConsumerStatefulWidget {
  /// Creates a personal-data form with an optional form key.
  const PersonalDataForm(this.formKey, {super.key});

  /// Key used to control and validate the form.
  final GlobalKey<FormBuilderState>? formKey;

  @override
  ConsumerState<PersonalDataForm> createState() => _PersonalDataFormState();
}

/// Builds the onboarding personal-data form.
class _PersonalDataFormState extends ConsumerState<PersonalDataForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (index, field) in onboardingDefaultFields.indexed) ...[
                if (index > 0) const SizedBox(height: 16),
                if (field is DefaultTextField)
                  FormBuilderTextField(
                    name: field.name,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: field.anweisung,
                      label: Text(field.label),
                    ),
                  )
                else if (field is DefaultSelectField)
                  GemeindeSelectField(name: field.name, label: field.label),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Default personal-data fields shown during onboarding.
const List<DefaultField> onboardingDefaultFields = [
  DefaultTextField(
    PersonalDataKeys.vorname,
    'application.profil.personal_data.fields.first_name',
  ),
  DefaultTextField(
    PersonalDataKeys.nachname,
    'application.profil.personal_data.fields.last_name',
  ),
  DefaultSelectField(
    PersonalDataKeys.gemeinde,
    'application.profil.personal_data.fields.municipality',
  ),
];
