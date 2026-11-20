using System.Text.RegularExpressions;

namespace API.Features.ObjectStorage;

/// <summary>Resolves registered consumers by key prefix.</summary>
public partial class ObjectStorageConsumerRegistry {
    private readonly Dictionary<string, IObjectStorageConsumer> _consumersByPrefix = new(StringComparer.Ordinal);

    /// <exception cref="InvalidOperationException">A prefix is invalid or registered twice.</exception>
    public ObjectStorageConsumerRegistry(IEnumerable<IObjectStorageConsumer> consumers) {
        foreach (var consumer in consumers) {
            if (!PrefixPattern().IsMatch(consumer.Prefix)) {
                throw new InvalidOperationException(
                    $"Object storage prefix '{consumer.Prefix}' of {consumer.GetType().Name} must match {PrefixPattern()}.");
            }

            if (!_consumersByPrefix.TryAdd(consumer.Prefix, consumer)) {
                throw new InvalidOperationException(
                    $"Object storage prefix '{consumer.Prefix}' is registered by both " +
                    $"{_consumersByPrefix[consumer.Prefix].GetType().Name} and {consumer.GetType().Name}.");
            }
        }
    }

    /// <summary>All registered consumers.</summary>
    public IReadOnlyCollection<IObjectStorageConsumer> All => _consumersByPrefix.Values;

    /// <summary>The consumer that owns <paramref name="prefix"/>, or <c>null</c>.</summary>
    public IObjectStorageConsumer? Find(string prefix) => _consumersByPrefix.GetValueOrDefault(prefix);

    [GeneratedRegex("^[a-z0-9-]+$")]
    private static partial Regex PrefixPattern();
}

/// <summary>Builds the registry once at startup, so an invalid or duplicate prefix fails the start.</summary>
public class ObjectStorageConsumerRegistryValidator(IServiceScopeFactory scopeFactory) : IHostedService {
    /// <inheritdoc />
    public Task StartAsync(CancellationToken cancellationToken) {
        using var scope = scopeFactory.CreateScope();
        scope.ServiceProvider.GetRequiredService<ObjectStorageConsumerRegistry>();
        return Task.CompletedTask;
    }

    /// <inheritdoc />
    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
