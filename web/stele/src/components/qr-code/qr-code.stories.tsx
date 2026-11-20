import type {Meta, StoryObj} from '@storybook/react-vite';

import {QrCode} from './qr-code';

const config = {
  title: 'Components/QrCode',
  component: QrCode,
  tags: ['autodocs'],
  parameters: {layout: 'centered'},
  args: {
    value: 'https://hameln-pyrmont.de/aktuelles/example-artikel',
  },
} satisfies Meta<typeof QrCode>;

export default config;

type Story = StoryObj<typeof config>;

export const Default: Story = {name: 'QrCode'};

export const WithLabel: Story = {
  args: {label: 'Mehr Informationen'},
};

export const Larger: Story = {
  args: {label: 'Mehr Informationen', size: 96},
};

export const WithRemoteSvg: Story = {
  args: {
    value: undefined,
    src: '/api/aufrufe/demo/qr.svg',
    label: 'Mehr Informationen',
  },
};
