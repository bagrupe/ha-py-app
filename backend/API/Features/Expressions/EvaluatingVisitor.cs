using System.Text.Json;
using API.Features.Expressions.Parser;
using API.Features.Geo;
using API.Features.Prozess;

namespace API.Features.Expressions;

/// <summary>
/// Dienst zur Auswertung von Ausdrücken mit Kontextinformationen.
/// </summary>
public class EvaluatingVisitorService(GeoService geoService) {
    /// <summary>
    /// Wertet einen String-Ausdruck aus und liefert das Ergebnis als Zeichenkette zurück.
    /// </summary>
    /// <param name="stringExpression">Der auszuwertende String-Ausdruck.</param>
    /// <param name="currentSlotValues">Aktuelle Werte der Slots.</param>
    /// <param name="kommuneId">Identifikator der Kommune.</param>
    /// <returns>Ausgewerteter String.</returns>
    public string Evaluate(StringExpression stringExpression,
        IReadOnlyDictionary<string, SlotValue> currentSlotValues, Guid kommuneId) {
        var visitor = new EvaluatingVisitor(currentSlotValues, geoService, kommuneId);
        return visitor.Visit(stringExpression.Context) as string ?? throw new InvalidOperationException();
    }

    /// <summary>
    /// Wertet einen Booleschen Ausdruck aus und liefert das Ergebnis als bool zurück.
    /// </summary>
    /// <param name="boolExpression">Der auszuwertende Boolesche Ausdruck.</param>
    /// <param name="currentSlotValues">Aktuelle Werte der Slots.</param>
    /// <param name="kommuneId">Identifikator der Kommune.</param>
    /// <returns>Ausgewerteter boolescher Wert.</returns>
    public bool Evaluate(BoolExpression boolExpression,
        IReadOnlyDictionary<string, SlotValue> currentSlotValues, Guid kommuneId) {
        var visitor = new EvaluatingVisitor(currentSlotValues, geoService, kommuneId);
        return visitor.Visit(boolExpression.Context) as bool? ?? throw new InvalidOperationException();
    }

    /// <summary>
    /// Wertet einen Integer-Ausdruck aus und liefert das Ergebnis als int zurück.
    /// </summary>
    /// <param name="intExpression">Der auszuwertende Integer-Ausdruck.</param>
    /// <param name="currentSlotValues">Aktuelle Werte der Slots.</param>
    /// <param name="kommuneId">Identifikator der Kommune.</param>
    /// <returns>Ausgewerteter Integer-Wert.</returns>
    public int Evaluate(IntExpression intExpression,
        IReadOnlyDictionary<string, SlotValue> currentSlotValues, Guid kommuneId) {
        var visitor = new EvaluatingVisitor(currentSlotValues, geoService, kommuneId);
        return visitor.Visit(intExpression.Context) as int? ?? throw new InvalidOperationException();
    }

    /// <summary>
    /// Wertet einen Orts-Ausdruck aus und liefert das Ergebnis als ParsedLocation zurück.
    /// </summary>
    /// <param name="locationExpression">Der auszuwertende Orts-Ausdruck.</param>
    /// <param name="currentSlotValues">Aktuelle Werte der Slots.</param>
    /// <param name="kommuneId">Identifikator der Kommune.</param>
    /// <returns>Ausgewerteter Ort als ParsedLocation.</returns>
    public EvaluatingVisitor.ParsedLocation Evaluate(LocationExpression locationExpression,
        IReadOnlyDictionary<string, SlotValue> currentSlotValues, Guid kommuneId) {
        var visitor = new EvaluatingVisitor(currentSlotValues, geoService, kommuneId);
        return visitor.Visit(locationExpression.Context) as EvaluatingVisitor.ParsedLocation ??
               throw new InvalidOperationException();
    }
}

/// <summary>
/// Besucher zur Auswertung von Ausdrucksbäumen mit dynamischen Ergebnistypen.
/// </summary>
/// <param name="currentSlotValues">Aktuelle Werte der Slots.</param>
/// <param name="geoService">Dienst zur Geodatenverarbeitung.</param>
/// <param name="kommuneId">Identifikator der Kommune.</param>
public class EvaluatingVisitor(
    IReadOnlyDictionary<string, SlotValue> currentSlotValues,
    GeoService geoService,
    Guid kommuneId)
    : ExpressionsBaseVisitor<dynamic> {
    /// <summary>
    /// Besucht die Wurzel des Ausdrucks und wertet den enthaltenen Ausdruck aus.
    /// </summary>
    public override dynamic VisitExpressionFile(ExpressionsParser.ExpressionFileContext context) {
        return Visit(context.expression());
    }

    /// <summary>
    /// Besucht einen Funktionsaufruf-Ausdruck und wertet ihn aus.
    /// </summary>
    public override dynamic VisitExprCall(ExpressionsParser.ExprCallContext context) {
        return Visit(context.call());
    }

    /// <summary>
    /// Besucht einen Wert-Ausdruck und wertet ihn aus.
    /// </summary>
    public override dynamic VisitExprValue(ExpressionsParser.ExprValueContext context) {
        return Visit(context.value());
    }

    /// <summary>
    /// Besucht eine Id und wirft eine Ausnahme, da diese nicht direkt ausgewertet wird.
    /// </summary>
    public override dynamic VisitId(ExpressionsParser.IdContext context) {
        throw new InvalidOperationException();
    }

    /// <summary>
    /// Wertet einen Operator-Ausdruck aus und führt die entsprechende Operation aus.
    /// </summary>
    public override dynamic VisitOperator(ExpressionsParser.OperatorContext context) {
        var left = Visit(context.left);
        var right = Visit(context.right);

        if (context.EQ() != null) {
            return Visit(context.left) == Visit(context.right);
        }

        if (context.NEQ() != null) {
            return Visit(context.left) != Visit(context.right);
        }

        if (context.GT() != null) {
            return Visit(context.left) > Visit(context.right);
        }

        if (context.GTEQ() != null) {
            return Visit(context.left) >= Visit(context.right);
        }

        if (context.LT() != null) {
            return Visit(context.left) < Visit(context.right);
        }

        if (context.LTEQ() != null) {
            return Visit(context.left) <= Visit(context.right);
        }

        if (context.AND() != null) {
            return Visit(context.left) && Visit(context.right);
        }

        if (context.OR() != null) {
            return Visit(context.left) || Visit(context.right);
        }

        if (context.PLUS() != null) {
            return Visit(context.left) + Visit(context.right);
        }

        if (context.MINUS() != null) {
            return Visit(context.left) - Visit(context.right);
        }

        if (context.TIMES() != null) {
            return Visit(context.left) * Visit(context.right);
        }

        if (context.DIV() != null) {
            return Visit(context.left) / Visit(context.right);
        }

        throw new InvalidOperationException("Operator not implemented");
    }

    /// <summary>
    /// Wertet einen Ausdruck in Klammern aus.
    /// </summary>
    public override dynamic VisitBrackets(ExpressionsParser.BracketsContext context) {
        return Visit(context.expr);
    }

    /// <summary>
    /// Wertet einen Funktionsaufruf aus und delegiert an die passende Implementierung.
    /// </summary>
    public override dynamic VisitCall(ExpressionsParser.CallContext context) {
        var functionName = context.Identifier().GetText();

        return functionName switch {
            "slot" => VisitSlotCall(context),
            "isInside" => VisitIsInsideCall(context),
            _ => throw new NotImplementedException("Function " + functionName + " not implemented")
        };
    }

    /// <summary>
    /// Wertet den Funktionsaufruf "isInside" aus und prüft, ob ein Punkt in einer Fläche liegt.
    /// </summary>
    private dynamic VisitIsInsideCall(ExpressionsParser.CallContext context) {
        var slotNameExpression = context.parameter.expression();
        if (slotNameExpression.Length != 2) {
            throw new NotImplementedException("Invalid parameter length. Only 2 parameter is supported");
        }

        var areaName = slotNameExpression[0].GetChild<ExpressionsParser.StringValueContext>(0)?.GetText();
        var locationParameter = Visit(slotNameExpression[1]);

        var strippedAreaName = areaName![1..^1];
        var isInside = geoService.IsPointInGeoflaeche(kommuneId, strippedAreaName, locationParameter);
        return isInside.Result;
    }

    /// <summary>
    /// Wertet den Funktionsaufruf "slot" aus und liefert den Wert des angegebenen Slots zurück.
    /// </summary>
    private dynamic VisitSlotCall(ExpressionsParser.CallContext context) {
        var slotNameExpression = context.parameter.expression();
        if (slotNameExpression.Length != 1) {
            throw new NotImplementedException("Invalid parameter length. Only 1 parameter is supported");
        }

        var slotName = slotNameExpression[0].GetChild<ExpressionsParser.StringValueContext>(0)?.GetText();
        var strippedSlotName = slotName![1..^1];

        if (!currentSlotValues.TryGetValue(strippedSlotName, out var slotValue)) {
            throw new InvalidOperationException("Slot " + strippedSlotName + " not found");
        }

        if (slotValue is not PlainSlotValue plainSlotValue) {
            throw new InvalidOperationException("Slot " + strippedSlotName + " is not a plain slot");
        }

        return plainSlotValue.Value.ValueKind switch {
            JsonValueKind.String => plainSlotValue.Value.GetString()!,
            JsonValueKind.Object => new ParsedLocation(plainSlotValue.Value.GetProperty("coordinates")[0].GetDouble(),
                plainSlotValue.Value.GetProperty("coordinates")[1].GetDouble()),
            _ => throw new InvalidOperationException("Cant handle input: " + strippedSlotName)
        };
    }

    /// <summary>
    /// Wertet einen Zahlenwert aus und liefert ihn als Integer zurück.
    /// </summary>
    public override dynamic VisitNumberValue(ExpressionsParser.NumberValueContext context) {
        return Int32.Parse(context.Number().GetText());
    }

    /// <summary>
    /// Wertet einen Ortswert aus und liefert ihn als ParsedLocation zurück.
    /// </summary>
    public override ParsedLocation VisitLocationValue(ExpressionsParser.LocationValueContext context) {
        var stringNumbers = context.Location()
            .GetText()[1..^1]
            .Split(',')
            .Select(double.Parse)
            .ToList();

        return new ParsedLocation(stringNumbers[0], stringNumbers[1]);
    }

    /// <summary>
    /// Repräsentiert einen geparsten Ort mit Längengrad und Breitengrad.
    /// </summary>
    public record ParsedLocation(double Lng, double Lat);

    /// <summary>
    /// Wertet einen String-Wert aus und entfernt die umschließenden Anführungszeichen.
    /// </summary>
    public override dynamic VisitStringValue(ExpressionsParser.StringValueContext context) {
        return context.String().GetText()[1..^1];
    }

    /// <summary>
    /// Wertet einen Booleschen Wert aus und liefert ihn als bool zurück.
    /// </summary>
    public override dynamic VisitBoolValue(ExpressionsParser.BoolValueContext context) {
        return context.Bool().GetText() switch {
            "true" => true,
            "false" => false,
            _ => throw new InvalidOperationException()
        };
    }
}
