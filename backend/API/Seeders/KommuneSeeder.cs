using System.Security.Cryptography;
using API.Features;
using API.Features.Kommune;
using API.Infrastructure;
using API.Seeders.Base;
using API.Seeders.Helpers;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace API.Seeders;

/// <summary>Repräsentiert die Daten für das Seed-Objekt einer Kommune.</summary>
/// <param name="Id">Eindeutige Kennung der Kommune.</param>
/// <param name="Name">Name der Kommune.</param>
/// <param name="AllgemeinerGemeindeSchluessel">Gemeindeschlüssel der Kommune.</param>
/// <param name="UnsafeRsa">RSA-Schlüssel für Verschlüsselungszwecke.</param>
/// <param name="KeyEncryptionKey">Schlüssel zur Verschlüsselung des privaten RSA-Schlüssels.</param>
public record KommuneSeed(Guid Id, string Name, string AllgemeinerGemeindeSchluessel, RSA UnsafeRsa, byte[] KeyEncryptionKey) { }

/// <summary>Seedet Kommunen in die Datenbank und verwaltet deren Verschlüsselungsinformationen.</summary>
public class KommuneSeeder : DataSeeder<DomainContext> {
    /// <summary>Gibt an, dass dieser Seeder vor Importen ausgeführt werden muss.</summary>
    public override bool MustRunBeforeImports => true;

    /// <summary>Initialisiert eine neue Instanz des KommuneSeeder mit den erforderlichen Abhängigkeiten.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung des Datenbankkontexts.</param>
    /// <param name="logger">Logger für die Ausgabe von Informationen.</param>
    /// <param name="validators">Sammlung von Validatoren für die Datenvalidierung.</param>
    public KommuneSeeder(IDbContextFactory<DomainContext> dbContextFactory, ILogger<KommuneSeeder> logger, IEnumerable<IValidator> validators) : base(dbContextFactory, logger, validators) { }

    /// <summary>Führt den Seed-Prozess asynchron aus.</summary>
    /// <param name="ct">Abbruchtoken zur Steuerung der Ausführung.</param>
    protected override async Task Run(CancellationToken ct = default) {
        await Seed(LandkreisHaPy, ct);
    }

    /// <summary>Seedet eine einzelne Kommune basierend auf den übergebenen Seed-Daten.</summary>
    /// <param name="seed">Seed-Daten der Kommune.</param>
    /// <param name="ct">Abbruchtoken zur Steuerung der Ausführung.</param>
    private async Task Seed(KommuneSeed seed, CancellationToken ct = default) {
        await Build(new Kommune { Name = seed.Name, Id = seed.Id }).OnCreate(k => {
            k.PublicKey = Convert.ToBase64String(seed.UnsafeRsa.ExportSubjectPublicKeyInfo());
            k.PrivateKey = Crypto.Encrypt(seed.UnsafeRsa.ExportPkcs8PrivateKey(), seed.KeyEncryptionKey);
        }).OnUpdate((current, next) => {
            current.Name = next.Name;
        }).SeedAsync(ct);
    }


    /// <summary>Beispielhafte Organisations-ID für Aerzen.</summary>
    public static readonly Guid AerzenOrganisationseinheitId = new("00e48df6-0d0f-48d2-9e8d-67fae50d4d26");



    /// <summary>Seed-Daten für den Landkreis Hameln-Pyrmont.</summary>
    public static readonly KommuneSeed LandkreisHaPy = new(
        new Guid("5a1aefef-809f-403d-a14c-27051353c7d4"),
        "Landkreis Hameln-Pyrmont",
        "03252006",
        RsaHelpers.FromXmlString(SeedSecrets.GetRequiredValue("SEED_KOMMUNE_RSA_XML")),
        Convert.FromBase64String(SeedSecrets.GetRequiredValue("SEED_KOMMUNE_ENCRYPTION_KEY"))
    );
}
