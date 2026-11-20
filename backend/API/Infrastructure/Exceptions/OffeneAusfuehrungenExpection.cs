namespace API.Infrastructure;

public class OffeneAusfuehrungenException() : DomainException("Profil kann nicht gelöscht werden, da noch offene Anträge vorhanden sind.");
