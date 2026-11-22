import * as Sentry from '@sentry/react';
import {format} from 'date-fns';
import {type FC} from 'react';
import {FaRegEdit} from 'react-icons/fa';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  ResponsiveField,
  ResponsiveListContainer,
  ResponsiveListHeader,
  ResponsiveListRow,
  responsiveListSlots,
} from '../../../components/responsive-list/responsive-list.tsx';
import {Skeleton} from '../../../components/skeleton.tsx';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {asymmetricUnwrapKeyWithCache} from '../../../lib/crypto/crypto.tsx';
import {useAsyncMemo} from '../../../lib/hooks/use-async-memo.ts';
import {
  type CryptoCache,
  useCryptoCache,
} from '../../../lib/hooks/use-crypto-cache.ts';
import {type AusfuehrungFragment} from '../ausfuehrungen.generated.ts';

/**
 * Eigenschaften für die Komponente AusfuehrungenList.
 */
export type AusfuehrungenListProps = {
  ausfuehrungen?: AusfuehrungFragment[];
  className?: string;
  showZugewiesenColumn?: boolean;
  loading?: boolean;
};

// Spaltenraster (erst ab `lg`). Bewusst statische Strings, damit Tailwind sie erkennt.
const GRID_BASE = 'lg:grid-cols-[11rem_1fr_2fr_1.3fr_8rem]';
const GRID_ZUGEWIESEN = 'lg:grid-cols-[11rem_1fr_2fr_1.3fr_1.3fr_8rem]';

/** Verantwortliche Stelle als Klartext (ohne Entschlüsselung). */
const verantwortlichText = (a: AusfuehrungFragment): string => {
  const z = a.istZustaendigkeit;
  return z.art === ZustaendigkeitArt.Buerger
    ? 'Bürger'
    : z.dienstleister?.name ??
        z.mitarbeiterGruppe?.name ??
        z.organisationseinheit?.name ??
        '';
};

/** Bereits aufbereitete (inkl. entschlüsselter Beschreibung) Anzeigedaten einer Zeile. */
type DecryptedAusfuehrung = {
  id: string;
  datum: string;
  antragsart: string;
  beschreibung: string;
  verantwortlich: string;
  zugewiesen: string | null;
  /** Kombinierter, kleingeschriebener Text für die clientseitige Suche (inkl. Beschreibung). */
  suchtext: string;
};

/** Entschlüsselt und bereitet die Anzeigedaten eines einzelnen Antrags auf. */
const decryptAusfuehrung = async (
  a: AusfuehrungFragment,
  organisationPrivateKey: CryptoKey,
  cryptoCache: CryptoCache,
): Promise<DecryptedAusfuehrung> => {
  const key = await asymmetricUnwrapKeyWithCache(
    organisationPrivateKey,
    a.sharedKeyEncryptedForKommune,
    cryptoCache,
  );

  const slots: Record<string, unknown> = {};
  for (const sv of a.beschreibungstextSlotValues) {
    if (sv.__typename === 'PlainSlotValue') {
      slots[sv.slotName] = sv.plainValue;
    } else if (sv.__typename === 'EncryptedSlotValue') {
      slots[sv.slotName] = await cryptoCache.getDecryptedValueCached(
        key,
        sv.encryptedValue,
      );
    }
  }

  const beschreibung = a.prozessVersion.beschreibungstext.evaluate(slots);
  const datum = format(a.createdAt, 'dd.MM.yyyy HH:mm');
  const verantwortlich = verantwortlichText(a);
  const z = a.istZustaendigkeit;
  const person = z.zugewiesenePerson
    ? `${z.zugewiesenePerson.vorname} ${z.zugewiesenePerson.nachname}`
    : '';

  return {
    id: a.id,
    datum,
    antragsart: a.prozessVersion.prozess.name,
    beschreibung,
    verantwortlich,
    zugewiesen: z.zugewiesenePerson
      ? `${z.zugewiesenePerson.vorname[0]}. ${z.zugewiesenePerson.nachname}`
      : null,
    suchtext: [
      a.prozessVersion.prozess.name,
      verantwortlich,
      person,
      datum,
      beschreibung,
    ]
      .join(' ')
      .toLowerCase(),
  };
};

/**
 * Entschlüsselt für ALLE geladenen Anträge die Beschreibung (parallel statt sequentiell,
 * da jede Entschlüsselung unabhängig ist) und liefert die Anzeigedaten inkl. eines
 * durchsuchbaren Texts. So funktioniert die Suche auch über die (verschlüsselte)
 * Beschreibung – allerdings nur über die aktuell geladene Seite.
 */
const useDecryptedAusfuehrungen = (ausfuehrungen: AusfuehrungFragment[]) => {
  const {organisationPrivateKey} = useAuth();
  const cryptoCache = useCryptoCache();

  return useAsyncMemo(async () => {
    if (!organisationPrivateKey) return null;

    const results = await Promise.allSettled(
      ausfuehrungen.map((a) =>
        decryptAusfuehrung(a, organisationPrivateKey, cryptoCache),
      ),
    );

    for (const r of results) {
      if (r.status === 'rejected') {
        Sentry.captureException(r.reason);
      }
    }

    if (results.some((result) => result.status === 'rejected')) {
      throw new Error('Antragsdaten konnten nicht entschlüsselt werden.');
    }

    return results.filter((r) => r.status === 'fulfilled').map((r) => r.value);
  }, [ausfuehrungen, organisationPrivateKey, cryptoCache]);
};

/**
 * Responsive Liste der Ausführungen (Anträge): Tabelle auf großen Bildschirmen,
 * gestapelte Karten auf schmalen/gezoomten. Zebra-Streifen + klickbare Zeilen.
 * Sucht clientseitig über Antragsart, Gruppe, Person, Datum UND die entschlüsselte
 * Beschreibung der aktuell geladenen Seite.
 */
export const AusfuehrungenList = ({
  ausfuehrungen = [],
  className,
  showZugewiesenColumn = false,
  loading,
}: AusfuehrungenListProps) => {
  const suche = useAppUiStore((s) => s.antragSuche)
    .trim()
    .toLowerCase();
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.antraege);

  const {value: decrypted, error: decryptError} =
    useDecryptedAusfuehrungen(ausfuehrungen);
  const istLaden = loading || decrypted == null;

  const gefiltert = (decrypted ?? []).filter(
    (d) => !suche || d.suchtext.includes(suche),
  );
  const gridCols = showZugewiesenColumn ? GRID_ZUGEWIESEN : GRID_BASE;

  if (decryptError) {
    return (
      <p className='rounded-md bg-red-50 px-4 py-3 text-red-700'>
        Die Antragsdaten konnten nicht entschlüsselt werden.
      </p>
    );
  }

  return (
    <ResponsiveListContainer className={className}>
      <ResponsiveListHeader gridCols={gridCols}>
        <div>Antragseingang</div>
        <div>Antragsart</div>
        <div>Beschreibung</div>
        <div>Verantwortliche Gruppe</div>
        {showZugewiesenColumn && <div>Zugewiesen</div>}
        <div aria-hidden />
      </ResponsiveListHeader>

      {!istLaden && suche && gefiltert.length === 0 ? (
        <p className='px-4 py-6 text-gray-600'>
          Keine Treffer für „{suche}&rdquo; auf dieser Seite.
        </p>
      ) : (
        <ul>
          {responsiveListSlots(istLaden, seitengroesse, gefiltert.length).map(
            (i) => (
              <li key={gefiltert[i]?.id ?? i}>
                {istLaden || !gefiltert[i] ? (
                  <RowSkeleton
                    even={i % 2 === 0}
                    gridCols={gridCols}
                    showZugewiesen={showZugewiesenColumn}
                  />
                ) : (
                  <Row
                    data={gefiltert[i]}
                    even={i % 2 === 0}
                    gridCols={gridCols}
                    showZugewiesen={showZugewiesenColumn}
                  />
                )}
              </li>
            ),
          )}
        </ul>
      )}
    </ResponsiveListContainer>
  );
};

const Row: FC<{
  data: DecryptedAusfuehrung;
  even: boolean;
  gridCols: string;
  showZugewiesen: boolean;
}> = ({data, even, gridCols, showZugewiesen}) => (
  <ResponsiveListRow
    to={`/antraege/${data.id}`}
    even={even}
    gridCols={gridCols}
  >
    <ResponsiveField label='Antragseingang'>
      <span className='text-gray-700'>{data.datum}</span>
    </ResponsiveField>
    <ResponsiveField label='Antragsart'>
      <span className='font-semibold'>{data.antragsart}</span>
    </ResponsiveField>
    <ResponsiveField label='Beschreibung'>
      <span className='line-clamp-2 text-gray-700'>{data.beschreibung}</span>
    </ResponsiveField>
    <ResponsiveField label='Verantwortliche Gruppe'>
      {data.verantwortlich || '–'}
    </ResponsiveField>
    {showZugewiesen && (
      <ResponsiveField label='Zugewiesen'>
        {data.zugewiesen ?? '–'}
      </ResponsiveField>
    )}
    <div className='flex items-center gap-1.5 self-center justify-self-start text-primary lg:justify-self-end'>
      <FaRegEdit className='shrink-0' />
      <span className='font-bold'>Bearbeiten</span>
    </div>
  </ResponsiveListRow>
);

const RowSkeleton: FC<{
  even: boolean;
  gridCols: string;
  showZugewiesen: boolean;
}> = ({even, gridCols, showZugewiesen}) => (
  <ResponsiveListRow even={even} gridCols={gridCols}>
    <Skeleton className='w-24' />
    <Skeleton className='w-32' />
    <Skeleton className='w-full' />
    <Skeleton className='w-28' />
    {showZugewiesen && <Skeleton className='w-20' />}
    <div className='hidden lg:block' />
  </ResponsiveListRow>
);
