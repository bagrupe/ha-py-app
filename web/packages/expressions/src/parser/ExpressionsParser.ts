// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-nocheck
// Generated from Expressions.g4 by ANTLR 4.13.1

import * as antlr from 'antlr4ng';
import {type Token} from 'antlr4ng';

import {type ExpressionsVisitor} from './ExpressionsVisitor.js';

// for running tests with parameters, TODO: discuss strategy for typed parameters in CI
// eslint-disable-next-line no-unused-vars
type int = number;

export class ExpressionsParser extends antlr.Parser {
  public static readonly Location = 1;
  public static readonly Number = 2;
  public static readonly Bool = 3;
  public static readonly LeftParen = 4;
  public static readonly RightParen = 5;
  public static readonly LeftBracket = 6;
  public static readonly RightBracket = 7;
  public static readonly PLUS = 8;
  public static readonly MINUS = 9;
  public static readonly TIMES = 10;
  public static readonly DIV = 11;
  public static readonly GT = 12;
  public static readonly GTEQ = 13;
  public static readonly LT = 14;
  public static readonly LTEQ = 15;
  public static readonly EQ = 16;
  public static readonly NEQ = 17;
  public static readonly POINT = 18;
  public static readonly AND = 19;
  public static readonly OR = 20;
  public static readonly COMMA = 21;
  public static readonly Identifier = 22;
  public static readonly String = 23;
  public static readonly WS = 24;
  public static readonly RULE_expressionFile = 0;
  public static readonly RULE_expression = 1;
  public static readonly RULE_call = 2;
  public static readonly RULE_callParams = 3;
  public static readonly RULE_value = 4;

  public static readonly literalNames = [
    null,
    null,
    null,
    null,
    "'('",
    "')'",
    "'['",
    "']'",
    "'+'",
    "'-'",
    "'*'",
    "'/'",
    "'>'",
    "'>='",
    "'<'",
    "'<='",
    "'=='",
    "'!='",
    "'.'",
    "'&&'",
    "'||'",
    "','",
  ];

  public static readonly symbolicNames = [
    null,
    'Location',
    'Number',
    'Bool',
    'LeftParen',
    'RightParen',
    'LeftBracket',
    'RightBracket',
    'PLUS',
    'MINUS',
    'TIMES',
    'DIV',
    'GT',
    'GTEQ',
    'LT',
    'LTEQ',
    'EQ',
    'NEQ',
    'POINT',
    'AND',
    'OR',
    'COMMA',
    'Identifier',
    'String',
    'WS',
  ];
  public static readonly ruleNames = [
    'expressionFile',
    'expression',
    'call',
    'callParams',
    'value',
  ];

  public get grammarFileName(): string {
    return 'Expressions.g4';
  }
  public get literalNames(): (string | null)[] {
    return ExpressionsParser.literalNames;
  }
  public get symbolicNames(): (string | null)[] {
    return ExpressionsParser.symbolicNames;
  }
  public get ruleNames(): string[] {
    return ExpressionsParser.ruleNames;
  }
  public get serializedATN(): number[] {
    return ExpressionsParser._serializedATN;
  }

  protected createFailedPredicateException(
    predicate?: string,
    message?: string,
  ): antlr.FailedPredicateException {
    return new antlr.FailedPredicateException(this, predicate, message);
  }

  public constructor(input: antlr.TokenStream) {
    super(input);
    this.interpreter = new antlr.ParserATNSimulator(
      this,
      ExpressionsParser._ATN,
      ExpressionsParser.decisionsToDFA,
      new antlr.PredictionContextCache(),
    );
  }
  public expressionFile(): ExpressionFileContext {
    const localContext = new ExpressionFileContext(this.context, this.state);
    this.enterRule(localContext, 0, ExpressionsParser.RULE_expressionFile);
    try {
      this.enterOuterAlt(localContext, 1);
      {
        this.state = 10;
        this.expression(0);
        this.state = 11;
        this.match(ExpressionsParser.EOF);
      }
    } catch (re) {
      if (re instanceof antlr.RecognitionException) {
        localContext.exception = re;
        this.errorHandler.reportError(this, re);
        this.errorHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localContext;
  }

  public expression(): ExpressionContext;
  public expression(_p: number): ExpressionContext;
  public expression(_p?: number): ExpressionContext {
    if (_p === undefined) {
      _p = 0;
    }

    const parentContext = this.context;
    const parentState = this.state;
    let localContext = new ExpressionContext(this.context, parentState);
    let previousContext = localContext;
    const _startState = 2;
    this.enterRecursionRule(
      localContext,
      2,
      ExpressionsParser.RULE_expression,
      _p,
    );
    let _la: number;
    try {
      let alternative: number;
      this.enterOuterAlt(localContext, 1);
      {
        this.state = 21;
        this.errorHandler.sync(this);
        switch (
          this.interpreter.adaptivePredict(this.tokenStream, 0, this.context)
        ) {
          case 1:
            {
              localContext = new BracketsContext(localContext);
              this.context = localContext;
              previousContext = localContext;

              this.state = 14;
              this.match(ExpressionsParser.LeftParen);
              this.state = 15;
              (localContext as BracketsContext)._expr = this.expression(0);
              this.state = 16;
              this.match(ExpressionsParser.RightParen);
            }
            break;
          case 2:
            {
              localContext = new ExprCallContext(localContext);
              this.context = localContext;
              previousContext = localContext;
              this.state = 18;
              this.call();
            }
            break;
          case 3:
            {
              localContext = new ExprValueContext(localContext);
              this.context = localContext;
              previousContext = localContext;
              this.state = 19;
              this.value();
            }
            break;
          case 4:
            {
              localContext = new IdContext(localContext);
              this.context = localContext;
              previousContext = localContext;
              this.state = 20;
              this.match(ExpressionsParser.Identifier);
            }
            break;
        }
        this.context!.stop = this.tokenStream.LT(-1);
        this.state = 43;
        this.errorHandler.sync(this);
        alternative = this.interpreter.adaptivePredict(
          this.tokenStream,
          2,
          this.context,
        );
        while (
          alternative !== 2 &&
          alternative !== antlr.ATN.INVALID_ALT_NUMBER
        ) {
          if (alternative === 1) {
            if (this._parseListeners != null) {
              this.triggerExitRuleEvent();
            }
            previousContext = localContext;
            {
              this.state = 41;
              this.errorHandler.sync(this);
              switch (
                this.interpreter.adaptivePredict(
                  this.tokenStream,
                  1,
                  this.context,
                )
              ) {
                case 1:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 23;
                    if (!this.precpred(this.context, 9)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 9)',
                      );
                    }
                    this.state = 24;
                    _la = this.tokenStream.LA(1);
                    if (!(_la === 10 || _la === 11)) {
                      this.errorHandler.recoverInline(this);
                    } else {
                      this.errorHandler.reportMatch(this);
                      this.consume();
                    }
                    this.state = 25;
                    (localContext as OperatorContext)._right =
                      this.expression(10);
                  }
                  break;
                case 2:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 26;
                    if (!this.precpred(this.context, 8)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 8)',
                      );
                    }
                    this.state = 27;
                    _la = this.tokenStream.LA(1);
                    if (!(_la === 8 || _la === 9)) {
                      this.errorHandler.recoverInline(this);
                    } else {
                      this.errorHandler.reportMatch(this);
                      this.consume();
                    }
                    this.state = 28;
                    (localContext as OperatorContext)._right =
                      this.expression(9);
                  }
                  break;
                case 3:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 29;
                    if (!this.precpred(this.context, 7)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 7)',
                      );
                    }
                    this.state = 30;
                    _la = this.tokenStream.LA(1);
                    if (!((_la & ~0x1f) === 0 && ((1 << _la) & 61440) !== 0)) {
                      this.errorHandler.recoverInline(this);
                    } else {
                      this.errorHandler.reportMatch(this);
                      this.consume();
                    }
                    this.state = 31;
                    (localContext as OperatorContext)._right =
                      this.expression(8);
                  }
                  break;
                case 4:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 32;
                    if (!this.precpred(this.context, 6)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 6)',
                      );
                    }
                    this.state = 33;
                    _la = this.tokenStream.LA(1);
                    if (!(_la === 16 || _la === 17)) {
                      this.errorHandler.recoverInline(this);
                    } else {
                      this.errorHandler.reportMatch(this);
                      this.consume();
                    }
                    this.state = 34;
                    (localContext as OperatorContext)._right =
                      this.expression(7);
                  }
                  break;
                case 5:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 35;
                    if (!this.precpred(this.context, 5)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 5)',
                      );
                    }
                    this.state = 36;
                    this.match(ExpressionsParser.AND);
                    this.state = 37;
                    (localContext as OperatorContext)._right =
                      this.expression(6);
                  }
                  break;
                case 6:
                  {
                    localContext = new OperatorContext(
                      new ExpressionContext(parentContext, parentState),
                    );
                    (localContext as OperatorContext)._left = previousContext;
                    this.pushNewRecursionContext(
                      localContext,
                      _startState,
                      ExpressionsParser.RULE_expression,
                    );
                    this.state = 38;
                    if (!this.precpred(this.context, 4)) {
                      throw this.createFailedPredicateException(
                        'this.precpred(this.context, 4)',
                      );
                    }
                    this.state = 39;
                    this.match(ExpressionsParser.OR);
                    this.state = 40;
                    (localContext as OperatorContext)._right =
                      this.expression(5);
                  }
                  break;
              }
            }
          }
          this.state = 45;
          this.errorHandler.sync(this);
          alternative = this.interpreter.adaptivePredict(
            this.tokenStream,
            2,
            this.context,
          );
        }
      }
    } catch (re) {
      if (re instanceof antlr.RecognitionException) {
        localContext.exception = re;
        this.errorHandler.reportError(this, re);
        this.errorHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.unrollRecursionContexts(parentContext);
    }
    return localContext;
  }
  public call(): CallContext {
    const localContext = new CallContext(this.context, this.state);
    this.enterRule(localContext, 4, ExpressionsParser.RULE_call);
    try {
      this.enterOuterAlt(localContext, 1);
      {
        this.state = 46;
        localContext._name = this.match(ExpressionsParser.Identifier);
        this.state = 47;
        this.match(ExpressionsParser.LeftParen);
        this.state = 48;
        localContext._parameter = this.callParams();
        this.state = 49;
        this.match(ExpressionsParser.RightParen);
      }
    } catch (re) {
      if (re instanceof antlr.RecognitionException) {
        localContext.exception = re;
        this.errorHandler.reportError(this, re);
        this.errorHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localContext;
  }
  public callParams(): CallParamsContext {
    const localContext = new CallParamsContext(this.context, this.state);
    this.enterRule(localContext, 6, ExpressionsParser.RULE_callParams);
    let _la: number;
    try {
      this.enterOuterAlt(localContext, 1);
      {
        this.state = 51;
        this.expression(0);
        this.state = 56;
        this.errorHandler.sync(this);
        _la = this.tokenStream.LA(1);
        while (_la === 21) {
          {
            {
              this.state = 52;
              this.match(ExpressionsParser.COMMA);
              this.state = 53;
              this.expression(0);
            }
          }
          this.state = 58;
          this.errorHandler.sync(this);
          _la = this.tokenStream.LA(1);
        }
      }
    } catch (re) {
      if (re instanceof antlr.RecognitionException) {
        localContext.exception = re;
        this.errorHandler.reportError(this, re);
        this.errorHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localContext;
  }
  public value(): ValueContext {
    let localContext = new ValueContext(this.context, this.state);
    this.enterRule(localContext, 8, ExpressionsParser.RULE_value);
    try {
      this.state = 63;
      this.errorHandler.sync(this);
      switch (this.tokenStream.LA(1)) {
        case ExpressionsParser.Number:
          localContext = new NumberValueContext(localContext);
          this.enterOuterAlt(localContext, 1);
          {
            this.state = 59;
            this.match(ExpressionsParser.Number);
          }
          break;
        case ExpressionsParser.String:
          localContext = new StringValueContext(localContext);
          this.enterOuterAlt(localContext, 2);
          {
            this.state = 60;
            this.match(ExpressionsParser.String);
          }
          break;
        case ExpressionsParser.Bool:
          localContext = new BoolValueContext(localContext);
          this.enterOuterAlt(localContext, 3);
          {
            this.state = 61;
            this.match(ExpressionsParser.Bool);
          }
          break;
        case ExpressionsParser.Location:
          localContext = new LocationValueContext(localContext);
          this.enterOuterAlt(localContext, 4);
          {
            this.state = 62;
            this.match(ExpressionsParser.Location);
          }
          break;
        default:
          throw new antlr.NoViableAltException(this);
      }
    } catch (re) {
      if (re instanceof antlr.RecognitionException) {
        localContext.exception = re;
        this.errorHandler.reportError(this, re);
        this.errorHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localContext;
  }

  public override sempred(
    localContext: antlr.RuleContext | null,
    ruleIndex: number,
    predIndex: number,
  ): boolean {
    switch (ruleIndex) {
      case 1:
        return this.expression_sempred(
          localContext as ExpressionContext,
          predIndex,
        );
    }
    return true;
  }
  private expression_sempred(
    localContext: ExpressionContext | null,
    predIndex: number,
  ): boolean {
    switch (predIndex) {
      case 0:
        return this.precpred(this.context, 9);
      case 1:
        return this.precpred(this.context, 8);
      case 2:
        return this.precpred(this.context, 7);
      case 3:
        return this.precpred(this.context, 6);
      case 4:
        return this.precpred(this.context, 5);
      case 5:
        return this.precpred(this.context, 4);
    }
    return true;
  }

  public static readonly _serializedATN: number[] = [
    4, 1, 24, 66, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 1,
    0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 22, 8,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 1, 42, 8, 1, 10, 1, 12, 1, 45, 9, 1,
    1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 5, 3, 55, 8, 3, 10, 3, 12,
    3, 58, 9, 3, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 64, 8, 4, 1, 4, 0, 1, 2, 5, 0, 2,
    4, 6, 8, 0, 4, 1, 0, 10, 11, 1, 0, 8, 9, 1, 0, 12, 15, 1, 0, 16, 17, 73, 0,
    10, 1, 0, 0, 0, 2, 21, 1, 0, 0, 0, 4, 46, 1, 0, 0, 0, 6, 51, 1, 0, 0, 0, 8,
    63, 1, 0, 0, 0, 10, 11, 3, 2, 1, 0, 11, 12, 5, 0, 0, 1, 12, 1, 1, 0, 0, 0,
    13, 14, 6, 1, -1, 0, 14, 15, 5, 4, 0, 0, 15, 16, 3, 2, 1, 0, 16, 17, 5, 5,
    0, 0, 17, 22, 1, 0, 0, 0, 18, 22, 3, 4, 2, 0, 19, 22, 3, 8, 4, 0, 20, 22, 5,
    22, 0, 0, 21, 13, 1, 0, 0, 0, 21, 18, 1, 0, 0, 0, 21, 19, 1, 0, 0, 0, 21,
    20, 1, 0, 0, 0, 22, 43, 1, 0, 0, 0, 23, 24, 10, 9, 0, 0, 24, 25, 7, 0, 0, 0,
    25, 42, 3, 2, 1, 10, 26, 27, 10, 8, 0, 0, 27, 28, 7, 1, 0, 0, 28, 42, 3, 2,
    1, 9, 29, 30, 10, 7, 0, 0, 30, 31, 7, 2, 0, 0, 31, 42, 3, 2, 1, 8, 32, 33,
    10, 6, 0, 0, 33, 34, 7, 3, 0, 0, 34, 42, 3, 2, 1, 7, 35, 36, 10, 5, 0, 0,
    36, 37, 5, 19, 0, 0, 37, 42, 3, 2, 1, 6, 38, 39, 10, 4, 0, 0, 39, 40, 5, 20,
    0, 0, 40, 42, 3, 2, 1, 5, 41, 23, 1, 0, 0, 0, 41, 26, 1, 0, 0, 0, 41, 29, 1,
    0, 0, 0, 41, 32, 1, 0, 0, 0, 41, 35, 1, 0, 0, 0, 41, 38, 1, 0, 0, 0, 42, 45,
    1, 0, 0, 0, 43, 41, 1, 0, 0, 0, 43, 44, 1, 0, 0, 0, 44, 3, 1, 0, 0, 0, 45,
    43, 1, 0, 0, 0, 46, 47, 5, 22, 0, 0, 47, 48, 5, 4, 0, 0, 48, 49, 3, 6, 3, 0,
    49, 50, 5, 5, 0, 0, 50, 5, 1, 0, 0, 0, 51, 56, 3, 2, 1, 0, 52, 53, 5, 21, 0,
    0, 53, 55, 3, 2, 1, 0, 54, 52, 1, 0, 0, 0, 55, 58, 1, 0, 0, 0, 56, 54, 1, 0,
    0, 0, 56, 57, 1, 0, 0, 0, 57, 7, 1, 0, 0, 0, 58, 56, 1, 0, 0, 0, 59, 64, 5,
    2, 0, 0, 60, 64, 5, 23, 0, 0, 61, 64, 5, 3, 0, 0, 62, 64, 5, 1, 0, 0, 63,
    59, 1, 0, 0, 0, 63, 60, 1, 0, 0, 0, 63, 61, 1, 0, 0, 0, 63, 62, 1, 0, 0, 0,
    64, 9, 1, 0, 0, 0, 5, 21, 41, 43, 56, 63,
  ];

  private static __ATN: antlr.ATN;
  public static get _ATN(): antlr.ATN {
    if (!ExpressionsParser.__ATN) {
      ExpressionsParser.__ATN = new antlr.ATNDeserializer().deserialize(
        ExpressionsParser._serializedATN,
      );
    }

    return ExpressionsParser.__ATN;
  }

  private static readonly vocabulary = new antlr.Vocabulary(
    ExpressionsParser.literalNames,
    ExpressionsParser.symbolicNames,
    [],
  );

  public override get vocabulary(): antlr.Vocabulary {
    return ExpressionsParser.vocabulary;
  }

  private static readonly decisionsToDFA =
    ExpressionsParser._ATN.decisionToState.map(
      (ds: antlr.DecisionState, index: number) => new antlr.DFA(ds, index),
    );
}

export class ExpressionFileContext extends antlr.ParserRuleContext {
  public constructor(
    parent: antlr.ParserRuleContext | null,
    invokingState: number,
  ) {
    super(parent, invokingState);
  }
  public expression(): ExpressionContext {
    return this.getRuleContext(0, ExpressionContext)!;
  }
  public EOF(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.EOF, 0)!;
  }
  public override get ruleIndex(): number {
    return ExpressionsParser.RULE_expressionFile;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitExpressionFile) {
      return visitor.visitExpressionFile(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

export class ExpressionContext extends antlr.ParserRuleContext {
  public constructor(
    parent: antlr.ParserRuleContext | null,
    invokingState: number,
  ) {
    super(parent, invokingState);
  }
  public override get ruleIndex(): number {
    return ExpressionsParser.RULE_expression;
  }
  public override copyFrom(ctx: ExpressionContext): void {
    super.copyFrom(ctx);
  }
}
export class ExprCallContext extends ExpressionContext {
  public constructor(ctx: ExpressionContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public call(): CallContext {
    return this.getRuleContext(0, CallContext)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitExprCall) {
      return visitor.visitExprCall(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class ExprValueContext extends ExpressionContext {
  public constructor(ctx: ExpressionContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public value(): ValueContext {
    return this.getRuleContext(0, ValueContext)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitExprValue) {
      return visitor.visitExprValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class IdContext extends ExpressionContext {
  public constructor(ctx: ExpressionContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public Identifier(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.Identifier, 0)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitId) {
      return visitor.visitId(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class OperatorContext extends ExpressionContext {
  public _left?: ExpressionContext;
  public _right?: ExpressionContext;
  public constructor(ctx: ExpressionContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public expression(): ExpressionContext[];
  public expression(i: number): ExpressionContext | null;
  public expression(
    i?: number,
  ): ExpressionContext[] | ExpressionContext | null {
    if (i === undefined) {
      return this.getRuleContexts(ExpressionContext);
    }

    return this.getRuleContext(i, ExpressionContext);
  }
  public TIMES(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.TIMES, 0);
  }
  public DIV(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.DIV, 0);
  }
  public PLUS(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.PLUS, 0);
  }
  public MINUS(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.MINUS, 0);
  }
  public LT(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.LT, 0);
  }
  public LTEQ(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.LTEQ, 0);
  }
  public GT(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.GT, 0);
  }
  public GTEQ(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.GTEQ, 0);
  }
  public EQ(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.EQ, 0);
  }
  public NEQ(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.NEQ, 0);
  }
  public AND(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.AND, 0);
  }
  public OR(): antlr.TerminalNode | null {
    return this.getToken(ExpressionsParser.OR, 0);
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitOperator) {
      return visitor.visitOperator(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class BracketsContext extends ExpressionContext {
  public _expr?: ExpressionContext;
  public constructor(ctx: ExpressionContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public LeftParen(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.LeftParen, 0)!;
  }
  public RightParen(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.RightParen, 0)!;
  }
  public expression(): ExpressionContext {
    return this.getRuleContext(0, ExpressionContext)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitBrackets) {
      return visitor.visitBrackets(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

export class CallContext extends antlr.ParserRuleContext {
  public _name?: Token | null;
  public _parameter?: CallParamsContext;
  public constructor(
    parent: antlr.ParserRuleContext | null,
    invokingState: number,
  ) {
    super(parent, invokingState);
  }
  public LeftParen(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.LeftParen, 0)!;
  }
  public RightParen(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.RightParen, 0)!;
  }
  public Identifier(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.Identifier, 0)!;
  }
  public callParams(): CallParamsContext {
    return this.getRuleContext(0, CallParamsContext)!;
  }
  public override get ruleIndex(): number {
    return ExpressionsParser.RULE_call;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitCall) {
      return visitor.visitCall(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

export class CallParamsContext extends antlr.ParserRuleContext {
  public constructor(
    parent: antlr.ParserRuleContext | null,
    invokingState: number,
  ) {
    super(parent, invokingState);
  }
  public expression(): ExpressionContext[];
  public expression(i: number): ExpressionContext | null;
  public expression(
    i?: number,
  ): ExpressionContext[] | ExpressionContext | null {
    if (i === undefined) {
      return this.getRuleContexts(ExpressionContext);
    }

    return this.getRuleContext(i, ExpressionContext);
  }
  public COMMA(): antlr.TerminalNode[];
  public COMMA(i: number): antlr.TerminalNode | null;
  public COMMA(i?: number): antlr.TerminalNode | null | antlr.TerminalNode[] {
    if (i === undefined) {
      return this.getTokens(ExpressionsParser.COMMA);
    } else {
      return this.getToken(ExpressionsParser.COMMA, i);
    }
  }
  public override get ruleIndex(): number {
    return ExpressionsParser.RULE_callParams;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitCallParams) {
      return visitor.visitCallParams(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

export class ValueContext extends antlr.ParserRuleContext {
  public constructor(
    parent: antlr.ParserRuleContext | null,
    invokingState: number,
  ) {
    super(parent, invokingState);
  }
  public override get ruleIndex(): number {
    return ExpressionsParser.RULE_value;
  }
  public override copyFrom(ctx: ValueContext): void {
    super.copyFrom(ctx);
  }
}
export class StringValueContext extends ValueContext {
  public constructor(ctx: ValueContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public String(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.String, 0)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitStringValue) {
      return visitor.visitStringValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class BoolValueContext extends ValueContext {
  public constructor(ctx: ValueContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public Bool(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.Bool, 0)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitBoolValue) {
      return visitor.visitBoolValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class NumberValueContext extends ValueContext {
  public constructor(ctx: ValueContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public Number(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.Number, 0)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitNumberValue) {
      return visitor.visitNumberValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
export class LocationValueContext extends ValueContext {
  public constructor(ctx: ValueContext) {
    super(ctx.parent, ctx.invokingState);
    super.copyFrom(ctx);
  }
  public Location(): antlr.TerminalNode {
    return this.getToken(ExpressionsParser.Location, 0)!;
  }
  public override accept<Result>(
    visitor: ExpressionsVisitor<Result>,
  ): Result | null {
    if (visitor.visitLocationValue) {
      return visitor.visitLocationValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
