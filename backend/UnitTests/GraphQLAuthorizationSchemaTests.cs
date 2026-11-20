using HotChocolate.Execution;
using HotChocolate.Types;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class GraphQLAuthorizationSchemaTests(BackendApiFactory factory) {
    [Fact]
    public async Task RootFields_HaveExactlyOneAccessClassification() {
        var executorResolver = factory.Services.GetRequiredService<IRequestExecutorResolver>();
        var executor = await executorResolver.GetRequestExecutorAsync();

        var invalidFields = new List<string>();
        foreach (var rootType in new[] { executor.Schema.QueryType, executor.Schema.MutationType }) {
            if (rootType is null) {
                continue;
            }

            foreach (var field in rootType.Fields) {
                // GraphQL reserves the __ prefix for framework-owned introspection fields.
                if (field.Name.StartsWith("__", StringComparison.Ordinal)) {
                    continue;
                }

                var classifications = new[] {
                    (Name: "authorize", Present: field.Directives.ContainsDirective("authorize")),
                    (Name: "allowAnonymous", Present: field.Directives.ContainsDirective("allowAnonymous")),
                };
                var presentClassifications = classifications
                    .Where(classification => classification.Present)
                    .Select(classification => classification.Name)
                    .ToArray();

                if (presentClassifications.Length != 1) {
                    var found = presentClassifications.Length == 0
                        ? "none"
                        : string.Join(", ", presentClassifications);
                    invalidFields.Add($"{rootType.Name}.{field.Name}: {found}");
                }
            }
        }

        Assert.True(
            invalidFields.Count == 0,
            "Every root field must have exactly one of authorize or allowAnonymous. " +
            $"Invalid fields:{Environment.NewLine}{string.Join(Environment.NewLine, invalidFields)}"
        );
    }
}
