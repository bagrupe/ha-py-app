import 'package:antlr4/antlr4.dart';
import 'package:app/common/expressions/parser/ExpressionsLexer.dart';
import 'package:app/common/expressions/parser/ExpressionsParser.dart';

/// Abstrakte Basisklasse für Ausdrücke, die einen String-Ausdruck parst und speichert.
abstract class Expression {
  /// Konstruktor, der den Ausdruck parst und den Kontext initialisiert.
  Expression(this.expression) {
    final inputStream = InputStream.fromString(expression);
    final lexer = ExpressionsLexer(inputStream);
    final tokenStream = CommonTokenStream(lexer);
    final parser = ExpressionsParser(tokenStream);

    parsed = parser.expressionFile().expression()!;
  }

  /// Der ursprüngliche Ausdruck als String.
  String expression;

  /// Der geparste Ausdruckskontext.
  late ExpressionContext parsed;
}

/// Ausdrucksklasse für boolesche Werte.
class BoolExpression extends Expression {
  /// Konstruktor, der den booleschen Ausdruck übernimmt.
  BoolExpression(super.expression);
}

/// Ausdrucksklasse für String-Werte.
class StringExpression extends Expression {
  /// Konstruktor, der den String-Ausdruck übernimmt.
  StringExpression(super.expression);
}

/// Ausdrucksklasse für Ganzzahlen.
class IntExpression extends Expression {
  /// Konstruktor, der den Integer-Ausdruck übernimmt.
  IntExpression(super.expression);
}

/// Ausdrucksklasse für Ortsangaben.
class LocationExpression extends Expression {
  /// Konstruktor, der den Ortsausdruck übernimmt.
  LocationExpression(super.expression);
}

/// Erzeugt einen BoolExpression aus einem JSON-Wert.
BoolExpression boolExpressionFromJson(dynamic json) {
  if (json is BoolExpression) return json;
  return BoolExpression(json as String);
}

/// Erzeugt einen StringExpression aus einem JSON-Wert.
StringExpression stringExpressionFromJson(dynamic json) {
  if (json is StringExpression) return json;
  return StringExpression(json as String);
}

/// Erzeugt einen IntExpression aus einem JSON-Wert.
IntExpression intExpressionFromJson(dynamic json) {
  if (json is IntExpression) return json;
  return IntExpression(json as String);
}

/// Serializes a BoolExpression for JSON/Hive caching.
String boolExpressionToJson(BoolExpression value) => value.expression;

/// Serializes a StringExpression for JSON/Hive caching.
String stringExpressionToJson(StringExpression value) => value.expression;

/// Serializes an IntExpression for JSON/Hive caching.
String intExpressionToJson(IntExpression value) => value.expression;
