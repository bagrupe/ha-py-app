import {useFormBuilder} from '@atmina/formbuilder';
import {useReactFlow} from '@xyflow/react';
import {type FC, useCallback, useState, useMemo} from 'react';
import {MdOutlineBackspace} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {Form} from '../../../../components/form/form.tsx';
import {Sidebar} from '../../../../components/sidebar/sidebar.tsx';
import {Button} from '../../../../components/ui/button';
import {type SchrittDaten} from '../lib/domain-types.ts';
import {getDeleteAction} from '../lib/node-helpers.ts';
import {resolveSollZustaendigkeitForArt} from '../lib/soll-zustaendigkeit.ts';
import {isStepDirty} from '../lib/step-dirty.ts';
import {useProzessEditorStore} from '../lib/store';
import {EmailWeiterleitenSchritt} from './form/email-weiterleiten-schritt.tsx';
import {FormularSchrittForm} from './form/formular-schritt-form.tsx';
import {GovManagerRestExportSchritt} from './form/govmanager-export-schritt.tsx';
import {ProgrammatischerSchritt} from './form/programmatischer-schritt.tsx';
import {
  EMailBenachrichtigungForm,
  SollZustaendigkeitForm,
  ZustaendigkeitRolleForm,
} from './form/soll-zustaendigkeit-form.tsx';
import {SidebarHeader} from './sidebar-header.tsx';

type ProzessSchrittForm = SchrittDaten;

/**
 * Sidebar-Komponente für die Bearbeitung von Prozessschritten im Editor.
 * Zeigt das Formular für den aktuell ausgewählten Schritt an und ermöglicht
 * das Bearbeiten, Übernehmen und Löschen des Schritts.
 */
export const ProzessSidebar: FC = () => {
  // Only a single-node selection drives the step editor; a multi-selection (copy/paste,
  // bulk delete) shows no form.
  const selectedNode = useProzessEditorStore((state) => {
    const selected = state.nodes.filter((n) => n.selected);
    return selected.length === 1 ? selected[0] : undefined;
  });
  const edges = useProzessEditorStore((state) => state.edges);
  const updateStepData = useProzessEditorStore((state) => state.updateStepData);

  const selectedSchritt = useMemo<SchrittDaten | undefined>(
    () =>
      selectedNode
        ? {...selectedNode.data.schritt, id: selectedNode.id}
        : undefined,
    [selectedNode],
  );

  const isDelete = useMemo<boolean>(() => {
    if (!selectedNode) return true;

    const action = getDeleteAction({
      nodes: [selectedNode],
      edges: edges.filter(
        (e) => e.source === selectedNode.id || e.target === selectedNode.id,
      ),
    });
    return ['delete-node', 'delete-ghost-node', 'delete-edge'].includes(action);
  }, [edges, selectedNode]);

  const flow = useReactFlow();

  const [subFormIsValid, setSubFormIsValid] = useState(true);

  const builder = useFormBuilder<ProzessSchrittForm>({
    values: selectedSchritt ?? undefined,
  });
  const {formState} = builder;

  /**
   * Callback zum Übernehmen der Änderungen im Formular.
   * Aktualisiert den ausgewählten Schritt mit den neuen Formulardaten.
   * @param form Die aktuellen Formulardaten des Schritts
   */
  const handleSubmit = useCallback(
    (form: ProzessSchrittForm) => {
      if (!selectedNode) return;
      updateStepData(selectedNode.id, form);
    },
    [updateStepData, selectedNode],
  );

  const [__typename, narrowed] = builder.fields.$discriminate('__typename');
  const isValid = formState.isValid;

  const currentValues = builder.watch();
  const isDirty = selectedSchritt
    ? isStepDirty(currentValues, selectedSchritt)
    : false;

  /**
   * Callback zum Löschen des aktuell ausgewählten Schritts aus dem Flow.
   */
  const onDeleteSchritt = useCallback(async () => {
    if (!selectedNode) return;

    flow.deleteElements({
      nodes: [{id: selectedNode.id}],
    });
  }, [flow, selectedNode]);

  return (
    <Sidebar isOpen={!!selectedSchritt}>
      <Form
        builder={builder}
        onSubmit={handleSubmit}
        className='flex grow flex-col overflow-hidden'
      >
        <SidebarHeader
          editable={__typename !== 'GhostSchritt'}
          on={builder.fields.titel}
          placeholder='Formular Schritt'
        />
        <div className='flex h-full w-[480px] flex-1 flex-col gap-4 overflow-auto p-4'>
          {selectedSchritt &&
            __typename !== 'GhostSchritt' &&
            selectedSchritt.__typename !== 'GhostSchritt' && (
              <>
                <div className='sticky -top-4 z-10 mb-2 flex items-center space-x-4 bg-white font-bold'>
                  <h2>Zuständigkeit</h2>
                  <hr className='h-px w-full' />
                </div>

                <ZustaendigkeitRolleForm
                  on={narrowed.schreibtRolleId}
                  schrittId={selectedSchritt.id}
                  label='Rolle setzen'
                />
                <SollZustaendigkeitForm
                  on={narrowed.sollZustaendigkeit}
                  schrittId={selectedSchritt.id}
                  valueForArt={(art) =>
                    resolveSollZustaendigkeitForArt(
                      selectedSchritt.sollZustaendigkeit,
                      art,
                    )
                  }
                  arten={[
                    ZustaendigkeitArt.Buerger,
                    ZustaendigkeitArt.Organisationseinheit,
                    ZustaendigkeitArt.Dienstleister,
                    ZustaendigkeitArt.Dynamisch,
                  ]}
                >
                  <EMailBenachrichtigungForm on={narrowed.sollZustaendigkeit} />
                </SollZustaendigkeitForm>
              </>
            )}
          <div className='flex flex-col'>
            {__typename === 'FormularSchritt' && (
              <FormularSchrittForm on={narrowed} />
            )}
            {__typename === 'GovManagerRestExportSchritt' && (
              <GovManagerRestExportSchritt
                subFormIsValid={(value: boolean) => setSubFormIsValid(value)}
                on={narrowed}
              />
            )}
            {__typename === 'EmailForwarderExportSchritt' && (
              <EmailWeiterleitenSchritt on={narrowed} />
            )}
            {__typename === 'ProgrammatischerSchritt' && (
              <ProgrammatischerSchritt on={narrowed} />
            )}
          </div>
          <Button
            variant='solid'
            disabled={
              !subFormIsValid ||
              !isValid ||
              !isDirty ||
              __typename === 'GhostSchritt'
            }
          >
            Übernehmen
          </Button>
          <Button
            type='button'
            variant={isDelete ? 'destructive' : 'solid'}
            onClick={onDeleteSchritt}
          >
            <div className='flex flex-col'>
              <div>
                {__typename === 'GhostSchritt' ? 'Platzhalter' : 'Schritt'}{' '}
                {isDelete ? 'löschen' : 'lösen'}
              </div>
              <div
                className={twMerge(
                  'text-xs',
                  isDelete ? 'text-red-200' : 'text-primary-light',
                )}
              >
                oder mit <MdOutlineBackspace className='mb-px inline-block' />{' '}
                Backspace
              </div>
            </div>
          </Button>
        </div>
      </Form>
    </Sidebar>
  );
};
