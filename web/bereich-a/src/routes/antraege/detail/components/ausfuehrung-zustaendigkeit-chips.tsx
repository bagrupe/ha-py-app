import {ChevronRightIcon} from '@radix-ui/react-icons';
import {type ReactNode} from 'react';
import {formatVornameNachname} from 'src/utils/format-names';
import {type AntragDetailAusfuehrung} from '../detail.generated';

/**
 * Komponente zur Darstellung eines einzelnen Chips mit Zuständigkeitsinformationen.
 * Zeigt ein Label und einen Namen an.
 * @param label Beschriftung des Chips
 * @param name Inhalt des Chips, kann ReactNode sein
 */
const ZustaendigkeitChip = ({
  label,
  name,
}: {
  label: string;
  name: ReactNode;
}) => (
  <div className='box-content flex-col rounded-md bg-gray-50 px-3 py-1 text-gray-700 shadow-md shadow-gray-500/10 outline outline-1 outline-gray-500/15'>
    <div className='text-xs capitalize'>{label}</div>
    <div className='font-bold'>{name}</div>
  </div>
);

/**
 * Komponente zur Anzeige der Zuständigkeiten einer Ausführung als Chips mit Pfeilen dazwischen.
 * Nutzt die Daten der Ausführung, um verschiedene Zuständigkeitsstufen darzustellen.
 * @param ausfuehrung Die Ausführung mit Zuständigkeitsinformationen
 */
export const AusfuehrungZustaendigkeitChips = ({
  ausfuehrung,
}: {
  ausfuehrung: AntragDetailAusfuehrung;
}) => (
  <div className='flex flex-wrap items-center gap-x-1.5 gap-y-3 py-1 text-sm'>
    <ZustaendigkeitChip
      label='Zuständigkeit:'
      name={
        <span className='capitalize'>
          {ausfuehrung.istZustaendigkeit.art.toLowerCase()}
        </span>
      }
    />
    {ausfuehrung.istZustaendigkeit.organisationseinheit && (
      <>
        <ChevronRightIcon className='size-6 text-primary' />
        <ZustaendigkeitChip
          label='Organisationseinheit:'
          name={ausfuehrung.istZustaendigkeit.organisationseinheit.name}
        />
      </>
    )}
    {ausfuehrung.istZustaendigkeit.mitarbeiterGruppe && (
      <>
        <ChevronRightIcon className='size-6 text-primary' />
        <ZustaendigkeitChip
          label='Abteilung:'
          name={ausfuehrung.istZustaendigkeit.mitarbeiterGruppe.name}
        />
      </>
    )}
    {ausfuehrung.istZustaendigkeit.dienstleister && (
      <>
        <ChevronRightIcon className='size-6 text-primary' />
        <ZustaendigkeitChip
          label='Dienstleister:'
          name={ausfuehrung.istZustaendigkeit.dienstleister.name}
        />
      </>
    )}
    {ausfuehrung.istZustaendigkeit.zugewiesenePerson && (
      <>
        <ChevronRightIcon className='size-6 text-primary' />
        <ZustaendigkeitChip
          label='Person:'
          name={formatVornameNachname(
            ausfuehrung.istZustaendigkeit.zugewiesenePerson,
          )}
        />
      </>
    )}
  </div>
);
