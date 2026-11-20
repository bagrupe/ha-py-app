import type {Meta, StoryObj} from '@storybook/react-vite';

import {RibbonBadge} from './ribbon-badge';

const meta = {
  title: 'Badges/RibbonBadge',
  component: RibbonBadge,
  parameters: {layout: 'centered'},
} satisfies Meta<typeof RibbonBadge>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {label: 'Veranstalter'},
};
