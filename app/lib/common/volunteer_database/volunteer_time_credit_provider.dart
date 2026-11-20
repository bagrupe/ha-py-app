import 'package:app/common/volunteer_database/graphql_volunteer_time_credit_repository.dart';
import 'package:app/common/volunteer_database/time_credit_model.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository used to load the authenticated volunteer's time credit.
final volunteerTimeCreditRepositoryProvider =
    Provider<GraphqlVolunteerTimeCreditRepository>(
      (ref) => GraphqlVolunteerTimeCreditRepository(
        ref.watch(graphqlClientProvider),
      ),
    );

/// Loads current time-credit totals for the active volunteer session.
class VolunteerTimeCreditNotifier extends AsyncNotifier<TimeCreditModel?> {
  @override
  Future<TimeCreditModel?> build() {
    final userId = ref.watch(volunteerAuthProvider);
    if (userId == null) return Future.value();
    return ref.read(volunteerTimeCreditRepositoryProvider).getTimeCredit();
  }
}

/// Current backend time-credit snapshot for the authenticated volunteer.
final volunteerTimeCreditProvider =
    AsyncNotifierProvider.autoDispose<
      VolunteerTimeCreditNotifier,
      TimeCreditModel?
    >(VolunteerTimeCreditNotifier.new);
