import 'package:app/graphql/graphql_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final _termineQuery = gql(r'''
  query Termine($von: String, $bis: String) {
    veranstaltungsTermine(von: $von, bis: $bis) {
      __typename
      docs {
        __typename
        id
        dates {
          __typename
          start
        }
      }
    }
  }
''');

Request _request(String von, String bis) => Request(
  operation: Operation(document: _termineQuery),
  variables: {'von': von, 'bis': bis},
);

void _writeTermine(Request request, String id, List<List<String>> dateStarts) {
  cache.writeQuery(
    request,
    data: {
      '__typename': 'Query',
      'veranstaltungsTermine': {
        '__typename': 'VeranstaltungsTermineResult',
        'docs': [
          for (final starts in dateStarts)
            {
              '__typename': 'VeranstaltungsTermin',
              'id': id,
              'dates': [
                for (final start in starts)
                  {'__typename': 'VeranstaltungsTerminDate', 'start': start},
              ],
            },
        ],
      },
    },
  );
}

List<List<String>> _readDateStarts(Request request) {
  final docs =
      (cache.readQuery(request)!['veranstaltungsTermine'] as Map)['docs']
          as List;
  return [
    for (final doc in docs.cast<Map<String, dynamic>>())
      [
        for (final date in (doc['dates'] as List).cast<Map<String, dynamic>>())
          date['start'] as String,
      ],
  ];
}

void main() {
  test('keeps rows of one Veranstaltung with a shared id distinct', () {
    final request = _request('2026-10-01', '2026-10-31');
    _writeTermine(request, 'veranstaltung-1', [
      ['2026-10-25'],
      ['2026-10-26'],
      ['2026-10-27'],
    ]);

    expect(_readDateStarts(request), [
      ['2026-10-25'],
      ['2026-10-26'],
      ['2026-10-27'],
    ]);
  });

  test('a narrower query does not overwrite the same row of a wider one', () {
    final wide = _request('2026-11-01', '2026-11-30');
    final narrow = _request('2026-11-05', '2026-11-05');
    const morning = '2026-11-05T09:00';
    const evening = '2026-11-05T18:00';
    _writeTermine(wide, 'veranstaltung-2', [
      [morning, evening],
    ]);
    _writeTermine(narrow, 'veranstaltung-2', [
      [morning],
    ]);

    expect(_readDateStarts(wide), [
      [morning, evening],
    ]);
  });
}
