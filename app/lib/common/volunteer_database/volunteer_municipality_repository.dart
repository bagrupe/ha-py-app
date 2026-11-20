import 'package:app/graphql/__generated__/volunteer-categories.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/models/volunteer_municipality_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Loads municipalities available for volunteer requests.
class VolunteerMunicipalityRepository {
  /// Creates a repository using [client].
  const VolunteerMunicipalityRepository(this.client);

  /// GraphQL client used for municipality requests.
  final GraphQLClient client;

  /// Returns municipalities belonging to [municipalityAssociationId].
  Future<List<VolunteerMunicipalityModel>> getMunicipalities(
    String municipalityAssociationId,
  ) async {
    final result = await client.query_VolunteerMunicipalities(
      Options_Query_VolunteerMunicipalities(
        variables: Variables_Query_VolunteerMunicipalities(
          kommuneId: municipalityAssociationId,
        ),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    if (result.hasException && result.parsedData == null) {
      throw result.exception!;
    }
    return (result.parsedData?.kommune.untereinheiten ?? [])
        .map(
          (municipality) => VolunteerMunicipalityModel(
            id: municipality.id,
            name: municipality.name,
          ),
        )
        .toList(growable: false);
  }
}

/// Repository for volunteer request municipalities.
final volunteerMunicipalityRepositoryProvider =
    Provider<VolunteerMunicipalityRepository>(
      (ref) =>
          VolunteerMunicipalityRepository(ref.watch(graphqlClientProvider)),
    );
