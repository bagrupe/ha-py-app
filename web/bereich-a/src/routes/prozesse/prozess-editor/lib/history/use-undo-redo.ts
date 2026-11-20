import {useEffect} from 'react';
import {useProzessEditorStore} from '../store';

const isEditableTarget = (target: EventTarget | null): boolean => {
  if (!(target instanceof HTMLElement)) return false;
  return (
    target.tagName === 'INPUT' ||
    target.tagName === 'TEXTAREA' ||
    target.tagName === 'SELECT' ||
    target.isContentEditable
  );
};

/**
 * Wires Cmd/Ctrl+Z (undo) and Cmd/Ctrl+Shift+Z (redo) to the store's history actions.
 * Ported from the React Flow Pro `useUndoRedo` template, with two deliberate changes: a
 * single keydown listener disambiguates redo from undo by the shift key (two separate
 * `useKeyPress` hooks would both fire on Shift+Z), and the shortcut is ignored while a text
 * field is focused so the browser's native text undo keeps working there.
 */
export const useUndoRedo = (): void => {
  const undo = useProzessEditorStore((state) => state.undo);
  const redo = useProzessEditorStore((state) => state.redo);

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if (!(event.metaKey || event.ctrlKey)) return;
      if (event.key?.toLowerCase() !== 'z') return;
      if (isEditableTarget(event.target)) return;

      event.preventDefault();
      if (event.shiftKey) {
        redo();
      } else {
        undo();
      }
    };

    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [undo, redo]);
};
