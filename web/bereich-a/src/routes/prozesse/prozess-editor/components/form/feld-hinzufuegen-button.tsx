import {useState} from 'react';
import {MdAdd} from 'react-icons/md';
import {Button} from 'src/components/ui/button';
import {DropdownMenu} from 'src/components/ui/dropdown-menu/dropdown-menu';
import {type FormularSchrittFormFelderType} from './formular-schritt-form.tsx';

/**
 * Erzeugt ein leeres Basisformularfeld mit Standardwerten.
 * Dies ist notwendig, da react-hook-form alle Schlüssel mit Standardwerten benötigt,
 * um unerwünschte Zuweisungen aus dem ersten Array-Element zu vermeiden.
 * @returns Ein Formularfeld ohne den __typename Schlüssel mit initialen Werten.
 */
const emptyBaseFeld = (): Omit<
  FormularSchrittFormFelderType,
  '__typename'
> => ({
  id: crypto.randomUUID().toString(),
  order: 1,
  anweisung: '',
  angezeigterName: '',
  slotName: '',
  istRelevant: 'true',
  encrypted: false,
  inhaltsTag: null,
  pflichtfeld: false,
  oeffentlichSichtbar: false,
});

/**
 * Komponente für einen Button mit Dropdown-Menü zum Hinzufügen verschiedener Formularfelder.
 * Öffnet ein Menü mit verschiedenen Feldtypen, die beim Auswählen an die onAdd-Funktion übergeben werden.
 * @param onAdd Callback-Funktion, die das neu erstellte Formularfeld entgegennimmt.
 */
export const FeldHinzufuegenButton = ({
  onAdd,
}: {
  onAdd: (value: FormularSchrittFormFelderType) => void;
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const handleAdd = (value: FormularSchrittFormFelderType) => {
    // Have to wrap in try catch because the formbuilder throws
    // a maximum callstack exceed error some internal maximum call stack
    onAdd(value);
  };

  return (
    <DropdownMenu open={isOpen} onOpenChange={setIsOpen}>
      <DropdownMenu.Trigger asChild>
        <Button variant='text' className='flex items-center gap-1 font-normal'>
          <MdAdd />
          Hinzufügen
        </Button>
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content className='min-w-fit'>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                ...emptyBaseFeld(),
                __typename: 'StringFormularFeld',
                options: [],
                multiline: false,
                durchsuchbar: false,
              });
            }}
          >
            Textfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'DateFormularFeld',
                ...emptyBaseFeld(),
              });
            }}
          >
            Datumsfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'TimeFormularFeld',
                ...emptyBaseFeld(),
              });
            }}
          >
            Uhrzeitfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'CheckboxListFormularFeld',
                ...emptyBaseFeld(),
                options: [],
              });
            }}
          >
            Checkboxfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'LocationFormularFeld',
                ...emptyBaseFeld(),
              });
            }}
          >
            Standortfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'UploadFormularFeld',
                ...emptyBaseFeld(),
                brauchtFreigabe: false,
                document: false,
                multi: false,
              });
            }}
          >
            Uploadfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              handleAdd({
                __typename: 'SignatureFormularFeld',
                ...emptyBaseFeld(),
              });
            }}
          >
            Unterschriftfeld
          </DropdownMenu.Item>
          <DropdownMenu.Item
            onClick={() => {
              const baseFeld = emptyBaseFeld();
              handleAdd({
                __typename: 'AnzeigeTextBlockFeld',
                ...baseFeld,
                slotName: baseFeld.id,
                text: '',
              });
            }}
          >
            Textblock (Read-Only)
          </DropdownMenu.Item>
          <DropdownMenu.Arrow />
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu>
  );
};
