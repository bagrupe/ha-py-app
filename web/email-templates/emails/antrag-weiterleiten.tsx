import {
  DetailList,
  Heading,
  Layout,
  Paragraph,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables([
  "ProzessName",
  "Organisationseinheit",
  "Abteilung",
  "AusfuehrungId",
  "Datum",
], {
  Organisationseinheit: "Fachbereich 5 Bauen und Umwelt",
  Abteilung: "Abt. 52 Verkehrsplanung, Straßenwesen, Radverkehr",
  ProzessName: "Mängelmelder",
  AusfuehrungId: "6615c5cb-dce0-49df-aa9b-b3d0f8d1f538",
  Datum: "12.02.2025",
});

export const AntragWeiterleitenEmail = () => (
  <Layout preview="Ein Antrag aus der Ha-Py App wurde an Sie weitergeleitet, die Angaben liegen als PDF bei.">
    <Heading>Weitergeleiteter Antrag</Heading>
    <Paragraph>Sehr geehrte Damen und Herren,</Paragraph>
    <Paragraph>
      anbei erhalten Sie einen Antrag aus der Ha-Py App mit folgenden Angaben:
    </Paragraph>
    <DetailList
      rows={[
        { label: "Antragsart", value: variables.ProzessName },
        { label: "Zuständige Organisationseinheit", value: variables.Organisationseinheit },
        { label: "Zuständige Abteilung", value: variables.Abteilung },
        { label: "Weitergeleitet am", value: variables.Datum },
        { label: "Antragsnummer", value: variables.AusfuehrungId },
      ]}
    />
    <Paragraph>
      Alle Angaben und Anhänge zum Antrag finden Sie im angehängten
      PDF-Dokument „antrag.pdf“.
    </Paragraph>
  </Layout>
);

export default AntragWeiterleitenEmail;
