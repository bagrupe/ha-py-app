import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useState} from 'react';
import {type SubmitHandler} from 'react-hook-form';
import SVG from 'react-inlinesvg';
import {toast} from 'react-toastify';
import {EmailFormField} from 'src/components/form/fields/email-field/email-field';
import {RadioFormField} from 'src/components/form/fields/radio-field/radio-field';
import {Form} from 'src/components/form/form';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {useAuth} from 'src/lib/context/auth/auth';
import {mutationFailed} from 'src/lib/mutation';
import {
  WeiterleitungArt,
  WeiterleitungEmpfaenger,
} from '../../../../__generated__/graphql';
import ConvertToText from '../../../../assets/convert_to_text.svg';
import {BuergerNachrichtField} from '../buerger-nachricht-field';
import {useAusfuehrungWeiterleitenMutation} from './ausfuehrung-weiterleiten.generated';
import {
  type AusgewaehlterMitarbeiter,
  MitarbeiterAuswahl,
} from './mitarbeiter-auswahl';

const NACHRICHT_PFLICHT = 'Bitte geben Sie eine Nachricht ein.';

/**
 * Eigenschaften für die Komponente AusfuehrungWeiterleiten.
 * Enthält die ID der Ausführung, die aktuelle Abteilungs-ID und eine Callback-Funktion für das Öffnen/Schließen.
 */
type AusfuehrungWeiterleitenProps = {
  ausfuehrungId: string;
  currentSchrittAbteilungId: string | null;
  modus: 'intern' | 'extern';
  nachrichtMaxLength: number;
  onOpenChange: (open: boolean) => void;
};

/**
 * Formulardaten für das Weiterleiten eines Antrags.
 * Beinhaltet die Ausführungs-ID, Empfängerart, Empfänger-ID oder E-Mail sowie die Art der Weiterleitung.
 */
type AntragWeiterleitenFormData = {
  ausfuehrungId: string;
  weiterleitungEmpfaenger: WeiterleitungEmpfaenger;
  empfaengerId?: string;
  empfaengerEmail?: string;
  weiterleitungArt?: WeiterleitungArt;
  nachricht?: string;
};

/**
 * Komponente zum Weiterleiten eines Antrags innerhalb der Organisation oder per E-Mail an externe Empfänger.
 * Nutzt ein Formular mit dynamischer Anzeige der Eingabefelder basierend auf der Empfängerart.
 * @param ausfuehrungId ID der auszuführenden Aktion.
 * @param currentSchrittAbteilungId ID der aktuellen Abteilung für die Filterung der Mitarbeitenden.
 * @param onOpenChange Callback zum Steuern des Öffnungszustands des Modals.
 */
export const AusfuehrungWeiterleiten: FC<AusfuehrungWeiterleitenProps> = ({
  ausfuehrungId,
  currentSchrittAbteilungId,
  modus,
  nachrichtMaxLength,
  onOpenChange,
}) => {
  const {user} = useAuth();
  const builder = useFormBuilder<AntragWeiterleitenFormData>({
    defaultValues: {
      ausfuehrungId: ausfuehrungId,
      weiterleitungEmpfaenger:
        modus === 'intern'
          ? WeiterleitungEmpfaenger.Intern
          : WeiterleitungEmpfaenger.Extern,
      empfaengerId: undefined,
      empfaengerEmail: '',
      weiterleitungArt: WeiterleitungArt.Kopieren,
      nachricht: '',
    },
  });
  const empfaengerArt = builder.fields.weiterleitungEmpfaenger.$useWatch();
  const weiterleitungArt = builder.fields.weiterleitungArt.$useWatch();
  const istAbgabe =
    empfaengerArt == WeiterleitungEmpfaenger.Extern &&
    weiterleitungArt == WeiterleitungArt.Schliessen;

  const [{fetching}, antragWeiterleiten] = useAusfuehrungWeiterleitenMutation();
  const [ausgewaehlt, setAusgewaehlt] =
    useState<AusgewaehlterMitarbeiter | null>(null);

  const buttonDisabled =
    fetching ||
    (empfaengerArt == WeiterleitungEmpfaenger.Intern && !ausgewaehlt);

  /**
   * Behandelt das Absenden des Formulars zum Weiterleiten des Antrags.
   * Führt die Mutation aus und zeigt bei Erfolg eine Erfolgsmeldung an.
   * @param data Die Formulardaten des Weiterleitungsformulars.
   */
  const handleSubmit: SubmitHandler<AntragWeiterleitenFormData> = async (
    data,
  ) => {
    const result = await antragWeiterleiten({
      input: {
        ...data,
        ausfuehrungId,
        nachricht: istAbgabe ? data.nachricht?.trim() : undefined,
      },
    });
    if (mutationFailed(result)) return;
    const errors = result.data!.ausfuehrungWeiterleiten.errors;
    if (errors?.length) return;
    toast.success(istAbgabe ? 'Antrag abgegeben' : 'Antrag weitergeleitet');
    onOpenChange(false);
  };

  return (
    <Modal
      title={
        modus === 'intern'
          ? 'Innerhalb der Abteilung zuweisen'
          : 'Per E-Mail versenden'
      }
      className='min-h-[60vh] max-w-3xl'
      contentClassName='max-h-[calc(100dvh-12rem)]'
    >
      <Form
        builder={builder}
        onSubmit={handleSubmit}
        className='flex min-h-[calc(60vh-6rem)] flex-col'
      >
        <div className='flex flex-1 flex-col gap-6'>
          <p>
            {modus === 'intern'
              ? 'Sie können diesen Antrag einer Kollegin oder einem Kollegen Ihrer Abteilung zuweisen. Der Antrag bleibt dabei geöffnet. Für andere Abteilungen oder Gemeinden nutzen Sie bitte „An andere Organisationseinheit übergeben“.'
              : 'Sie können diesen Antrag als PDF-Datei per E-Mail an externe Personen senden. Für andere Abteilungen oder Gemeinden nutzen Sie bitte „An andere Organisationseinheit übergeben“.'}
          </p>
          {empfaengerArt == WeiterleitungEmpfaenger.Intern && (
            <MitarbeiterAuswahl
              groupId={currentSchrittAbteilungId}
              currentUserId={user?.id}
              selected={ausgewaehlt}
              onSelect={(mitarbeiter) => {
                setAusgewaehlt(mitarbeiter);
                builder.fields.empfaengerId.$setValue(mitarbeiter.id);
              }}
            />
          )}
          {empfaengerArt == WeiterleitungEmpfaenger.Extern && (
            <>
              <EmailFormField
                label='E-Mail Adresse eingeben'
                on={builder.fields.empfaengerEmail}
                rules={{required: true}}
              />
              <p>Bitte wählen Sie aus, wie der Antrag behandelt werden soll.</p>
              <RadioFormField
                on={builder.fields.weiterleitungArt}
                orientation='horizontal'
                items={[
                  {name: 'Zur Ansicht', value: WeiterleitungArt.Kopieren},
                  {name: 'Zur Abgabe', value: WeiterleitungArt.Schliessen},
                ]}
              />
              {istAbgabe && (
                <>
                  <div className='rounded-md border border-yellow-500 bg-yellow-50 px-3 py-2'>
                    Mit der Abgabe wird der Antrag geschlossen. Die
                    antragstellende Person wird per Nachricht und
                    Push-Benachrichtigung informiert. Bitte schreiben Sie
                    deshalb kurz, an wen der Antrag abgegeben wurde und was als
                    Nächstes passiert. So weiß die meldende Person, was mit
                    ihrer Meldung geschieht.
                  </div>
                  <BuergerNachrichtField
                    autoFocus
                    on={builder.fields.nachricht}
                    maxLength={nachrichtMaxLength}
                    rules={{
                      required: NACHRICHT_PFLICHT,
                      validate: (value) =>
                        value.trim() !== '' || NACHRICHT_PFLICHT,
                    }}
                  />
                </>
              )}
            </>
          )}
        </div>
        <div className='sticky -bottom-3 -mx-5 -mb-3 mt-6 flex justify-end gap-4 bg-white px-5 py-3 shadow-[0_-6px_6px_-6px_rgba(0,0,0,0.2)]'>
          <Dialog.Close asChild>
            <Button variant='text-secondary'>Abbrechen</Button>
          </Dialog.Close>
          <Button
            type='submit'
            disabled={buttonDisabled}
            endAdornment={<SVG src={ConvertToText} />}
          >
            {istAbgabe
              ? 'Antrag abgeben'
              : modus === 'intern'
              ? 'Zuweisen'
              : 'Versenden'}
          </Button>
        </div>
      </Form>
    </Modal>
  );
};
