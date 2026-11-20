namespace API.Infrastructure.Exceptions;

/// <summary>
/// Wird ausgelöst, wenn Brevo eine Telefonnummer trotz bestandener eigener Formatprüfung ablehnt
/// – siehe <see cref="Features.Auth.SmsService"/>.
/// </summary>
public class SmsInvalidPhoneNumberException() : DomainException("SMS recipient rejected by provider");
