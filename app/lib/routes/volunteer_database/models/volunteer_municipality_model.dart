/// Immutable municipality option for volunteer request creation.
class VolunteerMunicipalityModel {
  /// Creates a municipality option.
  const VolunteerMunicipalityModel({required this.id, required this.name});

  /// Stable backend identifier.
  final String id;

  /// Localized municipality name supplied by the backend.
  final String name;
}
