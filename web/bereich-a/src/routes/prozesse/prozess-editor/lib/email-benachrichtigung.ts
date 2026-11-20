import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type ZustaendigkeitCatalog} from './validate-prozess.ts';

type Zustaendigkeit = {
  art: ZustaendigkeitArt;
  mitarbeiterGruppeId?: string | null;
  dienstleisterId?: string | null;
};

type EmailCatalog = Pick<
  ZustaendigkeitCatalog,
  'mitarbeiterGruppenWithoutEmail' | 'dienstleisterWithoutEmail'
>;

/** Rule: which steps offer the "Antrag eingegangen" notification. */
export const supportsEmailNotification = ({
  art,
  mitarbeiterGruppeId,
}: Zustaendigkeit): boolean => {
  switch (art) {
    case ZustaendigkeitArt.Buerger:
      return false;
    case ZustaendigkeitArt.Organisationseinheit:
      return mitarbeiterGruppeId != null;
    case ZustaendigkeitArt.Dienstleister:
      return true;
    case ZustaendigkeitArt.Dynamisch:
      return true;
  }
};

/** The addressee the editor can name. `id` is null while none is chosen yet. */
export type EmailRecipient = {
  kind: 'abteilung' | 'dienstleister';
  id: string | null;
  hasEmail: boolean;
};

/** Null when the editor cannot name an addressee: Bürger, OE without Abteilung, Dynamisch. */
export const emailRecipient = (
  {art, mitarbeiterGruppeId, dienstleisterId}: Zustaendigkeit,
  catalog?: EmailCatalog | null,
): EmailRecipient | null => {
  switch (art) {
    case ZustaendigkeitArt.Organisationseinheit:
      return mitarbeiterGruppeId == null
        ? null
        : recipient(
            'abteilung',
            mitarbeiterGruppeId,
            catalog?.mitarbeiterGruppenWithoutEmail,
          );
    case ZustaendigkeitArt.Dienstleister:
      return recipient(
        'dienstleister',
        dienstleisterId ?? null,
        catalog?.dienstleisterWithoutEmail,
      );
    case ZustaendigkeitArt.Buerger:
    case ZustaendigkeitArt.Dynamisch:
      return null;
  }
};

const recipient = (
  kind: EmailRecipient['kind'],
  id: string | null,
  withoutEmail: Set<string> | undefined,
): EmailRecipient => ({
  kind,
  id,
  hasEmail: id != null && !withoutEmail?.has(id),
});
