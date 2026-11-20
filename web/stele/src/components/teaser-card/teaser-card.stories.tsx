import type {Meta, StoryObj} from '@storybook/react-vite';

import {TeaserCard, type TeaserCardProps} from './teaser-card';

const config = {
  title: 'Components/TeaserCard',
  component: TeaserCard,
  tags: ['autodocs'],
  parameters: {
    layout: 'fullscreen',
  },
} satisfies Meta<TeaserCardProps>;

export default config;

type TeaserCardStory = StoryObj<typeof config>;

export const Default: TeaserCardStory = {
  name: 'Karte entdecken',
};

export const CustomCopy: TeaserCardStory = {
  args: {
    heading: 'Sehenswürdigkeiten in der Nähe',
    body: 'Stöbern Sie durch ausgewählte Highlights aus Kultur, Natur und Freizeit – direkt vor Ihrer Haustür.',
    ctaLabel: 'Karte öffnen',
  },
};

export const NaturBackground: TeaserCardStory = {
  name: 'Natur Hintergrund',
  args: {
    heading: 'Natur erleben',
    body: 'Wandern, Radfahren und entspannen in den schönsten Landschaften der Region.',
    backgroundImage: 'https://picsum.photos/seed/forest/1200/600',
  },
};

export const StadtBackground: TeaserCardStory = {
  name: 'Stadt Hintergrund',
  args: {
    heading: 'Die Stadt entdecken',
    body: 'Historische Altstadt, Märkte und kulturelle Highlights warten auf Sie.',
    backgroundImage: 'https://picsum.photos/seed/town/1200/600',
  },
};
