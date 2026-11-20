namespace API.Features.Email.Templates;

public interface IKommuneThemedTemplate {
    public string? LogoUrl { get; set; }

    public string? KommuneName { get; set; }
    public int LogoWidth { get; set; }
    public int LogoHeight { get; set; }

    public string? ImpressumUrl { get; set; }
    public string? DatenschutzUrl { get; set; }
}
