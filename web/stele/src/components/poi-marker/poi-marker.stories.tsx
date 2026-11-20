import type {Meta, StoryObj} from '@storybook/react-vite';

import physiotherapyIcon from '../../assets/Visual/poi-physiotherapy.svg';

import {PoiMarker} from './poi-marker';

const config = {
  title: 'Components/PoiMarker',
  component: PoiMarker,
  tags: ['autodocs'],
  args: {title: 'Physiotherapie'},
} satisfies Meta<typeof PoiMarker>;

export default config;

type PoiMarkerStory = StoryObj<typeof config>;

export const Default: PoiMarkerStory = {};

export const WithIcon: PoiMarkerStory = {
  args: {iconUrl: physiotherapyIcon},
};

export const Selected: PoiMarkerStory = {
  args: {selected: true},
};

export const SelectedWithIcon: PoiMarkerStory = {
  args: {iconUrl: physiotherapyIcon, selected: true},
};
