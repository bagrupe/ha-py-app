grammar Expressions;

expressionFile
    : expression EOF;

// Follows JavaScript operator precedence
expression
    : LeftParen expr=expression RightParen #brackets
    | left=expression (TIMES | DIV) right=expression  #operator
    | left=expression (PLUS | MINUS) right=expression #operator
    | left=expression (LT | LTEQ | GT | GTEQ) right=expression #operator
    | left=expression (EQ | NEQ) right=expression #operator
    | left=expression AND right=expression #operator
    | left=expression OR right=expression #operator
    | call #exprCall
    | value #exprValue
    | Identifier #id
    ;

call
    : name=Identifier LeftParen parameter=callParams RightParen;

callParams
  :  expression (COMMA expression)*
  ;

value
    : Number #numberValue
    | String #stringValue
    | Bool #boolValue
    | Location #locationValue
    ;

Location
    : LeftBracket Number COMMA Number RightBracket
    ;

Number
    : NonzeroDigit Digit*
    | NonzeroDigit Digit* POINT Digit+
    ;

fragment Digit
    : [0-9]
    ;

fragment NonzeroDigit
    : [1-9]
    ;

Bool
    : 'true'
    | 'false'
    ;

LeftParen
    : '('
    ;

RightParen
    : ')'
    ;

LeftBracket
    : '['
    ;

RightBracket
    : ']'
    ;

PLUS
    : '+'
    ;

MINUS
    : '-'
    ;

TIMES
    : '*'
    ;

DIV
    : '/'
    ;

GT
    : '>'
    ;

GTEQ
    : '>='
    ;

LT
    : '<'
    ;

LTEQ
    : '<='
    ;

EQ
    : '=='
    ;

NEQ
    : '!='
    ;

POINT
    : '.'
    ;

AND: '&&';
OR: '||';
COMMA: ',';

Identifier: IdentifierStart IdentifierPart*;

fragment IdentifierPart: IdentifierStart | [\p{Mn}] | [\p{Nd}] | [\p{Pc}] | '\u200C' | '\u200D';

fragment IdentifierStart: [\p{L}] | [$_];


String
    : '"' DoubleStringCharacter* '"' | '\'' SingleStringCharacter* '\''
    ;

fragment SingleStringCharacter: ~['\\] | '\\' EscapeSequence;
fragment DoubleStringCharacter: ~["\\] | '\\' EscapeSequence;

fragment EscapeSequence:
    CharacterEscapeSequence
;

fragment CharacterEscapeSequence: SingleEscapeCharacter | NonEscapeCharacter;

fragment SingleEscapeCharacter: ['"\\bfnrtv];

fragment NonEscapeCharacter: ~['"\\bfnrtv0-9xu\r\n];

fragment EscapeCharacter: SingleEscapeCharacter | [0-9] | [xu];

WS
    : [ \r\n\t]+ -> skip
    ;
