import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@radix-ui/react-tooltip';
import {Handle, type NodeProps, Position} from '@xyflow/react';
import {mz} from 'mehrzahl';
import {type FC, type CSSProperties, memo, useMemo} from 'react';
import {FaExclamationTriangle} from 'react-icons/fa';
import {MdArrowOutward} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type GhostSchritt, type SchrittDaten} from '../lib/domain-types.ts';
import {type SchrittNode} from '../lib/flow/flow.types.ts';
import {useProzessEditorStore} from '../lib/store';
import {type ProzessValidationError} from '../lib/validate-prozess.ts';
import {type ProzessEditorSchritt} from '../prozess-version-erstellen.generated.ts';
import {zustaendigkeitArtNames} from './form/soll-zustaendigkeit-form.tsx';

/**
 * Eigenschaften für den Schrittknoten-Komponenten-Wrapper.
 */
export type KommunalappSchrittNodeProps = NodeProps<SchrittNode>;

/**
 * Komponente zur Anzeige eines Fehler-Badges mit Tooltip für Validierungsfehler.
 * @param errors Liste der Fehlermeldungen
 * @param className optionale CSS-Klassen für die Badge-Komponente
 */
const ErrorBadge = ({
  errors,
  className,
}: {
  errors: string[];
  className?: string;
}) => (
  <TooltipProvider>
    <Tooltip>
      <TooltipTrigger
        className={twMerge(
          'z-50 grid place-items-center rounded-full border border-red-500 bg-red-200 px-2 text-xs text-red-700',
          className,
        )}
      >
        {mz(errors.length)`$value Problem{|e}`}
      </TooltipTrigger>
      <TooltipContent
        side='top'
        sideOffset={10}
        className='z-10 flex flex-col gap-1 p-2'
      >
        {errors?.map((message, i) => (
          <div
            key={message + i}
            className='flex items-center gap-1 rounded-md bg-red-100 px-2 text-base text-red-600'
          >
            <FaExclamationTriangle size={10} />
            {message}
          </div>
        ))}
      </TooltipContent>
    </Tooltip>
  </TooltipProvider>
);

/**
 * Hauptkomponente für einen Schrittknoten im Prozess-Editor.
 * Stellt je nach Schritt-Typ unterschiedliche Darstellungen und Handles bereit.
 * @param data Enthält Schrittdaten, Fehler, Startstatus und Schnittpunktinformationen
 * @param selected Kennzeichnet, ob der Knoten ausgewählt ist
 */
export const KommunalappSchrittNode: FC<KommunalappSchrittNodeProps> = memo(
  ({data: {schritt, errors, isStart, intersectionCause}, selected}) => {
    // Role objects are derived from process metadata, not stored on node data.
    const rollen = useProzessEditorStore((state) => state.metadata.rollen);
    const resolvedSchritt = useMemo(() => {
      if (schritt.__typename === 'GhostSchritt') return schritt;
      const schreibtRolle =
        rollen.find((r) => r.id === schritt.schreibtRolleId) ?? null;
      const liestRolle =
        schritt.sollZustaendigkeit.art === ZustaendigkeitArt.Dynamisch
          ? rollen.find(
              (r) => r.id === schritt.sollZustaendigkeit.liestRolleId,
            ) ?? null
          : null;
      return {
        ...schritt,
        schreibtRolle,
        sollZustaendigkeit: {...schritt.sollZustaendigkeit, liestRolle},
      } as Exclude<SchrittDaten, GhostSchritt>;
    }, [schritt, rollen]);

    if (schritt.__typename === 'GhostSchritt') {
      return (
        <>
          <div
            style={
              intersectionCause
                ? ({
                    '--width': `${(intersectionCause.width ?? 0) + 20}px`,
                    '--height': `${(intersectionCause.height ?? 0) + 20}px`,
                  } as CSSProperties)
                : undefined
            }
            className={twMerge('relative h-[60px] w-[120px]')}
          >
            <div
              className={twMerge(
                'absolute left-1/2 top-1/2 grid h-[--height,60px] w-[--width,120px] -translate-x-1/2 -translate-y-1/2 place-items-center rounded border-2 border-dashed border-gray-400 bg-gray-200 transition-all',
                selected && 'border-primary text-primary',
                intersectionCause &&
                  'border-primary bg-primary-light text-primary',
              )}
            >
              <ErrorBadge
                errors={errors?.map((e) => e.message) ?? []}
                className={twMerge(
                  'absolute -top-2 transition-opacity',
                  intersectionCause && 'opacity-0',
                )}
              />
              {intersectionCause ? 'Schritt einfügen' : 'Platzhalter'}
            </div>
          </div>
          <Handle
            type='target'
            position={Position.Left}
            className={twMerge(intersectionCause && 'opacity-0')}
          />
          <Handle
            type='source'
            position={Position.Right}
            className={twMerge(intersectionCause && 'opacity-0')}
          />
        </>
      );
    }

    return (
      <>
        {!isStart && <Handle type='target' position={Position.Left} />}
        <KommunalappSchrittNodeRender
          schritt={resolvedSchritt as Exclude<SchrittDaten, GhostSchritt>}
          errors={errors ?? []}
          selected={selected}
          isStart={isStart ?? false}
        />
        {schritt.__typename !== 'EndeSchritt' && (
          <Handle type='source' position={Position.Right} />
        )}
      </>
    );
  },
);

KommunalappSchrittNode.displayName = 'KommunalappSchrittNode';

/**
 * Eigenschaften für die Render-Komponente eines Schrittknotens.
 */
export type KommunalappSchrittNodeRenderProps = {
  schritt: Exclude<SchrittDaten, GhostSchritt>;
  errors: ProzessValidationError[];
  isStart: boolean;
  selected?: boolean;
};

/**
 * Mapping von Schritt-Typen zu ihren Anzeigenamen.
 */
const schrittArtLabels: Record<ProzessEditorSchritt['__typename'], string> = {
  WarteAufBezahlungAbgeschlossenSchritt: 'Bezahlung',
  BezahlenSchritt: 'Bezahlung',
  EndeSchritt: 'Ende',
  FormularSchritt: 'Formular',
  ProgrammatischerSchritt: 'Automatisierung',
  EmailForwarderExportSchritt: 'EMail',
  GovManagerRestExportSchritt: 'GovManager Rest Export',
  WarteAufGovManagerSchritt: 'GovManager Rest Export',
  NachrichtSchritt: 'Nachricht',
};

/**
 * Komponente zur Darstellung des Inhalts eines Schrittknotens.
 * Zeigt Schrittart, Zuständigkeit, Rollen und Validierungsfehler an.
 * @param schritt Schrittdaten ohne GhostSchritt
 * @param errors Liste der Validierungsfehler
 * @param selected Kennzeichnung der Auswahl
 */
export const KommunalappSchrittNodeRender: FC<
  KommunalappSchrittNodeRenderProps
> = ({schritt, errors, selected = false}) => (
  <div
    className={twMerge(
      'relative min-w-32 rounded border-[1.5px] border-primary bg-white',
      selected && 'bg-primary',
    )}
  >
    <div className='flex h-0 -translate-y-1/2 items-center justify-center gap-2'>
      <div className='flex items-center gap-1.5 rounded-full border bg-white px-2 text-center text-xs'>
        <span>{schrittArtLabels[schritt.__typename]}</span>
        <span className='text-primary'>
          {zustaendigkeitArtNames[schritt.sollZustaendigkeit.art]}
        </span>
      </div>
      {schritt.sollZustaendigkeit.liestRolle && (
        <div className='flex items-center gap-1 rounded-full border border-green-500 bg-green-200 px-2 text-center text-xs text-green-700'>
          <MdArrowOutward className='rotate-90' />{' '}
          {schritt.sollZustaendigkeit.liestRolle.name}
        </div>
      )}
      {schritt.schreibtRolle && (
        <div className='flex items-center gap-1 rounded-full border border-sky-500 bg-sky-200 px-2 text-center text-xs text-sky-700'>
          <MdArrowOutward /> {schritt.schreibtRolle.name}
        </div>
      )}
      {errors.length > 0 && (
        <ErrorBadge errors={errors?.map((e) => e.message) ?? []} />
      )}
    </div>
    <div className={twMerge('p-4', selected && 'text-white')}>
      <p className='text-center'>{schritt.titel}</p>

      {schritt.__typename === 'FormularSchritt' &&
        schritt.felder.length > 0 && (
          <div className='mt-2 grid grid-cols-2 gap-x-3 border-t pt-2'>
            <span className='col-span-2'>
              {mz(schritt.felder.length)`Formularfeld{|er}`}:
            </span>
            {schritt.felder.map((f) => (
              <p
                key={f.id}
                className={
                  (f.angezeigterName?.length ?? 0) > 30 ? 'col-span-2' : ''
                }
              >
                {f.angezeigterName ?? 'Eingabe'}
                {f.pflichtfeld && '*'}
              </p>
            ))}
          </div>
        )}
    </div>
  </div>
);
