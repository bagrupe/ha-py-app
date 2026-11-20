using API.Features.Expressions.Parser;

namespace API.Features.Expressions;

/// <summary>Besucher zur Ermittlung aller verwendeten Slot-Namen in einem Ausdruck.</summary>
public class UsedSlotNamesVisitor : ExpressionsBaseVisitor<List<string>> {
    /// <summary>Besucht die Wurzel des Ausdrucks und sammelt Slot-Namen.</summary>
    /// <param name="context">Der Kontext des Ausdrucksdatei-Knotens.</param>
    public override List<string> VisitExpressionFile(ExpressionsParser.ExpressionFileContext context) {
        return Visit(context.expression());
    }

    /// <summary>Besucht einen Funktionsaufruf-Ausdruck und sammelt Slot-Namen.</summary>
    /// <param name="context">Der Kontext des Funktionsaufruf-Ausdrucks.</param>
    public override List<string> VisitExprCall(ExpressionsParser.ExprCallContext context) {
        return Visit(context.call());
    }

    /// <summary>Besucht einen Wert-Ausdruck und sammelt Slot-Namen.</summary>
    /// <param name="context">Der Kontext des Wert-Ausdrucks.</param>
    public override List<string> VisitExprValue(ExpressionsParser.ExprValueContext context) {
        return Visit(context.value());
    }

    /// <summary>Besucht eine Id und liefert eine leere Liste zurück.</summary>
    /// <param name="context">Der Kontext der Id.</param>
    public override List<string> VisitId(ExpressionsParser.IdContext context) {
        return [];
    }

    /// <summary>Besucht einen Operator-Ausdruck und kombiniert die Slot-Namen der linken und rechten Seite.</summary>
    /// <param name="context">Der Kontext des Operator-Ausdrucks.</param>
    public override List<string> VisitOperator(ExpressionsParser.OperatorContext context) {
        var left = Visit(context.left);
        var right = Visit(context.right);

        return left.Concat(right).ToList();
    }

    /// <summary>Besucht einen Ausdruck in Klammern und sammelt Slot-Namen daraus.</summary>
    /// <param name="context">Der Kontext des Klammer-Ausdrucks.</param>
    public override List<string> VisitBrackets(ExpressionsParser.BracketsContext context) {
        return Visit(context.expr);
    }

    /// <summary>Besucht einen Funktionsaufruf und extrahiert bei Funktion "slot" den Slot-Namen.</summary>
    /// <param name="context">Der Kontext des Funktionsaufrufs.</param>
    public override List<string> VisitCall(ExpressionsParser.CallContext context) {
        var functionName = context.Identifier().GetText();

        if (functionName == "slot") {
            var slotNameExpression = context.parameter.expression();
            if (slotNameExpression.Length != 1) {
                throw new NotImplementedException("Invalid parameter length. Only 1 parameter is supported");
            }

            var slotName = slotNameExpression[0].GetChild<ExpressionsParser.StringValueContext>(0)?.GetText();

            return [slotName![1..^1]];
        }

        throw new NotImplementedException("Function " + functionName + " not implemented");
    }

    /// <summary>Besucht einen Zahlenwert und liefert eine leere Liste zurück.</summary>
    /// <param name="context">Der Kontext des Zahlenwerts.</param>
    public override List<string> VisitNumberValue(ExpressionsParser.NumberValueContext context) {
        return [];
    }

    /// <summary>Besucht einen Stringwert und liefert eine leere Liste zurück.</summary>
    /// <param name="context">Der Kontext des Stringwerts.</param>
    public override List<string> VisitStringValue(ExpressionsParser.StringValueContext context) {
        return [];
    }

    /// <summary>Besucht einen Booleschen Wert und liefert eine leere Liste zurück.</summary>
    /// <param name="context">Der Kontext des Booleschen Werts.</param>
    public override List<string> VisitBoolValue(ExpressionsParser.BoolValueContext context) {
        return [];
    }
}
