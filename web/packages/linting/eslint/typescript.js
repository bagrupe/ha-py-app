import importPlugin from 'eslint-plugin-import';
import tseslint from 'typescript-eslint';

const importTsConfig = importPlugin.configs.typescript ?? {};

export default tseslint.config({
  files: ['**/*.{ts,tsx}'],
  extends: [tseslint.configs.recommended],
  languageOptions: {
    parserOptions: {
      sourceType: 'module',
      project: ['./**/tsconfig.json', './**/tsconfig.*.json'],
    },
  },
  settings: {
    ...importTsConfig.settings,
    'import/resolver': {
      ...(importTsConfig.settings?.['import/resolver'] ?? {}),
      typescript: true,
    },
  },
  rules: {
    ...(importTsConfig.rules ?? {}),
    '@typescript-eslint/consistent-type-exports': 'warn',
    '@typescript-eslint/consistent-type-imports': [
      'warn',
      {prefer: 'type-imports', fixStyle: 'inline-type-imports'},
    ],
    '@typescript-eslint/ban-ts-comment': [
      'error',
      {
        'ts-expect-error': 'allow-with-description',
        'ts-ignore': 'allow-with-description',
        minimumDescriptionLength: 10,
      },
    ],
    '@typescript-eslint/no-unused-vars': ['warn', {ignoreRestSiblings: true}],
  },
});
