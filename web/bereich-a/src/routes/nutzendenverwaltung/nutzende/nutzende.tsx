import {useFormBuilder} from '@atmina/formbuilder';
import {type FC, useState} from 'react';
import {MdArrowDropDown, MdSearch} from 'react-icons/md';
import {useAuth} from 'src/lib/context/auth/auth.tsx';
import {matchNutzerart} from 'src/lib/nutzerart.ts';
import {
  BackofficeNutzerArt,
  BackofficeNutzerStatus,
  FunktionsberechtigungInOrganisationseinheit,
} from '../../../__generated__/graphql.ts';
import {InputFormField} from '../../../components/form/fields/input-field';
import {SelectFormField} from '../../../components/form/fields/select-field';
import {IfFunktionsberechtigung} from '../../../components/if-funktionsberechtigung.tsx';
import {PageHeader, PageShell} from '../../../components/page-shell.tsx';
import {PageSizeSelect} from '../../../components/page-size-select.tsx';
import {Pagination, usePage} from '../../../components/pagination.tsx';
import {
  ResponsiveField,
  ResponsiveListContainer,
  ResponsiveListHeader,
  ResponsiveListRow,
  responsiveListSlots,
} from '../../../components/responsive-list/responsive-list.tsx';
import {Skeleton} from '../../../components/skeleton.tsx';
import {Button} from '../../../components/ui/button';
import {DropdownMenu} from '../../../components/ui/dropdown-menu/dropdown-menu.tsx';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';
import {hasFunktionsberechtigungInAnyOrganisationseinheit} from '../../../lib/funktionsberechtigung.ts';
import {NutzendenBearbeiten} from './actions/nutzenden-bearbeiten.tsx';
import {NutzendenLoeschen} from './actions/nutzenden-loeschen.tsx';
import {ShowDienstleisterEinladenDialogButton} from './dienstleister-einladen.tsx';
import {
  type BackofficeUserOrganisationseinheitFragment,
  type MitarbeiterGruppeFragment,
  type NutzendeListItemFragment,
  useNutzendeQuery,
} from './nutzende.generated.ts';
import {ShowNutzendenEinladenDialogButton} from './nutzenden-einladen.tsx';
import {OrganisationseinheitVerwalten} from './organisationseinheit-verwalten.tsx';
import {PendingConfirmation} from './pending-confirmation/pending-confirmation.tsx';

/**
 * Typ für die Suchparameter der Nutzendenverwaltung.
 */
type NutzendeSearch = {
  search: string;
  gruppe: string | undefined;
  art: BackofficeNutzerArt | undefined;
};

/**
 * Typ für eine Mitarbeitergruppe mit ID und Name.
 */
type MitarbeiterGruppe = {
  id: string;
  name: string;
};

// Spaltenraster (erst ab `lg`). Bewusst statische Strings, damit Tailwind sie erkennt.
const GRID_COLS = 'lg:grid-cols-[9rem_8rem_8rem_1fr_1.4fr_8rem]';

/**
 * Hauptkomponente zur Anzeige und Verwaltung der Nutzenden.
 * Enthält Such- und Filterfunktionen, Listenanzeige und Aktionen zum Einladen, Bearbeiten und Löschen.
 */
export const Nutzende = () => {
  const {user, refetch: refetchCurrentUser} = useAuth();
  const formBuilder = useFormBuilder<NutzendeSearch>();
  const page = usePage();
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.nutzende);
  const [activeDialog, setActiveDialog] = useState<
    'einladen' | 'dienstleister' | 'organisationseinheit' | null
  >(null);

  const search = formBuilder.fields.search.$useWatch();
  const gruppe = formBuilder.fields.gruppe.$useWatch();
  const art = formBuilder.fields.art.$useWatch();
  const nurDienstleister = gruppe === 'externe';
  const groupId = gruppe != null && gruppe !== 'externe' ? gruppe : undefined;

  const [{data, fetching}, refetchQuery] = useNutzendeQuery({
    variables: {
      search: search,
      groupId,
      nurDienstleister: nurDienstleister || undefined,
      art,
      skip: page * seitengroesse,
      take: seitengroesse,
    },
  });

  const refetch = () => {
    refetchCurrentUser();
    refetchQuery({requestPolicy: 'network-only'});
  };

  if (!data) return null;

  const abteilungen =
    data.my.__typename === 'BackofficeUser'
      ? data.my.kommune.mitarbeiterGruppen
      : [];

  const nutzende =
    data.my.__typename === 'BackofficeUser'
      ? data.my.kommune.mitarbeiter?.items ?? []
      : [];

  const total =
    data.my.__typename === 'BackofficeUser'
      ? data.my.kommune.mitarbeiter?.totalCount ?? 0
      : 0;
  const pages = Math.ceil(total / seitengroesse);

  const canUpdateDienstleister =
    hasFunktionsberechtigungInAnyOrganisationseinheit(
      user,
      FunktionsberechtigungInOrganisationseinheit.BackofficeDienstleisterverwaltung,
    );

  return (
    <PageShell>
      <PageHeader
        title='Nutzendenverwaltung'
        description={
          <>
            In der Tabelle finden Sie eine Übersicht aller Nutzenden
            {user?.art === BackofficeNutzerArt.Superadmin
              ? ' und können die jeweiligen Gruppen bearbeiten'
              : ''}
            . Mit der Suche können Sie einzelne Nutzende suchen.
          </>
        }
        actions={
          <>
            <DropdownMenu>
              <DropdownMenu.Trigger asChild>
                <Button variant='outlined' endAdornment={<MdArrowDropDown />}>
                  Verwalten
                </Button>
              </DropdownMenu.Trigger>
              <DropdownMenu.Portal>
                <DropdownMenu.Content align='end'>
                  <DropdownMenu.Item
                    onSelect={() => setActiveDialog('einladen')}
                  >
                    Nutzer einladen
                  </DropdownMenu.Item>

                  <IfFunktionsberechtigung
                    funktionsberechtigung={
                      FunktionsberechtigungInOrganisationseinheit.BackofficeDienstleisterverwaltung
                    }
                  >
                    <DropdownMenu.Item
                      onSelect={() => setActiveDialog('dienstleister')}
                    >
                      Dienstleister einladen
                    </DropdownMenu.Item>
                  </IfFunktionsberechtigung>

                  {user &&
                    matchNutzerart(user.art, BackofficeNutzerArt.Admin) && (
                      <DropdownMenu.Item
                        onSelect={() => setActiveDialog('organisationseinheit')}
                      >
                        Organisationseinheit verwalten
                      </DropdownMenu.Item>
                    )}
                </DropdownMenu.Content>
              </DropdownMenu.Portal>
            </DropdownMenu>

            <ShowNutzendenEinladenDialogButton
              open={activeDialog === 'einladen'}
              onOpenChange={(open) => !open && setActiveDialog(null)}
              onInvite={() => refetch()}
            />
            <ShowDienstleisterEinladenDialogButton
              open={activeDialog === 'dienstleister'}
              onOpenChange={(open) => !open && setActiveDialog(null)}
              onInvite={() => refetch()}
            />
            {user && matchNutzerart(user.art, BackofficeNutzerArt.Admin) && (
              <OrganisationseinheitVerwalten
                abteilungen={abteilungen}
                onSaveDeleteOrUpdate={() => refetch()}
                canUpdateDienstleister={canUpdateDienstleister}
                open={activeDialog === 'organisationseinheit'}
                onOpenChange={(open) => !open && setActiveDialog(null)}
              />
            )}
          </>
        }
      />

      <PendingConfirmation />

      <div className='flex flex-wrap items-center gap-4'>
        <InputFormField
          on={formBuilder.fields.search}
          label='Name oder E-Mail-Adresse suchen...'
          endAdornment={<MdSearch className='text-gray-400' />}
          className='w-full sm:w-96'
        />

        <SelectFormField
          on={formBuilder.fields.gruppe}
          label='Nach Gruppen filtern'
          items={[
            {key: 'alle', name: 'Alle Gruppen', value: undefined},
            {key: 'externe', name: 'Externe Dienstleister', value: 'externe'},
            {
              key: 'separator-externe',
              separator: true,
              value: undefined,
            },
            ...abteilungen.map((g) => ({
              key: g.id,
              value: g.id,
              name: g.name,
            })),
          ]}
          className='w-full sm:w-60'
        />

        <SelectFormField
          on={formBuilder.fields.art}
          label='Nach Art filtern'
          items={[
            {key: 'alle', name: 'Alle Arten', value: undefined},
            ...Object.values(BackofficeNutzerArt).map((wert) => ({
              key: wert,
              value: wert,
              name: arten[wert],
            })),
          ]}
          className='w-full sm:w-60'
        />
      </div>

      <ResponsiveListContainer>
        <ResponsiveListHeader gridCols={GRID_COLS}>
          <div>Art</div>
          <div>Vorname</div>
          <div>Nachname</div>
          <div>E-Mail Adresse</div>
          <div>Zuordnungen</div>
          <div aria-hidden />
        </ResponsiveListHeader>

        {!fetching && nutzende.length === 0 ? (
          <p className='px-4 py-6 text-gray-600'>Keine Nutzenden gefunden.</p>
        ) : (
          <ul>
            {responsiveListSlots(fetching, seitengroesse, nutzende.length).map(
              (i) => (
                <li key={nutzende[i]?.id ?? i}>
                  {fetching || !nutzende[i] ? (
                    <NutzendeRowSkeleton even={i % 2 === 0} />
                  ) : (
                    <NutzendeRow
                      even={i % 2 === 0}
                      nutzender={nutzende[i]}
                      abteilungen={abteilungen}
                      availableFunktionsberechtigungen={
                        data.availableFunktionsberechtigungen
                      }
                      onUpdate={refetch}
                      onDelete={refetch}
                    />
                  )}
                </li>
              ),
            )}
          </ul>
        )}
      </ResponsiveListContainer>

      <div className='flex flex-col-reverse items-center gap-3 sm:flex-row sm:justify-between'>
        <PageSizeSelect listKey='nutzende' />
        <Pagination className='bg-white sm:w-auto' totalPages={pages} />
      </div>
    </PageShell>
  );
};

/**
 * Mapping der Nutzerarten auf ihre deutsche Bezeichnung.
 */
const arten: Record<BackofficeNutzerArt, string> = {
  [BackofficeNutzerArt.Nutzer]: 'Nutzer',
  [BackofficeNutzerArt.Admin]: 'Administrator',
  [BackofficeNutzerArt.Superadmin]: 'Super-Administrator',
  [BackofficeNutzerArt.Dienstleister]: 'Externer Dienstleister',
};

/**
 * Mapping der Nutzerstatus auf ihre deutsche Bezeichnung.
 */
const statuses: Record<BackofficeNutzerStatus, string> = {
  [BackofficeNutzerStatus.Registered]: 'Registriert',
  [BackofficeNutzerStatus.Invited]: 'Eingeladen',
  [BackofficeNutzerStatus.InvitationExpired]: 'Einladung abgelaufen',
};

/**
 * Komponente zur Anzeige der Nutzerart und des Status.
 * @param art Nutzerart
 * @param status Optionaler Nutzerstatus
 */
const StatusColumn = ({
  art,
  status,
}: {
  art: BackofficeNutzerArt;
  status?: BackofficeNutzerStatus;
}) => (
  <>
    {arten[art]}
    {status && status != BackofficeNutzerStatus.Registered && (
      <div className='text-sm text-primary'>{statuses[status]}</div>
    )}
  </>
);

/**
 * Komponente zur Anzeige der Zuordnungen eines Nutzenden.
 * Zeigt Organisationseinheiten und Gruppen bzw. Dienstleister an.
 * @param organisationseinheiten Zugeordnete Organisationseinheiten
 * @param gruppen Zugeordnete Mitarbeitergruppen
 * @param dienstleister Optional zugeordneter Dienstleister
 * @param userIsExterneDienstleister Ob der Nutzende ein externer Dienstleister ist
 */
const ZuordnungenColumn = ({
  organisationseinheiten,
  gruppen,
  dienstleister,
  userIsExterneDienstleister,
}: {
  organisationseinheiten: BackofficeUserOrganisationseinheitFragment[];
  gruppen: MitarbeiterGruppe[];
  dienstleister?: {name: string} | null;
  userIsExterneDienstleister: boolean;
}) => {
  if (userIsExterneDienstleister) {
    const dienstleisterName = dienstleister?.name ?? 'Kein Dienstleister';

    return (
      <div className='truncate' title={dienstleisterName}>
        {dienstleisterName}
      </div>
    );
  }

  const einheitenText = organisationseinheiten
    .map((einheit) => einheit.organisationseinheit.name)
    .join(', ');
  const gruppenText = [...gruppen, dienstleister]
    .filter(Boolean)
    .map((g) => g?.name)
    .filter((s) => !!s)
    .join(', ');

  return (
    <>
      <div className='truncate' title={einheitenText}>
        {einheitenText || 'Keine Organisationseinheiten'}
      </div>
      <div className='truncate text-sm text-gray-900' title={gruppenText}>
        {gruppenText}
      </div>
    </>
  );
};

/**
 * Eine Zeile der Nutzenden-Liste. Kein `NavLink`, da Bearbeiten/Löschen als eigene
 * Buttons/Dialoge innerhalb der Zeile liegen.
 */
const NutzendeRow: FC<{
  even: boolean;
  nutzender: NutzendeListItemFragment;
  abteilungen: MitarbeiterGruppeFragment[];
  availableFunktionsberechtigungen: Parameters<
    typeof NutzendenBearbeiten
  >[0]['availableFunktionsberechtigungen'];
  onUpdate: () => void;
  onDelete: () => void;
}> = ({
  even,
  nutzender: n,
  abteilungen,
  availableFunktionsberechtigungen,
  onUpdate,
  onDelete,
}) => (
  <ResponsiveListRow even={even} gridCols={GRID_COLS}>
    <ResponsiveField label='Art'>
      <StatusColumn art={n.art} status={n.status} />
    </ResponsiveField>
    <ResponsiveField label='Vorname'>{n.vorname}</ResponsiveField>
    <ResponsiveField label='Nachname'>{n.nachname}</ResponsiveField>
    <ResponsiveField label='E-Mail Adresse'>{n.eMail}</ResponsiveField>
    <ResponsiveField label='Zuordnungen'>
      <ZuordnungenColumn
        userIsExterneDienstleister={n.art === BackofficeNutzerArt.Dienstleister}
        {...n}
      />
    </ResponsiveField>
    <div className='flex items-center gap-1 self-center justify-self-start lg:justify-self-end'>
      <NutzendenBearbeiten
        nutzender={n}
        gruppen={abteilungen}
        disabled={
          !n.canBeUpdated || n.art === BackofficeNutzerArt.Dienstleister
        }
        onUpdate={onUpdate}
        availableFunktionsberechtigungen={availableFunktionsberechtigungen}
      />

      <NutzendenLoeschen
        userId={n.id}
        userName={n.nachname ? `${n.vorname} ${n.nachname}` : n.eMail}
        disabled={!n.canBeDeleted}
        onDelete={onDelete}
      />
    </div>
  </ResponsiveListRow>
);

const NutzendeRowSkeleton: FC<{even: boolean}> = ({even}) => (
  <ResponsiveListRow even={even} gridCols={GRID_COLS}>
    <Skeleton className='w-20' />
    <Skeleton className='w-24' />
    <Skeleton className='w-24' />
    <Skeleton className='w-40' />
    <Skeleton className='w-full' />
    <div className='hidden lg:block' />
  </ResponsiveListRow>
);
