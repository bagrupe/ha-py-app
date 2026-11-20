import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_phone_number_field.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Phone number input card for the volunteer login flow.
class VolunteerLoginPhoneCard extends ConsumerWidget {
  /// Creates the phone number input card.
  const VolunteerLoginPhoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loginState = ref.watch(volunteerLoginProvider);
    final notifier = ref.read(volunteerLoginProvider.notifier);

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
            initialValue: loginState.phoneNumber,
            textInputAction: TextInputAction.next,
            onChanged: notifier.updatePhoneNumber,
            label: 'application.volunteer_database.login_page.phone_label'.tr(),
            errorText: loginState.phoneErrorMessageKey?.tr(),
          ),
          const SizedBox(height: 11),
          Text(
            'application.volunteer_database.login_page.sms_notice'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
