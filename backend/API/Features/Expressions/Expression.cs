using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using API.Features.Expressions.Parser;

namespace API.Features.Expressions;

/// <summary>Basisklasse für Ausdrücke mit geparstem Kontext.</summary>
public abstract class Expression {
    /// <summary>Der ursprüngliche Ausdruck als Zeichenkette.</summary>
    public string ExpressionString { get; }
    /// <summary>Geparster Ausdruckskontext.</summary>
    public ExpressionsParser.ExpressionContext Context { get; }

    /// <summary>Initialisiert einen Ausdruck und parst den Ausdrucksstring.</summary>
    /// <param name="expression">Der Ausdruck als Zeichenkette.</param>
    public Expression(string expression) {
        ExpressionString = expression;
        Context = ParseExpressionString(expression);
    }

    private static ExpressionsParser.ExpressionContext ParseExpressionString(string expression) {
        AntlrInputStream inputStream = new AntlrInputStream(expression);
        var lexer = new ExpressionsLexer(inputStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(lexer);
        var parser = new ExpressionsParser(commonTokenStream) {
            ErrorHandler = ErrorStrategy,
        };

        try {
            return parser.expressionFile().expression();
        } catch (ParseCanceledException e) {
            throw new ExpressionParseException(expression, e);
        }
    }

    /// <summary>Gibt den Ausdruck als Zeichenkette zurück.</summary>
    public override string ToString() {
        return ExpressionString;
    }

    private static BailErrorStrategy ErrorStrategy = new();

    private class ThrowingErrorStrategy : DefaultErrorStrategy {
        public override void ReportError(Antlr4.Runtime.Parser recognizer, RecognitionException e) {
            throw e;
        }
    }
}

/// <summary>Repräsentiert einen String-Ausdruck.</summary>
public class StringExpression : Expression {
    /// <summary>Konvertiert einen String implizit in einen StringExpression.</summary>
    /// <param name="value">Der Stringwert.</param>
    public static implicit operator StringExpression(string value) {
        return new StringExpression("\"" + value
            .Replace(@"\", @"\\")
            .Replace("\"", @"\" + "\"")
            + "\""
        );
    }

    public StringExpression(string expression) : base(expression) { }
}

/// <summary>Repräsentiert einen booleschen Ausdruck.</summary>
public class BoolExpression : Expression {
    /// <summary>Konvertiert einen booleschen Wert implizit in einen BoolExpression.</summary>
    /// <param name="value">Der boolesche Wert.</param>
    public static implicit operator BoolExpression(bool value) {
        return new BoolExpression(value ? "true" : "false");
    }

    public BoolExpression(string expression) : base(expression) { }

    /// <summary>Gibt an, ob der Ausdruck immer true ist.</summary>
    public bool AlwaysTrue => ExpressionString.Trim() == "true";
}

/// <summary>Repräsentiert einen Integer-Ausdruck.</summary>
public class IntExpression : Expression {
    /// <summary>Konvertiert einen Integer implizit in einen IntExpression.</summary>
    /// <param name="value">Der Integerwert.</param>
    public static implicit operator IntExpression(int value) {
        return new IntExpression(value.ToString());
    }

    public IntExpression(string expression) : base(expression) { }
}

/// <summary>Repräsentiert einen Orts-Ausdruck.</summary>
public class LocationExpression : Expression {
    /// <summary>Konvertiert einen ParsedLocation implizit in einen LocationExpression.</summary>
    /// <param name="value">Der geparste Ort.</param>
    public static implicit operator LocationExpression(EvaluatingVisitor.ParsedLocation value) {
        return new LocationExpression($"[{value.Lat},{value.Lng}]");
    }

    public LocationExpression(string expression) : base(expression) { }
}

/// <summary>Typen von Ausdruckswerten als Flags.</summary>
[Flags]
public enum ExpressionValueType {
    Unknown = 0,
    String = 1,
    Int = 2,
    Bool = 4,
    Date = 8,
    Location = 16,
    Upload = 32,
    Identifier = 64,
}

/// <summary>Besucher zur Typprüfung von Ausdrücken.</summary>
public class TypecheckingVisitor : ExpressionsBaseVisitor<ExpressionValueType> {
    private readonly Dictionary<string, ExpressionValueType> _slotTypes;

    /// <summary>Initialisiert den Besucher mit bekannten Slot-Typen.</summary>
    /// <param name="slotTypes">Zuordnung von Slotnamen zu Typen.</param>
    public TypecheckingVisitor(Dictionary<string, ExpressionValueType> slotTypes) {
        _slotTypes = slotTypes;
    }

    public override ExpressionValueType VisitExpressionFile(ExpressionsParser.ExpressionFileContext context) {
        return Visit(context.expression());
    }

    public override ExpressionValueType VisitExprCall(ExpressionsParser.ExprCallContext context) {
        return Visit(context.call());
    }

    public override ExpressionValueType VisitExprValue(ExpressionsParser.ExprValueContext context) {
        return Visit(context.value());
    }

    public override ExpressionValueType VisitId(ExpressionsParser.IdContext context) {
        if (context.Identifier().GetText() != "slot") {
            throw new UnknownIdentifier(context.Identifier().GetText());
        }

        return ExpressionValueType.Identifier;
    }

    public override ExpressionValueType VisitOperator(ExpressionsParser.OperatorContext context) {
        var left = Visit(context.left);
        var right = Visit(context.right);

        if (context.EQ() != null || context.NEQ() != null) {
            if (left != right) {
                throw new ExpressionTypeMismatchException(context.GetText(), left, context.left.GetText(), right, context.right.GetText());
            }

            return ExpressionValueType.Bool;
        } else if (context.GT() != null || context.GTEQ() != null || context.LT() != null || context.LTEQ() != null) {
            if (left != right) {
                throw new ExpressionTypeMismatchException(context.GetText(), left, context.left.GetText(), right, context.right.GetText());
            }

            if (left != ExpressionValueType.Int && left != ExpressionValueType.String) {
                throw new ExpressionTypeMismatchException(context.GetText(), ExpressionValueType.Int | ExpressionValueType.String, left);
            }

            if (right != ExpressionValueType.Int && right != ExpressionValueType.String) {
                throw new ExpressionTypeMismatchException(context.GetText(), ExpressionValueType.Int | ExpressionValueType.String, right);
            }

            return ExpressionValueType.Bool;
        } else if (context.PLUS() != null) {
            if (left != ExpressionValueType.Int && left != ExpressionValueType.String) {
                throw new ExpressionTypeMismatchException(context.GetText(), ExpressionValueType.Int | ExpressionValueType.String, left);
            }

            if (right != ExpressionValueType.Int && right != ExpressionValueType.String) {
                throw new ExpressionTypeMismatchException(context.GetText(), ExpressionValueType.Int | ExpressionValueType.String, right);
            }

            if (left != right) {
                throw new ExpressionTypeMismatchException(context.GetText(), left, context.left.GetText(), right, context.right.GetText());
            }

            return left;
        } else if (context.MINUS() != null || context.TIMES() != null || context.DIV() != null) {
            if (left != ExpressionValueType.Int) {
                throw new ExpressionTypeMismatchException(context.left.GetText(), ExpressionValueType.Int, left);
            }

            if (right != ExpressionValueType.Int) {
                throw new ExpressionTypeMismatchException(context.right.GetText(), ExpressionValueType.Int, right);
            }

            return ExpressionValueType.Int;
        } else if (context.AND() != null || context.OR() != null) {
            if (left != ExpressionValueType.Bool) {
                throw new ExpressionTypeMismatchException(context.left.GetText(), ExpressionValueType.Bool, left);
            }

            if (right != ExpressionValueType.Bool) {
                throw new ExpressionTypeMismatchException(context.right.GetText(), ExpressionValueType.Bool, right);
            }

            return ExpressionValueType.Bool;
        } else {
            throw new NotImplementedException();
        }
    }

    public override ExpressionValueType VisitBrackets(ExpressionsParser.BracketsContext context) {
        return Visit(context.expr);
    }

    public override ExpressionValueType VisitCall(ExpressionsParser.CallContext context) {
        var functionName = context.Identifier().GetText();

        switch (functionName) {
            case "slot": {
                    var slotNameExpression = context.parameter.expression();
                    if (slotNameExpression.Length != 1) {
                        throw new NotImplementedException("Invalid parameter length. Only 1 parameter is supported");
                    }
                    var slotNameValueType = Visit(slotNameExpression[0]);

                    if (slotNameValueType != ExpressionValueType.String) {
                        throw new ExpressionTypeMismatchException(slotNameExpression[0].GetText(), ExpressionValueType.String, slotNameValueType);
                    }

                    var slotName = slotNameExpression[0].GetChild<ExpressionsParser.StringValueContext>(0)?.GetText();

                    if (slotName != null) {
                        var strippedSlotName = slotName[1..^1];

                        if (_slotTypes.TryGetValue(strippedSlotName, out var slotType)) {
                            return slotType;
                        }

                        throw new ExpressionSlotNameNotFoundException(context.GetText(), slotName);
                    }

                    return ExpressionValueType.Unknown;
                }
            case "isInside": {
                    var isInsideExpression = context.parameter.expression();
                    if (isInsideExpression.Length != 2) {
                        throw new NotImplementedException("Invalid parameter length. isInside requires 2 parameter");
                    }
                    var nameParameterValueType = Visit(isInsideExpression[0]);
                    var locationParameterValueType = Visit(isInsideExpression[1]);

                    if (nameParameterValueType != ExpressionValueType.String) {
                        throw new ExpressionTypeMismatchException(isInsideExpression[0].GetText(), ExpressionValueType.String, nameParameterValueType);
                    }

                    if (locationParameterValueType != ExpressionValueType.Location) {
                        throw new ExpressionTypeMismatchException(isInsideExpression[1].GetText(), ExpressionValueType.Location, locationParameterValueType);
                    }

                    return ExpressionValueType.Bool;
                }
            default:
                throw new NotImplementedException("Function " + functionName + " not implemented");
        }
    }

    public override ExpressionValueType VisitNumberValue(ExpressionsParser.NumberValueContext context) {
        return ExpressionValueType.Int;
    }

    public override ExpressionValueType VisitStringValue(ExpressionsParser.StringValueContext context) {
        return ExpressionValueType.String;
    }

    public override ExpressionValueType VisitBoolValue(ExpressionsParser.BoolValueContext context) {
        return ExpressionValueType.Bool;
    }
}

/// <summary>Ausnahme bei Fehlern beim Parsen von Ausdrücken.</summary>
public class ExpressionParseException : Exception {
    public ExpressionParseException(string expression, Exception innerException) : base($"Error while parsing expression \"{expression}\"", innerException) { }
}

/// <summary>Ausnahme bei Typinkonsistenzen in Ausdrücken.</summary>
public class ExpressionTypeMismatchException : Exception {
    public ExpressionTypeMismatchException(string expression, ExpressionValueType expected, ExpressionValueType actual) : base($"In expression \"{expression}\" expected expression of type {expected}, but got {actual}") { }

    public ExpressionTypeMismatchException(string expression, ExpressionValueType left, string leftExpression, ExpressionValueType right, string rightExpression) : base($"In expression \"{expression}\" expected left expression (\"{leftExpression}\") of type {left} to match right expression (\"{rightExpression}\") of type {right}") { }
}

/// <summary>Ausnahme bei unbekanntem Slotnamen in Ausdrücken.</summary>
public class ExpressionSlotNameNotFoundException : Exception {
    public ExpressionSlotNameNotFoundException(string expression, string slotName) : base($"In expression \"{expression}\" slot name \"{slotName}\" not found") { }
}

/// <summary>Ausnahme bei unbekanntem Bezeichner in Ausdrücken.</summary>
public class UnknownIdentifier : Exception {
    public UnknownIdentifier(string identifierName) : base($"Identifier \"{identifierName}\" is unknown") { }
}
