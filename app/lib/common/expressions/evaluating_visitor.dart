// ignore_for_file: avoid_dynamic_calls, strict_raw_type

import 'package:app/common/expressions/parser/ExpressionsParser.dart';
import 'package:app/common/expressions/parser/ExpressionsVisitor.dart';
import 'package:app/common/geo_service.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:latlong2/latlong.dart';

/// Besucher zur Auswertung von Ausdrücken mit asynchroner Rückgabe.
/// Nutzt GeoService und aktuelle Slot-Werte zur Berechnung.
class EvaluatingVisitor extends ExpressionsVisitor<Future<dynamic>> {
  /// Erstellt einen EvaluatingVisitor mit den aktuellen Slot-Werten und GeoService.
  EvaluatingVisitor(this.slots, this.geoservice);
  final GeoService geoservice;
  Map<String, dynamic> slots;

  /// Wertet einen booleschen Wert aus dem Kontext aus.
  @override
  Future? visitBoolValue(BoolValueContext ctx) async {
    return ctx.payload.text == 'true';
  }

  /// Wertet einen Ausdruck in Klammern aus.
  @override
  Future<dynamic>? visitBrackets(BracketsContext ctx) {
    return visit(ctx.expr!);
  }

  /// Wertet Funktionsaufrufe aus, unterstützt 'slot' und 'isInside'.
  @override
  Future<dynamic> visitCall(CallContext ctx) async {
    final functionName = ctx.name!.text;

    switch (functionName) {
      case 'slot':
        final parameter = await visit(ctx.parameter!);
        return slots[parameter as String];
      case 'isInside':
        final expressions = ctx.parameter?.expressions() ?? [];
        final nameParameter = expressions[0];
        final locationParameter = expressions[1];

        final strippedNameParameter = await visit(nameParameter) as String;

        final locationValue = await visit(locationParameter);
        if (locationValue is! FormLocation) return false;

        final isInside = await geoservice.isPointInGeoflaeche(
          strippedNameParameter,
          locationValue.position,
        );

        return isInside;
    }

    throw Exception('Unknown function $functionName');
  }

  /// Wertet einen Funktionsaufruf-Ausdruck aus.
  @override
  Future<dynamic>? visitExprCall(ExprCallContext ctx) {
    return visit(ctx.call()!);
  }

  /// Wertet einen Wert-Ausdruck aus.
  @override
  Future<dynamic>? visitExprValue(ExprValueContext ctx) {
    return visit(ctx.value()!);
  }

  /// Startpunkt der Auswertung einer Ausdrucksdatei.
  @override
  Future<dynamic>? visitExpressionFile(ExpressionFileContext ctx) {
    return visit(ctx.expression()!);
  }

  /// Liefert den Text eines Bezeichners zurück.
  @override
  Future<String> visitId(IdContext ctx) async {
    return ctx.payload.text;
  }

  /// Parst einen Zahlenwert als Integer.
  @override
  Future<int> visitNumberValue(NumberValueContext ctx) async {
    return int.parse(ctx.payload.text);
  }

  /// Wertet Operatoren aus und führt die entsprechenden Operationen aus.
  @override
  Future<dynamic> visitOperator(OperatorContext ctx) async {
    if (ctx.EQ() != null) {
      return await visit(ctx.left!) == await visit(ctx.right!);
    }

    if (ctx.NEQ() != null) {
      return await visit(ctx.left!) != await visit(ctx.right!);
    }

    if (ctx.GT() != null) {
      return await visit(ctx.left!) > await visit(ctx.right!);
    }

    if (ctx.GTEQ() != null) {
      return await visit(ctx.left!) >= await visit(ctx.right!);
    }

    if (ctx.LT() != null) {
      return await visit(ctx.left!) < await visit(ctx.right!);
    }

    if (ctx.LTEQ() != null) {
      return await visit(ctx.left!) <= await visit(ctx.right!);
    }

    if (ctx.AND() != null) {
      return await visit(ctx.left!) as bool && await visit(ctx.right!) as bool;
    }

    if (ctx.OR() != null) {
      return await visit(ctx.left!) as bool || await visit(ctx.right!) as bool;
    }

    if (ctx.PLUS() != null) {
      return await visit(ctx.left!) + await visit(ctx.right!);
    }

    if (ctx.MINUS() != null) {
      return await visit(ctx.left!) - await visit(ctx.right!);
    }

    if (ctx.TIMES() != null) {
      return await visit(ctx.left!) * await visit(ctx.right!);
    }

    if (ctx.DIV() != null) {
      return await visit(ctx.left!) / await visit(ctx.right!);
    }

    throw UnimplementedError();
  }

  /// Wertet einen String-Wert aus und entfernt Anführungszeichen und Escape-Sequenzen.
  @override
  Future<String> visitStringValue(StringValueContext ctx) async {
    return ctx.payload.text
        .substring(1, ctx.payload.text.length - 1)
        .replaceAllMapped(r'\(.?)', (match) {
          final found = match.group(1)!;
          switch (found) {
            case r'\':
              return r'\';
            case '':
              return '';
            default:
              return found;
          }
        });
  }

  /// Wertet die Parameter eines Funktionsaufrufs aus.
  @override
  Future<dynamic>? visitCallParams(CallParamsContext ctx) {
    return visitChildren(ctx);
  }

  /// Wertet einen Standortwert aus und liefert ein LatLng-Objekt zurück.
  @override
  Future<LatLng> visitLocationValue(LocationValueContext ctx) async {
    final location =
        ctx.Location()?.text?.split(',').map(double.parse).nonNulls.toList() ??
        [];

    if (location.length != 2) {
      throw UnsupportedError('LocationValue needs to be two numbers');
    }
    return LatLng(location[0], location[1]);
  }
}
