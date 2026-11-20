namespace API.Options;

public class EhrenamtsbankZeitkontoOptions {
    // EF's HasMaxLength needs a compile-time constant, so the column length lives here
    // and MaxNoteLength defaults to it.
    public const int NoteMaxLength = 500;

    public int StartCreditMinutes { get; init; } = 180;

    public int MaxTransactionMinutes { get; init; } = 1440;

    public int MaxNoteLength { get; init; } = NoteMaxLength;

    /// <summary>
    /// Mindest-Zeitkonto-Saldo in Minuten für die Ehrenamtsbank-Konto-Löschung.
    /// Standard 0: negative Salden blockieren die Löschung.
    /// </summary>
    public int DeletionMinBalanceMinutes { get; init; } = 0;
}
