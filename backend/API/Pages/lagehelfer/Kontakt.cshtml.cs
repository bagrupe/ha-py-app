using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using API.Features;
using API.Features.Lage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class KontaktModel(DomainContext db, IClock clock) : LagehelferPageModel {
    [BindProperty(SupportsGet = true)] public Guid LageId { get; set; }
    [BindProperty(SupportsGet = true)] public Guid? MeldungId { get; set; }
    [BindProperty(SupportsGet = true)] public bool Rueckruf { get; set; }
    [BindProperty, Required, StringLength(40)] public string? Nummer { get; set; }
    [BindProperty] public Guid Vorgang { get; set; }
    public bool Gespeichert { get; private set; }

    public void OnGet() => Vorgang = Guid.NewGuid();

    public async Task<IActionResult> OnPostAsync(CancellationToken ct) {
        if (MeldungId is { } id) {
            var meldung = await LageMeldungen.OfKommune(db, KommuneId).Where(a => a.PublicId == id)
                .Select(a => new { a.LageGebiet!.LageId, a.CorrelationId }).SingleOrDefaultAsync(ct);
            if (meldung is null) return NotFound();
            if (!Rueckruf && !Equals(TempData.Peek(MeldenModel.ConfirmationKey), $"Meldungs-Nr. {meldung.CorrelationId}")) return BadRequest();
            LageId = meldung.LageId;
        } else if (!Rueckruf) return BadRequest();

        if (!(await LiveLageGebiete.OfKommune(db, KommuneId, ct)).Any(l => l.LageId == LageId)) return NotFound();
        var nummer = Regex.Replace(Nummer ?? "", @"[\s()/\-]", "");
        if (!ModelState.IsValid || !Regex.IsMatch(nummer, @"^\+?[0-9]{5,15}$") || Vorgang == Guid.Empty) {
            ModelState.AddModelError(nameof(Nummer), "Bitte geben Sie eine gültige Telefonnummer ein.");
            return Page();
        }
        var inserted = await db.Database.ExecuteSqlInterpolatedAsync($"""
            INSERT INTO "LageKontakte" ("Id", "LageId", "MeldungId", "Telefonnummer", "Rueckruf", "Erstellt")
            VALUES ({Vorgang}, {LageId}, {MeldungId}, {nummer}, {Rueckruf}, {clock.GetCurrentInstant()})
            ON CONFLICT ("Id") DO NOTHING
            """, ct);
        if (inserted == 0 && !await db.LageKontakte.AnyAsync(k => k.Id == Vorgang && k.LageId == LageId
                && k.MeldungId == MeldungId && k.Rueckruf == Rueckruf && k.Telefonnummer == nummer, ct)) {
            return BadRequest();
        }
        Gespeichert = true;
        return Page();
    }
}
