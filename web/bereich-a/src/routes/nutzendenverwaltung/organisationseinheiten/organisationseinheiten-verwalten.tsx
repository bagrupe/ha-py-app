import {useFormBuilder} from '@atmina/formbuilder';
import {useCallback, useMemo, useState} from 'react';
import {BackofficeNutzerArt} from 'src/__generated__/graphql';
import {Button} from 'src/components/ui/button';
import {useAuth} from 'src/lib/context/auth/auth';
import {mutationFailed} from 'src/lib/mutation';
import {InputFormField} from '../../../components/form/fields/input-field';
import {Form} from '../../../components/form/form';
import {EditableTextForm} from '../components/editable-text-input';
import {NeueEMailAdressenFeld} from '../components/email-list-editor';
import {
  useUntereinheitenQuery,
  useUntereinheitCreateMutation,
  useUntereinheitDeleteMutation,
  useUntereinheitUpdateMutation,
  type UntereinheitCreateInput,
} from './organisationseinheit.generated';

/**
 * Typ für die Formular-Daten zur Erstellung einer Untereinheit.
 */
type UntereinheitCreateFormData = UntereinheitCreateInput;

/**
 * Komponente zur Verwaltung von Organisationseinheiten.
 * Lädt die Untereinheiten, zeigt diese an und ermöglicht das Erstellen, Aktualisieren und Löschen.
 */
export const OrganisationseinheitenVerwalten = () => {
  const {user} = useAuth();
  const context = useMemo(() => ({additionalTypenames: ['Untereinheit']}), []);
  const [{data}, refetch] = useUntereinheitenQuery({
    requestPolicy: 'network-only',
    context: context,
  });
  const untereinheiten =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.untereinheiten
      : [];

  const [, createUntereinheit] = useUntereinheitCreateMutation();
  const [, updateUntereinheit] = useUntereinheitUpdateMutation();
  const [, deleteUntereinheit] = useUntereinheitDeleteMutation();
  const [errors, setErrors] = useState<Record<string, string | undefined>>({});

  /**
   * Übernimmt die Fehlermeldung des Servers für eine Untereinheit; dieselbe Meldung
   * zeigt der globale Toast an, sodass beide Anzeigen identisch sind.
   * @param id ID der Untereinheit oder des Formulars
   * @param maybeError Optionaler Fehler des Servers
   */
  const setErrorMessage = (id: string, maybeError?: {message: string}) => {
    setErrors((prev) => ({...prev, [id]: maybeError?.message}));
  };

  const builder = useFormBuilder<UntereinheitCreateFormData>({});
  const [neueEMailAdressen, setNeueEMailAdressen] = useState<string[]>([]);

  /**
   * Behandelt das Absenden des Formulars zur Erstellung einer neuen Untereinheit.
   * Führt die Mutation aus und setzt ggf. Fehler.
   * @param form Formular-Daten der neuen Untereinheit
   */
  const onSubmit = useCallback(
    async (form: UntereinheitCreateFormData) => {
      const result = await createUntereinheit({
        input: {...form, eMailAdressen: neueEMailAdressen},
      });
      if (mutationFailed(result)) return;
      const maybeError = result.data!.untereinheitCreate.errors?.[0];
      setErrorMessage('neue_organisationseinheit', maybeError);
      if (maybeError || !result.data!.untereinheitCreate.untereinheit) return;
      builder.reset();
      setNeueEMailAdressen([]);
    },
    [createUntereinheit, builder, neueEMailAdressen],
  );
  return (
    <div className='flex flex-col gap-4 overflow-y-hidden'>
      <div className='flex flex-col gap-2 overflow-y-auto pr-2'>
        {untereinheiten.map((u) => {
          const {isGemeinde, ...untereinheit} = u;
          return (
            <EditableTextForm
              key={untereinheit.id}
              onUpdate={async (nextOrganisationseinheit) => {
                const result = await updateUntereinheit({
                  input: {
                    untereinheitId: untereinheit.id,
                    name: nextOrganisationseinheit.name,
                    eMailAdressen: nextOrganisationseinheit.eMailAdressen,
                  },
                });
                if (mutationFailed(result)) return false;
                const maybeError = result.data!.untereinheitUpdate.errors?.[0];
                setErrorMessage(untereinheit.id, maybeError);
                if (maybeError || !result.data!.untereinheitUpdate.untereinheit)
                  return false;
                return true;
              }}
              onDelete={async () => {
                const result = await deleteUntereinheit({
                  input: {untereinheitId: untereinheit.id},
                });
                if (mutationFailed(result)) return;
                const maybeError = result.data!.untereinheitDelete.errors?.[0];
                setErrorMessage(untereinheit.id, maybeError);
                if (maybeError || !result.data!.untereinheitDelete.untereinheit)
                  return;
                refetch();
              }}
              editable={!isGemeinde}
              error={errors[untereinheit.id]}
              object={untereinheit}
            />
          );
        })}
      </div>

      {user?.art === BackofficeNutzerArt.Superadmin && (
        <Form
          builder={builder}
          onSubmit={onSubmit}
          className='flex flex-col gap-2 rounded-md bg-gray-100 p-2'
        >
          <div className='flex gap-4'>
            <InputFormField
              className='flex-1'
              on={builder.fields.name}
              label='Name der Organisationseinheit'
              rules={{required: true}}
            />
            <Button variant='solid' className='my-2 shrink-0'>
              + Organisationseinheit hinzufügen
            </Button>
          </div>
          <NeueEMailAdressenFeld
            value={neueEMailAdressen}
            onChange={setNeueEMailAdressen}
            error={errors['neue_organisationseinheit']}
          />
        </Form>
      )}
    </div>
  );
};
