import {useEffect, useMemo, useState} from 'react';
import {MdAdd, MdCheck, MdClose, MdSearch, MdVisibility} from 'react-icons/md';
import {
  BackofficeNutzerArt,
  FunktionsberechtigungInOrganisationseinheit,
} from 'src/__generated__/graphql';
import {CheckboxField} from 'src/components/form/fields/checkbox-field/checkbox-field.tsx';
import {type CollectionItem} from 'src/components/form/fields/collections';
import {InputField} from 'src/components/form/fields/input-field';
import {SelectField} from 'src/components/form/fields/select-field';
import {Button} from 'src/components/ui/button';
import {PageHeader, PageShell} from '../../../components/page-shell.tsx';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {mutationFailed} from '../../../lib/mutation.ts';
import {KategorieZeile} from './kategorie-zeile.tsx';
import {
  kollidiertAlsZwilling,
  zaehleNachfahren,
} from './kategoriebaum-helpers.ts';
import {
  type KategorieFragment,
  useAusgeblendeteKategorienQuery,
  useKategorieAusblendungAufhebenMutation,
  useKategorieBaumQuery,
  useKategorieCreateMutation,
  useKategoriebaumOptionenQuery,
} from './kategoriebaum.generated.ts';

const gruppiereNachParent = (kategorien: KategorieFragment[]) => {
  const map = new Map<string | null, KategorieFragment[]>();
  for (const kategorie of kategorien) {
    if (kategorie.istWurzel) continue;
    const key = kategorie.parentId ?? null;
    const bisherige = map.get(key) ?? [];
    bisherige.push(kategorie);
    map.set(key, bisherige);
  }
  for (const kinder of map.values()) {
    kinder.sort((a, b) => a.name.localeCompare(b.name));
  }
  return map;
};

const entferneRedundanteEigeneZwillinge = (
  kinderVon: Map<string | null, KategorieFragment[]>,
) => {
  const gefiltert = new Map<string | null, KategorieFragment[]>();
  for (const [parentId, kinder] of kinderVon) {
    const behalten = kinder.filter((k) => {
      if (k.untereinheitId == null) return true;
      const hatGeteiltesGegenstueck = kinder.some(
        (andere) => andere.untereinheitId == null && andere.name === k.name,
      );
      return !hatGeteiltesGegenstueck;
    });
    gefiltert.set(parentId, behalten);
  }
  return gefiltert;
};

export const KategoriebaumVerwalten = () => {
  const {user} = useAuth();
  const istSuperadmin = user?.art === BackofficeNutzerArt.Superadmin;

  const [optionenResult] = useKategoriebaumOptionenQuery();
  const kommune =
    optionenResult.data?.my.__typename === 'BackofficeUser'
      ? optionenResult.data.my.kommune
      : undefined;

  const untereinheitOptionen = useMemo<CollectionItem<string>[]>(() => {
    if (!kommune) return [];
    const erlaubte = kommune.untereinheiten.filter(
      (u) =>
        istSuperadmin ||
        user?.organisationseinheiten?.some(
          (o) =>
            o.id === u.id &&
            o.funktionsberechtigungen.includes(
              FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung,
            ),
        ),
    );
    return erlaubte
      .map((u) => ({value: u.id, name: u.name}))
      .sort((a, b) => a.name.localeCompare(b.name));
  }, [kommune, istSuperadmin, user]);

  const [gewaehlteUntereinheitId, setUntereinheitId] = useState<
    string | undefined
  >();
  const untereinheitId =
    gewaehlteUntereinheitId ?? untereinheitOptionen[0]?.value;

  const gruppenOptionen = useMemo<CollectionItem<string>[]>(
    () =>
      (
        kommune?.untereinheiten.find((u) => u.id === untereinheitId)
          ?.mitarbeiterGruppen ?? []
      )
        .map((g) => ({value: g.id, name: g.name}))
        .sort((a, b) => a.name.localeCompare(b.name)),
    [kommune, untereinheitId],
  );
  const dienstleisterOptionen = useMemo<CollectionItem<string>[]>(
    () =>
      (kommune?.dienstleister ?? [])
        .filter((d) =>
          d.organisationseinheiten.some((o) => o.id === untereinheitId),
        )
        .map((d) => ({value: d.id, name: d.name}))
        .sort((a, b) => a.name.localeCompare(b.name)),
    [kommune, untereinheitId],
  );

  const [baumResult, refetchBaum] = useKategorieBaumQuery({
    variables: {untereinheitId: untereinheitId ?? ''},
    pause: !untereinheitId,
  });
  const [ausgeblendetResult, refetchAusgeblendet] =
    useAusgeblendeteKategorienQuery({
      variables: {untereinheitId: untereinheitId ?? ''},
      pause: !untereinheitId,
    });
  const onChanged = () => {
    refetchBaum({requestPolicy: 'network-only'});
    refetchAusgeblendet({requestPolicy: 'network-only'});
  };

  const kategorien = useMemo(
    () => baumResult.data?.kategorieBaum ?? [],
    [baumResult.data],
  );
  const wurzel = kategorien.find((k) => k.istWurzel);
  const kinderVonAlle = useMemo(
    () => gruppiereNachParent(kategorien),
    [kategorien],
  );
  const kinderVon = useMemo(
    () => entferneRedundanteEigeneZwillinge(kinderVonAlle),
    [kinderVonAlle],
  );
  const kategorieById = useMemo(
    () => new Map(kategorien.map((k) => [k.id, k])),
    [kategorien],
  );

  const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());
  const onToggleExpand = (id: string) =>
    setExpandedIds((bisherige) => {
      const neu = new Set(bisherige);
      if (neu.has(id)) neu.delete(id);
      else neu.add(id);
      return neu;
    });

  const [offeneAktionenId, setOffeneAktionenId] = useState<string | null>(null);
  const onToggleAktionen = (id: string) =>
    setOffeneAktionenId((bisherige) => (bisherige === id ? null : id));

  // Geteilte Kategorien haben dieselbe Id in jeder Untereinheit - Reset beim Wechsel nötig.
  useEffect(() => {
    setExpandedIds(new Set());
    setOffeneAktionenId(null);
  }, [untereinheitId]);

  const [suchbegriff, setSuchbegriff] = useState('');
  const suche = suchbegriff.trim().toLowerCase();
  const {sichtbareIds, erzwingenExpand} = useMemo(() => {
    if (!suche) return {sichtbareIds: null, erzwingenExpand: new Set<string>()};
    const sichtbareIds = new Set<string>();
    const erzwingenExpand = new Set<string>();
    for (const kategorie of kategorien) {
      if (!kategorie.name.toLowerCase().includes(suche)) continue;
      let current: KategorieFragment | undefined = kategorie;
      let istTreffer = true;
      while (current) {
        sichtbareIds.add(current.id);
        if (!istTreffer) erzwingenExpand.add(current.id);
        istTreffer = false;
        current = current.parentId
          ? kategorieById.get(current.parentId)
          : undefined;
      }
    }
    return {sichtbareIds, erzwingenExpand};
  }, [suche, kategorien, kategorieById]);

  const kinderVonSichtbar = useMemo(() => {
    if (!sichtbareIds) return kinderVon;
    const gefiltert = new Map<string | null, KategorieFragment[]>();
    for (const [parentId, kinder] of kinderVon) {
      const passende = kinder.filter((k) => sichtbareIds.has(k.id));
      if (passende.length > 0) gefiltert.set(parentId, passende);
    }
    return gefiltert;
  }, [kinderVon, sichtbareIds]);

  const effectiveExpandedIds = useMemo(
    () => new Set([...expandedIds, ...erzwingenExpand]),
    [expandedIds, erzwingenExpand],
  );

  const topLevel = kinderVonSichtbar.get(null) ?? [];

  const [addingTopLevel, setAddingTopLevel] = useState(false);
  const [neuerName, setNeuerName] = useState('');
  const [neuerIstGeteilt, setNeuerIstGeteilt] = useState(false);
  const [neuerNameFehler, setNeuerNameFehler] = useState<string | null>(null);
  const [topLevelBusy, setTopLevelBusy] = useState(false);
  const [, createKategorie] = useKategorieCreateMutation();
  const submitTopLevel = async () => {
    const name = neuerName.trim();
    if (!name || !untereinheitId) return;
    const zielUntereinheitId = neuerIstGeteilt ? null : untereinheitId;
    if (kollidiertAlsZwilling(topLevel, name, zielUntereinheitId)) {
      setNeuerNameFehler(
        'Eine Kategorie mit diesem Namen existiert bereits im jeweils anderen Geltungsbereich (geteilt/eigen). ' +
          'Nutze "Bearbeiten" auf der bestehenden Kategorie, um ihr eine eigene Zuständigkeit zu geben.',
      );
      return;
    }
    setNeuerNameFehler(null);
    setTopLevelBusy(true);
    try {
      const result = await createKategorie({
        input: {name, parentId: null, untereinheitId: zielUntereinheitId},
      });
      if (mutationFailed(result) || result.data?.kategorieCreate.errors) return;
      setNeuerName('');
      setAddingTopLevel(false);
      onChanged();
    } finally {
      setTopLevelBusy(false);
    }
  };

  const ausgeblendet = ausgeblendetResult.data?.ausgeblendeteKategorien ?? [];
  const [, einblenden] = useKategorieAusblendungAufhebenMutation();
  const [einblendenBusyId, setEinblendenBusyId] = useState<string | null>(null);
  const onEinblenden = async (kategorieId: string) => {
    if (!untereinheitId) return;
    setEinblendenBusyId(kategorieId);
    try {
      const result = await einblenden({
        input: {kategorieId, untereinheitId},
      });
      if (
        mutationFailed(result) ||
        result.data?.kategorieAusblendungAufheben.errors
      )
        return;
      onChanged();
    } finally {
      setEinblendenBusyId(null);
    }
  };

  return (
    <PageShell>
      <PageHeader
        title='Mängelmelder-Kategorien'
        actions={
          untereinheitId &&
          !addingTopLevel && (
            <Button
              type='button'
              variant='outlined'
              onClick={() => setAddingTopLevel(true)}
            >
              <MdAdd className='size-5' /> Neue Kategorie
            </Button>
          )
        }
      />

      <div className='flex flex-wrap items-end gap-4'>
        <SelectField
          label='Untereinheit'
          value={untereinheitId}
          onChange={(value) => setUntereinheitId(value ?? undefined)}
          items={untereinheitOptionen}
          className='w-80'
        />
        <InputField
          type='search'
          label='Kategorie suchen'
          value={suchbegriff}
          onChange={(e) => setSuchbegriff(e.target.value)}
          endAdornment={<MdSearch className='text-gray-400' />}
          className='min-w-72 flex-1'
        />
      </div>

      {untereinheitId && addingTopLevel && (
        <form
          className='flex flex-wrap items-center gap-3 rounded-md border border-gray-200 p-3'
          onSubmit={(e) => {
            e.preventDefault();
            void submitTopLevel();
          }}
        >
          <InputField
            autoFocus
            label='Name der neuen Kategorie'
            value={neuerName}
            onChange={(e) => {
              setNeuerName(e.target.value);
              setNeuerNameFehler(null);
            }}
            error={neuerNameFehler ?? undefined}
            className='h-10 grow'
          />
          {istSuperadmin && (
            <CheckboxField
              label='Für alle Untereinheiten geteilt'
              value={neuerIstGeteilt}
              onChange={(e) => {
                setNeuerIstGeteilt(e.target.checked);
                setNeuerNameFehler(null);
              }}
            />
          )}
          <button
            type='submit'
            aria-label='Anlegen'
            disabled={topLevelBusy}
            className='rounded-full p-2 text-primary hover:bg-black/10 disabled:opacity-50'
          >
            <MdCheck className='size-6' />
          </button>
          <button
            type='button'
            aria-label='Abbrechen'
            onClick={() => setAddingTopLevel(false)}
            className='rounded-full p-2 text-gray-600 hover:bg-black/10'
          >
            <MdClose className='size-6' />
          </button>
        </form>
      )}

      {untereinheitId && wurzel && (
        <div className='rounded-md border border-gray-200'>
          <p className='rounded-t-md border-b border-gray-200 bg-gray-100 px-3 py-2 text-sm font-medium text-gray-700'>
            Fallback: greift, wenn für eine Meldung keine spezifischere
            Kategorie-Zuständigkeit gefunden wird. Selbst keine Kategorie.
          </p>
          <KategorieZeile
            key={`${untereinheitId}-${wurzel.id}`}
            kategorie={wurzel}
            kinderVon={new Map()}
            kategorieById={kategorieById}
            wurzelZiel={wurzel?.ziel ?? null}
            offeneAktionenId={offeneAktionenId}
            onToggleAktionen={onToggleAktionen}
            istSuperadmin={istSuperadmin}
            untereinheitId={untereinheitId}
            tiefe={0}
            expandedIds={effectiveExpandedIds}
            onToggleExpand={onToggleExpand}
            gruppenOptionen={gruppenOptionen}
            dienstleisterOptionen={dienstleisterOptionen}
            onChanged={onChanged}
          />
        </div>
      )}

      {untereinheitId && (
        <div className='rounded-md border border-gray-200'>
          <h2 className='rounded-t-md border-b border-gray-200 bg-gray-100 px-3 py-2 text-base font-bold text-gray-900'>
            Sichtbare Kategorien
          </h2>
          <div className='divide-y divide-gray-100'>
            {topLevel.map((kategorie) => (
              <KategorieZeile
                key={`${untereinheitId}-${kategorie.id}`}
                kategorie={kategorie}
                kinderVon={kinderVonSichtbar}
                kategorieById={kategorieById}
                wurzelZiel={wurzel?.ziel ?? null}
                offeneAktionenId={offeneAktionenId}
                onToggleAktionen={onToggleAktionen}
                istSuperadmin={istSuperadmin}
                untereinheitId={untereinheitId}
                tiefe={0}
                expandedIds={effectiveExpandedIds}
                onToggleExpand={onToggleExpand}
                gruppenOptionen={gruppenOptionen}
                dienstleisterOptionen={dienstleisterOptionen}
                onChanged={onChanged}
              />
            ))}
          </div>
        </div>
      )}

      {untereinheitId && ausgeblendet.length > 0 && (
        <div className='rounded-md border border-gray-200'>
          <h2 className='rounded-t-md border-b border-gray-200 bg-gray-100 px-3 py-2 text-base font-bold text-gray-900'>
            Ausgeblendete Kategorien ({ausgeblendet.length})
          </h2>
          <div className='p-2'>
            {ausgeblendet.map((kategorie) => {
              const anzahlNachfahren = zaehleNachfahren(
                kategorie.id,
                kinderVonAlle,
              );
              return (
                <div
                  key={kategorie.id}
                  className='flex min-h-11 items-center gap-2 rounded-md px-2 py-1.5 hover:bg-gray-50'
                >
                  <span className='grow truncate text-base'>
                    {kategorie.name}
                    {anzahlNachfahren > 0 && (
                      <span className='ml-2 text-sm text-gray-500'>
                        (+{anzahlNachfahren} Unterkategorie
                        {anzahlNachfahren === 1 ? '' : 'n'} ebenfalls
                        ausgeblendet)
                      </span>
                    )}
                  </span>
                  <Button
                    type='button'
                    variant='text'
                    disabled={einblendenBusyId === kategorie.id}
                    onClick={() => onEinblenden(kategorie.id)}
                  >
                    <MdVisibility className='size-5' /> Einblenden
                  </Button>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </PageShell>
  );
};
