using System.Collections.Concurrent;
using API.Clients.BereichBClient;

namespace API.Features.Ideenmelder;

public class IdeenSichtbarkeitService(BereichBClient bereichBClient) {
    private readonly ConcurrentDictionary<Guid, double> _cache = new();
    private const double DefaultStunden = 72;

    public async Task<double> GetSichtbarkeitStunden(Guid kommuneId) {
        if (_cache.TryGetValue(kommuneId, out var cached)) return cached;

        var response = await bereichBClient.KommuneMaengelConfig.ExecuteAsync(kommuneId.ToString());
        var stunden = response.Data?.KommuneByBereichAId?.Ideenmelder?.IdeenZeitfensterStunden;
        var result = stunden ?? DefaultStunden;
        _cache.TryAdd(kommuneId, result);
        return result;
    }
}
