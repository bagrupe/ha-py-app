using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Kommune;
using API.Features.Lage;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Infrastructure;
using API.Options;
using API.Seeders.Base;
using FluentValidation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using static API.Seeders.LageHelfer.LageHelferSeedData;
using IOPath = System.IO.Path;

namespace API.Seeders.LageHelfer;

/// <summary>
/// Seedet einen LageHelfer-Mandanten aus <c>seed.json</c> und <c>flaechen.geojson</c>.
/// Struktur läuft in allen Umgebungen; der optionale Demo-Abschnitt nur außerhalb von Production.
/// </summary>
/// <remarks>
/// Bewusst nicht als <see cref="IDataSeeder"/> registriert: Die Ausführung wird über
/// <c>DataSeeder__LageHelferEnabled</c> gesteuert und ist unabhängig von <c>DataSeeder__Enabled</c>.
/// </remarks>
public class LageHelferSeeder : DataSeeder<DomainContext> {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly EnvironmentOptions _environmentOptions;
    private readonly DataSeederOptions _dataSeederOptions;
    private readonly ILogger<LageHelferSeeder> _logger;
    private readonly IClock _clock;

    /// <inheritdoc />
    public override bool MustRunBeforeImports => false;

    /// <summary>Initialisiert den Seeder mit seinen Abhängigkeiten.</summary>
    public LageHelferSeeder(IDbContextFactory<DomainContext> dbContextFactory, ILogger<LageHelferSeeder> logger,
        IPasswordHasher<User> passwordHasher, EnvironmentOptions environmentOptions, DataSeederOptions dataSeederOptions,
        IEnumerable<IValidator> validators, IClock clock) : base(dbContextFactory, logger, validators) {
        _clock = clock;
        _dbContextFactory = dbContextFactory;
        _passwordHasher = passwordHasher;
        _environmentOptions = environmentOptions;
        _dataSeederOptions = dataSeederOptions;
        _logger = logger;
    }

    /// <summary>Gibt zurück, ob der Demo-Abschnitt in der aktuellen Umgebung geseeded werden darf.</summary>
    public bool IsDemoAllowedInCurrentEnvironment =>
        !string.Equals(_environmentOptions.Name, "Production", StringComparison.OrdinalIgnoreCase);

    /// <inheritdoc />
    protected override async Task Run(CancellationToken cancellationToken = default) {
        var path = ResolveSeedPath(_dataSeederOptions.LageHelferSeedPath!);
        var document = LageHelferSeedLoader.Load(path);
        var keyEncryptionKey = Convert.FromBase64String(_dataSeederOptions.LageHelferKeyEncryptionKey!);
        var ns = document.IdNamespace;

        var gebieteInOffenerLage = await DbContext.Lagen
            .AsNoTracking()
            .Where(l => l.Status != LageStatus.Closed && l.DeletedAt == null)
            .SelectMany(l => l.LageGebiete)
            .Where(lg => lg.Status != LageGebietStatus.Ended && lg.Status != LageGebietStatus.Done)
            .Select(lg => lg.GebietId)
            .ToHashSetAsync(cancellationToken);

        await SeedKommune(document.Kommune, keyEncryptionKey, cancellationToken);

        var organisationseinheiten = new Dictionary<string, Untereinheit>(StringComparer.Ordinal);
        var abteilungen = new Dictionary<string, MitarbeiterGruppe>(StringComparer.Ordinal);

        foreach (var oe in document.Organisationseinheiten) {
            organisationseinheiten[oe.Key] = await SeedUntereinheit(
                OrganisationseinheitId(ns, oe.Key), document.Kommune.Id, oe.Name, cancellationToken);

            foreach (var bereich in oe.Bereiche) {
                await SeedGebiet(ns, oe.Key, bereich, document.BereichGeometrien, gebieteInOffenerLage,
                    cancellationToken);

                if (string.IsNullOrWhiteSpace(bereich.Einsatzleitung)) {
                    continue;
                }

                var einsatzleitung = await SeedAbteilung(
                    EinsatzleitungId(ns, bereich.Key),
                    new LageHelferAbteilungSeed(bereich.Key, bereich.Einsatzleitung),
                    organisationseinheiten[oe.Key],
                    document.Kommune.Id,
                    cancellationToken);
                abteilungen[bereich.Key] = einsatzleitung;
                await SeedGebietEinsatzleitung(GebietId(ns, bereich.Key), einsatzleitung.Id, cancellationToken);
                foreach (var einheit in bereich.Einheiten ?? []) {
                    await SeedEinheit(EinheitId(ns, bereich.Key, einheit), einheit, einsatzleitung.Id,
                        cancellationToken);
                }
            }
        }

        foreach (var oe in document.Organisationseinheiten) {
            foreach (var abteilung in oe.Abteilungen) {
                abteilungen[abteilung.Key] = await SeedAbteilung(
                    AbteilungId(ns, abteilung.Key),
                    abteilung,
                    organisationseinheiten[oe.Key],
                    document.Kommune.Id,
                    cancellationToken);
            }
        }

        foreach (var prozess in document.Prozesse) {
            await SeedProzess(ns, document.Kommune.Id, prozess, cancellationToken);
        }

        if (document.Demo is null) {
            return;
        }

        if (!IsDemoAllowedInCurrentEnvironment) {
            _logger.LogWarning(
                "LageHelfer-Demo-Abschnitt in der Umgebung '{Environment}' übersprungen (nur Struktur gesät).",
                _environmentOptions.Name);
            return;
        }

        await SeedDemo(document, ns, organisationseinheiten, abteilungen, keyEncryptionKey, cancellationToken);
    }

    private static string ResolveSeedPath(string configuredPath) {
        if (IOPath.IsPathRooted(configuredPath)) {
            return configuredPath;
        }

        return IOPath.GetFullPath(IOPath.Combine(AppContext.BaseDirectory, configuredPath));
    }

    private async Task SeedKommune(LageHelferKommuneSeed kommune, byte[] keyEncryptionKey, CancellationToken ct) =>
        await Build(new Kommune { Id = kommune.Id, Name = kommune.Name }).OnCreate(k => {
            using var rsa = RSA.Create(4096);
            k.PublicKey = Convert.ToBase64String(rsa.ExportSubjectPublicKeyInfo());
            k.PrivateKey = Crypto.Encrypt(rsa.ExportPkcs8PrivateKey(), keyEncryptionKey);
        }).OnUpdate((current, next) => current.Name = next.Name).SeedAsync(ct);

    private async Task<Untereinheit> SeedUntereinheit(Guid id, Guid kommuneId, string name, CancellationToken ct) =>
        await Build(new Untereinheit { Id = id, KommuneId = kommuneId, Name = name, IsGemeinde = false })
            .OnUpdate((current, next) => current.Name = next.Name)
            .SeedAsync(ct);

    private async Task SeedGebiet(Guid idNamespace, string oeKey, LageHelferBereichSeed bereich,
        IReadOnlyDictionary<string, string> geometrien, HashSet<Guid> gebieteInOffenerLage, CancellationToken ct) {
        geometrien.TryGetValue(bereich.Key, out var nextGeometry);
        var gebietId = GebietId(idNamespace, bereich.Key);
        var geometryLocked = gebieteInOffenerLage.Contains(gebietId)
            || await IsGebietInOffenerLageAsync(gebietId, ct);
        if (geometryLocked && nextGeometry is not null) {
            _logger.LogWarning(
                "Geometrie von Gebiet '{Bereich}' nicht aktualisiert (Gebiet in offener Lage).",
                bereich.Key);
        }

        await Build(new Gebiet {
            Id = gebietId,
            UntereinheitId = OrganisationseinheitId(idNamespace, oeKey),
            Name = bereich.Name,
            Geometry = geometryLocked ? null : nextGeometry,
        }).OnUpdate((current, next) => {
            current.Name = next.Name;
            current.UntereinheitId = next.UntereinheitId;
            if (next.Geometry is null) {
                return;
            }

            current.Geometry = next.Geometry;
        }).SeedAsync(ct);
    }

    private async Task<bool> IsGebietInOffenerLageAsync(Guid gebietId, CancellationToken ct) =>
        await DbContext.LageGebiete
            .AsNoTracking()
            .Where(lg => lg.GebietId == gebietId
                && lg.Status != LageGebietStatus.Ended
                && lg.Status != LageGebietStatus.Done)
            .AnyAsync(lg => lg.Lage.Status != LageStatus.Closed && lg.Lage.DeletedAt == null, ct);

    private async Task<MitarbeiterGruppe> SeedAbteilung(Guid id, LageHelferAbteilungSeed abteilung,
        Untereinheit oe, Guid kommuneId, CancellationToken ct) =>
        await Build(new MitarbeiterGruppe {
            Id = id,
            KommuneId = kommuneId,
            Name = abteilung.Name,
            Organisationseinheiten = [oe],
        }).OnUpdate((current, next) => current.Name = next.Name).SeedAsync(ct);

    private async Task SeedEinheit(Guid id, string name, Guid mitarbeiterGruppeId, CancellationToken ct) =>
        await Build(new Einheit { Id = id, Name = name, MitarbeiterGruppeId = mitarbeiterGruppeId })
            .OnUpdate((current, next) => current.Name = next.Name).SeedAsync(ct);

    private async Task SeedGebietEinsatzleitung(Guid gebietId, Guid mitarbeiterGruppeId, CancellationToken ct) =>
        await Build(new GebietEinsatzleitung { GebietId = gebietId, MitarbeiterGruppeId = mitarbeiterGruppeId })
            .SeedAsync(ct);

    /// <summary>
    /// Creates or renames the Prozess, publishes a new version only when the template or the seed content changed,
    /// and makes its tags match seed.json exactly.
    /// </summary>
    private async Task SeedProzess(Guid idNamespace, Guid kommuneId, LageHelferProzessSeed seed, CancellationToken ct) {
        var prozessId = ProzessId(idNamespace, seed.Key);
        var prozess = await DbContext.Prozesse.AsTracking().Include(p => p.Tags)
            .FirstOrDefaultAsync(p => p.Id == prozessId, ct);
        if (prozess is null) {
            prozess = new Prozess { Id = prozessId, Name = seed.Name, KommuneId = kommuneId };
            DbContext.Prozesse.Add(prozess);
        } else if (prozess.KommuneId != kommuneId) {
            throw new InvalidOperationException(
                $"Prozess '{seed.Key}' ({prozessId}) gehört zu einer anderen Kommune als in seed.json angegeben.");
        } else {
            prozess.Name = seed.Name;
        }

        var (fingerprint, beschreibungstext) = seed.Vorlage switch {
            LageHelferProzessVorlage.Ereignismeldung =>
                (EreignismeldungVorlage.Fingerprint(seed), EreignismeldungVorlage.Beschreibungstext),
            _ => throw new InvalidOperationException($"Vorlage {seed.Vorlage} ist nicht implementiert."),
        };
        var versionId = ProzessVersionId(idNamespace, seed.Key, fingerprint);
        if (!await DbContext.ProzessVersionen.AnyAsync(v => v.Id == versionId, ct)) {
            var (schritte, verbindungen, rollen) = EreignismeldungVorlage.Build(seed, versionId);
            foreach (var verbindung in verbindungen) {
                verbindung.Von.Verbindungen.Add(verbindung);
            }

            var now = _clock.GetCurrentInstant();
            var version = new ProzessVersion {
                Id = versionId,
                Prozess = prozess,
                CreatedAt = now,
                PublishedAt = now,
                Schritte = schritte,
                Rollen = rollen,
                Beschreibungstext = beschreibungstext,
            };
            DbContext.ProzessVersionen.Add(version);
            await SaveChangesAsync(ct);
            version.StartId = schritte[0].Id;
            _logger.LogInformation("LageHelfer-Prozess '{Prozess}' in neuer Version {Version} veröffentlicht.",
                seed.Key, versionId);
        }

        await SyncTags(idNamespace, prozess, seed.Tags, ct);
    }

    private async Task SyncTags(Guid idNamespace, Prozess prozess, IReadOnlyList<string> tagNames,
        CancellationToken ct) {
        var tags = new List<ProzessTag>();
        foreach (var name in tagNames) {
            var tag = DbContext.ProzessTags.Local.FirstOrDefault(t => t.Tag == name)
                ?? await DbContext.ProzessTags.AsTracking().FirstOrDefaultAsync(t => t.Tag == name, ct);
            if (tag is null) {
                tag = new ProzessTag { Id = TagId(idNamespace, name), Tag = name };
                DbContext.ProzessTags.Add(tag);
            }
            tags.Add(tag);
        }

        var tagIds = tags.Select(t => t.Id).ToHashSet();

        // Same rule as AssignProzessTag: a tag belongs to one Prozess per Kommune.
        var andereTraeger = await DbContext.Prozesse.AsTracking().Include(p => p.Tags)
            .Where(p => p.KommuneId == prozess.KommuneId && p.Id != prozess.Id
                && p.Tags.Any(t => tagIds.Contains(t.Id)))
            .ToListAsync(ct);
        foreach (var andererProzess in andereTraeger) {
            foreach (var tag in andererProzess.Tags.Where(t => tagIds.Contains(t.Id)).ToList()) {
                andererProzess.Tags.Remove(tag);
            }
        }

        foreach (var tag in prozess.Tags.Where(t => !tagIds.Contains(t.Id)).ToList()) {
            prozess.Tags.Remove(tag);
        }
        foreach (var tag in tags.Where(t => !prozess.Tags.Contains(t))) {
            prozess.Tags.Add(tag);
        }

        var bereitsInHistorie = await DbContext.ProzessTagHistorie
            .Where(h => h.ProzessId == prozess.Id)
            .Select(h => h.TagId)
            .ToListAsync(ct);
        foreach (var tag in tags.Where(t => !bereitsInHistorie.Contains(t.Id))) {
            DbContext.ProzessTagHistorie.Add(new ProzessTagHistorieEintrag {
                Id = Guid.NewGuid(),
                ProzessId = prozess.Id,
                TagId = tag.Id,
                ZugewiesenAm = _clock.GetCurrentInstant(),
            });
        }
    }

    private async Task SeedDemo(LageHelferSeedDocument document, Guid idNamespace,
        IReadOnlyDictionary<string, Untereinheit> organisationseinheiten,
        IReadOnlyDictionary<string, MitarbeiterGruppe> abteilungen, byte[] keyEncryptionKey, CancellationToken ct) {
        var demo = document.Demo!;
        var passwort = demo.Passwort;

        foreach (var seed in demo.Nutzer) {
            var art = ParseNutzerArt(seed.Art);
            MitarbeiterGruppe? gruppe = null;
            if (seed.EinsatzleitungBereich is not null
                && abteilungen.TryGetValue(seed.EinsatzleitungBereich, out var einsatzleitungGruppe)) {
                gruppe = einsatzleitungGruppe;
            } else if (seed.Organisationseinheit is not null) {
                var oe = document.Organisationseinheiten.First(o => o.Key == seed.Organisationseinheit);
                var abteilung = oe.Abteilungen.FirstOrDefault(a => a.Key == seed.Organisationseinheit)
                    ?? oe.Abteilungen.FirstOrDefault();
                if (abteilung is not null && abteilungen.TryGetValue(abteilung.Key, out var oeGruppe)) {
                    gruppe = oeGruppe;
                }
            }

            var globaleRechte = ParseGlobaleRechte(seed.GlobaleRechte);
            var user = await SeedNutzer(idNamespace, seed, art, document.Kommune.Id, gruppe, passwort, keyEncryptionKey,
                globaleRechte, ct);

            if (art == BackofficeNutzerArt.Admin) {
                foreach (var oe in organisationseinheiten.Values) {
                    await SeedPermissions(oe, user,
                        [
                            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                            FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung,
                        ], ct);
                }

                continue;
            }

            var rechte = ParseRechte(seed.Rechte);
            if (rechte.Length == 0) {
                continue;
            }

            if (seed.Organisationseinheit is not null
                && organisationseinheiten.TryGetValue(seed.Organisationseinheit, out var oeUntereinheit)) {
                await SeedPermissions(oeUntereinheit, user, rechte, ct);
            }
        }
    }

    private async Task<BackofficeUser> SeedNutzer(Guid idNamespace, LageHelferDemoNutzerSeed seed,
        BackofficeNutzerArt art, Guid kommuneId, MitarbeiterGruppe? abteilung, string passwort,
        byte[] keyEncryptionKey, GlobaleFunktionsberechtigung[] globaleRechte, CancellationToken ct) =>
        await Build(new BackofficeUser {
            Id = NutzerId(idNamespace, seed.Key),
            EMail = seed.Email,
            Vorname = seed.Vorname,
            Nachname = seed.Nachname,
            KommuneId = kommuneId,
            Password = passwort,
            Gruppen = abteilung is not null ? [abteilung] : [],
            Art = art,
            Funktionsberechtigungen = [.. globaleRechte],
        }).OnCreate(user => user.SetOrganisationCryptoAndPassword(passwort, keyEncryptionKey, _passwordHasher))
            .OnUpdate((current, next) => {
                current.Vorname = next.Vorname;
                current.Nachname = next.Nachname;
                current.Art = next.Art;
                current.Funktionsberechtigungen = next.Funktionsberechtigungen;
            })
            .SeedAsync(ct);

    private async Task SeedPermissions(Untereinheit untereinheit, BackofficeUser user,
        FunktionsberechtigungInOrganisationseinheit[] rechte, CancellationToken ct) =>
        await Build(new UntereinheitPermissions {
            UntereinheitId = untereinheit.Id,
            BackofficeUserId = user.Id,
            Funktionsberechtigungen = [.. rechte],
        }).OnUpdate((current, next) => current.Funktionsberechtigungen = next.Funktionsberechtigungen)
            .SeedAsync(ct);

    private static BackofficeNutzerArt ParseNutzerArt(string art) =>
        art switch {
            "Superadmin" => BackofficeNutzerArt.Superadmin,
            "Admin" => BackofficeNutzerArt.Admin,
            "Nutzer" => BackofficeNutzerArt.Nutzer,
            _ => throw new InvalidOperationException($"Unbekannte Nutzer-Art '{art}'."),
        };

    private static FunktionsberechtigungInOrganisationseinheit[] ParseRechte(IReadOnlyList<string>? rechte) {
        if (rechte is null || rechte.Count == 0) {
            return [];
        }

        return rechte.Select(r => r switch {
            "BackofficeAntraege" => FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
            "BackofficeNutzendenverwaltung" =>
                FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung,
            _ => throw new InvalidOperationException($"Unbekanntes Recht '{r}'."),
        }).ToArray();
    }

    private static GlobaleFunktionsberechtigung[] ParseGlobaleRechte(IReadOnlyList<string>? rechte) {
        if (rechte is null || rechte.Count == 0) {
            return [];
        }

        return rechte.Select(r => r switch {
            "LageHelfer" => GlobaleFunktionsberechtigung.LageHelfer,
            _ => throw new InvalidOperationException($"Unbekanntes globales Recht '{r}'."),
        }).ToArray();
    }
}
