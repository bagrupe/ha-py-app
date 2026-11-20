using HotChocolate.Language;

namespace API.Features.Expressions;

/// <summary>GraphQL-Scalar-Typ für StringExpression zur Serialisierung und Deserialisierung.</summary>
public sealed class StringExpressionType : ScalarType<StringExpression, StringValueNode> {
    /// <summary>Initialisiert den Scalar-Typ mit dem Namen "StringExpression".</summary>
    public StringExpressionType() : base("StringExpression") { }

    /// <summary>Parst das Ergebnisobjekt in einen GraphQL-Wertknoten.</summary>
    public override IValueNode ParseResult(object? resultValue) {
        return ParseValue(resultValue);
    }

    /// <summary>Parst einen StringValueNode in eine StringExpression.</summary>
    protected override StringExpression ParseLiteral(StringValueNode valueSyntax) {
        return new StringExpression(valueSyntax.Value);
    }

    /// <summary>Konvertiert eine StringExpression in einen StringValueNode.</summary>
    protected override StringValueNode ParseValue(StringExpression runtimeValue) {
        return new StringValueNode(runtimeValue.ExpressionString);
    }
}

/// <summary>GraphQL-Scalar-Typ für BoolExpression zur Serialisierung und Deserialisierung.</summary>
public sealed class BoolExpressionType : ScalarType<BoolExpression, StringValueNode> {
    /// <summary>Initialisiert den Scalar-Typ mit dem Namen "BoolExpression".</summary>
    public BoolExpressionType() : base("BoolExpression") { }

    /// <summary>Parst das Ergebnisobjekt in einen GraphQL-Wertknoten.</summary>
    public override IValueNode ParseResult(object? resultValue) {
        return ParseValue(resultValue);
    }

    /// <summary>Parst einen StringValueNode in eine BoolExpression.</summary>
    protected override BoolExpression ParseLiteral(StringValueNode valueSyntax) {
        return new BoolExpression(valueSyntax.Value);
    }

    /// <summary>Konvertiert eine BoolExpression in einen StringValueNode.</summary>
    protected override StringValueNode ParseValue(BoolExpression runtimeValue) {
        return new StringValueNode(runtimeValue.ExpressionString);
    }
}

/// <summary>GraphQL-Scalar-Typ für IntExpression zur Serialisierung und Deserialisierung.</summary>
public sealed class IntExpressionType : ScalarType<IntExpression, StringValueNode> {
    /// <summary>Initialisiert den Scalar-Typ mit dem Namen "IntExpression".</summary>
    public IntExpressionType() : base("IntExpression") { }

    /// <summary>Parst das Ergebnisobjekt in einen GraphQL-Wertknoten.</summary>
    public override IValueNode ParseResult(object? resultValue) {
        return ParseValue(resultValue);
    }

    /// <summary>Parst einen StringValueNode in eine IntExpression.</summary>
    protected override IntExpression ParseLiteral(StringValueNode valueSyntax) {
        return new IntExpression(valueSyntax.Value);
    }

    /// <summary>Konvertiert eine IntExpression in einen StringValueNode.</summary>
    protected override StringValueNode ParseValue(IntExpression runtimeValue) {
        return new StringValueNode(runtimeValue.ExpressionString);
    }
}
