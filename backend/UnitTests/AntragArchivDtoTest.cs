using API.Features.Aufbewahrung.Archive;
using API.Features.GovManager;
using API.Features.PmPayment;
using API.Features.Prozess;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Deckt das Datenverlust-Review-Feedback von Loic Ishimwe (MR 324) ab: <see cref="AntragArchivierungJob"/>
/// entfernt Ausführungen per <c>db.Ausfuehrungen.Remove()</c>, was per Cascade-Delete auch
/// VerlaufsEintraege/PaymentRequests/GovManagerRequests löscht. Reiner Unit-Test ohne DB - prüft nur,
/// dass <see cref="AntragArchivDto.From"/> diese drei Typen tatsächlich mit ins Archiv übernimmt.
/// </summary>
public class AntragArchivDtoTest {
    [Fact]
    public void From_uebernimmt_VerlaufsEintraege_PaymentRequests_und_GovManagerRequests() {
        var ausfuehrungId = Guid.NewGuid();
        var ausfuehrung = new Ausfuehrung {
            Id = ausfuehrungId,
            ProzessVersionId = Guid.NewGuid(),
            UserId = Guid.NewGuid(),
            CreatedAt = Instant.FromUtc(2026, 1, 1, 0, 0),
            Status = AusfuehrungStatus.Abgeschlossen,
            SharedKeyEncryptedForBuerger = "buerger-key",
            SharedKeyEncryptedForKommune = "kommune-key",
            Bearbeitungen = [],
        };

        var verlaufsEintrag = new VerlaufsEintrag {
            Id = Guid.NewGuid(),
            AusfuehrungId = ausfuehrungId,
            CreatedAt = Instant.FromUtc(2026, 1, 2, 0, 0),
            Art = VerlaufsEreignisArt.Uebernahme,
            BenutzerId = Guid.NewGuid(),
            BenutzerName = "Max Mustermann",
        };

        var paymentRequest = new PaymentRequest {
            Id = Guid.NewGuid(),
            AusfuehrungId = ausfuehrungId,
            BezahlenSchrittId = Guid.NewGuid(),
            CreatedAt = new DateTimeOffset(2026, 1, 3, 0, 0, 0, TimeSpan.Zero),
            CompletedAt = new DateTimeOffset(2026, 1, 3, 1, 0, 0, TimeSpan.Zero),
            Success = true,
            PaymentMethod = "creditcard",
        };

        var govManagerRequest = new GovManagerRequest {
            Id = Guid.NewGuid(),
            AusfuehrungId = ausfuehrungId,
            GovManagerSchrittId = Guid.NewGuid(),
            CreatedAt = new DateTimeOffset(2026, 1, 4, 0, 0, 0, TimeSpan.Zero),
            Success = true,
            ResponseBody = "{\"status\":\"ok\"}",
        };

        var dto = AntragArchivDto.From(ausfuehrung, [verlaufsEintrag], [paymentRequest], [govManagerRequest]);

        var verlauf = Assert.Single(dto.VerlaufsEintraege);
        Assert.Equal(verlaufsEintrag.Id, verlauf.Id);
        Assert.Equal(VerlaufsEreignisArt.Uebernahme, verlauf.Art);
        Assert.Equal("Max Mustermann", verlauf.BenutzerName);

        var payment = Assert.Single(dto.PaymentRequests);
        Assert.Equal(paymentRequest.Id, payment.Id);
        Assert.Equal(paymentRequest.BezahlenSchrittId, payment.BezahlenSchrittId);
        Assert.True(payment.Success);
        Assert.Equal("creditcard", payment.PaymentMethod);

        var govManager = Assert.Single(dto.GovManagerRequests);
        Assert.Equal(govManagerRequest.Id, govManager.Id);
        Assert.Equal(govManagerRequest.GovManagerSchrittId, govManager.GovManagerSchrittId);
        Assert.Equal("{\"status\":\"ok\"}", govManager.ResponseBody);
    }
}
