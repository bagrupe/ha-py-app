using System.IdentityModel.Tokens.Jwt;
using API.Features.Aufbewahrung;
using API.Features.Ehrenamtsbank;
using API.Features.Prozess;
using API.Infrastructure;
using API.Options;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using NodaTime;

namespace API.Features.Auth.Mutations;

public record DeleteEhrenamtsbankAccountResult(Guid BuergerId, string Token);

public class BuergerAccountDeletionService(
    IClock clock,
    IPasswordHasher<User> passwordHasher,
    IOptions<EhrenamtsbankZeitkontoOptions> zeitkontoOptions,
    JWTOptions jwtOptions) {
    internal const string AntragLoeschgrund = "Ehrenamtsbank-Konto gelöscht";

    public async Task<DeleteEhrenamtsbankAccountResult> DeleteEhrenamtsbankAccountAsync(
        DomainContext db,
        Guid oldBuergerId,
        WeakLoginCredentials newCredentials,
        CancellationToken ct = default) {
        await using var transaction = await db.Database.BeginTransactionAsync(ct);

        var oldBuerger = await db.Buerger.AsTracking()
            .Include(b => b.GefolgteAusfuehrungen)
            .FirstAsync(b => b.Id == oldBuergerId, ct);

        if (!oldBuerger.IsRegistered) {
            throw new NotAllowedException("Nur registrierte Nutzer können ihr Ehrenamtsbank-Konto löschen.");
        }

        await ValidatePreconditionsAsync(db, oldBuergerId, ct);

        var now = clock.GetCurrentInstant();
        await SoftDeleteOwnEintraegeAsync(db, oldBuergerId, now, ct);
        await CleanupAnfragenAsInteressent(db, oldBuergerId, now, ct);
        await SoftDeleteAusfuehrungenAsync(db, oldBuergerId, now, ct);
        await ClearTransactionNotesAsync(db, oldBuergerId, ct);
        await DeleteAuthLinksAsync(db, oldBuergerId, ct);
        await RetireOldBuergerAsync(db, oldBuerger);

        var newBuerger = WeakBuergerRegistration.Create(passwordHasher, clock, newCredentials);
        db.Buerger.Add(newBuerger);
        await db.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);

        var token = new JwtSecurityTokenHandler().WriteToken(newBuerger.GetToken(jwtOptions));
        return new DeleteEhrenamtsbankAccountResult(newBuerger.Id, token);
    }

    private async Task ValidatePreconditionsAsync(DomainContext db, Guid buergerId, CancellationToken ct) {
        var options = zeitkontoOptions.Value;
        var balanceMinutes = await ZeitkontoBalanceCalculator.GetBalanceMinutesAsync(
            db, buergerId, options.StartCreditMinutes, ct);
        if (balanceMinutes < options.DeletionMinBalanceMinutes) {
            throw new NegativeZeitkontoSaldoException(balanceMinutes, options.DeletionMinBalanceMinutes);
        }

        var vereinbartCount = await CountVereinbarteAnfragenAsync(db, buergerId, ct);
        if (vereinbartCount > 0) {
            throw new VereinbarteAnfragenException(vereinbartCount);
        }

        var hasOffeneAusfuehrungen = await db.Ausfuehrungen
            .NotDeleted()
            .AnyAsync(a => a.UserId == buergerId && a.Status != AusfuehrungStatus.Abgeschlossen, ct);

        if (hasOffeneAusfuehrungen) {
            throw new OffeneAusfuehrungenException();
        }
    }

    private static async Task<int> CountVereinbarteAnfragenAsync(
        DomainContext db, Guid buergerId, CancellationToken ct) {
        var asInteressent = db.EhrenamtsbankAnfragen
            .Where(a => a.InteressentId == buergerId && a.Status == EhrenamtsbankAnfrageStatus.Vereinbart);
        var ownedEintragIds = db.EhrenamtsbankEintraege
            .Where(e => e.OwnerId == buergerId)
            .Select(e => e.Id);
        var asOwner = db.EhrenamtsbankAnfragen
            .Where(a => ownedEintragIds.Contains(a.EintragId)
                        && a.Status == EhrenamtsbankAnfrageStatus.Vereinbart);
        return await asInteressent.Union(asOwner).CountAsync(ct);
    }

    private static async Task SoftDeleteOwnEintraegeAsync(
        DomainContext db, Guid ownerId, Instant now, CancellationToken ct) {
        var eintraege = await db.EhrenamtsbankEintraege.AsTracking()
            .Where(e => e.OwnerId == ownerId && !e.IsDeleted)
            .ToListAsync(ct);
        foreach (var eintrag in eintraege) {
            eintrag.IsDeleted = true;
            eintrag.UpdatedAt = now;
            await RejectNonTerminalAnfragen(db, eintrag.Id, now, ct);
        }
    }

    private async Task SoftDeleteAusfuehrungenAsync(
        DomainContext db, Guid userId, Instant now, CancellationToken ct) {
        var ausfuehrungen = await db.Ausfuehrungen.AsTracking()
            .Include(a => a.ProzessVersion).ThenInclude(pv => pv.Prozess)
            .Where(a => a.UserId == userId && a.GeloeschtAm == null)
            .ToListAsync(ct);

        foreach (var ausfuehrung in ausfuehrungen) {
            ausfuehrung.GeloeschtAm = now;
            ausfuehrung.GeloeschtVonId = null;
            ausfuehrung.Loeschgrund = AntragLoeschgrund;

            db.AntragLoeschProtokolle.Add(new AntragLoeschProtokoll {
                AusfuehrungId = ausfuehrung.Id,
                KommuneId = ausfuehrung.ProzessVersion.Prozess.KommuneId,
                Ereignis = AntragLoeschEreignis.SoftGeloescht,
                Grund = AntragLoeschgrund,
                Zeitpunkt = now,
            });
        }
    }

    private static async Task ClearTransactionNotesAsync(DomainContext db, Guid buergerId, CancellationToken ct) {
        await db.EhrenamtsbankTransaktionen
            .Where(t => (t.GiverId == buergerId || t.ReceiverId == buergerId) && t.Note != null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.Note, (string?)null), ct);
    }

    private static async Task DeleteAuthLinksAsync(DomainContext db, Guid buergerId, CancellationToken ct) {
        await db.ExternalIdentities
            .Where(e => e.BuergerId == buergerId)
            .ExecuteDeleteAsync(ct);
        await db.RefreshTokens
            .Where(t => t.BuergerId == buergerId)
            .ExecuteDeleteAsync(ct);
        await db.BuergerKeyEscrows
            .Where(e => e.BuergerId == buergerId)
            .ExecuteDeleteAsync(ct);
    }

    private async Task RetireOldBuergerAsync(DomainContext db, Buerger oldBuerger) {
        oldBuerger.IsDeleted = true;
        oldBuerger.Vorname = null;
        oldBuerger.Nachname = null;
        oldBuerger.EmailAddress = null;
        oldBuerger.Street = null;
        oldBuerger.PostalCode = null;
        oldBuerger.City = null;
        oldBuerger.Country = null;
        oldBuerger.Phone = null;
        oldBuerger.PhoneVerified = false;
        oldBuerger.IsRegistered = false;
        oldBuerger.RegisteredAt = null;
        oldBuerger.RequiresClearanceVerified = false;
        oldBuerger.BundIdDatenSyncedAt = null;
        oldBuerger.VerificationCode = null;
        oldBuerger.VerificationCodeValidUntil = null;
        oldBuerger.VerificationPhoneHash = null;
        oldBuerger.VerificationCodeRequestedAt = null;
        oldBuerger.VerificationCodeFailedAttempts = 0;
        oldBuerger.VerificationCodeLockedUntil = null;
        oldBuerger.PushNotificationTokens = [];
        oldBuerger.OrganisationseinheitIdsForNewsNotifications = [];
        oldBuerger.GefolgteAusfuehrungen.Clear();
        oldBuerger.PersonalData.Clear();
        await db.Set<BuergerPersonalData>().Where(d => d.BuergerId == oldBuerger.Id).ExecuteDeleteAsync();

        oldBuerger.PublicKey = null;
        oldBuerger.PersonalPrivateKey = null;
        oldBuerger.PersonalPrivateKeySalt = null;
        oldBuerger.PersonalDataKeyEncryptedForBuerger = "";
        oldBuerger.Password = passwordHasher.HashPassword(oldBuerger, Guid.NewGuid().ToString("N"));
    }

    private static async Task RejectNonTerminalAnfragen(
        DomainContext db, Guid eintragId, Instant now, CancellationToken ct) {
        var nonTerminalAnfragen = await db.EhrenamtsbankAnfragen.AsTracking()
            .Where(a => a.EintragId == eintragId && AnfrageStateMachine.NonTerminal.Contains(a.Status))
            .ToListAsync(ct);
        foreach (var anfrage in nonTerminalAnfragen) {
            anfrage.Status = EhrenamtsbankAnfrageStatus.Abgelehnt;
            anfrage.UpdatedAt = now;
            ClearPersonalInformation(anfrage);
        }
    }

    private static async Task CleanupAnfragenAsInteressent(
        DomainContext db, Guid interessentId, Instant now, CancellationToken ct) {
        var openStatuses = new[] {
            EhrenamtsbankAnfrageStatus.Offen,
            EhrenamtsbankAnfrageStatus.Akzeptiert,
        };
        var anfragen = await db.EhrenamtsbankAnfragen.AsTracking()
            .Where(a => a.InteressentId == interessentId)
            .ToListAsync(ct);
        foreach (var anfrage in anfragen) {
            if (openStatuses.Contains(anfrage.Status)) {
                anfrage.Status = EhrenamtsbankAnfrageStatus.Zurueckgezogen;
            }
            ClearPersonalInformation(anfrage);
            anfrage.UpdatedAt = now;
        }
    }

    private static void ClearPersonalInformation(EhrenamtsbankAnfrage anfrage) {
        anfrage.Nachricht = null;
        anfrage.ProposedNote = null;
    }
}
