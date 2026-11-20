import type {FormBuilder} from '@atmina/formbuilder';
import {ArrowDownIcon, ArrowUpIcon} from '@radix-ui/react-icons';
import {type ReactNode, type PropsWithChildren, useEffect} from 'react';
import {MdAdd, MdClear} from 'react-icons/md';
import {RiDeleteBin6Line} from 'react-icons/ri';
import {ExpressionInputFormField} from 'src/components/form/fields/expression-input-field/expression-input-field.tsx';
import {ToolTip} from 'src/components/ui/tool-tip.tsx';
import {CheckboxFormField} from '../../../../../components/form/fields/checkbox-field';
import {InputFormField} from '../../../../../components/form/fields/input-field';
import {Button} from '../../../../../components/ui/button';
import {useProzessEditorStore} from '../../lib/store';
import {type FormularSchrittFormFelderType} from './formular-schritt-form.tsx';

const feldTypeRecord: Record<
  FormularSchrittFormFelderType['__typename'],
  string
> = {
  CheckboxListFormularFeld: 'Checkboxfeld',
  DateFormularFeld: 'Datumsfeld',
  StringFormularFeld: 'Textfeld',
  UploadFormularFeld: 'Uploadfeld',
  LocationFormularFeld: 'Standortfeld',
  TimeFormularFeld: 'Uhrzeitfeld',
  SignatureFormularFeld: 'Unterschriftfeld',
  AnzeigeTextBlockFeld: 'TextBlock',
};

/**
 * Komponente zur Darstellung und Bearbeitung eines Formularfelds im Prozess-Editor.
 * Ermöglicht das Verschieben, Entfernen und Bearbeiten der Eigenschaften des Felds.
 * @param on FormBuilder-Instanz für das Formularfeld
 * @param canMoveUp Gibt an, ob das Feld nach oben verschoben werden kann
 * @param canMoveDown Gibt an, ob das Feld nach unten verschoben werden kann
 * @param onRemove Callback zum Entfernen des Felds
 * @param onMove Callback zum Verschieben des Felds in die angegebene Richtung
 */
export const ProzessEditorFormFeld = ({
  on,
  canMoveUp,
  canMoveDown,
  onRemove,
  onMove,
}: {
  on: FormBuilder<FormularSchrittFormFelderType>;
  canMoveUp: boolean;
  canMoveDown: boolean;
  onRemove: () => void;
  onMove: (direction: 'up' | 'down') => void;
}) => {
  const [__typename, narrowed] = on.$discriminate('__typename');
  const istOeffentlich = useProzessEditorStore(
    (state) => state.metadata.istOeffentlich,
  );
  const readOnly = __typename == 'AnzeigeTextBlockFeld'; // it's not pretty but otherwise we would query the slotValueType which would result in passing it through the whole prozess editor store only to remove it before mutating

  return (
    <div className='space-y-4'>
      <div className='space-y-3'>
        {(canMoveUp || canMoveDown) && (
          <div className='flex items-center gap-2'>
            <Button
              type='button'
              variant='outlined-secondary'
              className='px-1.5 py-1'
              disabled={!canMoveUp}
              onClick={() => onMove('up')}
            >
              <ArrowUpIcon />
            </Button>
            <Button
              type='button'
              variant='outlined-secondary'
              className='px-1.5 py-1'
              disabled={!canMoveDown}
              onClick={() => onMove('down')}
            >
              <ArrowDownIcon />
            </Button>
            <span className='text-sm text-gray-600'>Position ändern</span>
          </div>
        )}
        <div className='flex flex-col items-start gap-2'>
          {istOeffentlich && !readOnly && (
            <div className='flex items-center gap-2'>
              <CheckboxFormField
                on={on.oeffentlichSichtbar}
                label='Öffentlich sichtbar'
                orientation='checkbox-left'
              />
              <ToolTip tip='Wenn das Kontrollkästchen aktiviert ist, ist der Wert für alle Nutzenden der App sichtbar, nicht nur für Antragsteller:in und Sachbearbeitung. Nur für Angaben ohne Personenbezug aktivieren.' />
            </div>
          )}
          <CheckboxFormField
            on={on.pflichtfeld}
            label='Pflichtfeld'
            orientation='checkbox-left'
          />
        </div>
      </div>
      <FormFeldSectionHeading
        titel={feldTypeRecord[__typename]}
        toolTip={
          __typename === 'SignatureFormularFeld' && (
            <ToolTip tip='Dieses Feld dient der Erfassung von Unterschriften, die nicht weiter verarbeitet werden. Für Signaturen, die weiterverarbeitet werden, verwenden Sie bitte das Upload-Feld.' />
          )
        }
      >
        <FormFeldRemoveButton onClick={onRemove} />
      </FormFeldSectionHeading>
      {!readOnly && (
        <InputFormField
          rules={{required: true}}
          on={on.slotName}
          label='Name des Slot *'
        />
      )}
      <InputFormField on={on.angezeigterName} label='Name des Formularfeld ' />
      {!readOnly && (
        <InputFormField on={on.anweisung} label='Anweisung (Platzhalter)' />
      )}
      <ExpressionInputFormField
        kind='bool'
        on={on.istRelevant}
        label='Ist relevant'
      />
      <div>
        {__typename === 'StringFormularFeld' && <StringFeld on={narrowed} />}
        {__typename === 'CheckboxListFormularFeld' && (
          <CheckboxListFeld on={narrowed} />
        )}
        {__typename === 'UploadFormularFeld' && <UploadFeld on={narrowed} />}
        {__typename === 'LocationFormularFeld' && <LocationFeld />}
        {__typename === 'DateFormularFeld' && <DateFeld />}
        {__typename === 'AnzeigeTextBlockFeld' && (
          <AnzeigeTextBlockFeld on={narrowed} />
        )}
      </div>
    </div>
  );
};

type StringFormularFeld = Extract<
  FormularSchrittFormFelderType,
  {__typename: 'StringFormularFeld'}
>;

/**
 * Komponente zur Bearbeitung eines Textfelds mit Optionen.
 * Ermöglicht das Hinzufügen, Bearbeiten und Entfernen von Optionen.
 * @param on FormBuilder-Instanz für das StringFormularFeld
 */
const StringFeld = ({on}: {on: FormBuilder<StringFormularFeld>}) => {
  const options = on.options.$useFieldArray();
  const hasOptions = options.fields.length > 0;

  useEffect(() => {
    if (hasOptions) on.multiline.$setValue(false);
    else on.durchsuchbar.$setValue(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [hasOptions]);

  return (
    <>
      <div className='flex justify-between'>
        <CheckboxFormField
          on={on.multiline}
          label='Mehrzeiliges Textfeld'
          orientation='checkbox-left'
          disabled={hasOptions}
        />
        <ToolTip tip='Nur verfügbar, solange das Feld keine Optionen hat. Ein mehrzeiliges Feld kann nicht gleichzeitig eine Auswahl (Dropdown) sein.' />
      </div>
      <FormFeldSectionHeading titel='Optionen'>
        <FormFeldAddButton
          onClick={() =>
            options.append({
              key: `option-${options.fields.length}`,
              value: '',
            })
          }
        />
      </FormFeldSectionHeading>
      {options.fields.map((option, index) => (
        <div key={option.$key} className='flex w-full gap-2'>
          <InputFormField
            className='w-full bg-white'
            on={option.value}
            label={`Option ${index + 1}`}
          />
          <button type='button' onClick={() => options.remove(index)}>
            <RiDeleteBin6Line className='size-6 text-red-500' />
          </button>
        </div>
      ))}
      <div className='flex justify-between'>
        <CheckboxFormField
          on={on.durchsuchbar}
          label='Suche in der App anbieten'
          orientation='checkbox-left'
          disabled={!hasOptions}
        />
        <ToolTip tip='Bürger können die Optionen dieses Feldes und aller davon abhängigen Folgefelder per Suchbegriff finden, statt sich Ebene für Ebene durchzuklicken. Nur verfügbar, solange das Feld Optionen hat.' />
      </div>
    </>
  );
};

type AnzeigeTextBlockFormularFeld = Extract<
  FormularSchrittFormFelderType,
  {__typename: 'AnzeigeTextBlockFeld'}
>;

/**
 * Komponente zur Bearbeitung eines Textblocks.
 * Stellt ein mehrzeiliges Eingabefeld für den Text bereit.
 * @param on FormBuilder-Instanz für das AnzeigeTextBlockFormularFeld
 */
const AnzeigeTextBlockFeld = ({
  on,
}: {
  on: FormBuilder<AnzeigeTextBlockFormularFeld>;
}) => <InputFormField on={on.text} multiLine label='Text' />;

type CheckboxListFormularFeld = Extract<
  FormularSchrittFormFelderType,
  {__typename: 'CheckboxListFormularFeld'}
>;

/**
 * Komponente zur Bearbeitung einer Checkbox-Liste.
 * Ermöglicht das Hinzufügen, Bearbeiten und Entfernen von Checkbox-Optionen mit Standardwert.
 * @param on FormBuilder-Instanz für das CheckboxListFormularFeld
 */
const CheckboxListFeld = ({
  on,
}: {
  on: FormBuilder<CheckboxListFormularFeld>;
}) => {
  const options = on.options.$useFieldArray();

  return (
    <>
      <FormFeldSectionHeading titel='Optionen'>
        <FormFeldAddButton
          onClick={() =>
            options.append({
              key: 'Neuer Eintrag',
              label: 'Neuer Eintrag',
              defaultChecked: false,
              order: options.fields.length,
            })
          }
        />
      </FormFeldSectionHeading>
      {options.fields.map((option, index) => (
        <CheckboxOptionRow
          key={option.$key}
          option={option}
          index={index}
          onRemove={() => options.remove(index)}
        />
      ))}
    </>
  );
};

const CheckboxOptionRow = ({
  option,
  index,
  onRemove,
}: {
  option: FormBuilder<CheckboxListFormularFeld['options'][number]> & {
    $key: string;
  };
  index: number;
  onRemove: () => void;
}) => {
  const label = option.label.$useWatch();

  useEffect(() => {
    option.key.$setValue(label);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [label]);

  return (
    <div className='flex w-full gap-2'>
      <div className='mb-4 flex w-full flex-col'>
        <div className='flex gap-2'>
          <InputFormField
            className='w-full bg-white'
            on={option.label}
            label={`Option ${index + 1}`}
          />
          <button type='button' onClick={onRemove}>
            <RiDeleteBin6Line className='size-6 text-red-500' />
          </button>
        </div>
        <CheckboxFormField
          on={option.defaultChecked}
          label='Vorausgewählt'
          orientation='checkbox-left'
        />
      </div>
    </div>
  );
};

type UploadFormularFeld = Extract<
  FormularSchrittFormFelderType,
  {__typename: 'UploadFormularFeld'}
>;

/**
 * Komponente zur Bearbeitung eines Upload-Felds.
 * Bietet Optionen für Freigabe, Mehrfach-Uploads und Dokumentenunterstützung.
 * @param on FormBuilder-Instanz für das UploadFormularFeld
 */
const UploadFeld = ({on}: {on: FormBuilder<UploadFormularFeld>}) => (
  <>
    <FormFeldSectionHeading titel='Optionen' />
    <div className='flex justify-between'>
      <CheckboxFormField
        on={on.brauchtFreigabe}
        label='Braucht Freigabe'
        orientation='checkbox-left'
      />
      <ToolTip tip='Wenn das Kontrollkästchen aktiviert ist, dann müssen Bilder erst von der Zuständigen Abteilung überprüft werden, damit sie in der App für Nutzende sichtbar sind.' />
    </div>
    <CheckboxFormField
      on={on.multi}
      label='Mehrere Uploads erlauben?'
      orientation='checkbox-left'
    />
    <div className='flex'>
      <CheckboxFormField
        on={on.document}
        label='Bürger bei der Eingabe von Dokumenten unterstützen? '
        orientation='checkbox-left'
        className='items-start'
      />
      <ToolTip
        tip='Wenn das Kontrollkästchen aktiviert ist, werden dem Bürger die Optionen
      Foto-Upload und Dateiauswahl angeboten. Andernfalls wird nur die normale
      Fotofunktion des Mobilgeräts angeboten.'
      />
    </div>
  </>
);

const LocationFeld = () => null;
const DateFeld = () => null;

export type FormFeldSectionHeadingProps = {
  titel: string;
  toolTip?: ReactNode;
};

/**
 * Überschriften-Komponente für Abschnitte innerhalb eines Formularfelds.
 * Zeigt einen Titel, optional einen Tooltip und zusätzliche Kinder an.
 * @param titel Titel des Abschnitts
 * @param toolTip Optionaler Tooltip als ReactNode
 * @param children Optionale Kind-Elemente
 */
const FormFeldSectionHeading = ({
  titel,
  toolTip,
  children,
}: PropsWithChildren<FormFeldSectionHeadingProps>) => (
  <div className='flex items-center font-bold'>
    <p className='text-sm font-normal'>{titel}</p>
    {toolTip && <div className='px-2'>{toolTip}</div>}
    <hr className='ml-4 h-px w-full' />
    {children}
  </div>
);

/**
 * Allgemeine Schaltflächen-Komponente für Aktionen in Formularfeldern.
 * Stellt eine Schaltfläche mit Text-Variante und grauer Schrift dar.
 * @param onClick Callback für Klick-Ereignisse
 * @param children Inhalt der Schaltfläche
 */
export const FormFeldActionButton = ({
  onClick,
  children,
}: PropsWithChildren<{onClick: () => void}>) => (
  <Button
    variant='text'
    type='button'
    className='flex items-center font-normal text-gray-500'
    onClick={onClick}
  >
    {children}
  </Button>
);

/**
 * Schaltfläche zum Entfernen eines Formularfelds.
 * Nutzt die allgemeine Aktions-Schaltfläche mit einem Lösch-Icon.
 * @param onClick Callback für Klick-Ereignis
 */
export const FormFeldRemoveButton = ({onClick}: {onClick: () => void}) => (
  <FormFeldActionButton onClick={onClick}>
    <MdClear />
  </FormFeldActionButton>
);

/**
 * Schaltfläche zum Hinzufügen eines neuen Elements in einem Formularfeld.
 * Nutzt die allgemeine Aktions-Schaltfläche mit einem Hinzufügen-Icon und Text.
 * @param onClick Callback für Klick-Ereignis
 */
export const FormFeldAddButton = ({onClick}: {onClick: () => void}) => (
  <FormFeldActionButton onClick={onClick}>
    <MdAdd />
    Hinzufügen
  </FormFeldActionButton>
);
