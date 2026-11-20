using System.Text.Json;
using System.Text.Json.Nodes;

namespace API.Infrastructure;

/// <summary>Erweitert JsonNode um eine Methode zur Umwandlung in JsonElement.</summary>
public static class JsonNodeExtensions {
    /// <summary>Konvertiert einen JsonNode in ein JsonElement.</summary>
    /// <param name="node">Der umzuwandelnde JsonNode.</param>
    /// <returns>Das resultierende JsonElement.</returns>
    public static JsonElement ToJsonElement(this JsonNode node) {
        return JsonSerializer.SerializeToElement(node);
    }
}
