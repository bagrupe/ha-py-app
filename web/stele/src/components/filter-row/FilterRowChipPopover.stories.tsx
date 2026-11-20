import {type Meta, type StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {MdOutlineLocationOn} from 'react-icons/md';
import FilterRowChipPopover from './FilterRowChipPopover';

const gemeinden = [
  {id: 'hameln', label: 'Hameln'},
  {id: 'bad-pyrmont', label: 'Bad Pyrmont'},
  {id: 'aerzen', label: 'Aerzen'},
  {id: 'coppenbruegge', label: 'Coppenbrügge'},
  {id: 'emmerthal', label: 'Emmerthal'},
];

const meta = {
  title: 'FilterRow/FilterRowChipPopover',
  component: FilterRowChipPopover,
  parameters: {layout: 'centered'},
  args: {
    placeholder: 'Alle Gemeinden',
    items: gemeinden,
    selectedIds: [],
    onSelectedIdsChange: () => {},
  },
  decorators: [
    (Story) => (
      <div className='w-[min(100vw-2rem,320px)]'>
        <Story />
      </div>
    ),
  ],
} satisfies Meta<typeof FilterRowChipPopover>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  render: function DefaultRender() {
    const [selectedIds, setSelectedIds] = useState<string[]>([]);

    return (
      <FilterRowChipPopover
        id='story-gemeinde-default'
        title='Gemeinde'
        triggerIcon={<MdOutlineLocationOn />}
        placeholder='Alle Gemeinden'
        panelTitle='Gemeinde auswählen'
        items={gemeinden}
        selectedIds={selectedIds}
        onSelectedIdsChange={setSelectedIds}
      />
    );
  },
};

export const WithPreselection: Story = {
  render: function WithPreselectionRender() {
    const [selectedIds, setSelectedIds] = useState<string[]>([
      'hameln',
      'bad-pyrmont',
    ]);

    return (
      <FilterRowChipPopover
        id='story-gemeinde-preselected'
        title='Gemeinde'
        triggerIcon={<MdOutlineLocationOn />}
        placeholder='Alle Gemeinden'
        panelTitle='Gemeinde auswählen'
        items={gemeinden}
        selectedIds={selectedIds}
        onSelectedIdsChange={setSelectedIds}
      />
    );
  },
};
