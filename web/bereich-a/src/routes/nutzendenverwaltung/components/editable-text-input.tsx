import {Fragment, useEffect, useRef, useState} from 'react';
import SVG from 'react-inlinesvg';
import {twMerge} from 'tailwind-merge';
import {IconWithCallbackButton} from 'src/components/ui/button/icon-with-callback-button';
import Delete from '../../../assets/delete.svg';
import EditSquare from '../../../assets/edit-square.svg';
import Save from '../../../assets/save.svg';
import {CheckboxField} from '../../../components/form/fields/checkbox-field';
import {useUntereinheitenQuery} from '../organisationseinheiten/organisationseinheit.generated.ts';
import {EmailListEditor} from './email-list-editor';

/**
 * Eigenschaften für die EditableTextForm-Komponente.
 * @template T Typ des zu bearbeitenden Objekts
 */
export type EditableTextInputProps<T> = {
  /** Callback zum Aktualisieren des Objekts */
  onUpdate: (object: InputTypes<T>) => Promise<boolean>;
  /** Callback zum Löschen des Objekts */
  onDelete: () => void;
  /** Das zu bearbeitende Objekt */
  object: T;
  /** Optionale Fehlermeldung */
  error?: string;
  /** Gibt an, ob die Eingabe bearbeitbar ist */
  editable?: boolean;
};

/**
 * Typ für die Eingabewerte, ohne __typename und id
 * @template T Typ des Objekts
 */
export type InputTypes<T> = Omit<T, '__typename' | 'id'>;

/**
 * Komponente für ein editierbares Textformular mit Speichern- und Löschen-Funktion.
 * @template T Typ des zu bearbeitenden Objekts
 * @param props Eigenschaften der Komponente
 * @returns JSX-Element der editierbaren Textfelder
 */
export const EditableTextForm = <
  T extends {__typename?: string | undefined; id?: string},
>({
  error,
  object,
  onUpdate,
  onDelete,
  editable = true,
}: EditableTextInputProps<T>) => {
  const inputRefs = useRef<HTMLInputElement[]>([]);
  const [saveEnabled, setSaveEnabled] = useState(false);

  const {__typename, id, ...rest} = object;

  const [editableValues, setEditableValues] = useState<InputTypes<T>>(rest);

  useEffect(() => {
    if (saveEnabled && inputRefs.current.length > 0) {
      inputRefs.current[0]?.focus();
    }
  }, [saveEnabled]);

  return (
    <div className='mt-2 rounded-md border'>
      <div className='flex items-center justify-between'>
        <div className='w-full p-2'>
          <div className='flex gap-2'>
            {Object.keys(editableValues).map((key, index) => {
              const value = editableValues[key as keyof InputTypes<T>];
              return (
                <Fragment key={key}>
                  {index != 0 && (
                    <div className='w-px self-stretch bg-slate-300' />
                  )}
                  {key === 'eMailAdressen' && (
                    <div className='flex-1 self-center p-1 text-sm text-gray-700'>
                      {Array.isArray(value) && value.length > 0
                        ? value.join(', ')
                        : 'Keine E-Mail-Adresse hinterlegt'}
                    </div>
                  )}
                  {key !== 'organisationseinheitIds' &&
                    key !== 'eMailAdressen' && (
                      <input
                        ref={(el) => {
                          if (el) inputRefs.current[index] = el;
                        }}
                        disabled={!saveEnabled}
                        className='flex-1 rounded-md border-2 bg-gray-100 p-1 outline-gray-300 focus:outline-gray-500 disabled:border-transparent disabled:bg-transparent'
                        type='text'
                        id={key}
                        onChange={(e) =>
                          setEditableValues((prev) => ({
                            ...prev,
                            [key]: e.target.value,
                          }))
                        }
                        defaultValue={value != null ? String(value) : ''}
                      />
                    )}
                </Fragment>
              );
            })}
          </div>
        </div>
        <div
          className={twMerge(
            'mx-1 flex flex-row gap-2',
            !editable ? 'invisible' : '',
          )}
        >
          <IconWithCallbackButton
            onClick={
              saveEnabled
                ? async () => {
                    const saved = await onUpdate(editableValues);
                    if (saved) setSaveEnabled(false);
                  }
                : () => setSaveEnabled(!saveEnabled)
            }
            iconSrc={saveEnabled ? Save : EditSquare}
          />
          <button
            type='button'
            className='material-symbols-outlined flex gap-2 text-red-500'
            onClick={onDelete}
          >
            <SVG src={Delete} className='fill-red-500' />
          </button>
        </div>
      </div>
      {saveEnabled && 'eMailAdressen' in editableValues && (
        <div className='mx-2 mb-2 rounded border bg-gray-50 p-2'>
          <div className='mb-2 text-primary'>E-Mail-Adressen:</div>
          <EmailListEditor
            value={editableValues.eMailAdressen as string[]}
            onChange={(value) => {
              setEditableValues((prev) => ({
                ...prev,
                eMailAdressen: value,
              }));
            }}
          />
        </div>
      )}
      {saveEnabled && 'organisationseinheitIds' in editableValues && (
        <div className='mx-2 mb-2 rounded border bg-gray-50 p-2'>
          <div className='mb-2 text-primary'>
            Ist folgenden Organisationseinheiten zugehörig:
          </div>
          <OrganisationseinheitenMultiselectField
            className='max-w-fit'
            value={editableValues.organisationseinheitIds as string[]}
            onChange={(value) => {
              setEditableValues((prev) => ({
                ...prev,
                organisationseinheitIds: value,
              }));
            }}
          />
        </div>
      )}
      {error && (
        <div className='m-2 whitespace-pre rounded-md bg-red-50 px-4 py-2 text-sm text-gray-900'>
          {error}
        </div>
      )}
    </div>
  );
};

/**
 * Komponente für die Mehrfachauswahl von Organisationseinheiten mit Checkboxen.
 * @param props Eigenschaften der Komponente
 * @param props.value Ausgewählte IDs der Organisationseinheiten
 * @param props.onChange Callback bei Änderung der Auswahl
 * @param props.className Optionale CSS-Klasse für das Container-Element
 * @returns JSX-Element mit Checkboxen für Organisationseinheiten
 */
const OrganisationseinheitenMultiselectField = ({
  value,
  onChange,
  className,
}: {
  value: string[];
  onChange: (value: string[]) => void;
  className?: string;
}) => {
  const [untereinheitenQuery] = useUntereinheitenQuery();
  const my = untereinheitenQuery.data?.my;
  const organisationseinheiten =
    my && 'kommune' in my ? my.kommune.untereinheiten : [];

  return (
    <div className={className}>
      {organisationseinheiten.map(({name, id}) => (
        <CheckboxField
          key={id}
          value={value.includes(id)}
          label={name}
          onChange={(e) => {
            if (e.currentTarget.checked) {
              onChange([...value, id]);
            } else {
              onChange(value.filter((other) => other !== id));
            }
          }}
        />
      ))}
    </div>
  );
};
