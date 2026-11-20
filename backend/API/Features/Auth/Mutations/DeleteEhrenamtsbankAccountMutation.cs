using API.Features.Ehrenamtsbank.Mutations;
using API.Infrastructure;
using HotChocolate.Authorization;

namespace API.Features.Auth.Mutations;

[MutationType]
public class DeleteEhrenamtsbankAccountMutation {
    [UseMutationConvention(PayloadFieldName = "result")]
    [Error(typeof(CurrentUserAccessor.Unauthenticated))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(NegativeZeitkontoSaldoException))]
    [Error(typeof(VereinbarteAnfragenException))]
    [Error(typeof(OffeneAusfuehrungenException))]
    [Authorize]
    [GraphQLDescription(
        "Löscht das Ehrenamtsbank-Konto des angemeldeten Bürgers, soft-löscht zugehörige Anträge "
        + "und erstellt atomar eine neue schwache App-Identität.")]
    public async Task<DeleteEhrenamtsbankAccountResult> DeleteEhrenamtsbankAccount(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        [Service] BuergerAccountDeletionService deletionService,
        string derivedPassword,
        string publicKey,
        EncryptedValue encryptedPrivateKey,
        string personalDataKeyForBuerger,
        string salt,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        return await deletionService.DeleteEhrenamtsbankAccountAsync(
            db,
            buerger.Id,
            new WeakLoginCredentials(
                derivedPassword, publicKey, encryptedPrivateKey, personalDataKeyForBuerger, salt),
            ct);
    }
}
