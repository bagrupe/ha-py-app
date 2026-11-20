import { Body, Head, Html, Preview, Text } from "@react-email/components";
import { blazorVariables } from "utils/blazor-variables";
import { renderMode } from "utils/render-mode";

const BRAND_GREEN = "#74A220";
const BRAND_BLUE = "#2A5CAA";
const FONT = "Mulish, Arial, Helvetica, sans-serif";

const variables = blazorVariables(
  ["LogoUrl", "LogoWidth", "LogoHeight", "KommuneName", "ImpressumUrl", "DatenschutzUrl"],
  {
    KommuneName: "Landkreis Hameln-Pyrmont",
    LogoUrl: "/static/landkreis-hapy-small.png",
    LogoWidth: "180",
    LogoHeight: "103",
    ImpressumUrl: "#",
    DatenschutzUrl: "#",
  },
);

// Apple Mail ignores the size attributes and Outlook the CSS sizes, so both are set.
const px = (name: "LogoWidth" | "LogoHeight") =>
  process.env.NODE_ENV === "production"
    ? `@(${name})px`
    : `${variables[name]}px`;
const logoImg = `<img src="${variables.LogoUrl}" width="${variables.LogoWidth}" height="${variables.LogoHeight}" alt="${variables.KommuneName}" style="display:block;width:${px("LogoWidth")};height:${px("LogoHeight")};max-width:${px("LogoWidth")};border:0;outline:none;text-decoration:none;" />`;
const logoMarkup =
  process.env.NODE_ENV === "production"
    ? `@if (!string.IsNullOrEmpty(LogoUrl)) { ${logoImg} }`
    : logoImg;

type LayoutProps = {
  children?: React.ReactNode;
  preview: string;
};

// Outlook ignores max-width and padding on blocks: fixed table width, padding only on td.
const CONTENT_WIDTH = 720;
const responsiveCss = `:root{color-scheme:light only;supported-color-schemes:light only;}
@media (max-width:600px){
.mail-container{width:100%!important;max-width:100%!important;}
.mail-pad{padding-left:20px!important;padding-right:20px!important;}
.mail-label{display:block!important;width:100%!important;padding-bottom:0!important;border-bottom:0!important;}
.mail-value{display:block!important;width:100%!important;box-sizing:border-box!important;padding-top:2px!important;}
}`;
const bg = (color: string) => ({ bgcolor: color }) as Record<string, string>;
const spacer = (px: number) =>
  ({
    height: `${px}px`,
    lineHeight: `${px}px`,
    fontSize: `${px}px`,
    msoLineHeightRule: "exactly",
  }) as React.CSSProperties;

const FOOTER_BUTTON_WIDTH = 132;
const FOOTER_BUTTON_HEIGHT = 40;

const FooterLink = ({
  href,
  children,
}: {
  href: string;
  children: string;
}) => {
  const html = `<!--[if mso]><v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="${href}" style="height:${FOOTER_BUTTON_HEIGHT}px;v-text-anchor:middle;width:${FOOTER_BUTTON_WIDTH}px;" arcsize="15%" strokecolor="#c9d1db" strokeweight="1px" fillcolor="#ffffff"><w:anchorlock/><center style="color:${BRAND_BLUE};font-family:${FONT};font-size:14px;font-weight:bold;">${children}</center></v:roundrect><![endif]--><!--[if !mso]><!--><a href="${href}" target="_blank" style="display:inline-block;box-sizing:border-box;width:${FOOTER_BUTTON_WIDTH}px;height:${FOOTER_BUTTON_HEIGHT}px;background-color:#ffffff;border:1px solid #c9d1db;border-radius:6px;color:${BRAND_BLUE};font-family:${FONT};font-size:14px;font-weight:bold;line-height:${FOOTER_BUTTON_HEIGHT - 2}px;text-align:center;text-decoration:none;">${children}</a><!--<![endif]-->`;

  return <td align="center" dangerouslySetInnerHTML={{ __html: html }} />;
};

export const Layout = ({ children, preview }: LayoutProps) => (
  <Html lang="de">
    <Head>
      <meta name="x-apple-disable-message-reformatting" />
      <meta name="color-scheme" content="light only" />
      <meta name="supported-color-schemes" content="light only" />
      <style dangerouslySetInnerHTML={{ __html: responsiveCss }} />
    </Head>
    <Preview>{preview}</Preview>
    <Body
      style={{
        margin: 0,
        padding: 0,
        backgroundColor: "#ffffff",
        fontFamily: FONT,
      }}
    >
      <table
        role="presentation"
        width="100%"
        cellPadding={0}
        cellSpacing={0}
        border={0}
        style={{ backgroundColor: "#ffffff" }}
        {...bg("#ffffff")}
      >
        <tbody>
          <tr>
            <td align="center" style={{ padding: "24px 0" }}>
              <table
                role="presentation"
                width={CONTENT_WIDTH}
                className="mail-container"
                cellPadding={0}
                cellSpacing={0}
                border={0}
                style={{
                  width: `${CONTENT_WIDTH}px`,
                  maxWidth: "100%",
                  backgroundColor: "#ffffff",
                  border: "1px solid #e5e7eb",
                }}
                {...bg("#ffffff")}
              >
                <tbody>
                  <tr>
                    <td
                      height={4}
                      style={spacer(4)}
                      {...bg(BRAND_GREEN)}
                    >
                      &nbsp;
                    </td>
                  </tr>
                  <tr>
                    <td
                      align="left"
                      className="mail-pad"
                      style={{ padding: "28px 32px 20px 32px" }}
                      dangerouslySetInnerHTML={{ __html: logoMarkup }}
                    />
                  </tr>
                  <tr>
                    <td
                      align="left"
                      className="mail-pad"
                      style={{
                        padding: "0 32px 32px 32px",
                        fontFamily: FONT,
                      }}
                    >
                      {children}
                    </td>
                  </tr>
                  <tr>
                    <td
                      align="center"
                      className="mail-pad"
                      style={{
                        padding: "24px 32px 24px 32px",
                        borderTop: "1px solid #e5e7eb",
                        backgroundColor: "#f8fafc",
                        fontFamily: FONT,
                        textAlign: "center",
                      }}
                      {...bg("#f8fafc")}
                    >
                      <table
                        role="presentation"
                        align="center"
                        cellPadding={0}
                        cellSpacing={0}
                        border={0}
                        style={{ margin: "0 auto" }}
                      >
                        <tbody>
                          <tr>
                            <FooterLink href={variables.DatenschutzUrl}>
                              Datenschutz
                            </FooterLink>
                            <td width={12} style={{ width: "12px" }}>
                              &nbsp;
                            </td>
                            <FooterLink href={variables.ImpressumUrl}>
                              Impressum
                            </FooterLink>
                          </tr>
                        </tbody>
                      </table>
                      <table
                        role="presentation"
                        cellPadding={0}
                        cellSpacing={0}
                        border={0}
                        width="100%"
                      >
                        <tbody>
                          <tr>
                            <td
                              align="center"
                              style={{
                                paddingTop: "18px",
                                fontSize: "13px",
                                lineHeight: "19px",
                                color: "#6b7280",
                                fontFamily: FONT,
                                textAlign: "center",
                              }}
                            >
                              Diese E-Mail wurde automatisch von der Ha-Py App
                              des Landkreises Hameln-Pyrmont versendet. Bitte
                              antworten Sie nicht auf diese Nachricht.
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
        </tbody>
      </table>
    </Body>
  </Html>
);

export const Heading = ({ children }: { children: React.ReactNode }) => (
  <h1
    style={{
      margin: "0 0 16px 0",
      fontSize: "22px",
      lineHeight: "30px",
      fontWeight: "bold",
      color: "#1f2937",
      fontFamily: FONT,
    }}
  >
    {children}
  </h1>
);

export const Paragraph = ({ children }: { children: React.ReactNode }) => (
  <Text
    style={{
      margin: "0 0 16px 0",
      fontSize: "15px",
      lineHeight: "24px",
      color: "#374151",
      fontFamily: FONT,
    }}
  >
    {children}
  </Text>
);

export const SmallText = ({ children }: { children: React.ReactNode }) => (
  <Text
    style={{
      margin: "16px 0 0 0",
      fontSize: "13px",
      lineHeight: "20px",
      color: "#6b7280",
      fontFamily: FONT,
    }}
  >
    {children}
  </Text>
);

export const ActionButton = ({
  href,
  children,
}: {
  href: string;
  children: string;
}) => {
  const width = Math.round(children.length * 9.5 + 64);
  const html = `<!--[if mso]><v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="urn:schemas-microsoft-com:office:word" href="${href}" style="height:48px;v-text-anchor:middle;width:${width}px;" arcsize="14%" stroke="f" fillcolor="${BRAND_GREEN}"><w:anchorlock/><center style="color:#ffffff;font-family:Mulish,Arial,Helvetica,sans-serif;font-size:15px;font-weight:bold;">${children}</center></v:roundrect><![endif]--><!--[if !mso]><!--><a href="${href}" target="_blank" style="display:inline-block;background-color:${BRAND_GREEN};border-radius:6px;color:#ffffff;font-family:Mulish,Arial,Helvetica,sans-serif;font-size:15px;font-weight:bold;line-height:48px;padding:0 32px;text-decoration:none;">${children}</a><!--<![endif]-->`;

  return (
    <table
      role="presentation"
      cellPadding={0}
      cellSpacing={0}
      border={0}
      width="100%"
    >
      <tbody>
        <tr>
          <td height={24} style={spacer(24)}>
            &nbsp;
          </td>
        </tr>
        <tr>
          <td align="center" dangerouslySetInnerHTML={{ __html: html }} />
        </tr>
        <tr>
          <td height={16} style={spacer(16)}>
            &nbsp;
          </td>
        </tr>
      </tbody>
    </table>
  );
};

export const DetailList = ({
  rows,
}: {
  rows: { label: string; value: React.ReactNode }[];
}) => (
  <table
    role="presentation"
    cellPadding={0}
    cellSpacing={0}
    border={0}
    width="100%"
    style={{
      margin: "8px 0 16px 0",
      borderTop: "1px solid #e5e7eb",
    }}
  >
    <tbody>
      {rows.map((row) => (
        <tr key={row.label}>
          <td
            className="mail-label"
            width="38%"
            valign="top"
            style={{
              padding: "6px 12px 6px 0",
              borderBottom: "1px solid #e5e7eb",
              fontSize: "13px",
              lineHeight: "20px",
              color: "#6b7280",
              fontFamily: FONT,
            }}
          >
            {row.label}:{"\u00a0"}
          </td>
          <td
            className="mail-value"
            valign="top"
            style={{
              padding: "6px 0",
              borderBottom: "1px solid #e5e7eb",
              fontSize: "14px",
              lineHeight: "20px",
              color: "#1f2937",
              fontFamily: FONT,
            }}
          >
            {row.value}
          </td>
        </tr>
      ))}
    </tbody>
  </table>
);

const angabeCell = (width: string, color: string, size: string) =>
  `padding:6px 12px 6px 0;border-bottom:1px solid #e5e7eb;font-size:${size};line-height:20px;color:${color};font-family:${FONT};vertical-align:top;${width}`;

export const ANGABEN_TEXT_MARKER = "§ANGABEN§";
export const ANGABEN_TEXT_RAZOR =
  "@if (Angaben.Count > 0) {\n@:Angaben zum Antrag:\n@foreach (var angabe in Angaben) {\n@:@angabe.Label: @angabe.Value\n}\n}";

export const Angaben = ({
  preview,
}: {
  preview: { label: string; value: string }[];
}) => {
  if (renderMode.plain) {
    return <p>{ANGABEN_TEXT_MARKER}</p>;
  }

  const rows =
    process.env.NODE_ENV === "production"
      ? `@foreach (var angabe in Angaben) { <tr><td class="mail-label" width="38%" style="${angabeCell("", "#6b7280", "13px")}">@angabe.Label:&nbsp;</td><td class="mail-value" style="${angabeCell("white-space:pre-wrap;", "#1f2937", "14px")}">@angabe.Value</td></tr> }`
      : preview
          .map(
            (r) =>
              `<tr><td class="mail-label" width="38%" style="${angabeCell("", "#6b7280", "13px")}">${r.label}:&nbsp;</td><td class="mail-value" style="${angabeCell("white-space:pre-wrap;", "#1f2937", "14px")}">${r.value}</td></tr>`,
          )
          .join("");

  const html = `<p style="margin:16px 0 4px 0;font-size:14px;line-height:20px;font-weight:bold;color:#1f2937;font-family:${FONT};">Angaben zum Antrag</p><table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="margin:0 0 16px 0;border-top:1px solid #e5e7eb;"><tbody>${rows}</tbody></table>`;

  return (
    <div
      dangerouslySetInnerHTML={{
        __html:
          process.env.NODE_ENV === "production"
            ? `@if (Angaben.Count > 0) { ${html} }`
            : html,
      }}
    />
  );
};
