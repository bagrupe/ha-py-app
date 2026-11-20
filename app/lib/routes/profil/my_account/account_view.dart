part of 'my_account.dart';

class _AccountView extends ConsumerWidget {
  const _AccountView({
    required this.onProfileLoaded,
    required this.greetingMessage,
    required this.vorname,
    required this.onVornameChanged,
    required this.nachname,
    required this.onNachnameChanged,
    required this.email,
    required this.onEmailChanged,
    required this.street,
    required this.onStreetChanged,
    required this.postalCode,
    required this.onPostalCodeChanged,
    required this.city,
    required this.onCityChanged,
    required this.country,
    required this.onCountryChanged,
    required this.fieldsKeySuffix,
    required this.isEditingProfile,
    required this.onStartEditing,
    required this.isSaving,
    required this.onSave,
    required this.saveError,
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
    required this.onCancelChangingPhone,
    required this.onLogout,
    required this.isLoggingOutEverywhere,
    required this.onLogoutEverywhere,
  });

  final ValueChanged<MyAccountProfile> onProfileLoaded;
  final String? greetingMessage;
  final String vorname;
  final ValueChanged<String> onVornameChanged;
  final String nachname;
  final ValueChanged<String> onNachnameChanged;
  final String email;
  final ValueChanged<String> onEmailChanged;
  final String street;
  final ValueChanged<String> onStreetChanged;
  final String postalCode;
  final ValueChanged<String> onPostalCodeChanged;
  final String city;
  final ValueChanged<String> onCityChanged;
  final String country;
  final ValueChanged<String> onCountryChanged;
  final Object fieldsKeySuffix;
  final bool isEditingProfile;
  final VoidCallback onStartEditing;
  final bool isSaving;
  final VoidCallback onSave;
  final String? saveError;
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
  final VoidCallback onCancelChangingPhone;
  final VoidCallback onLogout;
  final bool isLoggingOutEverywhere;
  final VoidCallback onLogoutEverywhere;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myAccountProfileProvider);

    return profileAsync.when(
      skipLoadingOnRefresh: false,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          Center(child: Text('application.profil.my_account.errors.load'.tr())),
      data: (profile) {
        if (profile != null) onProfileLoaded(profile);
        final isBundIdManaged = profile?.hasBundId ?? false;
        final buttonHeight = MediaQuery.textScalerOf(
          context,
        ).scale(48).clamp(48.0, 500.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(17, 24, 17, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              if (isBundIdManaged)
                _BundIdManagedFields(
                  greetingMessage: greetingMessage,
                  vorname: vorname,
                  nachname: nachname,
                  email: email,
                  street: street,
                  postalCode: postalCode,
                  city: city,
                  country: country,
                  keySuffix: fieldsKeySuffix,
                )
              else
                _EditableAccountFields(
                  greetingMessage: greetingMessage,
                  vorname: vorname,
                  onVornameChanged: onVornameChanged,
                  nachname: nachname,
                  onNachnameChanged: onNachnameChanged,
                  email: email,
                  onEmailChanged: onEmailChanged,
                  street: street,
                  onStreetChanged: onStreetChanged,
                  postalCode: postalCode,
                  onPostalCodeChanged: onPostalCodeChanged,
                  city: city,
                  onCityChanged: onCityChanged,
                  country: country,
                  onCountryChanged: onCountryChanged,
                  keySuffix: fieldsKeySuffix,
                  isEditingProfile: isEditingProfile,
                  onStartEditing: onStartEditing,
                  isSaving: isSaving,
                  onSave: onSave,
                  saveError: saveError,
                ),
              const Divider(),
              _PhoneSection(
                profile: profile,
                requiresReverification: requiresReverification,
                isPhoneLoading: isPhoneLoading,
                onReverify: onReverify,
                isChangingPhone: isChangingPhone,
                onStartChangingPhone: onStartChangingPhone,
                phoneNumber: phoneNumber,
                onPhoneNumberChanged: onPhoneNumberChanged,
                phoneError: phoneError,
                isSmsStep: isSmsStep,
                smsCode: smsCode,
                onSmsCodeChanged: onSmsCodeChanged,
                onSendPhoneCode: onSendPhoneCode,
                onConfirmPhoneCode: onConfirmPhoneCode,
                onCancel: onCancelChangingPhone,
              ),
              const Divider(),
              const PilotProjectSection(),
              const Divider(),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton(
                  onPressed: isLoggingOutEverywhere ? null : onLogout,
                  child: Text(
                    'application.profil.my_account.logout'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: TextButton(
                  onPressed: isLoggingOutEverywhere ? null : onLogoutEverywhere,
                  child: isLoggingOutEverywhere
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'application.profil.my_account.logout_everywhere'
                              .tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
