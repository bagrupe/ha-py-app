import {type Meta, type StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {toDayTokenIso} from '../../utils/timeUtils';
import FilterRowToggleGroup, {
  type FilterRowValue,
} from './FilterRowToggleGroup';

const meta = {
  title: 'FilterRow/FilterRowToggleGroup',
  component: FilterRowToggleGroup,
  parameters: {layout: 'centered'},
} satisfies Meta<typeof FilterRowToggleGroup>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {};

const tomorrowIsoValue = (): FilterRowValue => {
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  return toDayTokenIso(tomorrow);
};

export const TomorrowSelectedByDefault: Story = {
  args: {
    defaultValue: tomorrowIsoValue(),
  },
};

export const WithCustomClassName: Story = {
  args: {
    className: 'max-w-xl shadow-sm',
  },
};

export const TracksSelection: Story = {
  render: function TracksSelectionRender() {
    const [last, setLast] = useState<FilterRowValue | null>(() =>
      toDayTokenIso(new Date()),
    );

    return (
      <div className='flex flex-col items-center gap-4'>
        <FilterRowToggleGroup onValueChange={setLast} />
        <p className='text-sm text-neutral-600'>
          Letzte Auswahl:{' '}
          <span className='font-medium text-neutral-900'>
            {last ?? '— (noch nicht gewechselt)'}
          </span>
        </p>
      </div>
    );
  },
};
