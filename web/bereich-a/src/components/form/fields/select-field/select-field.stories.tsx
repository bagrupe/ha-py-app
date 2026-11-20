import {type Meta, type StoryObj} from '@storybook/react';
import {action} from 'storybook/actions';
import {SelectField, type SelectFieldProps} from './select-field';

const config = {
  title: 'Common/Fields/SelectField',
  component: SelectField,
  args: {
    items: [{value: 'Value', key: 'key', name: 'Value'}],
    value: undefined,
    onChange: action('New Value Selected!'),
  },
} satisfies Meta<SelectFieldProps<string>>;
export default config;

export const SelectFieldStory: StoryObj<typeof config> = {
  name: 'SelectField',
};
