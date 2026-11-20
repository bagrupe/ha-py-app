namespace API.Options;

public class EhrenamtsbankOptions {
    public bool ACCEPT_MASTER_CODE { get; init; } = false;

    public string PhoneNumberSalt { get; init; } = "foo";

    public bool EintragSkipReview { get; init; } = false;
}
