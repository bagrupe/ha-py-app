using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;
using ProjNet.CoordinateSystems;
using ProjNet.CoordinateSystems.Transformations;
using ProjNet.IO.CoordinateSystems;

namespace API.Scripts.ImportKategorieBaum;

/// <summary>
/// Importiert und transformiert GeoJSON-Koordinaten von EPSG:25832 nach EPSG:4326.
/// </summary>
public class GeoJsonImporter {
    private static CoordinateTransformationFactory transformationFactory = new();
    private const string epsg4326Wkt = """
                          GEOGCS["WGS 84",
                          DATUM["WGS_1984",
                              SPHEROID["WGS 84",6378137,298.257223563,
                                  AUTHORITY["EPSG","7030"]],
                              AUTHORITY["EPSG","6326"]],
                          PRIMEM["Greenwich",0,
                              AUTHORITY["EPSG","8901"]],
                          UNIT["degree",0.0174532925199433,
                              AUTHORITY["EPSG","9122"]],
                          AUTHORITY["EPSG","4326"]]
                          """;

    private static CoordinateSystem epsg4326 = (CoordinateSystem)CoordinateSystemWktReader.Parse(epsg4326Wkt);

    private const string epsg25832Wkt = """
                        PROJCS["ETRS89 / UTM zone 32N",
                        GEOGCS["ETRS89",
                            DATUM["European_Terrestrial_Reference_System_1989",
                                SPHEROID["GRS 1980",6378137,298.257222101,
                                    AUTHORITY["EPSG","7019"]],
                                TOWGS84[0,0,0,0,0,0,0],
                                AUTHORITY["EPSG","6258"]],
                            PRIMEM["Greenwich",0,
                                AUTHORITY["EPSG","8901"]],
                            UNIT["degree",0.0174532925199433,
                                AUTHORITY["EPSG","9122"]],
                            AUTHORITY["EPSG","4258"]],
                        PROJECTION["Transverse_Mercator"],
                        PARAMETER["latitude_of_origin",0],
                        PARAMETER["central_meridian",9],
                        PARAMETER["scale_factor",0.9996],
                        PARAMETER["false_easting",500000],
                        PARAMETER["false_northing",0],
                        UNIT["metre",1,
                            AUTHORITY["EPSG","9001"]],
                        AXIS["Easting",EAST],
                        AXIS["Northing",NORTH],
                        AUTHORITY["EPSG","25832"]]
                        """;
    private static CoordinateSystem epsg25832 = (CoordinateSystem)CoordinateSystemWktReader.Parse(epsg25832Wkt);

    private static ICoordinateTransformation transform = transformationFactory.CreateFromCoordinateSystems(
        epsg25832,
        epsg4326
    )!;

    /// <summary>
    /// Transformiert einen Punkt von EPSG:25832 nach EPSG:4326.
    /// </summary>
    /// <param name="x">X-Koordinate im EPSG:25832 System.</param>
    /// <param name="y">Y-Koordinate im EPSG:25832 System.</param>
    /// <returns>Transformierte Koordinaten als Tupel (x, y) im EPSG:4326 System.</returns>
    public static (double x, double y) TransformPoint(double x, double y) {
        return transform.MathTransform.Transform(x, y);
    }

    /// <summary>
    /// Liest eine GeoJSON-Datei ein, transformiert alle Koordinaten und gibt das Ergebnis als JsonElement zurück.
    /// </summary>
    /// <param name="path">Pfad zur GeoJSON-Datei.</param>
    /// <returns>Transformiertes GeoJSON als JsonElement.</returns>
    public static async Task<JsonElement> ImportGeoJson(string path) {
        var geoJson = await File.ReadAllTextAsync(path);
        var coordinateRegex = new Regex(@"(?<X>[\d.]+),\s*(?<Y>[\d.]+)");

        CultureInfo.CurrentCulture = CultureInfo.InvariantCulture;

        var isMagic = coordinateRegex.Replace(geoJson, match => {
            var x = double.Parse(match.Groups["X"].Value);
            var y = double.Parse(match.Groups["Y"].Value);

            var (newX, newY) = TransformPoint(x, y);

            return $"{newX}, {newY}";
        });

        return JsonSerializer.Deserialize<JsonElement>(isMagic);
    }
}
