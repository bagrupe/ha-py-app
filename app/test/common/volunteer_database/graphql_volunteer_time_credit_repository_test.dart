import 'package:app/common/volunteer_database/graphql_volunteer_time_credit_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Verifies mapping of backend time-credit values.
void main() {
  test('loads the authenticated volunteer time credit', () async {
    final repository = GraphqlVolunteerTimeCreditRepository(
      GraphQLClient(
        link: Link.function(
          (request, [forward]) => Stream.value(
            const Response(
              response: {},
              data: {
                '__typename': 'Query',
                'meinEhrenamtsbankZeitkonto': {
                  '__typename': 'EhrenamtsbankZeitkonto',
                  'startCreditMinutes': 480,
                  'creditMinutes': 120,
                  'debitMinutes': 30,
                  'balanceMinutes': 570,
                },
              },
            ),
          ),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );

    final timeCredit = await repository.getTimeCredit();

    expect(timeCredit.baseCredit, const Duration(hours: 8));
    expect(timeCredit.helpProvided, const Duration(hours: 2));
    expect(timeCredit.helpReceived, const Duration(minutes: 30));
    expect(timeCredit.timeBlocked, Duration.zero);
    expect(timeCredit.currentBalance, const Duration(hours: 9, minutes: 30));
  });
}
