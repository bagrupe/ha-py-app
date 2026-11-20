import {type Meta, type StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {IoChevronDown} from 'react-icons/io5';
import FilterRowNativeSelect from './FilterRowSelect';

const sampleItems = [
  {label: 'Heute', value: 'today'},
  {label: 'Morgen', value: 'tomorrow'},
  {label: 'Diese Woche', value: 'week'},
] as const;

const meta = {
  title: 'FilterRow/FilterRowSelect',
  component: FilterRowNativeSelect,
  parameters: {layout: 'centered'},
  decorators: [
    (Story) => (
      <div className='w-[min(100vw-2rem,320px)]'>
        <Story />
      </div>
    ),
  ],
  args: {
    items: [...sampleItems],
    id: 'story-select',
  },
} satisfies Meta<typeof FilterRowNativeSelect>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    title: 'Zeitraum',
  },
};

export const WithTriggerIcon: Story = {
  args: {
    title: 'Zeitraum',
    triggerIcon: <IoChevronDown className='size-5' aria-hidden />,
  },
};

export const WithDefaultValue: Story = {
  args: {
    title: 'Zeitraum',
    defaultValue: 'tomorrow',
  },
};

export const TracksSelection: Story = {
  render: function TracksSelectionRender() {
    const [value, setValue] = useState('today');

    return (
      <div className='flex flex-col items-stretch gap-4'>
        <FilterRowNativeSelect
          title='Zeitraum'
          id='story-select-controlled'
          items={[...sampleItems]}
          value={value}
          onChange={(e) => setValue(e.target.value)}
        />
        <p className='text-sm text-neutral-600'>
          Auswahl:{' '}
          <span className='font-medium text-neutral-900'>
            {value || '— (leer)'}
          </span>
        </p>
      </div>
    );
  },
};
