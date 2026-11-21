using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Kommune;
using API.Features.PdfGenerator;
using API.Features.Prozess.Queries;
using API.Features.PushNotifications;
using API.Infrastructure;
using API.Options;
using API.Utils;
using FirebaseAdmin.Messaging;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using NodaTime;
using DateTime = System.DateTime;
using UnauthorizedAccessException = API.Utils.UnauthorizedAccessException;

namespace API.Features.Prozess.Mutations;

/// <summary>
/// Enthält Mutationsmethoden zur Verwaltung von Ausführungen (Anträgen) in Prozessen.
/// </summary>
[MutationType]
[ExtendObjectType<Kommune.Kommune>]
public class AusfuehrungMutations {
    [Authorize]
    [GraphQLDescription("Startet einen neuen Antrag (Ausführung) für eine Prozessversion. Initialisiert den Prozess und führt die ersten Bearbeitungsschritte aus.")]
    public async Task<AusfuehrungResult> AusfuehrungCreate(
        CurrentUserAccessor userAccessor, IClock clock,
        [Service] IOptions<EnvironmentOptions> environmentOptions,
        [Service] IFirebasePushMessagingService firebasePush,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] VorgangsverlaufService verlaufService,
        [Service] ProzessOptions prozessOptions,
        DomainContext db,
        WalkerFactory walkerFactory, Guid prozessVersionId, IEnumerable<AusfuehrungBearbeitungInput> bearbeitungen,
        SchrittSollZustaendigkeitInput? naechsteIstZustaendigkeit,
        string sharedKeyEncryptedForBuerger, string sharedKeyEncryptedForKommune) {
        var user = await userAccessor.User();
        var walker = await walkerFactory.StartNewAusfuehrung(prozessVersionId,
            new Ausfuehrung {
                ProzessVersionId = prozessVersionId,
                UserId = user.Id,
                CreatedAt = clock.GetCurrentInstant(),
                SharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger,
                SharedKeyEncryptedForKommune = sharedKeyEncryptedForKommune,
                Status = AusfuehrungStatus.BearbeitungDurchBuerger,
                SchrittId = Guid.Empty
            });

        var istZustaendigkeit = naechsteIstZustaendigkeit is not null
            ? new Zustaendigkeit {
                Art = naechsteIstZustaendigkeit.Art,
                OrganisationseinheitId = naechsteIstZustaendigkeit.OrganisationseinheitId,
                DienstleisterId = naechsteIstZustaendigkeit.DienstleisterId,
                MitarbeiterGruppeId = naechsteIstZustaendigkeit.MitarbeiterGruppeId,
            }
            : null;

        await PerformSteps(walker, user, bearbeitungen, ausfuehrungZustaendigkeitService, istZustaendigkeit,
            prozessOptions);

        await walker.SaveChangesAsync();

        verlaufService.RecordEingang(db, walker.Ausfuehrung.Id, walker.Ausfuehrung.CreatedAt);
        await db.SaveChangesAsync();

        if (user is Buerger {
            PushNotificationTokens.Count: > 0
        } buerger) {
            if (walker.Prozess.TagHistorie.Any(h => h.Tag.Tag == "Mängelmelder")) {
                await firebasePush.TrySubscribeToTopicAsync(buerger.PushNotificationTokens,
                    new PushTopic.Mangel(environmentOptions.Value.Name, walker.Ausfuehrung.Id).ToString(),
                    $"Mangel erstellt für {walker.Ausfuehrung.Id}");
            } else {
                await firebasePush.TrySubscribeToTopicAsync(buerger.PushNotificationTokens,
                    new PushTopic.Ausfuehrung(environmentOptions.Value.Name, walker.Ausfuehrung.Id).ToString(),
                    $"Ausführung erstellt für {walker.Ausfuehrung.Id}");
            }
        }

        return new AusfuehrungResult(walker.Ausfuehrung,
            await UserCanPerformSchritt(walker.Ausfuehrung, walker.CurrentSchritt, user,
                ausfuehrungZustaendigkeitService, istZustaendigkeit));
    }


    [AllowAnonymous]
    [Error(typeof(AnonymeEinreichungNichtErlaubtException))]
    [Error(typeof(AnonymeEinreichungUnvollstaendigException))]
    [GraphQLDescription(
        "Reicht einen Antrag ohne Anmeldung ein. Nur für Prozesse mit dem Tag 'Anonym'. Alle Schritte der " +
        "antragstellenden Person müssen in diesem einen Aufruf enthalten sein, weil der Antrag danach niemandem " +
        "mehr zum Fortsetzen gehört. Liefert die CorrelationId für die Statusabfrage.")]
    public async Task<AnonymeAusfuehrungResult> AusfuehrungCreateAnonym(
        IClock clock,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] VorgangsverlaufService verlaufService,
        [Service] ProzessOptions prozessOptions,
        DomainContext db,
        WalkerFactory walkerFactory, Guid prozessVersionId, IEnumerable<AusfuehrungBearbeitungInput> bearbeitungen,
        string sharedKeyEncryptedForKommune) {
        var anonymErlaubt = await db.ProzessVersionen.AnyAsync(v =>
            v.Id == prozessVersionId && v.Prozess.Tags.Any(t => t.Tag == AnonymeEinreichung.ProzessTagName));
        if (!anonymErlaubt) {
            throw new AnonymeEinreichungNichtErlaubtException();
        }

        var systemUser = await db.SystemUsers.SingleAsync(u => u.Id == SystemUser.UserId);
        var walker = await walkerFactory.StartNewAusfuehrung(prozessVersionId,
            new Ausfuehrung {
                ProzessVersionId = prozessVersionId,
                UserId = systemUser.Id,
                CreatedAt = clock.GetCurrentInstant(),
                // There is no Bürger key pair to encrypt for; the submitter keeps nothing but the CorrelationId.
                SharedKeyEncryptedForBuerger = "",
                SharedKeyEncryptedForKommune = sharedKeyEncryptedForKommune,
                Status = AusfuehrungStatus.BearbeitungDurchBuerger,
                SchrittId = Guid.Empty,
                CorrelationId = Guid.NewGuid(),
            });

        await PerformSteps(walker, systemUser, bearbeitungen, ausfuehrungZustaendigkeitService, null, prozessOptions);

        if (walker.Ausfuehrung.Status == AusfuehrungStatus.BearbeitungDurchBuerger) {
            throw new AnonymeEinreichungUnvollstaendigException();
        }

        await walker.SaveChangesAsync();

        verlaufService.RecordEingang(db, walker.Ausfuehrung.Id, walker.Ausfuehrung.CreatedAt);
        await db.SaveChangesAsync();

        return new AnonymeAusfuehrungResult(walker.Ausfuehrung.CorrelationId!.Value);
    }

    [Authorize]
    [Error(typeof(AusfuehrungNotFoundException))]
    [Error(typeof(NachrichtTooLongException))]
    [GraphQLDescription("Führt die Bearbeitung eines laufenden Antrags (Ausführung) fort. Überträgt die nächsten Schritte, Slot-Werte und ggf. Zuständigkeiten.")]
    public async Task<AusfuehrungResult> AusfuehrungContinue(CurrentUserAccessor userAccessor,
        [Service] IOptions<EnvironmentOptions> environmentOptions,
        [Service] IFirebasePushMessagingService firebasePush,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] VorgangsverlaufService verlaufService,
        [Service] ProzessOptions prozessOptions,
        WalkerFactory walkerFactory, Guid ausfuehrungId, IEnumerable<AusfuehrungBearbeitungInput> bearbeitungen,
        SchrittSollZustaendigkeitInput? naechsteIstZustaendigkeit,
        DomainContext db) {
        var user = await userAccessor.User();
        var walker = await walkerFactory.ContinueAusfuehrung(ausfuehrungId);

        var istZustaendigkeit = naechsteIstZustaendigkeit is not null
            ? new Zustaendigkeit {
                Art = naechsteIstZustaendigkeit.Art,
                OrganisationseinheitId = naechsteIstZustaendigkeit.OrganisationseinheitId,
                DienstleisterId = naechsteIstZustaendigkeit.DienstleisterId,
                MitarbeiterGruppeId = naechsteIstZustaendigkeit.MitarbeiterGruppeId,
            }
            : null;

        await EnsureAbteilungGehoertZuOrganisationseinheit(db, walker.Prozess.KommuneId, naechsteIstZustaendigkeit);

        var oldBearbeitungen = walker.Ausfuehrung.Bearbeitungen.Count;
        var oldZustaendigkeit = walker.Ausfuehrung.IstZustaendigkeit with { };

        var performedSteps = await PerformSteps(walker, user, bearbeitungen, ausfuehrungZustaendigkeitService,
            istZustaendigkeit, prozessOptions);

        await walker.SaveChangesAsync();

        var istMaengelmelder = walker.Prozess.TagHistorie.Any(h => h.Tag.Tag == "Mängelmelder");

        var ausfuehrung = await db.Ausfuehrungen.Include(a => a.IstZustaendigkeit.ZugewiesenePerson).AsTracking()
            .FirstOrDefaultAsync(a => a.Id == ausfuehrungId);
        if (ausfuehrung == null) throw new AusfuehrungNotFoundException();

        if (walker.Ausfuehrung.Bearbeitungen.Count > oldBearbeitungen) {
            var letzteBearbeitung = walker.Ausfuehrung.Bearbeitungen.Last();
            var verbindung = await db.Verbindungen.FirstAsync(v => v.Id == letzteBearbeitung.NextVerbindungId);
            if (!string.IsNullOrWhiteSpace(verbindung.StatusAenderung)) {
                if (istMaengelmelder) {
                    await NotifyMangel(firebasePush, environmentOptions.Value.Name, ausfuehrungId,
                        verbindung.StatusAenderung, verbindung.StatusAenderungBeschreibung);
                } else {
                    await NotifyAusfuehrung(firebasePush, environmentOptions.Value.Name, ausfuehrungId,
                        verbindung.StatusAenderung, verbindung.StatusAenderungBeschreibung);

                }
            }

            foreach (var (schritt, neueBearbeitung) in performedSteps) {
                if (schritt is NachrichtSchritt && NachrichtSchritt.NachrichtFrom(neueBearbeitung) is { } nachricht) {
                    verlaufService.RecordBuergerKommunikation(db, ausfuehrungId, user as Mitarbeiter, nachricht,
                        neueBearbeitung.CreatedAt);
                }
            }

            await verlaufService.ProtokolliereZustaendigkeitswechsel(db, ausfuehrung, oldZustaendigkeit,
                user as Mitarbeiter);
            await db.SaveChangesAsync();
        }

        return new AusfuehrungResult(walker.Ausfuehrung,
            await UserCanPerformSchritt(walker.Ausfuehrung, walker.CurrentSchritt, user,
                ausfuehrungZustaendigkeitService, istZustaendigkeit));
    }


    [Error(typeof(AusfuehrungNotFoundException))]
    [Error(typeof(UserNotFoundException))]
    [Error(typeof(MismatchingKommuneException))]
    [Error(typeof(UnauthorizedAccessException))]
    [Authorize]
    [GraphQLDescription("Weist eine andere Person als zuständig für den Antrag zu (Antrag Übernehmen im Backoffice).")]
    public async Task<Ausfuehrung> AusfuehrungUpdateZugewiesenePerson(
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] VorgangsverlaufService verlaufService,
        CurrentUserAccessor userAccessor,
        Guid ausfuehrungId, Guid userId, DomainContext db,
        ICurrentSchrittByAusfuehrungIdDataLoader currentSchrittByAusfuehrungIdDataLoader) {
        var user = await userAccessor.User();

        if (user is not BackofficeUser currentMitarbeiter)
            throw new UnauthorizedAccessException();

        var ausfuehrung = await db.Ausfuehrungen.AsTracking()
            .Include(a => a.IstZustaendigkeit)
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .FirstOrDefaultAsync(a => a.Id == ausfuehrungId);
        if (ausfuehrung == null) throw new AusfuehrungNotFoundException();

        if (ausfuehrung.Status == AusfuehrungStatus.Abgeschlossen) {
            throw new NotAllowedException();
        }

        var kommuneId = ausfuehrung.ProzessVersion.Prozess.KommuneId;
        if (currentMitarbeiter.KommuneId !=
            ausfuehrung.ProzessVersion.Prozess.KommuneId) throw new MismatchingKommuneException();

        var zugewiesenePerson = await db.Users.OfType<Mitarbeiter>().Include(u => ((BackofficeUser)u).Gruppen)
            .AsSingleQuery()
            .FirstOrDefaultAsync(m => m.Id == userId);
        if (zugewiesenePerson == null) throw new UserNotFoundException();

        if (zugewiesenePerson.KommuneId != kommuneId) throw new MismatchingKommuneException();

        if (!await ausfuehrungZustaendigkeitService.IstZustaendigFuerAusfuehrung(currentMitarbeiter, ausfuehrung)) {
            throw new UnauthorizedAccessException();
        }

        ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId = userId;

        if (userId == currentMitarbeiter.Id) {
            verlaufService.RecordUebernahme(db, ausfuehrungId, currentMitarbeiter);
        } else {
            verlaufService.RecordZustaendigkeitswechsel(db, ausfuehrungId, currentMitarbeiter,
                VorgangsverlaufService.NameVon(zugewiesenePerson));
        }

        await db.SaveChangesAsync();
        return ausfuehrung;
    }

    [Error(typeof(AusfuehrungNotFoundException))]
    [Error(typeof(UserNotFoundException))]
    [Error(typeof(AntragWeiterleitenException))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(NachrichtTooLongException))]
    [Error(typeof(NachrichtRequiredException))]
    [Authorize]
    [GraphQLDescription("Leitet einen Antrag intern oder extern weiter (z.B. an andere Mitarbeitende oder per E-Mail). Kann auch zum Manuellen Abschluss des Antrags führen; dafür ist eine Nachricht an die antragstellende Person erforderlich. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Ausfuehrung> AusfuehrungWeiterleiten(CurrentUserAccessor userAccessor,
        [Service] IClock clock,
        [Service] AusfuehrungWeiterleitenService ausfuehrungWeiterleitenService,
        [Service] VorgangsverlaufService verlaufService,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] ProzessOptions prozessOptions,
        [Service] IFirebasePushMessagingService firebasePush,
        [Service] IOptions<EnvironmentOptions> environmentOptions,
        Guid ausfuehrungId,
        string? empfaengerEmail, WeiterleitungEmpfaenger weiterleitungEmpfaenger, WeiterleitungArt? weiterleitungArt,
        Guid? empfaengerId,
        string? nachricht,
        DomainContext db, CancellationToken cancellationToken) {
        var (user, _) = await userAccessor.EnsureBackofficeUser();
        var ausfuehrung =
            await db.Ausfuehrungen.AsTracking().AsSplitQuery().Include(a => a.ProzessVersion).ThenInclude(pv => pv.Prozess)
                .Include(a => a.IstZustaendigkeit.ZugewiesenePerson)
                .Include(a => a.IstZustaendigkeit.Organisationseinheit)
                .Include(a => a.IstZustaendigkeit.MitarbeiterGruppe)
                .Include(a => a.IstZustaendigkeit.Dienstleister)
                .FirstOrDefaultAsync(a => a.Id == ausfuehrungId) ??
            throw new AusfuehrungNotFoundException("Der Antrag konnte nicht gefunden werden.");
        var prozess = await db.Prozesse.Include(p => p.TagHistorie).ThenInclude(h => h.Tag)
                          .FirstOrDefaultAsync(p => p.Id == ausfuehrung.ProzessVersion.ProzessId) ??
                      throw new Exception();

        switch (weiterleitungEmpfaenger) {
            case WeiterleitungEmpfaenger.Intern: {
                    if (!await ausfuehrungZustaendigkeitService.IstZustaendigFuerAusfuehrung(user, ausfuehrung)) {
                        throw new NotAllowedException();
                    }

                    var nextZustaendiger = await db.BackofficeUser
                        .AsSplitQuery()
                        .Include(u => u.Gruppen)
                        .FirstOrDefaultAsync(u => u.Id == empfaengerId) ??
                                           throw new UserNotFoundException("Der Nutzer konnte nicht gefunden werden.");
                    if (!await ausfuehrungZustaendigkeitService.IstZustaendigFuerAusfuehrung(nextZustaendiger, ausfuehrung)) {
                        throw new NotAllowedException();
                    }

                    ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId = empfaengerId;
                    verlaufService.RecordZustaendigkeitswechsel(db, ausfuehrungId, user,
                        VorgangsverlaufService.NameVon(nextZustaendiger));
                    await db.SaveChangesAsync();
                    return ausfuehrung;
                }
            case WeiterleitungEmpfaenger.Extern:
                if (empfaengerEmail == null) throw new Exception();
                switch (weiterleitungArt) {
                    case WeiterleitungArt.Kopieren:
                        await ausfuehrungWeiterleitenService.VersandAusfuehrung(db, ausfuehrung, empfaengerEmail, user,
                            prozess, cancellationToken);
                        verlaufService.RecordWeiterleitung(db, ausfuehrungId,
                            VerlaufsEreignisArt.WeiterleitungAnsicht, user, empfaengerEmail);
                        await db.SaveChangesAsync(cancellationToken);
                        return ausfuehrung;
                    case WeiterleitungArt.Schliessen:
                        if (ausfuehrung.Status == AusfuehrungStatus.Abgeschlossen) {
                            throw new AntragWeiterleitenException("Der Antrag ist bereits abgeschlossen.");
                        }

                        var buergerNachricht = nachricht?.Trim();
                        if (string.IsNullOrEmpty(buergerNachricht)) throw new NachrichtRequiredException();
                        if (buergerNachricht.Length > prozessOptions.NachrichtMaxLength) {
                            throw new NachrichtTooLongException(prozessOptions.NachrichtMaxLength);
                        }

                        await ausfuehrungWeiterleitenService.VersandAusfuehrung(db, ausfuehrung, empfaengerEmail, user,
                            prozess, cancellationToken);
                        var now = clock.GetCurrentInstant();
                        ausfuehrung.ManuellAbgeschlossen = now;
                        ausfuehrung.AbgeschlossenAm = now;
                        ausfuehrung.Status = AusfuehrungStatus.Abgeschlossen;
                        verlaufService.RecordWeiterleitung(db, ausfuehrungId,
                            VerlaufsEreignisArt.WeiterleitungAbgabe, user, empfaengerEmail, buergerNachricht);
                        verlaufService.RecordAbschluss(db, ausfuehrungId, user);
                        await db.SaveChangesAsync(cancellationToken);

                        const string pushTitel = "Neue Nachricht zu Ihrem Antrag";
                        const string pushText = "Ihr Antrag wurde an die zuständige Stelle abgegeben.";
                        if (prozess.TagHistorie.Any(h => h.Tag.Tag == "Mängelmelder")) {
                            await NotifyMangel(firebasePush, environmentOptions.Value.Name, ausfuehrungId, pushTitel,
                                pushText);
                        } else {
                            await NotifyAusfuehrung(firebasePush, environmentOptions.Value.Name, ausfuehrungId,
                                pushTitel, pushText);
                        }

                        return ausfuehrung;
                    default:
                        throw new Exception();
                }
            default:
                throw new Exception();
        }
    }

    [Error(typeof(BearbeitungNotFoundException))]
    [Error(typeof(SlotValueNotFoundException))]
    [Authorize]
    [GraphQLDescription("Setzt den Freigabe-Status eines Slot-Wertes (z.B. eines Uploads) im Antrag. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Ausfuehrung> UpdateIstFreigegebenSlotValue(DomainContext db, CurrentUserAccessor userAccessor,
        Guid ausfuehrungId, Guid slotValueId, bool istFreigegeben) {
        var (user, berechtigungen) = await userAccessor.EnsureBackofficeUser();

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();
        var ausfuehrung = await db.Ausfuehrungen.Include((a) => a.Bearbeitungen).ThenInclude((b) => b.SlotValues)
                              .Include(ausfuehrung => ausfuehrung.ProzessVersion)
                              .ThenInclude(prozessVersion => prozessVersion.Prozess)
                              .AsSingleQuery().AsTracking()
                              .FirstOrDefaultAsync((a) =>
                                  a.Id == ausfuehrungId && a.ProzessVersion.Prozess.KommuneId == user.KommuneId) ??
                          throw new MismatchingKommuneException();

        var lastBearbeitungOnSlot = ausfuehrung.Bearbeitungen
                                        .OrderByDescending(b => b.CreatedAt)
                                        .FirstOrDefault(bearbeitung =>
                                            bearbeitung.SlotValues.Any(sv => sv.Id == slotValueId)
                                        ) ?? throw new BearbeitungNotFoundException();
        var slotValue = lastBearbeitungOnSlot.SlotValues.FirstOrDefault(sv => sv.Id == slotValueId) ??
                        throw new SlotValueNotFoundException();
        slotValue.IstFreigegeben = istFreigegeben;
        await db.SaveChangesAsync();
        return ausfuehrung;
    }

    private static async Task EnsureAbteilungGehoertZuOrganisationseinheit(DomainContext db, Guid kommuneId,
        SchrittSollZustaendigkeitInput? naechsteIstZustaendigkeit) {
        if (naechsteIstZustaendigkeit is not { Art: ZustaendigkeitArt.Organisationseinheit }) return;

        var organisationseinheitId = naechsteIstZustaendigkeit.OrganisationseinheitId;
        var mitarbeiterGruppeId = naechsteIstZustaendigkeit.MitarbeiterGruppeId;

        if (organisationseinheitId is null) {
            throw new NotAllowedException("Bitte wählen Sie eine Organisationseinheit aus.");
        }

        if (mitarbeiterGruppeId is null) {
            throw new NotAllowedException("Bitte wählen Sie eine Abteilung der Organisationseinheit aus.");
        }

        var abteilungPasst = await db.MitarbeiterGruppen
            .Where(g => g.Id == mitarbeiterGruppeId.Value && g.KommuneId == kommuneId && !g.IsDeleted)
            .Where(g => g.Organisationseinheiten.Any(o =>
                o.Id == organisationseinheitId.Value && o.KommuneId == kommuneId))
            .AnyAsync();
        if (!abteilungPasst) {
            throw new NotAllowedException("Die gewählte Abteilung gehört nicht zur gewählten Organisationseinheit.");
        }
    }

    /// <summary>
    /// Führt die angegebenen Bearbeitungsschritte für eine Ausführung aus.
    /// </summary>
    private static async Task<List<(Schritt Schritt, Bearbeitung Bearbeitung)>> PerformSteps(Walker walker, User user,
        IEnumerable<AusfuehrungBearbeitungInput> bearbeitungen,
        AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        Zustaendigkeit? naechsteIstZustaendigkeit,
        ProzessOptions prozessOptions
    ) {
        var performedSteps = new List<(Schritt, Bearbeitung)>();

        foreach (var bearbeitung in bearbeitungen) {
            if (walker.CurrentSchritt.Id != bearbeitung.SchrittId) {
                throw new ArgumentException(
                    $"Expected SchrittId {walker.CurrentSchritt.Id} but got {bearbeitung.SchrittId}");
            }

            if (!await UserCanPerformSchritt(walker.Ausfuehrung, walker.CurrentSchritt, user,
                    ausfuehrungZustaendigkeitService, naechsteIstZustaendigkeit)) {
                throw new InvalidOperationException(
                    $"User {user.Id} cannot perform Schritt {walker.CurrentSchritt.Id} in Ausfuehrung {walker.Ausfuehrung.Id}");
            }

            var schritt = walker.CurrentSchritt;
            walker.Step(user.Id, bearbeitung.NextVerbindungId, bearbeitung.SlotValues, naechsteIstZustaendigkeit);

            var neueBearbeitung = walker.Ausfuehrung.Bearbeitungen.Last();
            if (schritt is NachrichtSchritt &&
                NachrichtSchritt.NachrichtFrom(neueBearbeitung) is { } nachricht &&
                nachricht.Length > prozessOptions.NachrichtMaxLength) {
                throw new NachrichtTooLongException(prozessOptions.NachrichtMaxLength);
            }

            performedSteps.Add((schritt, neueBearbeitung));
        }

        return performedSteps;
    }


    /// <summary>
    /// Sendet eine Push-Benachrichtigung für einen Mangels.
    /// </summary>
    private static async Task NotifyMangel(IFirebasePushMessagingService firebasePush, string environment,
        Guid ausfuehrungId, string title, string? description) {
        await firebasePush.TrySendAsync(new Message {
            Android = new AndroidConfig { Priority = Priority.High },
            Topic = new PushTopic.Mangel(environment, ausfuehrungId).ToString(),
            Data = new Dictionary<string, string> { { "type", "mangel" }, { "id", ausfuehrungId.ToString() }, },
            Notification = new() {
                Title = title ?? "Neue Informationen!",
                Body = description ?? "Es gibt neue Informationen zu einem Mangel, dem Sie folgen."
            }
        }, $"Statusänderung für Mangel {ausfuehrungId}");
    }

    /// <summary>
    /// Sendet eine Push-Benachrichtigung für eine Ausführung.
    /// </summary>
    private static async Task NotifyAusfuehrung(IFirebasePushMessagingService firebasePush, string environment,
        Guid ausfuehrungId, string title, string? description) {
        await firebasePush.TrySendAsync(new Message {
            Android = new AndroidConfig { Priority = Priority.High },
            Topic = new PushTopic.Ausfuehrung(environment, ausfuehrungId).ToString(),
            Data = new Dictionary<string, string> { { "type", "ausfuehrung" }, { "id", ausfuehrungId.ToString() }, },
            Notification = new() {
                Title = title ?? "Neue Informationen!",
                Body = description ?? "Es gibt neue Informationen zu ihrem Antrag."
            }
        }, $"Statusänderung für {ausfuehrungId}");
    }

    /// <summary>
    /// Prüft, ob der Benutzer den aktuellen Schritt in der Ausführung ausführen darf.
    /// </summary>
    private static async Task<bool> UserCanPerformSchritt(Ausfuehrung ausfuehrung, Schritt schritt, User user,
        AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        Zustaendigkeit? naechsteIstZustaendigkeit
    ) {
        if (user is Buerger && schritt.ErledigungDurchBuerger && ausfuehrung.UserId == user.Id &&
            naechsteIstZustaendigkeit is null) {
            return true;
        }

        // Nobody can log in as the SystemUser, so this branch is reachable only from AusfuehrungCreateAnonym.
        if (user is SystemUser && ausfuehrung.CorrelationId is not null && ausfuehrung.UserId == user.Id &&
            schritt.ErledigungDurchBuerger && naechsteIstZustaendigkeit is null) {
            return true;
        }

        if (user is not BackofficeUser backofficeUser) return false;

        return await ausfuehrungZustaendigkeitService.IstZustaendigFuerAusfuehrung(backofficeUser, ausfuehrung);
    }

    /// <summary>
    /// Eingabedaten für eine Bearbeitung eines Schritts in einer Ausführung.
    /// </summary>
    public record AusfuehrungBearbeitungInput(
        Guid SchrittId,
        IReadOnlyList<SlotValuesInput> SlotValues,
        Guid NextVerbindungId);

    /// <summary>
    /// Ergebnis einer Ausführungsoperation mit dem Ausführungsobjekt und der Information, ob weitere Schritte möglich sind.
    /// </summary>
    public record AusfuehrungResult(Ausfuehrung Ausfuehrung, bool ShouldContinue);

    private class BearbeitungNotFoundException : Exception;

    private class SlotValueNotFoundException : Exception;

    /// <summary>
    /// Ausnahme bei nicht übereinstimmender Kommune.
    /// </summary>
    public class MismatchingKommuneException : Exception;
}

public class NachrichtRequiredException()
    : DomainException("Bitte geben Sie eine Nachricht an die antragstellende Person ein.");

/// <summary>
/// Empfängerarten für die Weiterleitung eines Antrags.
/// </summary>
public enum WeiterleitungEmpfaenger {
    Intern,
    Extern
}

/// <summary>
/// Arten der Weiterleitung eines Antrags.
/// </summary>
public enum WeiterleitungArt {
    Kopieren,
    Schliessen
}
