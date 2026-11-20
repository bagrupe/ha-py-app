using System.Linq.Expressions;
using API.Features.Aufbewahrung.Archive;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess;

/// <summary>Service zur Prüfung, ob ein Nutzer für eine Ausführung zuständig ist.</summary>
public class AusfuehrungZustaendigkeitService(
    FunktionsberechtigungenService funktionsberechtigungenService,
    IDbContextFactory<DomainContext> domainContextFactory
) {
    /// <summary>Zugriff hat der Antragsteller selbst oder ein zuständiger Backoffice-Nutzer.</summary>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    public async Task EnsureZugriffAufAusfuehrung(Ausfuehrung ausfuehrung, ICurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();

        if (user is Buerger buerger && buerger.Id == ausfuehrung.UserId) {
            return;
        }

        if (user is BackofficeUser backofficeUser) {
            var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
            berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
                .Fordern();
            if (await IstZustaendigFuerAusfuehrung(backofficeUser, ausfuehrung)) {
                return;
            }
        }

        throw new NotAllowedException();
    }

    /// <summary>
    /// Backoffice-Zugriff auf eine Ausführung: <see cref="BackofficeAntraege"/>-Berechtigung
    /// und Zuständigkeit nach <see cref="IstZustaendigFuerAusfuehrung"/> (ohne Bürger-Fallback).
    /// </summary>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff hat.</exception>
    public async Task EnsureBackofficeZugriffAufAusfuehrung(Ausfuehrung ausfuehrung, ICurrentUserAccessor currentUserAccessor) {
        var (backofficeUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();
        if (!await IstZustaendigFuerAusfuehrung(backofficeUser, ausfuehrung)) {
            throw new NotAllowedException();
        }
    }

    /// <summary>Ermittelt, ob der angegebene Nutzer für die gegebene Ausführung zuständig ist.</summary>
    /// <param name="user">Der Nutzer, dessen Zuständigkeit geprüft wird.</param>
    /// <param name="ausfuehrung">Die Ausführung, für die die Zuständigkeit geprüft wird.</param>
    /// <returns>True, wenn der Nutzer zuständig ist, sonst false.</returns>
    public async Task<bool> IstZustaendigFuerAusfuehrung(BackofficeUser user, Ausfuehrung ausfuehrung) {
        if (user.Art == BackofficeNutzerArt.Superadmin) {
            var kommuneId = ausfuehrung.ProzessVersion?.Prozess?.KommuneId;
            if (!kommuneId.HasValue) {
                await using var domainContext = await domainContextFactory.CreateDbContextAsync();
                kommuneId = await domainContext.ProzessVersionen
                    .Where(pv => pv.Id == ausfuehrung.ProzessVersionId)
                    .Select(pv => pv.Prozess.KommuneId)
                    .FirstAsync();
            }
            return user.KommuneId == kommuneId;
        }

        if (user.Art == BackofficeNutzerArt.Dienstleister || ausfuehrung.IstZustaendigkeit.Art == ZustaendigkeitArt.Dienstleister) {
            return user.DienstleisterId == ausfuehrung.IstZustaendigkeit.DienstleisterId;
        }

        var berechtigungen = await funktionsberechtigungenService.GetHelpers(user.Id);
        if (!berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)) {
            return false;
        }

        var organisationseinheitenIds = (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(user))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = user.Gruppen.Select(g => g.Id).ToList();

        return IsVisibleToUser(user.Id, organisationseinheitenIds, mitarbeiterGruppenIds)
            .Compile()(ausfuehrung);
    }

    /// <summary>
    /// Schränkt eine Live-Antragsliste auf die für den Nutzer sichtbaren Ausführungen ein
    /// (gleiche Regel wie <see cref="IstZustaendigFuerAusfuehrung"/>, EF-translatable).
    /// </summary>
    public IQueryable<Ausfuehrung> FilterSichtbareAusfuehrungen(
        IQueryable<Ausfuehrung> query,
        BackofficeUser user,
        IReadOnlyCollection<Guid> organisationseinheitenIds,
        IReadOnlyCollection<Guid> mitarbeiterGruppenIds) {
        if (user.Art == BackofficeNutzerArt.Superadmin) {
            return query;
        }

        if (user.Art == BackofficeNutzerArt.Dienstleister) {
            return query.Where(ausfuehrung =>
                ausfuehrung.IstZustaendigkeit.DienstleisterId != null &&
                user.DienstleisterId == ausfuehrung.IstZustaendigkeit.DienstleisterId.Value);
        }

        if (user.Art is BackofficeNutzerArt.Nutzer or BackofficeNutzerArt.Admin) {
            return query.Where(IsVisibleToUser(user.Id, organisationseinheitenIds, mitarbeiterGruppenIds));
        }

        return query.Where(_ => false);
    }

    private static Expression<Func<Ausfuehrung, bool>> IsVisibleToUser(
        Guid userId,
        IReadOnlyCollection<Guid> organisationseinheitenIds,
        IReadOnlyCollection<Guid> mitarbeiterGruppenIds) =>
        ausfuehrung => ausfuehrung.IstZustaendigkeit.Art != ZustaendigkeitArt.Dienstleister && (
            ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId == userId
            || (ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId != null &&
                mitarbeiterGruppenIds.Contains(ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId.Value))
            || (ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId == null &&
                ausfuehrung.IstZustaendigkeit.OrganisationseinheitId != null &&
                organisationseinheitenIds.Contains(ausfuehrung.IstZustaendigkeit.OrganisationseinheitId.Value))
        );

    /// <summary>
    /// Schränkt archivierte Anträge auf den sichtbaren Zuständigkeitsbereich ein
    /// (gleiche Regel wie <see cref="FilterSichtbareAusfuehrungen"/>).
    /// </summary>
    public IQueryable<ArchivierterAntrag> FilterSichtbareArchivierteAntraege(
        IQueryable<ArchivierterAntrag> query,
        BackofficeUser user,
        IReadOnlyCollection<Guid> organisationseinheitenIds,
        IReadOnlyCollection<Guid> mitarbeiterGruppenIds) {
        if (user.Art == BackofficeNutzerArt.Superadmin) {
            return query;
        }

        if (user.Art == BackofficeNutzerArt.Dienstleister) {
            return query.Where(a =>
                a.ZustaendigkeitDienstleisterId != null &&
                a.ZustaendigkeitDienstleisterId == user.DienstleisterId);
        }

        if (user.Art is BackofficeNutzerArt.Nutzer or BackofficeNutzerArt.Admin) {
            return query.Where(a => a.ZustaendigkeitArt != ZustaendigkeitArt.Dienstleister && (
                a.ZustaendigkeitZugewiesenePersonId == user.Id
                || (a.ZustaendigkeitMitarbeiterGruppeId != null &&
                    mitarbeiterGruppenIds.Contains(a.ZustaendigkeitMitarbeiterGruppeId.Value))
                || (a.ZustaendigkeitMitarbeiterGruppeId == null &&
                    a.ZustaendigkeitOrganisationseinheitId != null &&
                    organisationseinheitenIds.Contains(a.ZustaendigkeitOrganisationseinheitId.Value))
            ));
        }

        return query.Where(_ => false);
    }
}
