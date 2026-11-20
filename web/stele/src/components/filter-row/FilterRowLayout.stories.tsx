import {type Meta, type StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {IoChevronDown} from 'react-icons/io5';
import FilterRowDatePicker from './FilterRowDatePicker';
import {FilterRowLayout} from './FilterRowLayout';
import FilterRowSelect from './FilterRowSelect';
import FilterRowToggleGroup from './FilterRowToggleGroup';
import {useFilterRowDateSelection} from './useFilterRowDateSelection';

const meta = {
  title: 'FilterRow/FilterRowLayout',
  component: FilterRowLayout,
  parameters: {layout: 'padded'},
  argTypes: {
    children: {control: false},
  },
  args: {
    children: null,
  },
  decorators: [
    (Story) => (
      <div className='w-full max-w-4xl'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof FilterRowLayout>;

export default meta;

type Story = StoryObj<typeof meta>;

function PlaceholderSlot({label}: {label: string}) {
  return (
    <div
      aria-hidden
      className='flex h-11 min-w-[120px] flex-1 items-center justify-center rounded-md border border-dashed border-gray-400 bg-gray-50 text-sm text-gray-600'
    >
      {label}
    </div>
  );
}

export const WithPlaceholderSlots: Story = {
  render: () => (
    <FilterRowLayout>
      <PlaceholderSlot label='Slot 1' />
      <PlaceholderSlot label='Slot 2' />
      <PlaceholderSlot label='Slot 3' />
    </FilterRowLayout>
  ),
};

export const WithFilterControls: Story = {
  render: function WithFilterControlsRender() {
    const {selectedDay, setSelectedDay} = useFilterRowDateSelection();
    const [selectedCategory, setSelectedCategory] = useState<string | null>(
      null,
    );

    const categories = [
      {label: 'Kategorie 1', value: 'category1'},
      {label: 'Kategorie 2', value: 'category2'},
      {label: 'Kategorie 3', value: 'category3'},
    ];

    return (
      <FilterRowLayout>
        <FilterRowToggleGroup
          value={selectedDay}
          onValueChange={setSelectedDay}
        />
        <FilterRowSelect
          items={categories}
          title='Kategorie auswählen'
          id='story-layout-category'
          triggerIcon={<IoChevronDown />}
          value={selectedCategory ?? ''}
          onChange={(event) => {
            const {value} = event.target;
            setSelectedCategory(value === '' ? null : value);
          }}
        />
        <FilterRowDatePicker
          title='Zeitpunkt auswählen'
          id='story-layout-date'
          value={selectedDay}
          onValueChange={setSelectedDay}
        />
      </FilterRowLayout>
    );
  },
};

export const WithCustomStyling: Story = {
  render: () => (
    <FilterRowLayout className='rounded-lg border border-gray-200 bg-gray-50 p-4'>
      <PlaceholderSlot label='Slot 1' />
      <PlaceholderSlot label='Slot 2' />
    </FilterRowLayout>
  ),
};
