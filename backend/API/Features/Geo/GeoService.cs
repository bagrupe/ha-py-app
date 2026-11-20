using API.Features.Expressions;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Geo;

/// <summary>Stellt Geo-bezogene Dienste bereit.</summary>
public class GeoService {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly IRequestExecutorResolver _requestExecutorResolver;

    /// <summary>Initialisiert den GeoService mit erforderlichen Abhängigkeiten.</summary>
    public GeoService(
        IRequestExecutorResolver requestExecutorResolver,
        IDbContextFactory<DomainContext> dbContextFactory) {
        _requestExecutorResolver = requestExecutorResolver;
        _dbContextFactory = dbContextFactory;
    }

    /// <summary>Prüft, ob ein Punkt innerhalb einer benannten Geofläche einer Kommune liegt.</summary>
    /// <param name="kommuneId">Die ID der Kommune.</param>
    /// <param name="name">Der Name der Geofläche.</param>
    /// <param name="parsedLocation">Die zu prüfende Position.</param>
    /// <returns>True, wenn der Punkt innerhalb der Geofläche liegt, sonst false.</returns>
    public async Task<bool> IsPointInGeoflaeche(Guid kommuneId, string name, EvaluatingVisitor.ParsedLocation parsedLocation) {
        await using var db = await _dbContextFactory.CreateDbContextAsync();
        var executor = await _requestExecutorResolver.GetRequestExecutorAsync();

        var response = await executor.ExecuteAsync(new QueryRequest(
            new QuerySourceText("""
                                query Kommune($kommuneId: UUID!, $name: String!, $position: Position!) {
                                  kommune(kommuneId: $kommuneId) {
                                    isPointInGeoflaeche(name: $name, position: $position) {
                                      isInside
                                      message
                                      __typename
                                    }
                                  }
                                }
                                """),
            variableValues: new Dictionary<string, object?> {
                { "kommuneId", kommuneId },
                { "name", name }, {
                    "position",
                    new Dictionary<string, object> { { "long", parsedLocation.Lng }, { "lat", parsedLocation.Lat } }
                }
            }));

        if (response is not QueryResult { Data: not null } result) {
            return false;
        }

        var kommune = result.Data["kommune"] as IReadOnlyDictionary<string, object?>;
        var isPointInGeoflaeche = kommune?["isPointInGeoflaeche"] as IReadOnlyDictionary<string, object?>;
        var isInside = isPointInGeoflaeche?["isInside"];

        return isInside is true;
    }
}
