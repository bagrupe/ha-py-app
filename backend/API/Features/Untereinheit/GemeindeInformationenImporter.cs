using Microsoft.EntityFrameworkCore;

namespace API.Features.Untereinheit;

/// <summary>Importiert Gemeindeinformationen aus externen Quellen und speichert sie in der Datenbank.</summary>
public class GemeindeInformationenImporter {
    private static List<string> _blacklistedPrefixes = ["Region", "Landkreis", "Stadt", "Gemeinde"];

    private HttpClient _httpClient;
    private IDbContextFactory<DomainContext> _dbContextFactory;
    private ILogger<GemeindeInformationenImporter> _logger;

    /// <summary>Initialisiert eine neue Instanz des Importers mit den benötigten Abhängigkeiten.</summary>
    public GemeindeInformationenImporter(IHttpClientFactory httpClientFactory, IDbContextFactory<DomainContext> dbContextFactory, ILogger<GemeindeInformationenImporter> logger) {
        _httpClient = httpClientFactory.CreateClient();
        _dbContextFactory = dbContextFactory;
        _logger = logger;
    }

    /// <summary>Importiert Gemeindeinformationen für alle Kommunen und speichert neue Gemeinden in der Datenbank.</summary>
    public async Task ImportGemeindeInformationen() {
        await using var db = await _dbContextFactory.CreateDbContextAsync();

        var kommunen = await db.Kommunen.ToListAsync();
        var kommuneInfos = await Task.WhenAll(kommunen.Select(async k => new { k.Id, Gemeinden = await ImportGemeinden(k.Name) }));

        var knownGemeinden = await db.Untereinheit.Where(u => u.IsGemeinde).ToListAsync();
        var knownGemeindeIds = knownGemeinden.Select(g => g.Id.ToString()).ToHashSet();

        foreach (var record in kommuneInfos) {
            _logger.LogInformation("Importing {GemeindeCount} gemeinde informationen for {KommuneId}", record.Gemeinden.Count(), record.Id);

            foreach (var gemeinde in record.Gemeinden) {
                if (knownGemeindeIds.Contains(gemeinde.Uuid)) continue;

                var untereinheitGemeinde = new Untereinheit {
                    Id = Guid.Parse(gemeinde.Uuid),
                    Name = gemeinde.Name,
                    KommuneId = record.Id,
                    IsGemeinde = true,
                    IsSyncedToBereichB = false,
                    Regionalschluessel = gemeinde.Ars.Ars
                };

                db.Untereinheit.Add(untereinheitGemeinde);
            }
        }

        await db.SaveChangesAsync();
    }

    /// <summary>Lädt und bereinigt Gemeindeinformationen anhand des Namens einer Kommune.</summary>
    /// <param name="name">Name der Kommune zur Suche der Gemeinden.</param>
    /// <returns>Eine Auflistung der geladenen Gemeindeinformationen.</returns>
    private async Task<IEnumerable<GemeindeInformationen>> ImportGemeinden(string name) {
        var sanitizedName = name.Trim();
        var blacklistedPrefix = _blacklistedPrefixes.FirstOrDefault(name.StartsWith);
        if (blacklistedPrefix is not null) {
            sanitizedName = name.Substring(blacklistedPrefix.Length).Trim();
        }

        var gemeinden = await _httpClient.GetFromJsonAsync<List<GemeindeInformationen>>($"https://gemeindeverzeichnis.govconnect.de/api/search/{sanitizedName}");
        if (gemeinden is null) {
            throw new Exception($"Failed to fetch gemeinden for name {sanitizedName}");
        }

        var uniqueResults = gemeinden.DistinctBy(g => g.Uuid).ToList();
        var uniqueGemeindeIds = uniqueResults.SelectMany(r => r.MunicipalityUuids ?? []).Distinct();

        var fetchedGemeinden = await Task.WhenAll(uniqueGemeindeIds.Select(FetchGemeinde));

        return fetchedGemeinden.OfType<GemeindeInformationen>();
    }

    /// <summary>Lädt detaillierte Informationen einer Gemeinde anhand ihrer UUID.</summary>
    /// <param name="uuid">Eindeutige Kennung der Gemeinde.</param>
    /// <returns>Die geladenen Gemeindeinformationen oder null, falls nicht gefunden.</returns>
    private async Task<GemeindeInformationen?> FetchGemeinde(string uuid) {
        var gemeinden = await _httpClient.GetFromJsonAsync<List<GemeindeInformationen>>($"https://gemeindeverzeichnis.govconnect.de/api/read/{uuid}");

        return gemeinden?.FirstOrDefault();
    }
}

/// <summary>Repräsentiert grundlegende Informationen einer Gemeinde.</summary>
/// <param name="Uuid">Eindeutige Kennung der Gemeinde.</param>
/// <param name="Name">Name der Gemeinde.</param>
/// <param name="CollectiveMunicipalityUuids">Liste von UUIDs übergeordneter Verwaltungsgemeinschaften.</param>
/// <param name="MunicipalityUuids">Liste von UUIDs zugehöriger Gemeinden.</param>
/// <param name="Ars">Regionaler Schlüssel der Gemeinde.</param>
record GemeindeInformationen(string Uuid, string Name, List<string>? CollectiveMunicipalityUuids, List<string>? MunicipalityUuids, GemeindeInformationenArs Ars);

/// <summary>Repräsentiert den regionalen Schlüssel einer Gemeinde.</summary>
/// <param name="Ars">Der regionale Schlüssel als String.</param>
record GemeindeInformationenArs(string Ars);
