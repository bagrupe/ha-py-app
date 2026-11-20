import 'package:app/common/pagination/offset_page.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';

/// One page of volunteer entries belonging to the authenticated user.
class MyVolunteerRequestsPageData extends OffsetPage<VolunteerRequestModel> {
  /// Creates a page with its unpaginated [totalCount].
  const MyVolunteerRequestsPageData({
    required super.items,
    required super.hasNextPage,
    required this.totalCount,
  });

  /// Total number of entries belonging to the user.
  final int totalCount;
}
