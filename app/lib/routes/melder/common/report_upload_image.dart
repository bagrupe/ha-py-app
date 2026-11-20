import 'dart:convert';
import 'dart:typed_data';

/// Normalized image data for uploaded report images.
class ReportUploadImage {
  /// Creates image data backed by a backend file id.
  const ReportUploadImage.fileId(this.fileId) : bytes = null;

  /// Creates image data backed by decoded image bytes.
  const ReportUploadImage.bytes(this.bytes) : fileId = null;

  /// Tries to create image data from supported upload slot value shapes.
  static ReportUploadImage? tryParse(Object? value) {
    if (value is List && value.isNotEmpty) {
      return ReportUploadImage.tryParse(value.first);
    }
    if (value is Map) {
      final byteImage = ReportUploadImage._fromByteCandidate(
        value['bytes'] ?? value['data'] ?? value['base64'],
      );
      if (byteImage != null) {
        return byteImage;
      }
      return ReportUploadImage.tryParse(value['id']);
    }
    final byteImage = ReportUploadImage._fromByteCandidate(value);
    if (byteImage != null) {
      return byteImage;
    }
    final fileId = _stringValue(value);
    return fileId == null ? null : ReportUploadImage.fileId(fileId);
  }

  /// Optional backend file id.
  final String? fileId;

  /// Optional decoded image bytes.
  final Uint8List? bytes;

  /// Builds a backend URL for file-id based images.
  String? imageUrl(String backendUrl, int size) {
    final id = fileId;
    if (id == null) {
      return null;
    }
    return '$backendUrl/api/file/$id/$size';
  }

  /// Tries to create byte-backed image data.
  static ReportUploadImage? _fromByteCandidate(Object? value) {
    final stringValue = _stringValue(value);
    if (stringValue == null) {
      return null;
    }
    final base64Value = _base64Payload(stringValue);
    if (!_looksLikeImageBase64(base64Value)) {
      return null;
    }
    try {
      return ReportUploadImage.bytes(base64Decode(base64Value));
    } on FormatException {
      return null;
    }
  }

  /// Extracts the base64 payload from plain or data-url values.
  static String _base64Payload(String value) {
    final commaIndex = value.indexOf(',');
    if (value.startsWith('data:') && commaIndex != -1) {
      return _withoutWhitespace(value.substring(commaIndex + 1));
    }
    return _withoutWhitespace(value);
  }

  /// Returns true for common image base64 prefixes.
  static bool _looksLikeImageBase64(String value) {
    return value.startsWith('/9j/') ||
        value.startsWith('iVBOR') ||
        value.startsWith('R0lG') ||
        value.startsWith('UklGR');
  }

  /// Returns a value without base64 whitespace.
  static String _withoutWhitespace(String value) {
    return value.replaceAll(RegExp(r'\s'), '');
  }

  /// Returns scalar values as strings.
  static String? _stringValue(Object? value) {
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
    return null;
  }
}
