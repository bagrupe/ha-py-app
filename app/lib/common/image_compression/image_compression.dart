import 'dart:async';
import 'dart:ui' as ui;

import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/image_compression/image_too_large_exception.dart';
import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uuid/uuid.dart';

final _processed = Expando<bool>('imageCompressionProcessed');

bool isProcessed(XFile file) => _processed[file] ?? false;

XFile _markProcessed(XFile file) {
  _processed[file] = true;
  return file;
}

/// Re-encodes images without source metadata and retains their temporary files.
/// Processing failures propagate so unprocessed originals cannot be uploaded.
Future<XFile> compressImage(XFile file, ImageCompressionProfile profile) async {
  if (isProcessed(file)) return file;

  try {
    final mime = file.mimeType ?? lookupMimeType(file.name);
    if (mime != null && !mime.startsWith('image/')) {
      return _markProcessed(await LocalAttachmentStore.retain(file));
    }
    final bytes = await file.length();
    if (bytes > ImageCompressionProfile.maxInputBytes) {
      throw const ImageTooLargeException();
    }
    if (kIsWeb) {
      final result = await FlutterImageCompress.compressWithList(
        await file.readAsBytes(),
        minWidth: profile.maxEdge,
        minHeight: profile.maxEdge,
        quality: profile.quality,
      );
      return _markProcessed(XFile.fromData(result, mimeType: 'image/jpeg'));
    }

    final source = await LocalAttachmentStore.retain(file);
    final (width, height) = await _readSize(source.path);
    if (width * height > ImageCompressionProfile.maxInputPixels) {
      throw const ImageTooLargeException();
    }
    final side = profile.targetSide(width: width, height: height);
    final tempDir = await getTemporaryDirectory();
    final target = '${tempDir.path}/compressed_${const Uuid().v4()}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      source.path,
      target,
      minWidth: side,
      minHeight: side,
      inSampleSize: profile.sampleSize(width: width, height: height),
      quality: profile.quality,
    );
    if (result == null) throw StateError('Image compression returned no file');
    final retained = await LocalAttachmentStore.retain(
      XFile(result.path, mimeType: 'image/jpeg'),
    );
    return _markProcessed(retained);
  } on ImageTooLargeException {
    rethrow;
  } catch (error, stackTrace) {
    unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    rethrow;
  }
}

Future<List<XFile>> compressImages(
  List<XFile> files,
  ImageCompressionProfile profile,
) async {
  final result = <XFile>[];
  for (final file in files) {
    result.add(await compressImage(file, profile));
  }
  return result;
}

int _pendingCompressions = 0;
final _idleWaiters = <Completer<void>>[];

Future<T> trackImageCompression<T>(Future<T> future) async {
  _pendingCompressions++;
  try {
    return await future;
  } finally {
    _pendingCompressions--;
    if (_pendingCompressions == 0) {
      for (final waiter in _idleWaiters) {
        if (!waiter.isCompleted) waiter.complete();
      }
      _idleWaiters.clear();
    }
  }
}

Future<void> awaitPendingImageCompressions() {
  if (_pendingCompressions == 0) return Future.value();
  final completer = Completer<void>();
  _idleWaiters.add(completer);
  return completer.future;
}

bool hasPendingImageCompressions() => _pendingCompressions > 0;

Future<(int, int)> _readSize(String path) async {
  final buffer = await ui.ImmutableBuffer.fromFilePath(path);
  try {
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    try {
      return (descriptor.width, descriptor.height);
    } finally {
      descriptor.dispose();
    }
  } finally {
    buffer.dispose();
  }
}
