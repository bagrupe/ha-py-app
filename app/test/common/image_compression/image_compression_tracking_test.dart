import 'dart:async';

import 'package:app/common/image_compression/image_compression.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('awaitPendingImageCompressions', () {
    test('resolves immediately when nothing is in flight', () async {
      await expectLater(awaitPendingImageCompressions(), completes);
    });

    test('does not resolve before a tracked compression finishes', () async {
      final completer = Completer<void>();
      final done = <String>[];

      unawaited(
        trackImageCompression(completer.future).whenComplete(() {
          done.add('compression');
        }),
      );

      final waiter = awaitPendingImageCompressions().whenComplete(() {
        done.add('waiter');
      });

      await Future<void>.delayed(Duration.zero);
      expect(done, isEmpty);

      completer.complete();
      await waiter;

      expect(done, ['compression', 'waiter']);
    });

    test('waits for every compression tracked concurrently', () async {
      final a = Completer<void>();
      final b = Completer<void>();

      unawaited(trackImageCompression(a.future));
      unawaited(trackImageCompression(b.future));

      var resolved = false;
      final waiter = awaitPendingImageCompressions().whenComplete(
        () => resolved = true,
      );

      a.complete();
      await Future<void>.delayed(Duration.zero);
      expect(resolved, isFalse);

      b.complete();
      await waiter;
      expect(resolved, isTrue);
    });

    test('a failing compression still clears the pending state', () async {
      final completer = Completer<void>();

      unawaited(trackImageCompression(completer.future).catchError((_) {}));
      completer.completeError(Exception('compression failed'));

      await expectLater(awaitPendingImageCompressions(), completes);
    });
  });

  group('hasPendingImageCompressions', () {
    test('is false when nothing is in flight', () async {
      await awaitPendingImageCompressions();
      expect(hasPendingImageCompressions(), isFalse);
    });

    test('is true while a tracked compression is running', () async {
      final completer = Completer<void>();

      unawaited(trackImageCompression(completer.future));
      expect(hasPendingImageCompressions(), isTrue);

      completer.complete();
      await awaitPendingImageCompressions();
      expect(hasPendingImageCompressions(), isFalse);
    });
  });
}
