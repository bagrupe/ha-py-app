import {
  DetailList,
  Heading,
  Layout,
  Paragraph,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables(
  ["TextContent", "ProzessName", "Organisationseinheit", "Abteilung", "Datum"],
  {
    TextContent:
      "Sehr geehrte Damen und Herren,<br/>" +
      "<br/>" +
      "anbei erhalten Sie eine Meldung über einen Mangel mit folgenden Angaben:",
    ProzessName: "Mängelmelder",
    Organisationseinheit: "Fachbereich 5 Bauen und Umwelt",
    Abteilung: "Abt. 52 Verkehrsplanung, Straßenwesen, Radverkehr",
    Datum: "12.02.2025",
  },
);

export const MaengelMeldungEmail = () => (
  <Layout preview="Meldung aus der Ha-Py App, alle Angaben finden Sie im angehängten PDF.">
    <Heading>Meldung aus der Ha-Py App</Heading>
    <p
      style={{
        margin: "0 0 8px 0",
        fontSize: "15px",
        lineHeight: "24px",
        color: "#374151",
        fontFamily: "Mulish, Arial, Helvetica, sans-serif",
      }}
      dangerouslySetInnerHTML={{ __html: variables.TextContent }}
    ></p>
    <DetailList
      rows={[
        { label: "Antragsart", value: variables.ProzessName },
        { label: "Zuständige Organisationseinheit", value: variables.Organisationseinheit },
        { label: "Zuständige Abteilung", value: variables.Abteilung },
        { label: "Eingegangen am", value: variables.Datum },
      ]}
    />
    <Paragraph>
      Alle Angaben und Fotos zur Meldung finden Sie im angehängten
      PDF-Dokument „export.pdf“.
    </Paragraph>
  </Layout>
);

export default MaengelMeldungEmail;
