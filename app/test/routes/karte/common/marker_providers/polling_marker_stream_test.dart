import 'dart:async';

import 'package:app/routes/karte/common/marker_providers/polling_marker_stream.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

MarkerData _marker(String id, {MarkerType type = MarkerType.mangelOpen}) {
  return MarkerData(
    id: id,
    type: type,
    point: const LatLng(52.1, 9.35),
    marker: const SizedBox(),
    routePrefix: '/karte/maengel/detail/',
  );
}

void main() {
  late Future<List<MarkerData>?> Function() fetch;
  var enabled = true;
  var fetchCount = 0;

  final testProvider = Provider.autoDispose<Stream<List<MarkerData>>>(
    (ref) => pollingMarkerStream(
      ref,
      enabled: enabled,
      fetch: () {
        fetchCount++;
        return fetch();
      },
    ),
  );

  setUp(() {
    enabled = true;
    fetchCount = 0;
  });

  void run(
    void Function(FakeAsync async, List<List<MarkerData>> emitted) body,
  ) {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(testProvider, (_, __) {});
      final emitted = <List<MarkerData>>[];
      final sub = container.read(testProvider).listen(emitted.add);
      addTearDown(sub.cancel);
      body(async, emitted);
    });
  }

  group('pollingMarkerStream', () {
    test('emits the first result immediately', () {
      fetch = () async => [_marker('a')];
      run((async, emitted) {
        async.elapse(Duration.zero);
        expect(emitted.single.map((m) => m.id), ['a']);
      });
    });

    test('removes a marker that disappeared from the backend', () {
      var results = [_marker('a'), _marker('b')];
      fetch = () async => results;
      run((async, emitted) {
        async.elapse(Duration.zero);
        results = [_marker('a')];
        async.elapse(markerRefreshInterval);
        expect(emitted.last.map((m) => m.id), ['a']);
      });
    });

    test('adds a new marker on the next refresh', () {
      var results = [_marker('a')];
      fetch = () async => results;
      run((async, emitted) {
        async.elapse(Duration.zero);
        results = [_marker('a'), _marker('b')];
        async.elapse(markerRefreshInterval);
        expect(emitted.last.map((m) => m.id), ['a', 'b']);
      });
    });

    test('emits again when only the marker type changes', () {
      var results = [_marker('a')];
      fetch = () async => results;
      run((async, emitted) {
        async.elapse(Duration.zero);
        results = [_marker('a', type: MarkerType.mangelCompleted)];
        async.elapse(markerRefreshInterval);
        expect(emitted, hasLength(2));
        expect(emitted.last.single.type, MarkerType.mangelCompleted);
      });
    });

    test('does not re-emit an unchanged result', () {
      fetch = () async => [_marker('a')];
      run((async, emitted) {
        async.elapse(markerRefreshInterval * 3);
        expect(fetchCount, 4);
        expect(emitted, hasLength(1));
      });
    });

    test('keeps the last markers when a refresh fails and recovers later', () {
      var fail = false;
      fetch = () async => fail ? null : [_marker('a')];
      run((async, emitted) {
        async.elapse(Duration.zero);
        fail = true;
        async.elapse(markerRefreshInterval);
        expect(emitted, hasLength(1), reason: 'failure must not clear markers');
        fail = false;
        async.elapse(markerRefreshInterval);
        expect(fetchCount, 3);
      });
    });

    test('keeps the last markers when fetch throws', () {
      var fail = false;
      fetch = () async =>
          fail ? throw StateError('bad response') : [_marker('a')];
      run((async, emitted) {
        async.elapse(Duration.zero);
        fail = true;
        async.elapse(markerRefreshInterval);
        expect(emitted, hasLength(1));
      });
    });

    test('emits an empty list when the very first fetch fails', () {
      fetch = () async => null;
      run((async, emitted) {
        async.elapse(Duration.zero);
        expect(emitted.single, isEmpty);
      });
    });

    test('emits an empty list when the very first fetch throws', () {
      fetch = () async => throw StateError('bad response');
      run((async, emitted) {
        async.elapse(Duration.zero);
        expect(emitted.single, isEmpty);
      });
    });

    test('recovers with markers after a failed first fetch', () {
      var fail = true;
      fetch = () async => fail ? null : [_marker('a')];
      run((async, emitted) {
        async.elapse(Duration.zero);
        fail = false;
        async.elapse(markerRefreshInterval);
        expect(emitted.last.map((m) => m.id), ['a']);
      });
    });

    test('ignores an older response that arrives after a newer one', () {
      final pending = <Completer<List<MarkerData>?>>[];
      fetch = () {
        final completer = Completer<List<MarkerData>?>();
        pending.add(completer);
        return completer.future;
      };
      run((async, emitted) {
        async.elapse(markerRefreshInterval);
        expect(pending, hasLength(2));

        pending[1].complete([_marker('new')]);
        async.flushMicrotasks();
        pending[0].complete([_marker('old')]);
        async.flushMicrotasks();

        expect(emitted.map((e) => e.single.id), ['new']);
      });
    });

    test('still applies a slow response when no newer one was applied', () {
      final pending = <Completer<List<MarkerData>?>>[];
      fetch = () {
        final completer = Completer<List<MarkerData>?>();
        pending.add(completer);
        return completer.future;
      };
      run((async, emitted) {
        async.elapse(markerRefreshInterval);
        pending[0].complete([_marker('slow')]);
        async.flushMicrotasks();
        expect(emitted.single.single.id, 'slow');
      });
    });

    test('emits an empty list without fetching while disabled', () {
      enabled = false;
      fetch = () async => [_marker('a')];
      run((async, emitted) {
        async.elapse(markerRefreshInterval * 2);
        expect(emitted.single, isEmpty);
        expect(fetchCount, 0);
      });
    });

    test('stops polling once the provider is disposed', () {
      fetch = () async => [_marker('a')];
      fakeAsync((async) {
        final container = ProviderContainer();
        final sub = container.listen(testProvider, (_, __) {});
        async.flushMicrotasks();
        expect(fetchCount, 1);

        sub.close();
        container.dispose();
        async.elapse(markerRefreshInterval * 3);
        expect(fetchCount, 1);
      });
    });
  });
}
