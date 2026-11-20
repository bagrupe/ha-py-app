import {useFormBuilder} from '@atmina/formbuilder';
import {type FC, useCallback, useState} from 'react';
import {toast} from 'react-toastify';
import {Button} from 'src/components/ui/button/button';
import {mutationFailed} from 'src/lib/mutation';
import {InputFormField} from '../../../components/form/fields/input-field';
import {Form} from '../../../components/form/form';
import {EditableTextForm} from '../components/editable-text-input';
import {NeueEMailAdressenFeld} from '../components/email-list-editor';
import {type GruppenVerwaltenProps} from '../nutzende/organisationseinheit-verwalten';
import {
  type AddAbteilungInput,
  useAddAbteilungMutation,
  useDeleteAbteilungMutation,
  useUpdateAbteilungMutation,
  type DeleteAbteilungPayloadFragment,
} from './abteilungen.generated';

type AddAbteilungFormData = AddAbteilungInput;

const ABTEILUNG_LOESCHEN_BLOCKIERT =
  'Abteilung ist noch mit Schritten in aktuellen Prozessversionen verknüpft und kann nicht gelöscht werden.';

const ABTEILUNG_LOESCHEN_FEHLGESCHLAGEN =
  'Abteilung konnte nicht gelöscht werden. Bitte versuchen Sie es erneut.';

/**
 * @param payload Delete mutation response with the Prozess dependencies
 */
const prozessAbhaengigkeitenText = (payload: DeleteAbteilungPayloadFragment) =>
  [
    ABTEILUNG_LOESCHEN_BLOCKIERT,
    ...(payload.prozessDependencies?.flatMap((dependency) => [
      `  - ${dependency.prozessName}`,
      ...dependency.schrittNamen.map((name) => `    - Schritt: ${name}`),
    ]) ?? []),
  ].join('\n');

/**
 * Komponente zur Verwaltung von Abteilungen.
 * Zeigt eine Liste der Abteilungen an und ermöglicht das Hinzufügen, Aktualisieren und Löschen.
 * @param abteilungen Die vorhandenen Abteilungen
 * @param onSaveDeleteOrUpdate Callback, der nach Änderungen aufgerufen wird
 */
export const AbteilungenVerwalten: FC<GruppenVerwaltenProps> = ({
  abteilungen,
  onSaveDeleteOrUpdate,
}) => {
  const [, addAbteilungMutation] = useAddAbteilungMutation();
  const [, updateAbteilungMutation] = useUpdateAbteilungMutation();
  const [, deleteAbteilungMutation] = useDeleteAbteilungMutation();
  const [errors, setErrors] = useState<Record<string, string | undefined>>({});

  /**
   * @param id ID of the Abteilung or of the form
   * @param message Error message, or undefined to clear it
   */
  const setErrorMessage = (id: string, message?: string) => {
    setErrors((prev) => ({...prev, [id]: message}));
  };

  const builder = useFormBuilder<AddAbteilungFormData>({});
  const [neueEMailAdressen, setNeueEMailAdressen] = useState<string[]>([]);

  /**
   * Callback für das Absenden des Formulars zum Hinzufügen einer neuen Abteilung.
   * @param form Die Formulardaten der neuen Abteilung
   */
  const onSubmit = useCallback(
    async (form: AddAbteilungFormData) => {
      const result = await addAbteilungMutation({
        input: {...form, eMailAdressen: neueEMailAdressen},
      });
      if (mutationFailed(result)) return;
      const error = result.data!.addAbteilung.errors?.[0]?.message;
      setErrorMessage('neue_abteilung', error);
      if (error) return;
      builder.reset();
      setNeueEMailAdressen([]);
      onSaveDeleteOrUpdate();
    },
    [addAbteilungMutation, builder, neueEMailAdressen, onSaveDeleteOrUpdate],
  );

  return (
    <div className='flex flex-col gap-4 overflow-y-hidden'>
      <div className='flex flex-col gap-2 overflow-y-auto pr-2'>
        {abteilungen.map((abteilung) => (
          <EditableTextForm
            onUpdate={async (nextAbteilung) => {
              const result = await updateAbteilungMutation({
                input: {
                  id: abteilung.id,
                  name: nextAbteilung.name,
                  eMailAdressen: nextAbteilung.eMailAdressen,
                  organisationseinheitIds:
                    nextAbteilung.organisationseinheitIds,
                },
              });
              if (mutationFailed(result)) return false;
              const error = result.data!.updateAbteilung.errors?.[0]?.message;
              setErrorMessage(abteilung.id, error);
              if (error) return false;
              onSaveDeleteOrUpdate();
              return true;
            }}
            key={abteilung.id}
            onDelete={async () => {
              const result = await deleteAbteilungMutation({
                input: {id: abteilung.id},
              });

              if (mutationFailed(result)) {
                setErrorMessage(
                  abteilung.id,
                  ABTEILUNG_LOESCHEN_FEHLGESCHLAGEN,
                );
                return;
              }
              const payload = result.data!.deleteAbteilung;
              if (payload.success) {
                setErrorMessage(abteilung.id, undefined);
                toast.success('Abteilung erfolgreich gelöscht.');
              } else {
                setErrorMessage(
                  abteilung.id,
                  prozessAbhaengigkeitenText(payload),
                );
                toast.error(ABTEILUNG_LOESCHEN_BLOCKIERT);
              }

              onSaveDeleteOrUpdate();
            }}
            error={errors[abteilung.id]}
            object={{
              __typename: abteilung.__typename,
              name: abteilung.name,
              eMailAdressen: abteilung.eMailAdressen,
              organisationseinheitIds: abteilung.organisationseinheiten.map(
                (oe) => oe.id,
              ),
            }}
          />
        ))}
      </div>
      <Form
        builder={builder}
        onSubmit={onSubmit}
        className='flex flex-col gap-2 rounded-md bg-gray-100 p-2'
      >
        <div className='flex gap-4'>
          <InputFormField
            className='flex-1'
            on={builder.fields.name}
            label='Abteilungsname'
            rules={{required: true}}
          />
          <Button variant='solid' className='my-2 shrink-0'>
            + Abteilung hinzufügen
          </Button>
        </div>
        <NeueEMailAdressenFeld
          value={neueEMailAdressen}
          onChange={setNeueEMailAdressen}
          error={errors['neue_abteilung']}
        />
      </Form>
    </div>
  );
};
