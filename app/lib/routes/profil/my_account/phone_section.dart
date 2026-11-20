part of 'my_account.dart';

class _PhoneSection extends StatelessWidget {
  const _PhoneSection({
    required this.profile,
    required this.requiresReverification,
    required this.isPhoneLoading,
    required this.onReverify,
    required this.isChangingPhone,
    required this.onStartChangingPhone,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
    required this.phoneError,
    required this.isSmsStep,
    required this.smsCode,
    required this.onSmsCodeChanged,
    required this.onSendPhoneCode,
    required this.onConfirmPhoneCode,
    required this.onCancel,
  });

  final MyAccountProfile? profile;
  final bool requiresReverification;
  final bool isPhoneLoading;
  final VoidCallback onReverify;
  final bool isChangingPhone;
  final VoidCallback onStartChangingPhone;
  final String phoneNumber;
  final ValueChanged<String> onPhoneNumberChanged;
  final String? phoneError;
  final bool isSmsStep;
  final String smsCode;
  final ValueChanged<String> onSmsCodeChanged;
  final VoidCallback onSendPhoneCode;
  final VoidCallback onConfirmPhoneCode;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (requiresReverification) {
      return _ReverificationNotice(
        isLoading: isPhoneLoading,
        onReverify: onReverify,
      );
    }

    if (!isChangingPhone) {
      final hasPhone = profile?.phoneNumberMasked != null;
      final isVerified = profile?.phoneVerified ?? false;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'application.profil.my_account.phone_number'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (!hasPhone)
                Text(
                  'application.profil.my_account.no_phone_number'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Text(
                      profile!.phoneNumberMasked!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DesignTokens.gray500,
                      ),
                    ),
                    Text(
                      '·',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DesignTokens.gray500,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Stack(
                        children: [
                          Icon(
                            isVerified ? Icons.verified : Icons.report,
                            size: 16,
                            color: isVerified
                                ? DesignTokens.green200
                                : DesignTokens.red200,
                          ),
                          Icon(
                            isVerified
                                ? Icons.verified_outlined
                                : Icons.report_outlined,
                            size: 16,
                            color: isVerified
                                ? DesignTokens.green500
                                : DesignTokens.red500,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      (isVerified
                              ? 'application.profil.my_account.phone_verified'
                              : 'application.profil.my_account.phone_unverified')
                          .tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isVerified
                            ? DesignTokens.green500
                            : DesignTokens.red500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          TextButton(
            onPressed: onStartChangingPhone,
            child: Text(
              (hasPhone && !isVerified
                      ? 'application.profil.my_account.verify_phone_now'
                      : 'application.profil.my_account.change_phone')
                  .tr(),
            ),
          ),
        ],
      );
    }

    return _PhoneEntryOrSmsStep(
      requiresReverification: requiresReverification,
      reverificationNotice: _ReverificationNotice(
        isLoading: isPhoneLoading,
        onReverify: onReverify,
      ),
      isSmsStep: isSmsStep,
      phoneNumber: phoneNumber,
      onPhoneNumberChanged: onPhoneNumberChanged,
      phoneError: phoneError,
      isPhoneLoading: isPhoneLoading,
      onSendPhoneCode: onSendPhoneCode,
      smsCode: smsCode,
      onSmsCodeChanged: onSmsCodeChanged,
      onConfirmPhoneCode: onConfirmPhoneCode,
      onCancel: onCancel,
      canCancel: true,
      canCancelPhoneStep: true,
    );
  }
}
