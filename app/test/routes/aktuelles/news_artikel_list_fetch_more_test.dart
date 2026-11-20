import 'package:app/routes/aktuelles/news_artikel_list_fetch_more.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldFetchNewsArtikelListNextPage', () {
    test('returns false while loading', () {
      expect(
        shouldFetchNewsArtikelListNextPage(
          isLoading: true,
          isNearBottom: true,
          hasNextPage: true,
        ),
        false,
      );
    });

    test('returns false when not near bottom', () {
      expect(
        shouldFetchNewsArtikelListNextPage(
          isLoading: false,
          isNearBottom: false,
          hasNextPage: true,
        ),
        false,
      );
    });

    test('returns false when hasNextPage is explicitly false', () {
      expect(
        shouldFetchNewsArtikelListNextPage(
          isLoading: false,
          isNearBottom: true,
          hasNextPage: false,
        ),
        false,
      );
    });

    test('returns true when near bottom, not loading, has more or unknown', () {
      expect(
        shouldFetchNewsArtikelListNextPage(
          isLoading: false,
          isNearBottom: true,
          hasNextPage: true,
        ),
        true,
      );
      expect(
        shouldFetchNewsArtikelListNextPage(
          isLoading: false,
          isNearBottom: true,
          hasNextPage: null,
        ),
        true,
      );
    });
  });

  group('mergeNewsArtikelListFetchMoreData', () {
    Map<String, dynamic> listPayload({
      required int page,
      required List<String> ids,
      bool? hasNextPage,
    }) {
      return {
        'newsArtikelList': {
          'page': page,
          'docs': ids.map((id) => <String, dynamic>{'id': id}).toList(),
          if (hasNextPage != null) 'hasNextPage': hasNextPage,
        },
      };
    }

    test('appends docs when page advances and ids are new', () {
      final previous = listPayload(page: 1, ids: ['a', 'b']);
      final more = listPayload(page: 2, ids: ['c'], hasNextPage: false);

      final out = mergeNewsArtikelListFetchMoreData(previous, more);

      expect(out, same(more));
      final docs = (more['newsArtikelList'] as Map)['docs'] as List<dynamic>;
      expect(docs.map((e) => (e as Map)['id']).toList(), ['a', 'b', 'c']);
      expect((more['newsArtikelList'] as Map)['hasNextPage'], false);
    });

    test('returns previous when more page is not ahead', () {
      final previous = listPayload(page: 2, ids: ['a']);
      final more = listPayload(page: 2, ids: ['b']);

      final out = mergeNewsArtikelListFetchMoreData(previous, more);

      expect(out, same(previous));
    });

    test('returns previous when more docs are empty', () {
      final previous = listPayload(page: 1, ids: ['a']);
      final more = listPayload(page: 2, ids: []);

      final out = mergeNewsArtikelListFetchMoreData(previous, more);

      expect(out, same(previous));
    });

    test('returns previous when all more ids already exist (wrapped page)', () {
      final previous = listPayload(page: 1, ids: ['a', 'b']);
      final more = listPayload(page: 2, ids: ['a', 'b']);

      final out = mergeNewsArtikelListFetchMoreData(previous, more);

      expect(out, same(previous));
    });

    test('drops overlapping ids and sets hasNextPage false', () {
      final previous = listPayload(page: 1, ids: ['a']);
      final more = listPayload(page: 2, ids: ['a', 'c'], hasNextPage: true);

      final out = mergeNewsArtikelListFetchMoreData(previous, more);

      expect(out, same(more));
      final list = more['newsArtikelList'] as Map;
      expect((list['docs'] as List).map((e) => (e as Map)['id']).toList(), [
        'a',
        'c',
      ]);
      expect(list['hasNextPage'], false);
    });

    test('returns fetchMore when previous list branch is missing', () {
      final more = listPayload(page: 1, ids: ['x']);

      final out = mergeNewsArtikelListFetchMoreData(null, more);

      expect(out, same(more));
    });

    test('returns previous when fetchMore list branch is missing', () {
      final previous = listPayload(page: 1, ids: ['a']);

      final out = mergeNewsArtikelListFetchMoreData(
        previous,
        <String, dynamic>{},
      );

      expect(out, same(previous));
    });
  });
}
