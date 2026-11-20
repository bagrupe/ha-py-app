// Generated from Expressions.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExpressionsBaseVisitor.dart';
import 'ExpressionsVisitor.dart';

const int RULE_expressionFile = 0,
    RULE_expression = 1,
    RULE_call = 2,
    RULE_callParams = 3,
    RULE_value = 4;

class ExpressionsParser extends Parser {
  static final checkVersion = () =>
      RuntimeMetaData.checkVersion('4.13.1', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
    _ATN.numberOfDecisions,
    (i) => DFA(_ATN.getDecisionState(i), i),
  );
  static final PredictionContextCache _sharedContextCache =
      PredictionContextCache();
  static const int TOKEN_Location = 1,
      TOKEN_Number = 2,
      TOKEN_Bool = 3,
      TOKEN_LeftParen = 4,
      TOKEN_RightParen = 5,
      TOKEN_LeftBracket = 6,
      TOKEN_RightBracket = 7,
      TOKEN_PLUS = 8,
      TOKEN_MINUS = 9,
      TOKEN_TIMES = 10,
      TOKEN_DIV = 11,
      TOKEN_GT = 12,
      TOKEN_GTEQ = 13,
      TOKEN_LT = 14,
      TOKEN_LTEQ = 15,
      TOKEN_EQ = 16,
      TOKEN_NEQ = 17,
      TOKEN_POINT = 18,
      TOKEN_AND = 19,
      TOKEN_OR = 20,
      TOKEN_COMMA = 21,
      TOKEN_Identifier = 22,
      TOKEN_String = 23,
      TOKEN_WS = 24;

  @override
  final List<String> ruleNames = [
    'expressionFile',
    'expression',
    'call',
    'callParams',
    'value',
  ];

  static final List<String?> _LITERAL_NAMES = [
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
  static final List<String?> _SYMBOLIC_NAMES = [
    null,
    "Location",
    "Number",
    "Bool",
    "LeftParen",
    "RightParen",
    "LeftBracket",
    "RightBracket",
    "PLUS",
    "MINUS",
    "TIMES",
    "DIV",
    "GT",
    "GTEQ",
    "LT",
    "LTEQ",
    "EQ",
    "NEQ",
    "POINT",
    "AND",
    "OR",
    "COMMA",
    "Identifier",
    "String",
    "WS",
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(
    _LITERAL_NAMES,
    _SYMBOLIC_NAMES,
  );

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'Expressions.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
    return _ATN;
  }

  ExpressionsParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(
      this,
      _ATN,
      _decisionToDFA,
      _sharedContextCache,
    );
  }

  ExpressionFileContext expressionFile() {
    dynamic _localctx = ExpressionFileContext(context, state);
    enterRule(_localctx, 0, RULE_expressionFile);
    try {
      enterOuterAlt(_localctx, 1);
      state = 10;
      expression(0);
      state = 11;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ExpressionContext expression([int _p = 0]) {
    final _parentctx = context;
    final _parentState = state;
    dynamic _localctx = ExpressionContext(context, _parentState);
    var _prevctx = _localctx;
    var _startState = 2;
    enterRecursionRule(_localctx, 2, RULE_expression, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 21;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 0, context)) {
        case 1:
          _localctx = BracketsContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 14;
          match(TOKEN_LeftParen);
          state = 15;
          _localctx.expr = expression(0);
          state = 16;
          match(TOKEN_RightParen);
          break;
        case 2:
          _localctx = ExprCallContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 18;
          call();
          break;
        case 3:
          _localctx = ExprValueContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 19;
          value();
          break;
        case 4:
          _localctx = IdContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 20;
          match(TOKEN_Identifier);
          break;
      }
      context!.stop = tokenStream.LT(-1);
      state = 43;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 2, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 41;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 1, context)) {
            case 1:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 23;
              if (!(precpred(context, 9))) {
                throw FailedPredicateException(this, "precpred(context, 9)");
              }
              state = 24;
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_TIMES || _la == TOKEN_DIV)) {
                errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 25;
              _localctx.right = expression(10);
              break;
            case 2:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 26;
              if (!(precpred(context, 8))) {
                throw FailedPredicateException(this, "precpred(context, 8)");
              }
              state = 27;
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_PLUS || _la == TOKEN_MINUS)) {
                errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 28;
              _localctx.right = expression(9);
              break;
            case 3:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 29;
              if (!(precpred(context, 7))) {
                throw FailedPredicateException(this, "precpred(context, 7)");
              }
              state = 30;
              _la = tokenStream.LA(1)!;
              if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 61440) != 0))) {
                errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 31;
              _localctx.right = expression(8);
              break;
            case 4:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 32;
              if (!(precpred(context, 6))) {
                throw FailedPredicateException(this, "precpred(context, 6)");
              }
              state = 33;
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_EQ || _la == TOKEN_NEQ)) {
                errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 34;
              _localctx.right = expression(7);
              break;
            case 5:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 35;
              if (!(precpred(context, 5))) {
                throw FailedPredicateException(this, "precpred(context, 5)");
              }
              state = 36;
              match(TOKEN_AND);
              state = 37;
              _localctx.right = expression(6);
              break;
            case 6:
              _localctx = OperatorContext(
                new ExpressionContext(_parentctx, _parentState),
              );
              _localctx.left = _prevctx;
              pushNewRecursionContext(_localctx, _startState, RULE_expression);
              state = 38;
              if (!(precpred(context, 4))) {
                throw FailedPredicateException(this, "precpred(context, 4)");
              }
              state = 39;
              match(TOKEN_OR);
              state = 40;
              _localctx.right = expression(5);
              break;
          }
        }
        state = 45;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 2, context);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      unrollRecursionContexts(_parentctx);
    }
    return _localctx;
  }

  CallContext call() {
    dynamic _localctx = CallContext(context, state);
    enterRule(_localctx, 4, RULE_call);
    try {
      enterOuterAlt(_localctx, 1);
      state = 46;
      _localctx.name = match(TOKEN_Identifier);
      state = 47;
      match(TOKEN_LeftParen);
      state = 48;
      _localctx.parameter = callParams();
      state = 49;
      match(TOKEN_RightParen);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  CallParamsContext callParams() {
    dynamic _localctx = CallParamsContext(context, state);
    enterRule(_localctx, 6, RULE_callParams);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 51;
      expression(0);
      state = 56;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_COMMA) {
        state = 52;
        match(TOKEN_COMMA);
        state = 53;
        expression(0);
        state = 58;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ValueContext value() {
    dynamic _localctx = ValueContext(context, state);
    enterRule(_localctx, 8, RULE_value);
    try {
      state = 63;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_Number:
          _localctx = NumberValueContext(_localctx);
          enterOuterAlt(_localctx, 1);
          state = 59;
          match(TOKEN_Number);
          break;
        case TOKEN_String:
          _localctx = StringValueContext(_localctx);
          enterOuterAlt(_localctx, 2);
          state = 60;
          match(TOKEN_String);
          break;
        case TOKEN_Bool:
          _localctx = BoolValueContext(_localctx);
          enterOuterAlt(_localctx, 3);
          state = 61;
          match(TOKEN_Bool);
          break;
        case TOKEN_Location:
          _localctx = LocationValueContext(_localctx);
          enterOuterAlt(_localctx, 4);
          state = 62;
          match(TOKEN_Location);
          break;
        default:
          throw NoViableAltException(this);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  @override
  bool sempred(RuleContext? _localctx, int ruleIndex, int predIndex) {
    switch (ruleIndex) {
      case 1:
        return _expression_sempred(_localctx as ExpressionContext?, predIndex);
    }
    return true;
  }

  bool _expression_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0:
        return precpred(context, 9);
      case 1:
        return precpred(context, 8);
      case 2:
        return precpred(context, 7);
      case 3:
        return precpred(context, 6);
      case 4:
        return precpred(context, 5);
      case 5:
        return precpred(context, 4);
    }
    return true;
  }

  static const List<int> _serializedATN = [
    4,
    1,
    24,
    66,
    2,
    0,
    7,
    0,
    2,
    1,
    7,
    1,
    2,
    2,
    7,
    2,
    2,
    3,
    7,
    3,
    2,
    4,
    7,
    4,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    3,
    1,
    22,
    8,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    5,
    1,
    42,
    8,
    1,
    10,
    1,
    12,
    1,
    45,
    9,
    1,
    1,
    2,
    1,
    2,
    1,
    2,
    1,
    2,
    1,
    2,
    1,
    3,
    1,
    3,
    1,
    3,
    5,
    3,
    55,
    8,
    3,
    10,
    3,
    12,
    3,
    58,
    9,
    3,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    3,
    4,
    64,
    8,
    4,
    1,
    4,
    0,
    1,
    2,
    5,
    0,
    2,
    4,
    6,
    8,
    0,
    4,
    1,
    0,
    10,
    11,
    1,
    0,
    8,
    9,
    1,
    0,
    12,
    15,
    1,
    0,
    16,
    17,
    73,
    0,
    10,
    1,
    0,
    0,
    0,
    2,
    21,
    1,
    0,
    0,
    0,
    4,
    46,
    1,
    0,
    0,
    0,
    6,
    51,
    1,
    0,
    0,
    0,
    8,
    63,
    1,
    0,
    0,
    0,
    10,
    11,
    3,
    2,
    1,
    0,
    11,
    12,
    5,
    0,
    0,
    1,
    12,
    1,
    1,
    0,
    0,
    0,
    13,
    14,
    6,
    1,
    -1,
    0,
    14,
    15,
    5,
    4,
    0,
    0,
    15,
    16,
    3,
    2,
    1,
    0,
    16,
    17,
    5,
    5,
    0,
    0,
    17,
    22,
    1,
    0,
    0,
    0,
    18,
    22,
    3,
    4,
    2,
    0,
    19,
    22,
    3,
    8,
    4,
    0,
    20,
    22,
    5,
    22,
    0,
    0,
    21,
    13,
    1,
    0,
    0,
    0,
    21,
    18,
    1,
    0,
    0,
    0,
    21,
    19,
    1,
    0,
    0,
    0,
    21,
    20,
    1,
    0,
    0,
    0,
    22,
    43,
    1,
    0,
    0,
    0,
    23,
    24,
    10,
    9,
    0,
    0,
    24,
    25,
    7,
    0,
    0,
    0,
    25,
    42,
    3,
    2,
    1,
    10,
    26,
    27,
    10,
    8,
    0,
    0,
    27,
    28,
    7,
    1,
    0,
    0,
    28,
    42,
    3,
    2,
    1,
    9,
    29,
    30,
    10,
    7,
    0,
    0,
    30,
    31,
    7,
    2,
    0,
    0,
    31,
    42,
    3,
    2,
    1,
    8,
    32,
    33,
    10,
    6,
    0,
    0,
    33,
    34,
    7,
    3,
    0,
    0,
    34,
    42,
    3,
    2,
    1,
    7,
    35,
    36,
    10,
    5,
    0,
    0,
    36,
    37,
    5,
    19,
    0,
    0,
    37,
    42,
    3,
    2,
    1,
    6,
    38,
    39,
    10,
    4,
    0,
    0,
    39,
    40,
    5,
    20,
    0,
    0,
    40,
    42,
    3,
    2,
    1,
    5,
    41,
    23,
    1,
    0,
    0,
    0,
    41,
    26,
    1,
    0,
    0,
    0,
    41,
    29,
    1,
    0,
    0,
    0,
    41,
    32,
    1,
    0,
    0,
    0,
    41,
    35,
    1,
    0,
    0,
    0,
    41,
    38,
    1,
    0,
    0,
    0,
    42,
    45,
    1,
    0,
    0,
    0,
    43,
    41,
    1,
    0,
    0,
    0,
    43,
    44,
    1,
    0,
    0,
    0,
    44,
    3,
    1,
    0,
    0,
    0,
    45,
    43,
    1,
    0,
    0,
    0,
    46,
    47,
    5,
    22,
    0,
    0,
    47,
    48,
    5,
    4,
    0,
    0,
    48,
    49,
    3,
    6,
    3,
    0,
    49,
    50,
    5,
    5,
    0,
    0,
    50,
    5,
    1,
    0,
    0,
    0,
    51,
    56,
    3,
    2,
    1,
    0,
    52,
    53,
    5,
    21,
    0,
    0,
    53,
    55,
    3,
    2,
    1,
    0,
    54,
    52,
    1,
    0,
    0,
    0,
    55,
    58,
    1,
    0,
    0,
    0,
    56,
    54,
    1,
    0,
    0,
    0,
    56,
    57,
    1,
    0,
    0,
    0,
    57,
    7,
    1,
    0,
    0,
    0,
    58,
    56,
    1,
    0,
    0,
    0,
    59,
    64,
    5,
    2,
    0,
    0,
    60,
    64,
    5,
    23,
    0,
    0,
    61,
    64,
    5,
    3,
    0,
    0,
    62,
    64,
    5,
    1,
    0,
    0,
    63,
    59,
    1,
    0,
    0,
    0,
    63,
    60,
    1,
    0,
    0,
    0,
    63,
    61,
    1,
    0,
    0,
    0,
    63,
    62,
    1,
    0,
    0,
    0,
    64,
    9,
    1,
    0,
    0,
    0,
    5,
    21,
    41,
    43,
    56,
    63,
  ];

  static final ATN _ATN = ATNDeserializer().deserialize(_serializedATN);
}

class ExpressionFileContext extends ParserRuleContext {
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  TerminalNode? EOF() => getToken(ExpressionsParser.TOKEN_EOF, 0);
  ExpressionFileContext([ParserRuleContext? parent, int? invokingState])
    : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_expressionFile;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitExpressionFile(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ExpressionContext extends ParserRuleContext {
  ExpressionContext([ParserRuleContext? parent, int? invokingState])
    : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_expression;

  @override
  void copyFrom(ParserRuleContext ctx) {
    super.copyFrom(ctx);
  }
}

class CallContext extends ParserRuleContext {
  Token? name;
  CallParamsContext? parameter;
  TerminalNode? LeftParen() => getToken(ExpressionsParser.TOKEN_LeftParen, 0);
  TerminalNode? RightParen() => getToken(ExpressionsParser.TOKEN_RightParen, 0);
  TerminalNode? Identifier() => getToken(ExpressionsParser.TOKEN_Identifier, 0);
  CallParamsContext? callParams() => getRuleContext<CallParamsContext>(0);
  CallContext([ParserRuleContext? parent, int? invokingState])
    : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_call;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitCall(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class CallParamsContext extends ParserRuleContext {
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  List<TerminalNode> COMMAs() => getTokens(ExpressionsParser.TOKEN_COMMA);
  TerminalNode? COMMA(int i) => getToken(ExpressionsParser.TOKEN_COMMA, i);
  CallParamsContext([ParserRuleContext? parent, int? invokingState])
    : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_callParams;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitCallParams(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ValueContext extends ParserRuleContext {
  ValueContext([ParserRuleContext? parent, int? invokingState])
    : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_value;

  @override
  void copyFrom(ParserRuleContext ctx) {
    super.copyFrom(ctx);
  }
}

class ExprCallContext extends ExpressionContext {
  CallContext? call() => getRuleContext<CallContext>(0);
  ExprCallContext(ExpressionContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitExprCall(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ExprValueContext extends ExpressionContext {
  ValueContext? value() => getRuleContext<ValueContext>(0);
  ExprValueContext(ExpressionContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitExprValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class IdContext extends ExpressionContext {
  TerminalNode? Identifier() => getToken(ExpressionsParser.TOKEN_Identifier, 0);
  IdContext(ExpressionContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitId(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class OperatorContext extends ExpressionContext {
  ExpressionContext? left;
  ExpressionContext? right;
  List<ExpressionContext> expressions() => getRuleContexts<ExpressionContext>();
  ExpressionContext? expression(int i) => getRuleContext<ExpressionContext>(i);
  TerminalNode? TIMES() => getToken(ExpressionsParser.TOKEN_TIMES, 0);
  TerminalNode? DIV() => getToken(ExpressionsParser.TOKEN_DIV, 0);
  TerminalNode? PLUS() => getToken(ExpressionsParser.TOKEN_PLUS, 0);
  TerminalNode? MINUS() => getToken(ExpressionsParser.TOKEN_MINUS, 0);
  TerminalNode? LT() => getToken(ExpressionsParser.TOKEN_LT, 0);
  TerminalNode? LTEQ() => getToken(ExpressionsParser.TOKEN_LTEQ, 0);
  TerminalNode? GT() => getToken(ExpressionsParser.TOKEN_GT, 0);
  TerminalNode? GTEQ() => getToken(ExpressionsParser.TOKEN_GTEQ, 0);
  TerminalNode? EQ() => getToken(ExpressionsParser.TOKEN_EQ, 0);
  TerminalNode? NEQ() => getToken(ExpressionsParser.TOKEN_NEQ, 0);
  TerminalNode? AND() => getToken(ExpressionsParser.TOKEN_AND, 0);
  TerminalNode? OR() => getToken(ExpressionsParser.TOKEN_OR, 0);
  OperatorContext(ExpressionContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitOperator(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BracketsContext extends ExpressionContext {
  ExpressionContext? expr;
  TerminalNode? LeftParen() => getToken(ExpressionsParser.TOKEN_LeftParen, 0);
  TerminalNode? RightParen() => getToken(ExpressionsParser.TOKEN_RightParen, 0);
  ExpressionContext? expression() => getRuleContext<ExpressionContext>(0);
  BracketsContext(ExpressionContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitBrackets(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class StringValueContext extends ValueContext {
  TerminalNode? String() => getToken(ExpressionsParser.TOKEN_String, 0);
  StringValueContext(ValueContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitStringValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BoolValueContext extends ValueContext {
  TerminalNode? Bool() => getToken(ExpressionsParser.TOKEN_Bool, 0);
  BoolValueContext(ValueContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitBoolValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumberValueContext extends ValueContext {
  TerminalNode? Number() => getToken(ExpressionsParser.TOKEN_Number, 0);
  NumberValueContext(ValueContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitNumberValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class LocationValueContext extends ValueContext {
  TerminalNode? Location() => getToken(ExpressionsParser.TOKEN_Location, 0);
  LocationValueContext(ValueContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExpressionsVisitor<T>) {
      return visitor.visitLocationValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
