/// Bundled attribution metadata for a resolved dependency.
class OpenSourcePackage {
  /// Creates immutable package metadata.
  const OpenSourcePackage({
    required this.name,
    required this.version,
    required this.license,
  });

  /// Reads metadata produced by dart_pubspec_licenses.
  factory OpenSourcePackage.fromJson(Map<String, dynamic> json) =>
      OpenSourcePackage(
        name: json['name'] as String,
        version: json['version'] as String? ?? '',
        license: json['license'] as String? ?? '',
      );

  /// The dependency name.
  final String name;

  /// The resolved dependency version.
  final String version;

  /// The complete, unmodified license notice.
  final String license;
}
