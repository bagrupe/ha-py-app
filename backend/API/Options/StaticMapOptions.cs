using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Options for the map image in PDF exports.</summary>
public class StaticMapOptions : IValidatable {
    /// <summary>URL template for raster tiles with <c>{z}</c>, <c>{x}</c>, and <c>{y}</c> placeholders.</summary>
    [Required] public string TileUrlTemplate { get; set; } = "https://tile.openstreetmap.de/{z}/{x}/{y}.png";

    /// <summary>Map zoom level.</summary>
    [Range(0, 22)] public int Zoom { get; set; } = 16;

    /// <summary>Map image width in pixels.</summary>
    [Range(1, 4096)] public int WidthPx { get; set; } = 640;

    /// <summary>Map image height in pixels.</summary>
    [Range(1, 4096)] public int HeightPx { get; set; } = 400;

    /// <summary>User agent for tile requests. If omitted, it is built from <c>EMail:From</c>.</summary>
    public string? UserAgent { get; set; }

    /// <summary>Tile request timeout in seconds.</summary>
    [Range(1, 300)] public int TimeoutSeconds { get; set; } = 10;

    /// <summary>Maximum simultaneous connections to the tile server (OSM tile server usage policy).</summary>
    [Range(1, 16)] public int MaxConnections { get; set; } = 2;

    /// <summary>Validates the current options against the defined rules.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
