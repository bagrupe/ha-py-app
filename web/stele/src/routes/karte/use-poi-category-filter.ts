import {useCallback, useMemo, useState} from 'react';
import {type MapFilterCategoryItem} from '../../components/map-filter';
import {type StelePoisQuery} from './karte.generated';

type StelePoi = NonNullable<
  NonNullable<NonNullable<StelePoisQuery['pois']>['docs']>[number]
>;

export type PoiCategoryGroup = {
  id: string;
  name: string;
  items: MapFilterCategoryItem[];
};

export type UsePoiCategoryFilterResult = {
  categoryGroups: PoiCategoryGroup[];
  pendingSelectedIds: string[];
  setPendingSelectedIds: (ids: string[]) => void;
  allPendingSelected: boolean;
  setAllPendingSelected: (value: boolean) => void;
  appliedSelectedCount: number;
  commit: () => void;
  revertPending: () => void;
  visiblePois: StelePoi[];
};

export const usePoiCategoryFilter = (
  pois: StelePoi[],
): UsePoiCategoryFilterResult => {
  const categoryGroups = useMemo<PoiCategoryGroup[]>(() => {
    const groups = new Map<
      string,
      {name: string; items: Map<string, MapFilterCategoryItem>}
    >();
    for (const poi of pois) {
      const {category} = poi;
      if (!category?.id) continue;
      const superId = category.supercategory?.id ?? '__ungrouped';
      let group = groups.get(superId);
      if (!group) {
        group = {name: category.supercategory?.title ?? '', items: new Map()};
        groups.set(superId, group);
      }
      if (!group.items.has(category.id)) {
        group.items.set(category.id, {
          id: category.id,
          label: category.title,
          iconUrl: category.icon?.url,
        });
      }
    }
    return Array.from(groups.entries()).map(([id, {name, items}]) => ({
      id,
      name,
      items: Array.from(items.values()),
    }));
  }, [pois]);

  const allCategoryIds = useMemo(
    () => categoryGroups.flatMap((g) => g.items.map((i) => i.id)),
    [categoryGroups],
  );

  // `null` = no explicit filter → show all (default unfiltered state)
  const [pendingSelectedIds, setPendingSelectedIds] = useState<string[] | null>(
    null,
  );
  const [appliedSelectedIds, setAppliedSelectedIds] = useState<string[] | null>(
    null,
  );

  const allPendingSelected =
    allCategoryIds.length > 0 &&
    (pendingSelectedIds === null ||
      pendingSelectedIds.length === allCategoryIds.length);

  const setAllPendingSelected = useCallback(
    (value: boolean) => setPendingSelectedIds(value ? null : []),
    [],
  );

  const commit = useCallback(() => {
    setAppliedSelectedIds(pendingSelectedIds);
  }, [pendingSelectedIds]);

  const revertPending = useCallback(() => {
    setPendingSelectedIds(appliedSelectedIds);
  }, [appliedSelectedIds]);

  const visiblePois = useMemo(() => {
    if (appliedSelectedIds === null) return pois;
    if (appliedSelectedIds.length === 0) return [];
    const selected = new Set(appliedSelectedIds);
    return pois.filter((poi) => {
      const categoryId = poi.category?.id;
      return categoryId ? selected.has(categoryId) : false;
    });
  }, [pois, appliedSelectedIds]);

  return {
    categoryGroups,
    pendingSelectedIds: pendingSelectedIds ?? allCategoryIds,
    setPendingSelectedIds,
    allPendingSelected,
    setAllPendingSelected,
    appliedSelectedCount:
      appliedSelectedIds === null
        ? allCategoryIds.length
        : appliedSelectedIds.length,
    commit,
    revertPending,
    visiblePois,
  };
};
