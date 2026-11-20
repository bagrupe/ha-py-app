import {type FormBuilder} from '@atmina/formbuilder';
import {useStore} from '@xyflow/react';
import {useEffect, useRef, useState, type FC} from 'react';
import {MdClose, MdEdit, MdEditOff} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für die SidebarHeader-Komponente.
 * @property on FormBuilder zur Verwaltung des Titelwerts.
 * @property placeholder Platzhaltertext für das Eingabefeld.
 * @property editable Optional, steuert ob der Titel bearbeitbar ist.
 */
export type SidebarHeaderProps = {
  on: FormBuilder<string | undefined>;
  placeholder: string;
  editable?: boolean;
};

/**
 * SidebarHeader-Komponente zur Anzeige und Bearbeitung eines Titels mit Schaltflächen zum Umschalten des Bearbeitungsmodus und zum Schließen.
 * @param on FormBuilder zur Steuerung des Titelwerts.
 * @param editable Gibt an, ob der Titel bearbeitet werden kann.
 * @param placeholder Platzhaltertext für das Eingabefeld.
 * @returns JSX-Element der SidebarHeader-Komponente.
 */
export const SidebarHeader: FC<SidebarHeaderProps> = ({
  on,
  editable,
  placeholder,
}) => {
  const unselectNodesAndEdges = useStore(
    (state) => state.unselectNodesAndEdges,
  );

  const [disabled, setDisabled] = useState(true);
  const inputRef = useRef<HTMLInputElement>(null);

  const title = on.$useWatch();

  useEffect(() => {
    if (!disabled) {
      inputRef.current?.focus();
    }
  }, [disabled, inputRef]);

  return (
    <div className='flex h-[72px] shrink-0 items-center gap-3 border-b border-b-gray-300 p-4'>
      <div className='flex w-96 flex-1 gap-2'>
        <button
          className={twMerge(
            'flex items-center gap-2 p-0 text-primary',
            !editable && 'opacity-0',
          )}
          disabled={!editable}
          onClick={(e) => {
            e.preventDefault();
            setDisabled((prev) => !prev);
          }}
        >
          {disabled ? <MdEdit /> : <MdEditOff />}
        </button>
        {disabled || !editable ? (
          <h2 className='truncate text-nowrap border-b-2 border-transparent font-bold'>
            {title}
          </h2>
        ) : (
          <input
            placeholder={placeholder}
            ref={inputRef}
            className='appearance-none overflow-hidden border-b-2 border-transparent bg-transparent py-1 font-bold  focus:border-b-2 focus:border-primary focus:outline-none'
            disabled={disabled}
            onBlur={() => {
              setDisabled(true);
            }}
            onChange={(e) => {
              on.$setValue(e.currentTarget.value);
            }}
            value={title ?? ''}
          />
        )}
      </div>
      <button
        className='shrink-0 p-3'
        type='button'
        onClick={() => unselectNodesAndEdges()}
      >
        <MdClose className='size-4' />
      </button>
    </div>
  );
};
