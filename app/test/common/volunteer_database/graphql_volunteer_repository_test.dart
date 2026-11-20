import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:app/common/volunteer_database/graphql_volunteer_repository.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';

/// Verifies the volunteer request submission GraphQL workflow.
void main() {
  test('loads owned requests with their lifecycle status', () async {
    final link = Link.function((request, [forward]) {
      return Stream.value(
        const Response(
          response: {},
          data: {
            '__typename': 'Query',
            'meineEhrenamtsbankEintraege': {
              '__typename': 'MeineEhrenamtsbankEintraegeCollectionSegment',
              'items': [
                {
                  '__typename': 'EhrenamtsbankEintrag',
                  'id': 'entry-id',
                  'typ': 'GESUCH',
                  'title': 'Hecken schneiden',
                  'description': 'Werkzeug ist vorhanden.',
                  'kategorieId': 'category-id',
                  'estimatedDurationMinutes': null,
                  'availability': null,
                  'imageKey': 'ehrenamtsbank/photo',
                  'tags': <String>[],
                  'createdAt': '2026-09-23T10:00:00Z',
                  'status': 'ASSIGNED',
                  'owner': {
                    '__typename': 'EhrenamtsbankProfil',
                    'id': 'owner-id',
                    'vorname': 'Sarah',
                    'nachname': 'Schmidt',
                    'phoneVerified': true,
                    'clearanceVerified': false,
                  },
                  'untereinheit': {
                    '__typename': 'Untereinheit',
                    'name': 'Hameln',
                  },
                },
              ],
              'pageInfo': {
                '__typename': 'CollectionSegmentInfo',
                'hasNextPage': false,
              },
              'totalCount': 1,
            },
          },
        ),
      );
    });
    final repository = GraphqlVolunteerRepository(
      objectStorage: ObjectStorageClient(
        backendUrl: 'https://backend.test',
        authHeaders: () => null,
      ),
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final page = await repository.getMyRequestsPage(skip: 0, take: 50);

    expect(page.totalCount, 1);
    expect(page.hasNextPage, isFalse);
    expect(page.items.single.status, VolunteerRequestStatus.assigned);
    expect(page.items.single.ownerId, 'owner-id');
    expect(
      page.items.single.image?.url,
      'https://backend.test/api/objects/ehrenamtsbank/photo',
    );
  });

  test('creates a request and submits the draft for review', () async {
    final requestedDocuments = <String>[];
    final link = Link.function((request, [forward]) {
      final document = printNode(request.operation.document);
      requestedDocuments.add(document);
      if (document.contains('CreateVolunteerRequest')) {
        return Stream.value(
          const Response(
            response: {},
            data: {
              '__typename': 'Mutation',
              'createEhrenamtsbankEintrag': {
                'ehrenamtsbankEintrag': {
                  '__typename': 'EhrenamtsbankEintrag',
                  'id': 'entry-id',
                  'status': 'DRAFT',
                },
                'errors': <Object>[],
                '__typename': 'CreateEhrenamtsbankEintragPayload',
              },
            },
          ),
        );
      }
      return Stream.value(
        const Response(
          response: {},
          data: {
            '__typename': 'Mutation',
            'updateEhrenamtsbankEintragStatus': {
              'ehrenamtsbankEintrag': {
                '__typename': 'EhrenamtsbankEintrag',
                'id': 'entry-id',
                'status': 'PENDING_REVIEW',
              },
              'errors': <Object>[],
              '__typename': 'UpdateEhrenamtsbankEintragStatusPayload',
            },
          },
        ),
      );
    });
    final repository = GraphqlVolunteerRepository(
      objectStorage: ObjectStorageClient(
        backendUrl: 'https://backend.test',
        authHeaders: () => null,
      ),
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final id = await repository.submitRequest(
      const VolunteerRequestSubmission(
        title: 'Hecken schneiden',
        description: 'Werkzeug ist vorhanden.',
        categoryId: 'category-id',
        municipalityId: 'municipality-id',
        urgency: Enum_EhrenamtsbankDringlichkeit.MITTEL,
        estimatedDurationMinutes: 90,
      ),
    );

    expect(id, 'entry-id');
    expect(requestedDocuments[0], contains('createEhrenamtsbankEintrag'));
    expect(requestedDocuments[1], contains('updateEhrenamtsbankEintragStatus'));
  });

  test('returns an active request without submitting it for review', () async {
    final requestedDocuments = <String>[];
    final link = Link.function((request, [forward]) {
      requestedDocuments.add(printNode(request.operation.document));
      return Stream.value(
        const Response(
          response: {},
          data: {
            '__typename': 'Mutation',
            'createEhrenamtsbankEintrag': {
              'ehrenamtsbankEintrag': {
                '__typename': 'EhrenamtsbankEintrag',
                'id': 'active-entry-id',
                'status': 'ACTIVE',
              },
              'errors': <Object>[],
              '__typename': 'CreateEhrenamtsbankEintragPayload',
            },
          },
        ),
      );
    });
    final repository = GraphqlVolunteerRepository(
      objectStorage: ObjectStorageClient(
        backendUrl: 'https://backend.test',
        authHeaders: () => null,
      ),
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final id = await repository.submitRequest(
      const VolunteerRequestSubmission(
        title: 'Hecken schneiden',
        description: 'Werkzeug ist vorhanden.',
        categoryId: 'category-id',
        municipalityId: 'municipality-id',
        urgency: Enum_EhrenamtsbankDringlichkeit.MITTEL,
        estimatedDurationMinutes: 90,
      ),
    );

    expect(id, 'active-entry-id');
    expect(requestedDocuments, hasLength(1));
    expect(requestedDocuments.single, contains('createEhrenamtsbankEintrag'));
  });
}
