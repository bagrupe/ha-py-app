using System.Security.Cryptography;
using System.Text.Json;
using API.Features;
using API.Features.Lage;
using API.Features.Lage.Queries;
using API.Features.Prozess;
using API.Seeders.LageHelfer;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;

namespace API.Pages.lagehelfer;

public sealed record MeldungFormular(
    Guid KommuneId,
    Guid ProzessVersionId,
    Guid MeldungSchrittId,
    Guid ZurZuordnungVerbindungId,
    IReadOnlyList<(string Key, string Label)> Kategorien);

public sealed record Meldung(
    string Kategorie,
    string Adresse,
    string Beschreibung,
    double Lat,
    double Lng,
    IReadOnlyList<byte[]> Fotos);

public enum MeldungFehler {
    KeineLageAmStandort,
    Abgelehnt,
}

public sealed record MeldungErgebnis(Guid? CorrelationId, MeldungFehler? Fehler);

/// <summary>Reicht eine Bürgermeldung über den anonymen Ereignismeldung-Prozess ein.</summary>
public sealed class MeldungService(DomainContext db, IRequestExecutorResolver executorResolver) {
    private const string CreateAnonymMutation = """
        mutation CreateAnonym($input: AusfuehrungCreateAnonymInput!) {
          ausfuehrungCreateAnonym(input: $input) {
            anonymeAusfuehrungResult { correlationId }
            errors { __typename }
          }
        }
        """;

    public async Task<IReadOnlyList<PublicLage>> LoadActiveLagenAsync(Guid kommuneId, CancellationToken ct) =>
        await PublicLageQueries.GetActiveLagen(kommuneId, db, ct);

    public async Task<MeldungFormular?> LoadFormularAsync(Guid kommuneId, CancellationToken ct) {
        var version = await db.ProzessVersionen.AsSplitQuery()
            .Include(v => v.Prozess)
            .Include(v => v.Schritte).ThenInclude(s => s.Verbindungen)
            .Where(v => v.Prozess.KommuneId == kommuneId
                && v.PublishedAt != null
                && v.Prozess.DeaktiviertAm == null
                && v.Prozess.Tags.Any(t => t.Tag == AnonymeEinreichung.ProzessTagName)
                && v.Prozess.Tags.Any(t => t.Tag == AnonymeEinreichung.LageHelferTagName)
                && v.Start != null)
            .OrderByDescending(v => v.PublishedAt)
            .FirstOrDefaultAsync(ct);
        if (version?.StartId is not { } startId) return null;

        var meldung = version.Schritte.OfType<FormularSchritt>().FirstOrDefault(s => s.Id == startId);
        var zurZuordnung = meldung?.Verbindungen.FirstOrDefault();
        if (meldung is null || zurZuordnung is null) return null;

        var kategorien = meldung.Felder.OfType<StringFormularFeld>()
            .FirstOrDefault(f => f.SlotName == EreignismeldungVorlage.KategorieSlot)?
            .Options.Where(o => !string.Equals(o.Value, "Großbrand", StringComparison.OrdinalIgnoreCase))
            .Select(o => (o.Key, o.Value)).ToList();
        if (kategorien is null or { Count: 0 }) return null;

        return new MeldungFormular(version.Prozess.KommuneId, version.Id, meldung.Id, zurZuordnung.Id, kategorien);
    }

    public async Task<MeldungErgebnis> SendAsync(MeldungFormular formular, Meldung meldung, CancellationToken ct, Guid? lageId = null) {
        var vorschlaege = await PublicLageQueries.GetSuggestedGebiete(formular.KommuneId, meldung.Lng, meldung.Lat, db, ct);
        var lage = vorschlaege.FirstOrDefault(v => lageId == null || v.LageId == lageId);
        if (lage is null) return new MeldungErgebnis(null, MeldungFehler.KeineLageAmStandort);

        var publicKey = await db.Kommunen.Where(k => k.Id == formular.KommuneId).Select(k => k.PublicKey)
            .SingleAsync(ct);

        var standort = new { addressString = meldung.Adresse, coordinates = new[] { meldung.Lng, meldung.Lat } };
        var meldungSlots = new List<Dictionary<string, object?>> {
            Slot(EreignismeldungVorlage.StandortSlot, standort),
            Slot(EreignismeldungVorlage.KategorieSlot, meldung.Kategorie),
            Slot(EreignismeldungVorlage.BeschreibungSlot, meldung.Beschreibung),
        };
        if (meldung.Fotos.Count > 0) {
            meldungSlots.Add(Slot(EreignismeldungVorlage.BilderSlot, meldung.Fotos.Select(photo => Convert.ToBase64String(photo)).ToArray()));
        }

        var input = new Dictionary<string, object?> {
            ["prozessVersionId"] = formular.ProzessVersionId,
            ["sharedKeyEncryptedForKommune"] = WrapNewSharedKey(publicKey),
            ["lage"] = new Dictionary<string, object?> { ["lageId"] = lage.LageId, ["gebietId"] = lage.GebietId },
            ["bearbeitungen"] = new[] {
                Bearbeitung(formular.MeldungSchrittId, formular.ZurZuordnungVerbindungId, meldungSlots),
            },
        };

        var executor = await executorResolver.GetRequestExecutorAsync(cancellationToken: ct);
        var request = QueryRequestBuilder.New()
            .SetQuery(CreateAnonymMutation)
            .SetVariableValue("input", input)
            .Create();

        await using var response = await executor.ExecuteAsync(request, ct);
        using var json = JsonDocument.Parse(response.ToJson());
        if (!json.RootElement.TryGetProperty("data", out var data) || data.ValueKind != JsonValueKind.Object
            || data.GetProperty("ausfuehrungCreateAnonym") is not { ValueKind: JsonValueKind.Object } payload) {
            throw new InvalidOperationException("ausfuehrungCreateAnonym fehlgeschlagen: " + json.RootElement);
        }

        if (payload.TryGetProperty("anonymeAusfuehrungResult", out var result) && result.ValueKind == JsonValueKind.Object) {
            return new MeldungErgebnis(result.GetProperty("correlationId").GetGuid(), null);
        }

        var errorTypes = payload.GetProperty("errors").EnumerateArray()
            .Select(e => e.GetProperty("__typename").GetString()).ToList();
        return new MeldungErgebnis(null, errorTypes.Any(t => t is "LageErforderlichError" or "LageGebietNotLiveError")
            ? MeldungFehler.KeineLageAmStandort
            : MeldungFehler.Abgelehnt);
    }

    private static string WrapNewSharedKey(string? kommunePublicKey) {
        using var rsa = RSA.Create();
        rsa.ImportSubjectPublicKeyInfo(Convert.FromBase64String(kommunePublicKey
            ?? throw new InvalidOperationException("Die Kommune hat keinen öffentlichen Schlüssel.")), out _);
        return Convert.ToBase64String(rsa.Encrypt(RandomNumberGenerator.GetBytes(32), RSAEncryptionPadding.OaepSHA512));
    }

    private static Dictionary<string, object?> Bearbeitung(Guid schrittId, Guid verbindungId,
        List<Dictionary<string, object?>> slots) => new() {
        ["schrittId"] = schrittId,
        ["nextVerbindungId"] = verbindungId,
        ["slotValues"] = slots,
    };

    private static Dictionary<string, object?> Slot(string name, object value) => new() {
        ["name"] = name,
        ["value"] = new Dictionary<string, object?> { ["plainValue"] = JsonSerializer.SerializeToElement(value) },
    };
}
