import {type FormBuilder} from '@atmina/formbuilder';
import groupBy from 'lodash/groupBy';
import {useEffect} from 'react';
import {MdAccountTree} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {
  BackofficeNutzerArt,
  type FunktionsberechtigungInOrganisationseinheit,
} from '../../../__generated__/graphql.ts';
import {Accordion} from '../../../components/accordion.tsx';
import {CheckboxField} from '../../../components/form/fields/checkbox-field';
import {ToolTip} from '../../../components/ui/tool-tip.tsx';
import {matchNutzerart} from '../../../lib/nutzerart.ts';
import {
  type BackofficeUserOrganisationseinheitFragment,
  type FunktionsberechtigungenMetadataFragment,
} from '../nutzende/nutzende.generated.ts';

/**
 * Komponente zur Darstellung und Verwaltung der Zuordnung von Backoffice-Nutzern zu Organisationseinheiten.
 * Zeigt eine Liste verfügbarer Organisationseinheiten mit zugehörigen Funktionsberechtigungen an.
 * @param currentOrganisationseinheiten Aktuelle Zuordnungen des Nutzers zu Organisationseinheiten
 * @param organisationseinheitenField Formularfeld zur Steuerung der Organisationseinheiten und Berechtigungen
 * @param availableOrganisationseinheiten Verfügbare Organisationseinheiten zur Auswahl
 * @param availableFunktionsberechtigungen Verfügbare Funktionsberechtigungen in Organisationseinheiten
 * @param nutzerart Art des Nutzers zur Filterung der Berechtigungen
 */
export const BackofficeUserOrganisationseinheitenSubform = ({
  currentOrganisationseinheiten,
  organisationseinheitenField,
  availableOrganisationseinheiten,
  availableFunktionsberechtigungen,
  nutzerart,
}: {
  currentOrganisationseinheiten: BackofficeUserOrganisationseinheitFragment[];
  organisationseinheitenField: FormBuilder<
    Record<
      string,
      {
        zugehoerig: boolean;
        funktionsberechtigungen: FunktionsberechtigungInOrganisationseinheit[];
      }
    >
  >;
  availableOrganisationseinheiten: {name: string; id: string}[];
  availableFunktionsberechtigungen: FunktionsberechtigungenMetadataFragment['inOrganisationseinheit'];
  nutzerart: BackofficeNutzerArt;
}) => {
  const organisationseinheiten = organisationseinheitenField.$useWatch();
  availableFunktionsberechtigungen = availableFunktionsberechtigungen.filter(
    (b) => matchNutzerart(nutzerart, b.nutzerArtMindestens),
  );

  useEffect(() => {
    for (const [id, einheit] of Object.entries(organisationseinheiten)) {
      if (einheit.funktionsberechtigungen?.length > 0 && !einheit.zugehoerig) {
        organisationseinheitenField[id].zugehoerig.$setValue(true);
      }
    }
  }, [organisationseinheiten, organisationseinheitenField]);

  return (
    <div className='flex flex-col gap-2'>
      {availableOrganisationseinheiten.map(({id, name}) => {
        const current = currentOrganisationseinheiten.find(
          (oe) => oe.organisationseinheitId === id,
        );
        const zugehoerig = organisationseinheiten[id]?.zugehoerig === true;
        const funktionsberechtigungenCount =
          organisationseinheiten[id]?.funktionsberechtigungen.length ?? 0;
        let geerbteFunktionsberechtigungen: FunktionsberechtigungInOrganisationseinheit[];
        availableFunktionsberechtigungen.map((b) => b.value);

        if (nutzerart === BackofficeNutzerArt.Superadmin) {
          geerbteFunktionsberechtigungen = availableFunktionsberechtigungen.map(
            (b) => b.value,
          );
        } else if (!zugehoerig) {
          geerbteFunktionsberechtigungen = [];
        } else {
          geerbteFunktionsberechtigungen = [
            ...(current?.geerbteFunktionsberechtigungen ?? []),
            ...availableFunktionsberechtigungen
              .filter((b) => b.implizit)
              .map((b) => b.value),
          ];
        }

        return (
          <Accordion
            key={id}
            heading={
              <div className='flex items-center'>
                <div>{name}</div>
                {funktionsberechtigungenCount > 0 && (
                  <div
                    className={twMerge(
                      'ml-auto mr-2 min-w-4 rounded bg-primary-light/20 px-2 py-1 text-sm text-primary',
                    )}
                  >
                    <span className='font-bold'>
                      {funktionsberechtigungenCount ===
                      availableFunktionsberechtigungen.length
                        ? 'Alle'
                        : funktionsberechtigungenCount}
                    </span>{' '}
                    {funktionsberechtigungenCount === 1
                      ? 'Funktionsberechtigung'
                      : 'Funktionsberechtigungen'}
                  </div>
                )}
                {funktionsberechtigungenCount == 0 && zugehoerig && (
                  <div
                    className={twMerge(
                      'ml-auto mr-2 min-w-4 rounded bg-primary-light/20 px-2 py-1 text-sm text-primary',
                    )}
                  >
                    Zugehörig
                  </div>
                )}
              </div>
            }
          >
            <div className='p-4'>
              <CheckboxField
                label='Zugehörig'
                value={zugehoerig}
                indeterminate={
                  !zugehoerig && nutzerart === BackofficeNutzerArt.Superadmin
                }
                orientation='checkbox-left'
                className='mb-2 font-bold text-gray-700'
                onChange={(e) => {
                  organisationseinheitenField[id].zugehoerig.$setValue(
                    e.currentTarget.checked,
                  );
                  organisationseinheitenField[
                    id
                  ].funktionsberechtigungen.$setValue([]);
                }}
              />
              <FunktionsberechtigungenSubform
                availableFunktionsberechtigungen={
                  availableFunktionsberechtigungen
                }
                geerbteFunktionsberechtigungen={geerbteFunktionsberechtigungen}
                on={organisationseinheitenField[id].funktionsberechtigungen}
                className='ml-2 border-l pl-4'
              />
            </div>
          </Accordion>
        );
      })}
    </div>
  );
};

/**
 * Komponente zur Darstellung und Auswahl von Funktionsberechtigungen in Gruppen.
 * Zeigt verfügbare Berechtigungen mit geerbten und benutzerspezifischen Zuständen an.
 * @template T Typ der Funktionsberechtigungswerte
 * @param availableFunktionsberechtigungen Liste der verfügbaren Funktionsberechtigungen mit Metadaten
 * @param geerbteFunktionsberechtigungen Liste der geerbten Funktionsberechtigungen
 * @param on Formularfeld zur Steuerung der ausgewählten Berechtigungen
 * @param className Optionale CSS-Klassen für die äußere Container-Div
 */
export const FunktionsberechtigungenSubform = <T,>({
  availableFunktionsberechtigungen,
  geerbteFunktionsberechtigungen = [],
  on,
  className,
}: {
  availableFunktionsberechtigungen: {
    name: string;
    value: T;
    groupName: string;
    description?: string;
  }[];
  geerbteFunktionsberechtigungen?: FunktionsberechtigungInOrganisationseinheit[];
  on: FormBuilder<T[]>;
  className?: string;
}) => {
  const {
    field: {value, onChange},
  } = on.$useController({defaultValue: []});

  const currentBerechtigungen = value ?? [];
  const groups = Object.entries(
    groupBy(availableFunktionsberechtigungen, 'groupName'),
  ).map(([groupName, berechtigungen]) => {
    const ids = berechtigungen.map((b) => b.value);
    const geerbte = ids.filter((id) =>
      geerbteFunktionsberechtigungen.includes(id as never),
    );
    const currentBenutzerspezifische = currentBerechtigungen.filter((b) =>
      ids.includes(b),
    );
    return (
      <div key={groupName}>
        <CheckboxField
          label={groupName}
          orientation='checkbox-left'
          value={currentBenutzerspezifische.length == ids.length}
          indeterminate={
            (currentBenutzerspezifische.length > 0 || geerbte.length > 0) &&
            currentBenutzerspezifische.length < ids.length
          }
          onChange={(e) => {
            if (e.currentTarget.checked) {
              onChange([
                ...currentBerechtigungen,
                ...ids.filter((id) => !currentBerechtigungen.includes(id)),
              ]);
            } else {
              onChange(currentBerechtigungen.filter((b) => !ids.includes(b)));
            }
          }}
          className='py-1 font-bold text-gray-700'
        />
        <div className='ml-2 border-l'>
          {berechtigungen.map((fb, i) => {
            const hasBerechtigung = currentBerechtigungen.includes(
              fb.value as never,
            );
            const isInherited = geerbteFunktionsberechtigungen.includes(
              fb.value as never,
            );
            return (
              <CheckboxField
                orientation='checkbox-left'
                key={i}
                label={
                  <ToolTip
                    key={i}
                    tip={
                      <div className='text-sm'>
                        {fb.description}

                        {isInherited && (
                          <div className='mt-1 text-xs text-gray-500'>
                            Diese Funktionsberechtigung wird{' '}
                            <span className='text-primary'>
                              automatisch erteilt
                            </span>{' '}
                            (z.B. aufgrund eines Berechtigungsprofils oder der
                            Nutzerart); dies gilt auch, wenn sie hier nicht
                            aktiviert ist.
                          </div>
                        )}
                      </div>
                    }
                    asChild
                  >
                    <div className='flex items-center gap-2'>
                      {fb.name}
                      {isInherited && (
                        <MdAccountTree className='size-4 text-primary/50' />
                      )}
                    </div>
                  </ToolTip>
                }
                value={hasBerechtigung}
                indeterminate={isInherited && !hasBerechtigung}
                onChange={(event) => {
                  if (event.currentTarget.checked && !hasBerechtigung) {
                    onChange([...currentBerechtigungen, fb.value]);
                  } else if (!event.currentTarget.checked && hasBerechtigung) {
                    onChange(
                      currentBerechtigungen.filter((b) => b != fb.value),
                    );
                  }
                }}
                className={twMerge('py-1 pl-6', isInherited && 'text-primary')}
              />
            );
          })}
        </div>
      </div>
    );
  });

  return (
    <div className={className}>
      <div className='flex flex-col gap-4'>{groups}</div>
    </div>
  );
};
