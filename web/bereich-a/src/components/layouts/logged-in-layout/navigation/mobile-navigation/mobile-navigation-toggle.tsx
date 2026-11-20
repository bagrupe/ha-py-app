import {type FC} from 'react';
import {MdMenu} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {useKommune} from '../../../../../lib/context/kommune/kommune';
import {useOffScreen} from '../../../../offscreen';

/**
 * Mobile Navigation Toggle-Komponente.
 *
 * Dient als Kopfzeile mit einem Logo und einem Menü-Button, der ein Offscreen-Menü anzeigen oder ausblenden kann.
 *
 * @param className - Zusätzliche CSS-Klassen für die äußere Wrapper-Div.
 */
export const MobileNavigationToggle: FC<{className?: string}> = ({
  className,
}) => {
  const setVisible = useOffScreen();
  const {logoUrl} = useKommune();

  return (
    <div
      className={twMerge(
        'sticky flex items-center justify-between p-4 xl:hidden',
        className,
      )}
    >
      {logoUrl ? (
        <img
          src={logoUrl}
          alt='Logo'
          className='max-h-full w-24 self-center object-contain object-left py-4'
        />
      ) : (
        <div />
      )}
      <button onClick={() => setVisible((prev) => !prev)} title='Menü öffnen'>
        <MdMenu className='size-12' />
      </button>
    </div>
  );
};
