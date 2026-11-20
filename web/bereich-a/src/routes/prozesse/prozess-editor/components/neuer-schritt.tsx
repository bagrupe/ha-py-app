import {type FC, useRef} from 'react';
import {useClickAway} from 'react-use';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {assertUnreachable} from '../../../../utils/assert-unreachable';
import {type SchrittDaten} from '../lib/domain-types.ts';
import {type SchrittNode} from '../lib/flow/flow.types.ts';
import {type ProzessEditorSchritt} from '../prozess-version-erstellen.generated.ts';

const schritteOptions: {
  label: string;
  typeName: ProzessEditorSchritt['__typename'] | 'GhostSchritt';
}[] = [
  {label: 'Platzhalter', typeName: 'GhostSchritt'},
  {label: 'Bezahlen-Schritt', typeName: 'BezahlenSchritt'},
  {
    label: 'Email-Weiterleiten-Schritt',
    typeName: 'EmailForwarderExportSchritt',
  },
  {label: 'Ende-Schritt', typeName: 'EndeSchritt'},
  {label: 'Formular-Schritt', typeName: 'FormularSchritt'},
  {
    label: 'GovManager-Export-Schritt',
    typeName: 'GovManagerRestExportSchritt',
  },
  {label: 'Nachricht-Schritt', typeName: 'NachrichtSchritt'},
  {label: 'Programmatischer Schritt', typeName: 'ProgrammatischerSchritt'},
  {
    label: 'Warte-auf-Bezahlung-abgeschlossen-Schritt',
    typeName: 'WarteAufBezahlungAbgeschlossenSchritt',
  },
  {
    label: 'Warte-auf-GovManager-Schritt',
    typeName: 'WarteAufGovManagerSchritt',
  },
];

/**
 * Eigenschaften für die Komponente NeuerSchrittSelect.
 * Ermöglicht die Positionierung und definiert Callback-Funktionen für Auswahl und Klick außerhalb.
 */
export type NeuerSchrittSelectProps = {
  top?: number;
  left?: number;
  right?: number;
  bottom?: number;
  onSelect: (
    label: string,
    typeName: SchrittDaten['__typename'],
    top?: number,
    left?: number,
    right?: number,
    bottom?: number,
  ) => void;
  onClickAway: () => void;
};

/**
 * Komponente zur Auswahl eines neuen Schritttyps im Prozesseditor.
 * Zeigt eine Liste von Schrittoptionen an und reagiert auf Auswahl oder Klick außerhalb.
 */
export const NeuerSchrittSelect: FC<NeuerSchrittSelectProps> = ({
  top,
  left,
  right,
  bottom,
  onSelect,
  onClickAway,
}) => {
  const ref = useRef<HTMLDivElement>(null);
  useClickAway(ref, onClickAway);

  return (
    <div
      className='absolute z-10 flex flex-col gap-2 rounded-md border border-gray-300 bg-white py-2'
      style={{top, left, right, bottom}}
      ref={ref}
    >
      {schritteOptions.map(({label, typeName}) => (
        <div
          className='px-4 hover:cursor-pointer hover:bg-gray-100'
          onClick={() => onSelect(label, typeName, top, left, right, bottom)}
          key={typeName}
        >
          {label}
        </div>
      ))}
    </div>
  );
};

/**
 * Erzeugt ein neues Schrittobjekt basierend auf dem Typ und Titel.
 * Initialisiert gemeinsame Felder und spezifische Eigenschaften je nach Schritt-Typ.
 * @param param0 Objekt mit Titel und Typname des Schritts
 * @returns Neues Schrittobjekt ohne ID
 */
type NeuerSchrittData = Partial<SchrittNode['data']['schritt']> &
  Pick<SchrittNode['data']['schritt'], '__typename'>;

export const newSchrittByType = ({
  titel: schrittLabel,
  __typename,
}: Pick<SchrittDaten, '__typename' | 'titel'>): NeuerSchrittData => {
  const commonFields = {
    titel: `Neuer ${schrittLabel}`,
    erledigungDurchBuerger: false,
    sollZustaendigkeit: {
      art: ZustaendigkeitArt.Buerger,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: false,
    },
    slots: [],
  };

  switch (__typename) {
    case 'GhostSchritt': {
      return {
        ...commonFields,
        __typename,
      };
    }
    case 'BezahlenSchritt': {
      return {
        ...commonFields,
        __typename,
        betrag: 0,
      };
    }
    case 'EmailForwarderExportSchritt': {
      return {
        ...commonFields,
        __typename,
        body: '',
        emailAddress: '',
        subject: '',
      };
    }
    case 'FormularSchritt': {
      return {
        ...commonFields,
        __typename,
        felder: [],
      };
    }
    case 'EndeSchritt': {
      return {
        ...commonFields,
        __typename,
      };
    }
    case 'ProgrammatischerSchritt': {
      return {
        ...commonFields,
        __typename,
        implementationAssemblyQualifiedName:
          'API.Features.Prozess.ProgrammatischeSchritte.WeicheSchritt, API, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null',
      };
    }
    case 'WarteAufBezahlungAbgeschlossenSchritt': {
      return {
        ...commonFields,
        __typename,
        bezahlenSchrittId: '',
      };
    }
    case 'GovManagerRestExportSchritt':
      return {
        ...commonFields,
        __typename,
        exportFilePartsAsPdf: false,
        vorgangsSchluessel: '',
        mandantenSchluessel: '',
        vorgangsTyp: '',
        exportParts: [],
      };
    case 'WarteAufGovManagerSchritt':
      return {
        ...commonFields,
        __typename,
        govManagerSchrittId: '',
      };
    case 'NachrichtSchritt':
      return {
        ...commonFields,
        __typename,
      };
    default: {
      return assertUnreachable(__typename);
    }
  }
};
