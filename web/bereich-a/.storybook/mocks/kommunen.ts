import {type Kommune} from '../../src/lib/context/kommune/kommune.generated.ts';

export const mockedKommunenItems = ['Landkreis Hameln-Pyrmont'] as const;

export const mockedKommunen: Record<
  (typeof mockedKommunenItems)[number],
  Kommune
> = {
  'Landkreis Hameln-Pyrmont': {
    id: '5a1aefef-809f-403d-a14c-27051353c7d4',
    name: 'Landkreis Hameln-Pyrmont',
    design: {
      colors: {
        primary: '#74A220',
        primaryLight: '#DAEFA7',
      },
      logo: {
        url: 'https://www.hameln-pyrmont.de/layout/hameln-pyrmont/media/logo_landkreis-hameln-pyrmont.png',
      },
    },
  },
};
