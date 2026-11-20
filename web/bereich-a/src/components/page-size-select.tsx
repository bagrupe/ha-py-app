import {useLocation, useNavigate} from 'react-router';
import {type ListKey, useAppUiStore} from '../lib/app-ui-store.ts';

const OPTIONEN = [10, 20, 30, 40, 50, 100];

/**
 * Auswahl der Seitengröße für die angegebene Liste (`listKey`). Setzt den Wert im UI-Store
 * und springt auf Seite 1 zurück, damit man nicht außerhalb des gültigen Bereichs landet.
 */
export const PageSizeSelect = ({
  listKey,
  className,
}: {
  listKey: ListKey;
  className?: string;
}) => {
  const seitengroesse = useAppUiStore((s) => s.seitengroessen[listKey]);
  const setSeitengroesse = useAppUiStore((s) => s.setSeitengroesse);
  const navigate = useNavigate();
  const loc = useLocation();

  return (
    <label
      className={`flex items-center gap-2 text-sm text-gray-600 ${
        className ?? ''
      }`}
    >
      <span>Pro Seite</span>
      <select
        className='rounded-md border border-gray-300 bg-white px-2 py-1'
        value={seitengroesse}
        onChange={(e) => {
          setSeitengroesse(listKey, Number(e.currentTarget.value));
          const search = new URLSearchParams(loc.search);
          search.set('page', '1');
          navigate({...loc, search: search.toString()});
        }}
      >
        {OPTIONEN.map((n) => (
          <option key={n} value={n}>
            {n}
          </option>
        ))}
      </select>
    </label>
  );
};
