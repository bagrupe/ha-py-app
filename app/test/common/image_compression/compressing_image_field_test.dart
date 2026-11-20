import 'dart:io';

import 'package:app/common/image_compression/compressing_image_field.dart';
import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('compressing_field_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => tempDir.path,
        );
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('oversized image is removed and a message is shown', (
    tester,
  ) async {
    final formKey = GlobalKey<FormBuilderState>();
    late ValueChanged<List<dynamic>?> report;
    final oversized = File('${tempDir.path}/riesig.png');
    oversized.openSync(mode: FileMode.write)
      ..setPositionSync(ImageCompressionProfile.maxInputBytes)
      ..writeByteSync(0)
      ..closeSync();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormBuilder(
            key: formKey,
            child: CompressingImageField(
              name: 'a',
              profile: ImageCompressionProfile.foto,
              builder: (context, onChanged) {
                report = onChanged;
                return FormBuilderField<List<dynamic>>(
                  name: 'a',
                  builder: (field) => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      report([XFile(oversized.path)]);
      await awaitPendingImageCompressions();
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump();

    expect(find.text('application.image_picker.too_large'), findsOneWidget);
    expect(formKey.currentState!.fields['a']!.value, isEmpty);
  });

  testWidgets('other files in the same selection are kept', (tester) async {
    final formKey = GlobalKey<FormBuilderState>();
    late ValueChanged<List<dynamic>?> report;
    final oversized = File('${tempDir.path}/riesig.png');
    oversized.openSync(mode: FileMode.write)
      ..setPositionSync(ImageCompressionProfile.maxInputBytes)
      ..writeByteSync(0)
      ..closeSync();
    final pdf = XFile(
      (File(
        '${tempDir.path}/dokument.pdf',
      )..writeAsBytesSync([0x25, 0x50, 0x44, 0x46])).path,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormBuilder(
            key: formKey,
            child: CompressingImageField(
              name: 'a',
              profile: ImageCompressionProfile.foto,
              builder: (context, onChanged) {
                report = onChanged;
                return FormBuilderField<List<dynamic>>(
                  name: 'a',
                  builder: (field) => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      report([pdf, XFile(oversized.path)]);
      await awaitPendingImageCompressions();
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump();

    final value = formKey.currentState!.fields['a']!.value as List;
    expect(value, hasLength(1));
    final retained = value.single as XFile;
    expect(
      retained.path,
      startsWith('${tempDir.path}/application_attachments/'),
    );
    expect(File(retained.path).readAsBytesSync(), [0x25, 0x50, 0x44, 0x46]);
  });

  testWidgets('processing errors preserve valid and restored attachments', (
    tester,
  ) async {
    /// Form receiving the successfully processed selection.
    final formKey = GlobalKey<FormBuilderState>();

    /// Selection callback exposed by the compression wrapper.
    late ValueChanged<List<dynamic>?> report;

    /// Valid newly selected document before the failing image.
    final document = File('${tempDir.path}/document.pdf')
      ..writeAsBytesSync([0x25, 0x50, 0x44, 0x46]);

    /// Invalid image that must not discard other attachments.
    final invalid = File('${tempDir.path}/invalid.png')
      ..writeAsBytesSync([1, 2, 3]);

    /// Previously retained file restored without an in-memory processed marker.
    late XFile restored;
    await tester.runAsync(() async {
      final retained = await compressImage(
        XFile(document.path),
        ImageCompressionProfile.foto,
      );
      restored = XFile(retained.path);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormBuilder(
            key: formKey,
            child: CompressingImageField(
              name: 'a',
              profile: ImageCompressionProfile.foto,
              builder: (context, onChanged) {
                report = onChanged;
                return FormBuilderField<List<dynamic>>(
                  name: 'a',
                  builder: (field) => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      report([XFile(document.path), XFile(invalid.path), restored]);
      await awaitPendingImageCompressions();
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump();

    /// Retained results from both sides of the failed attachment.
    final value = formKey.currentState!.fields['a']!.value as List;
    expect(value, hasLength(2));
    expect((value.first as XFile).path, isNot(document.path));
    expect((value.last as XFile).path, restored.path);
    for (final file in value.cast<XFile>()) {
      expect(isProcessed(file), isTrue);
      expect(File(file.path).readAsBytesSync(), [0x25, 0x50, 0x44, 0x46]);
    }
    expect(
      find.text('application.attachments.processing_error'),
      findsOneWidget,
    );
  });
}
