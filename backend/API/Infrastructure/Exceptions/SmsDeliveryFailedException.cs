namespace API.Infrastructure.Exceptions;

/// <summary>
/// Wird ausgelöst, wenn der SMS-Versand über Brevo fehlschlägt (API nicht erreichbar, sonstiger
/// Serverfehler) – siehe <see cref="Features.Auth.SmsService"/>.
/// </summary>
public class SmsDeliveryFailedException() : DomainException("SMS delivery failed");
