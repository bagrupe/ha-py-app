import 'package:app/common/volunteer_database/graphql_volunteer_interest_repository.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Verifies the volunteer interest GraphQL workflow.
void main() {
  test('submits entry id and trimmed optional message', () async {
    Map<String, dynamic>? submittedInput;
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function((request, [forward]) {
          submittedInput = request.variables['input'] as Map<String, dynamic>;
          return Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Mutation',
                'createEhrenamtsbankAnfrage': {
                  '__typename': 'CreateEhrenamtsbankAnfragePayload',
                  'ehrenamtsbankAnfrage': {
                    '__typename': 'EhrenamtsbankAnfrage',
                    'id': 'interest-id',
                    'status': 'OFFEN',
                    'nachricht': 'Dienstag passt.',
                    'createdAt': '2026-08-20T10:00:00.000Z',
                  },
                  'errors': <Object>[],
                },
              },
            ),
          );
        }),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final interest = await repository.createInterest(
      entryId: 'entry-id',
      message: '  Dienstag passt.  ',
    );

    expect(submittedInput?['eintragId'], 'entry-id');
    expect(submittedInput?['nachricht'], 'Dienstag passt.');
    expect(interest.status, Enum_EhrenamtsbankAnfrageStatus.OFFEN);
    expect(interest.isRequested, isTrue);
    expect(interest.message, 'Dienstag passt.');
  });

  test('maps a self-interest backend error', () async {
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function(
          (request, [forward]) => Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Mutation',
                'createEhrenamtsbankAnfrage': {
                  '__typename': 'CreateEhrenamtsbankAnfragePayload',
                  'ehrenamtsbankAnfrage': null,
                  'errors': [
                    {
                      '__typename': 'AnfrageForItselfError',
                      'message': 'Not allowed',
                    },
                  ],
                },
              },
            ),
          ),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    expect(
      () => repository.createInterest(entryId: 'entry-id', message: null),
      throwsA(
        isA<VolunteerInterestSubmissionException>().having(
          (error) => error.messageKey,
          'messageKey',
          'application.volunteer_database.details.interest.errors.own_entry',
        ),
      ),
    );
  });

  test('loads the current interest for an entry', () async {
    String? requestedEntryId;
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function((request, [forward]) {
          requestedEntryId = request.variables['entryId'] as String?;
          return Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Query',
                'meineEhrenamtsbankAnfrageFuerEintrag': {
                  '__typename': 'EhrenamtsbankAnfrage',
                  'id': 'interest-id',
                  'status': 'OFFEN',
                  'nachricht': 'Ich kann helfen.',
                  'createdAt': '2026-08-20T10:00:00.000Z',
                },
              },
            ),
          );
        }),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final interest = await repository.getInterestForEntry('entry-id');

    expect(requestedEntryId, 'entry-id');
    expect(interest?.id, 'interest-id');
    expect(interest?.isRequested, isTrue);
    expect(interest?.message, 'Ich kann helfen.');
  });

  test('returns null when no interest exists for an entry', () async {
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function(
          (request, [forward]) => Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Query',
                'meineEhrenamtsbankAnfrageFuerEintrag': null,
              },
            ),
          ),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final interest = await repository.getInterestForEntry('entry-id');

    expect(interest, isNull);
  });

  test('confirms an accepted agreement with the agreed status', () async {
    Map<String, dynamic>? submittedInput;
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function((request, [forward]) {
          submittedInput = request.variables['input'] as Map<String, dynamic>;
          return Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Mutation',
                'updateEhrenamtsbankAnfrageStatus': {
                  '__typename': 'UpdateEhrenamtsbankAnfrageStatusPayload',
                  'ehrenamtsbankAnfrage': {
                    '__typename': 'EhrenamtsbankAnfrage',
                    'id': 'interest-id',
                    'status': 'VEREINBART',
                    'vereinbartAt': '2026-09-01T10:00:00.000Z',
                  },
                  'errors': <Object>[],
                },
              },
            ),
          );
        }),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    await repository.updateStatus(
      interestId: 'interest-id',
      status: Enum_EhrenamtsbankAnfrageStatus.VEREINBART,
    );

    expect(submittedInput?['anfrageId'], 'interest-id');
    expect(submittedInput?['status'], 'VEREINBART');
  });

  test('submits a completion proposal with duration, date and note', () async {
    Map<String, dynamic>? submittedInput;
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function((request, [forward]) {
          submittedInput = request.variables['input'] as Map<String, dynamic>;
          return Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Mutation',
                'proposeEhrenamtsbankAbschluss': {
                  '__typename': 'ProposeEhrenamtsbankAbschlussPayload',
                  'ehrenamtsbankAnfrage': {
                    '__typename': 'EhrenamtsbankAnfrage',
                    'id': 'interest-id',
                    'status': 'VEREINBART',
                    'proposedMinutes': 135,
                    'proposedDate': '2026-08-31',
                    'proposedNote': 'Alles erledigt.',
                    'proposedById': 'user-id',
                  },
                  'errors': <Object>[],
                },
              },
            ),
          );
        }),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    await repository.proposeCompletion(
      interestId: 'interest-id',
      minutes: 135,
      performedOn: DateTime(2026, 8, 31),
      note: 'Alles erledigt.',
    );

    expect(submittedInput?['anfrageId'], 'interest-id');
    expect(submittedInput?['minutes'], 135);
    expect(submittedInput?['date'], '2026-08-31');
    expect(submittedInput?['note'], 'Alles erledigt.');
  });

  test('confirms the counterparty proposal and requires a booking', () async {
    Map<String, dynamic>? submittedInput;
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function((request, [forward]) {
          submittedInput = request.variables['input'] as Map<String, dynamic>;
          return Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Mutation',
                'confirmEhrenamtsbankAbschluss': {
                  '__typename': 'ConfirmEhrenamtsbankAbschlussPayload',
                  'ehrenamtsbankAnfrage': {
                    '__typename': 'EhrenamtsbankAnfrage',
                    'id': 'interest-id',
                    'status': 'ERLEDIGT',
                    'proposedMinutes': 135,
                    'proposedDate': '2026-08-31',
                    'proposedNote': 'Alles erledigt.',
                    'proposedById': 'other-user-id',
                    'transaktion': {
                      '__typename': 'EhrenamtsbankTransaktion',
                      'id': 'transaction-id',
                      'minutes': 135,
                      'performedOn': '2026-08-31',
                      'note': 'Alles erledigt.',
                      'status': 'CONFIRMED',
                    },
                  },
                  'errors': <Object>[],
                },
              },
            ),
          );
        }),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    await repository.confirmCompletion(interestId: 'interest-id');

    expect(submittedInput?['anfrageId'], 'interest-id');
  });

  test('loads and maps received and sent interests', () async {
    final repository = GraphqlVolunteerInterestRepository(
      GraphQLClient(
        link: Link.function(
          (request, [forward]) => Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Query',
                'meineEhrenamtsbankAnfragen': {
                  '__typename': 'MeineEhrenamtsbankAnfragenCollectionSegment',
                  'items': [
                    {
                      '__typename': 'EhrenamtsbankAnfrage',
                      'id': 'interest-id',
                      'eintragId': 'entry-id',
                      'nachricht': 'Ich kann helfen.',
                      'status': 'ERLEDIGT',
                      'typ': 'EMPFANGENE_ANFRAGE',
                      'createdAt': '2026-08-20T10:00:00.000Z',
                      'updatedAt': '2026-08-20T10:00:00.000Z',
                      'vereinbartAt': '2026-08-30T10:00:00.000Z',
                      'proposedMinutes': 135,
                      'proposedDate': '2026-08-31',
                      'proposedNote': 'Alles erledigt.',
                      'proposedById': 'person-id',
                      'interessent': {
                        '__typename': 'EhrenamtsbankProfil',
                        'id': 'person-id',
                        'vorname': 'Lea',
                        'nachname': 'Musterfrau',
                        'phone': '+49 151 12345678',
                      },
                      'eintrag': {
                        '__typename': 'EhrenamtsbankEintrag',
                        'id': 'entry-id',
                        'title': 'Einkaufshilfe',
                        'description': 'Einkauf gesucht',
                        'estimatedDurationMinutes': 375,
                        'owner': {
                          '__typename': 'EhrenamtsbankProfil',
                          'id': 'owner-id',
                          'vorname': 'Sarah',
                          'nachname': 'Schmidt',
                          'phone': '+49 152 87654321',
                        },
                      },
                      'transaktion': {
                        '__typename': 'EhrenamtsbankTransaktion',
                        'id': 'transaction-id',
                        'minutes': 135,
                        'performedOn': '2026-08-31',
                        'note': 'Alles erledigt.',
                        'status': 'CONFIRMED',
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
          ),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final interests = await repository.getInterests();

    expect(interests, hasLength(1));
    expect(interests.single.personName, 'Lea M.');
    expect(interests.single.entryTitle, 'Einkaufshilfe');
    expect(interests.single.plannedDurationMinutes, 375);
    expect(interests.single.contactPhone, '+49 151 12345678');
    expect(interests.single.isCompleted, isTrue);
    expect(interests.single.completionProposal?.minutes, 135);
    expect(interests.single.completionProposal?.proposedById, 'person-id');
    expect(interests.single.completionBooking?.minutes, 135);
  });
}
