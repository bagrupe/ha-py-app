import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the details of a specific volunteer request from the API.
final volunteerRequestDetailsProvider = FutureProvider.family
    .autoDispose<VolunteerRequestDetailsModel, String>((ref, id) async {
      return ref.watch(volunteerRepositoryProvider).getRequest(id);
    });
