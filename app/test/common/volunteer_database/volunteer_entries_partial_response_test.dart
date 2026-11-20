import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:app/common/volunteer_database/graphql_volunteer_repository.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Verifies partial entry responses without hiding essential query failures.
void main() {
  for (final field in ['owner', 'untereinheit', 'title']) {
    test('handles a partial response with an error on $field', () async {
      final repository = _repository([
        'ehrenamtsbankEintraege',
        'items',
        0,
        field,
      ]);
      final result = repository.getRequestsPage(
        helpType: HelpType.offerHelp,
        categoryKey: null,
        skip: 0,
        take: 50,
      );
      if (field == 'title') {
        await expectLater(result, throwsA(isA<OperationException>()));
      } else {
        final page = await result;
        expect(page.items.single.id, 'entry-id');
        expect(page.items.single.title, 'Test request');
        expect(page.items.single.ownerId, isEmpty);
        expect(page.hasNextPage, isFalse);
      }
    });
  }

  test('preserves errors on the list itself', () async {
    final repository = _repository(['ehrenamtsbankEintraege']);
    await expectLater(
      repository.getRequestsPage(
        helpType: HelpType.offerHelp,
        categoryKey: null,
        skip: 0,
        take: 50,
      ),
      throwsA(isA<OperationException>()),
    );
  });
}

/// Creates an entry response containing a GraphQL error at the given path.
GraphqlVolunteerRepository _repository(List<Object> errorPath) {
  final link = Link.function((request, [forward]) {
    return Stream.value(
      Response(
        response: const {},
        errors: [GraphQLError(message: 'Unknown Error', path: errorPath)],
        data: const {
          '__typename': 'Query',
          'ehrenamtsbankEintraege': {
            '__typename': 'EhrenamtsbankEintraegeCollectionSegment',
            'items': [
              {
                '__typename': 'EhrenamtsbankEintrag',
                'id': 'entry-id',
                'typ': 'GESUCH',
                'title': 'Test request',
                'description': 'Test description',
                'kategorieId': 'category-id',
                'estimatedDurationMinutes': null,
                'availability': null,
                'imageKey': null,
                'tags': <String>[],
                'createdAt': '2026-09-23T10:00:00Z',
                'status': 'ACTIVE',
                'owner': null,
                'untereinheit': null,
              },
            ],
            'pageInfo': {
              '__typename': 'CollectionSegmentInfo',
              'hasNextPage': false,
            },
          },
        },
      ),
    );
  });
  return GraphqlVolunteerRepository(
    objectStorage: ObjectStorageClient(
      backendUrl: 'https://backend.test',
      authHeaders: () => null,
    ),
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}
