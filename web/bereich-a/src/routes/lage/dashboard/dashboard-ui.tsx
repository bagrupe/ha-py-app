import {format, isToday} from 'date-fns';
import {type FC, type ReactNode} from 'react';
import {useNavigate} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {LageGebietStatus, LageStatus} from '../../../__generated__/graphql.ts';
import {type DashboardLageFragment} from './dashboard.generated.ts';
import {
  type Meldung,
  kategorie,
  type kategorieFarben,
  klassenClass,
  klassenLabel,
  nummer,
} from './meldung.ts';
import {type Einsatzleitung} from './use-lage-dashboard.ts';

export const LEITSTELLE = 'leitstelle';

export const Badge: FC<{className?: string; children: ReactNode}> = ({
  className,
  children,
}) => (
  <span
    className={twMerge(
      'inline-flex items-center whitespace-nowrap rounded-md px-2 py-0.5 text-xs font-semibold',
      className,
    )}
  >
    {children}
  </span>
);

export const MeldungBadges: FC<{
  meldung: Meldung;
  farbe: ReturnType<typeof kategorieFarben>;
  mitKlasse?: boolean;
}> = ({meldung, farbe, mitKlasse = true}) => (
  <>
    {mitKlasse && meldung.klasse && (
      <Badge className={klassenClass[meldung.klasse]}>
        {klassenLabel[meldung.klasse]}
      </Badge>
    )}
    <Badge className={farbe(kategorie(meldung)).badge}>
      {kategorie(meldung)}
    </Badge>
    <span className='text-xs text-gray-700'>{nummer(meldung)}</span>
  </>
);

export const lageSeit = (lage: DashboardLageFragment) => {
  const liveAts = lage.gebiete
    .map((g) => g.liveAt)
    .filter((d): d is Date => Boolean(d))
    .map((d) => d.getTime());
  return liveAts.length ? new Date(Math.min(...liveAts)) : undefined;
};

export const istMeldewegOffen = (lage?: DashboardLageFragment) =>
  Boolean(
    lage &&
      lage.status === LageStatus.Active &&
      !lage.meldewegPausiertSeit &&
      lage.gebiete.some((g) => g.status === LageGebietStatus.Live),
  );

const LagePill: FC<{lage?: DashboardLageFragment; mitSeit?: boolean}> = ({
  lage,
  mitSeit,
}) => {
  if (!lage) {
    return (
      <Badge className='rounded-full bg-gray-700 px-3 py-1 text-sm text-white'>
        Keine Lage
      </Badge>
    );
  }
  if (lage.status === LageStatus.Closed) {
    return (
      <Badge className='rounded-full bg-gray-700 px-3 py-1 text-sm text-white'>
        Beendet · Lage {lage.title}
      </Badge>
    );
  }
  if (!istMeldewegOffen(lage)) {
    return (
      <Badge className='gap-2 rounded-full bg-gray-700 px-3 py-1 text-sm text-white'>
        <span aria-hidden className='size-2 rounded-full bg-gray-300' />
        Inaktiv · Meldeweg geschlossen
      </Badge>
    );
  }
  const seit = lageSeit(lage);
  return (
    <Badge className='gap-2 rounded-full bg-success-surface px-3 py-1 text-sm text-success-text'>
      <span aria-hidden className='size-2 rounded-full bg-success' />
      Aktiv · Lage {lage.title}
      {mitSeit &&
        seit &&
        ` · seit ${format(seit, isToday(seit) ? 'HH:mm' : 'dd.MM. HH:mm')}`}
    </Badge>
  );
};

export const DashboardHeader: FC<{
  bereich: string;
  lage?: DashboardLageFragment;
  ansicht: string;
  ansichten: Einsatzleitung[];
  mitLeitstelle: boolean;
  aktualisiert: Date | null;
  aktionen?: ReactNode;
}> = ({
  bereich,
  lage,
  ansicht,
  ansichten,
  mitLeitstelle,
  aktualisiert,
  aktionen,
}) => {
  const navigate = useNavigate();
  return (
    <header className='flex flex-wrap items-center gap-4 bg-gray-900 px-6 py-3 text-white'>
      <span className='text-lg font-bold tracking-wider'>DEICH</span>
      <span className='text-sm text-gray-300'>{bereich}</span>
      <LagePill lage={lage} mitSeit={mitLeitstelle} />
      {aktionen}
      <div className='flex-1' />
      <label className='flex items-center gap-2 text-sm text-gray-300'>
        Ansicht
        <select
          value={ansicht}
          onChange={(e) =>
            navigate(
              e.target.value === LEITSTELLE
                ? '/lage/leitstelle'
                : `/lage/einsatzleitung/${e.target.value}`,
            )
          }
          className='min-h-10 rounded-lg border border-gray-700 bg-gray-900 px-3 text-sm text-white'
        >
          {mitLeitstelle && <option value={LEITSTELLE}>Leitstelle</option>}
          {ansichten.map((el) => (
            <option key={el.id} value={el.id}>
              {el.name}
            </option>
          ))}
        </select>
      </label>
      {aktualisiert && (
        <span className='text-sm text-gray-300'>
          Aktualisiert {format(aktualisiert, 'HH:mm')}
        </span>
      )}
    </header>
  );
};

export const Kennzahlen: FC<{
  werte: {label: string; wert: number | string; hervorheben?: boolean}[];
  rest?: ReactNode;
}> = ({werte, rest}) => (
  <section
    aria-label='Kennzahlen'
    className='flex flex-wrap items-center gap-x-5 gap-y-2 rounded-xl border border-gray-300 bg-white px-4 py-3 text-sm'
  >
    {werte.map((w) => (
      <span
        key={w.label}
        className={twMerge(
          w.hervorheben &&
            'rounded-md bg-warning-surface px-2 py-0.5 text-warning-text',
        )}
      >
        <strong className='text-lg'>{w.wert}</strong> {w.label}
      </span>
    ))}
    {rest}
  </section>
);

export const Panel: FC<{
  title: ReactNode;
  hinweis?: ReactNode;
  className?: string;
  children: ReactNode;
  labelledBy?: string;
}> = ({title, hinweis, className, children, labelledBy}) => (
  <section
    aria-labelledby={labelledBy}
    className={twMerge(
      'flex min-w-0 flex-col gap-3 rounded-xl border border-gray-300 bg-white p-4',
      className,
    )}
  >
    <div className='flex flex-wrap items-baseline justify-between gap-2'>
      <h2 id={labelledBy} className='text-base font-bold'>
        {title}
      </h2>
      {hinweis && <span className='text-xs text-gray-700'>{hinweis}</span>}
    </div>
    {children}
  </section>
);

export const KeineLage: FC = () => (
  <div className='m-6 rounded-xl border border-gray-300 bg-white p-6'>
    <h1 className='text-xl font-bold'>Keine Lage</h1>
    <p className='text-gray-700'>
      Es gibt noch keine Lage. Eine Lage legt die Leitstelle unter{' '}
      <a href='/lage' className='text-primary underline'>
        Lagen
      </a>{' '}
      an und schaltet dort ihre Gebiete live.
    </p>
  </div>
);
