using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

namespace API.Features.PushNotifications;

/// <summary>Zentrale, thread-sichere Initialisierung der Default-<see cref="FirebaseApp"/>-Instanz.</summary>
public static class FirebaseAppBootstrap {
    private static readonly object Lock = new();
    private static bool Done;

    /// <summary>Erstellt die Default-App genau einmal (idempotent).</summary>
    /// <param name="credentialPath">Pfad zur Service-Account-JSON-Datei.</param>
    public static void EnsureCreated(string credentialPath) {
        if (Done) return;
        lock (Lock) {
            if (Done) return;
            if (FirebaseApp.DefaultInstance is null) {
                FirebaseApp.Create(new AppOptions {
                    Credential = GoogleCredential.FromFile(credentialPath)
                });
            }

            Done = true;
        }
    }
}
