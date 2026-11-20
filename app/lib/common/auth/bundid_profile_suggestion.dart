part of 'bundid_auth.dart';

/// Unverified, [telephoneNumber] must be confirmed by SMS before it is used.
class BundIdProfileSuggestion {
  const BundIdProfileSuggestion({
    this.vorname,
    this.nachname,
    this.email,
    this.street,
    this.postalCode,
    this.city,
    this.country,
    this.telephoneNumber,
  });

  factory BundIdProfileSuggestion.fromJson(Map<String, dynamic> json) =>
      BundIdProfileSuggestion(
        vorname: json['vorname'] as String?,
        nachname: json['nachname'] as String?,
        email: json['email'] as String?,
        street: json['street'] as String?,
        postalCode: json['postalCode'] as String?,
        city: json['city'] as String?,
        country: json['country'] as String?,
        telephoneNumber: json['telephoneNumber'] as String?,
      );

  final String? vorname;
  final String? nachname;
  final String? email;
  final String? street;
  final String? postalCode;
  final String? city;
  final String? country;
  final String? telephoneNumber;
}
