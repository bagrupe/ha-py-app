using API.Clients.BereichBClient;
using API.Options;
using SkiaSharp;

namespace API.Features.Kommune;

public record KommuneLogo(byte[] Bytes, string MediaType, int Width, int Height);

internal record DownloadedLogo(byte[] Bytes, string MediaType);

public record KommuneLegalLinks(string Impressum, string Privacy);

/// <summary>Stellt Funktionen zum Abruf des Designs einer Kommune bereit.</summary>
public class KommuneDesignService(
    BereichBClient bereichBClient,
    IHttpClientFactory httpClientFactory,
    WebOptions webOptions,
    ILogger<KommuneDesignService> logger
) {
    private readonly Dictionary<Guid, (string? primaryColor, string? logoUrl)> _cached = [];
    private readonly Dictionary<Guid, KommuneLogo> _cachedLogos = [];

    /// <summary>Lädt die Primärfarbe und das Logo einer Kommune anhand der Kommune-Id.</summary>
    /// <param name="kommuneId">Die eindeutige Id der Kommune.</param>
    /// <returns>Ein Tupel mit Primärfarbe und Base64-kodierter Logo-URL oder null, falls nicht vorhanden.</returns>
    public async Task<(string? primaryColor, string? logoUrl)> GetKommuneDesign(Guid kommuneId) {
        if (_cached.TryGetValue(kommuneId, out var cached)) return cached;

        var kommuneDesignResponse = await bereichBClient.KommuneDesign.ExecuteAsync(kommuneId.ToString());
        if (kommuneDesignResponse.Data?.KommuneByBereichAId?.Design?.Colors?.Primary is not { } primary) {
            return (null, null);
        }

        if (kommuneDesignResponse.Data?.KommuneByBereichAId?.Design?.Logo?.Url is not { } logoUrl) {
            return (null, null);
        }

        var logo = await DownloadLogo(logoUrl);
        if (logo is null) {
            return (primary, null);
        }

        var base64 = $"data:{logo.MediaType};base64,{Convert.ToBase64String(logo.Bytes)}";

        var result = (primary, base64);
        _cached[kommuneId] = result;

        return result;
    }

    public async Task<KommuneLogo?> GetKommuneLogo(Guid kommuneId) {
        if (_cachedLogos.TryGetValue(kommuneId, out var cachedLogo)) return cachedLogo;

        // A CMS outage must not keep mails (e.g. password resets) from being queued.
        try {
            var response = await bereichBClient.KommuneDesign.ExecuteAsync(kommuneId.ToString());
            if (response.Data?.KommuneByBereichAId?.Design?.Logo?.Url is not { } logoUrl) {
                return null;
            }

            var downloaded = await DownloadLogo(logoUrl);
            if (downloaded is null) {
                return null;
            }

            using var codec = SKCodec.Create(new SKMemoryStream(downloaded.Bytes));
            if (codec is null) {
                return null;
            }

            var logo = new KommuneLogo(downloaded.Bytes, downloaded.MediaType, codec.Info.Width, codec.Info.Height);
            _cachedLogos[kommuneId] = logo;

            return logo;
        } catch (Exception e) when (e is not OperationCanceledException) {
            logger.LogWarning(e, "Could not load the logo of Kommune {KommuneId} for an e-mail", kommuneId);
            return null;
        }
    }

    public async Task<KommuneLegalLinks> GetKommuneLegalLinks(Guid kommuneId) {
        var baseUrl = webOptions.BaseUrl.TrimEnd('/');
        var fallback = new KommuneLegalLinks($"{baseUrl}/impressum", $"{baseUrl}/datenschutz");

        try {
            var response = await bereichBClient.KommuneLegalLinks.ExecuteAsync(kommuneId.ToString());
            var legal = response.Data?.KommuneByBereichAId?.Legal;

            return new KommuneLegalLinks(
                ToAbsoluteUrl(legal?.Impressum) ?? fallback.Impressum,
                ToAbsoluteUrl(legal?.Privacy) ?? fallback.Privacy);
        } catch (Exception e) when (e is not OperationCanceledException) {
            logger.LogWarning(e, "Could not load the legal links of Kommune {KommuneId} for an e-mail", kommuneId);
            return fallback;
        }
    }

    private string? ToAbsoluteUrl(string? url) {
        if (string.IsNullOrWhiteSpace(url)) return null;
        url = url.Trim();

        if (Uri.TryCreate(url, UriKind.Absolute, out var absolute)
            && absolute.Scheme is "http" or "https") {
            return url;
        }

        return url.StartsWith('/') ? $"{webOptions.BaseUrl.TrimEnd('/')}{url}" : null;
    }

    private async Task<DownloadedLogo?> DownloadLogo(string logoUrl) {
        using var httpClient = httpClientFactory.CreateClient();
        var logoResponse = await httpClient.GetAsync(logoUrl);

        if (!logoResponse.IsSuccessStatusCode) {
            return null;
        }

        var contentType = logoResponse.Content.Headers.ContentType?.MediaType ?? "image/png";
        var bytes = await logoResponse.Content.ReadAsByteArrayAsync();

        return new DownloadedLogo(bytes, contentType);
    }
}
