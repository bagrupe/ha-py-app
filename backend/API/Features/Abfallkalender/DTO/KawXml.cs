using System.Xml.Serialization;

namespace API.Features.Abfallkalender.DTO;

/// <summary>
/// Transfer-Objekt für KAW-XML-Antworten. Enthält verschachtelte Listen, um fehlerhafte XML-Strukturen zu handhaben.
/// </summary>
[XmlRoot("XML")]
public class KawXml {
    /// <summary>
    /// Repräsentiert das SERVLET-Element im XML.
    /// </summary>
    [XmlElement("SERVLET")] public Servlet Servlet { get; set; } = null!;
}

/// <summary>
/// Repräsentiert das DIALOG-Element im XML.
/// </summary>
public class Servlet {
    [XmlElement("DIALOG")] public Dialog Dialog { get; set; } = null!;
}

/// <summary>
/// Repräsentiert die verschiedenen Listen im DIALOG-Element des XML.
/// </summary>
public class Dialog {
    [XmlElement("CITYLIST")] public StaedteList? StaedteList { get; set; }
    [XmlElement("STREETLIST")] public StrassenList? StrassenList { get; set; }
    [XmlElement("NUMBERSLIST")] public StandortList? StandortList { get; set; }
    [XmlElement("TERMINELIST")] public TerminList? TerminList { get; set; }
    [XmlElement("FRAKTIONENLIST")] public FraktionenList? FraktionenList { get; set; }
}

#region Staedte

/// <summary>
/// Repräsentiert die CITYLIST im XML.
/// </summary>
public class StaedteList {
    [XmlElement("CITYLIST")] public StadtListeNested StaedteListeNested { get; set; } = null!;
}

/// <summary>
/// Repräsentiert eine verschachtelte Liste von Städten.
/// </summary>
public class StadtListeNested {
    [XmlElement("CITY")] public Stadt[] Staedte { get; set; } = null!;
}

/// <summary>
/// Repräsentiert eine Stadt mit Name und ID.
/// </summary>
public class Stadt {
    [XmlElement("CITYNAME")] public string Name { get; set; } = null!;
    [XmlElement("IDCITY")] public string Id { get; set; } = null!;
}

#endregion

#region Strassen

/// <summary>
/// Repräsentiert die STREETLIST im XML.
/// </summary>
public class StrassenList {
    [XmlElement("STREETLIST")] public StrassenListNested StrassenListNested { get; set; } = new();
}

/// <summary>
/// Repräsentiert eine verschachtelte Liste von Straßen.
/// </summary>
public class StrassenListNested {
    [XmlElement("STREET")] public Strasse[] Strassen { get; set; } = null!;
}

/// <summary>
/// Repräsentiert eine Straße mit Name und ID.
/// </summary>
public class Strasse {
    [XmlElement("STREETNAME")] public string Name { get; set; } = null!;
    [XmlElement("IDSTREET")] public string Id { get; set; } = null!;
}

#endregion

#region Standorte

/// <summary>
/// Repräsentiert die NUMBERLIST im XML.
/// </summary>
public class StandortList {
    [XmlElement("NUMBERLIST")] public StandortListNested StandortListNested { get; set; } = new();
}

/// <summary>
/// Repräsentiert eine verschachtelte Liste von Standorten.
/// </summary>
public class StandortListNested {
    [XmlElement("NUMBER")] public Standort[] Standorte { get; set; } = null!;
}

/// <summary>
/// Repräsentiert einen Standort mit Nummer, Zusatz und ID.
/// </summary>
public class Standort {
    [XmlElement("NR")] public string Nr { get; set; } = null!;
    [XmlElement("ZUSATZ")] public string Zusatz { get; set; } = null!;
    [XmlElement("IDSTANDORT")] public string Id { get; set; } = null!;
}

#endregion

#region Termine

/// <summary>
/// Repräsentiert die TERMINLIST im XML.
/// </summary>
public class TerminList {
    [XmlElement("TERMINLIST")] public TerminListNested TerminListNested { get; set; } = new();
}

/// <summary>
/// Repräsentiert eine verschachtelte Liste von Terminen.
/// </summary>
public class TerminListNested {
    [XmlElement("TERMIN")] public Termin[] Termine { get; set; } = null!;
}

/// <summary>
/// Repräsentiert einen Termin mit Datum, Typ, Fraktion und weiteren Eigenschaften.
/// </summary>
public class Termin {
    [XmlElement("DATE")] public string Datum { get; set; } = null!;
    [XmlElement("TYPE")] public string Type { get; set; } = null!;
    [XmlElement("BASICDATE")] public string BasisDatum { get; set; } = null!;
    [XmlElement("VERSCHOBEN")] public string? Verschoben { get; set; }
    [XmlElement("FRAKTION")] public string Fraktion { get; set; } = null!;
    [XmlElement("TURNUS")] public string Turnus { get; set; } = null!;
    [XmlElement("TONNENGRUPPE")] public string Tonnengruppe { get; set; } = null!;
    [XmlElement("BEMERK")] public string? Bemerkung { get; set; }
}

#endregion

#region Fraktionen

/// <summary>
/// Repräsentiert die FRAKTIONENLIST im XML.
/// </summary>
public class FraktionenList {
    [XmlElement("FRAKTIONENLIST")] public FraktionenListeNested FraktionenListeNested { get; set; } = new();
}

/// <summary>
/// Repräsentiert eine verschachtelte Liste von Fraktionen.
/// </summary>
public class FraktionenListeNested {
    [XmlElement("FRAKTIONEN")] public Fraktion[] Fraktionen { get; set; } = null!;
}

/// <summary>
/// Repräsentiert eine Fraktion mit ID, Name und optionaler Farbe.
/// </summary>
public class Fraktion {
    [XmlElement("TYPE")] public string Id { get; set; } = null!;
    [XmlElement("TYPENAME")] public string Name { get; set; } = null!;
    [XmlElement("TYPECOL")] public string? Col { get; set; }
}

#endregion
