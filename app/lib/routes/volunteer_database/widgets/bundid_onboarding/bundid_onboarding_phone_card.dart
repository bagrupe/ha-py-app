import 'package:app/common/design_tokens.dart';
import 'package:app/components/forms/app_phone_number_field.dart';
import 'package:app/components/forms/app_sms_code_field.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_state.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Phone number/SMS verification card for the BundID onboarding flow. The phone number is always
/// SMS-verified here, even if BundID already supplied one, since only a verified number can be
/// used later to automatically merge with a future SMS-based login onto the same account.
class BundIdOnboardingPhoneCard extends ConsumerWidget {
  /// Creates the phone number/SMS verification card.
  const BundIdOnboardingPhoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(bundIdOnboardingProvider);
    final notifier = ref.read(bundIdOnboardingProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: DesignTokens.white,
        border: Border.all(color: DesignTokens.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: onboardingState.currentStep == BundIdOnboardingStep.phone
          ? _buildPhoneStep(context, theme, onboardingState, notifier)
          : _buildSmsStep(context, theme, onboardingState, notifier),
    );
  }

  Widget _buildPhoneStep(
    BuildContext context,
    ThemeData theme,
    BundIdOnboardingState onboardingState,
    BundIdOnboardingNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onboardingState.phoneNumberCollision) ...[
          Text(
            'application.volunteer_database.bundid_onboarding_page.phone_collision_notice'
                .tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 11),
        ],
        AppPhoneNumberField(
          // See BundIdOnboardingProfileCard: initialValue only applies on first build, so the
          // key must change once the async BundID suggestion lands.
          key: ValueKey('phoneNumber-${onboardingState.isInitialized}'),
          initialValue: onboardingState.phoneNumber,
          textInputAction: TextInputAction.done,
          onChanged: notifier.updatePhoneNumber,
          label:
              'application.volunteer_database.bundid_onboarding_page.phone_label'
                  .tr(),
          errorText: onboardingState.phoneErrorMessageKey?.tr(),
        ),
        const SizedBox(height: 11),
        Text(
          'application.volunteer_database.bundid_onboarding_page.sms_notice'
              .tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: DesignTokens.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildSmsStep(
    BuildContext context,
    ThemeData theme,
    BundIdOnboardingState onboardingState,
    BundIdOnboardingNotifier notifier,
  ) {
    final smsCodeErrorMessageKey = onboardingState.smsCodeErrorMessageKey;
    final resendSecondsRemaining = onboardingState.resendSecondsRemaining;
    final canResend = resendSecondsRemaining == 0 && !onboardingState.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'application.volunteer_database.bundid_onboarding_page.sms.confirm_code'
              .tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: DesignTokens.gray900,
          ),
        ),
        const SizedBox(height: 8),
        AppSmsCodeField(
          hasError: smsCodeErrorMessageKey != null,
          semanticLabel:
              'application.volunteer_database.bundid_onboarding_page.semantics.sms_code'
                  .tr(),
          onChanged: notifier.updateSmsCode,
        ),
        if (smsCodeErrorMessageKey != null) ...[
          const SizedBox(height: 5),
          Text(
            smsCodeErrorMessageKey.tr(
              namedArgs: onboardingState.smsCodeErrorArgs,
            ),
            style: theme.textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 14),
        Text(
          'application.volunteer_database.bundid_onboarding_page.sms.sent_notice'
              .tr(
                namedArgs: {
                  'phone': _maskedPhoneNumber(
                    onboardingState.smsCodePhoneNumber,
                  ),
                },
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
                ? 'application.volunteer_database.bundid_onboarding_page.sms.resend_available'
                      .tr()
                : 'application.volunteer_database.bundid_onboarding_page.sms.resend_waiting'
                      .tr(
                        namedArgs: {
                          'duration': _formatDuration(resendSecondsRemaining),
                        },
                      ),
          ),
        ),
        const SizedBox(height: 10),
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
            'application.volunteer_database.bundid_onboarding_page.sms.check_phone'
                .tr(),
          ),
        ),
      ],
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
