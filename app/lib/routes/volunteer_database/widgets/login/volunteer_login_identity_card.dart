import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_form_checkbox.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Identity input card for the volunteer login flow — only reached when a verified phone number
/// turned out to belong to a genuinely new account (see `VolunteerLoginStep.identity`). Mirrors
/// `VolunteerRegistrationIdentityCard` field-for-field so the two entry points behave identically.
class VolunteerLoginIdentityCard extends ConsumerWidget {
  /// Creates the identity input card.
  const VolunteerLoginIdentityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loginState = ref.watch(volunteerLoginProvider);
    final notifier = ref.read(volunteerLoginProvider.notifier);
    final space = MediaQuery.textScalerOf(context).scale(10);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: DesignTokens.white,
        border: Border.all(color: DesignTokens.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'application.volunteer_database.register_page.identity.description'
                .tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.firstName,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.givenName],
            onChanged: notifier.updateFirstName,
            label:
                'application.volunteer_database.register_page.identity.first_name'
                    .tr(),
            errorText: loginState.firstNameErrorMessageKey?.tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.lastName,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.familyName],
            onChanged: notifier.updateLastName,
            label:
                'application.volunteer_database.register_page.identity.last_name'
                    .tr(),
            errorText: loginState.lastNameErrorMessageKey?.tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.email,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: notifier.updateEmail,
            label: 'application.volunteer_database.register_page.identity.email'
                .tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.street,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.streetAddressLine1],
            onChanged: notifier.updateStreet,
            label:
                'application.volunteer_database.register_page.identity.street'
                    .tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.postalCode,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.postalCode],
            onChanged: notifier.updatePostalCode,
            label:
                'application.volunteer_database.register_page.identity.postal_code'
                    .tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.city,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.addressCity],
            onChanged: notifier.updateCity,
            label: 'application.volunteer_database.register_page.identity.city'
                .tr(),
          ),
          SizedBox(height: space),
          AppTextField(
            initialValue: loginState.country,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.countryName],
            onChanged: notifier.updateCountry,
            label:
                'application.volunteer_database.register_page.identity.country'
                    .tr(),
          ),
          const SizedBox(height: 14),
          AppFormCheckbox(
            value: loginState.isAgeConfirmed,
            label:
                'application.volunteer_database.register_page.identity.age_confirmation'
                    .tr(),
            errorText: loginState.ageConfirmationErrorMessageKey?.tr(),
            onChanged: (value) {
              notifier.updateAgeConfirmation(value: value);
            },
          ),
        ],
      ),
    );
  }
}
