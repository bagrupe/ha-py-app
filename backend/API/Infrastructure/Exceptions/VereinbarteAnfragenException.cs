namespace API.Infrastructure;

public class VereinbarteAnfragenException(int count)
    : DomainException(
        count == 1
            ? "Es besteht noch eine vereinbarte Ehrenamtsbank-Anfrage. "
              + "Bitte schließen oder klären Sie diese, bevor Sie Ihr Konto löschen."
            : $"Es bestehen noch {count} vereinbarte Ehrenamtsbank-Anfragen. "
              + "Bitte schließen oder klären Sie diese, bevor Sie Ihr Konto löschen.") {
    public int Count { get; } = count;
}
