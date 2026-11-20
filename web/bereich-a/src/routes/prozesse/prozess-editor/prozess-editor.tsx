import {ReactFlowProvider} from '@xyflow/react';
import {useEffect, useMemo, useRef, type FC} from 'react';
import {useParams} from 'react-router';
import {EditorPane} from './components/editor-pane.tsx';
import {ProzessSidebar} from './components/prozess-sidebar.tsx';
import {Topbar} from './components/topbar.tsx';
import {VerbindungSidebar} from './components/verbindung-sidebar.tsx';
import {useProzessEditorStore} from './lib/store/index.ts';
import {type ZustaendigkeitCatalog} from './lib/validate-prozess.ts';
import {useProgrammatischeSchritteQuery} from './programmatische-schritte.generated.ts';
import {
  useGetProzessByIdQuery,
  useMoeglicheZustaendigeQuery,
} from './prozess-editor.generated.ts';

/**
 * Hauptkomponente des Prozess-Editors, die den Editor mit den zugehörigen Sidebars und der Topbar rendert.
 * Lädt den Prozess anhand der URL-Parameter und initialisiert den internen Zustand des Editors.
 */
export const ProzessEditor: FC = () => {
  const initializeFromProzess = useProzessEditorStore(
    (state) => state.initializeFromProzess,
  );
  const setCatalog = useProzessEditorStore((state) => state.setCatalog);

  const {id} = useParams();

  const [{data}] = useGetProzessByIdQuery({
    variables: {prozessId: id ?? ''},
    pause: !id,
  });
  const prozess =
    data?.my.__typename == 'BackofficeUser'
      ? data.my.kommune.prozessById
      : null;

  const [{data: zustaendigeData}] = useMoeglicheZustaendigeQuery();
  const [{data: programmatischeSchritteData}] =
    useProgrammatischeSchritteQuery();
  const catalog = useMemo<ZustaendigkeitCatalog | null>(() => {
    if (zustaendigeData?.my.__typename !== 'BackofficeUser') return null;
    const {organisationseinheiten, dienstleister} = zustaendigeData.my.kommune;
    return {
      liefertZustaendigkeitImpls: new Set(
        (programmatischeSchritteData?.programmatischeSchritte ?? [])
          .filter((s) => s.liefertZustaendigkeit)
          .map((s) => s.implementationAssemblyQualifiedName),
      ),
      oeGroups: new Map(
        organisationseinheiten.map((oe) => [
          oe.id,
          new Set(oe.mitarbeiterGruppen.map((g) => g.id)),
        ]),
      ),
      dienstleisterOEs: new Map(
        dienstleister.map((dl) => [
          dl.id,
          new Set(dl.organisationseinheiten.map((o) => o.id)),
        ]),
      ),
      mitarbeiterGruppenWithoutEmail: new Set(
        organisationseinheiten.flatMap((oe) =>
          oe.mitarbeiterGruppen
            .filter((g) => g.eMailAdressen.length === 0)
            .map((g) => g.id),
        ),
      ),
      dienstleisterWithoutEmail: new Set(
        dienstleister
          .filter((dl) => dl.eMailAdressen.length === 0)
          .map((dl) => dl.id),
      ),
    };
  }, [zustaendigeData?.my, programmatischeSchritteData]);

  useEffect(() => {
    if (catalog) setCatalog(catalog);
  }, [catalog, setCatalog]);

  // Nur bei Wechsel des Prozesses neu initialisieren. Ein erneutes Laden der
  // Query (z. B. nach dem sofortigen Umbenennen) darf die im Graph gehaltenen,
  // noch nicht gespeicherten Änderungen nicht überschreiben.
  const initializedProzessId = useRef<string | null>(null);
  useEffect(
    () => () => {
      initializedProzessId.current = null;
      initializeFromProzess(null);
    },
    [initializeFromProzess],
  );
  useEffect(() => {
    if (prozess != null && initializedProzessId.current !== prozess.id) {
      initializedProzessId.current = prozess.id;
      initializeFromProzess(prozess);
    }
  }, [prozess, initializeFromProzess]);

  // Remount the sidebar on selection change to reset its form state. Selection lives on
  // the controlled graph (`node.selected`), so the id is read straight from the store. Only
  // a single-node selection drives the sidebar (matching ProzessSidebar).
  const selectedSchrittId = useProzessEditorStore((state) => {
    const selected = state.nodes.filter((n) => n.selected);
    return selected.length === 1 ? selected[0].id : undefined;
  });

  return (
    <ReactFlowProvider>
      <div className='flex h-full overflow-hidden'>
        <div className='flex flex-1 flex-col'>
          <Topbar />

          <div className='flex flex-1'>
            <EditorPane />
          </div>
        </div>
        {/*Workaround fix to prevent inconsistent state*/}
        <ProzessSidebar key={selectedSchrittId} />
        <VerbindungSidebar />
      </div>

      <div
        id='kommunalapp-grid-measurement-container'
        className='invisible absolute -z-10'
      />
    </ReactFlowProvider>
  );
};
