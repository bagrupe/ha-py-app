import {
  ActionButton,
  Heading,
  Layout,
  Paragraph,
  SmallText,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables(["MandantName", "InviteUrl"], {
  MandantName: "Landkreis Hameln-Pyrmont",
  InviteUrl: "#",
});

export const InvitationEmail = () => (
  <Layout preview="Richten Sie Ihren Zugang zum Backoffice der Ha-Py App ein.">
    <Heading>Einladung zum Backoffice der Ha-Py App</Heading>
    <Paragraph>Guten Tag,</Paragraph>
    <Paragraph>
      Sie wurden eingeladen, das Backoffice der Ha-Py App für{" "}
      {variables.MandantName} zu nutzen. Dort bearbeiten Sie Anträge und
      Meldungen aus der App.
    </Paragraph>
    <Paragraph>
      Mit einem Klick auf die Schaltfläche richten Sie Ihren Zugang ein.
      Anschließend prüft eine administrierende Person Ihre Registrierung. Sie
      erhalten eine weitere E-Mail, sobald Sie sich anmelden können.
    </Paragraph>
    <ActionButton href={variables.InviteUrl}>Zugang einrichten</ActionButton>
    <SmallText>
      Funktioniert die Schaltfläche nicht? Kopieren Sie diesen Link in die
      Adresszeile Ihres Browsers:
      <br />
      {variables.InviteUrl}
    </SmallText>
  </Layout>
);

export default InvitationEmail;
