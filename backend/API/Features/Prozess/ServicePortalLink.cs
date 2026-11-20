namespace API.Features.Prozess;

[ObjectType]
[GraphQLDescription("Repräsentiert einen Link zu einem externen Service-Portal, der für Bürger sichtbar ist.")]
public class ServicePortalLink : UserFacingProzess {
    /// <summary>URL des externen Service-Portals.</summary>
    public string Url { get; set; } = "";
}
