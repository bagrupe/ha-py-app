import react from '@kommunal/linting/eslint/react';
import recommended from '@kommunal/linting/eslint/recommended';
import tailwind from '@kommunal/linting/eslint/tailwind';

const config = [
  {
    ignores: ['vitest.config.ts'],
  },
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
];

export default config;
