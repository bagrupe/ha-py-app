import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/routes/melder/common/report_upload_image.dart';

/// Provides reusable parsing helpers for report form fields and slot values.
class ReportFormValueParser {
  /// Returns all form fields from the first process steps.
  static List<Fragment_FormularFeld> formFields(
    Fragment_ProzessVersion version,
  ) {
    return version.ersteSchritte
        .whereType<Fragment_Schritt__FormularSchritt>()
        .expand((step) => step.felder)
        .toList();
  }

  /// Returns plain slot values keyed by their slot name.
  static Map<String, Object?> plainSlotValues(Iterable<Object?> slotValues) {
    final values = <String, Object?>{};
    for (final slotValue in slotValues) {
      final plainSlotValue = _PlainSlotValue.tryParse(slotValue);
      if (plainSlotValue != null) {
        values[plainSlotValue.slotName] = plainSlotValue.value;
      }
    }
    return values;
  }

  /// Returns the first displayable value for the given slot names.
  static String? firstDisplayValue(
    Map<String, Object?> slotValues,
    Iterable<String> slotNames,
  ) {
    for (final slotName in slotNames) {
      final value = displayValue(slotValues[slotName]);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  /// Returns the first uploaded image from upload field values.
  static ReportUploadImage? firstImage(
    List<Fragment_FormularFeld> fields,
    Map<String, Object?> slotValues,
  ) {
    for (final field in fields) {
      if (field is! Fragment_FormularFeld__UploadFormularFeld ||
          field.document) {
        continue;
      }
      final image = ReportUploadImage.tryParse(slotValues[field.slotName]);
      if (image != null) {
        return image;
      }
    }
    return null;
  }

  /// Returns a user-facing value for supported slot value shapes.
  static String? displayValue(Object? value) {
    if (value is Map<String, dynamic>) {
      return stringValue(value['addressString']);
    }
    if (value is Map) {
      return stringValue(value['addressString']);
    }
    if (value is List) {
      final values = value.map(displayValue).whereType<String>().toList();
      if (values.isEmpty) {
        return null;
      }
      return values.join(', ');
    }
    return stringValue(value);
  }

  /// Returns a scalar value as displayable text.
  static String? stringValue(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmedValue = value.trim();
      if (trimmedValue.isEmpty) {
        return null;
      }
      return trimmedValue;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    return null;
  }
}

/// Normalized plain slot value data.
class _PlainSlotValue {
  /// Creates normalized plain slot value data.
  const _PlainSlotValue({required this.slotName, required this.value});

  /// Creates normalized plain slot value data from generated GraphQL values.
  static _PlainSlotValue? tryParse(Object? slotValue) {
    if (slotValue is Fragment_ReportExecutionSlotValue__PlainSlotValue) {
      return _PlainSlotValue.fromParts(
        slotName: slotValue.slotName,
        value: slotValue.value,
      );
    }
    if (slotValue
        is Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue) {
      return _PlainSlotValue.fromParts(
        slotName: slotValue.slotName,
        value: slotValue.value,
      );
    }
    return null;
  }

  /// Creates normalized plain slot value data from typed fields.
  static _PlainSlotValue? fromParts({
    required String slotName,
    required Object? value,
  }) {
    return _PlainSlotValue(slotName: slotName, value: value);
  }

  /// Slot name for the value.
  final String slotName;

  /// Raw user-entered slot value.
  final Object? value;
}
