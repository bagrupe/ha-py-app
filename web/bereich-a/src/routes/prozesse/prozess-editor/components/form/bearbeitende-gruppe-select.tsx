import {type FormBuilder} from '@atmina/formbuilder';
import {type FC, useMemo} from 'react';
import {SelectFormField} from '../../../../../components/form/fields/select-field';
import {useGruppenUndOrganisationseinheitenQuery} from '../../prozess-editor.generated.ts';

/**
 * Eigenschaften für die Komponente BearbeitendeGruppeSelect.
 * Erwartet ein FormBuilder-Objekt zur Steuerung des Formularfelds.
 */
export type BearbeitendeGruppeSelectProps = {
  on: FormBuilder<string>;
};

/**
 * Komponente zur Auswahl einer bearbeitenden Gruppe.
 * Lädt die verfügbaren Gruppen und stellt ein Auswahlfeld bereit, das auch eine Option für "Nicht zugeordnet" enthält.
 * @param on FormBuilder-Instanz zur Steuerung des Auswahlfelds
 */
export const BearbeitendeGruppeSelect: FC<BearbeitendeGruppeSelectProps> = ({
  on,
}) => {
  const [{data}] = useGruppenUndOrganisationseinheitenQuery();
  const gruppen = useMemo(() => {
    if (data?.my.__typename !== 'BackofficeUser') return [];

    return data.my.kommune.mitarbeiterGruppen;
  }, [data]);

  const items = useMemo(
    () => gruppen.map((g) => ({name: g.name, value: g.id})),
    [gruppen],
  );
  const nichtZugeordnet = {name: 'Nicht zugeordnet', value: null};

  return (
    <SelectFormField
      on={on}
      label='Zugewiesen zu'
      items={[nichtZugeordnet, ...items]}
    />
  );
};
