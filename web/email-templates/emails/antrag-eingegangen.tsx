import {
  ActionButton,
  Angaben,
  DetailList,
  Heading,
  Layout,
  Paragraph,
  SmallText,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables(
  [
    "ProzessName",
    "AntragUrl",
    "Organisationseinheit",
    "Abteilung",
    "AusfuehrungId",
    "Datum",
  ],
  {
    AntragUrl: "/antraege/6615c5cb-dce0-49df-aa9b-b3d0f8d1f538",
    ProzessName: "Mängelmelder",
    Organisationseinheit: "Fachbereich 5 Bauen und Umwelt",
    Abteilung: "Abt. 52 Verkehrsplanung, Straßenwesen, Radverkehr",
    AusfuehrungId: "6615c5cb-dce0-49df-aa9b-b3d0f8d1f538",
    Datum: "12.02.2025",
  },
);

export const AntragEingegangenEmail = () => (
  <Layout preview="Ein neuer Antrag wartet im Backoffice der Ha-Py App auf Ihre Bearbeitung.">
    <Heading>Neuer Antrag zur Bearbeitung</Heading>
    <Paragraph>Guten Tag,</Paragraph>
    <Paragraph>
      in der Ha-Py App ist ein Antrag vom Typ „{variables.ProzessName}“
      eingegangen, für den Ihre Stelle zuständig ist. Bitte öffnen Sie ihn im
      Backoffice und bearbeiten Sie ihn dort.
    </Paragraph>
    <DetailList
      rows={[
        { label: "Antragsart", value: variables.ProzessName },
        { label: "Organisationseinheit", value: variables.Organisationseinheit },
        { label: "Abteilung", value: variables.Abteilung },
        { label: "Eingegangen am", value: variables.Datum },
      ]}
    />
    <Angaben
      preview={[
        { label: "Titel", value: "Schlagloch auf der Hauptstraße" },
        { label: "Kategorie", value: "Straßenschäden" },
        { label: "Beschreibung", value: "Tiefes Schlagloch in Höhe Hausnummer 12." },
      ]}
    />
    <ActionButton href={variables.AntragUrl}>Antrag im Backoffice öffnen</ActionButton>
    <SmallText>
      Für die Anmeldung im Backoffice benötigen Sie Ihre persönlichen
      Zugangsdaten.
      <br />
      Antragsnummer: {variables.AusfuehrungId}
    </SmallText>
  </Layout>
);

export default AntragEingegangenEmail;
