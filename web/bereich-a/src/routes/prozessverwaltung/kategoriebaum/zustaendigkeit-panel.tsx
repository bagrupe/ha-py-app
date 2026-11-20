import * as Tabs from '@radix-ui/react-tabs';
import {useState} from 'react';
import {ZustaendigkeitArt} from 'src/__generated__/graphql';
import {type CollectionItem} from 'src/components/form/fields/collections';
import {SelectField} from 'src/components/form/fields/select-field';
import {Button} from 'src/components/ui/button';
import {type KategorieFragment} from './kategoriebaum.generated.ts';

type Tab =
  | ZustaendigkeitArt.Organisationseinheit
  | ZustaendigkeitArt.Dienstleister
  | 'erbt';

export const ZustaendigkeitPanel = ({
  kategorie,
  gruppenOptionen,
  dienstleisterOptionen,
  onSpeichern,
  onAbbrechen,
  speichernFehlgeschlagen,
}: {
  kategorie: KategorieFragment;
  gruppenOptionen: CollectionItem<string>[];
  dienstleisterOptionen: CollectionItem<string>[];
  onSpeichern: (werte: {
    erbt: boolean;
    art: ZustaendigkeitArt;
    mitarbeiterGruppeId: string | null;
    dienstleisterId: string | null;
  }) => Promise<void>;
  onAbbrechen: () => void;
  speichernFehlgeschlagen: boolean;
}) => {
  const [tab, setTab] = useState<Tab>(
    kategorie.ziel == null
      ? kategorie.istWurzel
        ? ZustaendigkeitArt.Organisationseinheit
        : 'erbt'
      : kategorie.ziel.art === ZustaendigkeitArt.Dienstleister
      ? ZustaendigkeitArt.Dienstleister
      : ZustaendigkeitArt.Organisationseinheit,
  );
  const [mitarbeiterGruppeId, setMitarbeiterGruppeId] = useState(
    kategorie.ziel?.mitarbeiterGruppeId ?? undefined,
  );
  const [dienstleisterId, setDienstleisterId] = useState(
    kategorie.ziel?.dienstleisterId ?? undefined,
  );
  const [speichernLaeuft, setSpeichernLaeuft] = useState(false);
  const istHauptkategorie = kategorie.parentId == null && !kategorie.istWurzel;

  const submit = async () => {
    setSpeichernLaeuft(true);
    try {
      await onSpeichern({
        erbt: tab === 'erbt',
        art:
          tab === ZustaendigkeitArt.Dienstleister
            ? ZustaendigkeitArt.Dienstleister
            : ZustaendigkeitArt.Organisationseinheit,
        mitarbeiterGruppeId: mitarbeiterGruppeId ?? null,
        dienstleisterId: dienstleisterId ?? null,
      });
    } finally {
      setSpeichernLaeuft(false);
    }
  };

  return (
    <div className='flex flex-col gap-3 rounded-md border border-gray-200 bg-gray-50 p-3'>
      <Tabs.Root value={tab} onValueChange={(value) => setTab(value as Tab)}>
        <Tabs.List className='flex overflow-hidden rounded-t-md border border-gray-200'>
          {!kategorie.istWurzel && (
            <Tabs.Trigger
              className='flex grow cursor-pointer select-none items-center justify-center border-b-4 border-transparent bg-white p-2 text-sm leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary focus-visible:bg-primary/10 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary'
              value='erbt'
            >
              {istHauptkategorie
                ? 'Erbt Standard-Zuständigkeit'
                : 'Erbt von Elternkategorie'}
            </Tabs.Trigger>
          )}
          <Tabs.Trigger
            className='flex grow cursor-pointer select-none items-center justify-center border-b-4 border-transparent bg-white p-2 text-sm leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary focus-visible:bg-primary/10 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary'
            value={ZustaendigkeitArt.Organisationseinheit}
          >
            Abteilung
          </Tabs.Trigger>
          <Tabs.Trigger
            className='flex grow cursor-pointer select-none items-center justify-center border-b-4 border-transparent bg-white p-2 text-sm leading-none outline-none first:rounded-tl-md last:rounded-tr-md hover:text-primary focus-visible:bg-primary/10 data-[state=active]:border-primary data-[state=active]:bg-primary-light/20 data-[state=active]:text-primary'
            value={ZustaendigkeitArt.Dienstleister}
          >
            Dienstleister
          </Tabs.Trigger>
        </Tabs.List>
        <div className='rounded-b-md border border-t-0 border-gray-200 bg-white p-3'>
          <Tabs.Content value='erbt'>
            <p className='text-sm text-gray-600'>
              {istHauptkategorie
                ? 'Diese Kategorie übernimmt die Standard-Zuständigkeit dieser Untereinheit.'
                : 'Diese Kategorie übernimmt die Zuständigkeit der nächsten Elternkategorie, die eine eigene festlegt.'}
            </p>
          </Tabs.Content>
          <Tabs.Content value={ZustaendigkeitArt.Organisationseinheit}>
            <SelectField
              label='Abteilung *'
              value={mitarbeiterGruppeId}
              onChange={(value) => setMitarbeiterGruppeId(value ?? undefined)}
              items={gruppenOptionen}
            />
          </Tabs.Content>
          <Tabs.Content value={ZustaendigkeitArt.Dienstleister}>
            <SelectField
              label='Dienstleister *'
              value={dienstleisterId}
              onChange={(value) => setDienstleisterId(value ?? undefined)}
              items={dienstleisterOptionen}
            />
          </Tabs.Content>
        </div>
      </Tabs.Root>

      {speichernFehlgeschlagen && (
        <p className='text-sm text-red-600'>
          Speichern fehlgeschlagen. Bitte Auswahl prüfen.
        </p>
      )}

      <div className='flex gap-2 self-start'>
        <Button
          type='button'
          variant='solid'
          disabled={speichernLaeuft}
          onClick={submit}
        >
          Speichern
        </Button>
        <Button type='button' variant='outlined' onClick={onAbbrechen}>
          Abbrechen
        </Button>
      </div>
    </div>
  );
};
