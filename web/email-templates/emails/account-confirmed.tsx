import {
  ActionButton,
  Heading,
  Layout,
  Paragraph,
} from "components/layout";
import { blazorVariables } from "utils/blazor-variables";

const variables = blazorVariables(["LoginUrl"], {
  LoginUrl: "/auth/login",
});

export const AccountConfirmedEmail = () => (
  <Layout preview="Sie können sich jetzt im Backoffice der Ha-Py App anmelden.">
    <Heading>Ihr Zugang wurde freigegeben</Heading>
    <Paragraph>Guten Tag,</Paragraph>
    <Paragraph>
      eine administrierende Person hat Ihre Registrierung bestätigt. Sie können
      sich ab sofort mit Ihrer E-Mail-Adresse und Ihrem Passwort im Backoffice
      der Ha-Py App anmelden.
    </Paragraph>
    <ActionButton href={variables.LoginUrl}>Im Backoffice anmelden</ActionButton>
  </Layout>
);

export default AccountConfirmedEmail;
