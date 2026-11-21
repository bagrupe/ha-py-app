using System.ComponentModel.DataAnnotations;
using System.Globalization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class MeldenModel(MeldungService meldungService, ILogger<MeldenModel> logger) : PageModel {
    public const string AdresseLabel = "Wo ist es passiert?";
    public const string KategorieLabel = "Um welche Art von Ereignis handelt es sich?";
    public const string BeschreibungLabel = "Was ist passiert?";
    public const string ConfirmationKey = "LagehelferConfirmation";

    private const long MaxPhotoBytes = 15 * 1024 * 1024;

    [BindProperty]
    public MeldungInput Input { get; set; } = new();

    public MeldungFormular? Formular { get; private set; }

    public string? StatusMessage { get; private set; }

    public bool IsInvalid(string field) =>
        ModelState.TryGetValue($"{nameof(Input)}.{field}", out var entry) && entry.Errors.Count > 0;

    public async Task<IActionResult> OnGetAsync(CancellationToken ct) {
        if (!PrecheckPassed) return RedirectToPage("GefahrCheck");

        var formularLoaded = await LoadFormularAsync(ct);
        if (formularLoaded && !await HasActiveLagenAsync(ct)) return RedirectToPage("Index");

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(CancellationToken ct) {
        if (!PrecheckPassed) return RedirectToPage("GefahrCheck");
        if (!await LoadFormularAsync(ct)) return Page();
        if (!await HasActiveLagenAsync(ct)) return RedirectToPage("Index");

        if (Input.Kategorie is not null && Formular!.Kategorien.All(k => k.Key != Input.Kategorie)) {
            ModelState.AddModelError($"{nameof(Input)}.{nameof(Input.Kategorie)}", "unknown");
        }

        byte[]? photo = null;
        if (Input.Foto is { Length: > 0 } upload) {
            photo = upload.Length <= MaxPhotoBytes ? await FotoKompressor.CompressAsync(upload, ct) : null;
            if (photo is null) ModelState.AddModelError($"{nameof(Input)}.{nameof(Input.Foto)}", "unreadable");
        }

        if (!ModelState.IsValid) {
            StatusMessage = DescribeInvalidFields();
            return Page();
        }

        var meldung = new Meldung(
            Input.Kategorie!,
            Input.Adresse!.Trim(),
            Input.Beschreibung!.Trim(),
            ParseCoordinate(Input.Lat)!.Value,
            ParseCoordinate(Input.Lng)!.Value,
            photo);

        MeldungErgebnis ergebnis;
        try {
            ergebnis = await meldungService.SendAsync(Formular!, meldung, ct);
        } catch (Exception ex) when (ex is not OperationCanceledException) {
            logger.LogError(ex, "Lagehelfer-Meldung konnte nicht gesendet werden");
            StatusMessage = "Die Meldung konnte nicht gesendet werden. Bitte versuche es noch einmal.";
            return Page();
        }

        if (ergebnis.CorrelationId is not { } correlationId) {
            StatusMessage = ergebnis.Fehler == MeldungFehler.KeineLageAmStandort
                ? "An diesem Standort nimmt gerade keine Lage Meldungen an. Bitte wähle einen anderen Standort."
                : "Die Meldung wurde nicht angenommen. Bitte prüfe deine Angaben.";
            return Page();
        }

        TempData[ConfirmationKey] = $"Meldungs-Nr. {correlationId}";
        TempData.Remove(GefahrCheckModel.PrecheckPassedKey);
        return RedirectToPage("Danke");
    }

    private bool PrecheckPassed => TempData.Peek(GefahrCheckModel.PrecheckPassedKey) is true;

    private async Task<bool> HasActiveLagenAsync(CancellationToken ct) =>
        (await meldungService.LoadActiveLagenAsync(Formular!, ct)).Count > 0;

    private async Task<bool> LoadFormularAsync(CancellationToken ct) {
        Formular = await meldungService.LoadFormularAsync(ct);
        if (Formular is null) StatusMessage = "Der Lagehelfer nimmt gerade keine Meldungen entgegen.";
        return Formular is not null;
    }

    private string DescribeInvalidFields() {
        var problems = new List<string>();
        if (IsInvalid(nameof(Input.Adresse))) problems.Add(AdresseLabel);
        if (IsInvalid(nameof(Input.Kategorie))) problems.Add(KategorieLabel);
        if (IsInvalid(nameof(Input.Beschreibung))) problems.Add(BeschreibungLabel);

        var message = problems.Count > 0 ? "Bitte ausfüllen: " + string.Join(", ", problems) : null;
        if (HasMissingLocation) {
            message = (message is null ? "" : message + ". ") + "Bitte setze den Pin auf der Karte oder suche eine Adresse.";
        }
        if (IsInvalid(nameof(Input.Foto))) {
            message = (message is null ? "" : message + ". ") + "Das Bild konnte nicht gelesen werden. Bitte versuche ein anderes.";
        }
        return message ?? "Bitte prüfe deine Eingaben.";
    }

    public bool HasMissingLocation => IsInvalid(nameof(Input.Lat)) || IsInvalid(nameof(Input.Lng));

    private static double? ParseCoordinate(string? value) =>
        double.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out var parsed) ? parsed : null;

    public class MeldungInput {
        [Required]
        public string? Adresse { get; set; }

        [Required]
        public string? Kategorie { get; set; }

        [Required]
        public string? Beschreibung { get; set; }

        [Required, CoordinateFormat]
        public string? Lat { get; set; }

        [Required, CoordinateFormat]
        public string? Lng { get; set; }

        public string? StandortQuelle { get; set; }

        public IFormFile? Foto { get; set; }
    }

    private sealed class CoordinateFormatAttribute : ValidationAttribute {
        public override bool IsValid(object? value) => value is null || ParseCoordinate(value as string) is not null;
    }
}
