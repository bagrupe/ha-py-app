import prettierOverrides from 'eslint-config-prettier';

export default {
  files: ['**/*.{ts,tsx,js,jsx}'],
  rules: {
    ...prettierOverrides.rules,
  },
};
