part of 'my_account.dart';

class _LoggedOutView extends ConsumerWidget {
  const _LoggedOutView({
    required this.isBundIdLoading,
    required this.onLoginWithBundId,
    required this.requiresReverification,
    required this.isPhoneLoading,
    required this.onReverify,
    required this.isSmsStep,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
    required this.phoneError,
    required this.smsCode,
    required this.onSmsCodeChanged,
    required this.onSendPhoneCode,
    required this.onConfirmPhoneCode,
    required this.onCancel,
  });

  final bool isBundIdLoading;
  final VoidCallback onLoginWithBundId;
  final bool requiresReverification;
  final bool isPhoneLoading;
  final VoidCallback onReverify;
  final bool isSmsStep;
  final String phoneNumber;
  final ValueChanged<String> onPhoneNumberChanged;
  final String? phoneError;
  final String smsCode;
  final ValueChanged<String> onSmsCodeChanged;
  final VoidCallback onSendPhoneCode;
  final VoidCallback onConfirmPhoneCode;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionExpired = ref.watch(strongSessionExpiredProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(17, 24, 17, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          const PilotProjectSection(),
          const Divider(),
          if (sessionExpired)
            Text(
              'application.profil.my_account.session_expired'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          Text(
            'application.profil.my_account.logged_out_intro'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isBundIdLoading ? null : onLoginWithBundId,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: DesignTokens.white,
              ),
              child: isBundIdLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: DesignTokens.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -4),
                          child: Image.asset(
                            'assets/images/logos/bundid_logo_white.png',
                            height: 22,
                            excludeFromSemantics: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'application.profil.my_account.login'.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: DesignTokens.white),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'application.volunteer_database.login_page.bundid_divider'
                      .tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          _PhoneEntryOrSmsStep(
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
          ),
        ],
      ),
    );
  }
}
