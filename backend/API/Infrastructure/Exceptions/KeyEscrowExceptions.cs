namespace API.Infrastructure.Exceptions;

public class KeyEscrowAccountNotVerifiedException()
    : DomainException("Key escrow is only available for verified accounts.");

public class KeyEscrowKeyMismatchException()
    : DomainException("The private key does not match the account's public key.");

public class KeyEscrowRequiresStrongSessionException()
    : DomainException("Key escrow can only be retrieved with a BundID or SMS session.");
