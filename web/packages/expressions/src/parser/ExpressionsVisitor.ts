// Generated from Expressions.g4 by ANTLR 4.13.1

import {AbstractParseTreeVisitor} from 'antlr4ng';

import {
  type ExpressionFileContext,
  type ExprCallContext,
  type ExprValueContext,
  type IdContext,
  type OperatorContext,
  type BracketsContext,
  type CallContext,
  type CallParamsContext,
  type NumberValueContext,
  type StringValueContext,
  type BoolValueContext,
  type LocationValueContext,
} from './ExpressionsParser.js';

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by `ExpressionsParser`.
 *
 * @param <Result> The return type of the visit operation. Use `void` for
 * operations with no return type.
 */
export class ExpressionsVisitor<
  Result,
> extends AbstractParseTreeVisitor<Result> {
  /**
   * Visit a parse tree produced by `ExpressionsParser.expressionFile`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitExpressionFile?: (ctx: ExpressionFileContext) => Result;
  /**
   * Visit a parse tree produced by the `exprCall`
   * labeled alternative in `ExpressionsParser.expression`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitExprCall?: (ctx: ExprCallContext) => Result;
  /**
   * Visit a parse tree produced by the `exprValue`
   * labeled alternative in `ExpressionsParser.expression`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitExprValue?: (ctx: ExprValueContext) => Result;
  /**
   * Visit a parse tree produced by the `id`
   * labeled alternative in `ExpressionsParser.expression`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitId?: (ctx: IdContext) => Result;
  /**
   * Visit a parse tree produced by the `operator`
   * labeled alternative in `ExpressionsParser.expression`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitOperator?: (ctx: OperatorContext) => Result;
  /**
   * Visit a parse tree produced by the `brackets`
   * labeled alternative in `ExpressionsParser.expression`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitBrackets?: (ctx: BracketsContext) => Result;
  /**
   * Visit a parse tree produced by `ExpressionsParser.call`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitCall?: (ctx: CallContext) => Result;
  /**
   * Visit a parse tree produced by `ExpressionsParser.callParams`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitCallParams?: (ctx: CallParamsContext) => Result;
  /**
   * Visit a parse tree produced by the `numberValue`
   * labeled alternative in `ExpressionsParser.value`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitNumberValue?: (ctx: NumberValueContext) => Result;
  /**
   * Visit a parse tree produced by the `stringValue`
   * labeled alternative in `ExpressionsParser.value`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitStringValue?: (ctx: StringValueContext) => Result;
  /**
   * Visit a parse tree produced by the `boolValue`
   * labeled alternative in `ExpressionsParser.value`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitBoolValue?: (ctx: BoolValueContext) => Result;
  /**
   * Visit a parse tree produced by the `locationValue`
   * labeled alternative in `ExpressionsParser.value`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitLocationValue?: (ctx: LocationValueContext) => Result;
}
