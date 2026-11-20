// Generated from Expressions.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExpressionsParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [ExpressionsParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class ExpressionsVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [ExpressionsParser.expressionFile].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExpressionFile(ExpressionFileContext ctx);

  /// Visit a parse tree produced by the {@code exprCall}
  /// labeled alternative in {@link ExpressionsParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExprCall(ExprCallContext ctx);

  /// Visit a parse tree produced by the {@code exprValue}
  /// labeled alternative in {@link ExpressionsParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExprValue(ExprValueContext ctx);

  /// Visit a parse tree produced by the {@code id}
  /// labeled alternative in {@link ExpressionsParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitId(IdContext ctx);

  /// Visit a parse tree produced by the {@code operator}
  /// labeled alternative in {@link ExpressionsParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOperator(OperatorContext ctx);

  /// Visit a parse tree produced by the {@code brackets}
  /// labeled alternative in {@link ExpressionsParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBrackets(BracketsContext ctx);

  /// Visit a parse tree produced by [ExpressionsParser.call].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCall(CallContext ctx);

  /// Visit a parse tree produced by [ExpressionsParser.callParams].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCallParams(CallParamsContext ctx);

  /// Visit a parse tree produced by the {@code numberValue}
  /// labeled alternative in {@link ExpressionsParser#value}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumberValue(NumberValueContext ctx);

  /// Visit a parse tree produced by the {@code stringValue}
  /// labeled alternative in {@link ExpressionsParser#value}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStringValue(StringValueContext ctx);

  /// Visit a parse tree produced by the {@code boolValue}
  /// labeled alternative in {@link ExpressionsParser#value}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBoolValue(BoolValueContext ctx);

  /// Visit a parse tree produced by the {@code locationValue}
  /// labeled alternative in {@link ExpressionsParser#value}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLocationValue(LocationValueContext ctx);
}
