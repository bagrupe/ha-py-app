import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_booking_model.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_proposal_model.dart';

/// Display model for a sent or received volunteer interest request.
class VolunteerInterestOverviewModel {
  /// Creates an interest overview item.
  const VolunteerInterestOverviewModel({
    required this.id,
    required this.entryId,
    required this.entryTitle,
    required this.entryDescription,
    required this.plannedDurationMinutes,
    required this.personName,
    required this.status,
    required this.type,
    required this.createdAt,
    this.agreementConfirmedAt,
    this.completionProposal,
    this.completionBooking,
    this.message,
    this.contactPhone,
  });

  /// Stable request identifier.
  final String id;

  /// Stable volunteer entry identifier.
  final String entryId;

  /// Title of the related volunteer entry.
  final String entryTitle;

  /// Description of the related volunteer entry.
  final String entryDescription;

  /// Originally planned duration of the related entry in minutes.
  final int? plannedDurationMinutes;

  /// Display name of the other relevant person.
  final String personName;

  /// Optional message submitted with the request.
  final String? message;

  /// Mobile number of the other party when released by the backend.
  final String? contactPhone;

  /// Current backend request status.
  final Enum_EhrenamtsbankAnfrageStatus status;

  /// Whether the request was sent or received by the current user.
  final Enum_EhrenamtsbankAnfrageTyp type;

  /// Time at which the request was created.
  final DateTime createdAt;

  /// Time at which either party confirmed the agreement.
  final DateTime? agreementConfirmedAt;

  /// Current completion proposal awaiting the other party's confirmation.
  final VolunteerCompletionProposalModel? completionProposal;

  /// Time-account booking created after mutual confirmation.
  final VolunteerCompletionBookingModel? completionBooking;

  /// Translation key for the lifecycle label shown to the current party.
  String get statusTranslationKey {
    const path = 'application.profile.volunteer_interests.status';
    if (isAgreed) {
      if (completionProposal != null) return '$path.in_progress';
      if (type == Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE) {
        return '$path.assigned';
      }
    }
    return '$path.${status.name}';
  }

  /// Whether this request still awaits a decision.
  bool get isOpen => status == Enum_EhrenamtsbankAnfrageStatus.OFFEN;

  /// Whether this request is accepted and awaits agreement confirmation.
  bool get isAccepted => status == Enum_EhrenamtsbankAnfrageStatus.AKZEPTIERT;

  /// Whether either party has confirmed the agreement.
  bool get isAgreed => status == Enum_EhrenamtsbankAnfrageStatus.VEREINBART;

  /// Whether the request was completed and booked by both parties.
  bool get isCompleted => status == Enum_EhrenamtsbankAnfrageStatus.ERLEDIGT;

  /// Whether the current party can confirm the accepted agreement.
  bool get canConfirmAgreement => isAccepted;

  /// Whether WhatsApp contact remains available for this request.
  bool get canContact {
    final isReceived = type == Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE;
    return (isReceived && isOpen) || isAccepted || isAgreed;
  }
}
