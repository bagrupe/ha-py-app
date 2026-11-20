using System.Net.Http.Headers;
using MimeDetective;

namespace API.Features.GovManager;

/// <summary>Erzeugt Multipart-Formulardaten für den GovManager-Export mit Dateien und JSON-Daten.</summary>
public class GovManagerMultipartFormDataBuilder {
    /// <summary>Enthält die Dateien als Byte-Arrays mit Dateinamen als Schlüssel.</summary>
    public Dictionary<string, byte[]> Files { get; set; } = [];
    /// <summary>Enthält JSON-Daten als Strings mit Dateinamen als Schlüssel.</summary>
    public Dictionary<string, string> Json { get; set; } = [];

    /// <summary>Fügt eine Datei aus einem base64-kodierten String hinzu.</summary>
    /// <param name="fileBase64Encoded">Die Datei als base64-kodierter String.</param>
    public void AddFile(string fileBase64Encoded) {
        var byteArray = Convert.FromBase64String(fileBase64Encoded);
        var extension = GetExtension(byteArray);

        var fileName = $"anhang_{Files.Count}.{extension}";
        Files.Add(fileName, byteArray);
    }

    /// <summary>Fügt eine Antragsdatei als Byte-Array hinzu.</summary>
    /// <param name="fileBytes">Die Datei als Byte-Array.</param>
    public void AddAntrag(byte[] fileBytes) {
        var extension = GetExtension(fileBytes);

        var fileName = $"antrag.{extension}";
        Files.Add(fileName, fileBytes);
    }

    /// <summary>Fügt eine JSON-Daten-Datei hinzu.</summary>
    /// <param name="jsonString">Der JSON-Inhalt als String.</param>
    public void AddJson(string jsonString) {
        var fileName = $"daten.json";
        Json.Add(fileName, jsonString);
    }

    /// <summary>Ermittelt die Dateierweiterung anhand des Byte-Arrays.</summary>
    /// <param name="byteArray">Die Datei als Byte-Array.</param>
    /// <returns>Die Dateierweiterung ohne Punkt.</returns>
    private static string GetExtension(byte[] byteArray) {
        var inspector = new ContentInspectorBuilder { Definitions = MimeDetective.Definitions.Default.All() }.Build();
        var results = inspector.Inspect(byteArray);
        return results[0].Definition.File.Extensions[0];
    }

    /// <summary>Ermittelt den MIME-Typ anhand des Byte-Arrays.</summary>
    /// <param name="byteArray">Die Datei als Byte-Array.</param>
    /// <returns>Der MIME-Typ als String.</returns>
    private static string GetMimeType(byte[] byteArray) {
        var inspector = new ContentInspectorBuilder { Definitions = MimeDetective.Definitions.Default.All() }.Build();
        var results = inspector.Inspect(byteArray);
        return results[0].Definition.File.MimeType ?? "image/jpeg";
    }


    /// <summary>Erstellt den MultipartFormDataContent mit allen Dateien und JSON-Daten.</summary>
    /// <returns>Das zusammengesetzte MultipartFormDataContent-Objekt.</returns>
    public MultipartFormDataContent Build() {
        var content = Files.Aggregate(new MultipartFormDataContent(),
            (content, entry) => {
                var byteArrayContent = new ByteArrayContent(entry.Value);
                var mimeType = GetMimeType(entry.Value);
                byteArrayContent.Headers.ContentType = new MediaTypeHeaderValue(mimeType);
# if DEBUG
                content.Add(byteArrayContent, $"files_{content.Count()}", entry.Key);
# else
                content.Add(byteArrayContent, "files", entry.Key);
# endif
                return content;
            });

        var contentWithJson = Json.Aggregate(content,
            (aggregator, entry) => {
                var stringContent = new StringContent(entry.Value, new MediaTypeHeaderValue("application/json"));
                aggregator.Add(stringContent, "files", entry.Key);
                return aggregator;
            });

        return contentWithJson;
    }
}
