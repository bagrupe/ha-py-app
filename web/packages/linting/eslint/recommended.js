import base from './base.js';
import ignores from './ignores.js';
import prettier from './prettier.js';
import typescript from './typescript.js';

export default [ignores, base, ...typescript, prettier];
