import {useRef, useState} from 'react';
import SVG from 'react-inlinesvg';
import Add from '../../../assets/add.svg';
import Delete from '../../../assets/delete.svg';

/**
 * Adresse mit Domain-Anteil, die auf einen Punkt gefolgt von mindestens zwei Zeichen endet - fängt
 * Fälle wie `d@d` ab, die die native `type='email'`-Prüfung allein durchlässt (die Spezifikation
 * verlangt dort keinen Punkt/keine Top-Level-Domain).
 */
const HAS_VALID_DOMAIN = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

/**
 * Komponente zur Bearbeitung mehrerer E-Mail-Adressen: bestehende Adressen können einzeln entfernt,
 * neue über ein Eingabefeld hinzugefügt werden. Jede neue Adresse wird vor dem Hinzufügen per nativer
 * `type='email'`-Prüfung sowie einer zusätzlichen Domain-Prüfung validiert. Ein noch nicht bestätigter
 * Entwurf wird zusätzlich beim Verlassen des Felds übernommen, damit er nicht verloren geht, wenn
 * direkt danach anderswo gespeichert wird.
 * @param props Eigenschaften der Komponente
 * @param props.value Aktuell hinterlegte E-Mail-Adressen
 * @param props.onChange Callback bei Änderung der Liste
 * @returns JSX-Element mit Liste und Eingabefeld für E-Mail-Adressen
 */
export const EmailListEditor = ({
  value,
  onChange,
}: {
  value: string[];
  onChange: (value: string[]) => void;
}) => {
  const [draft, setDraft] = useState('');
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const addDraft = (options?: {silentOnEmpty?: boolean}) => {
    const trimmed = draft.trim();
    if (trimmed === '') {
      if (!options?.silentOnEmpty) {
        setError('Bitte geben Sie zuerst eine E-Mail-Adresse ein.');
      }
      return;
    }
    if (!inputRef.current?.checkValidity() || !HAS_VALID_DOMAIN.test(trimmed)) {
      setError('Bitte geben Sie eine gültige E-Mail-Adresse ein.');
      return;
    }
    if (value.some((email) => email.toLowerCase() === trimmed.toLowerCase())) {
      setError('Diese E-Mail-Adresse ist bereits vorhanden.');
      return;
    }
    onChange([...value, trimmed]);
    setDraft('');
    setError(null);
  };

  return (
    <div className='flex flex-col gap-2'>
      {value.map((email, index) => (
        <div key={email} className='flex items-center gap-2'>
          <span className='flex-1 rounded-md bg-white p-1 text-sm'>
            {email}
          </span>
          <button
            type='button'
            className='material-symbols-outlined flex shrink-0 gap-2 text-red-500'
            onClick={() => onChange(value.filter((_, i) => i !== index))}
          >
            <SVG src={Delete} className='fill-red-500' />
          </button>
        </div>
      ))}
      <div className='flex items-center gap-2'>
        <input
          ref={inputRef}
          type='email'
          autoComplete='off'
          data-1p-ignore='true'
          data-lpignore='true'
          data-bwignore='true'
          data-form-type='other'
          className='min-w-0 flex-1 rounded-md border-2 bg-white p-1 outline-gray-300 focus:outline-gray-500'
          aria-label='E-Mail-Adresse'
          value={draft}
          onChange={(e) => {
            setDraft(e.target.value);
            setError(null);
          }}
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              e.preventDefault();
              addDraft();
            }
          }}
          onBlur={() => addDraft({silentOnEmpty: true})}
        />
        <button
          type='button'
          className='material-symbols-outlined flex shrink-0 gap-2 text-primary'
          onMouseDown={(e) => e.preventDefault()}
          onClick={() => addDraft()}
          aria-label='E-Mail-Adresse hinzufügen'
          title='E-Mail-Adresse hinzufügen'
        >
          <SVG src={Add} className='fill-primary' />
        </button>
      </div>
      {error && <div className='text-sm text-red-500'>{error}</div>}
    </div>
  );
};

/**
 * Beschriftetes `EmailListEditor`-Feld für "Neu anlegen"-Formulare (Abteilungen, Organisationseinheiten,
 * Dienstleister): dieselbe graue Box mit grünem "E-Mail-Adressen:"-Label wie im aufgeklappten
 * Bearbeiten-Bereich einer bestehenden Abteilung/Organisationseinheit/eines Dienstleisters
 * (`EditableTextForm`), damit beide Formen optisch identisch sind.
 * @param props Eigenschaften der Komponente
 * @param props.value Aktuell im Formular eingetragene E-Mail-Adressen
 * @param props.onChange Callback bei Änderung der Liste
 * @param props.error Optionale Fehlermeldung des Servers (z. B. nach fehlgeschlagenem Absenden)
 * @returns JSX-Element mit Label, `EmailListEditor` und optionaler Fehlermeldung
 */
export const NeueEMailAdressenFeld = ({
  value,
  onChange,
  error,
}: {
  value: string[];
  onChange: (value: string[]) => void;
  error?: string;
}) => (
  <div className='rounded border bg-gray-50 p-2'>
    <div className='mb-2 text-primary'>E-Mail-Adressen:</div>
    <EmailListEditor value={value} onChange={onChange} />
    {error && <div className='mt-1 text-sm text-red-500'>{error}</div>}
  </div>
);
