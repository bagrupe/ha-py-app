namespace API.Options;

/// <summary>Konfiguration für die Firebase Admin SDK-Initialisierung (FCM).</summary>
public class FirebaseOptions {
    public const string SectionName = "Firebase";

    /// <summary>Pfad zur Google-Service-Account-JSON-Datei.</summary>
    public string CredentialPath { get; init; } = "./kommunalapp-service-account.json";
}
