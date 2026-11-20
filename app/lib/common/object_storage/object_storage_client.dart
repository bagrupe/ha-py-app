import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

/// Reports how many of [total] bytes have been handed to the connection.
typedef UploadProgressCallback = void Function(int sent, int total);

/// Client for the backend's `/api/objects/{prefix}` upload and download routes.
class ObjectStorageClient {
  /// Creates a client against [backendUrl].
  ObjectStorageClient({
    required this.backendUrl,
    required this.authHeaders,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Base URL of the backend serving `/api/objects`.
  final String backendUrl;

  /// Resolved per request so a refreshed token is picked up.
  final Map<String, String>? Function() authHeaders;

  final http.Client _httpClient;

  /// URL under which the object stored as [key] is served.
  String urlFor(String key) => '$backendUrl/api/objects/$key';

  /// Uploads [bytes] already held in memory and returns the stored key.
  Future<String> uploadBytes(
    String prefix,
    Uint8List bytes, {
    required String contentType,
  }) async {
    final request = http.Request('POST', _uploadUri(prefix))
      ..headers.addAll(_headers(contentType))
      ..bodyBytes = bytes;
    return _keyFrom(await _httpClient.send(request));
  }

  /// Streams [file] without loading it into memory and returns the stored key.
  ///
  /// [contentType] defaults to the type derived from the file extension.
  Future<String> uploadFile(
    String prefix,
    File file, {
    String? contentType,
    UploadProgressCallback? onProgress,
  }) async {
    final total = await file.length();
    // The backend answers 411 without a Content-Length, so the body must not be chunked.
    final request = http.StreamedRequest('POST', _uploadUri(prefix))
      ..contentLength = total
      ..headers.addAll(
        _headers(
          contentType ??
              lookupMimeType(file.path) ??
              'application/octet-stream',
        ),
      );
    final response = _httpClient.send(request);

    var sent = 0;
    try {
      await for (final chunk in file.openRead()) {
        request.sink.add(chunk);
        sent += chunk.length;
        onProgress?.call(sent, total);
      }
    } on Object catch (error, stackTrace) {
      request.sink.addError(error, stackTrace);
      rethrow;
    } finally {
      unawaited(request.sink.close());
    }
    return _keyFrom(await response);
  }

  Uri _uploadUri(String prefix) => Uri.parse('$backendUrl/api/objects/$prefix');

  Map<String, String> _headers(String contentType) => {
    ...?authHeaders(),
    HttpHeaders.contentTypeHeader: contentType,
  };

  Future<String> _keyFrom(http.StreamedResponse streamed) async {
    final response = await http.Response.fromStream(streamed);
    var body = const <String, dynamic>{};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } on FormatException {
      body = const {};
    }
    return switch (response.statusCode) {
      HttpStatus.created when body['key'] is String => body['key'] as String,
      HttpStatus.unauthorized => throw const ObjectUploadUnauthorized(),
      HttpStatus.forbidden => throw const ObjectUploadForbidden(),
      HttpStatus.requestEntityTooLarge => throw ObjectTooLarge(
        (body['maxBytes'] as int?) ?? 0,
      ),
      HttpStatus.unsupportedMediaType => throw ObjectContentTypeNotAllowed(
        (body['allowed'] as List<dynamic>? ?? const []).cast<String>(),
      ),
      HttpStatus.serviceUnavailable => throw const ObjectStorageUnavailable(),
      final status => throw ObjectUploadFailed(status, response.body),
    };
  }
}

/// Failure of an upload to `/api/objects`.
sealed class ObjectUploadException implements Exception {
  const ObjectUploadException();
}

/// No valid bearer token was sent (401).
class ObjectUploadUnauthorized extends ObjectUploadException {
  /// Creates the exception.
  const ObjectUploadUnauthorized();
}

/// The user may not upload under this prefix (403).
class ObjectUploadForbidden extends ObjectUploadException {
  /// Creates the exception.
  const ObjectUploadForbidden();
}

/// The object exceeds the prefix's size limit (413).
class ObjectTooLarge extends ObjectUploadException {
  /// Creates the exception with the server's limit.
  const ObjectTooLarge(this.maxBytes);

  /// Maximum accepted size in bytes.
  final int maxBytes;
}

/// The content type is not accepted for this prefix (415).
class ObjectContentTypeNotAllowed extends ObjectUploadException {
  /// Creates the exception with the accepted types.
  const ObjectContentTypeNotAllowed(this.allowed);

  /// Content types the prefix accepts.
  final List<String> allowed;
}

/// Object storage is not configured on the backend (503).
class ObjectStorageUnavailable extends ObjectUploadException {
  /// Creates the exception.
  const ObjectStorageUnavailable();
}

/// Any other non-201 response.
class ObjectUploadFailed extends ObjectUploadException {
  /// Creates the exception from the raw response.
  const ObjectUploadFailed(this.statusCode, this.body);

  /// HTTP status code of the response.
  final int statusCode;

  /// Raw response body.
  final String body;

  @override
  String toString() => 'ObjectUploadFailed($statusCode): $body';
}

/// Provides the object storage client for the configured backend.
final objectStorageClientProvider = Provider<ObjectStorageClient>((ref) {
  return ObjectStorageClient(
    backendUrl: ref.watch(appConfigProvider).backendUrl,
    authHeaders: () => ref.read(fileAuthHeadersProvider),
  );
});
