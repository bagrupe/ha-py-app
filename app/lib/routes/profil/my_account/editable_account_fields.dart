part of 'my_account.dart';

class _EditableAccountFields extends StatelessWidget {
  const _EditableAccountFields({
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
    required this.keySuffix,
    required this.isEditingProfile,
    required this.onStartEditing,
    required this.isSaving,
    required this.onSave,
    required this.saveError,
  });

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

  /// Forces a fresh [AppTextField] state (clearing user edits) whenever a new profile is seeded.
  final Object keySuffix;
  final bool isEditingProfile;
  final VoidCallback onStartEditing;
  final bool isSaving;
  final VoidCallback onSave;
  final String? saveError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        if (greetingMessage != null)
          Text(
            greetingMessage!,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        AppTextField(
          key: ValueKey('vorname-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: vorname,
          onChanged: onVornameChanged,
          label: 'application.profil.my_account.first_name'.tr(),
        ),
        AppTextField(
          key: ValueKey('nachname-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: nachname,
          onChanged: onNachnameChanged,
          label: 'application.profil.my_account.last_name'.tr(),
        ),
        AppTextField(
          key: ValueKey('email-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: email,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          label: 'application.profil.my_account.email'.tr(),
        ),
        AppTextField(
          key: ValueKey('street-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: street,
          onChanged: onStreetChanged,
          label: 'application.profil.my_account.street'.tr(),
        ),
        AppTextField(
          key: ValueKey('postalCode-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: postalCode,
          keyboardType: TextInputType.number,
          onChanged: onPostalCodeChanged,
          label: 'application.profil.my_account.postal_code'.tr(),
        ),
        AppTextField(
          key: ValueKey('city-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: city,
          onChanged: onCityChanged,
          label: 'application.profil.my_account.city'.tr(),
        ),
        AppTextField(
          key: ValueKey('country-$keySuffix'),
          enabled: isEditingProfile,
          initialValue: country,
          onChanged: onCountryChanged,
          label: 'application.profil.my_account.country'.tr(),
        ),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: isSaving
                ? null
                : (isEditingProfile ? onSave : onStartEditing),
            child: isSaving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DesignTokens.white,
                    ),
                  )
                : Text(
                    (isEditingProfile
                            ? 'application.profil.my_account.save'
                            : 'application.profil.my_account.edit')
                        .tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: DesignTokens.white),
                  ),
          ),
        ),
        if (saveError != null)
          Text(
            saveError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
