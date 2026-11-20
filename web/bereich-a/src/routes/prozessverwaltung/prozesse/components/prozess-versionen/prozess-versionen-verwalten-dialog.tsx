import {format} from 'date-fns';
import {type FC, useMemo, useState} from 'react';
import {useConfirm} from '../../../../../components/modal/confirm-modal.tsx';
import {Modal} from '../../../../../components/modal/modal.tsx';
import {Button} from '../../../../../components/ui/button';
import {useKommune} from '../../../../../lib/context/kommune/kommune.tsx';
import {mutationFailed} from '../../../../../lib/mutation.ts';
import {useDeleteProzessVersionMutation} from '../../prozesse.generated.ts';
import {useProzessVersionenFuerLoeschungQuery} from './prozess-versionen.generated.ts';

const formatVersionLabel = (version: {
  createdAt?: Date | null;
  publishedAt?: Date | null;
}): string =>
  version.publishedAt
    ? `Veröffentlicht am ${format(version.publishedAt, 'dd.MM.yyyy HH:mm')}`
    : `Entwurf (erstellt am ${
        version.createdAt ? format(version.createdAt, 'dd.MM.yyyy HH:mm') : '–'
      })`;

const istLetzteVeroeffentlichteVersion = (
  version: {publishedAt?: Date | null},
  alleVersionen: readonly {publishedAt?: Date | null}[],
): boolean =>
  version.publishedAt != null &&
  alleVersionen.length > 1 &&
  alleVersionen.filter((v) => v.publishedAt != null).length === 1;

const istAktuelleVersion = (
  version: {id: string; publishedAt?: Date | null},
  alleVersionen: readonly {id: string; publishedAt?: Date | null}[],
): boolean => {
  const publishedAt = version.publishedAt;
  if (publishedAt == null || alleVersionen.length <= 1) return false;

  const andereVeroeffentlichte = alleVersionen.filter(
    (v) => v.id !== version.id && v.publishedAt != null,
  );
  if (andereVeroeffentlichte.length === 0) return false;

  return !andereVeroeffentlichte.some((v) => v.publishedAt! > publishedAt);
};

const errorMessageFor = (typename: string): string => {
  switch (typename) {
    case 'ProzessVersionHasAusfuehrungen':
      return 'Dieser Version sind bereits Ausführungen (Anträge) zugeordnet und kann deshalb nicht gelöscht werden.';
    case 'ProzessVersionIsLastPublished':
      return 'Dies ist die letzte veröffentlichte Version dieses Prozesses und kann deshalb nicht gelöscht werden.';
    case 'ProzessVersionIsCurrentVersion':
      return 'Dies ist die aktuell für Bürger:innen aktive Version. Beim Löschen würde eine ältere veröffentlichte Version automatisch aktiv werden.';
    case 'ProzessVersionNotFound':
      return 'Diese Version existiert nicht mehr.';
    default:
      return 'Ein Fehler ist aufgetreten.';
  }
};

export type ProzessVersionenVerwaltenDialogProps = {
  prozessId: string;
};

export const ProzessVersionenVerwaltenDialog: FC<
  ProzessVersionenVerwaltenDialogProps
> = ({prozessId}) => {
  const {id: kommuneId} = useKommune();
  const [{data, fetching}, refetch] = useProzessVersionenFuerLoeschungQuery({
    variables: {kommuneId, prozessId},
    requestPolicy: 'network-only',
  });

  const versionen = useMemo(
    () =>
      [...(data?.kommune.prozessById.versionen ?? [])].sort(
        (a, b) => (b.createdAt?.getTime() ?? 0) - (a.createdAt?.getTime() ?? 0),
      ),
    [data],
  );
  const auswaehlbareVersionen = useMemo(
    () =>
      versionen.filter(
        (v) =>
          !v.hatAusfuehrungen &&
          !istLetzteVeroeffentlichteVersion(v, versionen) &&
          !istAktuelleVersion(v, versionen),
      ),
    [versionen],
  );

  const [selectedIds, setSelectedIds] = useState<ReadonlySet<string>>(
    new Set(),
  );
  const [rowErrors, setRowErrors] = useState<Record<string, string>>({});
  const [deleting, setDeleting] = useState(false);
  const confirm = useConfirm();
  const [, deleteProzessVersionMutation] = useDeleteProzessVersionMutation();

  const toggle = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  };

  const toggleAll = () => {
    setSelectedIds((prev) =>
      prev.size === auswaehlbareVersionen.length
        ? new Set()
        : new Set(auswaehlbareVersionen.map((v) => v.id)),
    );
  };

  const handleBulkDelete = async () => {
    if (selectedIds.size === 0) return;

    const confirmed = await confirm({
      title: 'Prozessversionen endgültig löschen',
      content: `${selectedIds.size} Prozessversion${
        selectedIds.size === 1 ? '' : 'en'
      } werden endgültig gelöscht und können danach nicht wiederhergestellt werden. Möchten Sie fortfahren?`,
      confirmText: 'Endgültig löschen',
      confirmVariant: 'destructive',
    });
    if (!confirmed) return;

    setDeleting(true);
    const newRowErrors: Record<string, string> = {};

    for (const id of selectedIds) {
      const result = await deleteProzessVersionMutation({input: {id}});
      if (mutationFailed(result)) {
        newRowErrors[id] = 'Ein Fehler ist aufgetreten.';
        continue;
      }
      const mutationError = result.data!.deleteProzessVersion.errors?.[0];
      if (mutationError) {
        newRowErrors[id] = errorMessageFor(mutationError.__typename);
      }
    }

    setRowErrors(newRowErrors);
    setSelectedIds(new Set(Object.keys(newRowErrors)));
    setDeleting(false);
    await refetch({requestPolicy: 'network-only'});
  };

  return (
    <Modal title='Versionen verwalten' className='max-w-2xl'>
      <div className='flex flex-col gap-3'>
        {fetching && versionen.length === 0 ? (
          <p className='text-sm text-gray-600'>Lädt…</p>
        ) : (
          <>
            <label className='flex items-center gap-2 text-sm font-semibold text-gray-700'>
              <input
                type='checkbox'
                checked={
                  auswaehlbareVersionen.length > 0 &&
                  selectedIds.size === auswaehlbareVersionen.length
                }
                disabled={auswaehlbareVersionen.length === 0}
                onChange={toggleAll}
              />
              Alle auswählen
            </label>

            <div className='flex max-h-[45vh] flex-col gap-1 overflow-y-auto'>
              {versionen.map((version) => {
                const letzteVeroeffentlichteVersion =
                  istLetzteVeroeffentlichteVersion(version, versionen);
                const aktuelleVersion = istAktuelleVersion(version, versionen);
                return (
                  <div key={version.id} className='flex flex-col gap-1'>
                    <label className='grid grid-cols-[auto_16rem_1fr] items-center gap-2 rounded p-1 text-sm hover:bg-gray-50 has-[:disabled]:text-gray-400'>
                      <input
                        type='checkbox'
                        checked={selectedIds.has(version.id)}
                        disabled={
                          version.hatAusfuehrungen ||
                          letzteVeroeffentlichteVersion ||
                          aktuelleVersion
                        }
                        onChange={() => toggle(version.id)}
                      />
                      <span>{formatVersionLabel(version)}</span>
                      <span className='flex flex-wrap gap-1'>
                        {version.hatAusfuehrungen && (
                          <span className='w-fit rounded-full border border-amber-500 bg-amber-200 px-2 text-center text-xs text-amber-700'>
                            Ausführungen zugeordnet
                          </span>
                        )}
                        {letzteVeroeffentlichteVersion && (
                          <span className='w-fit rounded-full border border-amber-500 bg-amber-200 px-2 text-center text-xs text-amber-700'>
                            Letzte veröffentlichte Version
                          </span>
                        )}
                        {aktuelleVersion && (
                          <span className='w-fit rounded-full border border-amber-500 bg-amber-200 px-2 text-center text-xs text-amber-700'>
                            Aktuell aktive Version
                          </span>
                        )}
                        {!version.hatAusfuehrungen &&
                          !letzteVeroeffentlichteVersion &&
                          !aktuelleVersion &&
                          versionen.length === 1 && (
                            <span className='w-fit rounded-full border border-amber-500 bg-amber-200 px-2 text-center text-xs text-amber-700'>
                              Löscht auch den Prozess
                            </span>
                          )}
                      </span>
                    </label>
                    {rowErrors[version.id] && (
                      <div className='ml-6 text-sm text-red-600'>
                        {rowErrors[version.id]}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            <div className='mt-2 flex items-center justify-between'>
              <span className='text-sm text-gray-600'>
                {selectedIds.size} von {auswaehlbareVersionen.length} löschbaren
                Versionen ausgewählt
              </span>
              <Button
                variant='destructive'
                disabled={selectedIds.size === 0 || deleting}
                onClick={handleBulkDelete}
              >
                Ausgewählte löschen
              </Button>
            </div>
          </>
        )}
      </div>
    </Modal>
  );
};
