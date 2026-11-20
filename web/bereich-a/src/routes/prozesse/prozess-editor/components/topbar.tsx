import * as Dialog from '@radix-ui/react-dialog';
import {mz} from 'mehrzahl';
import {useCallback} from 'react';
import {MdRedo, MdUndo, MdWarning} from 'react-icons/md';
import {toast} from 'react-toastify';
import {Modal} from 'src/components/modal/modal.tsx';
import {mutationFailed} from 'src/lib/mutation';
import {Button} from '../../../../components/ui/button';
import {flowToVersionInput} from '../lib/serialization/flow-to-version-input.ts';
import {useProzessEditorStore} from '../lib/store';
import {
  useProzessUmbenennenMutation,
  useProzessVersionVeroeffentlichenMutation,
} from '../prozess-editor.generated.ts';
import {useNeueProzessVersionErstellenMutation} from '../prozess-version-erstellen.generated.ts';
import {ProzessNameEditor} from './prozess-name-editor.tsx';

/**
 * Komponente für die obere Leiste im Prozess-Editor.
 * Zeigt den Namen des Prozesses, Validierungsfehler, Steuerung für das Speichern und Veröffentlichen von Prozessversionen sowie die Ansichtsauswahl für Kantentypen.
 */
export const Topbar = () => {
  const nodes = useProzessEditorStore((state) => state.nodes);
  const edges = useProzessEditorStore((state) => state.edges);
  const metadata = useProzessEditorStore((state) => state.metadata);
  const validationResult = useProzessEditorStore(
    (state) => state.validationResult,
  );
  const smartEdges = useProzessEditorStore((state) => state.smartEdges);
  const setSmartEdges = useProzessEditorStore((state) => state.setSmartEdges);
  const setName = useProzessEditorStore((state) => state.setName);
  const undo = useProzessEditorStore((state) => state.undo);
  const redo = useProzessEditorStore((state) => state.redo);
  const canUndo = useProzessEditorStore(
    (state) => state.history.past.length > 0,
  );
  const canRedo = useProzessEditorStore(
    (state) => state.history.future.length > 0,
  );
  const markVersionPublished = useProzessEditorStore(
    (state) => state.markVersionPublished,
  );
  const initializeFromProzess = useProzessEditorStore(
    (state) => state.initializeFromProzess,
  );

  const hasAenderungen = metadata.hasVersionChanges;
  const isReleased = !!metadata.latestVersionPublishedAt;

  const [, neueProzessVersionErstellenMutation] =
    useNeueProzessVersionErstellenMutation();

  const [, prozessVersionVeroeffentlichen] =
    useProzessVersionVeroeffentlichenMutation();

  const [, prozessUmbenennen] = useProzessUmbenennenMutation();

  /**
   * Speichert einen neuen Prozessnamen sofort, ohne eine neue Version zu erzeugen.
   * @param name Der neue, bereits getrimmte Prozessname.
   */
  const handleRename = useCallback(
    async (name: string) => {
      const result = await prozessUmbenennen({
        input: {id: metadata.prozessId, name},
      });
      if (mutationFailed(result)) return;
      const neuerName = result.data!.prozessUpsert.prozess?.name;
      if (neuerName != null) {
        setName(neuerName);
        toast.success('Prozessname geändert');
      } else {
        toast.error('Prozessname konnte nicht geändert werden');
      }
    },
    [metadata.prozessId, prozessUmbenennen, setName],
  );

  /**
   * Erstellt eine neue Prozessversion aus dem aktuellen React-Flow-Graphen.
   * Serialisiert über die Boundary, führt die Mutation aus und initialisiert den Editor
   * mit den zurückgegebenen Daten neu.
   * @param veroeffentlichen Gibt an, ob die neue Version direkt veröffentlicht werden soll.
   */
  const neueProzessVersionErstellen = useCallback(
    async (veroeffentlichen: boolean) => {
      const response = await neueProzessVersionErstellenMutation({
        input: flowToVersionInput({nodes, edges, metadata}, {veroeffentlichen}),
      });

      if (mutationFailed(response)) return;
      const newProzess = response.data!.prozessVersionErstellen.prozess;
      if (newProzess) {
        initializeFromProzess(newProzess);
        toast.success(
          veroeffentlichen
            ? 'Neue Version veröffentlicht'
            : 'Version gespeichert',
        );
      } else {
        toast.error(
          veroeffentlichen
            ? 'Neue Version konnte nicht veröffentlicht werden'
            : 'Version konnte nicht gespeichert werden',
        );
      }
    },
    [
      nodes,
      edges,
      metadata,
      initializeFromProzess,
      neueProzessVersionErstellenMutation,
    ],
  );
  return (
    <div className='flex h-[72px] items-center gap-4 border-b p-2 px-4'>
      <div className='flex shrink-0 items-center gap-1'>
        <Button
          variant='text-secondary'
          type='button'
          className='px-2'
          disabled={!canUndo}
          onClick={undo}
          title='Rückgängig (Strg+Z)'
          aria-label='Rückgängig'
        >
          <MdUndo className='size-5' />
        </Button>
        <Button
          variant='text-secondary'
          type='button'
          className='px-2'
          disabled={!canRedo}
          onClick={redo}
          title='Wiederherstellen (Strg+Umschalt+Z)'
          aria-label='Wiederherstellen'
        >
          <MdRedo className='size-5' />
        </Button>
      </div>
      <ProzessNameEditor
        name={metadata.name}
        onRename={handleRename}
        className='min-w-0 truncate'
      />
      <div className='ml-auto flex shrink-0 items-center gap-4'>
        {!validationResult.valid && (
          <Dialog.Root>
            <Dialog.Trigger asChild>
              <Button variant='destructive'>
                {mz(
                  validationResult.totalErrorCount,
                )`$value Problem{|e} anzeigen`}
              </Button>
            </Dialog.Trigger>
            <Modal title='Probleme' className='max-w-2xl'>
              <ul className='relative flex flex-col gap-2 py-2'>
                {validationResult.globalErrors.length > 0 && (
                  <>
                    <li className='flex flex-col gap-1 rounded-md bg-red-50 px-4 py-2'>
                      <p className='flex items-center gap-2 font-medium text-gray-900'>
                        <MdWarning className='text-red-500' />
                        Prozess
                      </p>
                      <ul className='flex list-disc flex-col gap-1 pb-1 pl-6'>
                        {validationResult.globalErrors.map((e) => (
                          <li key={e.message} className='text-gray-900'>
                            {e.message}
                          </li>
                        ))}
                      </ul>
                    </li>
                    <li className='flex items-center gap-4 py-1'>
                      <span>Schritte</span> <hr className='grow' />
                    </li>
                  </>
                )}
                {Object.values(validationResult.errors).map((ne) => (
                  <li
                    key={ne.schritt.id}
                    className='flex flex-col gap-1 rounded-md bg-red-50 px-4 py-2'
                  >
                    <p className='flex items-center gap-2 font-medium text-gray-900'>
                      <MdWarning className='text-red-500' />
                      {ne.schritt.titel}
                    </p>
                    <ul className='flex list-disc flex-col gap-1 pb-1 pl-6'>
                      {ne.errors.map((e) => (
                        <li key={e.message} className='text-gray-900'>
                          {e.message}
                        </li>
                      ))}
                    </ul>
                  </li>
                ))}
              </ul>
            </Modal>
          </Dialog.Root>
        )}
        {hasAenderungen && (
          <Button
            variant='solid'
            type='button'
            disabled={!validationResult.valid}
            onClick={() => neueProzessVersionErstellen(false)}
          >
            Änderungen speichern
          </Button>
        )}
        {(hasAenderungen || !isReleased) && (
          <Button
            variant='text'
            type='button'
            disabled={!validationResult.valid}
            onClick={async () => {
              if (!hasAenderungen && metadata.latestVersionId) {
                const result = await prozessVersionVeroeffentlichen({
                  input: {prozessVersionId: metadata.latestVersionId},
                });
                if (mutationFailed(result)) return;
                const publishedVersion =
                  result.data!.prozessVersionVeroeffentlichen.prozessVersion;
                if (publishedVersion?.publishedAt) {
                  markVersionPublished(publishedVersion);
                  toast.success('Neue Version veröffentlicht');
                } else {
                  toast.error(
                    'Neue Version konnte nicht veröffentlicht werden',
                  );
                }
              } else {
                neueProzessVersionErstellen(true);
              }
            }}
          >
            Veröffentlichen
          </Button>
        )}
        <hr className='h-full w-px bg-gray-200' />
        <div className='text-sm text-gray-500'>Ansicht</div>
        <div className='flex items-center gap-1 rounded-md bg-gray-100 p-2'>
          <Button
            variant={smartEdges ? 'solid' : 'text'}
            className='py-1 font-normal'
            onClick={() => setSmartEdges(true)}
          >
            Eckige Kanten
          </Button>
          <Button
            variant={smartEdges ? 'text' : 'solid'}
            className='py-1 font-normal'
            onClick={() => setSmartEdges(false)}
          >
            Runde Kanten
          </Button>
        </div>
      </div>
    </div>
  );
};
