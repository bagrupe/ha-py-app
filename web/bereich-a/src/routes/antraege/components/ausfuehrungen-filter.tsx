import {MdSearch} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {type CollectionItem} from '../../../components/form/fields/collections.ts';
import {InputField} from '../../../components/form/fields/input-field';
import {SelectField} from '../../../components/form/fields/select-field';
import {useLoggedInLayoutQuery} from '../../../components/layouts/logged-in-layout/logged-in-layout.generated.ts';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';

/**
 * Such- und Filterleiste für die Anträge-Liste: Freitext-Suche (clientseitig über die
 * geladene Seite, nicht verschlüsselte Felder) und Filter nach Antragsart.
 * @param className Optionale CSS-Klassen zur Anpassung des äußeren Containers.
 */
export const AusfuehrungenFilter = ({className}: {className?: string}) => {
  const selectedAntragsArt = useAppUiStore((state) => state.antragsartFilter);
  const updateSelectedAntragsart = useAppUiStore(
    (state) => state.updateAntragsartFilter,
  );
  const suche = useAppUiStore((state) => state.antragSuche);
  const setSuche = useAppUiStore((state) => state.setAntragSuche);

  const [{data}] = useLoggedInLayoutQuery();
  const my = data?.my ?? {};
  const prozesse = 'kommune' in my ? my.kommune.prozesse ?? [] : [];

  const antragsartItems: CollectionItem<string | null>[] = [
    {key: 'alle', name: 'Alle', value: null},
    ...prozesse.map((prozess) => ({
      key: prozess.id,
      value: prozess.id,
      name: prozess.name,
    })),
  ];

  return (
    <div
      className={twMerge(
        'flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-end',
        className,
      )}
    >
      <InputField
        type='search'
        value={suche}
        onChange={(e) => setSuche(e.currentTarget.value)}
        label='Suchen'
        endAdornment={<MdSearch className='text-gray-400' />}
        className='w-full sm:w-80'
      />

      <SelectField
        items={antragsartItems}
        value={selectedAntragsArt}
        onChange={(value) => updateSelectedAntragsart(value)}
        label='Nach Antragsart filtern'
        className='w-full sm:w-80'
      />
    </div>
  );
};
