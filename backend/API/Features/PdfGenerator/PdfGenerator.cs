using System.Net.Http.Headers;

namespace API.Features.PdfGenerator;

/// <summary>Ermöglicht das Erzeugen und Zusammenführen von PDF-Dokumenten über den Gotenberg-Dienst.</summary>
public class PdfGenerator(GotenbergService gotenberg) {
    /// <summary>Führt mehrere Dateien zu einem PDF zusammen.</summary>
    /// <param name="files">Liste der Dateien als Bytearrays.</param>
    /// <param name="fileName">Dateiname für die Debug-Ausgabe.</param>
    /// <returns>Das zusammengeführte PDF als Bytearray.</returns>
    public async Task<byte[]> Merge(List<byte[]> files, string fileName) {
        var multipartFormDataContent = new MultipartFormDataContent();
        multipartFormDataContent.Add(new StringContent("PDF/A-2b"), "pdfa");
        for (int i = 0; i < files.Count; i++) {
            var fileContent = new ByteArrayContent(files[i]);
            fileContent.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            multipartFormDataContent.Add(fileContent, "files", $"file{i + 1}.jpg");
            multipartFormDataContent.Add(new StringContent("true"), "merge");
        }

        var response = await gotenberg.RenderToPdf(multipartFormDataContent, GotenbergEndpoint.LibreOffice);

#if DEBUG
        await PrintDebugPdfToFilesSystem(fileName, response);
#endif

        return await response.Content.ReadAsByteArrayAsync();
    }

    /// <summary>Konvertiert HTML-Inhalte in ein PDF-Dokument.</summary>
    /// <param name="multipartFormDataContent">Die HTML- und zugehörigen Dateien als MultipartFormDataContent.</param>
    /// <param name="fileName">Dateiname für die Debug-Ausgabe.</param>
    /// <returns>Das erzeugte PDF als Bytearray.</returns>
    public async Task<byte[]> HtmlToPdf(MultipartFormDataContent multipartFormDataContent, string fileName) {
        multipartFormDataContent.Add(new StringContent("PDF/A-2b"), "pdfa");
        var response = await gotenberg.RenderToPdf(multipartFormDataContent, GotenbergEndpoint.Chromium);

#if DEBUG
        await PrintDebugPdfToFilesSystem(fileName, response);
#endif

        return await response.Content.ReadAsByteArrayAsync();
    }

    /// <summary>Konvertiert eine einzelne Datei in ein PDF-Dokument.</summary>
    /// <param name="file">Die Datei als Bytearray.</param>
    /// <param name="fileName">Dateiname für die Debug-Ausgabe.</param>
    /// <returns>Das erzeugte PDF als Bytearray.</returns>
    public async Task<byte[]> ConvertToPdf(byte[] file, string fileName) {
        var multipartFormDataContent = new MultipartFormDataContent();
        multipartFormDataContent.Add(new ByteArrayContent(file), "files", fileName);
        multipartFormDataContent.Add(new StringContent("PDF/A-2b"), "pdfa");
        var response = await gotenberg.RenderToPdf(multipartFormDataContent, GotenbergEndpoint.LibreOffice);

#if DEBUG
        await PrintDebugPdfToFilesSystem(fileName, response);
#endif

        return await response.Content.ReadAsByteArrayAsync();
    }

    /// <summary>Speichert die PDF-Antwort im Dateisystem zur Debug-Zwecken.</summary>
    /// <param name="fileName">Der Dateiname für die Speicherung.</param>
    /// <param name="response">Die HTTP-Antwort mit dem PDF-Inhalt.</param>
    private static async Task PrintDebugPdfToFilesSystem(string fileName, HttpResponseMessage response) {
        await using var responseStream = await response.Content.ReadAsStreamAsync();
        await using var fileStream = new FileStream(fileName, FileMode.Create, FileAccess.Write, FileShare.None);
        await responseStream.CopyToAsync(fileStream);
    }
}
