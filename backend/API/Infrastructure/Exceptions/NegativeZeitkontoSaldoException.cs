namespace API.Infrastructure;

public class NegativeZeitkontoSaldoException(int balanceMinutes, int minBalanceMinutes)
    : DomainException(
        $"Zeitkonto-Saldo beträgt {balanceMinutes} Minuten. "
        + $"Die Löschung ist erst ab einem Saldo von mindestens {minBalanceMinutes} Minuten möglich.") {
    public int BalanceMinutes { get; } = balanceMinutes;
    public int MinBalanceMinutes { get; } = minBalanceMinutes;
}
