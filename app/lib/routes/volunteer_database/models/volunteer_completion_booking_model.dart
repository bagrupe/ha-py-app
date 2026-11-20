import 'package:app/graphql/__generated__/schema.graphql.dart';

/// Time-account booking created from a mutually confirmed completion.
class VolunteerCompletionBookingModel {
  /// Creates a completion booking.
  const VolunteerCompletionBookingModel({
    required this.id,
    required this.minutes,
    required this.performedOn,
    required this.status,
    this.note,
  });

  /// Stable transaction identifier.
  final String id;

  /// Booked duration in minutes.
  final int minutes;

  /// Date on which the help was performed.
  final DateTime performedOn;

  /// Optional note copied from the accepted proposal.
  final String? note;

  /// Current backend transaction status.
  final Enum_EhrenamtsbankTransaktionStatus status;
}
