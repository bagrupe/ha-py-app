using API.Features.Auth;
using API.Features.Expressions;
using API.Features.Funktionsberechtigungen;
using API.Features.MaengelMelder;
using API.Features.MaengelMelder.Queries;
using API.Infrastructure;
using HotChocolate.Authorization;
using HotChocolate.Language;
using HotChocolate.Resolvers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using NodaTime;

namespace API.Features.Prozess.Queries;

/// <summary>Stellt Abfragen für Ausführungen (Anträge) bereit.</summary>
[QueryType]
public class AusfuehrungQueries {
    public const int CutoffDays = 180;

    /// <summary>Liefert eine paginierte Liste aller sichtbaren Anträge für den angemeldeten Backoffice-Nutzer.</summary>
    /// <param name="funktionsberechtigungenService">Service zur Ermittlung von Berechtigungen.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="status">Optionaler Filter nach Status.</param>
    /// <param name="zugewiesen">Optionaler Filter nach Zuweisung.</param>
    /// <param name="prozessId">Optionaler Filter nach Prozess-ID.</param>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <returns>Queryable mit den gefilterten Ausführungen.</returns>
    [GraphQLDescription("Liefert eine paginierte Liste aller Anträge (Ausführungen), die für den angemeldeten Backoffice-Nutzer sichtbar sind. Optional filterbar nach Status, Zuweisung oder Prozess.")]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Authorize]
    [Error(typeof(NotAllowedException))]
    public async Task<IQueryable<Ausfuehrung>> GetAusfuehrungen(
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        AusfuehrungStatus? status,
        bool? zugewiesen,
        Guid? prozessId,
        DomainContext domainContext,
        [Service] IClock clock
    ) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();

        var organisationseinheitenIds = (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(user))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = user.Gruppen.Select(g => g.Id).ToList();

        // Soft-gelöschte Anträge (GeloeschtAm != null) niemals im Backoffice anzeigen.
        var ausfuehrungMitZustaendigkeit = ausfuehrungZustaendigkeitService.FilterSichtbareAusfuehrungen(
            domainContext.Ausfuehrungen.NotDeleted().AsSplitQuery(),
            user,
            organisationseinheitenIds,
            mitarbeiterGruppenIds);

        if (status == AusfuehrungStatus.Abgeschlossen && user.Art != BackofficeNutzerArt.Superadmin) {
            var now = clock.GetCurrentInstant();
            var cutoffDate = now - Duration.FromDays(CutoffDays);
            ausfuehrungMitZustaendigkeit = ausfuehrungMitZustaendigkeit.Where(
                ausfuehrung => ausfuehrung.AbgeschlossenAm >= cutoffDate
            );
        }

        ausfuehrungMitZustaendigkeit = zugewiesen switch {
            true => ausfuehrungMitZustaendigkeit.Where(a => a.IstZustaendigkeit.ZugewiesenePersonId != null),
            false => ausfuehrungMitZustaendigkeit.Where(a => a.IstZustaendigkeit.ZugewiesenePersonId == null),
            _ => ausfuehrungMitZustaendigkeit
        };

        return ausfuehrungMitZustaendigkeit
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .Where(a => status == null || a.Status == status)
            .Where(a => a.ProzessVersion.Prozess.KommuneId == user.KommuneId)
            .Where(a => prozessId == null || a.ProzessVersion.ProzessId == prozessId)
            .OrderByDescending(a => a.CreatedAt);
    }
}

/// <summary>Erweitert den User-Typ um Abfragen zu Ausführungen.</summary>
[ExtendObjectType<User>]
public class AusfuehrungUserQueries {
    /// <summary>Liefert alle vom Nutzer erstellten Ausführungen.</summary>
    /// <param name="dataLoader">DataLoader zum Laden der Ausführungen.</param>
    /// <param name="user">Der Nutzer.</param>
    /// <returns>Liste der Ausführungen des Nutzers.</returns>
    [GraphQLDescription("Liefert alle Anträge (Ausführungen), die vom aktuellen Nutzer erstellt wurden.")]
    public async Task<IEnumerable<Ausfuehrung>> GetAusfuehrungen(IAusfuehrungenByUserIdDataLoader dataLoader,
        IMaengelByUserIdDataLoader maengelLoader,
        [Parent] User user,
        [Service] MaengelSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await dataLoader.LoadAsync(user.Id);
        var maengel = await maengelLoader.LoadAsync(user.Id);
        var expiredMaengelIds = await UserMaengelQueries.GetExpiredMaengelIds(
            maengel, sichtbarkeitService, clock);

        return ausfuehrungen.Where(a => !expiredMaengelIds.Contains(a.Id));
    }

    /// <summary>Lädt Ausführungen gruppiert nach Nutzer-IDs.</summary>
    /// <param name="ids">Liste der Nutzer-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Lookup mit Nutzer-ID als Schlüssel und Ausführungen als Wert.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetAusfuehrungenByUserId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Ausfuehrungen.NotDeleted().Where(a => ids.Contains(a.UserId))
            .ToLookupAsync(a => a.UserId, ct);
    }
}

/// <summary>Erweitert den Ausfuehrung-Typ um zusätzliche Felder und Abfragen.</summary>
[ExtendObjectType<Ausfuehrung>]
public class AusfuehrungExtensions {
    /// <summary>Gibt den verschlüsselten Schlüssel für den Bürger zurück, wenn der aktuelle Nutzer der Antragsteller ist.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Verschlüsselter Schlüssel für den Bürger.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer nicht der Antragsteller ist.</exception>
    [GraphQLDescription("Gibt den verschlüsselten Schlüssel für Bürger zurück, sofern der aktuelle Nutzer der Antragsteller ist.")]
    public async Task<string> GetSharedKeyEncryptedForBuerger(CurrentUserAccessor currentUserAccessor,
        [Parent] Ausfuehrung ausfuehrung) {
        if (await currentUserAccessor.User() is not Buerger buerger) {
            throw new NotAllowedException();
        }

        if (ausfuehrung.UserId != buerger.Id) {
            throw new NotAllowedException();
        }

        return ausfuehrung.SharedKeyEncryptedForBuerger;
    }

    /// <summary>Gibt den Soft-Löschungszeitpunkt zurück (nur für Backoffice-Nutzer mit der
    /// Funktionsberechtigung 'Anträge löschen', Superadmins bestehen diese automatisch).</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Zeitpunkt der Soft-Löschung, oder null, wenn nicht gelöscht.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer nicht berechtigt ist.</exception>
    [GraphQLDescription("Zeitpunkt der Soft-Löschung. Null bedeutet: nicht gelöscht. Nur für Backoffice-Nutzer mit der Funktionsberechtigung 'Anträge löschen'.")]
    public async Task<Instant?> GetGeloeschtAm(CurrentUserAccessor currentUserAccessor,
        [Parent] Ausfuehrung ausfuehrung) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.AntragLoeschung).Fordern();

        return ausfuehrung.GeloeschtAm;
    }

    /// <summary>Gibt den Löschgrund zurück (nur für Backoffice-Nutzer mit der Funktionsberechtigung
    /// 'Anträge löschen', Superadmins bestehen diese automatisch).</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Begründung der Löschung, oder null, wenn nicht gelöscht.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer nicht berechtigt ist.</exception>
    [GraphQLDescription("Begründung der Löschung. Nur für Backoffice-Nutzer mit der Funktionsberechtigung 'Anträge löschen'.")]
    public async Task<string?> GetLoeschgrund(CurrentUserAccessor currentUserAccessor,
        [Parent] Ausfuehrung ausfuehrung) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.AntragLoeschung).Fordern();

        return ausfuehrung.Loeschgrund;
    }

    /// <summary>Liefert die Bearbeitungshistorie zu einer Ausführung.</summary>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <param name="loader">DataLoader für Bearbeitungen.</param>
    /// <returns>Liste der Bearbeitungen.</returns>
    [GraphQLDescription("Liefert die Bearbeitungshistorie zu diesem Antrag.")]
    public async Task<IEnumerable<Bearbeitung>>
        GetBearbeitungen([Parent] Ausfuehrung ausfuehrung, IBearbeitungenByAusfuehrungIdDataLoader loader) {
        return await loader.LoadAsync(ausfuehrung.Id);
    }

    /// <summary>Lädt Bearbeitungen gruppiert nach Ausführungs-IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Lookup mit Ausführungs-ID als Schlüssel und Bearbeitungen als Wert.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Bearbeitung>> BearbeitungenByAusfuehrungId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Bearbeitungen
            .AsSplitQuery()
            .Where(b => ids.Contains(b.AusfuehrungId))
            .Include(b => b.User)
            .Include(b => b.Schritt)
            .OrderBy(b => b.CreatedAt)
            .ToLookupAsync(b => b.AusfuehrungId, ct);
    }

    /// <summary>Gibt den verschlüsselten Schlüssel für die Kommune zurück, wenn der Nutzer berechtigt ist.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="kommuneIdByProzessVersionId">DataLoader zur Ermittlung der Kommune.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Verschlüsselter Schlüssel für die Kommune.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer nicht berechtigt ist.</exception>
    [GraphQLDescription("Gibt den verschlüsselten Schlüssel für die Kommune zurück, sofern der aktuelle Nutzer berechtigt ist.")]
    public async Task<string> GetSharedKeyEncryptedForKommune(
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        IKommuneIdByProzessVersionIdDataLoader kommuneIdByProzessVersionId, [Parent] Ausfuehrung ausfuehrung) {
        await ausfuehrungZustaendigkeitService.EnsureBackofficeZugriffAufAusfuehrung(ausfuehrung, currentUserAccessor);

        var (backofficeUser, _) = await currentUserAccessor.EnsureBackofficeUser();
        if (backofficeUser.KommuneId != await kommuneIdByProzessVersionId.LoadAsync(ausfuehrung.ProzessVersionId)) {
            throw new NotAllowedException();
        }

        return ausfuehrung.SharedKeyEncryptedForKommune;
    }

    /// <summary>Liefert alle Slot-Werte für eine Ausführung, optional filterbar nach Typ.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="kommuneIdByProzessVersionId">DataLoader zur Ermittlung der Kommune.</param>
    /// <param name="slotValuesByAusfuehrungId">DataLoader für Slot-Werte.</param>
    /// <param name="prozessIsPublicByAusfuehrungId">DataLoader zur Ermittlung der Öffentlichkeitsstatus.</param>
    /// <param name="slotValuesByAusfuehrungAndNameId">DataLoader für Slot-Werte nach Ausführung und Namen.</param>
    /// <param name="context">Resolver-Kontext, aus dem der Namensfilter (<c>where</c>) gelesen wird.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <param name="imagesRaw">Optionaler Parameter für Bilddaten.</param>
    /// <returns>Liste der Slot-Werte.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    [GraphQLDescription("Liefert alle Slot-Werte für diesen Antrag (z.B. ausgefüllte Formularfelder). Optional filterbar nach Typ.")]
    [HotChocolate.Data.UseFiltering]
    public async Task<IEnumerable<SlotValue>> GetSlotValues(CurrentUserAccessor currentUserAccessor,
        IKommuneIdByProzessVersionIdDataLoader kommuneIdByProzessVersionId,
        ISlotValuesByAusfuehrungIdDataLoader slotValuesByAusfuehrungId,
        ISlotValuesByAusfuehrungAndNameIdDataLoader slotValuesByAusfuehrungAndNameId,
        IIsProzessPublicByAusfuehrungIdDataLoader prozessIsPublicByAusfuehrungId,
        IOeffentlichSichtbareSlotNamesByProzessVersionIdDataLoader oeffentlichSichtbareSlotNames,
        IResolverContext context,
        [Parent] Ausfuehrung ausfuehrung,
        bool? imagesRaw = false) {
        var prozessIsPublic = await prozessIsPublicByAusfuehrungId.LoadAsync(ausfuehrung.Id);

        var user = await currentUserAccessor.User();
        if (user is BackofficeUser backofficeUser) {
            if (backofficeUser.KommuneId != await kommuneIdByProzessVersionId.LoadAsync(ausfuehrung.ProzessVersionId)) {
                throw new NotAllowedException();
            }
        } else if ((user is not Buerger buerger || ausfuehrung.UserId != buerger.Id) && !prozessIsPublic) {
            throw new NotAllowedException();
        }

        IEnumerable<SlotValue> slotValues;
        if (SlotNameFilter.TryExtractNames(context.ArgumentLiteral<IValueNode>("where")) is { } slotNames) {
            var gefunden = await Task.WhenAll(slotNames.Select(name =>
                slotValuesByAusfuehrungAndNameId.LoadAsync((ausfuehrung.Id, name))));
            slotValues = gefunden.OfType<SlotValue>().ToList();
        } else {
            slotValues = await slotValuesByAusfuehrungId.LoadAsync(ausfuehrung.Id);
        }

        if (user is BackofficeUser || user is Buerger b && b.Id == ausfuehrung.UserId) {
            return slotValues;
        }

        var oeffentlicheSlotNames = await oeffentlichSichtbareSlotNames.LoadAsync(ausfuehrung.ProzessVersionId);
        return slotValues.Where(sv => IstOeffentlichSichtbar(sv, oeffentlicheSlotNames));
    }

    /// <summary>Liefert den Wert eines bestimmten Slots anhand des Namens, zuletzt befüllter Wert wird zurückgegeben.</summary>
    /// <param name="names">Array von Slot-Namen.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="kommuneIdByProzessVersionId">DataLoader zur Ermittlung der Kommune.</param>
    /// <param name="slotValuesByAusfuehrungAndNameIdDataLoader">DataLoader für Slot-Werte nach Ausführung und Namen.</param>
    /// <param name="prozessIsPublicByAusfuehrungId">DataLoader zur Ermittlung der Öffentlichkeitsstatus.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Der gefundene PlainSlotValue oder null.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    [GraphQLDescription("Liefert den Wert eines bestimmten Slots anhand des Namens. Gibt den letzten Wert zurück, falls mehrfach befüllt.")]
    public async Task<PlainSlotValue?> GetSlotValue(
        string[] names,
        CurrentUserAccessor currentUserAccessor,
        IKommuneIdByProzessVersionIdDataLoader kommuneIdByProzessVersionId,
        ISlotValuesByAusfuehrungAndNameIdDataLoader slotValuesByAusfuehrungAndNameIdDataLoader,
        IIsProzessPublicByAusfuehrungIdDataLoader prozessIsPublicByAusfuehrungId,
        IOeffentlichSichtbareSlotNamesByProzessVersionIdDataLoader oeffentlichSichtbareSlotNames,
        [Parent] Ausfuehrung ausfuehrung) {
        var prozessIsPublic = await prozessIsPublicByAusfuehrungId.LoadAsync(ausfuehrung.Id);

        var user = await currentUserAccessor.User();
        if (user is BackofficeUser backofficeUser) {
            if (backofficeUser.KommuneId != await kommuneIdByProzessVersionId.LoadAsync(ausfuehrung.ProzessVersionId)) {
                throw new NotAllowedException();
            }
        } else if ((user is not Buerger buerger || ausfuehrung.UserId != buerger.Id) && !prozessIsPublic) {
            throw new NotAllowedException();
        }

        var results = await Task.WhenAll(names.Select(async slotName =>
            await slotValuesByAusfuehrungAndNameIdDataLoader.LoadAsync((ausfuehrung.Id, slotName))));
        var plainSlotValues = results.OfType<PlainSlotValue>();

        if (user is BackofficeUser || user is Buerger b && b.Id == ausfuehrung.UserId)
            return plainSlotValues.FirstOrDefault();

        var oeffentlicheSlotNames = await oeffentlichSichtbareSlotNames.LoadAsync(ausfuehrung.ProzessVersionId);
        return plainSlotValues.FirstOrDefault(sv => IstOeffentlichSichtbar(sv, oeffentlicheSlotNames));
    }

    /// <summary>Liefert alle Slot-Werte, die im Beschreibungstext der Prozessversion verwendet werden.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="kommuneIdByProzessVersionId">DataLoader zur Ermittlung der Kommune.</param>
    /// <param name="slotValuesByAusfuehrungId">DataLoader für Slot-Werte.</param>
    /// <param name="prozessIsPublicByAusfuehrungId">DataLoader zur Ermittlung der Öffentlichkeitsstatus.</param>
    /// <param name="prozessVersionByIdDataLoader">DataLoader für Prozessversionen.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Liste der relevanten Slot-Werte.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    [GraphQLDescription("Liefert alle Slot-Werte, die im Beschreibungstext der Prozessversion verwendet werden.")]
    public async Task<IEnumerable<SlotValue>> GetBeschreibungstextSlotValues(CurrentUserAccessor currentUserAccessor,
        IKommuneIdByProzessVersionIdDataLoader kommuneIdByProzessVersionId,
        ISlotValuesByAusfuehrungIdDataLoader slotValuesByAusfuehrungId,
        IIsProzessPublicByAusfuehrungIdDataLoader prozessIsPublicByAusfuehrungId,
        IProzessVersionByIdDataLoader prozessVersionByIdDataLoader,
        IOeffentlichSichtbareSlotNamesByProzessVersionIdDataLoader oeffentlichSichtbareSlotNames,
        [Parent] Ausfuehrung ausfuehrung) {
        var prozessIsPublic = await prozessIsPublicByAusfuehrungId.LoadAsync(ausfuehrung.Id);
        var prozessVersion = await prozessVersionByIdDataLoader.LoadAsync(ausfuehrung.ProzessVersionId);
        var slotValueNames = new UsedSlotNamesVisitor().Visit(prozessVersion.Beschreibungstext.Context);

        var user = await currentUserAccessor.User();
        if (user is BackofficeUser backofficeUser) {
            if (backofficeUser.KommuneId != await kommuneIdByProzessVersionId.LoadAsync(ausfuehrung.ProzessVersionId)) {
                throw new NotAllowedException();
            }
        } else if ((user is not Buerger buerger || ausfuehrung.UserId != buerger.Id) && !prozessIsPublic) {
            throw new NotAllowedException();
        }

        var slotValues = (await slotValuesByAusfuehrungId.LoadAsync(ausfuehrung.Id)).Where(slotValue =>
            slotValueNames.Contains(slotValue.SlotName));

        if (user is BackofficeUser || user is Buerger b && b.Id == ausfuehrung.UserId) {
            return slotValues;
        }

        var oeffentlicheSlotNames = await oeffentlichSichtbareSlotNames.LoadAsync(ausfuehrung.ProzessVersionId);
        return slotValues.Where(sv => IstOeffentlichSichtbar(sv, oeffentlicheSlotNames));
    }

    private static bool IstOeffentlichSichtbar(SlotValue slotValue, HashSet<string> oeffentlicheSlotNames) =>
        slotValue.IstFreigegeben == true && oeffentlicheSlotNames.Contains(slotValue.SlotName);

    /// <summary>Slot names third parties may see on public Ausführungen, keyed by Prozessversion id.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, HashSet<string>>> GetOeffentlichSichtbareSlotNamesByProzessVersionId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        var felder = await domainContext.Set<FormularFeld>()
            .Where(f => f.OeffentlichSichtbar && ids.Contains(f.Schritt.ProzessVersionId))
            .Select(f => new { f.Schritt.ProzessVersionId, f.SlotName })
            .ToListAsync(ct);

        var namesByVersion = felder
            .GroupBy(f => f.ProzessVersionId)
            .ToDictionary(g => g.Key, g => g.Select(f => f.SlotName).ToHashSet());
        return ids.ToDictionary(id => id, id => namesByVersion.GetValueOrDefault(id) ?? []);
    }

    /// <summary>Lädt Slot-Werte nach Ausführungs- und Slot-Namen.</summary>
    /// <param name="ids">Liste von Tupeln aus Ausführungs-ID und Slot-Name.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Schlüssel aus Ausführungs-ID und Slot-Name, Wert ist der Slot-Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<(Guid, string), SlotValue>> GetSlotValuesByAusfuehrungAndNameId(
        IReadOnlyList<(Guid, string)> ids, IDbContextFactory<DomainContext> domainContextFactory,
        CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        var ausfuehrungIds = ids.Select(x => x.Item1).Distinct().ToList();
        var slotNames = ids.Select(x => x.Item2).Distinct().ToList();
        var angefragt = ids.ToHashSet();

        var treffer = await domainContext.SlotValues
            .Where(s => slotNames.Contains(s.SlotName) && ausfuehrungIds.Contains(s.Bearbeitung.AusfuehrungId))
            .OrderBy(s => s.Bearbeitung.CreatedAt).ThenBy(s => s.Id)
            .Select(s => new { s.Bearbeitung.AusfuehrungId, SlotValue = s })
            .ToListAsync(ct);

        var result = new Dictionary<(Guid, string), SlotValue>();
        foreach (var t in treffer) {
            var key = (t.AusfuehrungId, t.SlotValue.SlotName);
            if (angefragt.Contains(key)) {
                result[key] = t.SlotValue;
            }
        }

        return result;
    }

    /// <summary>Lädt Slot-Werte gruppiert nach Ausführungs-IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Ausführungs-ID als Schlüssel und Slot-Werten als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, IEnumerable<SlotValue>>> GetSlotValuesByAusfuehrungId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        var result = await domainContext.Bearbeitungen
            .Where(b => ids.Contains(b.Ausfuehrung.Id))
            .Include(b => b.SlotValues)
            .OrderBy(b => b.CreatedAt)
            .Select(b => new { b.AusfuehrungId, b.SlotValues })
            .GroupBy(record => record.AusfuehrungId)
            .ToDictionaryAsync(
                b => b.Key,
                b => b.Aggregate(new Dictionary<string, SlotValue>(), (dict, record) => {
                    foreach (var sv in record.SlotValues) {
                        dict[sv.SlotName] = sv;
                    }

                    return dict;
                }).Values.AsEnumerable(), ct);

        var empty = Array.Empty<SlotValue>();
        foreach (var id in ids) {
            result.TryAdd(id, empty);
        }

        return result;
    }

    /// <summary>Ermittelt, ob ein Prozess öffentlich ist, gruppiert nach Ausführungs-IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Ausführungs-ID als Schlüssel und boolscher Wert für Öffentlichkeit.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, bool>> GetIsProzessPublicByAusfuehrungId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        var publicRequestedAusfuehrungIds = await db.Ausfuehrungen
            .Where(a => ids.Contains(a.Id))
            .OnlyPublic()
            .Select(a => a.Id)
            .ToListAsync(ct);

        return ids.ToDictionary(id => id, id => publicRequestedAusfuehrungIds.Contains(id));
    }

    /// <summary>Liefert die zugehörige Prozessversion einer Ausführung.</summary>
    /// <param name="dataLoader">DataLoader für Prozessversionen.</param>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <returns>Die Prozessversion.</returns>
    [GraphQLDescription("Liefert die zugehörige Prozessversion dieses Antrags.")]
    public async Task<ProzessVersion> GetProzessVersion(IProzessVersionByIdDataLoader dataLoader,
        [Parent] Ausfuehrung ausfuehrung) {
        return await dataLoader.LoadAsync(ausfuehrung.ProzessVersionId);
    }

    /// <summary>Lädt Kommune-IDs gruppiert nach Prozessversions-IDs.</summary>
    /// <param name="ids">Liste der Prozessversions-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Prozessversions-ID als Schlüssel und Kommune-ID als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Guid>> GetKommuneIdByProzessVersionId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.ProzessVersionen
            .Where(pv => ids.Contains(pv.Id))
            .Select(pv => new { ProzessVersionId = pv.Id, KommuneId = pv.Prozess.Kommune.Id })
            .ToDictionaryAsync(a => a.ProzessVersionId, a => a.KommuneId, ct);
    }

    /// <summary>Liefert den aktuell auszuführenden Schritt einer Ausführung.</summary>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <param name="dataLoader">DataLoader für den aktuellen Schritt.</param>
    /// <returns>Der aktuelle Schritt.</returns>
    [GraphQLDescription("Liefert den aktuell auszuführenden Schritt dieses Antrags.")]
    public async Task<Schritt> CurrentSchritt([Parent] Ausfuehrung ausfuehrung,
        ICurrentSchrittByAusfuehrungIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(ausfuehrung.Id);
    }

    /// <summary>Lädt aktuelle Schritte gruppiert nach Ausführungs-IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Ausführungs-ID als Schlüssel und aktuellem Schritt als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Schritt>> GetCurrentSchrittByAusfuehrungId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Ausfuehrungen
            .AsSingleQuery()
            .Where(a => ids.Contains(a.Id))
            .Include(a => a.Schritt)
            .ToDictionaryAsync(a => a.Id, a => a.Schritt, ct);
    }

    /// <summary>Lädt die letzte Bearbeitung gruppiert nach Ausführungs-IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Ausführungs-ID als Schlüssel und letzter Bearbeitung als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Bearbeitung>> GetLastBearbeitungByAusfuehrungId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Bearbeitungen
            .AsSingleQuery()
            .Where(b => ids.Contains(b.AusfuehrungId))
            .GroupBy(b => b.AusfuehrungId)
            .Select(group =>
                new { group.Key, LastBearbeitung = group.OrderByDescending(b => b.CreatedAt).First() })
            .ToDictionaryAsync(record => record.Key, record => record.LastBearbeitung, cancellationToken: ct);
    }

    /// <summary>Liefert den Zeitpunkt der letzten Bearbeitung einer Ausführung.</summary>
    /// <param name="ausfuehrung">Die Ausführung.</param>
    /// <param name="currentSchrittByAusfuehrungId">DataLoader für die letzte Bearbeitung.</param>
    /// <returns>Instant des letzten Bearbeitungszeitpunkts.</returns>
    [GraphQLDescription("Liefert den Zeitpunkt der letzten Bearbeitung dieses Antrags.")]
    public async Task<Instant> GetUpdatedAt([Parent] Ausfuehrung ausfuehrung,
        ILastBearbeitungByAusfuehrungIdDataLoader currentSchrittByAusfuehrungId) {
        Bearbeitung bearbeitung = await currentSchrittByAusfuehrungId.LoadAsync(ausfuehrung.Id);
        return bearbeitung.CreatedAt;
    }
}

/// <summary>Stellt Abfragen für einzelne Ausführungen bereit.</summary>
[QueryType]
public class AusfuehrungRootQuery {
    /// <summary>Liefert eine einzelne Ausführung anhand der ID, nur für berechtigte Nutzer zugänglich.</summary>
    /// <param name="ausfuehrungZustaendigkeitService">Service zur Prüfung der Zuständigkeit.</param>
    /// <param name="dataLoader">DataLoader für Ausführungen.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="id">ID der Ausführung.</param>
    /// <returns>Die gefundene Ausführung.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    [Authorize]
    [GraphQLDescription("Liefert eine einzelne Ausführung (Antrag) anhand der ID. Nur für berechtigte Backoffice-Nutzer oder den Antragsteller zugänglich.")]
    public async Task<Ausfuehrung> GetAusfuehrung(
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        IAusfuehrungByIdDataLoader dataLoader,
        [Service] ICurrentUserAccessor currentUserAccessor,
        Guid id
    ) {
        var ausfuehrung = await dataLoader.LoadAsync(id);
        await ausfuehrungZustaendigkeitService.EnsureZugriffAufAusfuehrung(ausfuehrung, currentUserAccessor);

        return ausfuehrung;
    }

    /// <summary>Lädt Ausführungen nach IDs.</summary>
    /// <param name="ids">Liste der Ausführungs-IDs.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Ausführungs-ID als Schlüssel und Ausführung als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Ausfuehrung>> GetAusfuehrungById(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Ausfuehrungen.NotDeleted().Where(a => ids.Contains(a.Id))
            .ToDictionaryAsync(a => a.Id, ct);
    }
}
