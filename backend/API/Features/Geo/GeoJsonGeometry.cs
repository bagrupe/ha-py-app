using System.Text.Json;
using API.Features.Expressions;

namespace API.Features.Geo;

/// <summary>
/// Point-in-polygon for GeoJSON geometries stored as text (e.g. <see cref="Lage.Gebiet.Geometry"/>), since the
/// database has no PostGIS. Coordinates are planar [lng, lat]; fine for Gebiete of a few kilometres.
/// </summary>
public static class GeoJsonGeometry {
    /// <summary>Supports Polygon and MultiPolygon; any other geometry type never contains a point.</summary>
    public static bool Contains(string geometryJson, EvaluatingVisitor.ParsedLocation point) {
        using var document = JsonDocument.Parse(geometryJson);
        var geometry = document.RootElement;
        if (!geometry.TryGetProperty("type", out var type) || !geometry.TryGetProperty("coordinates", out var coordinates)) {
            return false;
        }

        return type.GetString() switch {
            "Polygon" => PolygonContains(coordinates, point),
            "MultiPolygon" => coordinates.EnumerateArray().Any(polygon => PolygonContains(polygon, point)),
            _ => false,
        };
    }

    /// <summary>Even-odd over all rings, so a point inside a hole counts as outside.</summary>
    private static bool PolygonContains(JsonElement rings, EvaluatingVisitor.ParsedLocation point) {
        var inside = false;
        foreach (var ring in rings.EnumerateArray()) {
            if (RingCrossingsAreOdd(ring, point)) {
                inside = !inside;
            }
        }
        return inside;
    }

    private static bool RingCrossingsAreOdd(JsonElement ring, EvaluatingVisitor.ParsedLocation point) {
        var vertices = ring.EnumerateArray()
            .Select(position => (Lng: position[0].GetDouble(), Lat: position[1].GetDouble()))
            .ToList();

        var odd = false;
        for (int i = 0, j = vertices.Count - 1; i < vertices.Count; j = i++) {
            var (lngI, latI) = vertices[i];
            var (lngJ, latJ) = vertices[j];
            var edgeSpansLatitude = latI > point.Lat != latJ > point.Lat;
            if (edgeSpansLatitude && point.Lng < (lngJ - lngI) * (point.Lat - latI) / (latJ - latI) + lngI) {
                odd = !odd;
            }
        }
        return odd;
    }
}
