/// Represents one displayable idea detail value with its process-defined label.
class IdeaDetailValue {
  /// Creates a displayable idea detail value.
  const IdeaDetailValue({required this.label, required this.value});

  /// Process-defined label for the value.
  final String label;

  /// User-entered value displayed for the label.
  final String value;
}
