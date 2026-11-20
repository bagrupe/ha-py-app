/** @type {import('prettier').Config} */
module.exports = {
  singleQuote: true,
  jsxSingleQuote: true,
  trailingComma: 'all',
  arrowParens: 'always',
  bracketSpacing: false,
  endOfLine: 'lf',
  embeddedLanguageFormatting: 'auto',
  overrides: [
    {
      files: ['*.md', '*.yml', '*.yaml'],
      options: {
        tabWidth: 4,
      },
    },
  ],
};
