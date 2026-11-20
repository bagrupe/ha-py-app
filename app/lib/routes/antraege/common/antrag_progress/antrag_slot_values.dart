part of 'antrag_progress.dart';

/// Encrypts a value with the given key and returns the encrypted input.
Future<Input_EncryptedValueInput> toEncryptedSlotValue(
  dynamic value,
  Uint8List key,
) async {
  final byteValue = await convertToByteArray(value);
  final encryptedValue = await Crypto.encrypt(byteValue, key);

  return encryptedValue.toInput();
}

/// Converts a value into a simple, non-encrypted form.
Future<dynamic> toPlainSlotValue(dynamic value) async {
  if (value is String || value is num || value is bool) return value;
  if (value is Uint8List) return value.toBase64String();
  if (value is List) return Future.wait(value.map(toPlainSlotValue));
  if (value is XFile) return (await value.readAsBytes()).toBase64String();
  if (value is DateTime) return value.toIso8601String();

  if (value == null || value is Map) return jsonEncode(value);
  return jsonDecode(jsonEncode(value));
}

/// Ensures restored and initially supplied files are processed before upload.
Future<dynamic> _prepareAttachmentValue(dynamic value) async {
  if (value is XFile) {
    return compressImage(value, ImageCompressionProfile.dokument);
  }
  if (value is List && value.any((item) => item is XFile)) {
    final result = <dynamic>[];
    for (final item in value) {
      result.add(await _prepareAttachmentValue(item));
    }
    return result;
  }
  return value;
}
