using System.Net.Mail;
using API.Features.Auth;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Features.EmailForwarder;
using API.Features.Kommune;
using API.Features.PdfGenerator;
using API.Utils;
using Microsoft.EntityFrameworkCore;
using DateTime = API.Utils.DateTime;

namespace API.Features.Prozess.Mutations;

/// <summary>Stellt Funktionen zum Weiterleiten von Ausführungen per E-Mail bereit.</summary>
public class AusfuehrungWeiterleitenService {

    private readonly EmailService _emailService;
    private readonly KommuneDesignService _kommuneDesignService;
    private readonly BlazorRenderer _blazorRenderer;
    private readonly GotenbergService _gotenberg;
    private readonly StaticMapService _staticMapService;

    /// <summary>Initialisiert den Service mit den benötigten Abhängigkeiten.</summary>
    public AusfuehrungWeiterleitenService(EmailService emailService,
        KommuneDesignService kommuneDesignService,
        BlazorRenderer blazorRenderer,
        GotenbergService gotenberg,
        StaticMapService staticMapService) {
        _emailService = emailService;
        _kommuneDesignService = kommuneDesignService;
        _blazorRenderer = blazorRenderer;
        _gotenberg = gotenberg;
        _staticMapService = staticMapService;
    }

    /// <summary>Renders the execution as a PDF and adds the email to the caller's outbox without saving.</summary>
    /// <param name="db">The caller's context in which the email is added.</param>
    /// <param name="ausfuehrung">The execution to forward, with the Zuständigkeit's navigations loaded.</param>
    /// <param name="empfaengerEmail">Die E-Mail-Adresse des Empfängers.</param>
    /// <param name="user">Der Benutzer, der die Weiterleitung initiiert.</param>
    /// <param name="prozess">Der zugehörige Prozess der Ausführung.</param>
    /// <param name="ct">Cancellation token for the rendering operation.</param>
    public async Task VersandAusfuehrung(DomainContext db, Ausfuehrung ausfuehrung, string empfaengerEmail,
        BackofficeUser user, Prozess prozess, CancellationToken ct) {
        var bearbeitungen = await db.Bearbeitungen
            .AsSplitQuery()
            .Where(b => b.AusfuehrungId == ausfuehrung.Id)
            .OrderBy(b => b.CreatedAt)
            .Include(b => b.Schritt)
            .ThenInclude(s => ((FormularSchritt)s).Felder.OrderBy(f => f.Order))
            .Include(b => b.User)
            .Include(b => b.SlotValues)
            .ToListAsync(ct);

        var (primaryColor, logoUrl) =
            await _kommuneDesignService.GetKommuneDesign(user.KommuneId);

        HttpResponseMessage pdf;
        try {
            var ausfuehrungHtml = await AusfuehrungHtml.AusfuehrungToHtml(ausfuehrung.Id, prozess.Name,
                PdfZustaendigkeit.FromLoaded(ausfuehrung.IstZustaendigkeit), bearbeitungen, _blazorRenderer,
                _staticMapService, primaryColor, logoUrl, ct);
            pdf = await _gotenberg.RenderToPdf(ausfuehrungHtml, GotenbergEndpoint.Chromium, ct);
        } catch (Exception e) when (e is not OperationCanceledException) {
            throw new AntragWeiterleitenException("Beim Generieren der PDF ist ein Fehler aufgetreten.", e);
        }

        using (pdf) {
            List<Attachment> attachments = [
                new(await pdf.Content.ReadAsStreamAsync(ct), "antrag.pdf", "application/pdf")
            ];
            attachments.AddRange(GetAttachmentsFromSlots(bearbeitungen));

            var (organisationseinheit, abteilung) =
                await ZustaendigkeitNames.Resolve(db, ausfuehrung.IstZustaendigkeit);

            await _emailService.AddMailToOutboxAsync<AntragWeiterleitenEmail, AntragWeiterleitenEmailText>(db,
                [empfaengerEmail],
                subject: $"Antrag Weiterleitung - {prozess.Name}",
                kommuneId: prozess.KommuneId,
                templateParams: new Dictionary<string, object> {
                    { nameof(AntragWeiterleitenEmail.AusfuehrungId), ausfuehrung.Id.ToString() },
                    { nameof(AntragWeiterleitenEmail.ProzessName), prozess.Name },
                    { nameof(AntragWeiterleitenEmail.Organisationseinheit), organisationseinheit },
                    { nameof(AntragWeiterleitenEmail.Abteilung), abteilung },
                    { nameof(AntragWeiterleitenEmail.Datum), DateTime.Today().ToString("dd.MM.yyyy", null) },
                },
                attachments: attachments);
        }
    }

    /// <summary>Erzeugt Anhänge aus den Slot-Werten der Bearbeitungen für die E-Mail.</summary>
    /// <param name="bearbeitungen">Die Bearbeitungen der Ausführung.</param>
    /// <returns>Eine Aufzählung von E-Mail-Anhängen.</returns>
    private static IEnumerable<Attachment> GetAttachmentsFromSlots(IEnumerable<Bearbeitung> bearbeitungen) {
        var i = 1;
        foreach (var bearbeitung in bearbeitungen) {
            if (bearbeitung.Schritt is not FormularSchritt formularSchritt) {
                continue;
            }

            foreach (var feld in formularSchritt.Felder) {
                var slotValue = bearbeitung.SlotValues.FirstOrDefault(sv => sv.SlotName == feld.SlotName);
                if (slotValue is not PlainSlotValue psv) continue;
                switch (feld) {
                    case UploadFormularFeld:
                        foreach (var file in psv.Value.EnumerateArray()) {
                            yield return ToAttachment(Convert.FromBase64String(file.ToString()), feld.SlotName, i++);
                        }

                        break;
                    case SignatureFormularFeld:
                        yield return ToAttachment(Convert.FromBase64String(psv.Value.ToString()), feld.SlotName, i++);
                        break;
                }
            }
        }
    }

    private static Attachment ToAttachment(byte[] bytes, string slotName, int index) {
        var (extension, mediaType) = DetectFileType(bytes);
        return new Attachment(new MemoryStream(bytes), $"{index}-{slotName}.{extension}", mediaType);
    }

    private static (string Extension, string MediaType) DetectFileType(ReadOnlySpan<byte> bytes) {
        if (bytes.StartsWith("%PDF"u8)) return ("pdf", "application/pdf");
        if (bytes.StartsWith<byte>([0x89, 0x50, 0x4E, 0x47])) return ("png", "image/png");
        if (bytes.StartsWith<byte>([0xFF, 0xD8, 0xFF])) return ("jpg", "image/jpeg");
        return ("bin", "application/octet-stream");
    }
}
