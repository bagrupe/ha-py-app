using API.Features.Expressions;

namespace UnitTests;

public class ExpressionsTest {
    [Fact]
    public void CanParseStringExpression() {
        _ = new StringExpression("'Hello World'");
    }

    [Fact]
    public void CanParseBoolExpression() {
        _ = new BoolExpression("true");
    }

    [Fact]
    public void CanParseIntExpression() {
        _ = new IntExpression("1");
    }

    [Fact]
    public void ThrowsWhenParsingInvalidStringExpression() {
        Assert.Throws<ExpressionParseException>(() => new StringExpression("'Hello World"));
    }

    [Fact]
    public void ThrowsWhenParsingInvalidDanglingExpression() {
        Assert.Throws<ExpressionParseException>(() => new IntExpression("1 + "));
    }

    [Fact]
    public void CanReturnTypeOfStringExpression() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new StringExpression("'Hello World'").Context);

        Assert.Equal(ExpressionValueType.String, type);
    }

    [Fact]
    public void CanReturnTypeOfStringExpressionWithWrongDefinition() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new StringExpression("1").Context);

        Assert.Equal(ExpressionValueType.Int, type);
    }

    [Fact]
    public void CanReturnTypeOfBoolExpression() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new BoolExpression("true").Context);

        Assert.Equal(ExpressionValueType.Bool, type);
    }

    [Fact]
    public void CanReturnTypeOfIntExpression() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new IntExpression("1").Context);

        Assert.Equal(ExpressionValueType.Int, type);
    }

    [Fact]
    public void CanReturnTypeOfSlotExpression() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType> {
            { "name", ExpressionValueType.String }
        }).Visit(new StringExpression("slot('name')").Context);

        Assert.Equal(ExpressionValueType.String, type);
    }

    [Fact]
    public void ThrowsWhenSlotNameIsNotKnown() {
        Assert.Throws<ExpressionSlotNameNotFoundException>(() => new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new StringExpression("slot('name')").Context));
    }

    [Fact]
    public void ReturnsUnknownTypeWhenSlotNameIsNotKnownStatically() {
        var type = new TypecheckingVisitor(new Dictionary<string, ExpressionValueType>()).Visit(new StringExpression("slot('name' + 'other')").Context);

        Assert.Equal(ExpressionValueType.Unknown, type);
    }
}
