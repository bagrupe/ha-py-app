import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {format} from 'date-fns';
import {type FC, useEffect, useMemo, useState} from 'react';
import {
  MdCheckCircleOutline,
  MdInfoOutline,
  MdKeyboardBackspace,
} from 'react-icons/md';
import SVG from 'react-inlinesvg';
import {useNavigate, useParams} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {IfFunktionsberechtigung} from 'src/components/if-funktionsberechtigung.tsx';
import {Link} from 'src/components/link/link.tsx';
import {formatVornameNachname} from 'src/utils/format-names.ts';
import {
  AusfuehrungStatus,
  GlobaleFunktionsberechtigung,
  ZustaendigkeitArt,
} from '../../../__generated__/graphql.ts';
import ConvertToText from '../../../assets/convert_to_text.svg';
import MoveLocation from '../../../assets/move_location.svg';
import {Accordion} from '../../../components/accordion.tsx';
import {CheckboxListFormField} from '../../../components/form/fields/checkbox-field';
import {InputFormField} from '../../../components/form/fields/input-field';
import {SelectFormField} from '../../../components/form/fields/select-field';
import {Form} from '../../../components/form/form.tsx';
import {Button, buttonVariants} from '../../../components/ui/button';
import {
  type SlotValue_EncryptedSlotValue_Fragment,
  type SlotValue_PlainSlotValue_Fragment,
} from '../../../components/ui/slot-value/slot-value.generated.ts';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {CryptoProvider} from '../../../lib/context/crypto/crypto.tsx';
import {symmetricEncryptValue} from '../../../lib/crypto/crypto.tsx';
import {useCryptoCache} from '../../../lib/hooks/use-crypto-cache.ts';
import {useDecryptedKey} from '../../../lib/hooks/use-decrypted-key.ts';
import {mutationFailed} from '../../../lib/mutation.ts';
import {getDelay} from '../../../utils/calculate-delay-for-interval.ts';
import {AntragLoeschen} from '../components/antrag-loeschen/antrag-loeschen.tsx';
import {AusfuehrungWeiterleiten} from '../components/ausfuehrung-weiterleiten/ausfuehrung-weiterleiten.tsx';
import {BuergerNachrichtField} from '../components/buerger-nachricht-field.tsx';
import {useDecryptedSlots} from '../utils.ts';
import {AusfuehrungVerlauf} from './components/ausfuehrung-verlauf.tsx';
import {AusfuehrungZustaendigkeitChips} from './components/ausfuehrung-zustaendigkeit-chips.tsx';
import {DynamischeZustaendigkeitDialog} from './components/dynamische-zustaendigkeit-dialog.tsx';
import {BezahlenSchritt} from './components/schritte/bezahlen-schritt.tsx';
import {EmailForwarderExportSchritt} from './components/schritte/email-forwarder-export-schritt.tsx';
import {FormularSchritt} from './components/schritte/formular-schritt.tsx';
import {
  NACHRICHT_SLOT_NAME,
  NachrichtSchritt,
} from './components/schritte/nachricht-schritt.tsx';
import {
  type AntragDetailAusfuehrung,
  type AntragDetailSchritt,
  type SlotValuesInput,
  useAusfuehrungContinueMutation,
  useAusfuehrungQuery,
  useAusfuehrungUpdateZugewiesenePersonMutation,
  type SchrittSollZustaendigkeitInput,
} from './detail.generated.ts';

/**
 * Typ für das Formular zum Absenden eines Schritts mit Slot-Werten und optionaler Soll-Zuständigkeit.
 */
type SubmitSchrittForm = {
  slotValues: Record<string, string | null>;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput | null;
};

const HINWEIS_CLASS = 'flex items-center gap-2 font-medium text-neutral-800';

const PLATZHALTER_LABEL_CLASS =
  '[&_.peer:placeholder-shown:not(:focus)~label]:!italic [&_.peer:placeholder-shown:not(:focus)~label]:!text-gray-400';

/**
 * Hauptkomponente zur Anzeige und Bearbeitung der Details eines Antrags.
 * Lädt die Ausführung, verwaltet Formularzustand und steuert die Navigation zwischen Schritten.
 * Nutzt Kryptographie-Kontext zur Entschlüsselung und Verschlüsselung von Daten.
 */
export const AntragDetail: FC = () => {
  const {id = ''} = useParams();
  const {user} = useAuth();
  const [isAfterContinue, setIsAfterContinue] = useState(false);
  const [{data, fetching}, refetch] = useAusfuehrungQuery({
    variables: {ausfuehrungId: id},
  });

  // Abgeschlossene Anträge können jederzeit vom Archivierungs-Job im Hintergrund aus der
  // Live-DB entfernt werden. Ohne Polling bliebe die Ansicht mit stale Daten stehen, statt
  // auf den KeineAusfuehrung-Fallback zu wechseln, sobald der Antrag verschwindet.
  const istAbgeschlossen =
    data?.ausfuehrung?.status === AusfuehrungStatus.Abgeschlossen;
  useEffect(() => {
    if (fetching || !istAbgeschlossen) return;

    const timerId = setTimeout(() => {
      refetch({requestPolicy: 'network-only'});
    }, getDelay());

    return () => clearTimeout(timerId);
  }, [fetching, istAbgeschlossen, refetch]);

  const [zuweisenModalOpen, setZuweisenModalOpen] = useState(false);
  const [versendenModalOpen, setVersendenModalOpen] = useState(false);
  const [loeschenModalOpen, setLoeschenModalOpen] = useState(false);
  const [
    auswahlZustaendigkeitVerbindungId,
    setAuswahlZustaendigkeitVerbindungId,
  ] = useState<string | null>(null);

  const [ausfuehrungContinueState, ausfuehrungContinue] =
    useAusfuehrungContinueMutation();
  const [, ausfuehrungUpdateZugewiesenePerson] =
    useAusfuehrungUpdateZugewiesenePersonMutation();
  const cryptoCache = useCryptoCache();

  const navigate = useNavigate();

  const ausfuehrung = data?.ausfuehrung;
  const formbuilder = useFormBuilder<SubmitSchrittForm>({
    values: {
      slotValues:
        ausfuehrung?.currentSchritt.__typename === 'FormularSchritt'
          ? Object.fromEntries(
              ausfuehrung.currentSchritt.felder.map(({slotName}) => [
                slotName,
                null,
              ]),
            )
          : ausfuehrung?.currentSchritt.__typename === 'NachrichtSchritt'
          ? {[NACHRICHT_SLOT_NAME]: null}
          : {},
      sollZustaendigkeit: null,
    },
    defaultValues: {
      slotValues: {},
      sollZustaendigkeit: null,
    },
  });

  const {value: decryptionKey, error: decryptionKeyError} = useDecryptedKey(
    ausfuehrung?.sharedKeyEncryptedForKommune,
    cryptoCache,
  );

  const currentSchritt = ausfuehrung?.currentSchritt;

  const ausfuehrungZustaendigeMitarbeiterGruppeId =
    ausfuehrung?.istZustaendigkeit?.mitarbeiterGruppe?.id;
  const userMitarbeiterGruppen =
    user?.__typename == 'BackofficeUser' ? user.gruppen.map((g) => g.id) : [];

  const kannAntragUebernehmen =
    ausfuehrung?.status !== AusfuehrungStatus.Abgeschlossen &&
    (ausfuehrungZustaendigeMitarbeiterGruppeId == undefined
      ? true
      : userMitarbeiterGruppen.includes(
          ausfuehrungZustaendigeMitarbeiterGruppeId,
        ));

  const {value: slots, error: slotsError} = useDecryptedSlots(
    cryptoCache,
    decryptionKey,
    ausfuehrung?.slotValues,
  );

  const namedVerbindungen = useMemo(() => {
    if (!slots) return [];

    return (
      currentSchritt?.verbindungen
        .map((v) => ({...v, name: v.name ?? `Lade...`, disabled: !v.name}))
        .filter((v) => v.istRelevant.evaluate(slots)) ?? []
    );
  }, [currentSchritt?.verbindungen, slots]);

  if (decryptionKeyError || slotsError) {
    return (
      <p className='m-8 rounded-md bg-red-50 px-4 py-3 text-red-700'>
        Die Antragsdaten konnten nicht entschlüsselt werden.
      </p>
    );
  }

  if (!ausfuehrung || !decryptionKey || !currentSchritt) {
    return !fetching ? (
      <KeineAusfuehrung isAfterContinue={isAfterContinue} />
    ) : null;
  }

  /**
   * Verschlüsselt die Slot-Werte eines Formulars mit dem Entschlüsselungsschlüssel.
   * @param form Formular mit Slot-Werten und Soll-Zuständigkeit
   * @returns Promise mit verschlüsselten Slot-Werten
   */
  const encryptSlotValues = async (form: SubmitSchrittForm) => {
    const encryptionPromises: Promise<SlotValuesInput>[] = Object.entries(
      form.slotValues,
    ).map(async ([key, value]) => ({
      name: key,
      value: {
        encryptedValue: await symmetricEncryptValue(
          decryptionKey,
          value ?? '',
          [],
        ),
      },
    }));

    return await Promise.all(encryptionPromises);
  };

  // Bewusst unverschlüsselt, damit die App den Text anzeigen kann.
  const nachrichtSlotValues = (form: SubmitSchrittForm): SlotValuesInput[] => {
    const nachricht = form.slotValues[NACHRICHT_SLOT_NAME]?.trim();
    return nachricht
      ? [{name: NACHRICHT_SLOT_NAME, value: {plainValue: nachricht}}]
      : [];
  };

  /**
   * Behandelt das Klicken auf eine Verbindung, prüft Zuständigkeiten und führt den Schritt fort.
   * @param verbindungId ID der gewählten Verbindung
   * @param naechsteIstZustaendigkeit Optionale Soll-Zuständigkeit für den nächsten Schritt
   */
  const handleClickVerbindung = async (
    verbindungId: string,
    naechsteIstZustaendigkeit: SchrittSollZustaendigkeitInput | null,
  ) => {
    const values = formbuilder.getValues();
    const nextSollZustaendigkeit = ausfuehrung.currentSchritt.verbindungen.find(
      (v) => v.id === verbindungId,
    );
    if (
      nextSollZustaendigkeit?.nach.sollZustaendigkeit.art ==
        ZustaendigkeitArt.Dynamisch &&
      !nextSollZustaendigkeit.nach.sollZustaendigkeit.liestRolleId &&
      naechsteIstZustaendigkeit === null
    ) {
      setAuswahlZustaendigkeitVerbindungId(verbindungId);
      return;
    }

    setAuswahlZustaendigkeitVerbindungId(null);

    const slotValues =
      currentSchritt.__typename === 'NachrichtSchritt'
        ? nachrichtSlotValues(values)
        : await encryptSlotValues(values);

    const result = await ausfuehrungContinue({
      input: {
        ausfuehrungId: ausfuehrung.id,
        naechsteIstZustaendigkeit,
        bearbeitungen: [
          {
            schrittId: currentSchritt.id,
            nextVerbindungId: verbindungId,
            slotValues: slotValues,
          },
        ],
      },
    });
    if (
      mutationFailed(result) ||
      !result.data!.ausfuehrungContinue.ausfuehrungResult?.ausfuehrung
    ) {
      return;
    }
    setIsAfterContinue(true);
  };

  const currentSchrittIsFormular =
    currentSchritt.__typename === 'FormularSchritt' &&
    !currentSchritt?.erledigungDurchBuerger &&
    currentSchritt.felder.length > 0;
  const currentSchrittIsNachricht =
    currentSchritt.__typename === 'NachrichtSchritt';
  const currentSchrittIsActionable =
    currentSchrittIsFormular || currentSchrittIsNachricht;

  const currentUserIsAssigned =
    ausfuehrung.istZustaendigkeit.zugewiesenePerson?.id == user?.id;

  return (
    <CryptoProvider decryptionKey={decryptionKey} cryptoCache={cryptoCache}>
      <div className='container mt-8 flex h-full flex-col text-neutral-600'>
        <div
          className={twMerge(
            'relative mb-4 flex justify-between',
            currentSchrittIsActionable ? 'flex-col' : 'items-start',
          )}
        >
          <div className='mt-2 flex w-full flex-col gap-3'>
            <div className='flex items-center gap-3'>
              <MdKeyboardBackspace
                className='size-8 hover:cursor-pointer'
                onClick={() => navigate(-1)}
              />
              <h1 className='text-3xl font-bold leading-10'>
                {ausfuehrung.prozessVersion.prozess.name}
              </h1>
            </div>
            <AusfuehrungZustaendigkeitChips ausfuehrung={ausfuehrung} />
            {ausfuehrung.manuellAbgeschlossen && (
              <div className='flex items-center gap-3 rounded-lg border border-primary/30 border-l-primary bg-primary/5 p-4 text-lg font-semibold text-neutral-800 [border-left-width:6px]'>
                <MdCheckCircleOutline className='size-8 shrink-0 text-primary' />
                <span>
                  Dieser Antrag wurde über die Weiterleitung zur Abgabe per
                  E-Mail am{' '}
                  {format(
                    ausfuehrung.manuellAbgeschlossen,
                    "dd.MM.yyyy 'um' HH:mm 'Uhr'",
                  )}{' '}
                  abgeschlossen.
                </span>
              </div>
            )}
            <div className='flex flex-col gap-1 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2 [&>*]:shrink-0'>
              <div className='text-sm font-bold leading-snug'>
                Antrag vom {format(ausfuehrung.createdAt, 'dd.MM.yyyy, HH:mm')}{' '}
                Uhr
              </div>
              {ausfuehrung.istZustaendigkeit.zugewiesenePerson && (
                <>
                  <div className='w-px self-stretch bg-slate-300' />
                  <div>
                    Bearbeiter:{' '}
                    {ausfuehrung.istZustaendigkeit.zugewiesenePerson &&
                      formatVornameNachname(
                        ausfuehrung.istZustaendigkeit.zugewiesenePerson,
                      )}
                  </div>
                </>
              )}
              {ausfuehrung.istZustaendigkeit.zugewiesenePerson?.id !==
                user?.id && (
                <>
                  <div className='w-px self-stretch bg-slate-300' />
                  <div
                    className={
                      kannAntragUebernehmen
                        ? 'fill-primary text-primary'
                        : 'fill-gray-400 text-gray-400  opacity-60'
                    }
                  >
                    <button
                      title={
                        kannAntragUebernehmen
                          ? undefined
                          : 'Sie haben nicht die benötigten Gruppenberechtigungen um den Antrag übernehmen zu können.'
                      }
                      disabled={!kannAntragUebernehmen}
                      onClick={async () => {
                        const result = await ausfuehrungUpdateZugewiesenePerson(
                          {
                            ausfuehrungId: ausfuehrung.id,
                            userId: user?.id ?? '',
                          },
                        );
                        if (
                          mutationFailed(result) ||
                          !result.data!.ausfuehrungUpdateZugewiesenePerson
                            .ausfuehrung
                        ) {
                          return;
                        }
                      }}
                      className='flex items-center text-start'
                    >
                      <SVG
                        src={MoveLocation}
                        className='mr-1  size-6 shrink-0'
                      />
                      <div>Bearbeitung übernehmen</div>
                    </button>
                  </div>
                </>
              )}
              {ausfuehrung.status != AusfuehrungStatus.Abgeschlossen && (
                <>
                  <div className='w-px self-stretch bg-slate-300' />
                  <Dialog.Root
                    open={zuweisenModalOpen}
                    onOpenChange={setZuweisenModalOpen}
                  >
                    <Dialog.Trigger asChild>
                      <button className='flex gap-1 text-primary'>
                        <SVG src={ConvertToText} />
                        Innerhalb meiner Abteilung zuweisen
                      </button>
                    </Dialog.Trigger>
                    <AusfuehrungWeiterleiten
                      modus='intern'
                      nachrichtMaxLength={ausfuehrung.nachrichtMaxLength}
                      onOpenChange={setZuweisenModalOpen}
                      currentSchrittAbteilungId={
                        ausfuehrung.istZustaendigkeit.mitarbeiterGruppe?.id ??
                        null
                      }
                      ausfuehrungId={ausfuehrung.id}
                    />
                  </Dialog.Root>
                  <div className='w-px self-stretch bg-slate-300' />
                  <Dialog.Root
                    open={versendenModalOpen}
                    onOpenChange={setVersendenModalOpen}
                  >
                    <Dialog.Trigger asChild>
                      <button className='flex gap-1 text-primary'>
                        <SVG src={ConvertToText} />
                        Per E-Mail versenden
                      </button>
                    </Dialog.Trigger>
                    <AusfuehrungWeiterleiten
                      modus='extern'
                      nachrichtMaxLength={ausfuehrung.nachrichtMaxLength}
                      onOpenChange={setVersendenModalOpen}
                      currentSchrittAbteilungId={
                        ausfuehrung.istZustaendigkeit.mitarbeiterGruppe?.id ??
                        null
                      }
                      ausfuehrungId={ausfuehrung.id}
                    />
                  </Dialog.Root>
                </>
              )}
              <IfFunktionsberechtigung
                funktionsberechtigung={
                  GlobaleFunktionsberechtigung.AntragLoeschung
                }
              >
                <div className='w-px self-stretch bg-slate-300' />
                <Dialog.Root
                  open={loeschenModalOpen}
                  onOpenChange={setLoeschenModalOpen}
                >
                  <Dialog.Trigger asChild>
                    <button className='flex gap-1 text-red-600'>
                      Antrag löschen
                    </button>
                  </Dialog.Trigger>
                  <AntragLoeschen
                    onOpenChange={setLoeschenModalOpen}
                    ausfuehrungId={ausfuehrung.id}
                  />
                </Dialog.Root>
              </IfFunktionsberechtigung>
            </div>
            <p className='border-t border-gray-100 pt-2 font-medium'>
              {!ausfuehrung.manuellAbgeschlossen &&
                ausfuehrung.currentSchritt.titel}
            </p>
            {!istAbgeschlossen && namedVerbindungen.length > 0 && (
              <div className='rounded-lg border border-primary/30 border-l-primary bg-primary/5 p-4 [border-left-width:6px]'>
                <h2 className='mb-3 text-lg font-bold text-primary'>
                  Wie möchten Sie den Vorgang weiterbearbeiten?
                </h2>
                <div className='flex flex-wrap justify-start gap-3'>
                  {namedVerbindungen.map((v) => (
                    <Button
                      key={v.id}
                      variant='solid'
                      className='px-5 py-3 font-semibold enabled:shadow-md enabled:hover:shadow-lg'
                      disabled={
                        !currentUserIsAssigned ||
                        ausfuehrungContinueState.fetching ||
                        v.disabled
                      }
                      onClick={() => handleClickVerbindung(v.id!, null)}
                      title={
                        !currentUserIsAssigned && !v.disabled
                          ? `Erfordert Mitarbeitergruppe: ${ausfuehrung.istZustaendigkeit.mitarbeiterGruppe?.id}`
                          : undefined
                      }
                    >
                      {v.name}
                    </Button>
                  ))}
                </div>
                {!currentUserIsAssigned && (
                  <p className={twMerge(HINWEIS_CLASS, 'mt-4')}>
                    <MdInfoOutline className='size-6 shrink-0 text-primary' />
                    Übernehmen Sie die Bearbeitung, um den Antrag
                    weiterzuleiten.
                  </p>
                )}
              </div>
            )}
            {!istAbgeschlossen && currentSchrittIsActionable && (
              <div className='mt-4 rounded-lg border border-gray-300 bg-gray-50 p-4'>
                {currentUserIsAssigned && (
                  <p
                    className={twMerge(
                      HINWEIS_CLASS,
                      'mb-1 font-normal text-neutral-600',
                    )}
                  >
                    <MdInfoOutline className='size-6 shrink-0 text-primary' />
                    Ihre Eingabe in diesem Feld wird beim Klick auf eine der
                    Aktionen oben übernommen.
                  </p>
                )}
                {currentSchritt.__typename === 'NachrichtSchritt' && (
                  <Form
                    builder={formbuilder}
                    className={twMerge('w-full', PLATZHALTER_LABEL_CLASS)}
                  >
                    <BuergerNachrichtField
                      optional
                      disabled={
                        !currentUserIsAssigned ||
                        ausfuehrungContinueState.fetching
                      }
                      maxLength={currentSchritt.nachrichtMaxLength}
                      on={formbuilder.fields.slotValues[NACHRICHT_SLOT_NAME]}
                    />
                  </Form>
                )}
                {currentSchrittIsFormular && (
                  <Form
                    builder={formbuilder}
                    className={twMerge('w-full', PLATZHALTER_LABEL_CLASS)}
                  >
                    {currentSchritt.felder.map((feld) => {
                      if (
                        feld.__typename == 'StringFormularFeld' &&
                        feld.options.length > 0
                      ) {
                        return (
                          <SelectFormField
                            key={feld.id}
                            items={feld.options.map((o) => ({
                              value: o.key,
                              name: o.value,
                            }))}
                            disabled={
                              !currentUserIsAssigned ||
                              ausfuehrungContinueState.fetching
                            }
                            on={formbuilder.fields.slotValues[feld.slotName]}
                            label={feld.angezeigterName ?? feld.slotName}
                          />
                        );
                      }
                      if (feld.__typename == 'StringFormularFeld') {
                        return (
                          <InputFormField
                            key={feld.id}
                            multiLine={
                              feld.__typename == 'StringFormularFeld'
                                ? feld.multiline
                                : false
                            }
                            inputClass={
                              feld.multiline
                                ? 'h-28 min-h-20 max-h-80 resize-y'
                                : undefined
                            }
                            disabled={
                              !currentUserIsAssigned ||
                              ausfuehrungContinueState.fetching
                            }
                            on={formbuilder.fields.slotValues[feld.slotName]}
                            label={feld.angezeigterName ?? feld.slotName}
                          />
                        );
                      } else if (
                        feld.__typename === 'CheckboxListFormularFeld'
                      ) {
                        return (
                          <CheckboxListFormField
                            key={feld.slotName}
                            options={feld.options}
                            on={formbuilder.fields.slotValues[feld.slotName]}
                            label={feld.angezeigterName ?? feld.slotName}
                          />
                        );
                      }
                    })}
                  </Form>
                )}
              </div>
            )}
            {currentSchrittIsActionable && (
              <div className='my-4 flex items-center gap-2'>
                <h2 className='text-xl font-bold'>Antragsdaten</h2>
                <div className='h-px w-full bg-gray-300' />
              </div>
            )}
          </div>
        </div>
        <DynamischeZustaendigkeitDialog
          open={!!auswahlZustaendigkeitVerbindungId}
          onClose={() => setAuswahlZustaendigkeitVerbindungId(null)}
          schrittId={currentSchritt.id}
          arten={
            currentSchritt.verbindungen.find(
              (v) => v.id === auswahlZustaendigkeitVerbindungId,
            )?.nach.sollZustaendigkeit.dynamischeArten ?? []
          }
          onSubmit={(result) =>
            auswahlZustaendigkeitVerbindungId &&
            handleClickVerbindung(
              auswahlZustaendigkeitVerbindungId,
              result.sollZustaendigkeit,
            )
          }
        />
        <div className='flex flex-col items-start gap-4'>
          {ausfuehrung.bearbeitungen
            // Programmatic steps (routing, Weichen) collect no data, so their accordion would open empty.
            .filter(
              (b) =>
                b.schritt.titel &&
                b.schritt.id != currentSchritt.id &&
                b.schritt.__typename !== 'ProgrammatischerSchritt',
            )
            .map((b, index) => {
              const mitarbeiter =
                b.user?.__typename === 'BackofficeUser' ? b.user : undefined;
              const bearbeitenderUser = mitarbeiter
                ? formatVornameNachname(mitarbeiter)
                : undefined;

              return (
                <ProzessSchritt
                  key={b.schritt.id}
                  schritt={b.schritt}
                  bearbeitungsDatum={b.createdAt ?? undefined}
                  bearbeitenderUser={bearbeitenderUser}
                  ausfuehrung={ausfuehrung}
                  index={index}
                />
              );
            })}
        </div>
        <AusfuehrungVerlauf historie={ausfuehrung.verlauf} />
      </div>
    </CryptoProvider>
  );
};

/**
 * Komponente zur Anzeige, wenn keine Ausführung verfügbar ist oder kein Zugriff besteht.
 * Zeigt unterschiedliche Meldungen abhängig davon, ob der Antrag weitergeleitet wurde.
 * @param isAfterContinue Gibt an, ob die Komponente nach einer Weiterleitung angezeigt wird
 */
const KeineAusfuehrung = ({isAfterContinue}: {isAfterContinue: boolean}) => (
  <div className='container relative mt-8 flex flex-col text-neutral-600'>
    <div className='absolute inset-0 z-10 grid place-items-center'>
      <div className='flex flex-col items-center rounded-md bg-white/50 p-8 text-center shadow-xl shadow-white'>
        <h1 className='mb-2 text-lg font-medium text-primary'>
          {isAfterContinue
            ? 'Antrag weitergeleitet'
            : 'Kein Zugriff auf diesen Antrag'}
        </h1>
        {isAfterContinue ? (
          <p>
            Der Antrag wurde weitergeleitet und liegt nicht mehr in Ihrer
            Zuständigkeit.
          </p>
        ) : (
          <p>Dieser Antrag liegt aktuell nicht in Ihrer Zuständigkeit.</p>
        )}
        <Link
          className={buttonVariants({className: 'mt-6 h-auto'})}
          to='/antraege/neu'
        >
          <div className='flex items-center justify-center'>
            <div>Zurück zu den Anträgen</div>
          </div>
        </Link>
      </div>
    </div>
    <div className='flex select-none flex-col opacity-70 blur-sm'>
      <div className={twMerge('relative mb-4 flex justify-between')}>
        <div className='mt-2 flex w-full flex-col gap-3'>
          <div className='flex items-center gap-3'>
            <MdKeyboardBackspace className='size-8 hover:cursor-pointer' />
            <h1 className='text-3xl font-bold leading-10'>Antrag</h1>
          </div>
          <div className=' flex flex-col gap-1 sm:flex-row sm:items-center sm:gap-2'>
            <div className='text-sm font-bold leading-snug'>00-00-000</div>
            <div className='w-px self-stretch bg-slate-300' />
            <div>Bearbeiter:</div>
          </div>
        </div>
      </div>
      <div className='mt-12 flex flex-col items-start gap-4'>
        <Accordion
          heading={
            <div className='flex w-full items-center justify-between gap-4 text-xl font-bold'>
              <div className='flex items-baseline gap-4'>
                <div>Titel</div>
              </div>
            </div>
          }
        >
          <div className='pt-2' />
        </Accordion>
      </div>
    </div>
  </div>
);

/**
 * Props für die Komponente ProzessSchritt.
 */
type ProzessSchrittProps = {
  bearbeitungsDatum?: Date;
  bearbeitenderUser?: string;
  schritt: AntragDetailSchritt;
  ausfuehrung: AntragDetailAusfuehrung;
  index: number;
};

/**
 * Komponente zur Darstellung eines einzelnen Prozess-Schritts mit Status und Bearbeiter.
 * Zeigt den Titel, ob Freigabe benötigt wird, und den bearbeitenden Nutzer an.
 * Rendert je nach Typ des Schritts die passende Unterkomponente.
 * @param props Eigenschaften des Prozess-Schritts
 */
const ProzessSchritt: FC<ProzessSchrittProps> = (props) => {
  const slotValuesDict: {
    [key: string]:
      | SlotValue_EncryptedSlotValue_Fragment
      | SlotValue_PlainSlotValue_Fragment;
  } = {};
  props.ausfuehrung.slotValues.forEach(
    (sv) => (slotValuesDict[sv.slotName] = sv),
  );

  const slotsBenoetigenFreigabe = props.schritt.slots.filter(
    (s) => s.brauchtFreigabe && !slotValuesDict[s.name].istFreigegeben,
  );

  return (
    <Accordion
      heading={
        <div className='flex w-full items-center justify-between gap-4 text-xl font-bold'>
          <div className='flex items-baseline gap-4'>
            <div>
              {props.index + 1}. {props.schritt.titel}
            </div>
            {slotsBenoetigenFreigabe.length > 0 && (
              <p className='rounded-lg bg-red-200 px-2 py-1 text-sm font-medium text-red-500'>
                Benötigt Freigabe
              </p>
            )}
          </div>
          {props.bearbeitenderUser && (
            <p className='rounded-full bg-gray-100 px-2 py-1 text-sm font-medium'>
              {props.bearbeitenderUser}
            </p>
          )}
        </div>
      }
    >
      <div className='pt-2' key={props.schritt.id}>
        {props.schritt.__typename === 'FormularSchritt' && (
          <div>
            <FormularSchritt
              schritt={props.schritt}
              ausfuehrung={props.ausfuehrung}
            />
          </div>
        )}
        {props.schritt.__typename === 'BezahlenSchritt' && (
          <BezahlenSchritt schritt={props.schritt} />
        )}
        {props.schritt.__typename === 'EmailForwarderExportSchritt' && (
          <EmailForwarderExportSchritt
            bearbeitungsDatum={props.bearbeitungsDatum}
            schritt={props.schritt}
            ausfuehrung={props.ausfuehrung}
          />
        )}
        {props.schritt.__typename === 'NachrichtSchritt' && (
          <NachrichtSchritt ausfuehrung={props.ausfuehrung} />
        )}
      </div>
    </Accordion>
  );
};
