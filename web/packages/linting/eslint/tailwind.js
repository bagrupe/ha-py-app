import tailwindPlugin from 'eslint-plugin-tailwindcss';

const {recommended} = tailwindPlugin.configs;

export default {
  files: ['**/*.tsx', '**/*.jsx'],
  plugins: {tailwindcss: tailwindPlugin},
  settings: {
    tailwindcss: {
      callees: ['classNames', 'clsx', 'cn', 'ctl', 'twMerge'],
    },
  },
  languageOptions: {
    parserOptions: recommended.parserOptions,
  },
  rules: {
    ...recommended.rules,
    'tailwindcss/no-custom-classname': 'off',
  },
};
