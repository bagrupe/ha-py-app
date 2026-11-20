import {type FormBuilder} from '@atmina/formbuilder';
import {SelectFormField} from '../../../../../components/form/fields/select-field';
import type {SchrittDaten} from '../../lib/domain-types.ts';
import {useProgrammatischeSchritteQuery} from '../../programmatische-schritte.generated.ts';

/**
 * Typ für die Formulardaten eines programmatischen Schritts.
 */
type FormData = Extract<SchrittDaten, {__typename: 'ProgrammatischerSchritt'}>;

/**
 * Komponente zur Auswahl eines programmatischen Schritttyps im Formular.
 * Lädt verfügbare programmatische Schritte und stellt sie als Auswahlfeld dar.
 *
 * @param on FormBuilder-Instanz zur Bindung der Formulardaten
 */
export const ProgrammatischerSchritt = ({on}: {on: FormBuilder<FormData>}) => {
  const [{data}] = useProgrammatischeSchritteQuery();
  const items =
    data?.programmatischeSchritte?.map((p) => ({
      name: p.name,
      value: p.implementationAssemblyQualifiedName,
    })) ?? [];

  return (
    <div>
      {data && (
        <SelectFormField
          label='Typ'
          items={items}
          on={on.implementationAssemblyQualifiedName}
        />
      )}
    </div>
  );
};
