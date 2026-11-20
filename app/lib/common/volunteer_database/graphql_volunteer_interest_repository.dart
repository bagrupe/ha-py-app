import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/volunteer-entries.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_booking_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_proposal_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:graphql/client.dart';

/// GraphQL implementation for volunteer interest submissions.
class GraphqlVolunteerInterestRepository {
  /// Creates a repository using [client].
  const GraphqlVolunteerInterestRepository(this.client);

  /// GraphQL client used for interest mutations.
  final GraphQLClient client;

  /// Loads all sent and received interest requests for the current user.
  Future<List<VolunteerInterestOverviewModel>> getInterests() async {
    const pageSize = 100;
    var skip = 0;
    var hasNextPage = true;
    final interests = <VolunteerInterestOverviewModel>[];
    while (hasNextPage) {
      final result = await client.query_MyVolunteerInterests(
        Options_Query_MyVolunteerInterests(
          variables: Variables_Query_MyVolunteerInterests(
            skip: skip,
            take: pageSize,
          ),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException is NetworkException) {
          throw OfflineDataUnavailableException(result.exception!);
        }
        throw result.exception!;
      }
      final segment = result.parsedData?.meineEhrenamtsbankAnfragen;
      final items = segment?.items ?? const [];
      interests.addAll(items.map(_mapOverviewItem));
      hasNextPage = segment?.pageInfo.hasNextPage ?? false;
      skip += items.length;
      if (hasNextPage && items.isEmpty) {
        throw StateError('Volunteer interest pagination did not advance');
      }
    }
    return interests;
  }

  /// Loads the current user's interest request for [entryId], if one exists.
  Future<VolunteerInterestModel?> getInterestForEntry(String entryId) async {
    final result = await client.query_MyVolunteerInterestForEntry(
      Options_Query_MyVolunteerInterestForEntry(
        variables: Variables_Query_MyVolunteerInterestForEntry(
          entryId: entryId,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      if (result.exception?.linkException is NetworkException) {
        throw OfflineDataUnavailableException(result.exception!);
      }
      throw result.exception!;
    }
    final interest = result.parsedData?.meineEhrenamtsbankAnfrageFuerEintrag;
    if (interest == null) return null;
    return VolunteerInterestModel(
      id: interest.id,
      status: interest.status,
      message: interest.nachricht,
      createdAt: interest.createdAt,
    );
  }

  Future<VolunteerInterestModel> createInterest({
    required String entryId,
    required String? message,
  }) async {
    final normalizedMessage = message?.trim();
    final result = await client.mutate_CreateVolunteerInterest(
      Options_Mutation_CreateVolunteerInterest(
        variables: Variables_Mutation_CreateVolunteerInterest(
          input: Input_CreateEhrenamtsbankAnfrageInput(
            eintragId: entryId,
            nachricht: normalizedMessage?.isEmpty ?? true
                ? null
                : normalizedMessage,
          ),
        ),
      ),
    );

    if (result.hasException) {
      final isOffline = result.exception?.linkException is NetworkException;
      throw VolunteerInterestSubmissionException(
        isOffline
            ? 'application.volunteer_database.details.interest.errors.offline'
            : 'application.volunteer_database.details.interest.errors.generic',
      );
    }

    final payload = result.parsedData?.createEhrenamtsbankAnfrage;
    final error = payload?.errors?.firstOrNull;
    if (error != null) {
      throw VolunteerInterestSubmissionException(
        _messageKeyFor(error.$__typename),
      );
    }

    final interest = payload?.ehrenamtsbankAnfrage;
    if (interest == null ||
        interest.status != Enum_EhrenamtsbankAnfrageStatus.OFFEN) {
      throw const VolunteerInterestSubmissionException(
        'application.volunteer_database.details.interest.errors.generic',
      );
    }

    return VolunteerInterestModel(
      id: interest.id,
      status: interest.status,
      message: interest.nachricht,
      createdAt: interest.createdAt,
    );
  }

  /// Updates the backend status of an existing interest request.
  Future<void> updateStatus({
    required String interestId,
    required Enum_EhrenamtsbankAnfrageStatus status,
  }) async {
    final result = await client.mutate_UpdateVolunteerInterestStatus(
      Options_Mutation_UpdateVolunteerInterestStatus(
        variables: Variables_Mutation_UpdateVolunteerInterestStatus(
          input: Input_UpdateEhrenamtsbankAnfrageStatusInput(
            anfrageId: interestId,
            status: status,
          ),
        ),
      ),
    );
    if (result.hasException) {
      final isOffline = result.exception?.linkException is NetworkException;
      throw VolunteerInterestSubmissionException(
        isOffline
            ? 'application.profile.volunteer_interests.actions.errors.offline'
            : 'application.profile.volunteer_interests.actions.errors.generic',
      );
    }
    final payload = result.parsedData?.updateEhrenamtsbankAnfrageStatus;
    if ((payload?.errors?.isNotEmpty ?? false) ||
        payload?.ehrenamtsbankAnfrage?.status != status) {
      throw const VolunteerInterestSubmissionException(
        'application.profile.volunteer_interests.actions.errors.generic',
      );
    }
  }

  /// Creates or replaces a completion proposal for an agreed request.
  Future<void> proposeCompletion({
    required String interestId,
    required int minutes,
    required DateTime performedOn,
    required String? note,
  }) async {
    final result = await client.mutate_ProposeVolunteerInterestCompletion(
      Options_Mutation_ProposeVolunteerInterestCompletion(
        variables: Variables_Mutation_ProposeVolunteerInterestCompletion(
          input: Input_ProposeEhrenamtsbankAbschlussInput(
            anfrageId: interestId,
            minutes: minutes,
            date: performedOn,
            note: note,
          ),
        ),
      ),
    );
    if (result.hasException) {
      final isOffline = result.exception?.linkException is NetworkException;
      throw VolunteerInterestSubmissionException(
        isOffline
            ? 'application.profile.volunteer_interests.completion.errors.offline'
            : 'application.profile.volunteer_interests.completion.errors.generic',
      );
    }
    final payload = result.parsedData?.proposeEhrenamtsbankAbschluss;
    final error = payload?.errors?.firstOrNull;
    if (error != null) {
      throw VolunteerInterestSubmissionException(
        _completionMessageKeyFor(error.$__typename),
      );
    }
    final proposal = payload?.ehrenamtsbankAnfrage;
    if (proposal == null ||
        proposal.status != Enum_EhrenamtsbankAnfrageStatus.VEREINBART ||
        proposal.proposedMinutes == null ||
        proposal.proposedDate == null ||
        proposal.proposedById == null) {
      throw const VolunteerInterestSubmissionException(
        'application.profile.volunteer_interests.completion.errors.generic',
      );
    }
  }

  /// Confirms the other party's current completion proposal.
  Future<void> confirmCompletion({required String interestId}) async {
    final result = await client.mutate_ConfirmVolunteerInterestCompletion(
      Options_Mutation_ConfirmVolunteerInterestCompletion(
        variables: Variables_Mutation_ConfirmVolunteerInterestCompletion(
          input: Input_ConfirmEhrenamtsbankAbschlussInput(
            anfrageId: interestId,
          ),
        ),
      ),
    );
    if (result.hasException) {
      final isOffline = result.exception?.linkException is NetworkException;
      throw VolunteerInterestSubmissionException(
        isOffline
            ? 'application.profile.volunteer_interests.completion.errors.offline'
            : 'application.profile.volunteer_interests.completion.errors.generic',
      );
    }
    final payload = result.parsedData?.confirmEhrenamtsbankAbschluss;
    final error = payload?.errors?.firstOrNull;
    if (error != null) {
      throw VolunteerInterestSubmissionException(
        _completionMessageKeyFor(error.$__typename),
      );
    }
    final completion = payload?.ehrenamtsbankAnfrage;
    if (completion == null ||
        completion.status != Enum_EhrenamtsbankAnfrageStatus.ERLEDIGT ||
        completion.transaktion == null) {
      throw const VolunteerInterestSubmissionException(
        'application.profile.volunteer_interests.completion.errors.generic',
      );
    }
  }

  String _messageKeyFor(String typeName) {
    return switch (typeName) {
      'AnfrageForItselfError' =>
        'application.volunteer_database.details.interest.errors.own_entry',
      'MultipleAnfrageError' =>
        'application.volunteer_database.details.interest.errors.duplicate',
      'EintragNotActiveError' =>
        'application.volunteer_database.details.interest.errors.inactive',
      'EintragNotFoundError' =>
        'application.volunteer_database.details.interest.errors.not_found',
      'Unauthenticated' =>
        'application.volunteer_database.details.interest.errors.unauthenticated',
      'NotAllowedError' =>
        'application.volunteer_database.details.interest.errors.not_allowed',
      _ => 'application.volunteer_database.details.interest.errors.generic',
    };
  }

  String _completionMessageKeyFor(String typeName) {
    const basePath =
        'application.profile.volunteer_interests.completion.errors';
    return switch (typeName) {
      'AbschlussMinutesOutOfRangeError' => '$basePath.duration_invalid',
      'AbschlussDateInFutureError' => '$basePath.date_in_future',
      'AbschlussNoteTooLongError' => '$basePath.note_too_long',
      'AbschlussSelfConfirmError' => '$basePath.self_confirmation',
      'AbschlussAlreadyBookedError' => '$basePath.already_completed',
      'AbschlussNotVereinbartError' ||
      'AbschlussNoProposalError' => '$basePath.proposal_changed',
      'Unauthenticated' => '$basePath.unauthenticated',
      'NotAllowedError' => '$basePath.not_allowed',
      _ => '$basePath.generic',
    };
  }

  VolunteerInterestOverviewModel _mapOverviewItem(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items item,
  ) {
    final isReceived =
        item.typ == Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE;
    final personName = isReceived
        ? _displayName(item.interessent?.vorname, item.interessent?.nachname)
        : _displayName(
            item.eintrag?.owner?.vorname,
            item.eintrag?.owner?.nachname,
          );
    final proposalMinutes = item.proposedMinutes;
    final proposalDate = item.proposedDate;
    final proposedById = item.proposedById;
    final completionProposal =
        proposalMinutes == null || proposalDate == null || proposedById == null
        ? null
        : VolunteerCompletionProposalModel(
            minutes: proposalMinutes,
            performedOn: proposalDate,
            proposedById: proposedById,
            note: item.proposedNote,
          );
    final transaction = item.transaktion;
    final completionBooking = transaction == null
        ? null
        : VolunteerCompletionBookingModel(
            id: transaction.id,
            minutes: transaction.minutes,
            performedOn: transaction.performedOn,
            status: transaction.status,
            note: transaction.note,
          );
    return VolunteerInterestOverviewModel(
      id: item.id,
      entryId: item.eintragId,
      entryTitle: item.eintrag?.title ?? '',
      entryDescription: item.eintrag?.description ?? '',
      plannedDurationMinutes: item.eintrag?.estimatedDurationMinutes,
      personName: personName,
      status: item.status,
      type: item.typ,
      createdAt: item.createdAt,
      agreementConfirmedAt: item.vereinbartAt,
      completionProposal: completionProposal,
      completionBooking: completionBooking,
      message: item.nachricht,
      contactPhone: isReceived
          ? item.interessent?.phone
          : item.eintrag?.owner?.phone,
    );
  }

  String _displayName(String? firstName, String? lastName) {
    final normalizedFirstName = firstName?.trim() ?? '';
    final normalizedLastName = lastName?.trim() ?? '';
    final lastInitial = normalizedLastName.isEmpty
        ? ''
        : '${normalizedLastName[0]}.';
    return [
      normalizedFirstName,
      lastInitial,
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
