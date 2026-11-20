import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Records native compression options without requiring a device encoder.
class RecordingImageCompressor extends Fake
    with MockPlatformInterfaceMixin
    implements FlutterImageCompressPlatform {
  /// Whether the native encoder should simulate a processing failure.
  bool fail = false;

  /// Metadata preservation settings observed by the native encoder.
  final exifOptions = <bool>[];

  /// Requested dimensions observed by the native encoder.
  final dimensions = <(int, int)>[];

  @override
  Future<XFile?> compressAndGetFile(
    String path,
    String targetPath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
    int numberOfRetries = 5,
  }) async {
    exifOptions.add(keepExif);
    dimensions.add((minWidth, minHeight));
    if (fail) return null;
    await File(path).copy(targetPath);
    return XFile(targetPath);
  }
}
