import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';

/// Maps valid backend occurrences without inventing missing event dates.
List<VeranstaltungsTermin> mapEventAppointments(
  Iterable<Query_TermineList_veranstaltungsTermine_docs> documents,
) {
  return mergeEventAppointments([
    for (final document in documents)
      if (document.id case final id? when id.isNotEmpty)
        if (DateTime.tryParse(document.start ?? '') case final start?)
          VeranstaltungsTermin(
            veranstaltungsId: id,
            start: start,
            end: DateTime.tryParse(document.end ?? '') ?? start,
            titel: document.titel ?? '',
            subtitel: document.locationName ?? document.subtitle ?? '',
            imageUrl:
                document.titelbild?.url ?? document.titelbild?.internal?.url,
            thumbnailImageUrl:
                document.titelbild?.url ?? document.titelbild?.internal?.url,
            termineOnSameDay: (document.dates ?? []).nonNulls
                .map((date) => DateTime.tryParse(date.start ?? ''))
                .nonNulls
                .toSet()
                .take(3)
                .toList(),
          ),
  ]);
}

/// Replaces overlapping occurrences while preserving distinct dates per event.
List<VeranstaltungsTermin> mergeEventAppointments(
  Iterable<VeranstaltungsTermin> appointments,
) {
  final byOccurrence = <(String, DateTime), VeranstaltungsTermin>{};
  for (final appointment in appointments) {
    byOccurrence[(appointment.veranstaltungsId, appointment.start.toUtc())] =
        appointment;
  }
  return byOccurrence.values.toList();
}
