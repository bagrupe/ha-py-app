import {useState} from 'react';
import {CiLocationOn} from 'react-icons/ci';
import {
  MdOutlineCalendarMonth,
  MdOutlineCategory,
  MdOutlineLocationOn,
} from 'react-icons/md';
import {useSearchParams} from 'react-router';
import {Badge} from '../../components/badge';
import {CarouselSlideVeranstaltung} from '../../components/carousel-slide';
import {CarouselSlider} from '../../components/carousel-slider';
import FilterRowChipPopover, {
  type FilterRowChipItem,
} from '../../components/filter-row/FilterRowChipPopover';
import FilterRowDatePicker from '../../components/filter-row/FilterRowDatePicker';
import {FilterRowLayout} from '../../components/filter-row/FilterRowLayout';
import FilterRowToggleGroup from '../../components/filter-row/FilterRowToggleGroup';
import {useFilterRowDateSelection} from '../../components/filter-row/useFilterRowDateSelection';
import {useAutoCollapse} from '../../hooks/useAutoCollapse';
import {useFilterRowAutoReset} from '../../hooks/useFilterRowAutoReset';
import {
  toDayEndUtcIso,
  toDayStartUtcIso,
  toDayTokenIso,
} from '../../utils/timeUtils';
import {
  type KioskVeranstaltung,
  useKioskVeranstaltungen,
} from './useKioskVeranstaltungen';
import {useVeranstaltungenFilterOptions} from './useVeranstaltungenFilterOptions';

const GEMEINDE_PARAM = 'gemeinde';

// Matches a Gemeinde name (e.g. from the `?gemeinde=` URL parameter) against
// the loaded Gemeinde list, case-insensitively. Exported for unit testing.
export const findGemeindeIdByName = (
  gemeinden: FilterRowChipItem[],
  name: string,
): string | undefined =>
  gemeinden.find((gemeinde) => gemeinde.label.toLowerCase() === name)?.id;

export default function EventsBlockView({
  events,
  selectedDay,
  setSelectedDay,
  gemeinden,
  selectedGemeindeIds,
  onSelectedGemeindeIdsChange,
  categories,
  selectedCategoryIds,
  onSelectedCategoryIdsChange,
}: {
  events: KioskVeranstaltung[];
  selectedDay: string;
  setSelectedDay: (day: string) => void;
  gemeinden: FilterRowChipItem[];
  selectedGemeindeIds: string[];
  onSelectedGemeindeIdsChange: (ids: string[]) => void;
  categories: FilterRowChipItem[];
  selectedCategoryIds: string[];
  onSelectedCategoryIdsChange: (ids: string[]) => void;
}) {
  const {expandedId, toggle, collapse, remainingSeconds} = useAutoCollapse();
  const hasActiveGemeindeOrCategoryFilter =
    selectedGemeindeIds.length > 0 || selectedCategoryIds.length > 0;

  return (
    <CarouselSlider
      slidesKey={[
        selectedDay,
        ...selectedGemeindeIds,
        ...selectedCategoryIds,
      ].join('|')}
      heading='Veranstaltungen'
      emptyState={
        hasActiveGemeindeOrCategoryFilter
          ? 'Keine Veranstaltungen für diese Filterauswahl.'
          : 'Keine Veranstaltungen für diesen Zeitraum.'
      }
      autoplayPaused={expandedId !== null}
      onSlideChange={collapse}
      toolbar={
        <FilterRowLayout className='mb-5'>
          <FilterRowToggleGroup
            value={selectedDay}
            onValueChange={setSelectedDay}
          />
          <FilterRowDatePicker
            title='Zeitpunkt auswählen'
            triggerIcon={<MdOutlineCalendarMonth />}
            value={selectedDay}
            onValueChange={setSelectedDay}
          />
          <FilterRowChipPopover
            title='Gemeinde'
            triggerIcon={<MdOutlineLocationOn />}
            placeholder='Alle Gemeinden'
            panelTitle='Gemeinde auswählen'
            items={gemeinden}
            selectedIds={selectedGemeindeIds}
            onSelectedIdsChange={onSelectedGemeindeIdsChange}
          />
          <FilterRowChipPopover
            title='Kategorie'
            triggerIcon={<MdOutlineCategory />}
            placeholder='Alle Kategorien'
            panelTitle='Kategorie auswählen'
            items={categories}
            selectedIds={selectedCategoryIds}
            onSelectedIdsChange={onSelectedCategoryIdsChange}
          />
        </FilterRowLayout>
      }
    >
      {events.map((event) => (
        <CarouselSlideVeranstaltung
          key={event.id}
          date={event.date}
          headline={event.titel}
          subHeadline={event.teaser}
          image={event.image}
          headerEnd={
            event.locationName ? (
              <Badge label={event.locationName} icon={CiLocationOn} colorized />
            ) : undefined
          }
          termin={event.termin}
          veranstalter={event.veranstalter}
          isExpanded={expandedId === event.id}
          onToggleExpand={() => toggle(event.id)}
          autoCollapseSecondsRemaining={
            expandedId === event.id ? remainingSeconds : undefined
          }
        />
      ))}
    </CarouselSlider>
  );
}

export const EventsBlock = () => {
  const {selectedDay, setSelectedDay} = useFilterRowDateSelection();
  const {gemeinden, categories} = useVeranstaltungenFilterOptions();
  const [searchParams] = useSearchParams();

  const [selectedGemeindeIds, setSelectedGemeindeIds] = useState<string[]>([]);
  const [selectedCategoryIds, setSelectedCategoryIds] = useState<string[]>([]);

  // Preselect the Gemeinde passed via the `?gemeinde=` URL parameter (e.g. a
  // Stele installed at/for a specific Gemeinde), once the Gemeinde list has
  // loaded. Adjusts state during render (see "You Might Not Need an Effect")
  // instead of an Effect, comparing against the previously-processed
  // `gemeinden` reference so it only ever applies once, never overriding a
  // later manual choice.
  const [gemeindeDefaultAppliedFor, setGemeindeDefaultAppliedFor] = useState<
    typeof gemeinden | null
  >(null);
  const [defaultGemeindeIds, setDefaultGemeindeIds] = useState<string[]>([]);
  if (gemeindeDefaultAppliedFor !== gemeinden && gemeinden.length > 0) {
    setGemeindeDefaultAppliedFor(gemeinden);

    const paramValue = searchParams.get(GEMEINDE_PARAM)?.trim().toLowerCase();
    const matchedId = paramValue
      ? findGemeindeIdByName(gemeinden, paramValue)
      : undefined;
    if (matchedId) {
      setDefaultGemeindeIds([matchedId]);
      setSelectedGemeindeIds([matchedId]);
    }
  }

  const todayValue = toDayTokenIso(new Date());
  const isFilterDirty =
    selectedDay !== todayValue ||
    selectedGemeindeIds.length !== defaultGemeindeIds.length ||
    selectedGemeindeIds.some((id) => !defaultGemeindeIds.includes(id)) ||
    selectedCategoryIds.length > 0;
  useFilterRowAutoReset(isFilterDirty, () => {
    setSelectedDay(todayValue);
    setSelectedGemeindeIds(defaultGemeindeIds);
    setSelectedCategoryIds([]);
  });

  const {events} = useKioskVeranstaltungen(
    toDayStartUtcIso(selectedDay),
    toDayEndUtcIso(selectedDay),
    selectedCategoryIds,
    selectedGemeindeIds,
  );

  return (
    <EventsBlockView
      events={events}
      selectedDay={selectedDay}
      setSelectedDay={setSelectedDay}
      gemeinden={gemeinden}
      selectedGemeindeIds={selectedGemeindeIds}
      onSelectedGemeindeIdsChange={setSelectedGemeindeIds}
      categories={categories}
      selectedCategoryIds={selectedCategoryIds}
      onSelectedCategoryIdsChange={setSelectedCategoryIds}
    />
  );
};
