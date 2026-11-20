using API.Features;
using API.Features.Auth;
using API.Features.Ehrenamtsbank;
using API.Seeders.Base;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Seeders;

/// <summary>Seedet Beispiel-Kategorien, Bürger und Einträge für die Ehrenamtsbank (nur Dev-Seeding).</summary>
public class EhrenamtsbankSeeder : DataSeeder<DomainContext> {
    private static readonly Guid Namespace = Guid.Parse("7e3f2a9c-1b5d-4c8e-9f0a-263263263263");

    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly ILogger<EhrenamtsbankSeeder> _logger;
    private readonly IClock _clock;

    public override bool MustRunBeforeImports => false;

    public EhrenamtsbankSeeder(IDbContextFactory<DomainContext> dbContextFactory,
        ILogger<EhrenamtsbankSeeder> logger, IEnumerable<IValidator> validators, IClock clock)
        : base(dbContextFactory, logger, validators) {
        _dbContextFactory = dbContextFactory;
        _logger = logger;
        _clock = clock;
    }

    private record KategorieSeed(string Key, string Name, bool RequiresClearance, string? ParentKey, int Sort);

    private static readonly KategorieSeed[] Kategorien = [
        new("haus-garten", "Haus & Garten", false, null, 0),
        new("gartenpflege", "Gartenpflege", false, "haus-garten", 0),
        new("kleine-reparaturen", "Kleine Reparaturen", false, "haus-garten", 1),
        new("betreuung", "Betreuung", true, null, 1),
        new("kinderbetreuung", "Kinderbetreuung", false, "betreuung", 0),
        new("seniorenbegleitung", "Seniorenbegleitung", false, "betreuung", 1),
    ];

    private record EintragSeed(
        string Key, EhrenamtsbankEintragTyp Typ, EhrenamtsbankEintragStatus Status,
        string KategorieKey, int GemeindeIndex, bool OwnerMitClearance,
        string Title, string Description, int? RadiusKm,
        EhrenamtsbankDringlichkeit? Urgency, int? EstimatedDurationMinutes, string? Availability,
        string[] Tags, EhrenamtsbankLocation? Location = null);

    // Some entries deliberately have no Location so a search shows both cases: with and
    // without a distance.
    private static readonly EintragSeed[] Eintraege = [
        new("hecken-schneiden", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.Active,
            "gartenpflege", 0, false, "Hecken schneiden",
            "Die Hecke am Vorgarten ist mir über den Kopf gewachsen. Werkzeug ist vorhanden.",
            5, EhrenamtsbankDringlichkeit.Mittel, 120, null, ["Werkzeug vorhanden", "Außenarbeit"],
            new EhrenamtsbankLocation("Deisterallee 12, 31785 Hameln", 52.1039, 9.3564)),
        new("regal-aufbauen", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.Active,
            "kleine-reparaturen", 1, false, "Regal aufbauen",
            "Ein Bücherregal muss zusammengebaut und an der Wand befestigt werden.",
            10, EhrenamtsbankDringlichkeit.Niedrig, 90, null, ["Innenarbeit"]),
        new("rasen-maehen-angebot", EhrenamtsbankEintragTyp.Angebot, EhrenamtsbankEintragStatus.Active,
            "gartenpflege", 0, true, "Ich mähe Rasen im Sommer",
            "Eigener Rasenmäher vorhanden, ich helfe gerne in der Nachbarschaft.",
            15, null, null, "Wochentags ab 16 Uhr, samstags flexibel", ["Eigenes Gerät"],
            new EhrenamtsbankLocation("Ohsener Straße 45, 31789 Hameln", 52.0921, 9.3502)),
        new("arztbegleitung-angebot", EhrenamtsbankEintragTyp.Angebot, EhrenamtsbankEintragStatus.Active,
            "seniorenbegleitung", 1, true, "Begleitung zu Arztterminen",
            "Ich begleite gerne zu Arztterminen und übernehme die Fahrt.",
            20, null, null, "Dienstags und donnerstags vormittags", ["Führungszeugnis", "Mit Auto"],
            new EhrenamtsbankLocation("Brunnenstraße 8, 31812 Bad Pyrmont", 51.9861, 9.2519)),
        new("hausaufgabenhilfe-gesuch", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.Draft,
            "kinderbetreuung", 0, false, "Hausaufgabenhilfe gesucht",
            "Für die 4. Klasse suchen wir Unterstützung bei den Hausaufgaben.",
            5, EhrenamtsbankDringlichkeit.Mittel, 60, null, ["Regelmäßig"]),
        new("laub-harken", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.PendingReview,
            "gartenpflege", 1, false, "Laub harken im Herbst",
            "Der Garten ist voller Laub, alleine schaffe ich das nicht mehr.",
            5, EhrenamtsbankDringlichkeit.Hoch, 180, null, ["Außenarbeit", "Saisonal"],
            new EhrenamtsbankLocation("Kirchstraße 3, 31855 Aerzen", 52.0453, 9.2669)),
        new("reparaturen-angebot", EhrenamtsbankEintragTyp.Angebot, EhrenamtsbankEintragStatus.PendingReview,
            "kleine-reparaturen", 0, true, "Kleine Reparaturen im Haushalt",
            "Tropfende Hähne, klemmende Türen — ich schaue mir das gerne an.",
            25, null, null, "Nach Absprache", ["Eigenes Werkzeug"]),
        new("fahrrad-reparieren", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.Paused,
            "kleine-reparaturen", 1, false, "Fahrrad reparieren",
            "Die Gangschaltung springt. Ersatzteile kann ich besorgen.",
            10, EhrenamtsbankDringlichkeit.Niedrig, 60, null, ["Werkzeug vorhanden"],
            new EhrenamtsbankLocation("Bahnhofstraße 21, 31860 Emmerthal", 52.0431, 9.3814)),
        new("umzugshilfe-gesuch", EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankEintragStatus.Completed,
            "kleine-reparaturen", 0, true, "Umzugshilfe für zwei Kartons",
            "Zwei schwere Kartons müssen in den ersten Stock getragen werden.",
            5, EhrenamtsbankDringlichkeit.Hoch, 45, null, ["Tragen"]),
        new("einkaufsdienst-angebot", EhrenamtsbankEintragTyp.Angebot, EhrenamtsbankEintragStatus.Closed,
            "seniorenbegleitung", 1, true, "Einkaufsdienst für Senioren",
            "Ich erledige Einkäufe und bringe sie bis an die Wohnungstür.",
            15, null, null, "Freitags vormittags", ["Führungszeugnis"]),
    ];

    protected override async Task Run(CancellationToken cancellationToken = default) {
        await using var db = await _dbContextFactory.CreateDbContextAsync(cancellationToken);
        var gemeinden = await db.Untereinheit
            .Where(u => u.IsGemeinde)
            .OrderBy(u => u.Name).ThenBy(u => u.Id)
            .Take(2)
            .Select(u => u.Id)
            .ToListAsync(cancellationToken);
        if (gemeinden.Count == 0) {
            _logger.LogWarning("Keine Gemeinde-Untereinheit vorhanden, Ehrenamtsbank-Einträge werden übersprungen.");
            return;
        }

        // Eine bereits gepflegte Kategorie-Landschaft (z.B. import-kategorie-baum) darf das
        // Beispiel-Seeding weder überschreiben noch um Fantasie-Kategorien ergänzen.
        var eigeneKategorieIds = Kategorien.Select(k => DeriveId(Namespace, k.Key)).ToHashSet();
        var fremdeKategorieVorhanden = await db.EhrenamtsbankKategorien
            .AnyAsync(k => !eigeneKategorieIds.Contains(k.Id), cancellationToken);
        if (fremdeKategorieVorhanden) {
            _logger.LogInformation(
                "Ehrenamtsbank-Kategorien sind bereits gepflegt, Beispieldaten werden übersprungen.");
            return;
        }

        foreach (var seed in Kategorien) {
            await SeedKategorie(seed, cancellationToken);
        }

        var mitClearance = await SeedBuerger("buerger-mit-clearance", "Magdalena", "Schmidt",
            clearance: true, phone: "+491701234567", ct: cancellationToken);
        var ohneClearance = await SeedBuerger("buerger-ohne-clearance", "Jonas", "Weber",
            clearance: false, phone: "+491709876543", ct: cancellationToken);

        var now = _clock.GetCurrentInstant();
        for (var i = 0; i < Eintraege.Length; i++) {
            var seed = Eintraege[i];
            await SeedEintrag(
                seed,
                ownerId: seed.OwnerMitClearance ? mitClearance.Id : ohneClearance.Id,
                untereinheitId: gemeinden[seed.GemeindeIndex % gemeinden.Count],
                createdAt: now.Minus(Duration.FromDays(i)),
                cancellationToken);
        }
    }

    private async Task SeedKategorie(KategorieSeed seed, CancellationToken ct) =>
        await Build(new EhrenamtsbankKategorie {
            Id = DeriveId(Namespace, seed.Key),
            Name = seed.Name,
            Active = true,
            RequiresClearance = seed.RequiresClearance,
            ParentId = seed.ParentKey is null ? null : DeriveId(Namespace, seed.ParentKey),
            Sort = seed.Sort,
        }).OnUpdate((current, next) => {
            current.Name = next.Name;
            current.RequiresClearance = next.RequiresClearance;
            current.ParentId = next.ParentId;
            current.Sort = next.Sort;
        }).SeedAsync(ct);

    private async Task<Buerger> SeedBuerger(
        string key, string vorname, string nachname, bool clearance, string phone, CancellationToken ct) =>
        await Build(new Buerger {
            Id = DeriveId(Namespace, key),
            PersonalDataKeyEncryptedForBuerger = "",
            IsRegistered = true,
            RequiresClearanceVerified = clearance,
            Vorname = vorname,
            Nachname = nachname,
            Phone = phone,
            PhoneVerified = true,
        }).OnUpdate((current, next) => {
            current.IsRegistered = next.IsRegistered;
            current.RequiresClearanceVerified = next.RequiresClearanceVerified;
            current.Vorname = next.Vorname;
            current.Nachname = next.Nachname;
            current.Phone = next.Phone;
            current.PhoneVerified = next.PhoneVerified;
        }).SeedAsync(ct);

    private async Task SeedEintrag(
        EintragSeed seed, Guid ownerId, Guid untereinheitId, Instant createdAt, CancellationToken ct) {
        var reviewedAt = seed.Status is EhrenamtsbankEintragStatus.Active
            or EhrenamtsbankEintragStatus.Paused
            or EhrenamtsbankEintragStatus.Completed
            or EhrenamtsbankEintragStatus.Closed
            ? createdAt
            : (Instant?)null;

        await Build(new EhrenamtsbankEintrag {
            Id = DeriveId(Namespace, seed.Key),
            Typ = seed.Typ,
            OwnerId = ownerId,
            Title = seed.Title,
            Description = seed.Description,
            KategorieId = DeriveId(Namespace, seed.KategorieKey),
            UntereinheitId = untereinheitId,
            RadiusKm = seed.RadiusKm,
            Status = seed.Status,
            Urgency = seed.Urgency,
            EstimatedDurationMinutes = seed.EstimatedDurationMinutes,
            Availability = seed.Availability,
            Tags = [.. seed.Tags],
            Address = seed.Location?.Address,
            Latitude = seed.Location?.Latitude,
            Longitude = seed.Location?.Longitude,
            CreatedAt = createdAt,
            UpdatedAt = createdAt,
            ReviewedAt = reviewedAt,
        }).OnUpdate((current, next) => {
            current.Typ = next.Typ;
            current.OwnerId = next.OwnerId;
            current.Title = next.Title;
            current.Description = next.Description;
            current.KategorieId = next.KategorieId;
            current.UntereinheitId = next.UntereinheitId;
            current.RadiusKm = next.RadiusKm;
            current.Status = next.Status;
            current.Urgency = next.Urgency;
            current.EstimatedDurationMinutes = next.EstimatedDurationMinutes;
            current.Availability = next.Availability;
            current.Tags = next.Tags;
            (current.Address, current.Latitude, current.Longitude) =
                (next.Address, next.Latitude, next.Longitude);
            current.ReviewedAt = next.ReviewedAt;
        }).SeedAsync(ct);
    }
}
