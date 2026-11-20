part of 'my_account_provider.dart';

class MyAccountProfile {
  const MyAccountProfile({
    required this.phoneVerified,
    required this.hasBundId,
    this.vorname,
    this.nachname,
    this.email,
    this.street,
    this.postalCode,
    this.city,
    this.country,
    this.phoneNumberMasked,
  });

  final String? vorname;
  final String? nachname;
  final String? email;
  final String? street;
  final String? postalCode;
  final String? city;
  final String? country;
  final bool phoneVerified;

  final String? phoneNumberMasked;

  final bool hasBundId;
}
