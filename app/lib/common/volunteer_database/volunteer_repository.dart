import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:app/common/pagination/offset_page.dart';
import 'package:app/common/volunteer_database/graphql_volunteer_repository.dart';
import 'package:app/common/volunteer_database/my_volunteer_requests_page_data.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_details_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for loading volunteer marketplace entries.
abstract class VolunteerRepository {
  /// Returns one page of entries belonging to the authenticated user.
  Future<MyVolunteerRequestsPageData> getMyRequestsPage({
    required int skip,
    required int take,
  });

  /// Returns one page of active entries for the selected filters.
  Future<OffsetPage<VolunteerRequestModel>> getRequestsPage({
    required HelpType helpType,
    required String? categoryKey,
    required int skip,
    required int take,
  });

  /// Returns the complete entry identified by [id].
  Future<VolunteerRequestDetailsModel> getRequest(String id);

  /// Creates a request draft and submits it for moderation.
  Future<String> submitRequest(VolunteerRequestSubmission submission);
}

/// Provides the GraphQL-backed volunteer marketplace repository.
final volunteerRepositoryProvider = Provider<VolunteerRepository>((ref) {
  return GraphqlVolunteerRepository(
    ref.watch(graphqlClientProvider),
    objectStorage: ref.watch(objectStorageClientProvider),
  );
});
