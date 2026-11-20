import type {Meta, StoryObj} from '@storybook/react-vite';
import {useState} from 'react';
import {Toggle, type ToggleProps} from './toggle';

const config = {
  title: 'Components/Toggle',
  component: Toggle,
  tags: ['autodocs'],
  args: {
    label: 'Alle auswählen',
  },
  render: (args) => {
    const Controlled = () => {
      const [checked, setChecked] = useState(false);
      return (
        <Toggle {...args} checked={checked} onCheckedChange={setChecked} />
      );
    };
    return <Controlled />;
  },
} satisfies Meta<ToggleProps>;

export default config;

type ToggleStory = StoryObj<typeof config>;

export const Default: ToggleStory = {name: 'Toggle'};
