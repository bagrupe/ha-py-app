using API.Options;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace API.Features.PushNotifications;

/// <summary>
/// Validiert Firebase-Credentials beim Host-Start (fehlende Datei / ungültiges JSON),
/// damit der Prozess nicht erst beim ersten Push fehlschlägt.
/// </summary>
public sealed class FirebasePushMessagingStartupValidator(
    IHostEnvironment hostEnvironment,
    IOptions<FirebaseOptions> options,
    ILogger<FirebasePushMessagingStartupValidator> logger
) : IHostedService {
    public Task StartAsync(CancellationToken cancellationToken) {
        if (hostEnvironment.IsEnvironment("Testing")) {
            return Task.CompletedTask;
        }

        var path = options.Value.CredentialPath;
        if (!File.Exists(path)) {
            throw new InvalidOperationException(
                $"Firebase service account file not found: '{path}'. Configure Firebase:CredentialPath or add the file.");
        }

        try {
            FirebaseAppBootstrap.EnsureCreated(path);
        } catch (Exception ex) {
            throw new InvalidOperationException(
                $"Firebase could not be initialized from '{path}'. See inner exception.", ex);
        }

        logger.LogInformation("Firebase Admin SDK initialized (credentials validated at startup).");
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
