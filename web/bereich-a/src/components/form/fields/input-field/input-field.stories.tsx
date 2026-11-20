import {type Meta, type StoryObj} from '@storybook/react';
import {InputField, type InputFieldProps} from './input-field.tsx';

const config = {
  title: 'Common/Fields/InputField',
  component: InputField,
  args: {
    label: 'Label',
  },
  tags: ['autodocs'],
} satisfies Meta<InputFieldProps>;

export default config;

export const InputFieldStory: StoryObj<typeof config> = {
  name: 'Input Field',
  args: {placeholder: 'Placeholder'},
};

export const FilledInputField: StoryObj<typeof config> = {
  args: {value: 'Test'},
};
export const FilledInputFieldWithoutLabel: StoryObj<typeof config> = {
  args: {value: 'Test', label: ''},
};

export const LongLabelInputField: StoryObj<typeof config> = {
  args: {value: 'Test', label: 'UmsatzsteuerIdNr'},
};

export const OverflowingLongLabelInputField: StoryObj<typeof config> = {
  args: {
    label:
      'This is a very long label that will overflow even the shrunken state',
    className: 'w-72',
  },
};

export const DisabledInputField: StoryObj<typeof config> = {
  args: {disabled: true},
};
export const InvalidInputField: StoryObj<typeof config> = {
  args: {error: 'Ich bin kaputt'},
};

export const StartAdornedInputField: StoryObj<typeof config> = {
  args: {startAdornment: 'https://'},
};

export const EndAdornedInputField: StoryObj<typeof config> = {
  args: {endAdornment: '€'},
};
export const OverflowingEndAdornedInputField: StoryObj<typeof config> = {
  args: {
    className: 'w-72',
    value:
      'Some super long text that is guaranteed to overflow the short field',
    ...EndAdornedInputField.args,
  },
};
