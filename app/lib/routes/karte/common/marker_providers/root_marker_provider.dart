import 'package:app/common/extensions/marker.dart';
import 'package:app/common/throttled_notifier.dart';
import 'package:app/components/map/map_state/map_state.dart';
import 'package:app/routes/karte/common/marker_providers/idee_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/maengel_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/poi_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/sensor_marker_provider.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

/// Provider, der einen Stream von sortierten Markern liefert.
/// Sortiert die Marker basierend auf der aktuellen Kartenrotation.
///
/// `autoDispose` so leaving the map also stops `ideeMarkerProvider`'s
/// refetch timer. Uses `ref.listen` rather than `ref.watch` on
/// `_throttledRotationProvider`, so rotation changes don't rebuild this
/// provider and resubscribe to `_markerProvider`'s shared stream.
final sortedMarkerProvider = Provider.autoDispose<Stream<List<MarkerData>>>((
  ref,
) {
  final markers = ref.watch(_markerProvider);

  final rotationSubject = BehaviorSubject<double>.seeded(
    ref.read(_throttledRotationProvider),
  );
  final subscription = ref.listen(_throttledRotationProvider, (_, next) {
    rotationSubject.add(next);
  });
  ref
    ..onDispose(subscription.close)
    ..onDispose(rotationSubject.close);

  return Rx.combineLatest2(
    markers,
    rotationSubject.stream,
    (List<MarkerData> list, double rotation) => list..sortByZIndex(rotation),
  );
}, dependencies: [_throttledRotationProvider]);

/// Provider, der einen kombinierten Stream aller Markerquellen liefert.
/// Vereint Marker von Mängeln, POIs und Sensoren in einer Liste.
final _markerProvider = Provider.autoDispose<Stream<List<MarkerData>>>((ref) {
  final poiStream = ref
      .watch(poiMarkerProvider)
      .map((payload) => payload.markers);

  return CombineLatestStream([
    ref.watch(maengelMarkerProvider),
    ref.watch(ideeMarkerProvider),
    poiStream,
    ref.watch(sensorMarkerProvider),
  ], (values) => values.expand((x) => x).toList()).shareValue();
});

/// Provider, der die Kartenrotation mit einer Drosselung bereitstellt.
/// Verhindert zu häufige Updates durch zeitliche Begrenzung.
final _throttledRotationProvider =
    NotifierProvider<ThrottledNotifier<double>, double>(
      () => ThrottledNotifier(
        mapStateProvider.select((map) => map.rotation),
        const Duration(milliseconds: 500),
      ),
      dependencies: [mapStateProvider],
    );
