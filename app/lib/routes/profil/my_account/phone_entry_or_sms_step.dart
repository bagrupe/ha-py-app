part of 'my_account.dart';

class _PhoneEntryOrSmsStep extends StatelessWidget {
  const _PhoneEntryOrSmsStep({
    required this.requiresReverification,
    required this.reverificationNotice,
    required this.isSmsStep,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
    required this.phoneError,
    required this.isPhoneLoading,
    required this.onSendPhoneCode,
    required this.smsCode,
    required this.onSmsCodeChanged,
    required this.onConfirmPhoneCode,
    required this.onCancel,
    this.canCancel = false,
    this.canCancelPhoneStep = false,
  });

  final bool requiresReverification;
  final Widget reverificationNotice;
  final bool isSmsStep;
  final String phoneNumber;
  final ValueChanged<String> onPhoneNumberChanged;
  final String? phoneError;
  final bool isPhoneLoading;
  final VoidCallback onSendPhoneCode;
  final String smsCode;
  final ValueChanged<String> onSmsCodeChanged;
  final VoidCallback onConfirmPhoneCode;
  final VoidCallback onCancel;

  final bool canCancel;

  /// Only for the phone change flow, the logged-out flow starts on this step.
  final bool canCancelPhoneStep;

  @override
  Widget build(BuildContext context) {
    if (requiresReverification) {
      return reverificationNotice;
    }

    if (!isSmsStep) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          AppPhoneNumberField(
            initialValue: phoneNumber,
            onChanged: onPhoneNumberChanged,
            label:
                'application.volunteer_database.bundid_onboarding_page.phone_label'
                    .tr(),
            errorText: phoneError,
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isPhoneLoading ? null : onSendPhoneCode,
              child: isPhoneLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: DesignTokens.white,
                      ),
                    )
                  : Text(
                      'application.volunteer_database.bundid_onboarding_page.send_code'
                          .tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DesignTokens.white,
                      ),
                    ),
            ),
          ),
          if (canCancelPhoneStep)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: isPhoneLoading ? null : onCancel,
                child: Text(
                  'application.profil.my_account.cancel'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        AppSmsCodeField(
          hasError: phoneError != null,
          semanticLabel:
              'application.volunteer_database.bundid_onboarding_page.semantics.sms_code'
                  .tr(),
          onChanged: onSmsCodeChanged,
        ),
        Text(
          'application.volunteer_database.bundid_onboarding_page.sms.sent_notice'
              .tr(namedArgs: {'phone': _maskedPhoneNumber(phoneNumber)}),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
        ),
        if (phoneError != null)
          Text(
            phoneError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: isPhoneLoading ? null : onConfirmPhoneCode,
            child: isPhoneLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DesignTokens.white,
                    ),
                  )
                : Text(
                    'application.volunteer_database.bundid_onboarding_page.confirm'
                        .tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: DesignTokens.white),
                  ),
          ),
        ),
        if (canCancel)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: isPhoneLoading ? null : onCancel,
              child: Text(
                'application.profil.my_account.cancel'.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
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
}
