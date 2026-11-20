import {type Meta, type StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {MdOutlineCalendarMonth} from 'react-icons/md';
import {toDayTokenIso} from '../../utils/timeUtils';
import FilterRowDatePicker from './FilterRowDatePicker';

const meta = {
  title: 'FilterRow/FilterRowDatePicker',
  component: FilterRowDatePicker,
  parameters: {layout: 'centered'},
  decorators: [
    (Story) => (
      <div className='w-[min(100vw-2rem,320px)]'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof FilterRowDatePicker>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    title: 'Datum',
    id: 'story-date-default',
  },
};

export const WithDefaultValue: Story = {
  args: {
    title: 'Datum',
    id: 'story-date-value',
    defaultValue: toDayTokenIso(new Date(2026, 4, 13)),
  },
};

export const WithTriggerIcon: Story = {
  args: {
    title: 'Datum',
    id: 'story-date-value',
    defaultValue: toDayTokenIso(new Date(2026, 4, 13)),
    triggerIcon: <MdOutlineCalendarMonth />,
  },
};

export const TracksValue: Story = {
  render: function TracksValueRender() {
    const [value, setValue] = useState(() =>
      toDayTokenIso(new Date(2026, 4, 13)),
    );

    return (
      <div className='flex flex-col items-stretch gap-4'>
        <FilterRowDatePicker
          title='Datum'
          id='story-date-controlled'
          value={value}
          onValueChange={setValue}
        />
        <p className='text-sm text-neutral-600'>
          Aktueller Wert:{' '}
          <span className='font-medium text-neutral-900'>{value || '—'}</span>
        </p>
      </div>
    );
  },
};
