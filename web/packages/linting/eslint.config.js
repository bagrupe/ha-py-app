import recommended from './eslint/recommended.js';

export default [
  ...recommended,
  {
    languageOptions: {
      parserOptions: {
        project: null,
      },
    },
  },
];
