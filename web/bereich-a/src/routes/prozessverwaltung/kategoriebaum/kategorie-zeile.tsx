import {useState} from 'react';
import {
  MdAdd,
  MdCheck,
  MdChevronRight,
  MdClose,
  MdDelete,
  MdEdit,
  MdExpandMore,
  MdMoreVert,
  MdVisibilityOff,
} from 'react-icons/md';
import {useClient} from 'urql';
import {ZustaendigkeitArt} from 'src/__generated__/graphql';
import {CheckboxField} from 'src/components/form/fields/checkbox-field/checkbox-field.tsx';
import {type CollectionItem} from 'src/components/form/fields/collections';
import {InputField} from 'src/components/form/fields/input-field';
import {Button} from 'src/components/ui/button';
import {ToolTip} from 'src/components/ui/tool-tip.tsx';
import {useConfirm} from '../../../components/modal/confirm-modal.tsx';
import {mutationFailed} from '../../../lib/mutation.ts';
import {
  findeZwilling,
  kollidiertAlsZwilling,
  resolveEffektivesZiel,
  zaehleNachfahren,
} from './kategoriebaum-helpers.ts';
import {
  type KategorieFragment,
  KategorieLoeschVorschauDocument,
  type KategorieLoeschVorschauQuery,
  useKategorieAusblendungSetzenMutation,
  useKategorieCreateMutation,
  useKategorieDeleteMutation,
  useKategorieRenameMutation,
  useKategorieZustaendigkeitSetzenMutation,
} from './kategoriebaum.generated.ts';
import {ZustaendigkeitPanel} from './zustaendigkeit-panel.tsx';

export const KategorieZeile = ({
  kategorie,
  kinderVon,
  kategorieById,
  wurzelZiel,
  untereinheitId,
  istSuperadmin,
  tiefe,
  expandedIds,
  onToggleExpand,
  gruppenOptionen,
  dienstleisterOptionen,
  onChanged,
  offeneAktionenId,
  onToggleAktionen,
}: {
  kategorie: KategorieFragment;
  kinderVon: Map<string | null, KategorieFragment[]>;
  kategorieById: Map<string, KategorieFragment>;
  wurzelZiel: KategorieFragment['ziel'];
  untereinheitId: string;
  istSuperadmin: boolean;
  tiefe: number;
  expandedIds: Set<string>;
  onToggleExpand: (id: string) => void;
  gruppenOptionen: CollectionItem<string>[];
  dienstleisterOptionen: CollectionItem<string>[];
  onChanged: () => void;
  offeneAktionenId: string | null;
  onToggleAktionen: (id: string) => void;
}) => {
  const [editing, setEditing] = useState(false);
  const aktionenOffen = offeneAktionenId === kategorie.id;
  const [nameEntwurf, setNameEntwurf] = useState(kategorie.name);
  const [zustaendigkeitFehlgeschlagen, setZustaendigkeitFehlgeschlagen] =
    useState(false);
  const [addingChild, setAddingChild] = useState(false);
  const [neuerKindName, setNeuerKindName] = useState('');
  const [neuesKindIstGeteilt, setNeuesKindIstGeteilt] = useState(false);
  const [neuerKindNameFehler, setNeuerKindNameFehler] = useState<string | null>(
    null,
  );
  const [busy, setBusy] = useState(false);

  const [, renameKategorie] = useKategorieRenameMutation();
  const [, setZustaendigkeit] = useKategorieZustaendigkeitSetzenMutation();
  const [, createKategorie] = useKategorieCreateMutation();
  const [, deleteKategorie] = useKategorieDeleteMutation();
  const [, ausblenden] = useKategorieAusblendungSetzenMutation();
  const confirm = useConfirm();
  const client = useClient();

  const kinder = kinderVon.get(kategorie.id) ?? [];
  const hatKinder = kinder.length > 0;
  const expanded = expandedIds.has(kategorie.id);
  const eigeneKategorie = kategorie.untereinheitId != null;
  const istWurzel = kategorie.istWurzel;
  // Geteilte Kategorien: Umbenennen/Löschen nur für Superadmins, Zuständigkeit nie (Backend-Regel).
  const kannUmbenennen = !istWurzel && (eigeneKategorie || istSuperadmin);
  const darfLoeschen = !istWurzel && (eigeneKategorie || istSuperadmin);
  // Geteilte Kategorien tragen nie ein eigenes Ziel - eigene Zuständigkeit braucht einen Zwilling.
  const eigenerZwilling = findeZwilling(
    kategorie,
    kategorieById,
    untereinheitId,
  );
  // "Bearbeiten" legt bei geteilten Kategorien ohne Zwilling beim Speichern einen an.
  const kannEigeneZustaendigkeitBearbeiten = !eigeneKategorie;
  const darfBearbeiten =
    !editing &&
    (kannUmbenennen || eigeneKategorie || kannEigeneZustaendigkeitBearbeiten);
  const hatAktionen =
    darfBearbeiten ||
    !istWurzel ||
    !eigeneKategorie ||
    eigenerZwilling != null ||
    darfLoeschen;
  const zeigtNamensfeld = editing && kannUmbenennen;
  const zeigtZustaendigkeitsfeld =
    editing && (eigeneKategorie || kannEigeneZustaendigkeitBearbeiten);

  const {ziel: effektivesZiel, eigen: zielIstEigen} = resolveEffektivesZiel(
    kategorie,
    kategorieById,
    wurzelZiel,
    untereinheitId,
  );
  // Reiner Container ohne eigene/geerbte Zuständigkeit ist kein Fehler, nur seine Kinder tragen sie.
  const zeigeZustaendigkeit = !hatKinder || effektivesZiel != null;
  const zustaendigkeitLabel = (() => {
    if (!effektivesZiel) return 'Keine Zuständigkeit festgelegt';
    const istDienstleister =
      effektivesZiel.art === ZustaendigkeitArt.Dienstleister;
    const name = istDienstleister
      ? dienstleisterOptionen.find(
          (d) => d.value === effektivesZiel.dienstleisterId,
        )?.name
      : gruppenOptionen.find(
          (g) => g.value === effektivesZiel.mitarbeiterGruppeId,
        )?.name;
    const basis = name ?? (istDienstleister ? 'Dienstleister' : 'Abteilung');
    return zielIstEigen ? basis : `${basis} (geerbt)`;
  })();

  const submitRename = async () => {
    const name = nameEntwurf.trim();
    if (!name || name === kategorie.name) {
      setEditing(false);
      setNameEntwurf(kategorie.name);
      return;
    }
    setBusy(true);
    try {
      const result = await renameKategorie({input: {id: kategorie.id, name}});
      if (mutationFailed(result) || result.data?.kategorieRename.errors) return;
      setEditing(false);
      onChanged();
    } finally {
      setBusy(false);
    }
  };

  const submitNeuesKind = async () => {
    const name = neuerKindName.trim();
    if (!name) return;
    const zielUntereinheitId = neuesKindIstGeteilt ? null : untereinheitId;
    if (kollidiertAlsZwilling(kinder, name, zielUntereinheitId)) {
      setNeuerKindNameFehler(
        'Eine Kategorie mit diesem Namen existiert bereits im jeweils anderen Geltungsbereich (geteilt/eigen). ' +
          'Nutze "Bearbeiten" auf der bestehenden Kategorie, um ihr eine eigene Zuständigkeit zu geben.',
      );
      return;
    }
    setNeuerKindNameFehler(null);
    setBusy(true);
    try {
      const result = await createKategorie({
        input: {
          name,
          parentId: kategorie.id,
          untereinheitId: zielUntereinheitId,
        },
      });
      if (mutationFailed(result) || result.data?.kategorieCreate.errors) return;
      setNeuerKindName('');
      setNeuesKindIstGeteilt(false);
      setAddingChild(false);
      if (!expanded) onToggleExpand(kategorie.id);
      onChanged();
    } finally {
      setBusy(false);
    }
  };

  const onZustaendigkeitSpeichern = async (werte: {
    erbt: boolean;
    art: ZustaendigkeitArt;
    mitarbeiterGruppeId: string | null;
    dienstleisterId: string | null;
  }) => {
    // Namens- und Zuständigkeitsfeld haben getrennte Speichern-Buttons; ein im Namensfeld
    // eingetippter, noch nicht per ✓ bestätigter Name darf hier nicht verworfen werden.
    let aktuellerName = kategorie.name;
    if (zeigtNamensfeld) {
      const name = nameEntwurf.trim();
      if (name && name !== kategorie.name) {
        const renameResult = await renameKategorie({
          input: {id: kategorie.id, name},
        });
        if (
          mutationFailed(renameResult) ||
          renameResult.data?.kategorieRename.errors
        ) {
          setZustaendigkeitFehlgeschlagen(true);
          return;
        }
        aktuellerName = name;
      }
    }

    let zielId = kategorie.id;
    if (!eigeneKategorie) {
      // "Erbt" räumt einen ziellosen Zwilling (abgebrochener Anlegeversuch) gleich mit auf.
      if (werte.erbt) {
        if (eigenerZwilling)
          await deleteKategorie({input: {id: eigenerZwilling.id}});
        setZustaendigkeitFehlgeschlagen(false);
        setEditing(false);
        onChanged();
        return;
      }
      if (eigenerZwilling) {
        zielId = eigenerZwilling.id;
      } else {
        // aktuellerName statt kategorie.name: die Prop ist nach einem Rename oben noch veraltet,
        // da erst onChanged() am Ende neu lädt.
        const createResult = await createKategorie({
          input: {
            name: aktuellerName,
            parentId: kategorie.parentId,
            untereinheitId,
          },
        });
        if (
          mutationFailed(createResult) ||
          createResult.data?.kategorieCreate.errors ||
          !createResult.data?.kategorieCreate.kategorie
        ) {
          setZustaendigkeitFehlgeschlagen(true);
          return;
        }
        zielId = createResult.data.kategorieCreate.kategorie.id;
      }
    }

    const result = await setZustaendigkeit({
      input: {kategorieId: zielId, ...werte},
    });
    if (
      mutationFailed(result) ||
      result.data?.kategorieZustaendigkeitSetzen.errors
    ) {
      setZustaendigkeitFehlgeschlagen(true);
      return;
    }
    setZustaendigkeitFehlgeschlagen(false);
    setEditing(false);
    onChanged();
  };

  const onDelete = async () => {
    const vorschau = await client
      .query(KategorieLoeschVorschauDocument, {id: kategorie.id})
      .toPromise();
    const anzahlUnterkategorien =
      vorschau.data?.kategorieLoeschVorschau.anzahlUnterkategorien;
    const betroffeneUntereinheiten: KategorieLoeschVorschauQuery['kategorieLoeschVorschau']['betroffeneUntereinheiten'] =
      vorschau.data?.kategorieLoeschVorschau.betroffeneUntereinheiten ?? [];
    const confirmed = await confirm({
      title: 'Kategorie löschen',
      content:
        anzahlUnterkategorien && anzahlUnterkategorien > 0
          ? `Diese Kategorie hat ${anzahlUnterkategorien} Unterkategorie(n), die dabei ebenfalls gelöscht werden.${
              betroffeneUntereinheiten.length > 0
                ? ` Betroffen sind auch eigene Unterkategorien von ${betroffeneUntereinheiten
                    .map(
                      (u) =>
                        `${u.untereinheitName} (${u.anzahlEigeneUnterkategorien})`,
                    )
                    .join(', ')}.`
                : ''
            } Trotzdem löschen?`
          : 'Möchten Sie diese Kategorie wirklich löschen?',
      confirmText: 'Kategorie löschen',
      confirmVariant: 'destructive',
    });
    if (!confirmed) return;

    setBusy(true);
    try {
      const result = await deleteKategorie({input: {id: kategorie.id}});
      if (mutationFailed(result) || result.data?.kategorieDelete.errors) return;
      onChanged();
    } finally {
      setBusy(false);
    }
  };

  const onEigenenZwillingEntfernen = async () => {
    if (!eigenerZwilling) return;
    const confirmed = await confirm({
      title: 'Eigene Zuständigkeit entfernen',
      content:
        'Diese Kategorie erbt danach wieder die Zuständigkeit der nächsten Elternkategorie bzw. der Standard-Zuständigkeit. Die geteilte Kategorie selbst bleibt erhalten.',
      confirmText: 'Entfernen',
      confirmVariant: 'destructive',
    });
    if (!confirmed) return;

    setBusy(true);
    try {
      const result = await deleteKategorie({input: {id: eigenerZwilling.id}});
      if (mutationFailed(result) || result.data?.kategorieDelete.errors) return;
      onChanged();
    } finally {
      setBusy(false);
    }
  };

  const onAusblenden = async () => {
    const anzahlNachfahren = zaehleNachfahren(kategorie.id, kinderVon);
    const confirmed = await confirm({
      title: 'Kategorie ausblenden',
      content:
        (anzahlNachfahren > 0
          ? `Diese Kategorie hat ${anzahlNachfahren} Unterkategorie(n), die dabei ebenfalls für diese Untereinheit unsichtbar werden. `
          : '') +
        'Die Kategorie wird für diese Untereinheit ausgeblendet, bleibt für alle anderen Untereinheiten aber weiterhin sichtbar. Sie kann jederzeit unter "Ausgeblendete Kategorien" wieder eingeblendet werden.',
      confirmText: 'Ausblenden',
    });
    if (!confirmed) return;

    setBusy(true);
    try {
      const result = await ausblenden({
        input: {kategorieId: kategorie.id, untereinheitId},
      });
      if (
        mutationFailed(result) ||
        result.data?.kategorieAusblendungSetzen.errors
      )
        return;
      onChanged();
    } finally {
      setBusy(false);
    }
  };

  const onExpandClick = async () => {
    if (editing) {
      const confirmed = await confirm({
        title: 'Bearbeitung verwerfen',
        content:
          'Die Änderungen an dieser Kategorie wurden noch nicht gespeichert. Möchtest du sie verwerfen?',
        confirmText: 'Verwerfen',
        confirmVariant: 'destructive',
      });
      if (!confirmed) return;
      setEditing(false);
      setNameEntwurf(kategorie.name);
      setZustaendigkeitFehlgeschlagen(false);
    }
    setAddingChild(false);
    if (aktionenOffen) onToggleAktionen(kategorie.id);
    onToggleExpand(kategorie.id);
  };

  const nameClass =
    istWurzel || tiefe === 0
      ? 'text-base font-semibold text-gray-900'
      : tiefe === 1
      ? 'text-sm font-medium text-gray-800'
      : 'text-sm font-normal text-gray-600';

  return (
    <div>
      <div
        className='group flex min-h-11 items-center gap-1 rounded-md py-2.5 pr-2 hover:bg-gray-100'
        style={{paddingLeft: tiefe * 24}}
      >
        <button
          type='button'
          className={`flex size-8 shrink-0 items-center justify-center rounded-full ${
            hatKinder ? 'text-gray-700 hover:bg-black/10' : 'text-transparent'
          }`}
          disabled={!hatKinder}
          onClick={() => void onExpandClick()}
          aria-label={expanded ? 'Einklappen' : 'Ausklappen'}
        >
          {hatKinder &&
            (expanded ? (
              <MdExpandMore className='size-6' />
            ) : (
              <MdChevronRight className='size-6' />
            ))}
        </button>

        {zeigtNamensfeld ? (
          <form
            className='flex grow items-center gap-2'
            onSubmit={(e) => {
              e.preventDefault();
              void submitRename();
            }}
          >
            <InputField
              autoFocus
              value={nameEntwurf}
              onChange={(e) => setNameEntwurf(e.target.value)}
              className='h-10 grow'
            />
            <button
              type='submit'
              aria-label='Speichern'
              disabled={busy}
              className='rounded-full p-2 text-primary hover:bg-black/10 disabled:opacity-50'
            >
              <MdCheck className='size-6' />
            </button>
            <button
              type='button'
              aria-label='Abbrechen'
              onClick={() => {
                setEditing(false);
                setNameEntwurf(kategorie.name);
              }}
              className='rounded-full p-2 text-gray-600 hover:bg-black/10'
            >
              <MdClose className='size-6' />
            </button>
          </form>
        ) : (
          <>
            <span className={`grow truncate ${nameClass}`}>
              {kategorie.name}
            </span>
            <div className='flex w-72 shrink-0 items-center justify-end gap-1.5 overflow-hidden'>
              {!eigeneKategorie && (
                <span className='shrink-0 rounded-full border border-gray-400 bg-gray-100 px-2 text-center text-xs text-gray-700'>
                  Geteilt
                </span>
              )}
              {zeigeZustaendigkeit && (
                <span
                  title={zustaendigkeitLabel}
                  className='hidden truncate text-sm text-gray-700 sm:inline'
                >
                  {zustaendigkeitLabel}
                </span>
              )}
            </div>
            <ToolTip tip='Weitere Aktionen'>
              <button
                type='button'
                aria-label='Weitere Aktionen'
                aria-expanded={aktionenOffen}
                onClick={() => onToggleAktionen(kategorie.id)}
                className={`shrink-0 rounded-full p-2 text-gray-600 hover:bg-black/10 ${
                  aktionenOffen ? 'bg-black/10' : ''
                }`}
              >
                <MdMoreVert className='size-6' />
              </button>
            </ToolTip>
          </>
        )}
      </div>

      {aktionenOffen && hatAktionen && (
        <div
          style={{paddingLeft: tiefe * 24 + 32}}
          className='flex flex-wrap gap-2 pb-2 pr-2 pt-1.5'
        >
          {darfBearbeiten && (
            <Button
              type='button'
              variant='outlined-secondary'
              onClick={() => {
                setEditing(true);
                onToggleAktionen(kategorie.id);
              }}
            >
              <MdEdit className='size-5' /> Bearbeiten
            </Button>
          )}
          {!istWurzel && (
            <Button
              type='button'
              variant='outlined-secondary'
              onClick={() => {
                setAddingChild(true);
                onToggleAktionen(kategorie.id);
              }}
            >
              <MdAdd className='size-5' /> Unterkategorie hinzufügen
            </Button>
          )}
          {!eigeneKategorie && (
            <Button
              type='button'
              variant='outlined-secondary'
              disabled={busy}
              onClick={() => {
                onToggleAktionen(kategorie.id);
                void onAusblenden();
              }}
            >
              <MdVisibilityOff className='size-5' /> Ausblenden
            </Button>
          )}
          {eigenerZwilling && (
            <Button
              type='button'
              variant='destructive'
              disabled={busy}
              onClick={() => {
                onToggleAktionen(kategorie.id);
                void onEigenenZwillingEntfernen();
              }}
            >
              <MdDelete className='size-5' /> Eigene Zuständigkeit entfernen
            </Button>
          )}
          {darfLoeschen && (
            <Button
              type='button'
              variant='destructive'
              disabled={busy}
              onClick={() => {
                onToggleAktionen(kategorie.id);
                void onDelete();
              }}
            >
              <MdDelete className='size-5' /> Löschen
            </Button>
          )}
        </div>
      )}

      {zeigtZustaendigkeitsfeld && (
        <div style={{paddingLeft: tiefe * 24 + 32}} className='pb-2 pr-2'>
          <ZustaendigkeitPanel
            kategorie={eigenerZwilling ?? kategorie}
            gruppenOptionen={gruppenOptionen}
            dienstleisterOptionen={dienstleisterOptionen}
            speichernFehlgeschlagen={zustaendigkeitFehlgeschlagen}
            onAbbrechen={() => {
              setEditing(false);
              setZustaendigkeitFehlgeschlagen(false);
            }}
            onSpeichern={onZustaendigkeitSpeichern}
          />
        </div>
      )}

      {addingChild && (
        <form
          style={{paddingLeft: tiefe * 24 + 32}}
          className='flex flex-wrap items-center gap-2 pb-2 pr-2'
          onSubmit={(e) => {
            e.preventDefault();
            void submitNeuesKind();
          }}
        >
          <InputField
            autoFocus
            placeholder='Name der neuen Unterkategorie'
            value={neuerKindName}
            onChange={(e) => {
              setNeuerKindName(e.target.value);
              setNeuerKindNameFehler(null);
            }}
            error={neuerKindNameFehler ?? undefined}
            className='h-10 grow'
          />
          {istSuperadmin && (
            <CheckboxField
              label='Für alle Untereinheiten geteilt'
              value={neuesKindIstGeteilt}
              onChange={(e) => {
                setNeuesKindIstGeteilt(e.target.checked);
                setNeuerKindNameFehler(null);
              }}
            />
          )}
          <button
            type='submit'
            aria-label='Anlegen'
            disabled={busy}
            className='rounded-full p-2 text-primary hover:bg-black/10 disabled:opacity-50'
          >
            <MdCheck className='size-6' />
          </button>
          <button
            type='button'
            aria-label='Abbrechen'
            onClick={() => setAddingChild(false)}
            className='rounded-full p-2 text-gray-600 hover:bg-black/10'
          >
            <MdClose className='size-6' />
          </button>
        </form>
      )}

      {expanded &&
        kinder.map((kind) => (
          <KategorieZeile
            key={kind.id}
            kategorie={kind}
            kinderVon={kinderVon}
            kategorieById={kategorieById}
            wurzelZiel={wurzelZiel}
            untereinheitId={untereinheitId}
            istSuperadmin={istSuperadmin}
            tiefe={tiefe + 1}
            expandedIds={expandedIds}
            onToggleExpand={onToggleExpand}
            gruppenOptionen={gruppenOptionen}
            dienstleisterOptionen={dienstleisterOptionen}
            onChanged={onChanged}
            offeneAktionenId={offeneAktionenId}
            onToggleAktionen={onToggleAktionen}
          />
        ))}
    </div>
  );
};
