// Global ignores. https://eslint.org/docs/latest/use/configure/configuration-files#globally-ignoring-files-with-ignores
export default {
  ignores: [
    '**/build/*',
    '**/dist/*',
    '**/dist-*/*',
    '**/release/*',
    '**/storybook-static/*',
    '**/out/*',
    '**/.cache/*',
    '**/.next/*',
    '**/.vite/*',
    '**/*.generated*',
    '**/__generated__/*',
  ],
};
