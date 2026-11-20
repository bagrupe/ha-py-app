import {readFile, writeFile} from 'node:fs/promises';
import type {CodegenConfig} from '@graphql-codegen/cli';
import {format, resolveConfig} from 'prettier';

const formatFile = async (path: string) => {
  const content = await readFile(path, 'utf-8');
  const parser = path.endsWith('.graphql') ? 'graphql' : 'typescript';
  const config = await resolveConfig(path);
  const formatted = await format(content, {...config, parser});
  await writeFile(path, formatted, 'utf-8');
};

export interface CreateCodegenConfigOptions {
  schema: string;
  srcDir: string;
}

export const createCodegenConfig = ({
  schema,
  srcDir,
}: CreateCodegenConfigOptions): CodegenConfig => ({
  overwrite: true,
  schema,
  documents: `${srcDir}/**/*.graphql`,
  hooks: {
    afterOneFileWrite: async (path: string) => {
      await formatFile(path);
    },
  },
  generates: {
    [`${srcDir}/__generated__/graphql.ts`]: {
      plugins: ['@atmina/only-enum-types'],
    },
    [`${srcDir}/__generated__/introspection.ts`]: {
      plugins: ['urql-introspection'],
      config: {includeScalars: true},
    },
    [`${srcDir}/`]: {
      preset: 'near-operation-file',
      presetConfig: {
        extension: '.generated.ts',
        baseTypesPath: '__generated__/graphql.ts',
      },
      plugins: [
        '@atmina/local-typescript-operations',
        'typescript-urql',
        {
          add: {
            content:
              'import {\n' +
              '  BoolExpression,\n' +
              '  IntExpression,\n' +
              '  StringExpression,\n' +
              "} from '@kommunalapp/expressions';\n",
          },
        },
      ],
      config: {
        scalars: {
          UUID: 'string',
          Decimal: 'number',
          Instant: 'Date',
          LocalDate: 'string',
          DateTime: 'Date',
          JSON: 'unknown',
          BoolExpression: 'BoolExpression',
          IntExpression: 'IntExpression',
          StringExpression: 'StringExpression',
        },
        strictScalars: true,
        inlineFragmentTypes: 'combine',
      },
    },
  },
});
