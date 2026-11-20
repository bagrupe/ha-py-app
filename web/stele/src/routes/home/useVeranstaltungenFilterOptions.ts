import {useMemo} from 'react';
import {STELE_CONFIG} from '../../config';
import {compact} from '../../utils/arrayUtils';
import type {KioskVeranstaltungenFilterOptionsQuery} from './veranstaltungen-filter.generated';
import {useKioskVeranstaltungenFilterOptionsQuery} from './veranstaltungen-filter.generated';

export type VeranstaltungenFilterOption = {
  id: string;
  label: string;
};

const buildCategories = (
  data: KioskVeranstaltungenFilterOptionsQuery | undefined,
): VeranstaltungenFilterOption[] =>
  compact(data?.veranstaltungskalenderKategories?.docs).map((doc) => ({
    id: doc.id,
    label: doc.label,
  }));

const buildGemeinden = (
  data: KioskVeranstaltungenFilterOptionsQuery | undefined,
): VeranstaltungenFilterOption[] =>
  compact(data?.untereinheitList?.docs).map((doc) => ({
    id: doc.id,
    label: doc.name,
  }));

// Loads the available Gemeinde and Kategorie filter options for the
// Veranstaltungen filter row, sourced from the CMS/backend like the app.
export const useVeranstaltungenFilterOptions = () => {
  const {kommuneId} = STELE_CONFIG;

  const [{data, fetching, error}] = useKioskVeranstaltungenFilterOptionsQuery({
    variables: {
      kommuneId,
    },
    pause: kommuneId === '',
  });

  const categories = useMemo(() => buildCategories(data), [data]);
  const gemeinden = useMemo(() => buildGemeinden(data), [data]);

  return {categories, gemeinden, fetching, error};
};
