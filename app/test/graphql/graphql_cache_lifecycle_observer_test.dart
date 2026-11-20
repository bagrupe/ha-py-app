import 'dart:async';

import 'package:app/graphql/graphql_cache_lifecycle_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies persistence triggers for application lifecycle transitions.
void main() {
  test('flushes when the application leaves the foreground', () async {
    var flushCount = 0;
    GraphQLCacheLifecycleObserver(
      flush: () async {
        flushCount++;
      },
    ).didChangeAppLifecycleState(AppLifecycleState.inactive);
    await Future<void>.delayed(Duration.zero);

    expect(flushCount, 1);
  });

  test('deduplicates concurrent lifecycle flushes', () async {
    var flushCount = 0;
    final completer = Completer<void>();
    GraphQLCacheLifecycleObserver(
        flush: () {
          flushCount++;
          return completer.future;
        },
      )
      ..didChangeAppLifecycleState(AppLifecycleState.inactive)
      ..didChangeAppLifecycleState(AppLifecycleState.paused)
      ..didChangeAppLifecycleState(AppLifecycleState.detached);

    expect(flushCount, 1);
    completer.complete();
    await completer.future;
  });

  test('does not flush when the application resumes', () {
    var flushCount = 0;
    GraphQLCacheLifecycleObserver(
      flush: () async {
        flushCount++;
      },
    ).didChangeAppLifecycleState(AppLifecycleState.resumed);

    expect(flushCount, 0);
  });
}
