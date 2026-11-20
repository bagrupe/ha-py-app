using Microsoft.Extensions.Logging;

namespace IntegrationTests.TestDoubles;

public sealed class TestLogger<T> : ILogger<T> {
    public List<TestLogEntry> Entries { get; } = [];

    public IDisposable BeginScope<TState>(TState state) where TState : notnull => NullDisposable.Instance;

    public bool IsEnabled(LogLevel logLevel) => true;

    public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception? exception,
        Func<TState, Exception?, string> formatter) {
        Entries.Add(new TestLogEntry(logLevel, eventId, formatter(state, exception), exception));
    }

    private sealed class NullDisposable : IDisposable {
        public static readonly NullDisposable Instance = new();

        public void Dispose() { }
    }
}

public sealed record TestLogEntry(LogLevel Level, EventId EventId, string Message, Exception? Exception);
