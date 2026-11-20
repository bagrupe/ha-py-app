import 'dart:io';

import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:app/common/pagination/offset_page.dart';
import 'package:app/common/volunteer_database/my_volunteer_requests_page_data.dart';
import 'package:app/common/volunteer_database/volunteer_photo_policy.dart';
import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/volunteer-entries.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_details_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:graphql/client.dart';

/// GraphQL implementation of the volunteer marketplace data source.
class GraphqlVolunteerRepository implements VolunteerRepository {
  /// Creates a repository using [client].
  const GraphqlVolunteerRepository(this.client, {required this.objectStorage});

  /// GraphQL client used for marketplace requests.
  final GraphQLClient client;

  /// Stores request images.
  final ObjectStorageClient objectStorage;

  /// Must match the backend's `EhrenamtsbankEintragImageStorageConsumer.KeyPrefix`.
  static const _imagePrefix = 'ehrenamtsbank';

  @override
  Future<MyVolunteerRequestsPageData> getMyRequestsPage({
    required int skip,
    required int take,
  }) async {
    final result = await _queryWithOfflineFallback(
      query: (fetchPolicy) => client.query_MyVolunteerEntries(
        Options_Query_MyVolunteerEntries(
          variables: Variables_Query_MyVolunteerEntries(skip: skip, take: take),
          fetchPolicy: fetchPolicy,
          errorPolicy: ErrorPolicy.all,
        ),
      ),
    );
    _throwWhenUnusable(result);
    final segment = result.parsedData!.meineEhrenamtsbankEintraege;
    return MyVolunteerRequestsPageData(
      items: (segment?.items ?? []).map(_mapEntry).toList(growable: false),
      hasNextPage: segment?.pageInfo.hasNextPage ?? false,
      totalCount: segment?.totalCount ?? 0,
    );
  }

  @override
  Future<String> submitRequest(VolunteerRequestSubmission submission) async {
    final photoPath = submission.photoPath;
    final photo = photoPath == null ? null : File(photoPath);
    final contentType = photo == null
        ? null
        : await VolunteerPhotoPolicy.validate(photo);
    final imageKey = photoPath == null
        ? null
        : await objectStorage.uploadFile(
            _imagePrefix,
            photo!,
            contentType: contentType,
          );
    final createResult = await client.mutate_CreateVolunteerRequest(
      Options_Mutation_CreateVolunteerRequest(
        variables: Variables_Mutation_CreateVolunteerRequest(
          input: Input_CreateEhrenamtsbankEintragInput(
            typ: Enum_EhrenamtsbankEintragTyp.GESUCH,
            title: submission.title,
            description: submission.description,
            kategorieId: submission.categoryId,
            untereinheitId: submission.municipalityId,
            urgency: submission.urgency,
            estimatedDurationMinutes: submission.estimatedDurationMinutes,
            radiusKm: submission.radiusKm,
            tags: submission.tags,
            imageKey: imageKey,
          ),
        ),
      ),
    );
    _throwWhenUnusable(createResult);
    final createPayload = createResult.parsedData!.createEhrenamtsbankEintrag;
    final createdEntry = createPayload.ehrenamtsbankEintrag;
    final entryId = createdEntry?.id;
    if ((createPayload.errors?.isNotEmpty ?? false) || entryId == null) {
      throw StateError(_mutationError(createPayload.errors));
    }
    if (createdEntry!.status == Enum_EhrenamtsbankEintragStatus.ACTIVE) {
      return entryId;
    }

    final submitResult = await client.mutate_SubmitVolunteerRequest(
      Options_Mutation_SubmitVolunteerRequest(
        variables: Variables_Mutation_SubmitVolunteerRequest(
          input: Input_UpdateEhrenamtsbankEintragStatusInput(
            id: entryId,
            status: Enum_EhrenamtsbankEintragStatus.PENDING_REVIEW,
          ),
        ),
      ),
    );
    _throwWhenUnusable(submitResult);
    final submitPayload =
        submitResult.parsedData!.updateEhrenamtsbankEintragStatus;
    if ((submitPayload.errors?.isNotEmpty ?? false) ||
        submitPayload.ehrenamtsbankEintrag?.status !=
            Enum_EhrenamtsbankEintragStatus.PENDING_REVIEW) {
      throw StateError(_mutationError(submitPayload.errors));
    }
    return entryId;
  }

  @override
  Future<VolunteerRequestDetailsModel> getRequest(String id) async {
    final result = await _queryWithOfflineFallback(
      query: (fetchPolicy) => client.query_VolunteerEntry(
        Options_Query_VolunteerEntry(
          variables: Variables_Query_VolunteerEntry(id: id),
          fetchPolicy: fetchPolicy,
          errorPolicy: ErrorPolicy.all,
        ),
      ),
    );
    _throwWhenUnusable(result, allowPartialEntries: true);
    final entry = result.parsedData!.ehrenamtsbankEintrag;
    return VolunteerRequestDetailsModel(
      volunteerRequestModel: _mapEntry(entry),
      metaData: entry.tags,
      createdAt: DateFormat.yMd('de').format(entry.createdAt.toLocal()),
    );
  }

  @override
  Future<OffsetPage<VolunteerRequestModel>> getRequestsPage({
    required HelpType helpType,
    required String? categoryKey,
    required int skip,
    required int take,
  }) async {
    final result = await _queryWithOfflineFallback(
      query: (fetchPolicy) => client.query_VolunteerEntries(
        Options_Query_VolunteerEntries(
          variables: Variables_Query_VolunteerEntries(
            typ: _mapHelpType(helpType),
            kategorieIds: categoryKey == null ? null : [categoryKey],
            skip: skip,
            take: take,
          ),
          fetchPolicy: fetchPolicy,
          errorPolicy: ErrorPolicy.all,
        ),
      ),
    );
    _throwWhenUnusable(result, allowPartialEntries: true);
    final segment = result.parsedData!.ehrenamtsbankEintraege;
    final page = OffsetPage(
      items: (segment?.items ?? []).map(_mapEntry).toList(growable: false),
      hasNextPage: segment?.pageInfo.hasNextPage ?? false,
    );
    if (page.hasNextPage && page.items.isEmpty) {
      throw StateError('Pagination did not advance');
    }
    return page;
  }

  /// Executes against the network and falls back to cached data when offline.
  Future<QueryResult<T>> _queryWithOfflineFallback<T>({
    required Future<QueryResult<T>> Function(FetchPolicy fetchPolicy) query,
  }) async {
    final networkResult = await query(FetchPolicy.networkOnly);
    final linkException = networkResult.exception?.linkException;
    if (linkException is! NetworkException) {
      return networkResult;
    }

    final cacheResult = await query(FetchPolicy.cacheOnly);
    if (!cacheResult.hasException && cacheResult.parsedData != null) {
      return cacheResult;
    }

    throw OfflineDataUnavailableException(networkResult.exception!);
  }

  /// Maps shared GraphQL entry data to the view model used by the app.
  VolunteerRequestModel _mapEntry(Fragment_VolunteerEntryData entry) {
    final firstName = entry.owner?.vorname?.trim() ?? '';
    final lastName = entry.owner?.nachname?.trim() ?? '';
    final displayName = [
      firstName,
      lastName,
    ].where((part) => part.isNotEmpty).join(' ');
    final initials = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty) lastName[0],
    ].join().toUpperCase();
    final duration = entry.estimatedDurationMinutes;
    final time = duration == null
        ? entry.availability ?? ''
        : _formatDuration(duration);
    return VolunteerRequestModel(
      id: entry.id,
      ownerId: entry.owner?.id ?? '',
      title: entry.title,
      time: time,
      commune: entry.untereinheit?.name ?? '',
      userAvatar: initials,
      userName: displayName,
      isVerified:
          (entry.owner?.phoneVerified ?? false) ||
          (entry.owner?.clearanceVerified ?? false),
      description: entry.description,
      categoryKey: entry.kategorieId,
      helpType: entry.typ == Enum_EhrenamtsbankEintragTyp.GESUCH
          ? HelpType.offerHelp
          : HelpType.seekHelp,
      image: entry.imageKey == null
          ? null
          : ViewImage(
              url: objectStorage.urlFor(entry.imageKey!),
              altText: entry.title,
            ),
      status: _mapStatus(entry.status),
    );
  }

  /// Maps a backend lifecycle status to the UI model.
  VolunteerRequestStatus _mapStatus(Enum_EhrenamtsbankEintragStatus status) {
    return switch (status) {
      Enum_EhrenamtsbankEintragStatus.DRAFT => VolunteerRequestStatus.draft,
      Enum_EhrenamtsbankEintragStatus.PENDING_REVIEW =>
        VolunteerRequestStatus.pendingReview,
      Enum_EhrenamtsbankEintragStatus.ACTIVE => VolunteerRequestStatus.active,
      Enum_EhrenamtsbankEintragStatus.ASSIGNED =>
        VolunteerRequestStatus.assigned,
      Enum_EhrenamtsbankEintragStatus.PAUSED => VolunteerRequestStatus.paused,
      Enum_EhrenamtsbankEintragStatus.COMPLETED =>
        VolunteerRequestStatus.completed,
      Enum_EhrenamtsbankEintragStatus.CLOSED => VolunteerRequestStatus.closed,
      Enum_EhrenamtsbankEintragStatus.$unknown =>
        VolunteerRequestStatus.unknown,
    };
  }

  /// Formats an estimated duration using the configured locale resources.
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes.remainder(60);
    final duration = '+$hours:${remainingMinutes.toString().padLeft(2, '0')}';
    return 'application.volunteer_database.hours'.tr(
      namedArgs: {'hours': duration},
    );
  }

  /// Maps the user's marketplace perspective to the backend entry type.
  Enum_EhrenamtsbankEintragTyp _mapHelpType(HelpType helpType) {
    return helpType == HelpType.offerHelp
        ? Enum_EhrenamtsbankEintragTyp.GESUCH
        : Enum_EhrenamtsbankEintragTyp.ANGEBOT;
  }

  /// Rejects failures except optional entry metadata errors with usable data.
  void _throwWhenUnusable<T>(
    QueryResult<T> result, {
    bool allowPartialEntries = false,
  }) {
    final exception = result.exception;
    final hasUsablePartialEntries =
        allowPartialEntries &&
        result.parsedData != null &&
        exception?.linkException == null &&
        (exception?.graphqlErrors.isNotEmpty ?? false) &&
        exception!.graphqlErrors.every(_isOptionalEntryFieldError);
    if (result.hasException && !hasUsablePartialEntries) {
      throw result.exception!;
    }
    if (result.parsedData == null) {
      throw StateError('Missing GraphQL response data');
    }
  }

  /// Identifies errors confined to nullable entry owner or municipality data.
  bool _isOptionalEntryFieldError(GraphQLError error) {
    final path = error.path;
    if (path == null) return false;
    final String field;
    if (path.length >= 4 &&
        path[0] == 'ehrenamtsbankEintraege' &&
        path[1] == 'items' &&
        path[2] is int) {
      field = path[3].toString();
    } else if (path.length >= 2 && path[0] == 'ehrenamtsbankEintrag') {
      field = path[1].toString();
    } else {
      return false;
    }
    return field == 'owner' || field == 'untereinheit';
  }

  /// Creates a readable fallback for typed mutation errors.
  String _mutationError(Iterable<Object>? errors) {
    if (errors == null || errors.isEmpty) {
      return 'Unexpected volunteer request response';
    }
    return errors.first.toString();
  }
}
