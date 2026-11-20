using API.Features.ObjectStorage;

namespace IntegrationTests.TestDoubles;

/// <summary>Per-test rules for one test consumer. Everything is denied until a test allows it.</summary>
public sealed class TestObjectStorageConsumerRules {
    public HashSet<Guid> Uploaders { get; } = [];
    public HashSet<Guid> Readers { get; } = [];
    public HashSet<string> ReferencedKeys { get; } = [];
    public List<string> KeysCheckedForReferences { get; } = [];
    public long? MaxUploadBytes { get; set; }
    public IReadOnlyCollection<string>? AllowedContentTypes { get; set; }

    public void Reset() {
        Uploaders.Clear();
        Readers.Clear();
        ReferencedKeys.Clear();
        KeysCheckedForReferences.Clear();
        MaxUploadBytes = null;
        AllowedContentTypes = null;
    }
}

/// <summary>Rules of both test consumers, shared across a test host.</summary>
public sealed class TestObjectStorageConsumers {
    public TestObjectStorageConsumerRules Test { get; } = new();
    public TestObjectStorageConsumerRules TestOther { get; } = new();

    public void Reset() {
        Test.Reset();
        TestOther.Reset();
    }
}

public abstract class RuleBasedObjectStorageConsumer(TestObjectStorageConsumerRules rules) : IObjectStorageConsumer {
    public abstract string Prefix { get; }
    public long? MaxUploadBytes => rules.MaxUploadBytes;
    public IReadOnlyCollection<string>? AllowedContentTypes => rules.AllowedContentTypes;

    public Task<bool> CanUploadAsync(Guid userId, CancellationToken ct) => Task.FromResult(rules.Uploaders.Contains(userId));

    public Task<bool> CanReadAsync(Guid? userId, string key, CancellationToken ct) =>
        Task.FromResult(userId is { } id && rules.Readers.Contains(id));

    public Task<bool> IsReferencedAsync(string key, CancellationToken ct) {
        rules.KeysCheckedForReferences.Add(key);
        return Task.FromResult(rules.ReferencedKeys.Contains(key));
    }
}

public sealed class TestObjectStorageConsumer(TestObjectStorageConsumers consumers)
    : RuleBasedObjectStorageConsumer(consumers.Test) {
    public const string PrefixValue = "test";
    public override string Prefix => PrefixValue;
}

public sealed class OtherTestObjectStorageConsumer(TestObjectStorageConsumers consumers)
    : RuleBasedObjectStorageConsumer(consumers.TestOther) {
    public const string PrefixValue = "test-other";
    public override string Prefix => PrefixValue;
}
