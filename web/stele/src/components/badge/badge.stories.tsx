import type {Meta, StoryObj} from '@storybook/react-vite';
import {CiLocationOn} from 'react-icons/ci';
import {Badge, type BadgeProps} from './badge';

const config = {
  title: 'Components/Badge',
  component: Badge,
  tags: ['autodocs'],
  args: {
    label: 'Label',
  },
} satisfies Meta<BadgeProps>;

export default config;

type BadgeStory = StoryObj<typeof config>;

export const Default: BadgeStory = {name: 'Badge'};

export const WithIcon: BadgeStory = {
  args: {icon: CiLocationOn},
};

export const Highlighted: BadgeStory = {
  args: {icon: CiLocationOn, highlight: true},
};

export const Colorized: BadgeStory = {
  args: {icon: CiLocationOn, colorized: true},
};

export const HighlightedColorized: BadgeStory = {
  name: 'Highlighted + Colorized',
  args: {icon: CiLocationOn, highlight: true, colorized: true},
};
