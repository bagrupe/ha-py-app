using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using API.Features.Prozess;

namespace API.Features.GovManager;

/// <summary>Definiert einen Prozessschritt für den GovManager-REST-Export mit zugehörigen Exportdaten und Metadaten.</summary>
public class GovManagerRestExportSchritt : Schritt {
    /// <summary>Enthält die Slots, die für diesen Schritt verwendet werden.</summary>
    public override IEnumerable<Slot> Slots { get; } = [
        new Slot { Name = "id", ValueType = SlotValueType.String, Encrypted = false },
        new Slot { Name = "requestId", ValueType = SlotValueType.String, Encrypted = false },
        new Slot { Name = "uploadStatus", ValueType = SlotValueType.String, Encrypted = false }
    ];

    /// <summary>Gibt an, dass die Erledigung dieses Schritts nicht durch den Bürger erfolgt.</summary>
    public override bool ErledigungDurchBuerger => false;

    /// <summary>Liste der zu exportierenden Teile, gespeichert als JSONB in der Datenbank.</summary>
    [Column(TypeName = "jsonb")]
    public required List<IPart> ExportParts { get; init; }

    /// <summary>Typ des Vorgangs, der exportiert wird.</summary>
    public required string VorgangsTyp { get; init; }

    /// <summary>Mandantenschlüssel für die Zuordnung des Vorgangs.</summary>
    public required string MandantenSchluessel { get; init; }

    /// <summary>Schlüssel des Vorgangs zur Identifikation.</summary>
    public required string VorgangsSchluessel { get; init; }

    /// <summary>Gibt an, ob die Datei-Teile als PDF exportiert werden sollen.</summary>
    public bool ExportFilePartsAsPdf { get; init; }
}

/// <summary>Repräsentiert einen Teil des Exports, entweder Datei oder JSON.</summary>
[UnionType]
[JsonDerivedType(typeof(FilePart), typeDiscriminator: "file")]
[JsonDerivedType(typeof(JsonPart), typeDiscriminator: "json")]
public interface IPart { }

/// <summary>Repräsentiert einen Datei-Teil im Export mit zugehörigem Slotnamen.</summary>
[ObjectType]
public record FilePart(string SlotName) : IPart;

/// <summary>Repräsentiert einen JSON-Teil im Export mit einem Wert, der Slots enthalten kann.</summary>
[ObjectType]
public record JsonPart(IJsonValueWithSlots Value) : IPart;

/// <summary>Interface für JSON-Werte, die Slots enthalten können.</summary>
[UnionType]
[JsonDerivedType(typeof(JsonObject), typeDiscriminator: "object")]
[JsonDerivedType(typeof(JsonSlotValue), typeDiscriminator: "slotValue")]
[JsonDerivedType(typeof(JsonStringValue), typeDiscriminator: "stringValue")]
public interface IJsonValueWithSlots { }

/// <summary>Repräsentiert ein JSON-Objekt mit einer Liste von Feldern.</summary>
[ObjectType]
public record JsonObject(List<JsonField> Fields) : IJsonValueWithSlots;

/// <summary>Repräsentiert ein Feld in einem JSON-Objekt mit Namen und Wert.</summary>
public record JsonField(string Name, IJsonValueWithSlots Value);

/// <summary>Repräsentiert einen JSON-Wert, der auf einen Slot verweist.</summary>
[ObjectType]
public record JsonSlotValue(string SlotName) : IJsonValueWithSlots;

/// <summary>Repräsentiert einen einfachen JSON-String-Wert.</summary>
[ObjectType]
public record JsonStringValue(string Value) : IJsonValueWithSlots;

/// <summary>Prozessschritt, der auf eine Antwort des GovManagers wartet.</summary>
[ObjectType]
public class WarteAufGovManagerSchritt : Schritt {
    /// <summary>Definiert die Slots, die in diesem Schritt verwendet werden.</summary>
    public override IEnumerable<Slot> Slots => [
        new() { Name = "govmanager-body", ValueType = SlotValueType.String, Encrypted = false },
    ];

    /// <summary>Gibt an, dass die Erledigung dieses Schritts nicht durch den Bürger erfolgt.</summary>
    public override bool ErledigungDurchBuerger => false;

    /// <summary>Referenz auf den zugehörigen GovManager-Export-Schritt.</summary>
    public GovManagerRestExportSchritt GovManagerSchritt { get; init; } = null!;

    /// <summary>ID des zugehörigen GovManager-Export-Schritts.</summary>
    public Guid GovManagerSchrittId { get; init; }
}
