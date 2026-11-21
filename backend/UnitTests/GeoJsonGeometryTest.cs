using API.Features.Expressions;
using API.Features.Geo;

namespace IntegrationTests;

/// <summary>Pure logic tests for <see cref="GeoJsonGeometry"/>: no database, no HTTP, no GraphQL.</summary>
public class GeoJsonGeometryTest {
    private const string Square = """{"type":"Polygon","coordinates":[[[9.0,52.0],[10.0,52.0],[10.0,53.0],[9.0,53.0],[9.0,52.0]]]}""";

    private const string SquareWithHole = """
        {"type":"Polygon","coordinates":[
          [[9.0,52.0],[10.0,52.0],[10.0,53.0],[9.0,53.0],[9.0,52.0]],
          [[9.4,52.4],[9.6,52.4],[9.6,52.6],[9.4,52.6],[9.4,52.4]]
        ]}
        """;

    private const string TwoSquares = """
        {"type":"MultiPolygon","coordinates":[
          [[[9.0,52.0],[10.0,52.0],[10.0,53.0],[9.0,53.0],[9.0,52.0]]],
          [[[11.0,52.0],[12.0,52.0],[12.0,53.0],[11.0,53.0],[11.0,52.0]]]
        ]}
        """;

    [Fact]
    public void Polygon_contains_a_point_inside() =>
        Assert.True(GeoJsonGeometry.Contains(Square, new EvaluatingVisitor.ParsedLocation(9.5, 52.5)));

    [Fact]
    public void Polygon_does_not_contain_a_point_outside() =>
        Assert.False(GeoJsonGeometry.Contains(Square, new EvaluatingVisitor.ParsedLocation(10.5, 52.5)));

    [Fact]
    public void Coordinates_are_read_as_lng_lat_not_lat_lng() =>
        Assert.False(GeoJsonGeometry.Contains(Square, new EvaluatingVisitor.ParsedLocation(52.5, 9.5)));

    [Fact]
    public void Polygon_does_not_contain_a_point_inside_its_hole() =>
        Assert.False(GeoJsonGeometry.Contains(SquareWithHole, new EvaluatingVisitor.ParsedLocation(9.5, 52.5)));

    [Fact]
    public void Polygon_contains_a_point_between_outer_ring_and_hole() =>
        Assert.True(GeoJsonGeometry.Contains(SquareWithHole, new EvaluatingVisitor.ParsedLocation(9.2, 52.2)));

    [Theory]
    [InlineData(9.5, 52.5, true)]
    [InlineData(11.5, 52.5, true)]
    [InlineData(10.5, 52.5, false)]
    public void MultiPolygon_contains_points_in_any_of_its_polygons(double lng, double lat, bool expected) =>
        Assert.Equal(expected, GeoJsonGeometry.Contains(TwoSquares, new EvaluatingVisitor.ParsedLocation(lng, lat)));

    [Fact]
    public void Unsupported_geometry_types_never_contain_a_point() =>
        Assert.False(GeoJsonGeometry.Contains("""{"type":"Point","coordinates":[9.5,52.5]}""", new EvaluatingVisitor.ParsedLocation(9.5, 52.5)));
}
