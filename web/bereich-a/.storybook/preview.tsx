import type {Preview} from '@storybook/react';
import {initialize, mswLoader} from 'msw-storybook-addon';
import {MemoryRouter} from 'react-router';

// TODO: define per-story request handlers via parameters.msw.handlers when API mocking is needed
// See: https://mswjs.io/docs/http/intercepting-requests
initialize({onUnhandledRequest: 'bypass'});

import '../src/index.css';
import {AuthProvider} from '../src/lib/context/auth/auth.tsx';
import {KommuneProvider} from '../src/lib/context/kommune/kommune.tsx';
import {UrqlProvider} from '../src/urql.tsx';
import {mockedKommunen, mockedKommunenItems} from './mocks/kommunen.ts';

const preview: Preview = {
  decorators: [
    (Story, context) => {
      const initialEntries = context.parameters?.router?.initialEntries ?? [
        '/',
      ];
      return (
        <MemoryRouter initialEntries={initialEntries}>
          <Story />
        </MemoryRouter>
      );
    },
    (Story, {globals}) => (
      <AuthProvider broadcastTimeout={0}>
        <UrqlProvider>
          <KommuneProvider
            kommune={
              mockedKommunen[
                (globals.kommune as keyof typeof mockedKommunen) ??
                  'Landkreis Hameln-Pyrmont'
              ]
            }
          >
            <Story />
          </KommuneProvider>
        </UrqlProvider>
      </AuthProvider>
    ),
  ],
  loaders: [mswLoader],
  parameters: {
    actions: {argTypesRegex: '^on[A-Z].*'},
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/,
      },
    },
  },
  globalTypes: {
    kommune: {
      type: 'string',
      toolbar: {
        title: 'Kommune',
        icon: 'structure',
        items: [...mockedKommunenItems],
      },
    },
  },
};

export default preview;
