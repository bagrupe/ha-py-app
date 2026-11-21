using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using API.Features.Expressions;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>Abstrakte Basisklasse für Prozesse, die für Nutzer sichtbar und bearbeitbar sind.</summary>
[InterfaceType]
[GraphQLDescription("Basis für alle Prozesse, die für Nutzer sichtbar und bearbeitbar sind.")]
public abstract class UserFacingProzess {
    public Guid Id { get; init; }

    [GraphQLDescription("Anzeigename des Prozesses.")]
    public required string Name { get; set; }

    [GraphQLDescription("Kommune, der der Prozess zugeordnet ist.")]
    public Kommune.Kommune Kommune { get; init; } = null!;

    [GraphQLDescription("ID der zugeordneten Kommune.")]
    public Guid KommuneId { get; init; }

    [GraphQLDescription("Gruppe, der der Prozess zugeordnet ist. Steuert die Veröffentlichung in der App.")]
    public ProzessGroup? Group { get; set; } = null;

    public Guid? GroupId { get; set; } = null;
}

/// <summary>Konkrete Prozessklasse mit Versionen und Tags zur Kategorisierung.</summary>
[ObjectType]
[GraphQLDescription("Repräsentiert einen Prozess, der konkret in ProzessVersionen definiert wird.")]
public class Prozess : UserFacingProzess {
    [GraphQLIgnore]
    public ICollection<ProzessVersion> Versionen { get; set; } = new HashSet<ProzessVersion>();

    [GraphQLDescription("Tags zur Kategorisierung des Prozesses.")]
    public ICollection<ProzessTag> Tags { get; set; } = new HashSet<ProzessTag>();

    /// <summary>Append-only, im Gegensatz zu <see cref="Tags"/> nie entfernt, auch nicht beim Umhängen eines Tags.</summary>
    [GraphQLIgnore]
    public ICollection<ProzessTagHistorieEintrag> TagHistorie { get; init; } = new HashSet<ProzessTagHistorieEintrag>();

    [GraphQLDescription("Zeitpunkt, zu dem der Prozess deaktiviert wurde. Bürger:innen können danach keine neuen Anträge mehr starten und der Prozess erscheint nicht mehr in der App. Null bedeutet: aktiv.")]
    public Instant? DeaktiviertAm { get; set; }
}

/// <summary>Repräsentiert ein Tag zur Kategorisierung von Prozessen.</summary>
[GraphQLDescription("Tag zur Kategorisierung von Prozessen.")]
public class ProzessTag {
    public Guid Id { get; init; }

    [GraphQLDescription("Name des Tags.")]
    public string Tag { get; init; } = "";

    [GraphQLDescription("Prozesse, die mit diesem Tag versehen sind.")]
    public ICollection<Prozess> Prozesse { get; init; } = new HashSet<Prozess>();
}

/// <summary>Wird nie gelöscht, auch nicht wenn das Tag später auf einen anderen Prozess umgehängt wird.</summary>
public class ProzessTagHistorieEintrag {
    public Guid Id { get; init; }

    public Guid ProzessId { get; init; }
    public Prozess Prozess { get; init; } = null!;

    public Guid TagId { get; init; }
    public ProzessTag Tag { get; init; } = null!;

    public Instant ZugewiesenAm { get; init; }
}

/// <summary>Konfiguration der Entity Framework Core Entity für ProzessTagHistorieEintrag.</summary>
public class ProzessTagHistorieEintragEntityTypeConfiguration : IEntityTypeConfiguration<ProzessTagHistorieEintrag> {
    public void Configure(EntityTypeBuilder<ProzessTagHistorieEintrag> builder) {
        builder.HasOne(h => h.Prozess).WithMany(p => p.TagHistorie).HasForeignKey(h => h.ProzessId);
        builder.HasOne(h => h.Tag).WithMany().HasForeignKey(h => h.TagId);
        builder.HasIndex(h => new { h.ProzessId, h.TagId }).IsUnique();
    }
}

/// <summary>Gruppe zur organisatorischen Kategorisierung von Prozessen innerhalb einer Kommune.</summary>
[GraphQLDescription("Gruppe zur Kategorisierung von Prozessen.")]
public class ProzessGroup {
    public Guid Id { get; init; }

    public string Name { get; set; } = "";

    [GraphQLDescription("Prozesse, die zu dieser Gruppe gehören.")]
    public ICollection<UserFacingProzess> Prozesse { get; set; } = new HashSet<UserFacingProzess>();

    [GraphQLDescription("Kommune, zu der die Gruppe gehört.")]
    public Kommune.Kommune Kommune { get; init; } = null!;

    public Guid KommuneId { get; init; }
}

/// <summary>Definiert eine Rolle, die in Prozessschritten als Zuständigkeit verwendet wird.</summary>
[GraphQLDescription("Rolle, die als Zuständigkeit in einem Prozessschritt gesetzt oder gelesen werden kann.")]
public class ZustaendigkeitRolle {
    public Guid Id { get; init; }

    public string Name { get; init; } = "";
}

/// <summary>Repräsentiert eine Version eines Prozesses mit zugehörigen Schritten und Rollen.</summary>
[GraphQLDescription("Stellt eine Version eines Prozesses dar, die eine Sammlung von Schritten enthält, die in einer bestimmten Reihenfolge ausgeführt werden.")]
public class ProzessVersion {
    public Guid Id { get; init; }

    [GraphQLDescription("Zeitpunkt der Erstellung der Version.")]
    public Instant? CreatedAt { get; set; }

    [GraphQLDescription("Zeitpunkt der Veröffentlichung der Version. Null wenn noch nicht veröffentlicht.")]
    public Instant? PublishedAt { get; set; }

    [GraphQLDescription("ID des zugehörigen Prozesses.")]
    public Guid ProzessId { get; set; }

    [GraphQLDescription("Der zugehörige Prozess.")]
    public required Prozess Prozess { get; init; }

    [GraphQLDescription("Start-Schritt der Prozessversion.")]
    [ForeignKey(nameof(StartId))]
    public Schritt? Start { get; set; }

    [GraphQLIgnore]
    public Guid? StartId { get; set; }

    [GraphQLIgnore]
    public ICollection<Schritt> Schritte { get; set; } = new HashSet<Schritt>();

    [GraphQLDescription("Rollen, die von Schritten in dieser Prozessversion verwendet werden.")]
    public ICollection<ZustaendigkeitRolle> Rollen { get; set; } = new HashSet<ZustaendigkeitRolle>();

    public required StringExpression Beschreibungstext { get; set; } = null!;
}

/// <summary>Konfiguration der Entity Framework Core Entity für ProzessVersion.</summary>
public class ProzessVersionEntityTypeConfiguration : IEntityTypeConfiguration<ProzessVersion> {
    public void Configure(EntityTypeBuilder<ProzessVersion> builder) {
        builder.HasMany(pv => pv.Schritte).WithOne(s => s.ProzessVersion);
        builder.Navigation(pv => pv.Rollen).AutoInclude();
    }
}

/// <summary>Abstrakte Basisklasse für einen Schritt innerhalb einer Prozessversion.</summary>
[InterfaceType]
[GraphQLDescription("Basis eines Schritts in einem Prozess.")]
public abstract class Schritt {
    public Guid Id { get; init; }

    [GraphQLDescription("Prozessversion, zu der dieser Schritt gehört.")]
    public ProzessVersion ProzessVersion { get; init; } = null!;

    public Guid ProzessVersionId { get; init; }

    [GraphQLDescription("Slots (technische Felder), die in diesem Schritt befüllt werden.")]
    [NotMapped] public abstract IEnumerable<Slot> Slots { get; }

    [GraphQLDescription("Titel des Schritts zur Anzeige.")]
    public string? Titel { get; init; }

    [GraphQLDescription("Zusätzliche Anweisung oder Beschreibung zur Anzeige.")]
    public string? Anweisung { get; init; }

    [GraphQLDescription("Freitext-Information zur Anzeige.")]
    public string? Informationstext { get; init; }

    [GraphQLDescription("Visuelle Position (Koordinaten) des Schritts im Editor.")]
    public NodePosition? NodePosition { get; init; }

    [GraphQLDescription("Zuständigkeit in welche der Antrag (Ausfuehrung) übergehen soll, sobald er diesen Schritt erreicht.")]
    public Zustaendigkeit SollZustaendigkeit { get; init; } = null!;

    [GraphQLDescription("Rolle, die beim Bearbeiten dieses Schritts geschrieben wird.")]
    public ZustaendigkeitRolle? SchreibtRolle { get; init; } = null!;
    public Guid? SchreibtRolleId { get; set; } = null;

    [GraphQLDescription("Gibt an, ob beim Betreten des Schritts eine E-Mail an die zuständige Stelle (Abteilung, Dienstleister oder die zur Laufzeit ermittelte Zuständigkeit) gesendet werden soll.")]
    public bool? VersendeEMailAnMitarbeiterGruppe { get; init; }

    [GraphQLDescription("Alle ausgehenden Verbindungen von diesem Schritt zu anderen Schritten.")]
    public ICollection<Verbindung> Verbindungen { get; init; } = new HashSet<Verbindung>();

    [GraphQLDescription("Gibt an, ob dieser Schritt von einem Bürger erledigt wird.")]
    [NotMapped]
    public virtual bool ErledigungDurchBuerger {
        get => SollZustaendigkeit.Art == ZustaendigkeitArt.Buerger;
    }
}

/// <summary>Repräsentiert die visuelle Position eines Schritts im Editor.</summary>
[Owned]
[GraphQLDescription("Visuelle Position eines Schritts im Prozess-Editor.")]
public class NodePosition {
    public double X { get; init; }
    public double Y { get; init; }
}

/// <summary>Verbindet zwei Schritte und steuert den Ablauf mit optionalen Bedingungen.</summary>
[GraphQLDescription("Verbindung zwischen zwei Schritten, steuert den Ablauf und kann Bedingungen enthalten.")]
public class Verbindung {
    public Guid Id { get; init; }
    [GraphQLDescription("Schritt von dem die Verbindung ausgeht.")]
    public Schritt Von { get; init; } = null!;
    [GraphQLDescription("ID des Ausgangs-Schritts.")]
    public Guid VonId { get; init; }
    [GraphQLDescription("Schritt zu dem die Verbindung führt.")]
    public Schritt Nach { get; init; } = null!;
    [GraphQLDescription("ID des Ziel-Schritts.")]
    public Guid NachId { get; init; }
    [GraphQLDescription("Optionaler Name der Verbindung. Wird im Backoffice als Button angezeigt.")]
    public string? Name { get; init; }
    [GraphQLDescription("Optionaler Titel der Statusänderung, die durch diese Verbindung ausgelöst wird.")]
    public string? StatusAenderung { get; init; }
    [GraphQLDescription("Optionale Beschreibung der Statusänderung.")]
    public string? StatusAenderungBeschreibung { get; init; }
    [GraphQLDescription("Bedingung (Expression Language), unter der diese Verbindung aktiviert werden kann. Beispiel: slot(\"feld\") == \"Wert\".")]
    public BoolExpression IstRelevant { get; init; } = true;
}

/// <summary>Konfiguration der Entity Framework Core Entity für Verbindung.</summary>
public class VerbindungConfig : IEntityTypeConfiguration<Verbindung> {
    public void Configure(EntityTypeBuilder<Verbindung> builder) {
        builder.HasOne(e => e.Von).WithMany(e => e.Verbindungen);
        builder.HasOne(e => e.Nach);
    }
}

/// <summary>Beschreibt ein einzelnes Formularfeld (Slot) in einem Schritt.</summary>
[GraphQLDescription("Slot beschreibt ein einzelnes Formularfeld in einem Schritt. Slots können in Expressions referenziert werden.")]
public class Slot {
    [GraphQLDescription("Technischer Name des Slots, wird in Expressions als Referenz verwendet.")]
    public required string Name { get; init; }
    [GraphQLDescription("Gibt an, ob der Wert verschlüsselt gespeichert wird.")]
    public bool Encrypted { get; init; } = true;
    [GraphQLDescription("Datentyp des Slots (z.B. String, Upload, Boolean, etc.).")]
    public required SlotValueType ValueType { get; init; }
    [GraphQLDescription("Gibt an, ob das Feld optional ist.")]
    public bool Optional { get; init; } = false;
    [GraphQLDescription("Gibt an, ob z.B. für Uploads eine Freigabe im Backoffice erforderlich ist.")]
    public bool BrauchtFreigabe { get; init; } = false;
    [GraphQLDescription("Gibt an, ob der Wert für Dritte bei öffentlichen Ausführungen sichtbar ist.")]
    public bool OeffentlichSichtbar { get; init; } = false;
}

/// <summary>Datentypen für Slots in Formularfeldern.</summary>
public enum SlotValueType {
    Location,
    String,
    Upload,
    Boolean,
    Date,
    Signature,
    Time,
    ReadOnly
}

/// <summary>Typen der String-Validierung für Formularfelder.</summary>
public enum StringValidationType {
    Default,
    Iban,
}

/// <summary>Formularschritt mit konfigurierbaren Feldern, die Slots bereitstellen.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht das Erfassen von Nutzereingaben über konfigurierbare Felder, welche mit Slots in Schritten verknüpft sind.")]
public class FormularSchritt : Schritt {
    [GraphQLDescription("Slots, die in diesem Schritt befüllt oder erzeugt werden können.")]
    public override IEnumerable<Slot> Slots => Felder.Select(f => new Slot {
        Name = f.SlotName,
        Encrypted = f.Encrypted,
        ValueType = f.SlotValueType,
        Optional = f.SlotValueType == SlotValueType.ReadOnly || !f.Pflichtfeld || !f.IstRelevant.AlwaysTrue,
        BrauchtFreigabe = (f is UploadFormularFeld { BrauchtFreigabe: true }),
        OeffentlichSichtbar = f.OeffentlichSichtbar
    });

    [GraphQLIgnore] public required ICollection<FormularFeld> Felder { get; init; } = new List<FormularFeld>();
}

/// <summary>Konfiguration der Entity Framework Core Entity für FormularSchritt.</summary>
public class FormularSchrittConfiguration : IEntityTypeConfiguration<FormularSchritt> {
    public void Configure(EntityTypeBuilder<FormularSchritt> builder) {
        builder.Navigation(e => e.Felder).AutoInclude();
    }
}

/// <summary>Abstrakte Basisklasse für ein Formularfeld mit technischem Slot-Namen und Anzeigeinformationen.</summary>
[InterfaceType]
[GraphQLDescription("Repräsentiert ein einzelnes Formularfeld, das in einem Formularschritt verwendet wird. Jedes Feld hat einen technischen Slot-Namen (für Verwendung in Expressions) und zusätzlich eine Bezeichnung.")]
public abstract class FormularFeld {
    public Guid Id { get; init; }

    [GraphQLDescription("Technischer Name des Slots, unter dem das Feld im Prozess und in Expressions referenziert wird.")]
    public required string SlotName { get; init; }

    [GraphQLDescription("Typ des Felds (z.B. String, Upload, Boolean, etc.).")]
    public abstract SlotValueType SlotValueType { get; }

    [GraphQLDescription("Angezeigter Name des Feldes im UI.")]
    public string? AngezeigterName { get; init; }

    [GraphQLDescription("Zusätzliche Anweisung für das Feld.")]
    public string? Anweisung { get; init; }

    [GraphQLDescription("Zugehöriger Formularschritt.")]
    public FormularSchritt Schritt { get; init; } = null!;

    [GraphQLDescription("ID des zugehörigen Formularschritts.")]
    public Guid SchrittId { get; init; }

    [GraphQLDescription("Reihenfolge (Index) des Feldes im Formular.")]
    public required int Order { get; init; }

    [GraphQLDescription("Gibt an, ob der Wert verschlüsselt gespeichert wird.")]
    public bool Encrypted { get; init; } = true;

    [GraphQLDescription("Optionales Tag für inhaltliche Gruppierung oder Auswertung.")]
    public string? InhaltsTag { get; init; }

    [GraphQLDescription("Bedingung (Expression Language), unter der das Feld im Formular angezeigt wird.")]
    public BoolExpression IstRelevant { get; init; } = true;

    [GraphQLDescription("Gibt an ob das Feld optional ist.")]
    [DefaultValue(true)]
    public bool Pflichtfeld { get; set; } = false;

    [GraphQLDescription("Gibt an, ob der Wert bei öffentlichen Ausführungen (z.B. Mängelmelder) für Dritte sichtbar ist.")]
    public bool OeffentlichSichtbar { get; set; } = false;
}


/// <summary>Option einer Checkbox-Liste mit Schlüssel, Label, Reihenfolge und Standardwert.</summary>
[method: JsonConstructor]
[method: SetsRequiredMembers]
public class CheckboxListFeldOption(string key, string label, int order, bool defaultChecked = false) {
    public required string Key { get; set; } = key;
    public required string Label { get; set; } = label;
    public required int Order { get; set; } = order;
    public bool DefaultChecked { get; set; } = defaultChecked;
    [GraphQLIgnore] public CheckboxListFormularFeld Feld { get; set; } = default!;

    [SetsRequiredMembers]
    public CheckboxListFeldOption(string key, int order, bool defaultChecked = false) : this(key, key, order, defaultChecked) {
    }
}

/// <summary>Formularfeld für eine Auswahl mehrerer Optionen mittels Checkboxen.</summary>
[ObjectType]
[GraphQLDescription("Ein Feld, das eine Auswahl mehrerer Optionen per Checkbox ermöglicht.")]
public class CheckboxListFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.String;

    [GraphQLDescription("Liste der auswählbaren Optionen für die Checkbox-Liste.")]
    [Column(TypeName = "jsonb")]
    public required List<CheckboxListFeldOption> Options { get; set; } = new();
}

/// <summary>Formularfeld für Texteingabe mit optionalen Auswahlmöglichkeiten und Validierung.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht die Eingabe von (mehrzeiligem) Text oder die Auswahl aus vordefinierten Optionen.")]
public class StringFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.String;

    [GraphQLDescription("Gibt an, ob das Feld mehrzeilig ist (Textarea).")]
    public bool Multiline { get; init; } = false;

    [GraphQLDescription("Liste der auswählbaren Optionen für das Textfeld.")]
    [Column(TypeName = "jsonb")]
    public List<StringFormularFeldOption> Options { get; init; } = [];

    [GraphQLDescription("Validierungs-Typ für das Textfeld, z.B. IBAN oder Default.")]
    public StringValidationType ValidationType { get; init; } = StringValidationType.Default;

    [GraphQLDescription("Gibt an, ob die App für dieses Auswahlfeld samt Folgefeldern eine Suche anbietet.")]
    public bool Durchsuchbar { get; init; } = false;
}


/// <summary>Option für StringFormularFeld mit Schlüssel und Wert.</summary>
[JsonConverter(typeof(StringFormularFeldOptionJsonConverter))]
public class StringFormularFeldOption {
    public string Key { get; init; }
    public string Value { get; init; }
    [GraphQLIgnore] public StringFormularFeld Feld { get; set; } = default!;

    [GraphQLName("istRelevant")]
    [GraphQLDescription(
        "Optionaler Ausdruck für diese einzelne Option (zusätzlich zur Relevanz des gesamten Feldes): " +
        "ist er gesetzt und ergibt false, ist genau diese Option nicht wählbar, auch wenn das Feld selbst " +
        "relevant ist und andere Optionen weiterhin zur Auswahl stehen.")]
    public BoolExpression? IstRelevant { get; init; }

    public StringFormularFeldOption(string key, string value, BoolExpression? istRelevant = null) {
        this.Key = key;
        this.Value = value;
        this.IstRelevant = istRelevant;
    }

    public StringFormularFeldOption(string key) {
        this.Key = key;
        this.Value = key;
    }
}

/// <summary>
/// Serialisiert <see cref="StringFormularFeldOption"/> für den jsonb-Spalten-Inhalt von
/// <see cref="StringFormularFeld.Options"/> von Hand, weil <see cref="BoolExpression"/> selbst (ANTLR-Parse-
/// Baum) nicht generisch JSON-(de)serialisierbar ist - hier wird nur der rohe Ausdruckstext gespeichert und
/// beim Lesen neu geparst.
/// </summary>
public class StringFormularFeldOptionJsonConverter : JsonConverter<StringFormularFeldOption> {
    public override StringFormularFeldOption Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options) {
        string? key = null, value = null, istRelevantExpression = null;
        while (reader.Read() && reader.TokenType != JsonTokenType.EndObject) {
            if (reader.TokenType != JsonTokenType.PropertyName) continue;
            var propertyName = reader.GetString();
            reader.Read();
            switch (propertyName) {
                case nameof(StringFormularFeldOption.Key): key = reader.GetString(); break;
                case nameof(StringFormularFeldOption.Value): value = reader.GetString(); break;
                case "IstRelevantExpression": istRelevantExpression = reader.GetString(); break;
            }
        }

        return new StringFormularFeldOption(
            key ?? throw new JsonException($"'{nameof(StringFormularFeldOption.Key)}' fehlt."),
            value ?? throw new JsonException($"'{nameof(StringFormularFeldOption.Value)}' fehlt."),
            istRelevantExpression is null ? null : new BoolExpression(istRelevantExpression));
    }

    public override void Write(Utf8JsonWriter writer, StringFormularFeldOption value, JsonSerializerOptions options) {
        writer.WriteStartObject();
        writer.WriteString(nameof(StringFormularFeldOption.Key), value.Key);
        writer.WriteString(nameof(StringFormularFeldOption.Value), value.Value);
        if (value.IstRelevant is { } istRelevant) {
            writer.WriteString("IstRelevantExpression", istRelevant.ExpressionString);
        }
        writer.WriteEndObject();
    }
}

[ObjectType]
[GraphQLDescription("Ermöglicht das Hochladen von Dateien oder Bildern durch den Nutzer.")]
public class UploadFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.Upload;

    [GraphQLDescription("Gibt an, ob eine Freigabe im Backoffice erforderlich ist, bevor die Datei z.B. in der App angezeigt wird.")]
    public bool BrauchtFreigabe { get; init; } = false;

    [GraphQLDescription("Erlaubt das Hochladen mehrerer Dateien gleichzeitig.")]
    public bool Multi { get; init; } = false;

    [GraphQLDescription("Gibt an, ob es sich um ein Dokument handelt (z.B. PDF).")]
    public bool Document { get; init; } = false;

    [GraphQLDescription(
        "Höchstzahl an Dateien, die hochgeladen werden dürfen. Null: unbegrenzt. Nur bei unverschlüsselten " +
        "Feldern serverseitig geprüft, weil verschlüsselte Inhalte nicht gezählt werden können.")]
    public int? MaxAnzahl { get; init; }
}


/// <summary>Formularfeld zur Erfassung eines Standorts mittels Karte oder GPS.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht die Erfassung eines Standorts über eine Karte oder GPS.")]
public class LocationFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.Location;
}


/// <summary>Formularfeld zur Anzeige von statischem Text ohne Eingabemöglichkeit.</summary>
[ObjectType]
[GraphQLDescription("Dient zur Anzeige von statischem Text im Formular, keine Nutzereingabe möglich.")]
public class AnzeigeTextBlockFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.ReadOnly;

    [GraphQLDescription("Anzuzeigender statischer Text.")]
    public String Text { get; init; } = "";
}

/// <summary>Formularfeld zur Auswahl eines Datums.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht die Auswahl eines Datums durch den Nutzer.")]
public class DateFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.Date;
}

/// <summary>Formularfeld zur digitalen Erfassung einer Unterschrift.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht die digitale Erfassung einer Unterschrift.")]
public class SignatureFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.Signature;
}


/// <summary>Formularfeld zur Eingabe oder Auswahl einer Uhrzeit.</summary>
[ObjectType]
[GraphQLDescription("Ermöglicht die Eingabe oder Auswahl einer Uhrzeit.")]
public class TimeFormularFeld : FormularFeld {
    public override SlotValueType SlotValueType => SlotValueType.Time;
}


/// <summary>Schritt, der eine Zahlung anfordert und Transaktionsdaten als Slots bereitstellt.</summary>
[ObjectType]
[GraphQLDescription("Fordert den Nutzer zur Zahlung auf. Enthält Slots für Transaktionsdaten.")]
public class BezahlenSchritt : Schritt {
    public override IEnumerable<Slot> Slots => [
        new Slot { Name = "txId", ValueType = SlotValueType.String, Encrypted = false },
        new Slot { Name = "paymentMethod", ValueType = SlotValueType.String, Encrypted = false },
    ];

    [GraphQLDescription("Zu zahlender Betrag in Euro.")]
    public required Decimal Betrag { get; init; }
}

/// <summary>Schritt, der auf den Abschluss einer Zahlung wartet, bevor der Prozess fortgesetzt wird.</summary>
[ObjectType]
[GraphQLDescription("Wartet auf den Abschluss einer Zahlung, bevor der Prozess fortgesetzt wird.")]
public class WarteAufBezahlungAbgeschlossenSchritt : Schritt {
    public override IEnumerable<Slot> Slots => [
        new Slot { Name = "txId", ValueType = SlotValueType.String, Encrypted = false },
        new Slot { Name = "paymentMethod", ValueType = SlotValueType.String, Encrypted = false },
    ];

    public override bool ErledigungDurchBuerger => false;
    [GraphQLDescription("Bezahlen-Schritt, auf dessen Abschluss gewartet wird.")]
    public BezahlenSchritt BezahlenSchritt { get; init; } = null!;
    public Guid BezahlenSchrittId { get; init; }
}

/// <summary>Ergebnis eines programmatischen Schritts mit der nächsten Verbindungs-ID.</summary>
/// <param name="NextVerbindungGuid">Die Id der zu wählenden nächsten Verbindung.</param>
/// <param name="NaechsteIstZustaendigkeit">
/// Nur relevant, wenn der nächste Schritt eine dynamische Soll-Zuständigkeit hat: die vom programmatischen
/// Schritt ermittelte tatsächliche Zuständigkeit (siehe <see cref="Walker.Step"/>).
/// </param>
public record ProgrammatischerSchrittResult(Guid NextVerbindungGuid, Zustaendigkeit? NaechsteIstZustaendigkeit = null);

/// <summary>Interface für die Ausführung programmatischer Schritte.</summary>
public interface ProgrammatischerSchrittExecutable {
    /// <summary>Führt den programmatischen Schritt asynchron aus.</summary>
    /// <param name="walker">Der Kontext des Prozessdurchlaufs.</param>
    /// <returns>Ergebnis mit der nächsten Verbindungs-ID.</returns>
    public Task<ProgrammatischerSchrittResult> ExecuteAsync(Walker walker);
}

/// <summary>Attribut zur Benennung eines Schritts.</summary>
[AttributeUsage(AttributeTargets.Class, Inherited = false)]
public class SchrittNameAttribute : Attribute {
    public string Name { get; }

    /// <summary>
    /// Markiert einen programmatischen Schritt als geeigneten Vorgänger eines Schritts mit dynamischer
    /// Soll-Zuständigkeit, d.h. seine <see cref="ProgrammatischerSchrittResult.NaechsteIstZustaendigkeit"/>
    /// wird tatsächlich befüllt. Wird im Prozesseditor genutzt, um bei der Auswahl eines programmatischen
    /// Schritts vor einer dynamischen Zuständigkeit nur passende Implementierungen anzubieten.
    /// </summary>
    public bool LiefertZustaendigkeit { get; init; }

    public SchrittNameAttribute(string name) {
        Name = name;
    }
}

/// <summary>Schritt, der automatisch vom System ausgeführt wird, z.B. für Automatisierungen.</summary>
[ObjectType]
[GraphQLDescription("Wird automatisch vom System ausgeführt, z.B. für Weichen, Automatisierungen oder Hintergrundaktionen.")]
public class ProgrammatischerSchritt : Schritt {
    public override IEnumerable<Slot> Slots => Array.Empty<Slot>();
    public override bool ErledigungDurchBuerger => false;

    [GraphQLIgnore] public required string ImplementationAssemblyQualifiedName { get; init; }
}

/// <summary>Schritt, der das Ende eines Prozesses markiert.</summary>
[ObjectType]
[GraphQLDescription("Markiert das Ende eines Prozesses. Nachfolgende Schritte sind nicht möglich.")]
public class EndeSchritt : Schritt {
    public override IEnumerable<Slot> Slots => Array.Empty<Slot>();
    public override bool ErledigungDurchBuerger => false;
}

/// <summary>Schritt, in dem der Bearbeitende eine Freitextnachricht an die aufrufende Person verfasst.</summary>
[ObjectType]
[GraphQLDescription(
    "Ermöglicht dem Bearbeitenden das Verfassen einer Freitextnachricht, die der aufrufenden Person unter Mitteilungen angezeigt wird.")]
public class NachrichtSchritt : Schritt {
    public const string NachrichtSlotName = "nachricht";

    // Unverschlüsselt, damit die Nachricht dem Bürger in der App angezeigt werden kann.
    public override IEnumerable<Slot> Slots => [
        new Slot { Name = NachrichtSlotName, ValueType = SlotValueType.String, Encrypted = false, Optional = true }
    ];

    public override bool ErledigungDurchBuerger => false;

    /// <summary>Liefert den Nachrichtentext aus einer Bearbeitung eines Nachricht-Schritts (null bei leer/whitespace).</summary>
    public static string? NachrichtFrom(Bearbeitung bearbeitung) {
        var value = bearbeitung.SlotValues?
            .OfType<PlainSlotValue>()
            .FirstOrDefault(sv => sv.SlotName == NachrichtSlotName)?.Value;

        var text = value is { ValueKind: JsonValueKind.String } json ? json.GetString() : null;
        return string.IsNullOrWhiteSpace(text) ? null : text;
    }
}

/// <summary>Wird ausgelöst, wenn die Nachricht eines Nachricht-Schritts die konfigurierte Maximallänge überschreitet.</summary>
public class NachrichtTooLongException(int maxLength)
    : DomainException($"Die Nachricht darf höchstens {maxLength} Zeichen lang sein.");

/// <summary>Eingabedaten für Slotwerte mit Umwandlung in SlotValue.</summary>
public record SlotValuesInput(string Name, SlotValuesValueInput Value) {
    /// <summary>Konvertiert die Eingabedaten in ein SlotValue-Objekt.</summary>
    /// <param name="bearbeitung">Die zugehörige Bearbeitung.</param>
    /// <param name="prozessSchritt">Der zugehörige Prozessschritt.</param>
    /// <returns>Instanz von SlotValue entsprechend der Eingabedaten.</returns>
    [GraphQLIgnore]
    public SlotValue ToSlotValue(Bearbeitung bearbeitung, Schritt prozessSchritt) {

        var slot = prozessSchritt.Slots.Where((s) => s.Name == Name).First();
        bool? istFreigegeben = slot.ValueType == SlotValueType.Upload && slot.BrauchtFreigabe ? null : true;


        if (Value.EncryptedValue is { } encryptedValue) {
            return new EncryptedSlotValue { SlotName = Name, Value = encryptedValue, Bearbeitung = bearbeitung, IstFreigegeben = istFreigegeben };
        }

        if (Value.PlainValue is { } plainValue) {
            return new PlainSlotValue { SlotName = Name, Value = plainValue, Bearbeitung = bearbeitung, IstFreigegeben = istFreigegeben };
        }

        throw new InvalidOperationException("Exactly one of EncryptedValue and PlainValue must be present");
    }
}

/// <summary>Repräsentiert den Wert eines Slot-Inputs, entweder verschlüsselt oder im Klartext.</summary>
[OneOf]
public record SlotValuesValueInput(EncryptedValue? EncryptedValue, JsonElement? PlainValue) {
    public static implicit operator SlotValuesValueInput(EncryptedValue encryptedValue) => new(encryptedValue, null);
    public static implicit operator SlotValuesValueInput(JsonElement plainValue) => new(null, plainValue);
    public static implicit operator SlotValuesValueInput(JsonValue plainValue) => new(null, plainValue.ToJsonElement());
}
