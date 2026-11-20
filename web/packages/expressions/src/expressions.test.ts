import {describe, expect, it} from 'vitest';
import {BoolExpression, IntExpression, StringExpression} from './index.ts';

describe('expression evaluation', () => {
  it('evaluates a literal BoolExpression', () => {
    expect(new BoolExpression('true').evaluate({})).toBe(true);
  });

  it('evaluates an IntExpression with arithmetic', () => {
    expect(new IntExpression('1 + 2').evaluate({})).toBe(3);
  });

  it('evaluates a StringExpression slot lookup', () => {
    expect(new StringExpression('slot("name")').evaluate({name: 'world'})).toBe(
      'world',
    );
  });
});
