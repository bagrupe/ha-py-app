using System.Text.Json;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Features.EmailForwarder;
using API.Features.Expressions;
using API.Features.GovManager;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>
/// Verwaltet die Ausführung eines Prozesses und steuert den Ablauf der Schritte.
/// </summary>
public class Walker : IDisposable, IAsyncDisposable {
    private readonly IClock _clock;
    private readonly DomainContext _domainContext;
    private readonly ProzessVersion _prozessVersion;
    private readonly Ausfuehrung _ausfuehrung;
    private readonly EvaluatingVisitorService _evaluatingVisitorService;

    private readonly EmailService _emailService;
    private readonly WebOptions _webOptions;
    private readonly ILogger<Walker> _logger;
    private readonly List<(Schritt Schritt, Zustaendigkeit? Zustaendigkeit)> _pendingMailEvaluations = [];

    /// <summary>
    /// Initialisiert eine neue Instanz des Walkers mit den benötigten Abhängigkeiten.
    /// </summary>
    /// <param name="clock">Zeitquelle für Zeitstempel.</param>
    /// <param name="domainContext">Datenbankkontext für Persistenz.</param>
    /// <param name="prozessVersion">Version des Prozesses, der ausgeführt wird.</param>
    /// <param name="ausfuehrung">Aktuelle Ausführung des Prozesses.</param>
    /// <param name="evaluatingVisitorService">Service zur Auswertung von Bedingungen.</param>
    public Walker(IClock clock, DomainContext domainContext, ProzessVersion prozessVersion, Ausfuehrung ausfuehrung,
        EvaluatingVisitorService evaluatingVisitorService, EmailService emailService, WebOptions webOptions,
        ILogger<Walker> logger) {
        _clock = clock;
        _domainContext = domainContext;
        _prozessVersion = prozessVersion;
        _ausfuehrung = ausfuehrung;
        _evaluatingVisitorService = evaluatingVisitorService;
        _emailService = emailService;
        _webOptions = webOptions;
        _logger = logger;
    }

    /// <summary>
    /// Liefert den aktuellen Schritt der Ausführung.
    /// </summary>
    public Schritt CurrentSchritt {
        get {
            return this._prozessVersion.Schritte.First(s => s.Id == _ausfuehrung.SchrittId);
        }
    }

    /// <summary>
    /// Liefert die Verbindungen des aktuellen Schritts.
    /// </summary>
    public IReadOnlyList<Verbindung> CurrentVerbindungen => CurrentSchritt.Verbindungen.ToList();

    /// <summary>
    /// Liefert den zugrundeliegenden Prozess.
    /// </summary>
    public Prozess Prozess => _prozessVersion.Prozess;

    /// <summary>
    /// Liefert die aktuelle Ausführung.
    /// </summary>
    public Ausfuehrung Ausfuehrung => _ausfuehrung;

    private IEnumerable<Verbindung> Verbindungen =>
        _prozessVersion.Schritte.SelectMany(s => s.Verbindungen).DistinctBy(v => v.Id);

    /// <summary>
    /// Liefert die aktuellen Slot-Werte der Ausführung als Dictionary.
    /// </summary>
    /// <returns>Dictionary mit Slotnamen und zugehörigen Werten.</returns>
    public IReadOnlyDictionary<string, SlotValue> CurrentSlotValues() {
        var dictionary = new Dictionary<string, SlotValue>();

        foreach (var bearbeitung in _ausfuehrung.Bearbeitungen.OrderBy(b => b.CreatedAt)) {
            foreach (var slotValue in bearbeitung.SlotValues) {
                dictionary[slotValue.SlotName] = slotValue;
            }
        }

        return dictionary;
    }

    /// <summary>
    /// Ermittelt die nächsten Schritte, die ohne erforderliche Wahl automatisch durchlaufen werden können.
    /// </summary>
    /// <returns>Aufzählung der nächsten Schritte ohne erforderliche Wahl.</returns>
    public IEnumerable<Schritt> NextSchritteWithoutRequiredChoice() {
        var verbindungen = CurrentVerbindungen;

        while (verbindungen.Count == 1 && verbindungen.First().Name == null) {
            var verbindung = verbindungen.First();
            var nextSchritt = _prozessVersion.Schritte.First(s => s.Id == verbindung.NachId);

            if (nextSchritt is ProgrammatischerSchritt) {
                // A ProgrammatischerSchritt is always a boundary since it's not intended to be handled by any person.
                break;
            }

            if (nextSchritt is BezahlenSchritt) {
                // A BezahlenSchritt is a boundary since it requires an up to date Ausführung for generating the payment.
                break;
            }

            if (nextSchritt is GovManagerRestExportSchritt) {
                // A GovManagerRestExportSchritt is a boundary since it requires an up to date Ausführung for export.
                break;
            }

            if (nextSchritt is EmailForwarderExportSchritt) {
                // A EmailForwarderExportSchritt is a boundary since it requires an up to date Ausführung for export.
                break;
            }

            if (
                CurrentSchritt.SollZustaendigkeit?.OrganisationseinheitId !=
                nextSchritt.SollZustaendigkeit?.OrganisationseinheitId
                || CurrentSchritt.SollZustaendigkeit?.MitarbeiterGruppeId !=
                nextSchritt.SollZustaendigkeit?.MitarbeiterGruppeId) {
                // A change in responsibilities between Schritte indicates a boundary.
                // (MitarbeiterGruppeId = null implies Bürger resposibility)
                break;
            }

            if (!verbindung.IstRelevant.AlwaysTrue) {
                // Generally this case can't happen, because there shouldn't be a single Verbindung that
                // has the possibility to be not relevant as the Ausführung would be stuck
                break;
            }

            yield return nextSchritt;
            verbindungen = Verbindungen.Where(v => v.VonId == nextSchritt.Id).ToList();
        }
    }

    /// <summary>
    /// Führt einen Schritt im Prozess aus und aktualisiert die Ausführung entsprechend.
    /// </summary>
    /// <param name="userId">ID des ausführenden Benutzers.</param>
    /// <param name="bearbeitungNextVerbindungId">ID der gewählten nächsten Verbindung.</param>
    /// <param name="bearbeitungSlotValues">Slot-Werte der aktuellen Bearbeitung.</param>
    /// <param name="naechsteIstZustaendigkeit">OptiAusfuehrungUpdateZugewiesenePersononale nächste Zuständigkeit.</param>
    /// <param name="validateStep">Ob der Step validiert werden soll.</param>
    public void Step(Guid userId, Guid bearbeitungNextVerbindungId,
        IReadOnlyList<SlotValuesInput> bearbeitungSlotValues,
        Zustaendigkeit? naechsteIstZustaendigkeit,
        bool validateStep = true
    ) {
        EnsureAllSlotsFilled(CurrentSchritt, bearbeitungSlotValues);
        EnsureUploadLimits(CurrentSchritt, bearbeitungSlotValues);

        if (CurrentVerbindungen.FirstOrDefault(v => v.Id == bearbeitungNextVerbindungId) is not { } verbindung) {
            throw new ArgumentException(
                $"Verbindung {bearbeitungNextVerbindungId} not found in Schritt {CurrentSchritt.Id}");
        }

        var bearbeitung = new Bearbeitung {
            SchrittId = CurrentSchritt.Id,
            NextVerbindungId = bearbeitungNextVerbindungId,
            CreatedAt = _clock.GetCurrentInstant(),
            UserId = userId,
            WarZustaendigkeit = Ausfuehrung.IstZustaendigkeit with {
                LiestRolle = null,
                LiestRolleId = null,
            },
        };

        var slotValues = new Dictionary<string, SlotValue>(this.CurrentSlotValues());
        foreach (var bearbeitungSlotValue in bearbeitungSlotValues) {
            slotValues[bearbeitungSlotValue.Name] = bearbeitungSlotValue.ToSlotValue(bearbeitung, CurrentSchritt);
        }

        if (validateStep && !_evaluatingVisitorService.Evaluate(verbindung.IstRelevant, slotValues, this.Prozess.KommuneId)) {
            throw new ArgumentException(
                $"Verbindung {bearbeitungNextVerbindungId} not relevant with current Slot Values");
        }

        var nextStep = _prozessVersion.Schritte.FirstOrDefault(s => s.Id == verbindung.NachId);

        if (nextStep is null) {
            throw new ArgumentException($"Next step {bearbeitungNextVerbindungId} not found");
        }

        if (nextStep is {
            SollZustaendigkeit: {
                Art: ZustaendigkeitArt.Dynamisch,
                LiestRolleId: null
            }
        } &&
            naechsteIstZustaendigkeit is null) {
            throw new ArgumentException(
                $"Nächster Schritt {nextStep.Id} erfordert eine dynamische Zustaendigkeit");
        }

        if (
            nextStep is { SollZustaendigkeit.Art: not ZustaendigkeitArt.Dynamisch } or
                {
                    SollZustaendigkeit: {
                        Art: ZustaendigkeitArt.Dynamisch,
                        LiestRolleId: not null
                    }
                } &&
            naechsteIstZustaendigkeit is not null) {
            throw new ArgumentException(
                $"Nächster Schritt {nextStep.Id} erwartet keine dynamische Zuständigkeit");
        }

        if (nextStep is { SollZustaendigkeit.Art: ZustaendigkeitArt.Dynamisch } && naechsteIstZustaendigkeit is not null) {
            var naechsteArten = nextStep.SollZustaendigkeit.DynamischeArten;
            var isValideNaechsteZustaendigkeit =
                naechsteArten.Contains(naechsteIstZustaendigkeit.Art);

            if (!isValideNaechsteZustaendigkeit) {
                throw new ArgumentException(
                    $"Nächster Schritt {nextStep.Id} erwartet nur {string.Join(',', naechsteArten)} als Zuständigkeit");
            }
        }

        bearbeitung.SlotValues =
            bearbeitungSlotValues.Select(bsv => bsv.ToSlotValue(bearbeitung, CurrentSchritt)).ToList();

        _ausfuehrung.Bearbeitungen.Add(bearbeitung);

        // Um die nächste Zuständigkeit zu bestimmen, muss die aktuelle Bearbeitung schon in der Liste sein.
        // Damit schritte eine Rolle übernehmen und gleichzeitig setzen können
        var naechsteTatsaechlicheIstZustaendigkeit = naechsteIstZustaendigkeit ?? GetZustaendigkeitAusNaechsterSollZustaendigkeit(nextStep);

        _ausfuehrung.SchrittId = verbindung.NachId;
        _ausfuehrung.Status = CurrentSchritt switch {
            EndeSchritt => AusfuehrungStatus.Abgeschlossen, { ErledigungDurchBuerger: true } => AusfuehrungStatus.BearbeitungDurchBuerger,
            _ => AusfuehrungStatus.BearbeitungDurchKommune,
        };

        if (CurrentSchritt is EndeSchritt) {
            _ausfuehrung.AbgeschlossenAm = _clock.GetCurrentInstant();
        }

        // CurrentSchritt ist nach Änderung der SchrittId schon der nächste Schritt
        // Wenn die nächste Ist-Zuständigkeit gesetzt ist, können wir diese verwenden weil bereits gprüft wurde
        // dass der nächste Schritt eine Dynamische Soll-Zuständigkeit hat
        if (naechsteTatsaechlicheIstZustaendigkeit.Art == ZustaendigkeitArt.Buerger) {
            _ausfuehrung.IstZustaendigkeit.Art = ZustaendigkeitArt.Buerger;
            _ausfuehrung.IstZustaendigkeit.DienstleisterId = null;
            _ausfuehrung.IstZustaendigkeit.OrganisationseinheitId = null;
            _ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId = null;
            _ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId = null;
        } else {
            if (WechseltInAndereZustaendigkeit(_ausfuehrung.IstZustaendigkeit, naechsteTatsaechlicheIstZustaendigkeit)) {
                _ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId = naechsteTatsaechlicheIstZustaendigkeit.ZugewiesenePersonId;
            }

            _ausfuehrung.IstZustaendigkeit.Art = naechsteTatsaechlicheIstZustaendigkeit.Art;
            _ausfuehrung.IstZustaendigkeit.DienstleisterId = naechsteTatsaechlicheIstZustaendigkeit.DienstleisterId;
            _ausfuehrung.IstZustaendigkeit.OrganisationseinheitId = naechsteTatsaechlicheIstZustaendigkeit.OrganisationseinheitId;
            _ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId = naechsteTatsaechlicheIstZustaendigkeit.MitarbeiterGruppeId;
        }

        // TODO: Durch tatsächliche Backend-Validierung des Prozesses ersetzen
        PreventInvalidState();

        // Recipients are resolved from the landing step's Zuständigkeit. Snapshot it here because a later
        // Step in the same walker mutates IstZustaendigkeit in place before SaveChangesAsync flushes mail.
        if (CurrentSchritt.VersendeEMailAnMitarbeiterGruppe == true) {
            var zustaendigkeit = CurrentSchritt.SollZustaendigkeit is { Art: ZustaendigkeitArt.Dynamisch }
                ? SnapshotZustaendigkeit(Ausfuehrung.IstZustaendigkeit)
                : CurrentSchritt.SollZustaendigkeit;
            _pendingMailEvaluations.Add((CurrentSchritt, zustaendigkeit));
        }
    }

    /// <summary>
    /// Verhindert ungültige Zustände der Zuständigkeit nach einer Bearbeitung.
    /// </summary>
    private void PreventInvalidState() {
        switch (_ausfuehrung.IstZustaendigkeit) {
            case { Art: ZustaendigkeitArt.Dynamisch }:
                throw new InvalidOperationException(
                    "IstZuständigkeit darf nach Bearbeitung nicht im Zustand Dynamisch sein.");
            case { Art: ZustaendigkeitArt.Dienstleister, DienstleisterId: null }:
                throw new InvalidOperationException(
                    "IstZuständigkeit darf nach Bearbeitung nicht im Zustand Dienstleister sein, wenn kein Dienstleister gesetzt ist.");
            case { Art: ZustaendigkeitArt.Organisationseinheit, OrganisationseinheitId: null }:
                throw new InvalidOperationException(
                    "IstZuständigkeit darf nach Bearbeitung nicht im Zustand Organisationseinheit sein, wenn keine Organisationseinheit gesetzt ist.");
        }
    }

    /// <summary>
    /// Ermittelt die tatsächliche Zuständigkeit aus der Soll-Zuständigkeit des nächsten Schritts.
    /// </summary>
    /// <param name="nextSchritt">Der nächste Schritt im Prozess.</param>
    /// <returns>Die ermittelte Zuständigkeit.</returns>
    private Zustaendigkeit GetZustaendigkeitAusNaechsterSollZustaendigkeit(Schritt nextSchritt) {
        if (nextSchritt is not {
            SollZustaendigkeit: {
                Art: ZustaendigkeitArt.Dynamisch,
                LiestRolleId: { } liestRolleId
            }
        }) {
            return nextSchritt.SollZustaendigkeit;
        }

        // Bearbeitungen enthält bereits die aktuelle Bearbeitung, auf der Schritt (noch) nicht gesetzt ist,
        // da sie erst nach dem Speichern gesetzt wird.
        var schritteZuRolleMap = _prozessVersion.Schritte.ToDictionary(s => s.Id, s => s.SchreibtRolleId);

        var latestRelevantBearbeitung = Ausfuehrung.Bearbeitungen
            .Where(bearbeitung => schritteZuRolleMap[bearbeitung.SchrittId] == liestRolleId)
            .OrderByDescending(bearbeitung => bearbeitung.CreatedAt)
            .FirstOrDefault();

        if (latestRelevantBearbeitung is null) {
            throw new ArgumentException(
                $"Schritt {nextSchritt.Id} erwartet die Zuweisung aus einer Rolle, es gibt aber keine Bearbeitung welche diese Rolle schreibt.");
        }

        return latestRelevantBearbeitung.WarZustaendigkeit;
    }

    /// <summary>
    /// Prüft, ob alle erforderlichen Slots für einen Schritt ausgefüllt sind.
    /// </summary>
    /// <param name="schritt">Der Schritt, dessen Slots geprüft werden.</param>
    /// <param name="values">Die übergebenen Slot-Werte.</param>
    private void EnsureAllSlotsFilled(Schritt schritt, IEnumerable<SlotValuesInput> values) {
        var allSlots = schritt.Slots.ToList();
        var requiredSlotNames = allSlots.Where(s => !s.Optional).Select(s => s.Name).ToHashSet();
        var availableSlotNames = allSlots.Select(s => s.Name).ToHashSet();
        var providedSlotNames = values.Select(sv => sv.Name).ToHashSet();

        if (!requiredSlotNames.All(required => providedSlotNames.Contains(required))) {
            throw new ArgumentException(
                $"All slotnames have to be provided. Expected: {String.Join(", ", requiredSlotNames)}. Got: {String.Join(", ", providedSlotNames)}");
        }

        if (!providedSlotNames.All(provided => availableSlotNames.Contains(provided))) {
            throw new ArgumentException(
                $"Unexpected slotnames provided. Expected: {String.Join(", ", availableSlotNames)}. Got: {String.Join(", ", providedSlotNames)}");
        }
    }

    private static void EnsureUploadLimits(Schritt schritt, IEnumerable<SlotValuesInput> values) {
        if (schritt is not FormularSchritt formular) {
            return;
        }

        foreach (var feld in formular.Felder.OfType<UploadFormularFeld>()) {
            if (feld.MaxAnzahl is not { } maxAnzahl) {
                continue;
            }

            // Encrypted uploads arrive as one cipher and cannot be counted here.
            var dateien = values.FirstOrDefault(v => v.Name == feld.SlotName)?.Value.PlainValue;
            if (dateien is { ValueKind: JsonValueKind.Array } && dateien.Value.GetArrayLength() > maxAnzahl) {
                throw new ZuVieleDateienException(feld.AngezeigterName ?? feld.SlotName, maxAnzahl);
            }
        }
    }

    /// <summary>
    /// Prüft, ob sich die Zuständigkeit ändert.
    /// </summary>
    /// <param name="aktuelleZustaendigkeit">Die aktuelle Zuständigkeit.</param>
    /// <param name="naechsteZustaendigkeit">Die nächste Zuständigkeit.</param>
    /// <returns>True, wenn sich die Zuständigkeit ändert, sonst false.</returns>
    private static bool WechseltInAndereZustaendigkeit(Zustaendigkeit aktuelleZustaendigkeit,
        Zustaendigkeit naechsteZustaendigkeit) {
        return aktuelleZustaendigkeit.Art != naechsteZustaendigkeit.Art
               || aktuelleZustaendigkeit.DienstleisterId != naechsteZustaendigkeit.DienstleisterId
               || aktuelleZustaendigkeit.OrganisationseinheitId != naechsteZustaendigkeit.OrganisationseinheitId
               || aktuelleZustaendigkeit.MitarbeiterGruppeId != naechsteZustaendigkeit.MitarbeiterGruppeId
               // Auf der nächsten Zuständigkeit wird eine ZugewiesenePerson vorgegeben welche sich von der aktuellen unterscheidet
               || (
                   naechsteZustaendigkeit.ZugewiesenePersonId != null
                   && aktuelleZustaendigkeit.ZugewiesenePersonId != naechsteZustaendigkeit.ZugewiesenePersonId
               );
    }

    /// <summary>Queues the "Antrag eingegangen" e-mail to the step's responsible party if the step asks for it.</summary>
    private async Task EvaluateSendMail(Schritt schritt, Zustaendigkeit? zustaendigkeit) {
        var recipientEmails = await ResolveRecipientEmails(zustaendigkeit);

        if (recipientEmails.Count == 0) {
            return;
        }

        var ausfuehrungId = Ausfuehrung.Id;
        var (organisationseinheit, abteilung) = await ResolveZustaendigkeitNames(zustaendigkeit);
        var angaben = await LoadPublicAngaben();
        var antragUrl = $"{_webOptions.BaseUrl}/antraege/{Ausfuehrung.Id}";
        var templateParams = new Dictionary<string, object> {
            { nameof(AntragEingegangenEmail.AntragUrl), antragUrl },
            { nameof(AntragEingegangenEmail.AusfuehrungId), ausfuehrungId.ToString() },
            { nameof(AntragEingegangenEmail.ProzessName), Prozess.Name },
            { nameof(AntragEingegangenEmail.Organisationseinheit), organisationseinheit },
            { nameof(AntragEingegangenEmail.Abteilung), abteilung },
            { nameof(AntragEingegangenEmail.Angaben), angaben },
            {
                nameof(AntragEingegangenEmail.Datum),
                Ausfuehrung.CreatedAt.InZone(DateTimeZoneProviders.Tzdb["Europe/Berlin"]).ToString("dd.MM.yyyy", null)
            },
        };

        // One outbox item per recipient keeps delivery and failures traceable per address,
        // while rendering and saving happen once for all of them.
        await _emailService.AddMailToOutboxAsync<AntragEingegangenEmail, AntragEingegangenEmailText>(
            recipientEmails: recipientEmails, templateParams: templateParams,
            subject: $"Neuer Antrag eingegangen: {Prozess.Name}", kommuneId: Prozess.KommuneId);
    }

    public Task<(string Organisationseinheit, string Abteilung)> ResolveZustaendigkeitNames(
        Zustaendigkeit? zustaendigkeit) => ZustaendigkeitNames.Resolve(_domainContext, zustaendigkeit);

    private const int MaxAngabeLength = 300;

    // Unencrypted is not enough: processes also store personal data (IBAN, phone) unencrypted.
    private async Task<List<EmailAngabe>> LoadPublicAngaben() {
        var felder = await _domainContext.StringFormularFelder
            .Where(f => f.Schritt.ProzessVersionId == Ausfuehrung.ProzessVersionId
                        && f.OeffentlichSichtbar && !f.Encrypted && f.AngezeigterName != null)
            .OrderBy(f => f.Order)
            .Select(f => new { f.SlotName, Label = f.AngezeigterName! })
            .ToListAsync();
        felder = felder.DistinctBy(f => f.SlotName).ToList();

        if (felder.Count == 0) {
            return [];
        }

        var slotNames = felder.Select(f => f.SlotName).ToList();
        var values = await _domainContext.PlainSlotValues
            .Where(v => v.Bearbeitung.AusfuehrungId == Ausfuehrung.Id && slotNames.Contains(v.SlotName))
            .OrderBy(v => v.Bearbeitung.CreatedAt)
            .ToListAsync();
        var latestBySlot = values.GroupBy(v => v.SlotName).ToDictionary(g => g.Key, g => g.Last());

        var angaben = new List<EmailAngabe>();
        foreach (var feld in felder) {
            if (latestBySlot.TryGetValue(feld.SlotName, out var slotValue)
                && slotValue.Value.ValueKind == System.Text.Json.JsonValueKind.String
                && slotValue.Value.GetString() is { Length: > 0 } text) {
                angaben.Add(new EmailAngabe(feld.Label,
                    text.Length > MaxAngabeLength ? text[..MaxAngabeLength].TrimEnd() + "..." : text));
            }
        }

        return angaben;
    }

    private static Zustaendigkeit SnapshotZustaendigkeit(Zustaendigkeit zustaendigkeit) => new() {
        Art = zustaendigkeit.Art,
        DienstleisterId = zustaendigkeit.DienstleisterId,
        OrganisationseinheitId = zustaendigkeit.OrganisationseinheitId,
        MitarbeiterGruppeId = zustaendigkeit.MitarbeiterGruppeId,
        ZugewiesenePersonId = zustaendigkeit.ZugewiesenePersonId,
    };

    /// <summary>The navigation properties on <see cref="Zustaendigkeit"/> are not loaded, so the addresses are queried directly.</summary>
    private async Task<List<string>> ResolveRecipientEmails(Zustaendigkeit? zustaendigkeit) =>
        zustaendigkeit switch { { Art: ZustaendigkeitArt.Dienstleister, DienstleisterId: { } dienstleisterId } =>
                                    await _domainContext.Dienstleister
                                        .Where(d => d.Id == dienstleisterId)
                                        .Select(d => d.EMailAdressen)
                                        .FirstOrDefaultAsync() ?? [], { Art: ZustaendigkeitArt.Organisationseinheit, MitarbeiterGruppeId: { } mitarbeiterGruppeId } =>
                                                                          await _domainContext.MitarbeiterGruppen
                                                                              .Where(m => m.Id == mitarbeiterGruppeId)
                                                                              .Select(m => m.EMailAdressen)
                                                                              .FirstOrDefaultAsync() ?? [],
            _ => [],
        };

    /// <summary>
    /// Speichert Änderungen im Datenbankkontext asynchron und queued danach ausstehende Abteilungs-Mails.
    /// Ein Fehler beim Mailversand darf den bereits gespeicherten Schrittübergang nicht zurückrollen.
    /// </summary>
    public async Task SaveChangesAsync() {
        await _domainContext.SaveChangesAsync();

        foreach (var (schritt, zustaendigkeit) in _pendingMailEvaluations) {
            try {
                await EvaluateSendMail(schritt, zustaendigkeit);
            } catch (Exception ex) {
                _logger.LogError(ex,
                    "Failed to queue department notification for Ausfuehrung {AusfuehrungId}, Schritt {SchrittId}",
                    _ausfuehrung.Id, schritt.Id);
            }
        }

        _pendingMailEvaluations.Clear();
    }

    /// <summary>
    /// Gibt Ressourcen synchron frei.
    /// </summary>
    public void Dispose() {
        _domainContext.Dispose();
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Gibt Ressourcen asynchron frei.
    /// </summary>
    /// <returns>ValueTask für die asynchrone Freigabe.</returns>
    public async ValueTask DisposeAsync() {
        await _domainContext.DisposeAsync();
        GC.SuppressFinalize(this);
    }
}
