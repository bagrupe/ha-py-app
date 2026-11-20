/// Immutable volunteer marketplace category.
class VolunteerCategoryModel {
  /// Creates a volunteer marketplace category.
  const VolunteerCategoryModel({required this.id, required this.name});

  /// Stable backend identifier.
  final String id;

  /// Display name supplied by the backend.
  final String name;
}
