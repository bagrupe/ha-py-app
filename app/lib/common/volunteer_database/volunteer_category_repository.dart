import 'package:app/graphql/__generated__/volunteer-categories.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/models/volunteer_category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Loads volunteer marketplace categories from the backend.
class VolunteerCategoryRepository {
  /// Creates a repository using [client].
  const VolunteerCategoryRepository(this.client);

  /// GraphQL client used for category requests.
  final GraphQLClient client;

  /// Returns visible root categories in backend-defined order.
  Future<List<VolunteerCategoryModel>> getCategories() async {
    final result = await client.query_VolunteerCategories(
      Options_Query_VolunteerCategories(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException && result.parsedData == null) {
      throw result.exception!;
    }

    return result.parsedData?.ehrenamtsbankKategorien
            .map(
              (category) =>
                  VolunteerCategoryModel(id: category.id, name: category.name),
            )
            .toList() ??
        [];
  }
}

/// Repository for volunteer marketplace categories.
final volunteerCategoryRepositoryProvider = Provider(
  (ref) => VolunteerCategoryRepository(ref.watch(graphqlClientProvider)),
);
