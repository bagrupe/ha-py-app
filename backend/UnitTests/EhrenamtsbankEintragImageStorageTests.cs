using API.Features;
using API.Features.Auth;
using API.Features.Ehrenamtsbank;
using API.Features.Funktionsberechtigungen;
using API.Features.ObjectStorage;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankEintragImageStorageTests(BackendApiFactory factory) : EhrenamtsbankEintragTestBase(factory) {
    private const string Prefix = EhrenamtsbankEintragImageStorageConsumer.KeyPrefix;

    [Fact]
    public async Task Upload_AllowedOnlyForRegisteredBuerger() {
        var registered = await CreateBuerger(registered: true);
        var unregistered = await CreateBuerger(registered: false);

        Assert.True(await WithConsumer(c => c.CanUploadAsync(registered.Id, default)));
        Assert.False(await WithConsumer(c => c.CanUploadAsync(unregistered.Id, default)));
    }

    [Fact]
    public async Task Read_ActiveIsPublic_PendingOnlyForOwner() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var activeKey = await AttachImage(await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active));
        var pendingKey = await AttachImage(await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview));

        Assert.True(await WithConsumer(c => c.CanReadAsync(null, activeKey, default)));
        Assert.True(await WithConsumer(c => c.CanReadAsync(owner.Id, pendingKey, default)));
        Assert.False(await WithConsumer(c => c.CanReadAsync(stranger.Id, pendingKey, default)));
        Assert.False(await WithConsumer(c => c.CanReadAsync(null, pendingKey, default)));
    }

    [Fact]
    public async Task Create_WithMissingImage_IsRejected() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        var result = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation, new Dictionary<string, object?> {
            ["input"] = CreateInput(kategorie.Id, gemeinde,
                overrides: new() { ["imageKey"] = ObjectStorageTestBucket.NewKey(Prefix) }),
        });

        AssertMutationError(result, "createEhrenamtsbankEintrag", "EintragValidationError");
    }

    [Fact]
    public async Task Update_ReplacingImage_EnqueuesOldKey() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var oldKey = await AttachImage(eintrag);
        var newKey = await PutImage();

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation, new Dictionary<string, object?> {
            ["input"] = UpdateInput(await ReadEintrag(eintrag.Id), eintrag.Title,
                overrides: new() { ["imageKey"] = newKey }),
        });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        Assert.Equal(newKey, (await ReadEintrag(eintrag.Id)).ImageKey);
        Assert.True(await IsDeletionPending(oldKey));
    }

    [Fact]
    public async Task Create_WithKeyOfAnotherEintrag_IsRejected() {
        var owner = await CreateBuerger(registered: true);
        var other = await CreateBuerger(registered: true);
        var key = await AttachImage(await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active));
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        var result = await ExecuteGraphqlAsync(Principal(other.Id), CreateMutation, new Dictionary<string, object?> {
            ["input"] = CreateInput(kategorie.Id, gemeinde, overrides: new() { ["imageKey"] = key }),
        });

        AssertMutationError(result, "createEhrenamtsbankEintrag", "EintragValidationError");
    }

    [Fact]
    public async Task Update_ClearingImage_EnqueuesKey() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var key = await AttachImage(eintrag);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation, new Dictionary<string, object?> {
            ["input"] = UpdateInput(await ReadEintrag(eintrag.Id), eintrag.Title,
                overrides: new() { ["imageKey"] = null }),
        });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        Assert.Null((await ReadEintrag(eintrag.Id)).ImageKey);
        Assert.True(await IsDeletionPending(key));
    }

    [Fact]
    public async Task Update_WithoutImageKey_KeepsImage() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var key = await AttachImage(eintrag);
        var input = UpdateInput(await ReadEintrag(eintrag.Id), eintrag.Title);
        input.Remove("imageKey");

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = input });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        Assert.Equal(key, (await ReadEintrag(eintrag.Id)).ImageKey);
        Assert.False(await IsDeletionPending(key));
    }

    [Fact]
    public async Task PendingEintrag_VisibleOnlyToModerator() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview);
        var moderator = await CreateBackofficeUser([GlobaleFunktionsberechtigung.Ehrenamtsbank]);
        var withoutBerechtigung = await CreateBackofficeUser([]);
        const string query = "query Eintrag($id: UUID!) { ehrenamtsbankEintrag(id: $id) { id } }";
        var variables = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() };

        var asModerator = await ExecuteGraphqlAsync(Principal(moderator), query, variables);
        var asOther = await ExecuteGraphqlAsync(Principal(withoutBerechtigung), query, variables);

        Assert.Null(asModerator.Errors);
        Assert.Equal("EINTRAG_NOT_FOUND", Assert.Single(asOther.Errors!).Code);
    }

    [Fact]
    public async Task Delete_EnqueuesImageKey() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var key = await AttachImage(eintrag);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), """
            mutation Delete($input: DeleteEhrenamtsbankEintragInput!) {
                deleteEhrenamtsbankEintrag(input: $input) { errors { __typename } }
            }
        """, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() },
        });

        Assert.Null(Payload(result, "deleteEhrenamtsbankEintrag")["errors"]);
        Assert.True(await IsDeletionPending(key));
    }

    private async Task<Guid> CreateBackofficeUser(List<GlobaleFunktionsberechtigung> funktionsberechtigungen) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"ehrenamtsbank-{Guid.NewGuid():N}@test.local",
            Vorname = "Moderation",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Funktionsberechtigungen = funktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>());
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
        return user.Id;
    }

    private async Task<T> WithConsumer<T>(Func<IObjectStorageConsumer, Task<T>> action) {
        using var scope = Factory.Services.CreateScope();
        var consumer = scope.ServiceProvider.GetServices<IObjectStorageConsumer>().Single(c => c.Prefix == Prefix);
        return await action(consumer);
    }

    private async Task<string> PutImage() {
        await ObjectStorageTestBucket.EnsureExistsAsync(Factory.Services);
        return await Factory.Services.GetRequiredService<IObjectStorage>()
            .PutAsync(ObjectStorageTestBucket.NewKey(Prefix), [1, 2, 3]);
    }

    private async Task<string> AttachImage(EhrenamtsbankEintrag eintrag) {
        var key = await PutImage();
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await db.EhrenamtsbankEintraege.Where(e => e.Id == eintrag.Id)
            .ExecuteUpdateAsync(s => s.SetProperty(e => e.ImageKey, key));
        return key;
    }

    private async Task<bool> IsDeletionPending(string key) {
        using var scope = Factory.Services.CreateScope();
        return await scope.ServiceProvider.GetRequiredService<DomainContext>().IsObjectDeletionPendingAsync(key, default);
    }
}
