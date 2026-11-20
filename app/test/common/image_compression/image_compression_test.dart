import 'dart:io';
import 'dart:ui' as ui;

import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/image_compression/image_too_large_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recording_image_compressor.dart';

Future<File> _writePng(Directory dir, int width, int height) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..color = const ui.Color(0xFF336699),
  );
  final image = await recorder.endRecording().toImage(width, height);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File('${dir.path}/test_${width}x$height.png');
  await file.writeAsBytes(data!.buffer.asUint8List());
  return file;
}

int _crc32(List<int> data) {
  var crc = 0xFFFFFFFF;
  for (final byte in data) {
    crc ^= byte;
    for (var i = 0; i < 8; i++) {
      crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
    }
  }
  return crc ^ 0xFFFFFFFF;
}

List<int> _pngChunk(String type, List<int> data) {
  final body = [...type.codeUnits, ...data];
  return [
    ...(ByteData(4)..setUint32(0, data.length)).buffer.asUint8List(),
    ...body,
    ...(ByteData(4)..setUint32(0, _crc32(body))).buffer.asUint8List(),
  ];
}

File _writePngHeaderOnly(Directory dir, int width, int height) {
  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8)
    ..setUint8(9, 2);
  return File('${dir.path}/header_${width}x$height.png')..writeAsBytesSync([
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    ..._pngChunk('IHDR', header.buffer.asUint8List()),
    ..._pngChunk('IDAT', ZLibEncoder().convert([0])),
    ..._pngChunk('IEND', const []),
  ]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RecordingImageCompressor compressor;
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('image_compression_test');
    compressor = RecordingImageCompressor();
    FlutterImageCompressPlatform.instance = compressor;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => tempDir.path,
        );
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('compressImage', () {
    test('PDF is left unchanged and marked as processed', () async {
      final pdf = File('${tempDir.path}/dokument.pdf')
        ..writeAsBytesSync([0x25, 0x50, 0x44, 0x46]);
      final input = XFile(pdf.path);

      final result = await compressImage(input, ImageCompressionProfile.foto);

      expect(await result.readAsBytes(), await input.readAsBytes());
      expect(isProcessed(result), isTrue);
    });

    test('small images are re-encoded without preserving EXIF', () async {
      final png = await _writePng(tempDir, 200, 100);
      final input = XFile(png.path);

      final result = await compressImage(input, ImageCompressionProfile.foto);

      expect(result.path, isNot(png.path));
      expect(compressor.exifOptions, [false]);
      expect(compressor.dimensions, [(100, 100)]);
      expect(isProcessed(result), isTrue);
    });

    test('compression failure never returns the original image', () async {
      final png = await _writePng(tempDir, 200, 100);
      compressor.fail = true;
      final input = XFile(png.path);
      await expectLater(
        compressImage(input, ImageCompressionProfile.foto),
        throwsStateError,
      );
      expect(isProcessed(input), isFalse);
    });

    test('already processed file is not touched again', () async {
      final png = await _writePng(tempDir, 200, 100);
      final first = await compressImage(
        XFile(png.path),
        ImageCompressionProfile.foto,
      );

      final second = await compressImage(
        first,
        ImageCompressionProfile.dokument,
      );

      expect(second, same(first));
    });

    test('file above the byte limit is rejected without decoding', () async {
      final file = File('${tempDir.path}/riesig.png');
      file.openSync(mode: FileMode.write)
        ..setPositionSync(ImageCompressionProfile.maxInputBytes)
        ..writeByteSync(0)
        ..closeSync();

      expect(
        compressImage(XFile(file.path), ImageCompressionProfile.foto),
        throwsA(isA<ImageTooLargeException>()),
      );
    });

    test('image above the pixel limit is rejected', () async {
      final png = _writePngHeaderOnly(tempDir, 20000, 20000);

      expect(
        compressImage(XFile(png.path), ImageCompressionProfile.foto),
        throwsA(isA<ImageTooLargeException>()),
      );
    });

    test('image just below the pixel limit is accepted', () async {
      final png = _writePngHeaderOnly(tempDir, 9000, 11000);
      final input = XFile(png.path);

      final result = await compressImage(input, ImageCompressionProfile.foto);

      expect(isProcessed(result), isTrue);
    });

    test('order is preserved for multiple files', () async {
      final a = await _writePng(tempDir, 20, 20);
      final b = await _writePng(tempDir, 30, 30);

      final result = await compressImages([
        XFile(a.path),
        XFile(b.path),
      ], ImageCompressionProfile.foto);

      expect(await result[0].readAsBytes(), await a.readAsBytes());
      expect(await result[1].readAsBytes(), await b.readAsBytes());
    });
  });
}
