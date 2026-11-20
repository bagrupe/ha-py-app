using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Features.PmPayment.Controller;

/// <summary>Controller zum Empfang und Verarbeiten von Zahlungsbenachrichtigungen.</summary>
[ApiController]
public class PmPaymentNotificationController : Microsoft.AspNetCore.Mvc.Controller {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;

    /// <summary>Initialisiert den Controller mit einer Datenbankkontextfabrik.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung von Datenbankkontexten.</param>
    public PmPaymentNotificationController(IDbContextFactory<DomainContext> dbContextFactory) {
        _dbContextFactory = dbContextFactory;
    }

    /// <summary>Verarbeitet eine Zahlungsbenachrichtigung und aktualisiert den Zahlungsstatus.</summary>
    /// <param name="notification">Die empfangene Zahlungsbenachrichtigung.</param>
    /// <returns>Ergebnis der Verarbeitung als IActionResult.</returns>
    [Route("api/[controller]")]
    [HttpGet]
    [HttpPost]
    public async Task<IActionResult> Index([FromBody] PmPaymentNotification notification) {
        await using var db = await _dbContextFactory.CreateDbContextAsync();

        if (!Guid.TryParse(notification.Txid, out var paymentRequestId)) {
            return BadRequest();
        }

        var paymentRequest = await db.PaymentRequests.AsTracking().FirstOrDefaultAsync(p => p.Id == paymentRequestId);

        if (paymentRequest is null) {
            return BadRequest();
        }

        paymentRequest.CompletedAt = DateTimeOffset.UtcNow;
        paymentRequest.Success = notification.Status == 1;
        paymentRequest.PaymentMethod = notification.PaymentMethod;

        await db.SaveChangesAsync();

        return Ok();
    }

    /// <summary>Repräsentiert eine Zahlungsbenachrichtigung mit relevanten Daten.</summary>
    /// <param name="Txid">Transaktions-ID der Zahlung.</param>
    /// <param name="Status">Status der Zahlung (1 = erfolgreich).</param>
    /// <param name="PaymentMethod">Verwendete Zahlungsmethode.</param>
    public record PmPaymentNotification(string Txid, int Status, [property: JsonPropertyName("payment_method")] string PaymentMethod);
}
