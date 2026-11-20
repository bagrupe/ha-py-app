import 'package:app/routes/termine/termine.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'termin_list.freezed.dart';

/// Enthält Listen von Veranstaltungsterminen und Abfallkalender-Terminen Sowie Paginations-Info.
@freezed
abstract class TermineList with _$TermineList {
  /// Erstellt eine Instanz mit den übergebenen Veranstaltungsterminen und Abfallkalender-Terminen.
  const factory TermineList({
    required List<VeranstaltungsTermin> veranstaltungen,
    required List<AbfallkalenderTermin> abfallkalenderTermine,
    @Default(1) int currentPage,
    @Default(false) bool hasNextPage,
  }) = _TermineList;
}
