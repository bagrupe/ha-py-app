namespace API.Infrastructure;

/// <summary>Definiert einen GraphQL-Enum-Typ für Fehlercodes basierend auf Domain-Ausnahmen.</summary>
public class ErrorCodeType : EnumType {
    /// <summary>Konfiguriert den Enum-Typ mit allen Ausnahmen, die von DomainException erben.</summary>
    /// <param name="descriptor">Der Descriptor zur Definition des Enum-Typs.</param>
    protected override void Configure(IEnumTypeDescriptor descriptor) {
        // All exceptions who inherit from `DomainException` will be exposed as a
        // GraphQL enum type in order to have a type safe error lookup.
        var types = typeof(Program).Assembly.GetTypes().Where(x => x.IsSubclassOf(typeof(DomainException)));
        foreach (Type type in types) {
            descriptor.Value(ExceptionTypeNameToGraphQLCode(type));
        }
    }

    /// <summary>Wandelt den Namen einer Ausnahme in einen GraphQL-konformen Fehlercode um.</summary>
    /// <param name="type">Der Typ der Ausnahme.</param>
    /// <returns>Der Fehlercode als Großbuchstaben mit Unterstrichen.</returns>
    public static string ExceptionTypeNameToGraphQLCode(Type type) {
        return type.Name.Replace("Exception", "").ToUnderscoreCase().ToUpper();
    }
}

/// <summary>Erweitert Strings um eine Methode zur Umwandlung in Unterstrich-Schreibweise.</summary>
static class StringExtensions {
    /// <summary>Konvertiert einen PascalCase-String in eine Unterstrich-Schreibweise.</summary>
    /// <param name="str">Der Eingabestring im PascalCase.</param>
    /// <returns>Der String mit Unterstrichen zwischen Großbuchstaben.</returns>
    public static string ToUnderscoreCase(this string str) {
        return string.Concat(str.Select((x, i) => i > 0 && char.IsUpper(x) ? "_" + x : x.ToString()));
    }
}
