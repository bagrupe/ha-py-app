import 'package:app/components/forms/app_dropdown_form_field.dart';
import 'package:app/components/forms/app_radio_option.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_form_state.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_municipalities_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Municipality and scheduling fields of a request.
class VolunteerRequestStepLocation extends ConsumerWidget {
  /// Creates the location workflow step.
  const VolunteerRequestStepLocation({
    required this.state,
    required this.notifier,
    super.key,
  });

  /// Current request form state.
  final VolunteerRequestFormState state;

  /// Request form notifier.
  final VolunteerRequestFormNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final municipalities = ref.watch(volunteerMunicipalitiesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'application.volunteer_database.create_request.hints.location'.tr(),
        ),
        const SizedBox(height: 12),
        municipalities.when(
          data: (items) {
            return AppDropdownFormField<String>(
              key: ValueKey(state.municipalityId),
              name: 'volunteer_request_municipality',
              label:
                  'application.volunteer_database.create_request.fields.municipality'
                      .tr(),
              initialValue: state.municipalityId,
              items: [
                for (final municipality in items)
                  DropdownMenuItem(
                    value: municipality.id,
                    child: Text(municipality.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) notifier.setMunicipality(value);
              },
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => TextButton(
            onPressed: () => ref.invalidate(volunteerMunicipalitiesProvider),
            child: Text('application.error.retry'.tr()),
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'application.volunteer_database.create_request.fields.address'
              .tr(),
          helperText:
              'application.volunteer_database.create_request.hints.address'
                  .tr(),
          initialValue: state.address,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.streetAddressLine1],
          onChanged: notifier.setAddress,
        ),
        const SizedBox(height: 18),
        Text(
          'application.volunteer_database.create_request.options.time_heading'
              .tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        RadioGroup<bool>(
          groupValue: state.hasAcceptedWhatsAppArrangement ? true : null,
          onChanged: (value) {
            notifier.setWhatsAppArrangementAccepted(value ?? false);
          },
          child: AppRadioOption<bool>(
            value: true,
            title:
                'application.volunteer_database.create_request.options.whatsapp_arrangement'
                    .tr(),
          ),
        ),
      ],
    );
  }
}
