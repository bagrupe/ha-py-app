using API.Features.Expressions;
using FluentValidation;
using FluentValidation.Validators;

namespace API.Features.Prozess.Validators;

/// <summary>Validiert die Typen von Ausdrücken innerhalb einer Prozessversion.</summary>
public class ExpressionsTypeCheckerValidator : AbstractValidator<ProzessVersion> {
    public ExpressionsTypeCheckerValidator() {
        RuleForEach(prozessVersion => prozessVersion.Schritte)
            .SetInheritanceValidator(v => {
                v.Add<FormularSchritt>((_, derived) => new FormularSchrittValidator(derived));
            });
        RuleForEach(prozessVersion => prozessVersion.Schritte)
            .SetValidator(version => new SchrittValidator(version));
    }
}

/// <summary>Validiert die Verbindungen eines Schritts innerhalb einer Prozessversion.</summary>
file class SchrittValidator : AbstractValidator<Schritt> {
    public SchrittValidator(ProzessVersion version) {
        RuleForEach(formularSchritt => formularSchritt.Verbindungen)
            .SetValidator(new VerbindungValidator(version.Schritte));
    }
}

/// <summary>Validiert die Felder eines Formularschritts anhand der zugehörigen Slot-Typen.</summary>
file class FormularSchrittValidator : AbstractValidator<FormularSchritt> {
    public FormularSchrittValidator(FormularSchritt schritt) {
        var slotTypes = schritt.Slots
            .ToDictionary(
                s => s.Name,
                s => s.ValueType switch {
                    SlotValueType.Location => ExpressionValueType.Location,
                    SlotValueType.String => ExpressionValueType.String,
                    SlotValueType.Upload => ExpressionValueType.Upload,
                    SlotValueType.Date => ExpressionValueType.Date,
                    _ => ExpressionValueType.Unknown
                });

        RuleForEach(fs => fs.Felder)
            .ChildRules(ff => {
                ff.RuleFor(feld => feld.IstRelevant)
                    .SetValidator(new ExpressionTypeValidator<FormularFeld>(slotTypes));
            });
    }
}

/// <summary>Validiert die Relevanz-Ausdrücke von Verbindungen anhand der Typen der Schritte.</summary>
file class VerbindungValidator : AbstractValidator<Verbindung> {
    public VerbindungValidator(IEnumerable<Schritt> schritte) {

        RuleFor(v => v.IstRelevant)
            .SetValidator(new ExpressionTypeValidator<Verbindung>(ExpressionTypeValidator<Verbindung>.GetValueTypes(schritte)));
    }
}

/// <summary>Validiert den Typ eines Ausdrucks anhand erwarteter und tatsächlicher Typen.</summary>
/// <typeparam name="T">Der Typ des Objekts, das validiert wird.</typeparam>
file class ExpressionTypeValidator<T> : PropertyValidator<T, Expression> {
    private readonly Dictionary<string, ExpressionValueType> _slotTypes;

    /// <summary>Ermittelt die erwarteten Typen der Slots aus einer Sammlung von Schritten.</summary>
    /// <param name="schritte">Die Schritte, aus denen die Slot-Typen extrahiert werden.</param>
    /// <returns>Dictionary mit Slot-Namen und zugehörigen erwarteten Typen.</returns>
    public static Dictionary<string, ExpressionValueType> GetValueTypes(IEnumerable<Schritt> schritte) {
        var result = new Dictionary<string, ExpressionValueType>();

        foreach (var slot in schritte.SelectMany(schritt => schritt.Slots)) {

            var valueType = slot.ValueType switch {
                SlotValueType.Location => ExpressionValueType.Location,
                SlotValueType.String => ExpressionValueType.String,
                SlotValueType.Upload => ExpressionValueType.Upload,
                SlotValueType.Date => ExpressionValueType.Date,
                _ => ExpressionValueType.Unknown
            };

            if (result.ContainsKey(slot.Name)) {
                result[slot.Name] |= valueType;
            } else {
                result.Add(slot.Name, valueType);
            }
        }

        return result;
    }

    /// <summary>Initialisiert den Validator mit den erwarteten Slot-Typen.</summary>
    /// <param name="slotTypes">Dictionary der erwarteten Slot-Typen.</param>
    public ExpressionTypeValidator(Dictionary<string, ExpressionValueType> slotTypes) {
        _slotTypes = slotTypes;
    }

    public override string Name => "ExpressionTypeValidator";

    /// <summary>Prüft, ob der Ausdruck den erwarteten Typen entspricht.</summary>
    /// <param name="context">Der Validierungskontext.</param>
    /// <param name="value">Der zu prüfende Ausdruck.</param>
    /// <returns>True, wenn der Typ übereinstimmt, sonst false.</returns>
    public override bool IsValid(ValidationContext<T> context, Expression value) {
        var expected = value switch {
            StringExpression => ExpressionValueType.String,
            IntExpression => ExpressionValueType.Int,
            BoolExpression => ExpressionValueType.Bool,
            _ => ExpressionValueType.Unknown
        };
        var actual = new TypecheckingVisitor(_slotTypes).Visit(value.Context);

        context.MessageFormatter.AppendArgument("Expression", value.ExpressionString);
        context.MessageFormatter.AppendArgument("ExpectedType", expected);
        context.MessageFormatter.AppendArgument("ActualType", actual);

        return expected == actual;
    }

    protected override string GetDefaultMessageTemplate(string errorCode)
        => "Expression \"{Expression}\" is not of the correct type, expected {ExpectedType} but got {ActualType}";
}
