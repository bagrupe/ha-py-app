import 'package:app/routes/termine/common/model/termin_list/termin_list.dart';
import 'package:app/routes/termine/termine.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension TerminListLegacy on TermineList {
  TermineList legacyCopyWith({
    List<VeranstaltungsTermin>? veranstaltungen,
    List<AbfallkalenderTermin>? abfallkalenderTermine,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return TermineList(
      veranstaltungen: veranstaltungen ?? this.veranstaltungen,
      abfallkalenderTermine:
          abfallkalenderTermine ?? this.abfallkalenderTermine,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
