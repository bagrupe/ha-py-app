using HotChocolate.Execution;

namespace API.Infrastructure;

/// <summary>Schreibt das GraphQL-Schema in die Frontend-Projekte beim Start des Dienstes.</summary>
public class WriteSchemaToFrontends(IRequestExecutorResolver executorResolver, ILogger<WriteSchemaToFrontends> logger) : IHostedService {

    /// <summary>Lädt das Schema und speichert es in den Frontend-Verzeichnissen, falls diese existieren.</summary>
    /// <param name="cancellationToken">Token zum Abbrechen der asynchronen Operation.</param>
    public async Task StartAsync(CancellationToken cancellationToken) {
        var executor = await executorResolver.GetRequestExecutorAsync(Schema.DefaultName, cancellationToken);
        var schema = executor.Schema.Print().ReplaceLineEndings("\n");

        if (!Directory.Exists("../../web") || !Directory.Exists("../../app")) {
            logger.LogInformation("Schema not written to projects, because they do not exist");
            return;
        }

        await File.WriteAllTextAsync("../../web/bereich-a/schema.graphql", schema, cancellationToken);
        await File.WriteAllTextAsync("../../web/stele/schema.graphql", schema, cancellationToken);
        await File.WriteAllTextAsync("../../app/lib/graphql/schema.graphql", schema, cancellationToken);

        logger.LogInformation("Schema written to projects");
    }

    /// <summary>Beendet den Dienst ohne weitere Aktionen.</summary>
    /// <param name="cancellationToken">Token zum Abbrechen der Operation.</param>
    public Task StopAsync(CancellationToken cancellationToken) {
        return Task.CompletedTask;
    }
}
