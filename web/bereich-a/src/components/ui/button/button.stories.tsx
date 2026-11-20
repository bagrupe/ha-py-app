import {type Meta, type StoryObj} from '@storybook/react';
import {type ButtonProps, Button} from './button';

const config = {
  title: 'Common/Button',
  component: Button,
  tags: ['autodocs'],
  args: {
    children: 'Click me!',
  },
} satisfies Meta<ButtonProps>;

export default config;

type ButtonStory = StoryObj<typeof config>;
export const ButtonStory: ButtonStory = {name: 'Button'};
export const DisabledButton: ButtonStory = {args: {disabled: true}};
export const LoadingButton: ButtonStory = {
  args: {submittingState: true},
};
export const SolidButton: ButtonStory = {args: {variant: 'solid'}};
