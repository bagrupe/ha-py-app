import type {Meta, StoryObj} from '@storybook/react-vite';
import {Tooltip, TooltipDetailList, type TooltipProps} from './tooltip';

const config = {
  title: 'Components/Tooltip',
  component: Tooltip,
  tags: ['autodocs'],
  argTypes: {
    alignment: {
      control: {type: 'inline-radio'},
      options: ['top', 'bottom', 'left', 'right'],
    },
    variant: {
      control: {type: 'inline-radio'},
      options: ['location', 'poi'],
    },
  },
  decorators: [
    (Story) => (
      <div className='flex min-h-screen w-full items-center justify-center bg-gray-100 p-32'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<TooltipProps>;

export default config;

type TooltipStory = StoryObj<typeof config>;

export const Location: TooltipStory = {
  name: 'Location · Sie sind hier',
  args: {
    variant: 'location',
    alignment: 'top',
    children: 'Sie sind hier',
  },
};

export const LocationTopAlignment: TooltipStory = {
  name: 'Location · alignment top',
  args: {
    variant: 'location',
    alignment: 'top',
    children: 'Sie sind hier',
  },
};

export const LocationLeftAlignment: TooltipStory = {
  name: 'Location · alignment left',
  args: {
    variant: 'location',
    alignment: 'left',
    children: 'Sie sind hier',
  },
};

export const LocationRightAlignment: TooltipStory = {
  name: 'Location · alignment right',
  args: {
    variant: 'location',
    alignment: 'right',
    children: 'Sie sind hier',
  },
};

const poiExampleDetails = (
  <TooltipDetailList
    items={[
      {label: 'Adresse', value: 'Gröninger Straße 15, 31785 Hameln'},
      {
        label: 'Website',
        value:
          'https://www.kitav.de/einrichtungen/kindertagesstaette-st-nicolai/',
      },
      {label: 'Email', value: 'contact-0378f03d@example.com'},
      {label: 'Telefonnr.', value: '030 00000000'},
    ]}
  />
);

export const Poi: TooltipStory = {
  name: 'PoI · Sie sind hier',
  args: {
    variant: 'poi',
    alignment: 'right',
    header: 'Sie sind hier',
    onClose: () => {},
    children: poiExampleDetails,
    closeLabel: '',
  },
};

export const PoiTopAlignment: TooltipStory = {
  name: 'PoI · alignment top',
  args: {
    variant: 'poi',
    alignment: 'top',
    header: 'Sie sind hier',
    onClose: () => {},
    children: poiExampleDetails,
  },
};

export const PoiBottomAlignment: TooltipStory = {
  name: 'PoI · alignment bottom',
  args: {
    variant: 'poi',
    alignment: 'bottom',
    header: 'Sie sind hier',
    onClose: () => {},
    children: poiExampleDetails,
  },
};

export const PoiLeftAlignment: TooltipStory = {
  name: 'PoI · alignment left',
  args: {
    variant: 'poi',
    alignment: 'left',
    header: 'Sie sind hier',
    onClose: () => {},
    children: poiExampleDetails,
  },
};
