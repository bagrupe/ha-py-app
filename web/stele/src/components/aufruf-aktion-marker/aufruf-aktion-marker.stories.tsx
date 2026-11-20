import type {Meta, StoryObj} from '@storybook/react-vite';

import {
  AufrufAktionMarker,
  type AufrufAktionMarkerProps,
} from './aufruf-aktion-marker';

const config = {
  title: 'Components/AufrufAktionMarker',
  component: AufrufAktionMarker,
  tags: ['autodocs'],
} satisfies Meta<AufrufAktionMarkerProps>;

export default config;

type AufrufAktionMarkerStory = StoryObj<typeof config>;

export const Default: AufrufAktionMarkerStory = {name: 'Aufruf-Aktion'};

export const CustomLabel: AufrufAktionMarkerStory = {
  args: {label: 'Sonder-Aktion'},
};
