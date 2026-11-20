import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/common/marker_providers/maengel_marker_provider.dart';
import 'package:app/routes/karte/common/marker_providers/polling_marker_stream.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

class _MaengelPoiCategoryFilterNotifier extends PoiCategoryFilterNotifier {
  @override
  PoiCategoryFilterState build() =>
      const PoiCategoryFilterState([maengelKategorieId]);
}

class _NoPoiCategoryFilterNotifier extends PoiCategoryFilterNotifier {
  @override
  PoiCategoryFilterState build() => const PoiCategoryFilterState([]);
}

Map<String, dynamic> _mangelJson(String id) => {
  '__typename': 'Ausfuehrung',
  'id': id,
  'userId': 'user-1',
  'status': 'BEARBEITUNG_DURCH_KOMMUNE',
  'slotValues': [
    {
      '__typename': 'PlainSlotValue',
      'id': 'slot-$id',
      'slotName': 'adresse',
      'istFreigegeben': true,
      'plainValue': {
        'addressString': 'Musterstraße 1, Hameln',
        'coordinates': [9.35, 52.1],
      },
    },
  ],
};

Map<String, dynamic> _responseData(List<String> ids) => {
  '__typename': 'Query',
  'kommune': {
    '__typename': 'Kommune',
    'maengelAusfuehrungen': ids.map(_mangelJson).toList(),
  },
};

MaengelAusfuehrungen _mangel({
  required String id,
  required List<Fragment_SlotValue> slotValues,
  Enum_AusfuehrungStatus status =
      Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE,
}) {
  return Query_MaengelKarte_kommune_maengelAusfuehrungen(
    id: id,
    userId: 'user-1',
    status: status,
    slotValues: slotValues,
  );
}

void main() {
  group('toMaengelMarkerData', () {
    test('maps a Mangel with a visible adresse to a marker', () {
      final markers = toMaengelMarkerData([
        _mangel(
          id: 'mangel-1',
          slotValues: [
            Fragment_SlotValue__PlainSlotValue(
              id: 'slot-adresse',
              slotName: 'adresse',
              plainValue: {
                'addressString': 'Musterstraße 1, Hameln',
                'coordinates': [9.35, 52.1],
              },
            ),
          ],
        ),
      ]);

      expect(markers.single.id, 'mangel-1');
      expect(markers.single.type, MarkerType.mangelOpen);
      expect(markers.single.point.latitude, 52.1);
    });

    test('skips a Mangel whose adresse value is not a location object', () {
      final markers = toMaengelMarkerData([
        _mangel(
          id: 'mangel-kaputt',
          slotValues: [
            Fragment_SlotValue__PlainSlotValue(
              id: 'slot-adresse',
              slotName: 'adresse',
              plainValue: 'Musterstraße 1',
            ),
          ],
        ),
      ]);

      expect(markers, isEmpty);
    });

    test('skips a Mangel whose adresse slot is not visible', () {
      final markers = toMaengelMarkerData([
        _mangel(id: 'mangel-ohne-adresse', slotValues: const []),
        _mangel(
          id: 'mangel-2',
          slotValues: [
            Fragment_SlotValue__PlainSlotValue(
              id: 'slot-adresse',
              slotName: 'adresse',
              plainValue: {
                'addressString': 'Musterstraße 2, Hameln',
                'coordinates': [9.36, 52.11],
              },
            ),
          ],
        ),
      ]);

      expect(markers.map((m) => m.id), ['mangel-2']);
    });
  });

  group('maengelMarkerProvider lifecycle', () {
    late Stream<Response> Function() respond;
    var requestCount = 0;

    ProviderContainer buildContainer({
      PoiCategoryFilterNotifier Function() filter =
          _MaengelPoiCategoryFilterNotifier.new,
    }) {
      final client = GraphQLClient(
        link: Link.function((request, [forward]) {
          requestCount++;
          return respond();
        }),
        cache: GraphQLCache(possibleTypes: possibleTypesMap),
        queryRequestTimeout: null,
      );
      return ProviderContainer(
        overrides: [
          graphqlClientProvider.overrideWithValue(client),
          appConfigProvider.overrideWith(_FixedAppConfigNotifier.new),
          poiCategoryFilterProvider.overrideWith(filter),
        ],
      );
    }

    Stream<Response> data(List<String> ids) =>
        Stream.value(Response(data: _responseData(ids), response: const {}));

    void run(
      void Function(
        FakeAsync async,
        List<List<String>> emitted,
        ProviderContainer container,
      )
      body, {
      PoiCategoryFilterNotifier Function()? filter,
    }) {
      fakeAsync((async) {
        requestCount = 0;
        final container = buildContainer(
          filter: filter ?? _MaengelPoiCategoryFilterNotifier.new,
        );
        addTearDown(container.dispose);
        container.listen(maengelMarkerProvider, (_, __) {});
        final emitted = <List<String>>[];
        final sub = container
            .read(maengelMarkerProvider)
            .listen((m) => emitted.add(m.map((e) => e.id).toList()));
        addTearDown(sub.cancel);
        body(async, emitted, container);
      });
    }

    test('emits the markers returned by the backend', () {
      respond = () => data(['a', 'b']);
      run((async, emitted, _) {
        async.elapse(Duration.zero);
        expect(emitted.single, ['a', 'b']);
      });
    });

    test('removes a deleted Mangel on the next refresh', () {
      respond = () => data(['a', 'b']);
      run((async, emitted, _) {
        async.elapse(Duration.zero);
        respond = () => data(['a']);
        async.elapse(markerRefreshInterval);
        expect(emitted.last, ['a']);
      });
    });

    test('adds a new Mangel on the next refresh', () {
      respond = () => data(['a']);
      run((async, emitted, _) {
        async.elapse(Duration.zero);
        respond = () => data(['a', 'b']);
        async.elapse(markerRefreshInterval);
        expect(emitted.last, ['a', 'b']);
      });
    });

    test('keeps the markers when a refresh fails with a network error', () {
      respond = () => data(['a']);
      run((async, emitted, _) {
        async.elapse(Duration.zero);
        respond = () =>
            Stream.error(ServerException(originalException: Exception()));
        async.elapse(markerRefreshInterval);
        expect(emitted, hasLength(1));
      });
    });

    test('shows no markers and sends no request while the filter is off', () {
      respond = () => data(['a']);
      run((async, emitted, _) {
        async.elapse(markerRefreshInterval * 2);
        expect(emitted.single, isEmpty);
        expect(requestCount, 0);
      }, filter: _NoPoiCategoryFilterNotifier.new);
    });

    test('pauses while the map tab is inactive and refreshes on return', () {
      respond = () => data(['a']);
      run((async, emitted, container) {
        async.elapse(Duration.zero);
        expect(requestCount, 1);

        container.read(markerPollingActiveProvider).value = false;
        async.elapse(markerRefreshInterval * 3);
        expect(requestCount, 1);

        container.read(markerPollingActiveProvider).value = true;
        async.elapse(Duration.zero);
        expect(requestCount, 2);
      });
    });

    test('stops refreshing once disposed', () {
      respond = () => data(['a']);
      fakeAsync((async) {
        requestCount = 0;
        final container = buildContainer();
        final sub = container.listen(maengelMarkerProvider, (_, __) {});
        async.flushMicrotasks();
        expect(requestCount, 1);

        sub.close();
        container.dispose();
        async.elapse(markerRefreshInterval * 3);
        expect(requestCount, 1);
      });
    });
  });
}
