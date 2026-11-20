import type {Meta, StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {
  MdDirectionsBike,
  MdLocalCafe,
  MdMusicNote,
  MdRestaurant,
  MdSchool,
  MdSportsBasketball,
} from 'react-icons/md';
import {
  MapFilterCategory,
  type MapFilterCategoryItem,
  type MapFilterCategoryProps,
} from './map-filter-category';

const categories: MapFilterCategoryItem[] = [
  {id: 'gastronomie', label: 'Gastronomie', icon: MdRestaurant},
  {id: 'cafes', label: 'Cafés', icon: MdLocalCafe},
  {id: 'musik', label: 'Musik', icon: MdMusicNote},
  {id: 'sport', label: 'Sport', icon: MdSportsBasketball},
  {id: 'radfahren', label: 'Radfahren', icon: MdDirectionsBike},
  {id: 'bildung', label: 'Bildung', icon: MdSchool},
];

const config = {
  title: 'Components/MapFilterCategory',
  component: MapFilterCategory,
  tags: ['autodocs'],
  parameters: {layout: 'padded'},
  args: {
    name: 'Veranstaltungen',
    categories,
  },
  render: (args) => {
    const Controlled = () => {
      const [selectedIds, setSelectedIds] = useState<string[]>([
        'cafes',
        'sport',
      ]);
      return (
        <MapFilterCategory
          {...args}
          selectedIds={selectedIds}
          onSelectionChange={setSelectedIds}
        />
      );
    };
    return <Controlled />;
  },
} satisfies Meta<MapFilterCategoryProps>;

export default config;

type MapFilterCategoryStory = StoryObj<typeof config>;

export const Default: MapFilterCategoryStory = {name: 'MapFilterCategory'};
