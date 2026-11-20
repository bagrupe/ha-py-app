namespace API.Infrastructure.Exceptions;

/// <summary>
/// Wird ausgelöst, wenn versucht wird, Vorname/Nachname/EmailAddress/Street/PostalCode/City/Country
/// eines mit BundID verknüpften Bürgers über <c>updateMyProfile</c> zu ändern. Diese Felder werden
/// ausschließlich bei der BundID-Anmeldung synchronisiert; Änderungen müssen direkt im BundID-Konto
/// erfolgen.
/// </summary>
public class ProfileManagedByBundIdException()
    : DomainException("Profildaten werden von BundID verwaltet und können nicht manuell geändert werden.");
