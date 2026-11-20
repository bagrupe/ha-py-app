using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text.Json;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.ObjectStorage;
using API.Options;
using IntegrationTests.TestDoubles;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace IntegrationTests;

[Collection("Api Tests")]
public class ObjectStorageRouteTests(BackendApiFactory factory) : IAsyncLifetime {
    private const string Test = TestObjectStorageConsumer.PrefixValue;
    private const string TestOther = OtherTestObjectStorageConsumer.PrefixValue;

    private IObjectStorage Storage => factory.Services.GetRequiredService<IObjectStorage>();
    private TestObjectStorageConsumers Consumers => factory.Services.GetRequiredService<TestObjectStorageConsumers>();

    public async Task InitializeAsync() {
        Consumers.Reset();
        await ObjectStorageTestBucket.EnsureExistsAsync(factory.Services);
    }

    public Task DisposeAsync() {
        Consumers.Reset();
        return Task.CompletedTask;
    }

    [Fact]
    public async Task Upload_Authorized_StoresObjectUnderPrefix() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);

        var response = await UploadAsync(Test, token, [1, 2, 3], "image/png");

        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        var key = (await response.Content.ReadFromJsonAsync<UploadedObject>())!.Key;
        Assert.Matches($"^{Test}/[0-9a-f]{{32}}$", key);
        Assert.True(await factory.Services.GetRequiredService<IObjectStorage>().ExistsAsync(key, default));
    }

    [Fact]
    public async Task Upload_Unauthenticated_Returns401AndStoresNothing() {
        var before = await Storage.CountObjectsAsync(Test);

        var response = await UploadAsync(Test, token: null, [1], "image/png");

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        Assert.Equal(before, await Storage.CountObjectsAsync(Test));
    }

    [Fact]
    public async Task Upload_Denied_Returns403AndStoresNothing() {
        var (_, token) = CreateUser();
        var before = await Storage.CountObjectsAsync(Test);

        var response = await UploadAsync(Test, token, [1], "image/png");

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
        Assert.Equal(before, await Storage.CountObjectsAsync(Test));
    }

    [Fact]
    public async Task UnknownPrefix_Returns404OnBothRoutes() {
        var (_, token) = CreateUser();

        var upload = await UploadAsync("unknown", token, [1], "image/png");
        var download = await DownloadAsync($"unknown/{Guid.NewGuid():N}", token);

        Assert.Equal(HttpStatusCode.NotFound, upload.StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, download.StatusCode);
    }

    [Fact]
    public async Task Upload_WithoutContentLength_Returns411() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        using var client = CreateClient(token);
        var request = new HttpRequestMessage(HttpMethod.Post, $"/api/objects/{Test}") {
            Content = Content([1, 2, 3], "image/png"),
        };
        request.Headers.TransferEncodingChunked = true;

        var response = await client.SendAsync(request);

        Assert.Equal(HttpStatusCode.LengthRequired, response.StatusCode);
    }

    [Fact]
    public async Task Upload_AboveGlobalLimit_Returns413WithCodeAndStoresNothing() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        var maxBytes = factory.Services.GetRequiredService<ObjectStorageOptions>().MaxUploadBytes;
        var before = await Storage.CountObjectsAsync(Test);

        var response = await UploadAsync(Test, token, new byte[maxBytes + 1], "image/png");

        Assert.Equal(HttpStatusCode.RequestEntityTooLarge, response.StatusCode);
        var error = await ReadJsonAsync(response);
        Assert.Equal("ObjectTooLarge", error.GetProperty("code").GetString());
        Assert.Equal(maxBytes, error.GetProperty("maxBytes").GetInt64());
        Assert.Equal(before, await Storage.CountObjectsAsync(Test));
    }

    [Fact]
    public async Task Upload_AboveConsumerLimit_Returns413WithConsumerLimit() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        Consumers.Test.MaxUploadBytes = 10;

        var response = await UploadAsync(Test, token, new byte[11], "image/png");

        Assert.Equal(HttpStatusCode.RequestEntityTooLarge, response.StatusCode);
        var error = await ReadJsonAsync(response);
        Assert.Equal("ObjectTooLarge", error.GetProperty("code").GetString());
        Assert.Equal(10, error.GetProperty("maxBytes").GetInt64());
    }

    [Fact]
    public async Task Upload_DisallowedContentType_Returns415WithCodeAndStoresNothing() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        var before = await Storage.CountObjectsAsync(Test);

        var response = await UploadAsync(Test, token, [1], "text/html");

        Assert.Equal(HttpStatusCode.UnsupportedMediaType, response.StatusCode);
        var error = await ReadJsonAsync(response);
        Assert.Equal("ContentTypeNotAllowed", error.GetProperty("code").GetString());
        Assert.Equal(ObjectStorageOptions.DefaultAllowedContentTypes,
            error.GetProperty("allowed").EnumerateArray().Select(type => type.GetString()!));
        Assert.Equal(before, await Storage.CountObjectsAsync(Test));
    }

    [Fact]
    public async Task Upload_ConsumerContentTypes_ReplaceTheGlobalList() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        Consumers.Test.AllowedContentTypes = ["text/plain"];

        var accepted = await UploadAsync(Test, token, [1], "text/plain");
        var rejected = await UploadAsync(Test, token, [1], "image/png");

        Assert.Equal(HttpStatusCode.Created, accepted.StatusCode);
        Assert.Equal(HttpStatusCode.UnsupportedMediaType, rejected.StatusCode);
    }

    [Fact]
    public async Task Download_Authorized_StreamsBytesWithHeaders() {
        var (userId, token) = CreateUser();
        Consumers.Test.Uploaders.Add(userId);
        Consumers.Test.Readers.Add(userId);
        var bytes = RandomNumberGenerator.GetBytes(4096);
        var key = await UploadExpectingKeyAsync(Test, token, bytes, "application/pdf");

        var response = await DownloadAsync(key, token);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Equal(bytes, await response.Content.ReadAsByteArrayAsync());
        Assert.Equal("application/pdf", response.Content.Headers.ContentType!.MediaType);
        Assert.Equal(bytes.Length, response.Content.Headers.ContentLength);
        Assert.NotNull(response.Headers.ETag);
        Assert.True(response.Headers.CacheControl!.Private);
        Assert.True(response.Headers.CacheControl.NoStore);
    }

    [Fact]
    public async Task Download_MissingDeniedOrMalformed_Returns404() {
        var (owner, ownerToken) = CreateUser();
        var (_, strangerToken) = CreateUser();
        Consumers.Test.Uploaders.Add(owner);
        Consumers.Test.Readers.Add(owner);
        var key = await UploadExpectingKeyAsync(Test, ownerToken, [1], "image/png");

        Assert.Equal(HttpStatusCode.NotFound, (await DownloadAsync($"{Test}/{Guid.NewGuid():N}", ownerToken)).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await DownloadAsync(key, strangerToken)).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await DownloadAsync(key, token: null)).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await DownloadAsync($"{Test}/not-an-id", ownerToken)).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await DownloadAsync($"{Test}/{key[(Test.Length + 1)..].ToUpperInvariant()}", ownerToken)).StatusCode);
    }

    [Fact]
    public async Task Download_KeyOfAnotherConsumer_Returns404() {
        var (userId, token) = CreateUser();
        Consumers.TestOther.Uploaders.Add(userId);
        Consumers.Test.Readers.Add(userId);
        var otherKey = await UploadExpectingKeyAsync(TestOther, token, [1], "image/png");
        var otherId = otherKey[(TestOther.Length + 1)..];

        var viaTestPrefix = await DownloadAsync($"{Test}/{otherId}", token);
        var viaOwnPrefix = await DownloadAsync(otherKey, token);

        Assert.Equal(HttpStatusCode.NotFound, viaTestPrefix.StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, viaOwnPrefix.StatusCode);
    }

    [Fact]
    public async Task DisabledStorage_Returns503OnBothRoutes() {
        await using var disabledFactory = new ObjectStorageDisabledApiFactory();
        var (_, token) = CreateUser();
        using var client = CreateClient(token, disabledFactory);

        var upload = await client.PostAsync($"/api/objects/{Test}", Content([1], "image/png"));
        var download = await client.GetAsync($"/api/objects/{Test}/{Guid.NewGuid():N}");

        Assert.Equal(HttpStatusCode.ServiceUnavailable, upload.StatusCode);
        Assert.Equal(HttpStatusCode.ServiceUnavailable, download.StatusCode);
    }

    [Theory]
    [InlineData("Test")]
    [InlineData("with/slash")]
    [InlineData("")]
    public void Registry_RejectsInvalidPrefix(string prefix) {
        Assert.Throws<InvalidOperationException>(() => new ObjectStorageConsumerRegistry([new FixedPrefixConsumer(prefix)]));
    }

    [Fact]
    public void Registry_RejectsDuplicatePrefix() {
        Assert.Throws<InvalidOperationException>(() => new ObjectStorageConsumerRegistry(
            [new FixedPrefixConsumer("images"), new FixedPrefixConsumer("images")]));
    }

    [Fact]
    public void ConfiguredContentTypes_ReplaceTheDefaults() {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?> { ["AllowedContentTypes:0"] = "text/plain" })
            .Build();

        var options = configuration.Get<ObjectStorageOptions>()!;

        Assert.Equal(["text/plain"], options.EffectiveAllowedContentTypes);
    }

    private (Guid UserId, string Token) CreateUser() {
        var jwtOptions = factory.Services.GetRequiredService<IOptions<JWTOptions>>().Value;
        var buerger = new Buerger { Id = Guid.NewGuid(), PersonalDataKeyEncryptedForBuerger = "test" };
        return (buerger.Id, new JwtSecurityTokenHandler().WriteToken(buerger.GetToken(jwtOptions)));
    }

    private static ByteArrayContent Content(byte[] bytes, string contentType) {
        var content = new ByteArrayContent(bytes);
        content.Headers.ContentType = new MediaTypeHeaderValue(contentType);
        return content;
    }

    private async Task<HttpResponseMessage> UploadAsync(string prefix, string? token, byte[] bytes, string contentType) {
        using var client = CreateClient(token);
        return await client.PostAsync($"/api/objects/{prefix}", Content(bytes, contentType));
    }

    private async Task<string> UploadExpectingKeyAsync(string prefix, string token, byte[] bytes, string contentType) {
        var response = await UploadAsync(prefix, token, bytes, contentType);
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<UploadedObject>())!.Key;
    }

    private async Task<HttpResponseMessage> DownloadAsync(string key, string? token) {
        using var client = CreateClient(token);
        return await client.GetAsync($"/api/objects/{key}");
    }

    private HttpClient CreateClient(string? token, BackendApiFactory? host = null) {
        var client = (host ?? factory).CreateClient();
        if (token is not null) {
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        }

        return client;
    }

    private static async Task<JsonElement> ReadJsonAsync(HttpResponseMessage response) =>
        await response.Content.ReadFromJsonAsync<JsonElement>();

    private sealed class FixedPrefixConsumer(string prefix) : IObjectStorageConsumer {
        public string Prefix => prefix;
        public Task<bool> CanUploadAsync(Guid userId, CancellationToken ct) => Task.FromResult(false);
        public Task<bool> CanReadAsync(Guid? userId, string key, CancellationToken ct) => Task.FromResult(false);
        public Task<bool> IsReferencedAsync(string key, CancellationToken ct) => Task.FromResult(true);
    }
}
