import 'package:app/common/expressions/evaluating_visitor.dart';
import 'package:app/common/expressions/expression.dart';
import 'package:app/common/geo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service zur Auswertung von Ausdrücken mit Unterstützung für Geo-Dienste.
class EvaluatingVisitorService {
  /// Erstellt eine Instanz mit dem benötigten GeoService.
  EvaluatingVisitorService(this.geoService);
  final GeoService geoService;

  /// Wertet einen String-Ausdruck aus und liefert das Ergebnis als String zurück.
  Future<dynamic> evaluateString(
    StringExpression stringExpression,
    Map<String, dynamic> currentSlotValues,
  ) async {
    final visitor = EvaluatingVisitor(currentSlotValues, geoService);
    return await visitor.visit(stringExpression.parsed);
  }

  /// Wertet einen Booleschen Ausdruck aus und liefert das Ergebnis als bool zurück.
  Future<bool> evaluateBool(
    BoolExpression boolExpression,
    Map<String, dynamic> currentSlotValues,
  ) async {
    final visitor = EvaluatingVisitor(currentSlotValues, geoService);
    return await visitor.visit(boolExpression.parsed) as bool;
  }

  /// Wertet einen Integer-Ausdruck aus und liefert das Ergebnis als int zurück.
  Future<int> evaluateInt(
    IntExpression intExpression,
    Map<String, dynamic> currentSlotValues,
  ) async {
    final visitor = EvaluatingVisitor(currentSlotValues, geoService);
    return await visitor.visit(intExpression.parsed) as int;
  }
}

/// Provider für die Instanz von [EvaluatingVisitorService] mit Abhängigkeit zu [GeoService].
final evaluatingVisitorProvider = Provider((ref) {
  final geoService = ref.watch(geoServiceProvider);
  return EvaluatingVisitorService(geoService);
});
