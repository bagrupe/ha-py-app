part of 'my_account.dart';

/// Read-only, BundID data changes arrive with the next BundID login.
class _BundIdManagedFields extends StatelessWidget {
  const _BundIdManagedFields({
    required this.greetingMessage,
    required this.vorname,
    required this.nachname,
    required this.email,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.keySuffix,
  });

  final String? greetingMessage;
  final String vorname;
  final String nachname;
  final String email;
  final String street;
  final String postalCode;
  final String city;
  final String country;

  /// Without a new key the fields keep their first value after a reseed.
  final Object keySuffix;

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
        Text(
          'application.profil.my_account.bundid_managed_note'.tr(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
        ),
        AppTextField(
          key: ValueKey('vorname-$keySuffix'),
          enabled: false,
          initialValue: vorname,
          onChanged: (_) {},
          label: 'application.profil.my_account.first_name'.tr(),
        ),
        AppTextField(
          key: ValueKey('nachname-$keySuffix'),
          enabled: false,
          initialValue: nachname,
          onChanged: (_) {},
          label: 'application.profil.my_account.last_name'.tr(),
        ),
        AppTextField(
          key: ValueKey('email-$keySuffix'),
          enabled: false,
          initialValue: email,
          onChanged: (_) {},
          label: 'application.profil.my_account.email'.tr(),
        ),
        AppTextField(
          key: ValueKey('street-$keySuffix'),
          enabled: false,
          initialValue: street,
          onChanged: (_) {},
          label: 'application.profil.my_account.street'.tr(),
        ),
        AppTextField(
          key: ValueKey('postal_code-$keySuffix'),
          enabled: false,
          initialValue: postalCode,
          onChanged: (_) {},
          label: 'application.profil.my_account.postal_code'.tr(),
        ),
        AppTextField(
          key: ValueKey('city-$keySuffix'),
          enabled: false,
          initialValue: city,
          onChanged: (_) {},
          label: 'application.profil.my_account.city'.tr(),
        ),
        AppTextField(
          key: ValueKey('country-$keySuffix'),
          enabled: false,
          initialValue: country,
          onChanged: (_) {},
          label: 'application.profil.my_account.country'.tr(),
        ),
      ],
    );
  }
}
