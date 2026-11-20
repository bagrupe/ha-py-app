using HotChocolate.Execution.Configuration;

namespace API.Infrastructure;

/// <summary>Erweitert den IRequestExecutorBuilder um Typen, die für Payload CMS benötigt werden.</summary>
public static class PayloadCmsExtensions {
    /// <summary>Fügt dem Builder die Typen "JSONObject" und "EmailAddress" hinzu.</summary>
    /// <param name="builder">Der IRequestExecutorBuilder, der erweitert wird.</param>
    /// <returns>Den erweiterten IRequestExecutorBuilder.</returns>
    public static IRequestExecutorBuilder AddPayloadCmsTypes(this IRequestExecutorBuilder builder) {
        // https://github.com/ChilliCream/graphql-platform/issues/3067#issuecomment-1121655104
        builder.AddType(new AnyType("JSONObject"));
        builder.AddType(new AnyType("EmailAddress"));
        return builder;
    }

}
