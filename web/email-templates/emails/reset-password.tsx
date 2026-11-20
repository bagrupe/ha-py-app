import {
  ActionButton,
  Heading,
  Layout,
  Paragraph,
  SmallText,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables(["ResetUrl"], {
  ResetUrl: "#",
});

export const ResetPasswordEmail = () => (
  <Layout preview="Legen Sie ein neues Passwort für das Backoffice der Ha-Py App fest.">
    <Heading>Passwort zurücksetzen</Heading>
    <Paragraph>Guten Tag,</Paragraph>
    <Paragraph>
      für Ihren Zugang zum Backoffice der Ha-Py App wurde ein neues Passwort
      angefordert. Über die Schaltfläche legen Sie es fest. Der Link ist 24
      Stunden gültig.
    </Paragraph>
    <ActionButton href={variables.ResetUrl}>
      Neues Passwort festlegen
    </ActionButton>
    <Paragraph>
      Sie haben kein neues Passwort angefordert? Dann können Sie diese E-Mail
      ignorieren. Ihr Passwort bleibt unverändert.
    </Paragraph>
    <SmallText>
      Funktioniert die Schaltfläche nicht? Kopieren Sie diesen Link in die
      Adresszeile Ihres Browsers:
      <br />
      {variables.ResetUrl}
    </SmallText>
  </Layout>
);

export default ResetPasswordEmail;
