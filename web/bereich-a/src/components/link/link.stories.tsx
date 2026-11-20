import {type Meta, type StoryObj} from '@storybook/react';
import {Link, type LinkProps} from './link.tsx';

const config = {
  title: 'Common/Link',
  component: Link,
  args: {
    children: 'I am a link',
    to: '/there',
  },
} satisfies Meta<LinkProps>;

export default config;

export const LinkStory: StoryObj<typeof config> = {
  name: 'Link',
};

export const ActiveLink: StoryObj<typeof config> = {
  name: 'Active Link',
  args: {
    to: '/here',
  },
  parameters: {
    router: {initialEntries: ['/here']},
  },
};
