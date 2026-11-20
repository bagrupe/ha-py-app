import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useState} from 'react';
import {
  MdEdit,
  MdOutlineAccountTree,
  MdOutlineHistory,
  MdOutlinePauseCircle,
  MdOutlinePlayCircle,
} from 'react-icons/md';
import SVG from 'react-inlinesvg';
import {Link} from 'react-router';
import Delete from '../../../../assets/delete.svg';
import {useConfirm} from '../../../../components/modal/confirm-modal.tsx';
import {
  ResponsiveField,
  ResponsiveListRow,
} from '../../../../components/responsive-list/responsive-list.tsx';
import {ToolTip} from '../../../../components/ui/tool-tip.tsx';
import {mutationFailed} from '../../../../lib/mutation.ts';
import {PROZESSE_GRID_COLS} from '../grid-cols.ts';
import {ProzessTagsVerwalten} from '../prozess-tags-verwalten.tsx';
import {ProzesseVerwalten} from '../prozesse-verwalten.tsx';
import {
  type ProzessGroup,
  type ProzessTag,
  type UserFacingProzess,
  type UserFacingProzess_Prozess,
  type UserFacingProzess_ServicePortalLink,
  useDeleteProzessMutation,
  useDeleteServicePortalLinkMutation,
  useProzessAktivierenMutation,
  useProzessDeaktivierenMutation,
} from '../prozesse.generated.ts';
import {ProzessVersionenVerwaltenDialog} from './prozess-versionen/prozess-versionen-verwalten-dialog.tsx';
import {ServicePortalLinkBearbeitenDialog} from './service-portal-link/service-portal-link-bearbeiten-dialog.tsx';

/**
 * Komponente zur Darstellung einer Tabellenzeile für einen Prozess.
 * Zeigt den Namen, die zugehörigen Gruppen und spezielle Spalten je nach Prozess-Typ an.
 * @param prozess Der darzustellende Prozess.
 * @param prozessGroups Die verfügbaren Prozessgruppen.
 * @param alleTags Alle im System vorhandenen Prozess-Tags.
 * @param even Zebra-Streifen: gerade oder ungerade Zeile.
 */
export const ProzessRow: FC<{
  prozess: UserFacingProzess;
  prozessGroups: ProzessGroup[];
  alleTags: ProzessTag[];
  even: boolean;
}> = ({prozess, prozessGroups, alleTags, even}) => (
  <ResponsiveListRow even={even} gridCols={PROZESSE_GRID_COLS}>
    <ResponsiveField label='Name'>
      <span className='flex items-center gap-2'>
        <span className='font-semibold'>{prozess.name}</span>
        {prozess.__typename === 'Prozess' && prozess.deaktiviertAm != null && (
          <span className='rounded-full border border-gray-300 bg-gray-100 px-2 py-0.5 text-xs font-semibold text-gray-700'>
            Deaktiviert
          </span>
        )}
        {prozess.__typename === 'Prozess' && (
          <ProzessTagsVerwalten prozess={prozess} tags={alleTags} />
        )}
      </span>
    </ResponsiveField>
    <ResponsiveField label='Gruppe'>
      <div className='flex items-center gap-2'>
        <ProzesseVerwalten gruppen={prozessGroups} prozess={prozess} />
        <div>{prozess.group?.name}</div>
      </div>
    </ResponsiveField>

    <ProzessRowSpecialColumns prozess={prozess} />
  </ResponsiveListRow>
);

/**
 * Komponente zur Darstellung der speziellen Spalten einer Prozess-Zeile.
 * Unterscheidet die Darstellung je nach Typ des Prozesses.
 * @param prozess Der Prozess, dessen spezielle Spalten dargestellt werden.
 */
const ProzessRowSpecialColumns: FC<{prozess: UserFacingProzess}> = ({
  prozess,
}) => {
  switch (prozess.__typename) {
    case 'Prozess':
      return <ProzessRowProzessSpecialColumns prozess={prozess} />;
    case 'ServicePortalLink':
      return <ProzessRowServicePortalLinkSpecialColumns link={prozess} />;
    default:
      return (
        <>
          <ResponsiveField label='Version'>{null}</ResponsiveField>
          <ResponsiveField label='Aktion'>{null}</ResponsiveField>
        </>
      );
  }
};

const ProzessRowProzessSpecialColumns: FC<{
  prozess: UserFacingProzess_Prozess;
}> = ({prozess}) => {
  const [versionenDialogOpen, setVersionenDialogOpen] = useState(false);

  return (
    <>
      <ResponsiveField label='Version'>
        {prozess.versionenCount}
      </ResponsiveField>
      <ResponsiveField label='Aktion'>
        <div className='flex items-center justify-end gap-1'>
          <ToolTip tip='Ablauf bearbeiten' asChild>
            <Link
              to={`/prozesse/${prozess.id}`}
              aria-label='Ablauf bearbeiten'
              className='rounded-full p-2 text-primary hover:bg-black/10'
            >
              <MdOutlineAccountTree className='size-6' />
            </Link>
          </ToolTip>

          {prozess.versionenCount > 0 && (
            <Dialog.Root
              open={versionenDialogOpen}
              onOpenChange={setVersionenDialogOpen}
            >
              <ToolTip tip='Versionen verwalten' asChild>
                <Dialog.Trigger asChild>
                  <button
                    type='button'
                    aria-label='Versionen verwalten'
                    className='rounded-full p-2 text-primary hover:bg-black/10'
                  >
                    <MdOutlineHistory className='size-6' />
                  </button>
                </Dialog.Trigger>
              </ToolTip>
              {versionenDialogOpen && (
                <ProzessVersionenVerwaltenDialog prozessId={prozess.id} />
              )}
            </Dialog.Root>
          )}

          <ProzessAktivStatusButton
            prozessId={prozess.id}
            deaktiviertAm={prozess.deaktiviertAm}
          />

          <ProzessLoeschenButton
            prozessId={prozess.id}
            disabledReason={
              prozess.versionenCount > 0
                ? 'Dieser Prozess hat noch Versionen. Löschen Sie zuerst alle Versionen über "Versionen verwalten".'
                : undefined
            }
          />
        </div>
      </ResponsiveField>
    </>
  );
};

const ProzessAktivStatusButton: FC<{
  prozessId: string;
  deaktiviertAm: Date | null | undefined;
}> = ({prozessId, deaktiviertAm}) => {
  const [error, setError] = useState('');
  const confirm = useConfirm();
  const [{fetching: deaktivierenFetching}, deaktivierenMutation] =
    useProzessDeaktivierenMutation();
  const [{fetching: aktivierenFetching}, aktivierenMutation] =
    useProzessAktivierenMutation();
  const istDeaktiviert = deaktiviertAm != null;

  const handleClick = async () => {
    if (!istDeaktiviert) {
      const confirmed = await confirm({
        title: 'Prozess deaktivieren',
        content:
          'Bürger:innen können danach keine neuen Anträge mehr für diesen Prozess starten. Bestehende Anträge sind nicht betroffen. Möchten Sie fortfahren?',
        confirmText: 'Deaktivieren',
      });
      if (!confirmed) return;
    }

    if (istDeaktiviert) {
      const result = await aktivierenMutation({input: {id: prozessId}});
      setError(
        mutationFailed(result) || result.data!.prozessAktivieren.errors?.[0]
          ? 'Ein Fehler ist aufgetreten.'
          : '',
      );
      return;
    }

    const result = await deaktivierenMutation({input: {id: prozessId}});
    setError(
      mutationFailed(result) || result.data!.prozessDeaktivieren.errors?.[0]
        ? 'Ein Fehler ist aufgetreten.'
        : '',
    );
  };

  const label = istDeaktiviert ? 'Prozess aktivieren' : 'Prozess deaktivieren';

  return (
    <div className='flex flex-col items-center gap-1'>
      <ToolTip tip={label} asChild>
        <button
          type='button'
          aria-label={label}
          className='rounded-full p-2 text-primary hover:bg-black/10 disabled:opacity-50'
          disabled={deaktivierenFetching || aktivierenFetching}
          onClick={handleClick}
        >
          {istDeaktiviert ? (
            <MdOutlinePlayCircle className='size-6' />
          ) : (
            <MdOutlinePauseCircle className='size-6' />
          )}
        </button>
      </ToolTip>
      {error && <div className='text-sm text-red-600'>{error}</div>}
    </div>
  );
};

const ProzessLoeschenButton: FC<{
  prozessId: string;
  disabledReason?: string;
}> = ({prozessId, disabledReason}) => {
  const [error, setError] = useState('');
  const confirm = useConfirm();
  const [{fetching}, deleteProzessMutation] = useDeleteProzessMutation();

  const handleDelete = async () => {
    if (disabledReason) return;

    const confirmed = await confirm({
      title: 'Prozess endgültig löschen',
      content:
        'Dieser Prozess wird endgültig gelöscht und kann danach nicht wiederhergestellt werden. Möchten Sie fortfahren?',
      confirmText: 'Endgültig löschen',
      confirmVariant: 'destructive',
    });
    if (!confirmed) return;

    const result = await deleteProzessMutation({input: {id: prozessId}});
    if (mutationFailed(result)) {
      setError('Ein Fehler ist aufgetreten.');
      return;
    }

    const mutationError = result.data!.deleteProzess.errors?.[0];
    if (!mutationError) {
      setError('');
      return;
    }

    setError('Ein Fehler ist aufgetreten.');
  };

  const button = (
    <button
      type='button'
      aria-label='Prozess löschen'
      className={`rounded-full p-2 text-red-500 hover:bg-black/10 disabled:opacity-50 ${
        disabledReason ? 'opacity-50' : ''
      }`}
      disabled={fetching}
      aria-disabled={disabledReason != null}
      onClick={handleDelete}
    >
      <SVG src={Delete} className='size-6 shrink-0 fill-red-500' />
    </button>
  );

  return (
    <div className='flex flex-col items-center gap-1'>
      <ToolTip tip={disabledReason ?? 'Prozess löschen'} asChild>
        {button}
      </ToolTip>
      {error && <div className='text-sm text-red-600'>{error}</div>}
    </div>
  );
};

/**
 * Komponente zur Darstellung spezieller Spalten für Service-Portal-Links in der Prozess-Tabelle.
 * Zeigt einen Link, einen Button zum Bearbeiten des Links in einem Dialog und eine Löschen-Aktion an.
 * @param link Der Service-Portal-Link, der dargestellt wird.
 */
const ProzessRowServicePortalLinkSpecialColumns: FC<{
  link: UserFacingProzess_ServicePortalLink;
}> = ({link}) => {
  const [open, setOpen] = useState(false);
  const [error, setError] = useState('');
  const confirm = useConfirm();
  const [{fetching}, deleteServicePortalLinkMutation] =
    useDeleteServicePortalLinkMutation();

  const handleDelete = async () => {
    const confirmed = await confirm({
      title: 'Service-Portal-Link endgültig löschen',
      content:
        'Dieser Service-Portal-Link wird endgültig gelöscht und kann danach nicht wiederhergestellt werden. Möchten Sie fortfahren?',
      confirmText: 'Endgültig löschen',
      confirmVariant: 'destructive',
    });
    if (!confirmed) return;

    const result = await deleteServicePortalLinkMutation({
      input: {id: link.id},
    });
    if (mutationFailed(result)) {
      setError('Ein Fehler ist aufgetreten.');
      return;
    }

    const mutationError = result.data!.deleteServicePortalLink.errors?.[0];
    if (!mutationError) {
      setError('');
      return;
    }

    setError('Ein Fehler ist aufgetreten.');
  };

  return (
    <>
      <ResponsiveField label='Version'>
        <a
          href={link.url}
          target='_blank'
          className='text-primary hover:underline'
          rel='noreferrer'
        >
          Link
        </a>
      </ResponsiveField>
      <ResponsiveField label='Aktion'>
        <div className='flex items-center justify-end gap-1'>
          <Dialog.Root open={open} onOpenChange={setOpen}>
            <ToolTip tip='Link bearbeiten' asChild>
              <Dialog.Trigger asChild>
                <button
                  type='button'
                  aria-label='Link bearbeiten'
                  className='rounded-full p-2 text-primary hover:bg-black/10'
                >
                  <MdEdit className='size-6' />
                </button>
              </Dialog.Trigger>
            </ToolTip>
            <ServicePortalLinkBearbeitenDialog
              id={link.id}
              onAfterSave={() => setOpen(false)}
            />
          </Dialog.Root>
          <ToolTip tip='Löschen' asChild>
            <button
              type='button'
              aria-label='Löschen'
              className='rounded-full p-2 text-red-500 hover:bg-black/10 disabled:opacity-50'
              disabled={fetching}
              onClick={handleDelete}
            >
              <SVG src={Delete} className='size-6 shrink-0 fill-red-500' />
            </button>
          </ToolTip>
        </div>
        {error && <div className='text-sm text-red-600'>{error}</div>}
      </ResponsiveField>
    </>
  );
};
