import {type FC, useCallback, useEffect, useRef, useState} from 'react';
import {MdEdit} from 'react-icons/md';
import {toast} from 'react-toastify';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für den Inline-Editor des Prozessnamens.
 * @property name Der aktuell gespeicherte Prozessname.
 * @property onRename Callback, das den getrimmten neuen Namen speichert.
 * @property className Optionale CSS-Klasse für das äußere Element.
 */
export type ProzessNameEditorProps = {
  name: string;
  onRename: (name: string) => void | Promise<void>;
  className?: string;
};

/**
 * Zeigt den Prozessnamen als Überschrift an und macht ihn per Klick inline editierbar.
 * Speichert beim Verlassen des Feldes oder mit Enter, verwirft mit Escape und lehnt leere Namen ab.
 * @param props Eigenschaften des Inline-Editors.
 */
export const ProzessNameEditor: FC<ProzessNameEditorProps> = ({
  name,
  onRename,
  className,
}) => {
  const [isEditing, setIsEditing] = useState(false);
  const [value, setValue] = useState(name);
  const inputRef = useRef<HTMLInputElement>(null);
  // Das Entfernen des fokussierten Inputs aus dem DOM löst noch ein Blur aus.
  // Beim Abbrechen darf dieses Blur kein Commit auslösen.
  const cancelledRef = useRef(false);

  useEffect(() => {
    if (isEditing) {
      inputRef.current?.focus();
      inputRef.current?.select();
    }
  }, [isEditing]);

  const startEditing = useCallback(() => {
    cancelledRef.current = false;
    setValue(name);
    setIsEditing(true);
  }, [name]);

  const commit = useCallback(() => {
    if (cancelledRef.current) {
      cancelledRef.current = false;
      return;
    }
    const trimmed = value.trim();
    if (!trimmed) {
      toast.error('Der Prozessname darf nicht leer sein');
      // Im Bearbeitungsmodus bleiben und den Fokus nach dem Blur zurückholen,
      // damit der Pflichtwert korrigiert werden kann.
      requestAnimationFrame(() => inputRef.current?.focus());
      return;
    }
    setIsEditing(false);
    if (trimmed !== name) {
      void onRename(trimmed);
    }
  }, [name, onRename, value]);

  const cancel = useCallback(() => {
    cancelledRef.current = true;
    setValue(name);
    setIsEditing(false);
  }, [name]);

  if (isEditing) {
    return (
      <input
        ref={inputRef}
        aria-label='Prozessname'
        className={twMerge(
          'rounded-md border-2 border-gray-300 bg-gray-100 px-2 py-1 font-medium outline-none focus:border-gray-500',
          className,
        )}
        value={value}
        onChange={(e) => setValue(e.target.value)}
        onBlur={commit}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            e.preventDefault();
            inputRef.current?.blur();
          } else if (e.key === 'Escape') {
            e.preventDefault();
            cancel();
          }
        }}
      />
    );
  }

  return (
    <h3 className={className}>
      <button
        type='button'
        title='Prozessname bearbeiten'
        className='group flex items-center gap-2 rounded-md px-2 py-1 font-medium hover:bg-gray-100'
        onClick={startEditing}
      >
        {name}
        <MdEdit className='text-gray-400 opacity-0 transition-opacity group-hover:opacity-100' />
      </button>
    </h3>
  );
};
