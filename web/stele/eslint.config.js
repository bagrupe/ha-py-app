// For more info, see https://github.com/storybookjs/eslint-plugin-storybook#configuration-flat-config-format

import react from '@kommunal/linting/eslint/react';
import recommended from '@kommunal/linting/eslint/recommended';
import tailwind from '@kommunal/linting/eslint/tailwind';
import storybook from 'eslint-plugin-storybook';

const config = [
  ...recommended,
  tailwind,
  react,
  {
    files: ['**/*.{ts,tsx}'],
    rules: {
      '@typescript-eslint/no-unused-vars': [
        'warn',
        {
          argsIgnorePattern: '^_',
          ignoreRestSiblings: true,
        },
      ],
    },
  },
  ...storybook.configs['flat/recommended'],
];

export default config;
