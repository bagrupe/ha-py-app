import {CharStreams, CommonTokenStream} from 'antlr4ng';
import {ExpressionErrorListener} from './expression-error-listener.ts';
import {ExpressionsLexer} from './parser/ExpressionsLexer.ts';
import {
  ExpressionsParser,
  type BoolValueContext,
  type BracketsContext,
  type CallContext,
  type ExprCallContext,
  type ExpressionContext,
  type ExpressionFileContext,
  type ExprValueContext,
  type IdContext,
  type NumberValueContext,
  type OperatorContext,
  type StringValueContext,
} from './parser/ExpressionsParser.ts';
import {ExpressionsVisitor} from './parser/ExpressionsVisitor.ts';

/**
 * Abstrakte Basisklasse für Ausdrücke, die einen Ausdruck parst und auswertbar macht.
 */
export abstract class Expression {
  public readonly parsed: ExpressionContext;

  /**
   * Erstellt eine neue Instanz und parst den übergebenen Ausdruck.
   * @param expression Der Ausdruck als String.
   */
  public constructor(public readonly expression: string) {
    const inputStream = CharStreams.fromString(expression);
    const lexer = new ExpressionsLexer(inputStream);
    const tokenStream = new CommonTokenStream(lexer);
    const parser = new ExpressionsParser(tokenStream);
    // We remove the default listener which writes errors to stdout
    // We rather want to throw and catch parser errors.
    parser.removeErrorListeners();
    parser.addErrorListener(new ExpressionErrorListener());

    this.parsed = parser.expressionFile().expression()!;
  }

  /**
   * Wertet den Ausdruck mit den gegebenen Slots aus.
   * @param slots Ein Objekt mit Werten für Platzhalter im Ausdruck.
   * @returns Das Ergebnis der Auswertung.
   */
  evaluate(slots: Record<string, unknown>): unknown {
    return new EvaluatingVisitor(slots).visit(this.parsed);
  }

  /**
   * Wandelt den Ausdruck in einen JSON-kompatiblen String um.
   * Diese Methode wird implizit von JSON.stringify aufgerufen.
   * @returns Der ursprüngliche Ausdruck als String.
   */
  // noinspection JSUnusedGlobalSymbols
  toJSON(): string {
    return this.expression;
  }
}

/**
 * Klasse für boolesche Ausdrücke.
 */
export class BoolExpression extends Expression {
  /**
   * Wertet den booleschen Ausdruck aus.
   * @param slots Werte für Platzhalter.
   * @returns Das Ergebnis als boolean.
   */
  evaluate(slots: Record<string, unknown>): boolean {
    return super.evaluate(slots) as boolean;
  }
}

/**
 * Klasse für String-Ausdrücke.
 */
export class StringExpression extends Expression {
  /**
   * Wertet den String-Ausdruck aus.
   * @param slots Werte für Platzhalter.
   * @returns Das Ergebnis als string.
   */
  evaluate(slots: Record<string, unknown>): string {
    return super.evaluate(slots) as string;
  }
}

/**
 * Klasse für Ganzzahl-Ausdrücke.
 */
export class IntExpression extends Expression {
  /**
   * Wertet den Ganzzahl-Ausdruck aus.
   * @param slots Werte für Platzhalter.
   * @returns Das Ergebnis als number.
   */
  evaluate(slots: Record<string, unknown>): number {
    return super.evaluate(slots) as number;
  }
}

/**
 * Visitor zur Auswertung der geparsten Ausdrücke.
 */
class EvaluatingVisitor extends ExpressionsVisitor<unknown> {
  /**
   * Erstellt einen neuen Visitor mit den gegebenen Slots.
   * @param slots Werte für Platzhalter im Ausdruck.
   */
  constructor(private slots: Record<string, unknown>) {
    super();
  }

  visitExpressionFile = (ctx: ExpressionFileContext): unknown =>
    this.visit(ctx.expression());

  visitExprCall = (ctx: ExprCallContext): unknown => this.visit(ctx.call());

  visitExprValue = (ctx: ExprValueContext): unknown => this.visit(ctx.value());

  visitId = (ctx: IdContext): unknown => ctx.Identifier().getText();

  visitOperator = (ctx: OperatorContext): unknown => {
    if (ctx.EQ() !== null) {
      return this.visit(ctx._left!) === this.visit(ctx._right!);
    }

    if (ctx.NEQ() !== null) {
      return this.visit(ctx._left!) !== this.visit(ctx._right!);
    }

    if (ctx.GT() !== null) {
      return (
        (this.visit(ctx._left!) as string | number) >
        (this.visit(ctx._right!) as string | number)
      );
    }

    if (ctx.GTEQ() !== null) {
      return (
        (this.visit(ctx._left!) as string | number) >=
        (this.visit(ctx._right!) as string | number)
      );
    }

    if (ctx.LT() !== null) {
      return (
        (this.visit(ctx._left!) as string | number) <
        (this.visit(ctx._right!) as string | number)
      );
    }

    if (ctx.LTEQ() !== null) {
      return (
        (this.visit(ctx._left!) as string | number) <=
        (this.visit(ctx._right!) as string | number)
      );
    }

    if (ctx.AND() !== null) {
      return this.visit(ctx._left!) && this.visit(ctx._right!);
    }

    if (ctx.OR() !== null) {
      return this.visit(ctx._left!) || this.visit(ctx._right!);
    }

    if (ctx.PLUS() !== null) {
      return (
        (this.visit(ctx._left!) as string) + (this.visit(ctx._right!) as string)
      );
    }

    if (ctx.MINUS() !== null) {
      return (
        (this.visit(ctx._left!) as number) - (this.visit(ctx._right!) as number)
      );
    }

    if (ctx.TIMES() !== null) {
      return (
        (this.visit(ctx._left!) as number) * (this.visit(ctx._right!) as number)
      );
    }

    if (ctx.DIV() !== null) {
      return (
        (this.visit(ctx._left!) as number) / (this.visit(ctx._right!) as number)
      );
    }

    throw new Error(`Unknown operator ${ctx}`);
  };

  visitBrackets = (ctx: BracketsContext): unknown =>
    this.visit(ctx.expression());

  /**
   * Wertet Funktionsaufrufe im Ausdruck aus.
   * Unterstützt aktuell 'slot' und 'isInside'.
   * @param ctx Kontext des Funktionsaufrufs.
   * @returns Ergebnis der Funktion.
   */
  visitCall = (ctx: CallContext): unknown => {
    const functionName = ctx._name!.text;
    switch (functionName) {
      case 'slot': {
        const parameter = this.visit(ctx._parameter!);

        return this.slots[parameter as string];
      }
      case 'isInside':
        // Todo implement handling
        // const expressions = ctx._parameter?.expression() ?? [];
        // const nameParameter = expressions[0];
        // const locationParameter = expressions[1];
        // const strippedNameParameter = await this.visit(nameParameter);
        //
        // const location = await this.visit(locationParameter) as FormLocation;
        //   const isInside = await geoservice.isPointInGeoflaeche(
        //   strippedNameParameter,
        //   location.position,
        // );

        return false;

      default:
        throw new Error(`Unknown function ${functionName}`);
    }
  };

  visitNumberValue = (ctx: NumberValueContext): unknown =>
    parseInt(ctx.Number().getText(), 10);

  visitStringValue = (ctx: StringValueContext): unknown =>
    ctx
      .String()
      .getText()
      .slice(1, -1)
      .replace(/\\(.?)/g, (_, found) => {
        switch (found) {
          case '\\':
            return '\\';
          case '':
            return '';
          default:
            return found;
        }
      });

  visitBoolValue = (ctx: BoolValueContext): unknown =>
    ctx.Bool().getText() === 'true';
}
