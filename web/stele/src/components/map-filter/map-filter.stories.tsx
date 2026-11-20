import type {Meta, StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {
  MdAccountBalance,
  MdDirectionsBike,
  MdEventNote,
  MdLocalCafe,
  MdMusicNote,
  MdRestaurant,
  MdSchool,
  MdSportsBasketball,
} from 'react-icons/md';

import {MapFilter, type MapFilterProps} from './map-filter';
import {
  MapFilterCategory,
  type MapFilterCategoryItem,
} from './map-filter-category';

const veranstaltungen: MapFilterCategoryItem[] = [
  {id: 'gastro', label: 'Gastronomie', icon: MdRestaurant},
  {id: 'cafes', label: 'Cafés', icon: MdLocalCafe},
  {id: 'musik', label: 'Musik', icon: MdMusicNote},
  {id: 'sport', label: 'Sport', icon: MdSportsBasketball},
];

const orte: MapFilterCategoryItem[] = [
  {id: 'bildung', label: 'Bildung', icon: MdSchool},
  {id: 'amt', label: 'Ämter', icon: MdAccountBalance},
  {id: 'rad', label: 'Radwege', icon: MdDirectionsBike},
  {id: 'events', label: 'Events', icon: MdEventNote},
];

const allIds = [...veranstaltungen, ...orte].map(({id}) => id);

const config = {
  title: 'Components/MapFilter',
  component: MapFilter,
  tags: ['autodocs'],
  parameters: {
    layout: 'padded',
  },
} satisfies Meta<MapFilterProps>;

export default config;

type MapFilterStory = StoryObj<typeof config>;

export const Default: MapFilterStory = {
  render: () => {
    const [open, setOpen] = useState(false);
    const [selected, setSelected] = useState<string[]>(['cafes', 'sport']);
    const allSelected = selected.length === allIds.length;

    return (
      <MapFilter
        open={open}
        onOpenChange={setOpen}
        allSelected={allSelected}
        onAllSelectedChange={(value) => setSelected(value ? allIds : [])}
        selectedCount={selected.length}
        onConfirm={() => setOpen(false)}
      >
        <MapFilterCategory
          name='Veranstaltungen'
          categories={veranstaltungen}
          selectedIds={selected}
          onSelectionChange={setSelected}
        />
        <MapFilterCategory
          name='Orte'
          categories={orte}
          selectedIds={selected}
          onSelectionChange={setSelected}
        />
      </MapFilter>
    );
  },
};
