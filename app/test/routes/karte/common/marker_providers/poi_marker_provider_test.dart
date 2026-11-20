import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:app/routes/karte/common/marker_providers/poi_marker_provider.dart';
import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter_test/flutter_test.dart';

Query_Pois_pois_docs _poi({required String id, required String categoryId}) {
  return Query_Pois_pois_docs(
    id: id,
    position: const [52.1, 9.35],
    category: Query_Pois_pois_docs_category(id: categoryId),
  );
}

Query_Pois _parsedData(List<Query_Pois_pois_docs> docs) {
  return Query_Pois(pois: Query_Pois_pois(docs: docs));
}

void main() {
  group('poiMarkerPayloadFromResult', () {
    test('empty-cache offline → isOfflineEmpty true and no markers', () {
      final payload = poiMarkerPayloadFromResult(
        hasException: true,
        parsedData: null,
        selectedPoiCategories: const ['cat-1'],
      );

      expect(payload.isOfflineEmpty, isTrue);
      expect(payload.markers, isEmpty);
    });

    test('empty-cache offline is detected before category filter '
        '(selected categories empty must not mask the failure)', () {
      final payload = poiMarkerPayloadFromResult(
        hasException: true,
        parsedData: null,
        selectedPoiCategories: const [],
      );

      expect(payload.isOfflineEmpty, isTrue);
      expect(payload.markers, isEmpty);
    });

    test('exception with cached data → markers usable, not offline-empty', () {
      final payload = poiMarkerPayloadFromResult(
        hasException: true,
        parsedData: _parsedData([_poi(id: 'poi-1', categoryId: 'cat-1')]),
        selectedPoiCategories: const ['cat-1'],
      );

      expect(payload.isOfflineEmpty, isFalse);
      expect(payload.markers, hasLength(1));
      expect(payload.markers.single.id, 'poi-1');
      expect(payload.markers.single.type, MarkerType.poi);
    });

    test(
      'no exception + empty category selection → empty markers, not error',
      () {
        final payload = poiMarkerPayloadFromResult(
          hasException: false,
          parsedData: _parsedData([_poi(id: 'poi-1', categoryId: 'cat-1')]),
          selectedPoiCategories: const [],
        );

        expect(payload.isOfflineEmpty, isFalse);
        expect(payload.markers, isEmpty);
      },
    );

    test('filters markers by selected POI categories', () {
      final payload = poiMarkerPayloadFromResult(
        hasException: false,
        parsedData: _parsedData([
          _poi(id: 'poi-1', categoryId: 'cat-1'),
          _poi(id: 'poi-2', categoryId: 'cat-2'),
        ]),
        selectedPoiCategories: const ['cat-2'],
      );

      expect(payload.isOfflineEmpty, isFalse);
      expect(payload.markers, hasLength(1));
      expect(payload.markers.single.id, 'poi-2');
    });
  });
}
