import {type Meta, type StoryObj} from '@storybook/react';

import {
  type PasswordInputFieldProps,
  PasswordInputField,
} from './password-input-field.tsx';

const config = {
  title: 'Common/Fields/PasswordInputField',
  component: PasswordInputField,
} satisfies Meta<PasswordInputFieldProps>;
export default config;

export const PasswordInputFieldStory: StoryObj<typeof config> = {
  name: 'PasswordInputField',
};
