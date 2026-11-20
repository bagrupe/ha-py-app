import ResetPasswordEmail from "emails/reset-password.tsx";
import MaengelMeldungEmail from "./emails/maengel-meldung.tsx";
import { render } from "@react-email/render";
import { writeFile } from "fs/promises";
import { resolve } from "path";
import { fileURLToPath } from "url";
import AccountConfirmedEmail from "emails/account-confirmed.tsx";
import { InvitationEmail } from "./emails/invitation.tsx";
import AntragEingegangenEmail from "emails/antrag-eingegangen.tsx";
import { plainTextSelectors } from "@react-email/render";
import AntragWeiterleitenEmail from "emails/antrag-weiterleiten.tsx";
import type { ReactElement } from "react";
import { renderMode } from "utils/render-mode";
import { ANGABEN_TEXT_MARKER, ANGABEN_TEXT_RAZOR } from "components/layout";

type Template = {
  element: ReactElement;
  name: string;
};

const raw = (text: string) =>
  `@Raw($@"${text
    .replaceAll('"', '""')
    .replaceAll("{", "{{")
    .replaceAll("}", "}}")
    .replace(/(?<![\w@])@([A-Za-z_]\w*)/g, "{System.Net.WebUtility.HtmlEncode($1)}")}")`;

// Razor drops HTML comments, so the Outlook conditionals have to pass as raw markup.
const keepConditionalComments = (html: string) =>
  html
    .replace(/<!--\[if mso\]>[\s\S]*?<!\[endif\]-->/g, (m) => raw(m))
    .replaceAll("<!--[if !mso]><!-->", () => raw("<!--[if !mso]><!-->"))
    .replaceAll("<!--<![endif]-->", () => raw("<!--<![endif]-->"));

const templates: Template[] = [
  {
    element: <MaengelMeldungEmail />,
    name: "MaengelMeldungEmail",
  },
  {
    element: <ResetPasswordEmail />,
    name: "ResetPasswordEmail",
  },
  {
    element: <AccountConfirmedEmail />,
    name: "AccountConfirmedEmail",
  },
  {
    element: <InvitationEmail />,
    name: "InvitationEmail",
  },
  {
    element: <AntragEingegangenEmail />,
    name: "AntragEingegangenEmail",
  },
  {
    element: <AntragWeiterleitenEmail />,
    name: "AntragWeiterleitenEmail",
  },
];

const generatedHint =
  "@* This file is generated. Do not edit it directly. Instead, edit the corresponding .tsx file in web/email-templates and run `pnpm export` to update this file.*@\n" +
  "@inherits API.Features.Email.Templates.EmailTemplateBase\n\n";

for (const template of templates) {
  // We can't use pretty printing here, the generated html otherwise breaks in razor templates because of the <!--[if mso]> comments.
  let html = await render(template.element);
  // We don't want to uppercase variables in headings.
  renderMode.plain = true;
  let text = await render(template.element, {
    plainText: true,
    htmlToTextOptions: {
      selectors: [
        ...plainTextSelectors,
        { selector: "table", format: "block" },
        { selector: "tr", format: "block" },
        { selector: "td", format: "inline" },
        ...Array.from({ length: 6 }, (_, i) => ({
          selector: `h${i + 1}`,
          options: { uppercase: false },
        })),
      ],
    },
  });
  renderMode.plain = false;
  text = text.replace(ANGABEN_TEXT_MARKER, ANGABEN_TEXT_RAZOR);
  // In Razor, "@media" would start an expression and has to be written "@@media".
  html = keepConditionalComments(html)
    .replaceAll("@media", "@@media")
    .replace("<html ", '<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" ')
    .replace(
      "</head>",
      () =>
        raw("<!--[if mso]><xml><o:OfficeDocumentSettings><o:AllowPNG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><![endif]-->") +
        "</head>"
    );
  html = generatedHint + html;
  // The logo condition leaves an empty block in the text version.
  text = text.replace(/@if \(!string\.IsNullOrEmpty\(LogoUrl\)\) \{\s*\}\s*/g, "");

  text = generatedHint + text;

  const path = resolve(
    fileURLToPath(import.meta.url),
    `../../../backend/API/Features/Email/Templates/${template.name}.razor`
  );

  await writeFile(path, html, "utf-8");

  const textPath = resolve(
    fileURLToPath(import.meta.url),
    `../../../backend/API/Features/Email/Templates/${template.name}Text.razor`
  );

  await writeFile(textPath, text, "utf-8");
}

console.info(`Exported ${templates.length} mail templates`);
