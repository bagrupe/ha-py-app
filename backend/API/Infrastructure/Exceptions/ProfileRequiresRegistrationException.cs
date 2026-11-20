namespace API.Infrastructure.Exceptions;

/// <summary>
/// Wird ausgelöst, wenn ein noch nicht registrierter (anonymer Weak-Login-)Bürger versucht,
/// über <c>updateMyProfile</c> Profilfelder zu ändern. "Mein Konto" und diese Mutation sind
/// ausschließlich für registrierte Bürger (SMS- oder BundID-Registrierung) gedacht.
/// </summary>
public class ProfileRequiresRegistrationException()
    : DomainException("Profildaten können erst nach der Registrierung bearbeitet werden.");
