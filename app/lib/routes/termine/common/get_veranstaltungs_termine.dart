// ignore_for_file: omit_local_variable_types

import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/termine.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:collection/collection.dart';

/// Typdefinition für eine Liste von zusammengefassten Terminen an einem Tag.
/// Enthält das erste Datum mit Zeit und Ort sowie eine Liste weiterer Termine am selben Tag.
typedef CompleteDate = ({DateTime start, DateTime end});
typedef CollapsedDates =
    List<(CompleteDate firstDate, List<DateTime> otherDates)>;

/// Erzeugt eine Liste von VeranstaltungsTerminen aus den Veranstaltungsinformationen.
/// Gruppiert dabei Termine, die am selben Tag stattfinden, und bereitet Bild-URLs auf.
/// [veranstaltung] sind die Veranstaltungsinformationen mit Termindaten.
List<VeranstaltungsTermin> getVeranstaltungstermine(
  Fragment_VeranstaltungInfo veranstaltung, {
  bool showPastEvents = false,
}) {
  final veranstaltungsTermin = veranstaltung;

  final imageUrl = veranstaltungsTermin.titelbild == null
      ? null
      : veranstaltungsTermin.titelbild!.$external ?? false
      ? veranstaltungsTermin.titelbild!.url!
      : veranstaltungsTermin.titelbild!.internal?.url;

  final thumbnailImageUrl = veranstaltungsTermin.titelbild == null
      ? null
      : veranstaltungsTermin.titelbild!.$external ?? false
      ? veranstaltungsTermin.titelbild!.url!
      : veranstaltungsTermin.titelbild!.internal?.sizes?.thumbnail?.url;

  final collapsedTermine = _collapseOnSameDay(
    veranstaltungsTermin.timeAndLocation?.dates ?? [],
    showPastEvents: showPastEvents,
  );

  return collapsedTermine.map((collapse) {
    final (first, otherDates) = collapse;

    return VeranstaltungsTermin(
      veranstaltungsId: veranstaltung.id,
      start: first.start,
      end: first.end,
      titel: veranstaltung.titel,
      subtitel: veranstaltung.timeAndLocation?.locationName ?? '',
      imageUrl: imageUrl,
      thumbnailImageUrl: thumbnailImageUrl,
      termineOnSameDay: otherDates.take(3).toList(),
    );
  }).toList();
}

/// Fasst Termine zusammen, die am selben Kalendertag stattfinden.
/// [veranstaltungDates] sind die einzelnen Termine mit Start- und Endzeit.
/// Liefert eine Liste von Tupeln mit dem ersten Termin und weiteren Terminen am gleichen Tag.
CollapsedDates _collapseOnSameDay(
  VeranstaltungDates veranstaltungDates, {
  bool showPastEvents = false,
}) {
  if (veranstaltungDates.isEmpty) return [];

  final completeDates = veranstaltungDates
      .where((d) => d.start != null && d.end != null)
      .map((d) => (start: d.start!, end: d.end!))
      .toList();
  if (completeDates.isEmpty) return [];

  final CollapsedDates result = [];

  completeDates.sortBy<DateTime>((d) => d.start);

  List<CompleteDate> filtered = [];

  if (showPastEvents) {
    filtered = completeDates;
  } else {
    filtered = completeDates
        .skipWhile((date) => date.start.isBefore(DateTime.now()))
        .toList();
  }

  var i = 0;
  while (i < filtered.length) {
    final first = filtered[i];
    final remaining = filtered
        .skip(i + 1)
        .takeWhile(
          (d) =>
              d.start.year == first.start.year &&
              d.start.month == first.start.month &&
              d.start.day == first.start.day,
        )
        .map((d) => d.start)
        .toList();

    result.add((first, remaining));

    i += 1 + remaining.length;
  }

  return result;
}
