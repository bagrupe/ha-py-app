import {type FC} from 'react';
import {MdCheck} from 'react-icons/md';
import {type AntragDetailSchritt_BezahlenSchritt} from '../../detail.generated.ts';

/**
 * Eigenschaften für die Komponente BezahlenSchritt.
 * Enthält den Schritt mit den Zahlungsdetails.
 */
export type BezahlenSchrittProps = {
  schritt: AntragDetailSchritt_BezahlenSchritt;
};

/**
 * Komponente zur Anzeige einer erfolgreichen Zahlung mit Betrag und Icon.
 * @param schritt Enthält die Zahlungsinformationen, insbesondere den Betrag.
 */
export const BezahlenSchritt: FC<BezahlenSchrittProps> = ({schritt}) => (
  <div className='flex items-center p-2'>
    Zahlung über {schritt.betrag.toFixed(2).replace('.', ',')}€ war erfolgreich.{' '}
    <MdCheck />
  </div>
);
