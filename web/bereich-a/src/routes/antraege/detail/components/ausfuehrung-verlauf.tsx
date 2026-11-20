import {format} from 'date-fns';
import {type FC} from 'react';
import {twMerge} from 'tailwind-merge';

/** Verlaufseintrag, wie er sowohl vom Live-Antrag als auch vom Archiv geliefert wird. */
export type Verlaufseintrag = {
  id: string;
  createdAt: Date;
  statusAenderung?: string | null;
  statusAenderungBeschreibung?: string | null;
  benutzer?: string | null;
  nachricht?: string | null;
};

/**
 * Zeigt den chronologischen Verlauf eines Antrags (Übernahme, Weiterleitungen,
 * Zuständigkeitswechsel, Abschluss). Neueste Ereignisse zuerst.
 */
export const AusfuehrungVerlauf: FC<{historie: readonly Verlaufseintrag[]}> = ({
  historie,
}) => {
  const eintraege = [...historie].reverse();

  return (
    <section className='mt-3 w-full'>
      <div className='mb-3 flex items-center gap-2'>
        <h2 className='text-xl font-bold'>Verlauf</h2>
        <div className='h-px w-full bg-gray-300' />
      </div>
      {eintraege.length === 0 ? (
        <p className='text-sm text-gray-500'>
          Es ist noch keine Historie vorhanden.
        </p>
      ) : (
        <ol className='flex flex-col'>
          {eintraege.map((eintrag, index) => (
            <li key={eintrag.id} className='flex gap-3'>
              <div className='flex flex-col items-center'>
                <div className='mt-1.5 size-3 shrink-0 rounded-full bg-primary' />
                <div
                  className={twMerge(
                    'w-px grow bg-gray-200',
                    index === eintraege.length - 1 && 'bg-transparent',
                  )}
                />
              </div>
              <div className='pb-5'>
                <div className='font-bold'>{eintrag.statusAenderung}</div>
                <div className='text-sm text-gray-500'>
                  {format(eintrag.createdAt, 'dd.MM.yyyy HH:mm')}
                  {eintrag.benutzer ? ` · ${eintrag.benutzer}` : ''}
                </div>
                {eintrag.statusAenderungBeschreibung ? (
                  <div className='mt-1 text-sm'>
                    {eintrag.statusAenderungBeschreibung}
                  </div>
                ) : null}
                {eintrag.nachricht ? (
                  <div className='mt-1 whitespace-pre-wrap text-sm text-gray-500'>
                    {eintrag.nachricht}
                  </div>
                ) : null}
              </div>
            </li>
          ))}
        </ol>
      )}
    </section>
  );
};
