using API.Features.Auth.KeyEscrow;
using HotChocolate.Authorization;

namespace API.Features.Auth.Queries;

[QueryType]
public class KeyEscrowQuery {
    [Authorize]
    public async Task<string?> KeyEscrow(
        [Service] KeyEscrowService keyEscrowService,
        [Service] ICurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new InvalidOperationException();

        return await keyEscrowService.RetrieveAsync(user.Id, currentUserAccessor.ClaimsPrincipal, ct);
    }
}
