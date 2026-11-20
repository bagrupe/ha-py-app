import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/poi_category_prefs.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart'
    show Fragment_Kommune;
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/karte/common/marker_providers/idee_marker_provider.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Liefert eine feste AppConfig, ohne die echte SharedPreferences-Kette zu
/// benötigen.
class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

/// Liefert einen festen POI-Filter (inkl. Ideen-Kategorie), ohne die echte
/// SharedPreferences-Kette zu benötigen.
class _FixedPoiCategoryFilterNotifier extends PoiCategoryFilterNotifier {
  @override
  PoiCategoryFilterState build() =>
      const PoiCategoryFilterState([ideenKategorieId]);
}

/// Returns a POI filter without the Ideen category, to test the
/// "category deselected" branch of `fetchAndEmit`.
class _WithoutIdeenPoiCategoryFilterNotifier extends PoiCategoryFilterNotifier {
  @override
  PoiCategoryFilterState build() => const PoiCategoryFilterState([]);
}

/// Antwortet auf jede Anfrage mit einer leeren IdeenKarte-Liste und ruft
/// dabei [onRequest] auf, damit Tests zählen können, wie oft tatsächlich neu
/// vom Netzwerk geladen wurde. In den Tests, die diesen Stub nutzen, ist
/// `kommuneProvider` separat überschrieben (siehe `buildContainer`), sodass
/// hier ausschließlich IdeenKarte-Anfragen ankommen - eine Unterscheidung
/// nach Operation ist daher nicht nötig.
Link _stubLink({void Function()? onRequest}) {
  return Link.function((request, [forward]) {
    onRequest?.call();
    return Stream.value(
      const Response(
        data: {
          '__typename': 'Query',
          'kommune': {
            '__typename': 'Kommune',
            'ideenAusfuehrungen': <dynamic>[],
          },
        },
        response: {},
      ),
    );
  });
}

IdeenAusfuehrungen _ideeMitAdresse({
  required String id,
  required Enum_AusfuehrungStatus status,
}) {
  return Query_IdeenKarte_kommune_ideenAusfuehrungen(
    id: id,
    userId: 'user-1',
    status: status,
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
  );
}

void main() {
  group('toMarkerData', () {
    test('maps a well-formed Idee to a marker', () {
      final ideen = [
        _ideeMitAdresse(
          id: 'idee-1',
          status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE,
        ),
      ];

      final markers = toMarkerData(ideen, 'https://cms/icon.svg');

      expect(markers, hasLength(1));
      expect(markers.single.id, 'idee-1');
      expect(markers.single.type, MarkerType.ideeOpen);
      expect(markers.single.point.latitude, 52.1);
      expect(markers.single.point.longitude, 9.35);
    });

    test('uses ideeCompleted marker type once abgeschlossen', () {
      final ideen = [
        _ideeMitAdresse(
          id: 'idee-1',
          status: Enum_AusfuehrungStatus.ABGESCHLOSSEN,
        ),
      ];

      final markers = toMarkerData(ideen, null);

      expect(markers.single.type, MarkerType.ideeCompleted);
    });

    test('skips ideas without an adresse slot instead of throwing', () {
      final ideeOhneAdresse = Query_IdeenKarte_kommune_ideenAusfuehrungen(
        id: 'idee-ohne-adresse',
        userId: 'user-1',
        status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER,
        slotValues: const [],
      );

      expect(() => toMarkerData([ideeOhneAdresse], null), returnsNormally);
      expect(toMarkerData([ideeOhneAdresse], null), isEmpty);
    });

    test('skips ideas whose adresse slot is not a PlainSlotValue instead of '
        'throwing', () {
      final ideeMitFalschemSlotTyp =
          Query_IdeenKarte_kommune_ideenAusfuehrungen(
            id: 'idee-falscher-slot-typ',
            userId: 'user-1',
            status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER,
            slotValues: [
              Fragment_SlotValue__EncryptedSlotValue(
                id: 'slot-adresse',
                slotName: 'adresse',
                encryptedValue: Fragment_EncryptedValue(
                  cipher: 'cipher',
                  nonce: 'nonce',
                  tag: 'tag',
                ),
              ),
            ],
          );

      expect(
        () => toMarkerData([ideeMitFalschemSlotTyp], null),
        returnsNormally,
      );
      expect(toMarkerData([ideeMitFalschemSlotTyp], null), isEmpty);
    });

    test('one malformed Idee does not drop markers for the others', () {
      final ideeOhneAdresse = Query_IdeenKarte_kommune_ideenAusfuehrungen(
        id: 'idee-ohne-adresse',
        userId: 'user-1',
        status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER,
        slotValues: const [],
      );
      final ideeMitAdresse = _ideeMitAdresse(
        id: 'idee-mit-adresse',
        status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER,
      );

      final markers = toMarkerData([ideeOhneAdresse, ideeMitAdresse], null);

      expect(markers, hasLength(1));
      expect(markers.single.id, 'idee-mit-adresse');
    });
  });

  group('ideeMarkerProvider lifecycle', () {
    ProviderContainer buildContainer(
      Link link, {
      PoiCategoryFilterNotifier Function() poiCategoryFilterNotifier =
          _FixedPoiCategoryFilterNotifier.new,
    }) {
      // queryRequestTimeout defaults to 5s and is implemented via
      // Stream.timeout(), which doesn't resolve reliably under fakeAsync -
      // disabled here since these tests don't need it.
      final client = GraphQLClient(
        link: link,
        cache: GraphQLCache(),
        queryRequestTimeout: null,
      );
      return ProviderContainer(
        overrides: [
          graphqlClientProvider.overrideWithValue(client),
          appConfigProvider.overrideWith(_FixedAppConfigNotifier.new),
          poiCategoryFilterProvider.overrideWith(poiCategoryFilterNotifier),
          // Never resolves - keeps kommuneProvider (which ideeMarkerProvider
          // also `ref.watch`es, only for the marker icon URL) from settling
          // and triggering an unrelated extra rebuild that would otherwise
          // interfere with measuring the periodic-refresh behavior below.
          kommuneProvider.overrideWithBuild(
            (ref, notifier) => Completer<Fragment_Kommune>().future,
          ),
        ],
      );
    }

    test('refreshes on the same Stream instance instead of rebuilding it every '
        '15s (rebuilding would hand root_marker_provider a brand new Stream '
        'each time, making the markers blink)', () {
      fakeAsync((async) {
        var requestCount = 0;
        final container = buildContainer(
          _stubLink(onRequest: () => requestCount++),
        );
        addTearDown(container.dispose);

        // Simuliert die Karte, die den Marker-Provider dauerhaft
        // beobachtet.
        final sub = container.listen(ideeMarkerProvider, (_, __) {});
        addTearDown(sub.close);

        final stream = container.read(ideeMarkerProvider);
        var emissionCount = 0;
        final dataSub = stream.listen((_) => emissionCount++);
        addTearDown(dataSub.cancel);

        async.elapse(Duration.zero);
        expect(requestCount, 1, reason: 'initial fetch on first build');
        expect(emissionCount, 1);

        async.elapse(const Duration(seconds: 15));
        expect(
          requestCount,
          2,
          reason: 'the periodic timer must trigger a fresh network fetch',
        );
        expect(
          emissionCount,
          1,
          reason: 'an unchanged result must not be emitted again',
        );

        expect(
          container.read(ideeMarkerProvider),
          same(stream),
          reason:
              'the Stream instance handed to root_marker_provider.dart '
              'must stay the same across refreshes',
        );
      });
    });

    test('does not drop the initial empty-list emission when the Ideenmelder '
        'category is deselected', () {
      fakeAsync((async) {
        final container = buildContainer(
          _stubLink(),
          poiCategoryFilterNotifier: _WithoutIdeenPoiCategoryFilterNotifier.new,
        );
        addTearDown(container.dispose);

        final sub = container.listen(ideeMarkerProvider, (_, __) {});
        addTearDown(sub.close);

        final stream = container.read(ideeMarkerProvider);
        List<MarkerData>? received;
        final dataSub = stream.listen((data) => received = data);
        addTearDown(dataSub.cancel);

        async.elapse(Duration.zero);

        expect(
          received,
          isNotNull,
          reason:
              'a subscriber attaching after the provider already built '
              'must still receive the emitted empty list',
        );
        expect(received, isEmpty);
      });
    });

    test('stops refreshing and releases the timer once disposed', () {
      fakeAsync((async) {
        var requestCount = 0;
        final container = buildContainer(
          _stubLink(onRequest: () => requestCount++),
        );

        final sub = container.listen(ideeMarkerProvider, (_, __) {});
        container.read(ideeMarkerProvider);
        async.flushMicrotasks();
        expect(requestCount, 1);

        sub.close();
        container.dispose();

        async.elapse(const Duration(seconds: 30));
        expect(
          requestCount,
          1,
          reason: 'no further fetches once the provider is disposed',
        );
      });
    });
  });
}
