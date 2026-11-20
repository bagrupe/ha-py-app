import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_sms_code_field.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SMS verification card for the volunteer registration flow.
class VolunteerRegistrationSmsCard extends ConsumerWidget {
  /// Creates the SMS verification card.
  const VolunteerRegistrationSmsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registrationState = ref.watch(volunteerRegistrationProvider);
    final notifier = ref.read(volunteerRegistrationProvider.notifier);
    final maskedPhone = _maskedPhoneNumber(registrationState.phoneNumber);
    final smsCodeErrorMessageKey = registrationState.smsCodeErrorMessageKey;
    final resendSecondsRemaining = registrationState.resendSecondsRemaining;
    final canResend =
        resendSecondsRemaining == 0 && !registrationState.isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      decoration: BoxDecoration(
        color: DesignTokens.white,
        border: Border.all(color: DesignTokens.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'application.volunteer_database.register_page.sms.confirm_code'
                .tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray900,
            ),
          ),
          const SizedBox(height: 8),
          AppSmsCodeField(
            hasError: smsCodeErrorMessageKey != null,
            semanticLabel:
                'application.volunteer_database.register_page.semantics.sms_code'
                    .tr(),
            onChanged: notifier.updateSmsCode,
          ),
          if (smsCodeErrorMessageKey != null) ...[
            const SizedBox(height: 5),
            Text(
              smsCodeErrorMessageKey.tr(
                namedArgs: registrationState.smsCodeErrorArgs,
              ),
              style: theme.textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            'application.volunteer_database.register_page.sms.sent_notice'.tr(
              namedArgs: {'phone': maskedPhone},
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
          const SizedBox(height: 22),
          TextButton(
            onPressed: canResend ? notifier.resendCode : null,
            style: TextButton.styleFrom(
              foregroundColor: canResend
                  ? Theme.of(context).colorScheme.primary
                  : DesignTokens.gray500,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
              textStyle: theme.textTheme.bodySmall?.copyWith(
                decoration: canResend ? TextDecoration.underline : null,
              ),
            ),
            child: Text(
              canResend
                  ? 'application.volunteer_database.register_page.sms.resend_available'
                        .tr()
                  : 'application.volunteer_database.register_page.sms.resend_waiting'
                        .tr(
                          namedArgs: {
                            'duration': _formatDuration(resendSecondsRemaining),
                          },
                        ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'application.volunteer_database.register_page.sms.no_code'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: DesignTokens.gray500,
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: notifier.reviewPhoneNumber,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 26),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
              textStyle: theme.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            child: Text(
              'application.volunteer_database.register_page.sms.check_phone'
                  .tr(),
            ),
          ),
        ],
      ),
    );
  }

  String _maskedPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    if (digits.length < 4) {
      return phoneNumber.isEmpty ? '0151...' : '$phoneNumber...';
    }

    return '${digits.substring(0, 4)}...';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}s';
  }
}
