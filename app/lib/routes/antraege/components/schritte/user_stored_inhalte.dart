import 'dart:io';
import 'dart:typed_data';

import 'package:app/common/extensions/string.dart';
import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:cross_file/cross_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

const singleImagePrefix = 'field_image_single_';
const multiImagePrefix = 'field_image_multi_';
const defaultPrefix = 'field_';

/// Manages access to user-stored content in SharedPreferences.
class UserStoredInhalte {
  /// Creates an instance with the provided SharedPreferences.
  UserStoredInhalte({required this.prefs});
  final SharedPreferences prefs;

  /// Retrieves a saved string value by its content tag, using normalization for robust matching.
  String? getSimpleValue(String inhaltsTag) =>
      _getNormalizedString(defaultPrefix, inhaltsTag);

  /// Retrieves a single saved image as an XFile, if present.
  XFile? getSingleImageValue(String inhaltsTag) {
    final files = getSavedDocuments(inhaltsTag);
    return files == null || files.isEmpty ? null : files.first;
  }

  /// Retrieves existing saved attachments synchronously as form initial values.
  List<XFile>? getSavedDocuments(String inhaltsTag) {
    final key =
        _getNormalizedKey(singleImagePrefix, inhaltsTag) ??
        _getNormalizedKey(multiImagePrefix, inhaltsTag);
    return key == null ? null : LocalAttachmentStore(prefs).read(key);
  }

  /// Reads a locally retained, generated signature for its form field.
  Uint8List? getSignatureValue(String inhaltsTag) {
    final key = _getNormalizedKey('field_signature_', inhaltsTag);
    if (key == null) return null;
    final files = LocalAttachmentStore(prefs).read(key);
    return files.isEmpty ? null : File(files.first.path).readAsBytesSync();
  }

  /// Finds a preference key using the normalized content tag.
  String? _getNormalizedKey(String prefix, String inhaltsTag) {
    for (final key in prefs.getKeys()) {
      if (key.startsWith(prefix) &&
          key.substring(prefix.length).normalize() == inhaltsTag.normalize()) {
        return key;
      }
    }
    return null;
  }

  /// Helper to find a value in SharedPreferences by normalizing keys.
  /// This ensures that searching for "strasse" finds "field_Straße".
  String? _getNormalizedString(String prefix, String inhaltsTag) {
    final exactMatch = prefs.getString('$prefix$inhaltsTag');
    if (exactMatch != null) return exactMatch;

    final normalizedSearch = inhaltsTag.normalize();
    final allKeys = prefs.getKeys();

    for (final key in allKeys) {
      if (key.startsWith(prefix)) {
        final punchTag = key.substring(prefix.length);
        if (punchTag.normalize() == normalizedSearch) {
          return prefs.getString(key);
        }
      }
    }

    return null;
  }
}
