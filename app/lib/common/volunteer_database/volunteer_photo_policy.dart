import 'dart:io';

import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:mime/mime.dart';

/// Upload constraints shared by volunteer request photo submissions.
abstract final class VolunteerPhotoPolicy {
  /// Maximum photo size accepted by the app's image picker.
  static const maxBytes = 5 * 1024 * 1024;

  /// Image media types accepted by the backend.
  static const contentTypes = [
    'image/jpeg',
    'image/png',
    'image/heic',
    'image/webp',
  ];

  /// Validates a local photo and returns its declared media type.
  static Future<String> validate(File photo) async {
    if (await photo.length() > maxBytes) {
      throw const ObjectTooLarge(maxBytes);
    }
    final contentType = lookupMimeType(photo.path);
    if (!contentTypes.contains(contentType)) {
      throw const ObjectContentTypeNotAllowed(contentTypes);
    }
    return contentType!;
  }
}
