export default {
  extends: ['@commitlint/config-conventional'],
  plugins: [
    {
      rules: {
        'gitlab-changelog-trailer': (parsed) => {
          // Extract notes that match the "Changelog" keyword
          const changelogNotes = parsed.notes.filter(note => note.title === 'Changelog');

          if (changelogNotes.length === 0) {
            return [false, 'Commit must have a Changelog trailer (e.g., "Changelog: added"). Ensure it is placed at the end of the commit message preceded by a blank line.'];
          }

          // GitLab's official default trailer values
          const validTypes = [
            'added',
            'fixed',
            'changed',
            'deprecated',
            'removed',
            'security',
            'performance',
            'documentation',
            'dependencies',
            'other',
          ];
          const type = changelogNotes[0].text;

          if (!validTypes.includes(type)) {
            return [false, `Changelog trailer value "${type}" is invalid. Must be one of: ${validTypes.join(', ')}`];
          }

          return [true];
        }
      }
    }
  ],
  rules: {
    'type-enum': [2, 'always', ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'build', 'ci', 'chore', 'revert']],
    'scope-enum': [2, 'always', ['app', 'backend', 'bereich-a', 'bereich-b', 'stele', 'shared', 'infrastructure', 'monitoring']],
    'scope-empty': [2, 'never'],
    'header-max-length': [2, 'always', 100],
    'footer-leading-blank': [2, 'always'],
    'gitlab-changelog-trailer': [2, 'always'], // Enforce our custom GitLab rule
  },
  parserPreset: {
    parserOpts: {
      noteKeywords: ['Changelog', 'Details'],
    },
  },
  prompt: {
    settings: {},
    messages: {
      skip: 'can be skipped',
      empty: 'cannot be empty',
      mustSelect: 'must select one from the list',
    },
    questions: {
      type: {
        description: "Select the type of change that you're committing:",
        enum: {
          feat: { description: 'A new feature', title: 'Features' },
          fix: { description: 'A bug fix', title: 'Bug Fixes' },
          docs: { description: 'Documentation only changes', title: 'Documentation' },
          style: { description: 'Changes that do not affect the meaning of the code', title: 'Styles' },
          refactor: { description: 'A code change that neither fixes a bug nor adds a feature', title: 'Code Refactoring' },
          perf: { description: 'A code change that improves performance', title: 'Performance Improvements' },
          test: { description: 'Adding missing tests or correcting existing tests', title: 'Tests' },
          build: { description: 'Changes that affect the build system or external dependencies', title: 'Builds' },
          ci: { description: 'Changes to our CI configuration files and scripts', title: 'Continuous Integrations' },
          chore: { description: "Other changes that don't modify src or test files", title: 'Chores' },
          revert: { description: 'Reverts a previous commit', title: 'Reverts' },
        },
      },
      scope: {
        description: 'What is the scope of this change (e.g. component or file name):',
        enum: {
          app: { description: 'Frontend / Mobile app specific' },
          backend: { description: 'Dotnet' },
          'bereich-a': { description: 'Backoffice' },
          'bereich-b': { description: 'Payload CMS' },
          stele: { description: 'Stele app' },
          shared: { description: 'If more than one area is modified' },
          infrastructure: { description: 'Docker/scripts/workflows' },
          monitoring: { description: 'Grafana / Prometheus monitoring stack' },
        },
      },
      subject: {
        description: 'Write a short, imperative tense description of the change:',
      },
      isBreaking: {
        description: 'Are there any breaking changes?',
      },
    },
  },
};
