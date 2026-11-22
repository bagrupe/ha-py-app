using API.Features;
using API.Features.Lage;
using API.Features.Prozess;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class StatusModel(DomainContext db) : LagehelferPageModel {
    public MeldungStatus Status { get; private set; }
    public Guid MeldungId { get; private set; }
    public string? LageTitel { get; private set; }
    public string? Gebiet { get; private set; }
    public string? Beschreibung { get; private set; }
    public string GemeldetUm { get; private set; } = "";
    public int? Nummer { get; private set; }

    public async Task<IActionResult> OnGetAsync(Guid id, CancellationToken ct) {
        var meldung = await LageMeldungen.OfKommune(db, KommuneId)
            .Where(a => a.PublicId == id)
            .Select(a => new {
                a.Id, a.Meldungsnummer, a.CreatedAt,
                LageTitel = a.LageGebiet!.Lage.Title,
                Gebiet = a.LageGebiet.Gebiet.Name
            }).SingleOrDefaultAsync(ct);
        if (meldung is null) return NotFound();
        Nummer = meldung.Meldungsnummer;
        var status = await MeldungStatusErmittlung.Ermittle(db, [meldung.Id], ct);
        Status = status[meldung.Id];
        MeldungId = id;
        LageTitel = meldung.LageTitel;
        Gebiet = meldung.Gebiet;
        GemeldetUm = meldung.CreatedAt.InZone(DateTimeZoneProviders.Tzdb["Europe/Berlin"]).ToString("HH:mm", null);
        var beschreibung = await db.PlainSlotValues
            .Where(s => s.Bearbeitung.AusfuehrungId == meldung.Id && s.SlotName == OpenMeldungen.BeschreibungSlot)
            .OrderByDescending(s => s.Bearbeitung.CreatedAt)
            .Select(s => s.Value).FirstOrDefaultAsync(ct);
        Beschreibung = beschreibung.ValueKind == System.Text.Json.JsonValueKind.String ? beschreibung.GetString() : null;
        return Page();
    }
}
