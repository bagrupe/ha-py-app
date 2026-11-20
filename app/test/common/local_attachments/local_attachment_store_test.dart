import 'dart:convert';
import 'dart:io';

import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/schritte/user_stored_inhalte.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temporary;
  late SharedPreferences prefs;

  setUp(() async {
    temporary = Directory.systemTemp.createTempSync('attachment_store_test');
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => temporary.path,
        );
  });

  tearDown(() => temporary.deleteSync(recursive: true));

  test('retains file contents and persists only temporary paths', () async {
    final original = File('${temporary.path}/original.png');
    await original.writeAsBytes([1, 2, 3]);
    final store = LocalAttachmentStore(prefs);
    await store.save('field_image_single_photo', [XFile(original.path)]);
    await original.delete();

    final restored = store.read('field_image_single_photo').single;
    expect(
      restored.path,
      startsWith('${temporary.path}/application_attachments/'),
    );
    expect(await restored.readAsBytes(), [1, 2, 3]);
    expect(jsonDecode(prefs.getString('field_image_single_photo')!), [
      restored.path,
    ]);
  });

  test(
    'migrates JPEG Base64 and document lists without mistaking JPEG for a path',
    () async {
      final jpeg = [0xff, 0xd8, 0xff, 0xe0, 1, 2];
      final pdf = [0x25, 0x50, 0x44, 0x46, 0x2d];
      await prefs.setString('field_image_single_photo', base64Encode(jpeg));
      await prefs.setString(
        'field_image_multi_docs',
        jsonEncode([base64Encode(pdf), base64Encode(jpeg)]),
      );
      final store = LocalAttachmentStore(prefs);
      await store.migrate();

      expect(
        await store.read('field_image_single_photo').single.readAsBytes(),
        jpeg,
      );
      final documents = store.read('field_image_multi_docs');
      expect(documents.length, 2);
      expect(documents.first.path, endsWith('.pdf'));
      final pathsBefore = prefs.getString('field_image_multi_docs');
      await store.migrate();
      expect(prefs.getString('field_image_multi_docs'), pathsBefore);
    },
  );

  test(
    'missing temporary files are excluded and reported for reselection',
    () async {
      final store = LocalAttachmentStore(prefs);
      await store.save('field_image_single_Foto', [
        XFile.fromData(Uint8List.fromList([1]), name: 'photo.png'),
      ]);
      final file = store.read('field_image_single_Foto').single;
      await File(file.path).delete();

      expect(store.hasMissingFiles, isTrue);
      expect(store.read('field_image_single_Foto'), isEmpty);
      expect(
        UserStoredInhalte(prefs: prefs).getSavedDocuments('foto'),
        isEmpty,
      );
    },
  );

  test('legacy images are processed before they can be restored', () async {
    await prefs.setString('field_image_single_photo', base64Encode([1, 2, 3]));
    final processed = File('${temporary.path}/processed.jpg');
    await processed.writeAsBytes([4, 5, 6]);
    final store = LocalAttachmentStore(prefs);
    await store.migrate(processImage: (_) async => XFile(processed.path));

    expect(await store.read('field_image_single_photo').single.readAsBytes(), [
      4,
      5,
      6,
    ]);
  });

  test(
    'failed legacy processing requires reselection instead of using the original',
    () async {
      await prefs.setString(
        'field_image_single_photo',
        base64Encode([1, 2, 3]),
      );
      final store = LocalAttachmentStore(prefs);
      await store.migrate(
        processImage: (_) async => throw StateError('encoder failed'),
      );

      expect(store.read('field_image_single_photo'), isEmpty);
      expect(store.hasMissingFiles, isTrue);
    },
  );

  test(
    'generated signatures migrate to paths and restore as signature bytes',
    () async {
      await prefs.setString(
        'field_signature_Signatur',
        base64Encode([1, 2, 3]),
      );
      await LocalAttachmentStore(prefs).migrate();

      expect(UserStoredInhalte(prefs: prefs).getSignatureValue('signatur'), [
        1,
        2,
        3,
      ]);
      expect(
        prefs.getString('field_signature_Signatur'),
        isNot(base64Encode([1, 2, 3])),
      );
    },
  );

  test('corrupt legacy data becomes a missing attachment notice', () async {
    await prefs.setString('field_image_single_photo', 'invalid base64!');
    final store = LocalAttachmentStore(prefs);
    await store.migrate();
    expect(store.read('field_image_single_photo'), isEmpty);
    expect(store.hasMissingFiles, isTrue);
  });

  test('cleared signatures cannot be restored in another form', () async {
    /// Container exercising the application's actual field persistence path.
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    /// Notifier used to save and subsequently clear the signature.
    final notifier = container.read(antragProgressProvider.notifier);
    await notifier.saveFieldValues({
      'Signatur': Uint8List.fromList([1, 2, 3]),
    });
    expect(UserStoredInhalte(prefs: prefs).getSignatureValue('signatur'), [
      1,
      2,
      3,
    ]);

    await notifier.saveFieldValues({'Signatur': null});

    expect(prefs.containsKey('field_signature_Signatur'), isFalse);
    expect(
      UserStoredInhalte(prefs: prefs).getSignatureValue('signatur'),
      isNull,
    );
  });
}
