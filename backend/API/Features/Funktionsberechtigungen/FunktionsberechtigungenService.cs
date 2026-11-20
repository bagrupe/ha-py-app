using System.Collections.Immutable;
using API.Features.Auth;
using API.Features.Auth.Queries;
using API.Features.Untereinheit;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Funktionsberechtigungen;

/// <summary>Service zur Verwaltung und Abfrage von Funktionsberechtigungen für Backoffice-Nutzer.</summary>
public class FunktionsberechtigungenService(
    IBackofficeUserByIdDataLoader usersById,
    IUntereinheitenPermissionsByUserIdDataLoader untereinheitPermissionsByUserId,
    IHttpContextAccessor httpContextAccessor,
    IDbContextFactory<DomainContext> dbContextFactory
) {
    /// <summary>Ermittelt Hilfsobjekte für Funktionsberechtigungen eines Nutzers anhand seiner ID.</summary>
    /// <param name="userId">Die ID des Backoffice-Nutzers.</param>
    /// <returns>Hilfsobjekt mit Berechtigungsinformationen des Nutzers.</returns>
    public async Task<BackofficeUserFunktionsberechtigungenHelpers> GetHelpers(Guid userId) {
        var isHttpRequest = httpContextAccessor.HttpContext is not null;
        BackofficeUser user;
        if (isHttpRequest) {
            user = await usersById.LoadAsync(userId);
        } else {
            await using var db = await dbContextFactory.CreateDbContextAsync();
            user = await db.BackofficeUser.FirstAsync(u => u.Id == userId);
        }
        var organisationseinheiten = await GetOrganisationseinheitenForUser(user);
        return new BackofficeUserFunktionsberechtigungenHelpers(user, organisationseinheiten);
    }

    /// <summary>Ermittelt die globalen Funktionsberechtigungen eines Nutzers.</summary>
    /// <param name="user">Der Backoffice-Nutzer.</param>
    /// <returns>Set der globalen Funktionsberechtigungen.</returns>
    public ImmutableHashSet<GlobaleFunktionsberechtigung> GetGlobaleFunktionsberechtigungenForUser(BackofficeUser user) {
        if (user.Art == BackofficeNutzerArt.Superadmin) {
            return Enum.GetValues<GlobaleFunktionsberechtigung>().ToImmutableHashSet();
        }

        return user.Funktionsberechtigungen.Where(b => {
            var meta = b.GetMetadata();
            return !meta.Virtuell && meta.NutzerArtMindestens.ErfuelltDurch(user.Art);
        }).ToImmutableHashSet();
    }

    /// <summary>Setzt die globalen Funktionsberechtigungen eines Nutzers.</summary>
    /// <param name="user">Der Backoffice-Nutzer.</param>
    /// <param name="globaleFunktionsberechtigungen">Die neuen globalen Funktionsberechtigungen.</param>
    public void SetGlobaleFunktionsberechtigungenForUser(BackofficeUser user, IEnumerable<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        user.Funktionsberechtigungen = globaleFunktionsberechtigungen.ToList();
    }

    /// <summary>Ermittelt die Organisationseinheiten und zugehörigen Funktionsberechtigungen eines Nutzers.</summary>
    /// <param name="user">Der Backoffice-Nutzer.</param>
    /// <returns>Auflistung der aufgelösten Organisationseinheiten mit Berechtigungen.</returns>
    public async Task<IEnumerable<ResolvedBackofficeUserOrganisationseinheit>> GetOrganisationseinheitenForUser(BackofficeUser user) {
        var isHttpRequest = httpContextAccessor.HttpContext is not null;
        UntereinheitPermissions[] untereinheitPermissions;

        if (isHttpRequest) {
            untereinheitPermissions = await untereinheitPermissionsByUserId.LoadAsync(user.Id);
        } else {
            await using var db = await dbContextFactory.CreateDbContextAsync();
            untereinheitPermissions = await db.UntereinheitPermissions.Where(p => p.BackofficeUserId == user.Id).ToArrayAsync();
        }

        var alleMoeglichenFunktionsberechtigungen = Enum.GetValues<FunktionsberechtigungInOrganisationseinheit>()
            .Where(b => {
                var meta = b.GetMetadata();
                return !meta.Virtuell && meta.NutzerArtMindestens.ErfuelltDurch(user.Art);
            })
            .ToArray();

        return untereinheitPermissions.Select(up => {
            var nutzerspezifischeFunktionsberechtigungen = new HashSet<FunktionsberechtigungInOrganisationseinheit>(up.Funktionsberechtigungen.Intersect(alleMoeglichenFunktionsberechtigungen));
            var geerbteFunktionsberechtigungen = new HashSet<FunktionsberechtigungInOrganisationseinheit>();

            // TODO: Berechtigungsprofile berücksichtigen

            geerbteFunktionsberechtigungen.UnionWith(alleMoeglichenFunktionsberechtigungen.Where(b => b.GetMetadata().Implizit));

            var alleFunktionsberechtigungen =
                nutzerspezifischeFunktionsberechtigungen.Union(geerbteFunktionsberechtigungen).ToHashSet();

            if (alleFunktionsberechtigungen.Any(b => b.ToString().StartsWith(nameof(FunktionsberechtigungInOrganisationseinheit.Backoffice)))) {
                alleFunktionsberechtigungen.Add(FunktionsberechtigungInOrganisationseinheit.Backoffice);
            }

            if (alleFunktionsberechtigungen.Any(b => b.ToString().StartsWith(nameof(FunktionsberechtigungInOrganisationseinheit.Inhaltspflege)))) {
                alleFunktionsberechtigungen.Add(FunktionsberechtigungInOrganisationseinheit.Inhaltspflege);
            }

            if (user.Art == BackofficeNutzerArt.Superadmin) {
                geerbteFunktionsberechtigungen.UnionWith(alleMoeglichenFunktionsberechtigungen);
                alleFunktionsberechtigungen.UnionWith(alleMoeglichenFunktionsberechtigungen);
            }

            return new ResolvedBackofficeUserOrganisationseinheit {
                Zugehoerig = true,
                OrganisationseinheitId = up.UntereinheitId,
                NutzerspezifischeFunktionsberechtigungen = nutzerspezifischeFunktionsberechtigungen.ToHashSet(),
                GeerbteFunktionsberechtigungen = geerbteFunktionsberechtigungen.ToImmutableHashSet(),
                AlleFunktionsberechtigungen = alleFunktionsberechtigungen.ToImmutableHashSet(),
            };
        });
    }

    /// <summary>Setzt die Organisationseinheiten und deren Berechtigungen für einen Nutzer.</summary>
    /// <param name="user">Der Backoffice-Nutzer.</param>
    /// <param name="organisationseinheiten">Die zu setzenden Organisationseinheiten mit Berechtigungen.</param>
    public void SetOrganisationseinheitenForUser(BackofficeUser user, IEnumerable<BackofficeUserOrganisationseinheit> organisationseinheiten) {
        user.UntereinheitPermissions.Clear();
        user.UntereinheitPermissions.AddRange(organisationseinheiten
            .Where(oe => oe.Zugehoerig)
            .Select(oe => new UntereinheitPermissions {
                UntereinheitId = oe.OrganisationseinheitId,
                Funktionsberechtigungen = oe.NutzerspezifischeFunktionsberechtigungen
                    .Where(b => !b.GetMetadata().Virtuell)
                    .ToList()
            }));
        Invalidate(user.Id);
    }

    /// <summary>Invalidiert den Cache der Untereinheiten-Berechtigungen für einen Nutzer.</summary>
    /// <param name="userId">Die ID des Nutzers.</param>
    public void Invalidate(Guid userId) {
        untereinheitPermissionsByUserId.Clear();
    }

    /// <summary>Lädt Backoffice-Nutzer anhand einer Liste von IDs.</summary>
    /// <param name="ids">Liste der Nutzer-IDs.</param>
    /// <param name="domainContextFactory">Factory für den Datenbankkontext.</param>
    /// <param name="ct">Abbruch-Token.</param>
    /// <returns>Dictionary der Nutzer nach ID.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, BackofficeUser>> GetBackofficeUserById(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.BackofficeUser
            .Include(u => u.Gruppen)
            .AsSingleQuery()
            .Where(a => ids.Contains(a.Id)).ToDictionaryAsync(a => a.Id, ct);
    }

}

/// <summary>Repräsentiert die Zuordnung eines Backoffice-Nutzers zu einer Organisationseinheit mit nutzerspezifischen Berechtigungen.</summary>
public class BackofficeUserOrganisationseinheit {
    public bool Zugehoerig { get; init; }
    public required Guid OrganisationseinheitId { get; init; }
    public required HashSet<FunktionsberechtigungInOrganisationseinheit> NutzerspezifischeFunktionsberechtigungen { get; init; }
}

/// <summary>Erweiterte Darstellung einer Nutzer-Organisationseinheit-Zuordnung mit geerbten und allen Berechtigungen.</summary>
public class ResolvedBackofficeUserOrganisationseinheit : BackofficeUserOrganisationseinheit {
    public required ImmutableHashSet<FunktionsberechtigungInOrganisationseinheit> GeerbteFunktionsberechtigungen { get; init; }
    public required ImmutableHashSet<FunktionsberechtigungInOrganisationseinheit> AlleFunktionsberechtigungen { get; init; }
}

/// <summary>Hilfsklasse zur Prüfung von Funktionsberechtigungen eines Backoffice-Nutzers.</summary>
/// <param name="self">Der Nutzer, für den die Berechtigungen geprüft werden.</param>
/// <param name="einheiten">Die Organisationseinheiten mit Berechtigungen des Nutzers.</param>
public class BackofficeUserFunktionsberechtigungenHelpers(BackofficeUser self, IEnumerable<ResolvedBackofficeUserOrganisationseinheit> einheiten) {
    /// <summary>Prüft eine globale Funktionsberechtigung.</summary>
    /// <param name="berechtigung">Die zu prüfende Berechtigung.</param>
    /// <returns>Status der Berechtigung.</returns>
    public Berechtigungsstatus Global(GlobaleFunktionsberechtigung berechtigung) {
        var berechtigt =
            self.Art == BackofficeNutzerArt.Superadmin ||
            self.Funktionsberechtigungen.Contains(berechtigung);
        return berechtigt
            ? Berechtigungsstatus.Ok
            : Berechtigungsstatus.Abgelehnt($"Ihnen fehlt die Globale Funktionsberechtigung {berechtigung}");
    }

    /// <summary>Prüft eine Funktionsberechtigung in einer bestimmten Organisationseinheit.</summary>
    /// <param name="organisationseinheitId">ID der Organisationseinheit.</param>
    /// <param name="berechtigung">Die zu prüfende Berechtigung.</param>
    /// <returns>Status der Berechtigung.</returns>
    public Berechtigungsstatus InOrganisationseinheit(Guid organisationseinheitId, FunktionsberechtigungInOrganisationseinheit berechtigung) {
        if (self.Art == BackofficeNutzerArt.Superadmin) {
            return Berechtigungsstatus.Ok;
        }
        var einheit = einheiten.FirstOrDefault(b => b.OrganisationseinheitId == organisationseinheitId);
        var berechtigt = einheit is not null && einheit.AlleFunktionsberechtigungen.Contains(berechtigung);
        return berechtigt
            ? Berechtigungsstatus.Ok
            : Berechtigungsstatus.Abgelehnt($"Ihnen fehlt die Funktionsberechtigung {berechtigung} in dieser Organisationseinheit.");
    }

    /// <summary>Prüft eine Funktionsberechtigung in allen angegebenen Organisationseinheiten.</summary>
    /// <param name="organisationseinheitIds">IDs der Organisationseinheiten.</param>
    /// <param name="berechtigung">Die zu prüfende Berechtigung.</param>
    /// <returns>Status der Berechtigung.</returns>
    public Berechtigungsstatus InAllenOrganisationseinheiten(IEnumerable<Guid> organisationseinheitIds, FunktionsberechtigungInOrganisationseinheit berechtigung) {
        if (self.Art == BackofficeNutzerArt.Superadmin) {
            return Berechtigungsstatus.Ok;
        }

        var berechtigt = organisationseinheitIds.All((id) =>
            einheiten.FirstOrDefault(oe => oe.OrganisationseinheitId == id)?.AlleFunktionsberechtigungen
                .Contains(berechtigung) ?? false);
        return berechtigt
            ? Berechtigungsstatus.Ok
            : Berechtigungsstatus.Abgelehnt($"Ihnen fehlt die Funktionsberechtigung {berechtigung} in mindestens einer der Organisationseinheiten.");
    }

    /// <summary>Prüft eine Funktionsberechtigung in beliebiger Organisationseinheit.</summary>
    /// <param name="berechtigung">Die zu prüfende Berechtigung.</param>
    /// <returns>Status der Berechtigung.</returns>
    public Berechtigungsstatus InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit berechtigung) {
        if (self.Art == BackofficeNutzerArt.Superadmin) {
            return Berechtigungsstatus.Ok;
        }

        return einheiten.Any(b => b.AlleFunktionsberechtigungen.Contains(berechtigung))
            ? Berechtigungsstatus.Ok
            : Berechtigungsstatus.Abgelehnt($"Ihnen fehlt die Funktionsberechtigung {berechtigung}.");
    }

    /// <summary>Prüft, ob der Nutzer einen anderen Nutzer löschen darf.</summary>
    /// <param name="user">Der zu löschende Nutzer.</param>
    /// <returns>Status der Löschberechtigung.</returns>
    public Berechtigungsstatus NutzerLoeschen(BackofficeUser user) {
        if (user.Id == self.Id) {
            return Berechtigungsstatus.Abgelehnt("Sie können sich nicht selbst löschen");
        }

        if (self.Art == BackofficeNutzerArt.Superadmin) {
            return Berechtigungsstatus.Ok;
        }

        switch (user.Art) {
            case BackofficeNutzerArt.Superadmin:
                return Berechtigungsstatus.Abgelehnt(
                    "Ein Superadmin kann nur von einem anderen Superadmin gelöscht werden.");
            case BackofficeNutzerArt.Admin:
                return Berechtigungsstatus.Abgelehnt("Ein Admin kann nur von einem Superadmin gelöscht werden.");
        }

        var actingUserOrganisationseinheitIds =
            self.UntereinheitPermissions
                .Where(p => p.Funktionsberechtigungen.Contains(
                    FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung))
                .Select(p => p.UntereinheitId).ToImmutableHashSet();

        var userToDeleteOrganisationseinheitIds =
            user.UntereinheitPermissions.Select(p => p.UntereinheitId);

        if (!actingUserOrganisationseinheitIds.IsSupersetOf(userToDeleteOrganisationseinheitIds)) {
            return Berechtigungsstatus.Abgelehnt(
                "Sie dürfen nur Nutzer löschen, wenn Sie in allen Organisationseinheiten, denen der Nutzer angehört, " +
                "zur Nutzungsverwaltung berechtigt sind.");
        }

        return Berechtigungsstatus.Ok;
    }

    /// <summary>Prüft, ob der Nutzer einen anderen Nutzer bearbeiten darf.</summary>
    /// <param name="user">Der zu bearbeitende Nutzer.</param>
    /// <returns>Status der Bearbeitungsberechtigung.</returns>
    public Berechtigungsstatus NutzerBearbeiten(BackofficeUser user) {
        if (self.Art == BackofficeNutzerArt.Superadmin) {
            return Berechtigungsstatus.Ok;
        }

        return user.Art switch {
            BackofficeNutzerArt.Superadmin => Berechtigungsstatus.Abgelehnt(
                "Ein Superadmin kann nur von einem anderen Superadmin bearbeitet werden."),
            BackofficeNutzerArt.Admin => Berechtigungsstatus.Abgelehnt(
                "Ein Admin kann nur von einem Superadmin bearbeitet werden."),
            _ => Berechtigungsstatus.Ok
        };
    }
}

/// <summary>Repräsentiert den Status einer Berechtigungsprüfung.</summary>
/// <param name="Berechtigt">Gibt an, ob die Berechtigung erteilt ist.</param>
/// <param name="Grund">Begründung bei Ablehnung.</param>
public record Berechtigungsstatus(bool Berechtigt, string Grund) {
    public static readonly Berechtigungsstatus Ok = new(true, "");
    public static Berechtigungsstatus Abgelehnt(string grund) => new(false, grund);
    /// <summary>Wirft eine Ausnahme, wenn die Berechtigung nicht erteilt ist.</summary>
    public void Fordern() {
        if (!Berechtigt) {
            throw new NotAllowedException(Grund);
        }
    }
    public static implicit operator bool(Berechtigungsstatus status) => status.Berechtigt;
}
