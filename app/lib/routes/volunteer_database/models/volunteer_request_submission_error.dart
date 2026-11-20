import 'dart:async';
import 'dart:io';

import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

/// Maps submission failures to actionable, localized messages.
abstract final class VolunteerRequestSubmissionError {
  /// Returns the translation key describing [error].
  static String translationKey(Object error) {
    const prefix = 'application.volunteer_database.create_request';
    return switch (error) {
      ObjectTooLarge() => '$prefix.upload_errors.too_large',
      ObjectContentTypeNotAllowed() => '$prefix.upload_errors.format',
      ObjectUploadUnauthorized() => '$prefix.upload_errors.unauthorized',
      ObjectUploadForbidden() => '$prefix.upload_errors.forbidden',
      ObjectStorageUnavailable() => '$prefix.upload_errors.unavailable',
      FileSystemException() => '$prefix.upload_errors.file',
      SocketException() ||
      TimeoutException() ||
      http.ClientException() ||
      OperationException(
        linkException: NetworkException(),
      ) => '$prefix.upload_errors.network',
      _ => '$prefix.error',
    };
  }
}
