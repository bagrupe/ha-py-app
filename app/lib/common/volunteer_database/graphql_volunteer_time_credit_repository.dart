import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/volunteer_database/time_credit_model.dart';
import 'package:app/graphql/__generated__/volunteer-entries.graphql.dart';
import 'package:graphql/client.dart';

/// GraphQL implementation for volunteer time-credit data.
class GraphqlVolunteerTimeCreditRepository {
  /// Creates a repository using [client].
  const GraphqlVolunteerTimeCreditRepository(this.client);

  /// GraphQL client used for time-credit requests.
  final GraphQLClient client;

  /// Loads the current time-credit totals of the authenticated volunteer.
  Future<TimeCreditModel> getTimeCredit() async {
    final result = await client.query_MyVolunteerTimeCredit(
      Options_Query_MyVolunteerTimeCredit(fetchPolicy: FetchPolicy.networkOnly),
    );
    if (result.hasException) {
      if (result.exception?.linkException is NetworkException) {
        throw OfflineDataUnavailableException(result.exception!);
      }
      throw result.exception!;
    }
    final timeCredit = result.parsedData?.meinEhrenamtsbankZeitkonto;
    if (timeCredit == null) {
      throw StateError('Volunteer time credit response is missing');
    }
    return TimeCreditModel(
      baseCredit: Duration(minutes: timeCredit.startCreditMinutes),
      helpProvided: Duration(minutes: timeCredit.creditMinutes),
      helpReceived: Duration(minutes: timeCredit.debitMinutes),
      timeBlocked: Duration.zero,
    );
  }
}
