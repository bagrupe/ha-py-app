import {type Meta, type StoryObj} from '@storybook/react';
import {type FC, useState} from 'react';
import {CheckboxField, type CheckboxFieldProps} from './checkbox-field.tsx';

const InteractivityWrapper: FC<CheckboxFieldProps> = (props) => {
  const [checked, setChecked] = useState(false);

  return (
    <CheckboxField
      {...props}
      value={checked}
      onChange={(e) => setChecked(e.target.checked)}
    />
  );
};

const config = {
  title: 'Fields/CheckboxField',
  component: CheckboxField,
  args: {
    label: 'Checkbox',
    value: true,
  },
} satisfies Meta<CheckboxFieldProps>;

export default config;

export const CheckboxFieldStory: StoryObj<typeof config> = {
  name: 'CheckboxField',
  render: (props) => <InteractivityWrapper {...props} />,
};
