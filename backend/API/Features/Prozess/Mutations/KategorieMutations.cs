using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace API.Features.Prozess.Mutations;

/// <summary>Eingabe zum Anlegen einer Kategorie im Mängelmelder-Kategoriebaum.</summary>
/// <param name="ParentId">
/// Übergeordnete Kategorie, oder null für eine neue Top-Level-Kategorie. Bei einer eigenen Kategorie einer
/// Untereinheit muss der Elternknoten entweder geteilt sein oder derselben Untereinheit gehören.
/// </param>
/// <param name="UntereinheitId">Null = geteilte, für alle Untereinheiten sichtbare Kategorie.</param>
public record KategorieCreateInput(Guid? ParentId, Guid? UntereinheitId, string Name);

/// <summary>
/// Eingabe zum Setzen oder Vererben-Lassen der Zuständigkeit einer Kategorie.
/// </summary>
/// <param name="Erbt">
/// True = keine eigene Zuständigkeit, es gilt die des nächsten Elternknotens (Ziel-Felder werden ignoriert).
/// </param>
public record KategorieZustaendigkeitSetzenInput(Guid KategorieId, bool Erbt, ZustaendigkeitArt Art, Guid? MitarbeiterGruppeId, Guid? DienstleisterId);

/// <summary>Stellt Mutationen für den Mängelmelder-Kategoriebaum bereit.</summary>
[MutationType]
public class KategorieMutations {
    /// <summary>Legt eine neue Kategorie an. Ohne eigene Zuständigkeit erbt sie die des Elternknotens.</summary>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<Kategorie> KategorieCreate(DomainContext domainContext, KategorieCreateInput input, CurrentUserAccessor currentUserAccessor, [Service] KategorieSyncExport syncExport) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        if (string.IsNullOrWhiteSpace(input.Name)) throw new NotAllowedException("Der Name darf nicht leer sein.");

        await EnsureDarfKategorieVerwalten(berechtigungen, user, input.UntereinheitId);

        Kategorie? parent = null;
        if (input.ParentId is { } parentId) {
            parent = await domainContext.Kategorien
                .Where(k => k.Id == parentId && k.KommuneId == user.KommuneId)
                .FirstOrDefaultAsync() ?? throw new NotAllowedException("Übergeordnete Kategorie nicht gefunden.");

            if (input.UntereinheitId is { } eigeneId && parent.UntereinheitId is { } parentUntereinheitId && parentUntereinheitId != eigeneId) {
                throw new NotAllowedException("Eine eigene Kategorie darf nicht unter der eigenen Kategorie einer anderen Untereinheit angelegt werden.");
            }
            if (input.UntereinheitId is null && parent.UntereinheitId is not null) {
                throw new NotAllowedException("Eine geteilte Kategorie darf nicht unter einer Untereinheit-eigenen Kategorie angelegt werden.");
            }
        }

        var kategorie = new Kategorie {
            Id = Guid.NewGuid(),
            KommuneId = user.KommuneId,
            ParentId = parent?.Id,
            UntereinheitId = input.UntereinheitId,
            Name = input.Name.Trim(),
        };

        domainContext.Kategorien.Add(kategorie);

        await using var transaction = await domainContext.Database.BeginTransactionAsync();
        await SaveOrThrowOnDuplicateName(domainContext, input.Name);
        await syncExport.RunAsync(domainContext, user.KommuneId);
        await transaction.CommitAsync();

        return kategorie;
    }

    /// <summary>
    /// Benennt eine Kategorie um; bei einer geteilten Kategorie werden eigene Zwillinge (gleicher ParentId,
    /// bisheriger Name) mit umbenannt, sonst verliert ihr Zuständigkeits-Override beim Routing eingehender
    /// Meldungen stillschweigend den Namensbezug (kein Fremdschlüssel, reines Name-Matching überall).
    /// </summary>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<Kategorie> KategorieRename(DomainContext domainContext, Guid id, string name, CurrentUserAccessor currentUserAccessor, [Service] KategorieSyncExport syncExport) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        if (string.IsNullOrWhiteSpace(name)) throw new NotAllowedException("Der Name darf nicht leer sein.");

        var kategorie = await domainContext.Kategorien.AsTracking()
            .Where(k => k.Id == id && k.KommuneId == user.KommuneId)
            .FirstOrDefaultAsync() ?? throw new NotAllowedException();

        if (kategorie.IstWurzel) throw new NotAllowedException("Der Wurzel-Knoten kann nicht umbenannt werden.");

        await EnsureDarfKategorieVerwalten(berechtigungen, user, kategorie.UntereinheitId);

        var alterName = kategorie.Name;
        var neuerName = name.Trim();
        kategorie.Name = neuerName;

        if (kategorie.UntereinheitId is null) {
            var zwillinge = await domainContext.Kategorien.AsTracking()
                .Where(k => k.KommuneId == user.KommuneId && k.ParentId == kategorie.ParentId
                    && k.UntereinheitId != null && k.Name == alterName)
                .ToListAsync();
            foreach (var zwilling in zwillinge) zwilling.Name = neuerName;
        }

        await using var transaction = await domainContext.Database.BeginTransactionAsync();
        await SaveOrThrowOnDuplicateName(domainContext, name);
        await syncExport.RunAsync(domainContext, user.KommuneId);
        await transaction.CommitAsync();

        return kategorie;
    }

    /// <summary>
    /// Setzt die eigene Zuständigkeit einer Kategorie, oder lässt sie wieder vom Elternknoten erben. Löst
    /// bewusst keinen Sync-Export aus: die Zuständigkeit fließt nie in die generierten Formularfelder ein,
    /// sondern wird erst zur Laufzeit vom Routing-Schritt live aus der Tabelle gelesen.
    /// </summary>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<Kategorie> KategorieZustaendigkeitSetzen(DomainContext domainContext, KategorieZustaendigkeitSetzenInput input, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        var kategorie = await domainContext.Kategorien.AsTracking()
            .Where(k => k.Id == input.KategorieId && k.KommuneId == user.KommuneId)
            .FirstOrDefaultAsync() ?? throw new NotAllowedException();

        var geltendeUntereinheitId = kategorie.UntereinheitId ?? throw new NotAllowedException(
            "Für eine geteilte Kategorie kann keine Zuständigkeit direkt gesetzt werden, nur für die eigene Kategorie einer Untereinheit.");

        if (kategorie.IstWurzel && input.Erbt) {
            throw new NotAllowedException("Der Wurzel-Knoten (Standard-Zuständigkeit) kann nicht auf 'erbt' gestellt werden.");
        }

        berechtigungen.InOrganisationseinheit(geltendeUntereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();

        var untereinheit = await domainContext.Untereinheit
            .Where(u => u.Id == geltendeUntereinheitId)
            .FirstOrDefaultAsync() ?? throw new NotAllowedException();

        kategorie.Ziel = input.Erbt ? null : await BuildZiel(domainContext, untereinheit, input);
        await domainContext.SaveChangesAsync();
        return kategorie;
    }

    /// <summary>Löscht eine Kategorie und alle ihre Unterkategorien (Cascade über die Datenbank-Fremdschlüssel).</summary>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> KategorieDelete(DomainContext domainContext, Guid id, CurrentUserAccessor currentUserAccessor, [Service] KategorieSyncExport syncExport) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        var kategorie = await domainContext.Kategorien.AsTracking()
            .Where(k => k.Id == id && k.KommuneId == user.KommuneId)
            .FirstOrDefaultAsync() ?? throw new NotAllowedException();

        if (kategorie.IstWurzel) throw new NotAllowedException("Der Wurzel-Knoten einer Untereinheit kann nicht gelöscht werden.");

        await EnsureDarfKategorieVerwalten(berechtigungen, user, kategorie.UntereinheitId);

        domainContext.Kategorien.Remove(kategorie);

        await using var transaction = await domainContext.Database.BeginTransactionAsync();
        await domainContext.SaveChangesAsync();
        await syncExport.RunAsync(domainContext, user.KommuneId);
        await transaction.CommitAsync();

        return true;
    }

    /// <summary>Blendet eine geteilte Kategorie für eine Untereinheit aus, ohne sie für andere zu entfernen.</summary>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> KategorieAusblendungSetzen(DomainContext domainContext, Guid kategorieId, Guid untereinheitId, CurrentUserAccessor currentUserAccessor, [Service] KategorieSyncExport syncExport) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InOrganisationseinheit(untereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();

        var kategorieIstGeteilt = await domainContext.Kategorien
            .Where(k => k.Id == kategorieId && k.KommuneId == user.KommuneId && k.UntereinheitId == null)
            .AnyAsync();
        if (!kategorieIstGeteilt) throw new NotAllowedException("Nur geteilte Kategorien können ausgeblendet werden.");

        var ausblendung = new KategorieAusblendung { Id = Guid.NewGuid(), KategorieId = kategorieId, UntereinheitId = untereinheitId };
        domainContext.KategorieAusblendungen.Add(ausblendung);

        await using var transaction = await domainContext.Database.BeginTransactionAsync();
        await transaction.CreateSavepointAsync("vor_ausblendung_insert");
        try {
            await domainContext.SaveChangesAsync();
        } catch (DbUpdateException e) when (e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation }) {
            // Bereits ausgeblendet - idempotent behandeln. Savepoint zurückrollen (Postgres markiert die
            // ganze Transaction nach einem fehlgeschlagenen Statement sonst als "aborted"), und den
            // ungespeichert gebliebenen Insert aus dem Change Tracker entfernen, damit er nicht beim
            // nächsten SaveChangesAsync (innerhalb von syncExport.RunAsync) erneut versucht wird.
            await transaction.RollbackToSavepointAsync("vor_ausblendung_insert");
            domainContext.Entry(ausblendung).State = EntityState.Detached;
        }
        await syncExport.RunAsync(domainContext, user.KommuneId);
        await transaction.CommitAsync();
        return true;
    }

    /// <summary>Hebt die Ausblendung einer geteilten Kategorie für eine Untereinheit wieder auf.</summary>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> KategorieAusblendungAufheben(DomainContext domainContext, Guid kategorieId, Guid untereinheitId, CurrentUserAccessor currentUserAccessor, [Service] KategorieSyncExport syncExport) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InOrganisationseinheit(untereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();

        var ausblendung = await domainContext.KategorieAusblendungen.AsTracking()
            .Where(a => a.KategorieId == kategorieId && a.UntereinheitId == untereinheitId)
            .FirstOrDefaultAsync();
        if (ausblendung is not null) {
            domainContext.KategorieAusblendungen.Remove(ausblendung);

            await using var transaction = await domainContext.Database.BeginTransactionAsync();
            await domainContext.SaveChangesAsync();
            await syncExport.RunAsync(domainContext, user.KommuneId);
            await transaction.CommitAsync();
        }
        return true;
    }

    /// <summary>
    /// Geteilte Kategorien (wirken sich auf alle Untereinheiten aus) dürfen nur von Superadmins angelegt,
    /// umbenannt oder gelöscht werden. Für eigene Kategorien reicht die übliche OE-Berechtigung.
    /// </summary>
    private static Task EnsureDarfKategorieVerwalten(
        BackofficeUserFunktionsberechtigungenHelpers berechtigungen, BackofficeUser user, Guid? untereinheitId
    ) {
        if (untereinheitId is { } id) {
            berechtigungen.InOrganisationseinheit(id, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();
            return Task.CompletedTask;
        }

        if (user.Art != BackofficeNutzerArt.Superadmin) {
            throw new NotAllowedException("Geteilte Kategorien können nur von Superadmins verwaltet werden.");
        }

        return Task.CompletedTask;
    }

    /// <summary>
    /// Speichert und übersetzt eine Verletzung des eindeutigen Index auf (ParentId, UntereinheitId, Name) in
    /// eine verständliche Fehlermeldung (deckt nur den nicht-gleichzeitigen Fall ab - die eigentliche
    /// Absicherung gegen zwei gleichzeitige Anfragen mit demselben Namen ist der Datenbank-Index selbst).
    /// </summary>
    private static async Task SaveOrThrowOnDuplicateName(DomainContext domainContext, string name) {
        try {
            await domainContext.SaveChangesAsync();
        } catch (DbUpdateException e) when (e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation }) {
            throw new NotAllowedException($"Unter dieser übergeordneten Kategorie existiert bereits eine Kategorie namens '{name.Trim()}'.");
        }
    }

    private static async Task<Zustaendigkeit> BuildZiel(DomainContext domainContext, Untereinheit.Untereinheit untereinheit, KategorieZustaendigkeitSetzenInput input) {
        switch (input.Art) {
            case ZustaendigkeitArt.Organisationseinheit: {
                    if (input.MitarbeiterGruppeId is not { } mitarbeiterGruppeId) {
                        throw new NotAllowedException("Es muss eine Abteilung ausgewählt werden.");
                    }

                    var gehoertZurUntereinheit = await domainContext.MitarbeiterGruppen
                        .Where(g => g.Id == mitarbeiterGruppeId && g.KommuneId == untereinheit.KommuneId && !g.IsDeleted)
                        .Where(g => g.Organisationseinheiten.Any(o => o.Id == untereinheit.Id))
                        .AnyAsync();
                    if (!gehoertZurUntereinheit) {
                        throw new NotAllowedException("Die Abteilung gehört nicht zu dieser Untereinheit.");
                    }

                    return new Zustaendigkeit { Art = ZustaendigkeitArt.Organisationseinheit, OrganisationseinheitId = untereinheit.Id, MitarbeiterGruppeId = mitarbeiterGruppeId };
                }
            case ZustaendigkeitArt.Dienstleister: {
                    if (input.DienstleisterId is not { } dienstleisterId) {
                        throw new NotAllowedException("Es muss ein Dienstleister ausgewählt werden.");
                    }

                    var gehoertZurUntereinheit = await domainContext.Dienstleister
                        .Where(d => d.Id == dienstleisterId && d.MandantId == untereinheit.KommuneId)
                        .Where(d => d.Organisationseinheiten.Any(o => o.Id == untereinheit.Id))
                        .AnyAsync();
                    if (!gehoertZurUntereinheit) {
                        throw new NotAllowedException("Der Dienstleister ist dieser Untereinheit nicht zugeordnet.");
                    }

                    return new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = dienstleisterId };
                }
            default:
                throw new NotAllowedException("Ungültige Zuständigkeitsart für eine Kategorie.");
        }
    }
}
