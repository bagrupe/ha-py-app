using API.Features.Auth;
using API.Features.EmailForwarder;
using API.Features.Expressions;
using API.Features.Funktionsberechtigungen;
using API.Features.GovManager;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Serialization;
using NodaTime;
using Riok.Mapperly.Abstractions;

namespace API.Features.Prozess.Mutations;

[MutationType]
public class NeueProzessVersionErstellenMutation {
    /// <summary>
    /// Erzeugt neue IDs für Schritte und deren Felder und passt Referenzen bei Warte-Schritten an.
    /// </summary>
    /// <param name="schritte">Die ursprünglichen Schritte.</param>
    /// <returns>Ein Tupel aus der Zuordnung alter zu neuer IDs und den Schritten mit neuen IDs.</returns>
    private static (Dictionary<Guid, Guid> TempToNewIds, IEnumerable<BaseSchrittInput> Schritte)
        DeepGenerateNewIds(IEnumerable<SchrittInput> schritte) {
        var tempToNewIds = new Dictionary<Guid, Guid>();

        var scrambledSchritte = schritte.Select(s => {
            var schritt = s.Schritt;

            var newId = Guid.NewGuid();
            tempToNewIds[schritt.Id] = newId;

            if (schritt is FormularSchrittInput formularSchritt) {
                var scrambledFelder = formularSchritt.Felder.Select(f => {
                    var scrambledFeld = f.WithScrambledIds();

                    return scrambledFeld;
                }).ToList();

                return formularSchritt with { Id = newId, Felder = scrambledFelder };
            }

            return schritt with { Id = newId };
        }).ToList();

        // Sicherstellen, dass alle Schritte neue IDs haben, bevor Warte-Schritte referenziert werden
        var patchedScrambledSchritte = scrambledSchritte.Select(s => {
            if (s is WarteAufGovManagerSchrittInput warteAufGovManagerSchrittInput) {
                return warteAufGovManagerSchrittInput with {
                    GovManagerSchrittId = tempToNewIds[warteAufGovManagerSchrittInput.GovManagerSchrittId]
                };
            }

            if (s is WarteAufBezahlungAbgeschlossenSchrittInput warteAufBezahlungAbgeschlossenSchrittInput) {
                return warteAufBezahlungAbgeschlossenSchrittInput with {
                    BezahlenSchrittId = tempToNewIds[warteAufBezahlungAbgeschlossenSchrittInput.BezahlenSchrittId]
                };
            }

            return s;
        });

        return (tempToNewIds, patchedScrambledSchritte);
    }

    /// <summary>
    /// Erzeugt neue IDs für Zuständigkeit-Rollen.
    /// </summary>
    /// <param name="zustaendigkeitRolleInputs">Die ursprünglichen Zuständigkeit-Rollen.</param>
    /// <returns>Ein Tupel aus der Zuordnung alter zu neuer IDs und den Rollen mit neuen IDs.</returns>
    private static (Dictionary<Guid, Guid> TempToNewIds, IEnumerable<ZustaendigkeitRolleInput> ZustaendigkeitRollen)
        DeepGenerateNewIds(IEnumerable<ZustaendigkeitRolleInput> zustaendigkeitRolleInputs) {
        var tempToNewIds = new Dictionary<Guid, Guid>();

        var scrambledZustaendigkeitRolleInputs = zustaendigkeitRolleInputs.Select(n => {
            var newId = Guid.NewGuid();
            tempToNewIds[n.Id] = newId;

            return n with { Id = newId };
        }).ToList();

        return (tempToNewIds, scrambledZustaendigkeitRolleInputs);
    }

    /// <summary>
    /// Erstellt eine neue Version eines bestehenden Prozesses mit neuen IDs und optionaler Veröffentlichung.
    /// </summary>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="prozessId">ID des Prozesses.</param>
    /// <param name="schritte">Liste der Schritte.</param>
    /// <param name="verbindungen">Liste der Verbindungen zwischen Schritten.</param>
    /// <param name="zustaendigkeitRollen">Liste der Zuständigkeit-Rollen.</param>
    /// <param name="veroeffentlichen">Flag zur direkten Veröffentlichung der neuen Version.</param>
    /// <param name="clock">Zeitgeber-Service.</param>
    /// <param name="currentUserAccessor">Service zum Zugriff auf aktuellen Benutzer.</param>
    /// <param name="ct">Abbruch-Token.</param>
    /// <returns>Den Prozess mit der neuen Version.</returns>
    [Error(typeof(EmailAddressNotProvidedException))]
    [Authorize]
    [GraphQLDescription("Erstellt eine neue Version eines bestehenden Prozesses. Kopiert und ersetzt alle IDs, um eine unabhängige Version zu erzeugen. Optional kann die Version direkt veröffentlicht werden.")]
    public async Task<Prozess> ProzessVersionErstellen(DomainContext db,
        Guid prozessId, List<SchrittInput> schritte, List<VerbindungInput> verbindungen,
        List<ZustaendigkeitRolleInput> zustaendigkeitRollen, bool veroeffentlichen,
        [Service] IClock clock, [Service] CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var (backofficeUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        return await PublishNewVersionAsync(db, prozessId, backofficeUser.KommuneId, schritte, verbindungen, zustaendigkeitRollen, veroeffentlichen, clock, ct);
    }

    /// <summary>
    /// Kern von <see cref="ProzessVersionErstellen"/> OHNE die Prozessverwaltung-Berechtigungsprüfung - jeder
    /// Aufrufer muss selbst sicherstellen, dass die eigene Berechtigung für den Aufruf ausreicht.
    /// </summary>
    internal async Task<Prozess> PublishNewVersionAsync(DomainContext db,
        Guid prozessId, Guid kommuneId, List<SchrittInput> schritte, List<VerbindungInput> verbindungen,
        List<ZustaendigkeitRolleInput> zustaendigkeitRollen, bool veroeffentlichen,
        IClock clock, CancellationToken ct) {
        // Prozesse fremder Kommunen sind absichtlich ununterscheidbar von nicht vorhandenen.
        var prozess = await db.Prozesse
            .AsTracking()
            .FirstOrDefaultAsync(p => p.Id == prozessId && p.KommuneId == kommuneId, ct);

        var mostRecentVersion = await db.ProzessVersionen
            .Where(pv => pv.ProzessId == prozessId && pv.PublishedAt != null)
            .OrderBy(pv => pv.PublishedAt)
            .FirstOrDefaultAsync(ct);

        if (prozess is null) {
            throw new ArgumentException(nameof(prozessId));
        }

        await ValidateSchritte(db, schritte, prozess, ct);

        var (zustaendigkeitenScrambledIdMap, scrambledZustaendigkeitRollen
                ) =
            DeepGenerateNewIds(zustaendigkeitRollen);
        var (schritteScrambledIdMap, scrambledSchritte) = DeepGenerateNewIds(schritte);

        var mapper = new MapperlyMapper();

        var dbSchritte = scrambledSchritte.Select(s => mapper.ToSchritt(s)).ToList();

        // TODO: Check unscramble
        foreach (var schritt in dbSchritte) {
            schritt.SchreibtRolleId = schritt.SchreibtRolleId is not null
                ? zustaendigkeitenScrambledIdMap[schritt.SchreibtRolleId.Value]
                : null;
            schritt.SollZustaendigkeit.LiestRolleId =
                schritt.SollZustaendigkeit.LiestRolleId is not null
                    ? zustaendigkeitenScrambledIdMap[
                        schritt.SollZustaendigkeit.LiestRolleId.Value]
                    : null;
        }

        db.Schritte.AddRange(dbSchritte);

        var dbVerbindungen = verbindungen
            .Select(v => v with {
                Id = Guid.NewGuid(),
                VonId = schritteScrambledIdMap[v.VonId],
                NachId = schritteScrambledIdMap[v.NachId]
            })
            .Select(v => mapper.ToVerbindung(v))
            .ToList();
        db.Verbindungen.AddRange(dbVerbindungen);

        var dbZustaendigkeitRollen = scrambledZustaendigkeitRollen
            .Select(n => new ZustaendigkeitRolle { Id = n.Id, Name = n.Name }).ToList();

        var neueProzessVersion = new ProzessVersion {
            ProzessId = prozessId,
            Schritte = dbSchritte,
            Prozess = prozess,
            CreatedAt = clock.GetCurrentInstant(),
            PublishedAt = veroeffentlichen ? clock.GetCurrentInstant() : null,
            Beschreibungstext = mostRecentVersion?.Beschreibungstext ?? "Neuer Prozess",
            Rollen = dbZustaendigkeitRollen,
        };

        db.ZustaendigkeitRollen.AddRange(dbZustaendigkeitRollen);

        db.ProzessVersionen.Add(neueProzessVersion);

        // save once to avoid circular dependency when setting StartId
        await db.SaveChangesAsync(ct);

        var nachIds = dbVerbindungen.Select(v => v.NachId).ToHashSet();
        var startId = dbSchritte.FirstOrDefault(s => !nachIds.Contains(s.Id))?.Id;
        neueProzessVersion.StartId = startId;

        await db.SaveChangesAsync(ct);

        return prozess;
    }

    private static async Task ValidateSchritte(DomainContext db, List<SchrittInput> schritte, Prozess prozess, CancellationToken ct) {
        var mitarbeiterGruppenWithoutEmail = await db.MitarbeiterGruppen
            .Where(m => m.EMailAdressen.Count == 0 && m.KommuneId == prozess.KommuneId)
            .Select(m => m.Id).ToListAsync(ct);
        if (schritte.Any(s => s.Schritt.VersendeEMailAnMitarbeiterGruppe == true &&
                              s.Schritt.SollZustaendigkeit.MitarbeiterGruppeId != null &&
                              mitarbeiterGruppenWithoutEmail.Contains(s.Schritt.SollZustaendigkeit
                                  .MitarbeiterGruppeId.Value))) {
            throw new EmailAddressNotProvidedException();
        }

        var dienstleisterWithoutEmail = await db.Dienstleister
            .Where(d => d.EMailAdressen.Count == 0 && d.MandantId == prozess.KommuneId)
            .Select(d => d.Id).ToListAsync(ct);
        if (schritte.Any(s => s.Schritt.VersendeEMailAnMitarbeiterGruppe == true &&
                              s.Schritt.SollZustaendigkeit.Art == ZustaendigkeitArt.Dienstleister &&
                              s.Schritt.SollZustaendigkeit.DienstleisterId != null &&
                              dienstleisterWithoutEmail.Contains(s.Schritt.SollZustaendigkeit
                                  .DienstleisterId.Value))) {
            throw new EmailAddressNotProvidedException();
        }

        foreach (var s in schritte) {
            if (!await MitarbeiterGruppeIsCorrect(db, s, prozess.KommuneId, ct)) {
                throw new UserGroupIsNotValidException();
            }
        }
    }

    /// <summary>
    /// Prüft: Ist eine <see cref="MitarbeiterGruppe"/> gesetzt, muss auch eine Organisationseinheit
    /// (<see cref="Untereinheit.Untereinheit"/>) gesetzt sein; die Gruppe muss dieser OE derselben Kommune
    /// zugeordnet sein (Many-to-many über <c>MitarbeiterGruppeUntereinheit</c>).
    /// </summary>
    private static async Task<bool> MitarbeiterGruppeIsCorrect(DomainContext db, SchrittInput s, Guid kommuneId,
        CancellationToken ct) {
        var mitarbeiterGruppeId = s.Schritt.SollZustaendigkeit.MitarbeiterGruppeId;
        var organisationseinheitId = s.Schritt.SollZustaendigkeit.OrganisationseinheitId;
        if (mitarbeiterGruppeId is null) {
            return true;
        }

        if (organisationseinheitId is null) {
            return false;
        }

        // Als DB-Abfrage (nicht in-memory auf Navigation), damit die Zuordnung aus dem Join kommt — vgl.
        // GetMitarbeiterGruppenByUntereinheitId mit Include(Organisationseinheiten).
        return await db.MitarbeiterGruppen
            .Where(g => g.Id == mitarbeiterGruppeId.Value && g.KommuneId == kommuneId && !g.IsDeleted)
            .Where(g => g.Organisationseinheiten.Any(o =>
                o.Id == organisationseinheitId.Value && o.KommuneId == kommuneId))
            .AnyAsync(ct);
    }

    private class EmailAddressNotProvidedException : Exception;

    private class UserGroupIsNotValidException : Exception;
}

/// <summary>
/// Eingabedaten für eine Zuständigkeit-Rolle.
/// </summary>
/// <param name="Id">ID der Rolle.</param>
/// <param name="Name">Name der Rolle.</param>
public record ZustaendigkeitRolleInput(
    Guid Id,
    string Name
);

/// <summary>
/// Eingabedaten für einen Schritt, der verschiedene Schritt-Typen kapselt.
/// </summary>
[OneOf]
public record SchrittInput(
    FormularSchrittInput? FormularSchrittInput,
    BezahlenSchrittInput? BezahlenSchrittInput,
    WarteAufBezahlungAbgeschlossenSchrittInput? WarteAufBezahlungAbgeschlossenSchrittInput,
    ProgrammatischerSchrittInput? ProgrammatischerSchrittInput,
    EndeSchrittInput? EndeSchrittInput,
    NachrichtSchrittInput? NachrichtSchrittInput,
    EmailForwarderSchrittInput? EmailForwardSchrittInput,
    GovManagerRestExportSchrittInput? GovManagerRestExportSchrittInput,
    WarteAufGovManagerSchrittInput? WarteAufGovManagerSchrittInput
) {
    /// <summary>
    /// Gibt den konkreten Basisschritt zurück.
    /// </summary>
    [GraphQLIgnore]
    public BaseSchrittInput Schritt {
        get {
            if (FormularSchrittInput != null) return FormularSchrittInput;
            if (BezahlenSchrittInput != null) return BezahlenSchrittInput;
            if (WarteAufBezahlungAbgeschlossenSchrittInput != null) return WarteAufBezahlungAbgeschlossenSchrittInput;
            if (ProgrammatischerSchrittInput != null) return ProgrammatischerSchrittInput;
            if (EndeSchrittInput != null) return EndeSchrittInput;
            if (NachrichtSchrittInput != null) return NachrichtSchrittInput;
            if (EmailForwardSchrittInput != null) return EmailForwardSchrittInput;
            if (GovManagerRestExportSchrittInput != null) return GovManagerRestExportSchrittInput;
            if (WarteAufGovManagerSchrittInput != null) return WarteAufGovManagerSchrittInput;

            throw new ArgumentOutOfRangeException();
        }
    }
};

/// <summary>
/// Position eines Knotens im Koordinatensystem.
/// </summary>
/// <param name="X">X-Koordinate.</param>
/// <param name="Y">Y-Koordinate.</param>
public record NodePositionInput(
    double X,
    double Y
);

/// <summary>
/// Eingabedaten für die Soll-Zuständigkeit eines Schritts.
/// </summary>
/// <param name="Art">Art der Zuständigkeit.</param>
/// <param name="DienstleisterId">Optionale Dienstleister-ID.</param>
/// <param name="OrganisationseinheitId">Optionale Organisationseinheit-ID.</param>
/// <param name="MitarbeiterGruppeId">Optionale Mitarbeitergruppen-ID.</param>
/// <param name="LiestRolleId">Optionale Rolle, die liest.</param>
/// <param name="DynamischeArten">Optionale Liste dynamischer Zuständigkeitsarten.</param>
public record SchrittSollZustaendigkeitInput(
    ZustaendigkeitArt Art,
    Guid? DienstleisterId,
    Guid? OrganisationseinheitId,
    Guid? MitarbeiterGruppeId,
    Guid? LiestRolleId,
    List<ZustaendigkeitArt>? DynamischeArten
);

/// <summary>
/// Basisklasse für Schritt-Eingaben.
/// </summary>
public abstract record BaseSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
);

/// <summary>
/// Eingabedaten für einen Formular-Schritt.
/// </summary>
public record FormularSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    List<FormularFeldInput> Felder,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen Bezahlen-Schritt.
/// </summary>
public record BezahlenSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    decimal Betrag,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen WarteAufBezahlungAbgeschlossen-Schritt.
/// </summary>
public record WarteAufBezahlungAbgeschlossenSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    Guid BezahlenSchrittId,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen GovManagerRestExport-Schritt.
/// </summary>
public record GovManagerRestExportSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    string VorgangsTyp,
    string MandantenSchluessel,
    string VorgangsSchluessel,
    bool ExportFilePartsAsPdf,
    List<PartInput> ExportParts,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen Part, der verschiedene Part-Typen kapselt.
/// </summary>
[OneOf]
public record PartInput(FilePartInput? FilePartInput, JsonPartInput? JsonPartInput) {
    /// <summary>
    /// Gibt den konkreten Basistyp des Parts zurück.
    /// </summary>
    [GraphQLIgnore]
    public BasePartInput Part {
        get {
            if (FilePartInput != null) return FilePartInput;
            if (JsonPartInput != null) return JsonPartInput;

            throw new ArgumentOutOfRangeException();
        }
    }
}

/// <summary>
/// Basisklasse für Part-Eingaben.
/// </summary>
public abstract record BasePartInput;

/// <summary>
/// Eingabedaten für einen File-Part.
/// </summary>
/// <param name="SlotName">Name des Slots.</param>
public record FilePartInput(string SlotName) : BasePartInput;

/// <summary>
/// Eingabedaten für einen Json-Part.
/// </summary>
/// <param name="Value">Json-Wert mit Slots.</param>
public record JsonPartInput(JsonValueWithSlotsInput Value) : BasePartInput;

/// <summary>
/// Eingabedaten für Json-Werte mit Slots, die verschiedene Typen kapseln.
/// </summary>
[OneOf]
public record JsonValueWithSlotsInput(
    JsonObjectInput? JsonObjectInput,
    JsonSlotValueInput? JsonSlotValueInput,
    JsonStringValueInput? JsonStringValueInput) {
    /// <summary>
    /// Gibt den konkreten Basistyp des Json-Werts zurück.
    /// </summary>
    [GraphQLIgnore]
    public BaseJsonValueWithSlotsInput JsonValueWithSlots {
        get {
            if (JsonObjectInput != null) return JsonObjectInput;
            if (JsonSlotValueInput != null) return JsonSlotValueInput;
            if (JsonStringValueInput != null) return JsonStringValueInput;

            throw new ArgumentOutOfRangeException();
        }
    }
}

/// <summary>
/// Basisklasse für Json-Werte mit Slots.
/// </summary>
public abstract record BaseJsonValueWithSlotsInput;

/// <summary>
/// Eingabedaten für ein Json-Objekt.
/// </summary>
/// <param name="Fields">Liste der Felder.</param>
public record JsonObjectInput(List<JsonFieldInput> Fields) : BaseJsonValueWithSlotsInput;

/// <summary>
/// Eingabedaten für einen Json-String-Wert.
/// </summary>
/// <param name="Value">String-Wert.</param>
public record JsonStringValueInput(string Value) : BaseJsonValueWithSlotsInput;

/// <summary>
/// Eingabedaten für einen Json-Slot-Wert.
/// </summary>
/// <param name="SlotName">Name des Slots.</param>
public record JsonSlotValueInput(string SlotName) : BaseJsonValueWithSlotsInput;

/// <summary>
/// Eingabedaten für ein Json-Feld.
/// </summary>
/// <param name="Name">Name des Feldes.</param>
/// <param name="Value">Wert des Feldes.</param>
public record JsonFieldInput(string Name, JsonValueWithSlotsInput Value);

/// <summary>
/// Eingabedaten für einen WarteAufGovManager-Schritt.
/// </summary>
public record WarteAufGovManagerSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    Guid GovManagerSchrittId,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen programmatischen Schritt.
/// </summary>
public record ProgrammatischerSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    string ImplementationAssemblyQualifiedName,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen End-Schritt.
/// </summary>
public record EndeSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen Nachricht-Schritt.
/// </summary>
public record NachrichtSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für einen EmailForwarder-Schritt.
/// </summary>
public record EmailForwarderSchrittInput(
    Guid Id,
    string? Titel,
    string? Anweisung,
    SchrittSollZustaendigkeitInput SollZustaendigkeit,
    bool? VersendeEMailAnMitarbeiterGruppe,
    StringExpression EmailAddress,
    StringExpression Subject,
    StringExpression Body,
    NodePositionInput? NodePosition,
    Guid? SchreibtRolleId
) : BaseSchrittInput(Id, Titel, Anweisung, SollZustaendigkeit, VersendeEMailAnMitarbeiterGruppe, NodePosition, SchreibtRolleId);

/// <summary>
/// Eingabedaten für ein Formularfeld, das verschiedene Feldtypen kapselt.
/// </summary>
[OneOf]
public record FormularFeldInput(
    CheckboxListFormularFeldInput? CheckboxListFormularFeldInput,
    StringFormularFeldInput? StringFormularFeldInput,
    UploadFormularFeldInput? UploadFormularFeldInput,
    LocationFormularFeldInput? LocationFormularFeldInput,
    DateFormularFeldInput? DateFormularFeldInput,
    SignatureFormularFeldInput? SignatureFormularFeldInput,
    TimeFormularFeldInput? TimeFormularFeldInput,
    AnzeigeTextBlockFormularFeldInput? AnzeigeTextBlockFormularFeldInput
) {
    /// <summary>
    /// Gibt das konkrete Formularfeld zurück.
    /// </summary>
    [GraphQLIgnore]
    public BaseFormularFeldInput Feld {
        get {
            if (CheckboxListFormularFeldInput != null) return CheckboxListFormularFeldInput;
            if (StringFormularFeldInput != null) return StringFormularFeldInput;
            if (UploadFormularFeldInput != null) return UploadFormularFeldInput;
            if (LocationFormularFeldInput != null) return LocationFormularFeldInput;
            if (DateFormularFeldInput != null) return DateFormularFeldInput;
            if (TimeFormularFeldInput != null) return TimeFormularFeldInput;
            if (SignatureFormularFeldInput != null) return SignatureFormularFeldInput;
            if (AnzeigeTextBlockFormularFeldInput != null) return AnzeigeTextBlockFormularFeldInput;

            throw new ArgumentOutOfRangeException();
        }
    }

    /// <summary>
    /// Erzeugt eine Kopie des Formularfelds mit neuen IDs.
    /// </summary>
    /// <returns>Neues Formularfeld mit neuen IDs.</returns>
    [GraphQLIgnore]
    public FormularFeldInput WithScrambledIds() {
        var feld = Feld;

        var scrambled = feld with { Id = new Guid() };
        return scrambled switch {
            CheckboxListFormularFeldInput checkboxList => this with { CheckboxListFormularFeldInput = checkboxList },
            StringFormularFeldInput @string => this with { StringFormularFeldInput = @string },
            UploadFormularFeldInput upload => this with { UploadFormularFeldInput = upload },
            LocationFormularFeldInput location => this with { LocationFormularFeldInput = location },
            DateFormularFeldInput date => this with { DateFormularFeldInput = date },
            SignatureFormularFeldInput signature => this with { SignatureFormularFeldInput = signature },
            TimeFormularFeldInput time => this with { TimeFormularFeldInput = time },
            AnzeigeTextBlockFormularFeldInput text => this with { AnzeigeTextBlockFormularFeldInput = text },
            _ => throw new ArgumentOutOfRangeException()
        };
    }
};

/// <summary>
/// Basisklasse für Formularfeld-Eingaben.
/// </summary>
public abstract record BaseFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    [property: DefaultValue(false)] bool OeffentlichSichtbar
);

/// <summary>
/// Eingabedaten für ein CheckboxList-Formularfeld.
/// </summary>
public record CheckboxListFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    List<CheckboxListFeldOptionInput> Options,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Option für CheckboxList-Felder.
/// </summary>
/// <param name="Key">Schlüssel der Option.</param>
/// <param name="Label">Anzeigetext der Option.</param>
/// <param name="Order">Reihenfolge.</param>
/// <param name="DefaultChecked">Standardauswahl.</param>
public record CheckboxListFeldOptionInput(string Key, string Label, int Order, bool DefaultChecked);

/// <summary>
/// Eingabedaten für ein String-Formularfeld.
/// </summary>
public record StringFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool Multiline,
    StringFormularFeldOption[]? Options,
    bool OeffentlichSichtbar,
    bool Durchsuchbar = false
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein Upload-Formularfeld.
/// </summary>
public record UploadFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool Multi,
    bool Document,
    bool BrauchtFreigabe,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein Signature-Formularfeld.
/// </summary>
public record SignatureFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein Location-Formularfeld.
/// </summary>
public record LocationFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein Date-Formularfeld.
/// </summary>
public record DateFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein AnzeigeTextBlock-Formularfeld.
/// </summary>
public record AnzeigeTextBlockFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    string Text,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für ein Time-Formularfeld.
/// </summary>
public record TimeFormularFeldInput(
    Guid Id,
    string SlotName,
    string? AngezeigterName,
    string? Anweisung,
    int Order,
    bool Encrypted,
    string? InhaltsTag,
    BoolExpression IstRelevant,
    bool Pflichtfeld,
    bool OeffentlichSichtbar
) : BaseFormularFeldInput(Id, SlotName, AngezeigterName, Anweisung, Order, Encrypted, InhaltsTag, IstRelevant, Pflichtfeld, OeffentlichSichtbar);

/// <summary>
/// Eingabedaten für eine Verbindung zwischen Schritten.
/// </summary>
public record VerbindungInput(
    Guid Id,
    Guid VonId,
    Guid NachId,
    string? Name,
    string? StatusAenderung,
    string? StatusAenderungBeschreibung,
    BoolExpression IstRelevant);

[Mapper]
public partial class MapperlyMapper {
    /// <summary>
    /// Wandelt ein Formularfeld-Input in ein Formularfeld um.
    /// </summary>
    /// <param name="input">Eingabedaten des Formularfelds.</param>
    /// <returns>Formularfeld-Objekt.</returns>
    [MapDerivedType<CheckboxListFormularFeldInput, CheckboxListFormularFeld>]
    [MapDerivedType<StringFormularFeldInput, StringFormularFeld>]
    [MapDerivedType<UploadFormularFeldInput, UploadFormularFeld>]
    [MapDerivedType<LocationFormularFeldInput, LocationFormularFeld>]
    [MapDerivedType<DateFormularFeldInput, DateFormularFeld>]
    [MapDerivedType<SignatureFormularFeldInput, SignatureFormularFeld>]
    [MapDerivedType<TimeFormularFeldInput, TimeFormularFeld>]
    [MapDerivedType<AnzeigeTextBlockFormularFeldInput, AnzeigeTextBlockFeld>]
    public partial FormularFeld ToFormularFeld(BaseFormularFeldInput input);

    /// <summary>
    /// Wandelt einen Part-Input in ein Part-Objekt um.
    /// </summary>
    /// <param name="input">Eingabedaten des Parts.</param>
    /// <returns>Part-Objekt.</returns>
    [MapDerivedType<FilePartInput, FilePart>]
    [MapDerivedType<JsonPartInput, JsonPart>]
    public partial IPart ToPart(BasePartInput input);

    /// <summary>
    /// Wandelt einen JsonValueWithSlots-Input in ein entsprechendes Objekt um.
    /// </summary>
    /// <param name="input">Eingabedaten des Json-Werts.</param>
    /// <returns>JsonValueWithSlots-Objekt.</returns>
    [MapDerivedType<JsonObjectInput, JsonObject>]
    [MapDerivedType<JsonSlotValueInput, JsonSlotValue>]
    [MapDerivedType<JsonStringValueInput, JsonStringValue>]
    public partial IJsonValueWithSlots ToJsonValueWithSlots(BaseJsonValueWithSlotsInput input);

    /// <summary>
    /// Wandelt einen Basisschritt-Input in ein Schritt-Objekt um.
    /// </summary>
    /// <param name="input">Eingabedaten des Schritts.</param>
    /// <returns>Schritt-Objekt.</returns>
    [MapDerivedType<FormularSchrittInput, FormularSchritt>]
    [MapDerivedType<BezahlenSchrittInput, BezahlenSchritt>]
    [MapDerivedType<WarteAufBezahlungAbgeschlossenSchrittInput, WarteAufBezahlungAbgeschlossenSchritt>]
    [MapDerivedType<ProgrammatischerSchrittInput, ProgrammatischerSchritt>]
    [MapDerivedType<EndeSchrittInput, EndeSchritt>]
    [MapDerivedType<NachrichtSchrittInput, NachrichtSchritt>]
    [MapDerivedType<EmailForwarderSchrittInput, EmailForwarderExportSchritt>]
    [MapDerivedType<GovManagerRestExportSchrittInput, GovManagerRestExportSchritt>]
    [MapDerivedType<WarteAufGovManagerSchrittInput, WarteAufGovManagerSchritt>]
    public partial Schritt ToSchritt(BaseSchrittInput input);

    /// <summary>
    /// Wandelt eine Verbindung-Input in ein Verbindung-Objekt um.
    /// </summary>
    /// <param name="input">Eingabedaten der Verbindung.</param>
    /// <returns>Verbindung-Objekt.</returns>
    public partial Verbindung ToVerbindung(VerbindungInput input);

    /// <summary>
    /// Wandelt ein FormularFeldInput in ein FormularFeld um.
    /// </summary>
    /// <param name="input">FormularFeldInput.</param>
    /// <returns>FormularFeld.</returns>
    public FormularFeld ToFormularFeld(FormularFeldInput input) => ToFormularFeld(input.Feld);

    /// <summary>
    /// Wandelt ein PartInput in ein Part-Objekt um.
    /// </summary>
    /// <param name="input">PartInput.</param>
    /// <returns>Part-Objekt.</returns>
    public IPart ToPart(PartInput input) => ToPart(input.Part);

    /// <summary>
    /// Wandelt ein JsonValueWithSlotsInput in ein entsprechendes Objekt um.
    /// </summary>
    /// <param name="input">JsonValueWithSlotsInput.</param>
    /// <returns>JsonValueWithSlots-Objekt.</returns>
    public IJsonValueWithSlots ToJsonValueWithSlots(JsonValueWithSlotsInput input) =>
        ToJsonValueWithSlots(input.JsonValueWithSlots);
}
