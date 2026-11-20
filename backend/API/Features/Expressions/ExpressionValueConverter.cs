using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace API.Features.Expressions;

/// <summary>Konvertiert StringExpression-Objekte in und aus der Datenbankdarstellung als string.</summary>
public class StringExpressionValueConverter : ValueConverter<StringExpression, string> {
    /// <summary>Initialisiert den Konverter mit den Umwandlungsfunktionen.</summary>
    public StringExpressionValueConverter() : base(
        expression => expression.ExpressionString,
        expressionString => String.IsNullOrEmpty(expressionString) ? "" : new StringExpression(expressionString)) { }
}

/// <summary>Konvertiert BoolExpression-Objekte in und aus der Datenbankdarstellung als string.</summary>
public class BoolExpressionValueConverter : ValueConverter<BoolExpression, string> {
    /// <summary>Initialisiert den Konverter mit den Umwandlungsfunktionen.</summary>
    public BoolExpressionValueConverter() : base(
        expression => expression.ExpressionString,
        expressionString => String.IsNullOrEmpty(expressionString) ? true : new BoolExpression(expressionString)) { }
}

/// <summary>Konvertiert IntExpression-Objekte in und aus der Datenbankdarstellung als string.</summary>
public class IntExpressionValueConverter : ValueConverter<IntExpression, string> {
    /// <summary>Initialisiert den Konverter mit den Umwandlungsfunktionen.</summary>
    public IntExpressionValueConverter() : base(
        expression => expression.ExpressionString,
        expressionString => String.IsNullOrEmpty(expressionString) ? 0 : new IntExpression(expressionString)) { }
}
