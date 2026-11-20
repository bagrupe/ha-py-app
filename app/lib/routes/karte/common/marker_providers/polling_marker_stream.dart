import 'dart:async';

import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

const Duration markerRefreshInterval = Duration(seconds: 15);

final markerPollingActiveProvider = Provider<ValueNotifier<bool>>(
  (ref) => ValueNotifier(true),
);

Stream<List<MarkerData>> pollingMarkerStream(
  Ref ref, {
  required bool enabled,
  required Future<List<MarkerData>?> Function() fetch,
}) {
  final controller = BehaviorSubject<List<MarkerData>>();
  var latestStarted = 0;
  var latestApplied = 0;

  Future<void> fetchAndEmit() async {
    if (!enabled) {
      controller.add(const []);
      return;
    }

    final request = ++latestStarted;
    List<MarkerData>? markers;
    try {
      markers = await fetch();
    } catch (_) {
      markers = null;
    }
    if (controller.isClosed || request < latestApplied) return;

    if (markers != null) {
      latestApplied = request;
      controller.add(markers);
    } else if (!controller.hasValue) {
      controller.add(const []);
    }
  }

  final active = ref.read(markerPollingActiveProvider);

  void refreshIfActive() {
    if (active.value) unawaited(fetchAndEmit());
  }

  unawaited(fetchAndEmit());
  final timer = Timer.periodic(markerRefreshInterval, (_) => refreshIfActive());
  active.addListener(refreshIfActive);

  ref
    ..onDispose(timer.cancel)
    ..onDispose(() => active.removeListener(refreshIfActive))
    ..onDispose(controller.close);

  return controller.stream.distinct(_sameMarkers);
}

bool _sameMarkers(List<MarkerData> a, List<MarkerData> b) {
  return listEquals(a.map(_markerKey).toList(), b.map(_markerKey).toList());
}

(String, MarkerType, double, double, String) _markerKey(MarkerData m) =>
    (m.id, m.type, m.point.latitude, m.point.longitude, m.routePrefix);
