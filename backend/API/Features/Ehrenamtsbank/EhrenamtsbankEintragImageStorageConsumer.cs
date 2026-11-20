using API.Features.ObjectStorage;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank;

/// <summary>Stores Ehrenamtsbank entry images. Registered Bürger may upload; entry visibility controls reading.</summary>
public class EhrenamtsbankEintragImageStorageConsumer(DomainContext db) : IObjectStorageConsumer {
    // Keep the existing prefix so stored entry image keys remain valid. Other attachment purposes need their own prefix.
    public const string KeyPrefix = "ehrenamtsbank";

    public static readonly IReadOnlyCollection<string> AllowedImageContentTypes =
        ["image/jpeg", "image/png", "image/heic", "image/webp"];

    public string Prefix => KeyPrefix;

    public IReadOnlyCollection<string> AllowedContentTypes => AllowedImageContentTypes;

    public Task<bool> CanUploadAsync(Guid userId, CancellationToken ct) =>
        EintragVisibility.IsRegisteredBuergerAsync(db, userId, ct);

    public async Task<bool> CanReadAsync(Guid? userId, string key, CancellationToken ct) {
        var eintrag = await db.EhrenamtsbankEintraege.FirstOrDefaultAsync(e => e.ImageKey == key && !e.IsDeleted, ct);
        return eintrag is not null && await EintragVisibility.CanViewAsync(db, eintrag, userId, ct);
    }

    public Task<bool> IsReferencedAsync(string key, CancellationToken ct) =>
        db.EhrenamtsbankEintraege.AnyAsync(e => e.ImageKey == key && !e.IsDeleted, ct);
}
