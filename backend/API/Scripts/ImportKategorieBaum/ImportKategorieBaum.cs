using System.Collections;
using API.Clients.BereichBClient;
using API.Features;
using API.Features.Auth;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Infrastructure;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using StrawberryShake;
using Path = System.IO.Path;

namespace API.Scripts.ImportKategorieBaum;

/**
 * Usage: dotnet run --project API import-kategorie-baum
 */
/// <summary>Importiert einen Kategoriebaum aus einer CSV-Datei und integriert ihn in eine neue Prozessversion.</summary>
public class ImportKategorieBaum {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly ILogger<ImportKategorieBaum> _logger;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly BereichBClient _bereichBClient;

    /// <summary>Initialisiert eine neue Instanz von <see cref="ImportKategorieBaum"/>.</summary>
    public ImportKategorieBaum(IDbContextFactory<DomainContext> dbContextFactory, ILogger<ImportKategorieBaum> logger, IPasswordHasher<User> passwordHasher, BereichBClient bereichBClient) {
        _dbContextFactory = dbContextFactory;
        _logger = logger;
        _passwordHasher = passwordHasher;
        _bereichBClient = bereichBClient;
    }

    /// <summary>Führt den Importprozess aus.</summary>
    /// <param name="args">Argumente aus der Kommandozeile.</param>
    public async Task Run(string[] args) {
        if (args is not [_, var path]) {
            path = Prompt("Path to CSV file");
        }

        var arguments = PromptArgs();

        await using var db = await _dbContextFactory.CreateDbContextAsync();

        _logger.LogInformation("Loading required information");
        var prozessVersion = await db.ProzessVersionen
            .AsSingleQuery()
            .Include(pv => pv.Schritte)
            .ThenInclude(s => s.Verbindungen)
            .SingleAsync(pv => pv.Id == arguments.ProzessVersionId);

        var kommuneId = await db.Prozesse.Where(p => p.Id == prozessVersion.ProzessId).Select(p => p.KommuneId).SingleAsync();

        var mitarbeiterGruppen = await db.MitarbeiterGruppen
            .AsTracking()
            .Where(mg => mg.KommuneId == kommuneId)
            .ToListAsync();

        _logger.LogInformation("Replacing Ids to create a new ProzessVersion");
        var changedIds = new Dictionary<Guid, Guid>();
        DeepUpdateIds(prozessVersion, changedIds);

        // Give the Schritte a second pass to update Verbindungen
        foreach (var schritt in prozessVersion.Schritte) {
            DeepUpdateIds(schritt, changedIds);
        }

        _logger.LogInformation("Importing CSV");
        var importer = new KategorieBaumImporter(path, kommuneId, mitarbeiterGruppen);

        var patchedSchritt = prozessVersion.Schritte.Single(s => s.Id == changedIds[arguments.PatchedSchrittId]);
        if (patchedSchritt is not FormularSchritt formularSchritt) {
            _logger.LogError("patched-schritt-id has to point to a FormularSchritt");
            Environment.Exit(1);
            return;
        }

        var vonSchritt = prozessVersion.Schritte.Single(s => s.Id == changedIds[arguments.VonSchrittId]);
        var nachSchritt = prozessVersion.Schritte.Single(s => s.Id == changedIds[arguments.NachSchrittId]);

        if (nachSchritt is not EndeSchritt endeSchritt) {
            _logger.LogError("nach-schritt-id has to point to an EndeSchritt");
            Environment.Exit(1);
            return;
        }

        _logger.LogInformation("Sneaking in imported Felder");
        var kategorienFeld = formularSchritt.Felder.Single(f => f.AngezeigterName == "Kategorie");
        formularSchritt.Felder.Remove(kategorienFeld);

        var importedFelder = importer.GetFelder(kategorienFeld.Order);
        var importedFelderMaxOrder = importedFelder.Max(f => f.Order);

        var shiftedFelder = formularSchritt.Felder.Where(f => f.Order > kategorienFeld.Order);

        foreach (var feld in shiftedFelder) {
            feld.GetType().GetProperty("Order")?.SetValue(feld, importedFelderMaxOrder + 1);
        }

        foreach (var feld in importedFelder) {
            formularSchritt.Felder.Add(feld);
        }

        vonSchritt.Verbindungen.Clear();

        _logger.LogInformation("Adding importierte Schritte");
        var (schritte, verbindungen) = importer.GetSchritte(vonSchritt, endeSchritt);

        foreach (var schritt in schritte) {
            prozessVersion.Schritte.Add(schritt);
        }

        _logger.LogInformation("Stripping unreachable Schritte");
        StripUnreachableSchritte(prozessVersion, verbindungen);

        var startId = prozessVersion.StartId;
        prozessVersion.StartId = null;
        prozessVersion.PublishedAt = SystemClock.Instance.GetCurrentInstant();
        prozessVersion.Beschreibungstext = new StringExpression("slot('_wurzel') + ': ' + slot('titel')");

        db.Verbindungen.AddRange(verbindungen);
        db.ProzessVersionen.Add(prozessVersion);

        var allmightyUser = await db.BackofficeUser.AsTracking().Include(u => u.Gruppen).FirstOrDefaultAsync(u => u.EMail == "maengel.test@example.com");
        if (allmightyUser == null) {
            allmightyUser = new BackofficeUser {
                KommuneId = kommuneId,
                Vorname = "Mängel",
                Nachname = "Test",
                EMail = "maengel.test@example.com",
                Art = BackofficeNutzerArt.Admin,
                Gruppen = [],
            };

            var seeds = new List<KommuneSeed> { KommuneSeeder.LandkreisHaPy };
            allmightyUser.SetOrganisationCryptoAndPassword("123456", seeds.Single(seed => seed.Id == kommuneId).KeyEncryptionKey, _passwordHasher);
            db.BackofficeUser.Add(allmightyUser);
        }

        allmightyUser.Gruppen.Clear();
        allmightyUser.Gruppen.AddRange(
            prozessVersion.Schritte.Select(s => s.SollZustaendigkeit?.MitarbeiterGruppe).OfType<MitarbeiterGruppe>().DistinctBy(mg => mg?.Id)
        );

        _logger.LogInformation("Persisting new ProzessVersion");
        await db.SaveChangesAsync();

        prozessVersion.StartId = startId;
        await db.SaveChangesAsync();

        await EnsureOrtslagenExists(path, kommuneId);

        _logger.LogInformation("Done!");
    }

    /// <summary>Stellt sicher, dass die Geofläche 'Ortslagen' für die Kommune existiert und legt sie bei Bedarf an.</summary>
    /// <param name="csvPath">Pfad zur CSV-Datei, um den GeoJSON-Pfad zu ermitteln.</param>
    /// <param name="kommuneId">ID der Kommune.</param>
    private async Task EnsureOrtslagenExists(string csvPath, Guid kommuneId) {
        _logger.LogInformation("Trying to create Geofläche Ortslagen for use in Verbindungen");

        var directory = Path.GetDirectoryName(csvPath);
        var geoJsonPath = Path.Join(directory, "ortslagen.geojson");

        if (!File.Exists(geoJsonPath)) {
            _logger.LogWarning("{geoJsonPath} not found; skipping creation of Geofläche 'Ortslagen' which may be required by some Verbindungen!", geoJsonPath);
            return;
        }

        var bereichBKommuneResult = await _bereichBClient.KommuneByBereichAId.ExecuteAsync(kommuneId.ToString());
        if (bereichBKommuneResult.IsErrorResult()) {
            _logger.LogError("Error fetching Kommune Bereich-B ID, aborting!");
            return;
        }

        var kommuneBereichBId = bereichBKommuneResult.Data!.KommuneByBereichAId!.Id;

        var geoJsonElement = await GeoJsonImporter.ImportGeoJson(geoJsonPath);

        var geoflaecheResult = await _bereichBClient.CreateGeoflaeche.ExecuteAsync(
            new mutationGeoFlaechenInput {
                Name = "Ortslagen",
                Kommune = kommuneBereichBId,
                Geometry = geoJsonElement
            }
        );

        if (geoflaecheResult.IsErrorResult()) {
            _logger.LogError("Error creating the Geofläche entity, aborting!");
            return;
        }

        _logger.LogInformation("Geofläche Ortslagen created successfully!");
    }

    /// <summary>Entfernt Schritte aus der Prozessversion, die von der Start-ID aus nicht erreichbar sind.</summary>
    /// <param name="prozessVersion">Die Prozessversion, deren Schritte gefiltert werden.</param>
    /// <param name="verbindungen">Liste zusätzlicher Verbindungen, die berücksichtigt werden.</param>
    private static void StripUnreachableSchritte(ProzessVersion prozessVersion, List<Verbindung> verbindungen) {
        while (true) {
            var alteSchritte = prozessVersion.Schritte;

            var reachableSchritteIds = alteSchritte
                .SelectMany(s => s.Verbindungen)
                .Concat(verbindungen)
                .Select(v => v.NachId)
                .Append(prozessVersion.StartId!.Value)
                .ToHashSet();

            var neueSchritte = alteSchritte.Where(s => reachableSchritteIds.Contains(s.Id)).ToHashSet();

            if (alteSchritte.Count == neueSchritte.Count) break;

            prozessVersion.Schritte = neueSchritte;
        }
    }

    /// <summary>Fragt die notwendigen Import-Argumente vom Benutzer ab.</summary>
    /// <returns>Ein <see cref="ImportArguments"/>-Objekt mit den eingegebenen IDs.</returns>
    private ImportArguments PromptArgs() {
        var pvIdString = Prompt("Prozessversion-ID");
        var patchedSchrittIdString = Prompt("Patched-Schritt-ID");
        var vonSchrittIdString = Prompt("Von-Schritt-ID");
        var nachSchittIdString = Prompt("Nach-Schritt-ID");

        var pvId = Guid.Parse(pvIdString);
        var patchedSchrittId = Guid.Parse(patchedSchrittIdString);
        var vonSchrittId = Guid.Parse(vonSchrittIdString);
        var nachSchrittId = Guid.Parse(nachSchittIdString);

        return new ImportArguments(pvId, patchedSchrittId, vonSchrittId, nachSchrittId);
    }

    /**
     * Sets an Id through reflection on the field directly.
     *
     * If the Id is already known to be a replacement, it's ignored.
     * If the Id to be replaced is already known from another replacement, it's replaced with the same value.
     */
    /// <summary>Setzt eine neue Id per Reflection, sofern noch keine neue Id zugeordnet wurde.</summary>
    /// <param name="o">Das Objekt, dessen Id gesetzt werden soll.</param>
    /// <param name="updatedIds">Dictionary mit alten und neuen Ids zur Nachverfolgung.</param>
    private void SetNewId(object o, Dictionary<Guid, Guid> updatedIds) {
        var idProp = o.GetType().GetProperty("Id");
        if (idProp == null) return /* true */;

        var oldId = (Guid)idProp.GetValue(o)!;

        // After updating the now currentId was previously set as Value to the dict. Not using Key here is intended.
        if (updatedIds.ContainsValue(oldId)) return /* false */;

        if (updatedIds.TryGetValue(oldId, out var knownNewId)) {
            idProp.SetValue(o, knownNewId);
            return /* true */;
        }

        var newId = Guid.NewGuid();
        idProp.SetValue(o, newId);
        updatedIds[oldId] = newId;

        /* return true */
    }

    // TODO replace the depth with return from SetNewId and allowing GuidProperty loop write to updatedIds
    /// <summary>Aktualisiert rekursiv alle relevanten Ids in einem Objektgraphen.</summary>
    /// <param name="o">Das zu aktualisierende Objekt.</param>
    /// <param name="updatedIds">Dictionary mit alten und neuen Ids.</param>
    /// <param name="depth">Maximale Rekursionstiefe.</param>
    private void DeepUpdateIds(Object o, Dictionary<Guid, Guid> updatedIds, int depth = 5) {
        if (depth == 0) return;

        SetNewId(o, updatedIds);
        var properties = o.GetType().GetProperties();

        List<Type> whitelistedTypes = [typeof(ProzessVersion), typeof(Schritt), typeof(Verbindung), typeof(FormularFeld)];

        var idUpdateRequiredProps = properties.Where(
            p => whitelistedTypes.Any(t => p.PropertyType.IsAssignableTo(t)
                                           || p.PropertyType.IsAssignableTo(typeof(IEnumerable<>).MakeGenericType(t)))
        );

        foreach (var prop in idUpdateRequiredProps) {
            var propValue = prop.GetValue(o);
            if (propValue == null) {
                _logger.LogDebug("Property {Property} of Object {Object} is null!", prop.Name, o.GetType().Name);
                continue;
            }

            if (propValue.GetType().IsAssignableTo(typeof(IEnumerable))) {
                var propEnumerable = (IEnumerable)propValue;
                _logger.LogDebug("Iterating over elements of prop {Property}", prop.Name);
                foreach (var enumeratedProp in propEnumerable) {
                    DeepUpdateIds(enumeratedProp, updatedIds, depth - 1);
                }
            } else {
                DeepUpdateIds(propValue, updatedIds, depth - 1);
            }
        }

        var guidProperties = properties.Where(p => p.PropertyType == typeof(Guid) || p.PropertyType == typeof(Guid?));

        foreach (var guidProperty in guidProperties) {
            if (guidProperty.Name == "Id") continue;

            _logger.LogDebug("Updating property {Property}", guidProperty.Name);

            var guidPropertyValue = guidProperty.GetValue(o);
            if (guidPropertyValue is not Guid guid) continue;

            if (updatedIds.TryGetValue(guid, out var knownNewId)) {
                guidProperty.SetValue(o, knownNewId);
            }
        }
    }

    /// <summary>Fragt eine Eingabe vom Benutzer ab.</summary>
    /// <param name="prompt">Die Eingabeaufforderung.</param>
    /// <returns>Die eingegebene Zeichenkette.</returns>
    private static string Prompt(string prompt) {
        Console.Out.Write(prompt + ": ");
        return Console.ReadLine() ?? "";
    }
}

/// <summary>Argumente für den Importprozess.</summary>
/// <param name="ProzessVersionId">ID der Prozessversion.</param>
/// <param name="PatchedSchrittId">ID des zu patchenden Schritts.</param>
/// <param name="VonSchrittId">ID des Ausgangsschritts.</param>
/// <param name="NachSchrittId">ID des Endschritts.</param>
record ImportArguments(Guid ProzessVersionId, Guid PatchedSchrittId, Guid VonSchrittId, Guid NachSchrittId);
