using API.Features.Auth.KeyEscrow;
using HotChocolate.Authorization;

namespace API.Features.Auth.Mutations;

[MutationType]
public class StoreKeyEscrowMutation {
    [Authorize]
    public async Task<bool> StoreKeyEscrow(
        string privateKey,
        [Service] KeyEscrowService keyEscrowService,
        [Service] ICurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new InvalidOperationException();

        await keyEscrowService.StoreAsync(user.Id, privateKey, ct);
        return true;
    }
}
