import {type Meta, type StoryObj} from '@storybook/react';
import {graphql, HttpResponse} from 'msw';
import {DesktopNavigation} from './desktop-navigation.tsx';

const config = {
  title: 'Common/DesktopNavigation',
  component: DesktopNavigation,
} satisfies Meta<typeof DesktopNavigation>;

export default config;

export const DesktopNavigationStory: StoryObj<typeof config> = {
  name: 'Desktop Navigation',
  parameters: {
    msw: {
      handlers: [
        graphql.query('Ausfuehrungen', () =>
          HttpResponse.json({
            data: {
              my: {
                __typename: 'Sachbearbeiter',
                kommune: {
                  ausfuehrungen: [{}, {}, {}],
                },
              },
            },
          }),
        ),
      ],
    },
  },
};
