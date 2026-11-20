import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_phone_number_field.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Phone number input card for the volunteer registration flow.
class VolunteerRegistrationPhoneCard extends ConsumerWidget {
  /// Creates the phone number input card.
  const VolunteerRegistrationPhoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registrationState = ref.watch(volunteerRegistrationProvider);
    final notifier = ref.read(volunteerRegistrationProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: DesignTokens.white,
        border: Border.all(color: DesignTokens.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPhoneNumberField(
            initialValue: registrationState.phoneNumber,
            textInputAction: TextInputAction.next,
            onChanged: notifier.updatePhoneNumber,
            label: 'application.volunteer_database.register_page.phone_label'
                .tr(),
            errorText: registrationState.phoneErrorMessageKey?.tr(),
          ),
          const SizedBox(height: 11),
          Text(
            'application.volunteer_database.register_page.sms_notice'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
