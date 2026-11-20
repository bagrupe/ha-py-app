using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Infrastructure;
using API.Seeders.Base;
using API.Seeders.Helpers;
using FluentValidation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace API.Seeders;

/// <summary>Seedet Standard-Bürgerdaten für die Anwendung.</summary>
public class BuergerSeeder : DataSeeder<DomainContext> {
    /// <summary>Gibt an, ob der Seeder vor Importen ausgeführt werden muss.</summary>
    public override bool MustRunBeforeImports => false;

    /// <summary>Initialisiert eine neue Instanz des BuergerSeeder mit den benötigten Abhängigkeiten.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung des Datenbankkontexts.</param>
    /// <param name="logger">Logger für die Ausgabe von Informationen.</param>
    /// <param name="passwordHasher">Dienst zum Hashen von Passwörtern.</param>
    /// <param name="validators">Sammlung von Validierern für die Daten.</param>
    public BuergerSeeder(IDbContextFactory<DomainContext> dbContextFactory, ILogger<BuergerSeeder> logger, IPasswordHasher<User> passwordHasher, IEnumerable<IValidator> validators) : base(dbContextFactory, logger, validators) {
        _passwordHasher = passwordHasher;
    }

    private readonly IPasswordHasher<User> _passwordHasher;

    /// <summary>Standard-ID für den Mängel-Bürger.</summary>
    public static Guid MangelBuergerId = new Guid("4c385202-e22f-4ebc-a51b-67eba6bc0bec");

    /// <summary>Unsicherer RSA-Schlüssel für den Mängel-Bürger zur Verschlüsselung.</summary>
    public static readonly RSA UnsafeBuergerRsa = RsaHelpers.FromXmlString(SeedSecrets.GetRequiredValue("SEED_BUERGER_RSA_XML"));

    /// <summary>Führt das Seeden der Standard-Bürgerdaten asynchron aus.</summary>
    /// <param name="ct">Abbruch-Token zur Steuerung der Ausführung.</param>
    protected override async Task Run(CancellationToken ct = default) {
        await Build(new Buerger {
            Id = MangelBuergerId,
            PersonalDataKeyEncryptedForBuerger = "",
        }).OnCreate(manni => {
            manni.SetCryptoAndPassword("234567", "manni.maengel@example.com", _passwordHasher, UnsafeBuergerRsa);
        }).SeedAsync(ct);
    }
}
