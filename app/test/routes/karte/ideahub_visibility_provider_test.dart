import 'dart:async';

import 'package:app/common/auth/profile_gemeinde_provider.dart';
import 'package:app/routes/karte/ideahub_visibility_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  test(
    'updates visibility when the position crosses the Hameln geofence',
    () async {
      final positions = StreamController<Position>();
      final container = ProviderContainer(
        overrides: [
          profileGemeindeProvider.overrideWithValue(null),
          ideahubPositionProvider.overrideWith((_) => positions.stream),
        ],
      );
      final visibilities = <bool>[];
      final updatesReceived = Completer<void>();
      final subscription = container.listen(ideahubVisibilityProvider, (
        _,
        next,
      ) {
        if (next case AsyncData(:final value)) {
          visibilities.add(value);
          if (visibilities.length == 3) updatesReceived.complete();
        }
      });
      addTearDown(subscription.close);
      addTearDown(container.dispose);
      addTearDown(positions.close);

      final outsideHameln = Position(
        longitude: 9.732,
        latitude: 52.375,
        timestamp: DateTime(2026),
        accuracy: 10,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      final insideHameln = Position(
        longitude: 9.3571,
        latitude: 52.1037,
        timestamp: DateTime(2026),
        accuracy: 10,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      positions
        ..add(outsideHameln)
        ..add(insideHameln)
        ..add(outsideHameln);

      await updatesReceived.future.timeout(const Duration(seconds: 1));

      expect(visibilities, [false, true, false]);
    },
  );
}
