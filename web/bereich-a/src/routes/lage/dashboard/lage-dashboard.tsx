import {type FC} from 'react';
import {Navigate, useParams} from 'react-router';
import {
  BackofficeNutzerArt,
  LageStatus,
} from '../../../__generated__/graphql.ts';
import {Button} from '../../../components/ui/button';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {
  DashboardHeader,
  KeineLage,
  LEITSTELLE,
  istMeldewegOffen,
} from './dashboard-ui.tsx';
import {EinsatzleitungAnsicht} from './einsatzleitung-ansicht.tsx';
import {LeitstelleAnsicht} from './leitstelle-ansicht.tsx';
import {useLageDashboard} from './use-lage-dashboard.ts';
import {useMeldungAktionen} from './use-meldung-aktionen.ts';

/** Admins and Superadmins act as Leitstelle, as in the backend. */
const useRolle = () => {
  const {user} = useAuth();
  const istLeitstelle =
    user?.art === BackofficeNutzerArt.Admin ||
    user?.art === BackofficeNutzerArt.Superadmin;
  const gruppenIds = user?.gruppen.map((g) => g.id) ?? [];
  return {istLeitstelle, gruppenIds};
};

/** /lage/dashboard: picks the view that fits the signed-in user. */
export const DashboardEinstieg: FC = () => {
  const {istLeitstelle, gruppenIds} = useRolle();
  const data = useLageDashboard();
  if (istLeitstelle) return <Navigate to='/lage/leitstelle' replace />;
  if (data.loading) return null;
  const eigene = data.einsatzleitungen.find((el) => gruppenIds.includes(el.id));
  return eigene ? (
    <Navigate to={`/lage/einsatzleitung/${eigene.id}`} replace />
  ) : (
    <div className='m-6 rounded-xl border border-gray-300 bg-white p-6'>
      Sie gehören zu keiner Einsatzleitung. Bitte wenden Sie sich an die
      Leitstelle.
    </div>
  );
};

const DashboardSeite: FC<{ansicht: string}> = ({ansicht}) => {
  const {istLeitstelle, gruppenIds} = useRolle();
  const data = useLageDashboard();
  const aktionen = useMeldungAktionen(data.refetch);
  const {lage} = data;

  const ansichten = istLeitstelle
    ? data.einsatzleitungen
    : data.einsatzleitungen.filter((el) => gruppenIds.includes(el.id));
  const leitstelle = ansicht === LEITSTELLE;

  if (data.loading) return null;

  const meldewegSchalter =
    leitstelle && istLeitstelle && lage && lage.status !== LageStatus.Closed ? (
      istMeldewegOffen(lage) ? (
        <Button
          variant='outlined-secondary'
          className='border-gray-500 py-1.5 text-sm text-white enabled:hover:bg-gray-700'
          onClick={() => void aktionen.meldeweg(lage.id, false)}
        >
          Offline nehmen
        </Button>
      ) : lage.meldewegPausiertSeit ? (
        <Button
          variant='solid'
          className='bg-success py-1.5 text-sm'
          onClick={() => void aktionen.meldeweg(lage.id, true)}
        >
          Online nehmen
        </Button>
      ) : null
    ) : null;

  return (
    <div className='min-h-full bg-gray-100'>
      <DashboardHeader
        bereich={leitstelle ? 'Leitstelle' : 'Einsatzleitung'}
        lage={lage}
        ansicht={ansicht}
        ansichten={ansichten}
        mitLeitstelle={istLeitstelle}
        aktualisiert={data.aktualisiert}
        aktionen={meldewegSchalter}
      />
      {!lage ? (
        <KeineLage />
      ) : leitstelle ? (
        istLeitstelle ? (
          <LeitstelleAnsicht data={data} aktionen={aktionen} />
        ) : (
          <div className='m-6 rounded-xl border border-gray-300 bg-white p-6'>
            Die Ansicht Leitstelle ist Admins und Superadmins vorbehalten.
          </div>
        )
      ) : (
        <EinsatzleitungAnsicht
          data={data}
          gruppeId={ansicht}
          aktionen={aktionen}
        />
      )}
    </div>
  );
};

export const LeitstelleSeite: FC = () => (
  <DashboardSeite ansicht={LEITSTELLE} />
);

export const EinsatzleitungSeite: FC = () => {
  const {gruppeId} = useParams<{gruppeId: string}>();
  return <DashboardSeite key={gruppeId} ansicht={gruppeId!} />;
};
