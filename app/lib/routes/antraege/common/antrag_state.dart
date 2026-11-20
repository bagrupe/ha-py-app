import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Repräsentiert den Status eines Antrags im System.
enum AntragState {
  saved,
  buerger,
  kommune,
  completed,
  error;

  /// Wandelt einen Ausführungsstatus in einen entsprechenden AntragState um.
  /// [status] ist der Enum-Wert aus der Backend-Ausführung.
  static AntragState fromStatus(Enum_AusfuehrungStatus status) {
    return switch (status) {
      Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER => AntragState.buerger,
      Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE => AntragState.kommune,
      Enum_AusfuehrungStatus.ABGESCHLOSSEN => AntragState.completed,
      _ => AntragState.kommune,
    };
  }

  /// Gibt eine kurze textuelle Beschreibung des Status zurück.
  String toLabel() {
    return switch (this) {
      AntragState.saved => 'Gespeichert',
      AntragState.buerger => 'Angaben erforderlich',
      AntragState.kommune => 'In Bearbeitung',
      AntragState.completed => 'Abgeschlossen',
      AntragState.error => 'Unterlagen fehlen',
    };
  }

  /// Gibt eine textuelle Beschreibung mit optionalem Datum der letzten Änderung zurück.
  /// [lastChange] ist das Datum der letzten Statusänderung.
  String toDatedLabel(DateTime? lastChange) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final lastChangeFormatted = lastChange != null
        ? dateFormat.format(lastChange)
        : null;

    return switch (this) {
      AntragState.saved => 'Gespeichert am $lastChangeFormatted',
      AntragState.buerger => '$lastChangeFormatted Angaben erforderlich',
      AntragState.kommune => '$lastChangeFormatted In Bearbeitung',
      AntragState.completed => 'Abgeschlossen am $lastChangeFormatted',
      AntragState.error => '$lastChangeFormatted Unterlagen fehlen',
    };
  }

  /// Liefert die Darstellungselemente für den Status zurück.
  /// [theme] ist das aktuelle Theme für Farbwerte.
  /// Rückgabe ist ein Tupel aus Icon, Hauptfarbe und Hintergrundfarbe.
  (IconData, Color, Color) toRenderDetails(ThemeData theme) => switch (this) {
    AntragState.buerger => (
      Icons.hourglass_empty,
      theme.primaryColor,
      theme.primaryColorLight,
    ),
    AntragState.kommune => (
      Icons.hourglass_empty,
      DesignTokens.orange500,
      DesignTokens.orange100,
    ),
    AntragState.completed => (
      Icons.check,
      DesignTokens.green900,
      DesignTokens.green100,
    ),
    AntragState.saved => (
      Icons.edit_document,
      theme.primaryColor,
      theme.primaryColorLight,
    ),
    AntragState.error => (
      Icons.error,
      DesignTokens.red500,
      DesignTokens.red200,
    ),
  };
}
