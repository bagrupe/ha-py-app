using System.Text.Json;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Infrastructure;
using API.Seeders.LageHelfer;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Lage.Mutations;

public class EinheitNotFoundException()
    : DomainException("Die Einheit existiert nicht.");

public class EinheitGehoertNichtZurEinsatzleitungException()
    : DomainException("Die Einheit gehört nicht zur Einsatzleitung, die für die Meldung zuständig ist.");

public class EinheitNameVergebenException()
    : DomainException("Diese Einsatzleitung hat bereits eine Einheit mit diesem Namen.");

public class EinheitNameErforderlichException()
    : DomainException("Bitte einen Namen für die Einheit angeben.");

public class MitarbeiterGruppeNotFoundException()
    : DomainException("Die Einsatzleitung (Mitarbeitergruppe) existiert nicht.");

public class MeldungInKlaerungException()
    : DomainException("Die Meldung liegt zur Klärung bei der Leitstelle.");

public class MeldungAktionNichtMoeglichException()
    : DomainException("Diese Aktion ist für die Meldung in ihrem aktuellen Stand nicht möglich.");

[GraphQLDescription("Schritt, den die Einsatzleitung an einer Meldung im Prozess geht.")]
public enum MeldungAktion {
    [GraphQLDescription("Hilfe einleiten: Bürger:innen sehen \"Hilfe ist unterwegs\".")]
    HilfeEinleiten,

    [GraphQLDescription("Einsatz abschließen; leitet vorher Hilfe ein, falls das noch nicht geschehen ist.")]
    EinsatzAbschliessen,
}

[GraphQLDescription("Ergebnis einer Bestätigung (\"+1\").")]
public record MeldungBestaetigenResult(
    [property: GraphQLDescription("Anzahl der Bestätigungen der Meldung einschließlich dieser.")]
    int AnzahlBestaetigungen);

[MutationType]
public class LageMeldungMutations {
    [Authorize]
    [GraphQLDescription("Legt eine Einheit einer Einsatzleitung an.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MitarbeiterGruppeNotFoundException))]
    [Error(typeof(EinheitNameVergebenException))]
    [Error(typeof(EinheitNameErforderlichException))]
    public async Task<Einheit> CreateEinheit(DomainContext db, CurrentUserAccessor currentUserAccessor,
        string name, Guid mitarbeiterGruppeId, CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        EnsureLeitstelleOderMitglied(user, mitarbeiterGruppeId);
        var trimmed = string.IsNullOrWhiteSpace(name) ? throw new EinheitNameErforderlichException() : name.Trim();

        if (!await db.MitarbeiterGruppen.AnyAsync(g =>
                g.Id == mitarbeiterGruppeId && g.KommuneId == user.KommuneId && !g.IsDeleted, ct)) {
            throw new MitarbeiterGruppeNotFoundException();
        }
        if (await db.Einheiten.AnyAsync(e => e.MitarbeiterGruppeId == mitarbeiterGruppeId && e.Name == trimmed, ct)) {
            throw new EinheitNameVergebenException();
        }

        var einheit = new Einheit { Id = Guid.NewGuid(), Name = trimmed, MitarbeiterGruppeId = mitarbeiterGruppeId };
        db.Einheiten.Add(einheit);
        await db.SaveChangesAsync(ct);
        return einheit;
    }

    [Authorize]
    [GraphQLDescription("Löscht eine Einheit. Ihre offenen Meldungen gehen zurück in den Eingang.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EinheitNotFoundException))]
    public async Task<Einheit> DeleteEinheit(DomainContext db, CurrentUserAccessor currentUserAccessor,
        Guid einheitId, CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var einheit = await db.Einheiten.AsTracking()
            .SingleOrDefaultAsync(e => e.Id == einheitId && e.MitarbeiterGruppe.KommuneId == user.KommuneId, ct)
            ?? throw new EinheitNotFoundException();
        EnsureLeitstelleOderMitglied(user, einheit.MitarbeiterGruppeId);

        db.Einheiten.Remove(einheit);
        await db.SaveChangesAsync(ct);
        return einheit;
    }

    [Authorize]
    [GraphQLDescription(
        "Weist eine Meldung einer Einheit der zuständigen Einsatzleitung zu. einheitId: null legt sie zurück in den " +
        "Eingang.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(MeldungInKlaerungException))]
    [Error(typeof(EinheitNotFoundException))]
    [Error(typeof(EinheitGehoertNichtZurEinsatzleitungException))]
    public async Task<Ausfuehrung> MeldungEinheitZuweisen(DomainContext db, CurrentUserAccessor currentUserAccessor,
        [Service] VorgangsverlaufService verlaufService, Guid ausfuehrungId, Guid? einheitId, CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var meldung = await LageMeldungen.TrackedOffeneMeldung(db, user, ausfuehrungId, nurLeitstelle: false, ct);
        if (meldung.KlaerungSeit is not null) throw new MeldungInKlaerungException();

        string ziel = "Eingang";
        if (einheitId is { } id) {
            var einheit = await db.Einheiten.SingleOrDefaultAsync(e => e.Id == id, ct)
                ?? throw new EinheitNotFoundException();
            if (einheit.MitarbeiterGruppeId != meldung.IstZustaendigkeit.MitarbeiterGruppeId) {
                throw new EinheitGehoertNichtZurEinsatzleitungException();
            }
            ziel = $"Einheit {einheit.Name}";
        }

        meldung.EinheitId = einheitId;
        verlaufService.RecordZustaendigkeitswechsel(db, meldung.Id, user, ziel);
        await db.SaveChangesAsync(ct);
        return meldung;
    }

    [Authorize]
    [GraphQLDescription(
        "Geht für die Einsatzleitung den nächsten Prozessschritt einer Meldung, ohne Formularwerte. So sehen " +
        "Bürger:innen den neuen Stand (\"Hilfe ist unterwegs\", \"Abgeschlossen\").")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(MeldungInKlaerungException))]
    [Error(typeof(MeldungAktionNichtMoeglichException))]
    public async Task<Ausfuehrung> MeldungFortsetzen(DomainContext db, CurrentUserAccessor currentUserAccessor,
        [Service] VorgangsverlaufService verlaufService, WalkerFactory walkerFactory, Guid ausfuehrungId,
        MeldungAktion aktion, CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var meldung = await LageMeldungen.TrackedOffeneMeldung(db, user, ausfuehrungId, nurLeitstelle: false, ct);
        if (meldung.KlaerungSeit is not null) throw new MeldungInKlaerungException();
        var alteZustaendigkeit = meldung.IstZustaendigkeit with { };

        await using (var walker = await walkerFactory.ContinueAusfuehrung(ausfuehrungId)) {
            var hilfeEinleiten = Verbindung(walker, EreignismeldungVorlage.VerbindungHilfeEinleiten);
            switch (aktion) {
                case MeldungAktion.HilfeEinleiten:
                    walker.Step(user.Id, (hilfeEinleiten ?? throw new MeldungAktionNichtMoeglichException()).Id, [],
                        null);
                    break;
                case MeldungAktion.EinsatzAbschliessen:
                    if (hilfeEinleiten is not null) {
                        walker.Step(user.Id, hilfeEinleiten.Id, [], null);
                    }
                    var abschliessen = Verbindung(walker, EreignismeldungVorlage.VerbindungEinsatzAbschliessen)
                        ?? throw new MeldungAktionNichtMoeglichException();
                    walker.Step(user.Id, abschliessen.Id, [], null);
                    break;
            }
            await walker.SaveChangesAsync();
        }

        var aktualisiert = await db.Ausfuehrungen.SingleAsync(a => a.Id == ausfuehrungId, ct);
        await verlaufService.ProtokolliereZustaendigkeitswechsel(db, aktualisiert, alteZustaendigkeit, user);
        await db.SaveChangesAsync(ct);
        return aktualisiert;
    }

    [Authorize]
    [GraphQLDescription(
        "Gibt eine Meldung an die Leitstelle ab, die die Einsatzleitung nicht bearbeiten kann (z. B. \"Kettensäge " +
        "fehlt\"). Der Kommentar ist Pflicht; die Einheit wird gelöst.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(MeldungInKlaerungException))]
    [Error(typeof(BegruendungErforderlichException))]
    public async Task<Ausfuehrung> MeldungAnLeitstelleAbgeben(DomainContext db,
        CurrentUserAccessor currentUserAccessor, IClock clock, [Service] VorgangsverlaufService verlaufService,
        Guid ausfuehrungId, string kommentar, CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var text = LageMeldungen.PflichtText(kommentar);
        var meldung = await LageMeldungen.TrackedOffeneMeldung(db, user, ausfuehrungId, nurLeitstelle: false, ct);
        if (meldung.KlaerungSeit is not null) throw new MeldungInKlaerungException();

        meldung.KlaerungSeit = clock.GetCurrentInstant();
        meldung.KlaerungKommentar = text;
        meldung.EinheitId = null;
        verlaufService.RecordZustaendigkeitswechsel(db, meldung.Id, user, $"Leitstelle (Klärung): {text}");
        await db.SaveChangesAsync(ct);
        return meldung;
    }

    [Authorize]
    [GraphQLDescription(
        "Nur Leitstelle: gibt eine Meldung einer anderen Einsatzleitung (Mitarbeitergruppe), etwa aus der Klärung " +
        "heraus. Löst Einheit, zugewiesene Person und Klärung.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(MitarbeiterGruppeNotFoundException))]
    public async Task<Ausfuehrung> MeldungUmverteilen(DomainContext db, CurrentUserAccessor currentUserAccessor,
        [Service] VorgangsverlaufService verlaufService, Guid ausfuehrungId, Guid mitarbeiterGruppeId,
        CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var meldung = await LageMeldungen.TrackedOffeneMeldung(db, user, ausfuehrungId, nurLeitstelle: true, ct);

        var lageUntereinheitId = await db.LageGebiete
            .Where(lg => lg.Id == meldung.LageGebietId)
            .Select(lg => lg.Lage.UntereinheitId)
            .SingleAsync(ct);
        var gruppe = await db.MitarbeiterGruppen
            .Where(g => g.Id == mitarbeiterGruppeId && g.KommuneId == user.KommuneId && !g.IsDeleted)
            .Select(g => new {
                OrganisationseinheitIds = g.Organisationseinheiten
                    .OrderByDescending(o => o.Id == lageUntereinheitId)
                    .Select(o => o.Id)
                    .ToList(),
            })
            .SingleOrDefaultAsync(ct);
        if (gruppe is null || gruppe.OrganisationseinheitIds.Count == 0) {
            throw new MitarbeiterGruppeNotFoundException();
        }

        var alteZustaendigkeit = meldung.IstZustaendigkeit with { };
        meldung.IstZustaendigkeit.Art = ZustaendigkeitArt.Organisationseinheit;
        meldung.IstZustaendigkeit.OrganisationseinheitId = gruppe.OrganisationseinheitIds[0];
        meldung.IstZustaendigkeit.MitarbeiterGruppeId = mitarbeiterGruppeId;
        meldung.IstZustaendigkeit.ZugewiesenePersonId = null;
        meldung.IstZustaendigkeit.DienstleisterId = null;
        meldung.EinheitId = null;
        meldung.KlaerungSeit = null;
        meldung.KlaerungKommentar = null;
        await verlaufService.ProtokolliereZustaendigkeitswechsel(db, meldung, alteZustaendigkeit, user);
        await db.SaveChangesAsync(ct);
        return meldung;
    }

    [Authorize]
    [GraphQLDescription(
        "Nur Leitstelle: schließt eine Meldung mit Pflicht-Begründung, ohne dass ein Einsatz stattfindet " +
        "(\"Verwerfen\", \"Schließen mit Begründung\"). Bürger:innen sehen \"Abgeschlossen\".")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(BegruendungErforderlichException))]
    public async Task<Ausfuehrung> MeldungVerwerfen(DomainContext db, CurrentUserAccessor currentUserAccessor,
        IClock clock, [Service] VorgangsverlaufService verlaufService, Guid ausfuehrungId, string begruendung,
        CancellationToken ct) {
        var user = await LageHelferUser(currentUserAccessor);
        var text = LageMeldungen.PflichtText(begruendung);
        var meldung = await LageMeldungen.TrackedOffeneMeldung(db, user, ausfuehrungId, nurLeitstelle: true, ct);

        var now = clock.GetCurrentInstant();
        meldung.VerwerfenGrund = text;
        meldung.Status = AusfuehrungStatus.Abgeschlossen;
        meldung.ManuellAbgeschlossen = now;
        meldung.AbgeschlossenAm = now;
        verlaufService.RecordAbschluss(db, meldung.Id, user);
        await db.SaveChangesAsync(ct);
        return meldung;
    }

    [AllowAnonymous]
    [GraphQLDescription(
        "\"+1 · Sehe ich auch\": bestätigt eine offene Meldung einer Lage, die gerade Meldungen annimmt, statt sie " +
        "doppelt zu melden. publicId stammt aus activeLagen.meldungen.id. Fotos wie im Slot \"bilder\", höchstens 3. " +
        "Ohne Anmeldung möglich.")]
    [Error(typeof(MeldungNotFoundException))]
    [Error(typeof(MeldungAbgeschlossenException))]
    [Error(typeof(LageGebietNotLiveException))]
    [Error(typeof(ZuVieleDateienException))]
    public async Task<MeldungBestaetigenResult> MeldungBestaetigen(DomainContext db, IClock clock, Guid publicId,
        JsonElement? fotos, CancellationToken ct) {
        var meldung = await db.Ausfuehrungen.NotDeleted()
            .Where(a => a.PublicId == publicId)
            .Select(a => new { a.Id, a.Status, PassStatus = a.LageGebiet!.Status, LageStatus = a.LageGebiet.Lage.Status })
            .SingleOrDefaultAsync(ct) ?? throw new MeldungNotFoundException();
        if (meldung.Status == AusfuehrungStatus.Abgeschlossen) throw new MeldungAbgeschlossenException();
        if (meldung.LageStatus == LageStatus.Closed || !LageGebietStateMachine.AcceptsMeldungen(meldung.PassStatus)) {
            throw new LageGebietNotLiveException();
        }

        var mitFotos = fotos is { ValueKind: not (JsonValueKind.Null or JsonValueKind.Undefined) } f ? f : (JsonElement?)null;
        if (mitFotos is { } liste &&
            (liste.ValueKind != JsonValueKind.Array || liste.GetArrayLength() > EreignismeldungVorlage.MaxFotos)) {
            throw new ZuVieleDateienException("Fotos", EreignismeldungVorlage.MaxFotos);
        }

        db.MeldungBestaetigungen.Add(new MeldungBestaetigung {
            Id = Guid.NewGuid(),
            AusfuehrungId = meldung.Id,
            CreatedAt = clock.GetCurrentInstant(),
            Fotos = mitFotos,
        });
        await db.SaveChangesAsync(ct);

        return new MeldungBestaetigenResult(
            await db.MeldungBestaetigungen.CountAsync(b => b.AusfuehrungId == meldung.Id, ct));
    }

    private static async Task<BackofficeUser> LageHelferUser(ICurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();
        return user;
    }

    private static void EnsureLeitstelleOderMitglied(BackofficeUser user, Guid mitarbeiterGruppeId) {
        if (!LageMeldungen.IstLeitstelle(user) && user.Gruppen.All(g => g.Id != mitarbeiterGruppeId)) {
            throw new NotAllowedException("Nur die Leitstelle oder die Einsatzleitung selbst kann ihre Einheiten pflegen.");
        }
    }

    private static Verbindung? Verbindung(Walker walker, string name) =>
        walker.CurrentVerbindungen.FirstOrDefault(v => v.Name == name);
}
