import {useCallback, useState} from 'react';
import {toDayTokenIso} from '../../utils/timeUtils';
import {type FilterRowValue} from './FilterRowToggleGroup';

export interface UseFilterRowDayOptions {
  /** Controlled value. Omit for uncontrolled mode (defaults to today). */
  selectedDay?: FilterRowValue;
  onSelectedDayChange?: (value: FilterRowValue) => void;
}

export interface UseFilterRowDayResult {
  selectedDay: FilterRowValue;
  setSelectedDay: (value: FilterRowValue) => void;
}

/**
 * Shared day state for filter-row controls (toggle group + date picker).
 * Supports controlled and uncontrolled usage.
 */
const normalizeSelectedDay = (value: FilterRowValue): FilterRowValue =>
  value || toDayTokenIso(new Date());

export function useFilterRowDateSelection({
  selectedDay: selectedDayProp,
  onSelectedDayChange,
}: UseFilterRowDayOptions = {}): UseFilterRowDayResult {
  const [selectedDayInternal, setSelectedDayInternal] =
    useState<FilterRowValue>(() => toDayTokenIso(new Date()));
  const selectedDay = normalizeSelectedDay(
    selectedDayProp ?? selectedDayInternal,
  );
  const setSelectedDay = useCallback(
    (value: FilterRowValue) => {
      const update = onSelectedDayChange ?? setSelectedDayInternal;
      update(normalizeSelectedDay(value));
    },
    [onSelectedDayChange],
  );

  return {selectedDay, setSelectedDay};
}
