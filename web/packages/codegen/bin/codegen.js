#!/usr/bin/env node
import {delimiter, dirname, join} from 'node:path';
import {createRequire} from 'node:module';
import {fileURLToPath} from 'node:url';
import Module from 'node:module';

const require = createRequire(import.meta.url);
const currentDir = dirname(fileURLToPath(import.meta.url));
const packageDir = dirname(currentDir);
const cliPackagePath = require.resolve('@graphql-codegen/cli/package.json');
const cliPackageDir = dirname(cliPackagePath);
const codegenNodeModules = join(packageDir, 'node_modules');

process.env.NODE_PATH = [codegenNodeModules, process.env.NODE_PATH]
  .filter(Boolean)
  .join(delimiter);
Module._initPaths();

const {runCli} = require(join(cliPackageDir, 'cjs/cli.js'));
const {cliError} = require(join(cliPackageDir, 'cjs/utils/cli-error.js'));

const [, , cmd] = process.argv;

runCli(cmd)
  .then((returnCode) => {
    process.exit(returnCode);
  })
  .catch((error) => {
    cliError(error);
  });
