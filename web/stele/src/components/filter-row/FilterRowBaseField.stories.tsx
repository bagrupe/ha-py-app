import {type Meta, type StoryObj} from '@storybook/react-vite';
import {IoChevronDown} from 'react-icons/io5';
import FilterRowBaseField from './FilterRowBaseField';

const meta = {
  title: 'FilterRow/FilterRowBaseField',
  component: FilterRowBaseField,
  parameters: {layout: 'centered'},
  decorators: [
    (Story) => (
      <div className='w-[min(100vw-2rem,320px)]'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof FilterRowBaseField>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    title: 'Feld',
    children: (
      <input
        type='text'
        placeholder='Eingabe…'
        className='size-full min-w-0 bg-transparent text-base outline-none'
        aria-label='Beispiel'
      />
    ),
  },
};

export const WithoutTitle: Story = {
  args: {
    title: '',
    children: (
      <input
        type='text'
        placeholder='Ohne Legende'
        className='size-full min-w-0 bg-transparent text-base outline-none'
        aria-label='Ohne Titel'
      />
    ),
  },
};

export const WithTriggerIcon: Story = {
  args: {
    title: 'Datum',
    triggerIcon: <IoChevronDown />,
    children: (
      <input
        type='text'
        readOnly
        value='13.05.2026'
        className='size-full min-w-0 cursor-default bg-transparent pr-2 text-base outline-none'
        aria-label='Datum (Beispiel)'
      />
    ),
  },
};
