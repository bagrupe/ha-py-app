import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Stores attachment contents in temporary files and only paths in preferences.
class LocalAttachmentStore {
  /// Creates a store backed by the application's preferences.
  const LocalAttachmentStore(this.prefs);

  /// Preferences containing attachment paths.
  final SharedPreferences prefs;

  /// Identifies image and document preference entries.
  static bool isAttachmentKey(String key) =>
      key.startsWith('field_image_single_') ||
      key.startsWith('field_image_multi_') ||
      key.startsWith('field_signature_');

  /// Reads path lists without loading file contents into memory.
  static List<String> paths(String value) {
    if (value.startsWith('[')) {
      return (jsonDecode(value) as List).cast<String>();
    }
    return [value];
  }

  /// Returns existing attachments, excluding files removed by the system.
  List<XFile> read(String key) {
    final value = prefs.getString(key);
    if (value == null || kIsWeb) return [];
    return paths(value)
        .where((path) => path.startsWith('/') && File(path).existsSync())
        .map(XFile.new)
        .toList();
  }

  /// Copies a file into an application-owned temporary directory.
  static Future<XFile> retain(XFile file) async {
    if (kIsWeb) return file;
    final directory = await _directory();
    if (file.path.startsWith('${directory.path}/') &&
        File(file.path).existsSync()) {
      return file;
    }
    final mime = file.mimeType ?? lookupMimeType(file.name);
    final extension =
        extensionFromMime(mime ?? 'application/octet-stream') ?? 'bin';
    final target = '${directory.path}/${const Uuid().v4()}.$extension';
    await file.saveTo(target);
    return XFile(target, mimeType: mime);
  }

  /// Saves file paths only, after retaining each attachment in temporary storage.
  Future<void> save(String key, List<XFile> files) async {
    if (kIsWeb) {
      await prefs.remove(key);
      return;
    }
    final retained = <String>[];
    for (final file in files) {
      retained.add((await retain(file)).path);
    }
    await prefs.setString(key, jsonEncode(retained));
  }

  /// Migrates legacy Base64 entries one file at a time before forms are loaded.
  Future<void> migrate({
    Future<XFile> Function(XFile file)? processImage,
  }) async {
    if (kIsWeb) return;
    for (final key in prefs.getKeys().where(isAttachmentKey).toList()) {
      try {
        final value = prefs.get(key);
        if (value == null) continue;
        final migrated = <String>[];
        try {
          for (final entry in paths(value as String)) {
            try {
              if (entry.startsWith('/') && !entry.startsWith('/9j/')) {
                migrated.add(entry);
                continue;
              }

              final bytes = await compute(_decodeLegacy, entry);
              final mime = lookupMimeType('', headerBytes: bytes);
              final directory = await _directory();
              final extension = extensionFromMime(mime ?? 'image/jpeg');
              final file = File(
                '${directory.path}/${const Uuid().v4()}.$extension',
              );
              await file.writeAsBytes(bytes, flush: true);
              if (processImage != null && !key.startsWith('field_signature_')) {
                migrated.add((await processImage(XFile(file.path))).path);
              } else {
                migrated.add(file.path);
              }
            } on Object {
              migrated.add('/missing-attachment');
            }
          }
        } on Object {
          migrated.add('/missing-attachment');
        }
        if (!await prefs.setString(key, jsonEncode(migrated))) {
          throw StateError('Could not persist migrated attachment paths');
        }
      } on Object catch (error, stackTrace) {
        unawaited(Sentry.captureException(error, stackTrace: stackTrace));
      }
    }
  }

  /// Reports whether any saved attachment has been removed by the system.
  bool get hasMissingFiles {
    if (kIsWeb) return false;
    return prefs.getKeys().where(isAttachmentKey).any((key) {
      final value = prefs.getString(key);
      return value != null &&
          paths(value).any((path) => !File(path).existsSync());
    });
  }

  /// Creates the temporary directory used by retained attachments.
  static Future<Directory> _directory() async {
    final temporary = await getTemporaryDirectory();
    return Directory(
      '${temporary.path}/application_attachments',
    ).create(recursive: true);
  }
}

/// Decodes a legacy preference value outside the UI isolate.
Uint8List _decodeLegacy(String value) => base64Decode(value);
