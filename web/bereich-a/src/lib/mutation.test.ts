import {describe, expect, it} from 'vitest';
import {mutationFailed, shouldToastMutationError} from './mutation.ts';

describe('mutationFailed', () => {
  it('accepts a mutation result with data and no transport error', () => {
    expect(mutationFailed({data: {saved: true}})).toBe(false);
  });

  it.each([{data: undefined}, {data: null}, {data: {saved: true}, error: {}}])(
    'rejects an unusable mutation result %#',
    (result) => {
      expect(mutationFailed(result as never)).toBe(true);
    },
  );
});

describe('shouldToastMutationError', () => {
  it('handles generic GraphQL and network failures for mutations', () => {
    expect(
      shouldToastMutationError({graphQLErrors: []}, {kind: 'mutation'}),
    ).toBe(true);
    expect(
      shouldToastMutationError(
        {graphQLErrors: [{message: 'Interner Fehler'} as never]},
        {kind: 'mutation'},
      ),
    ).toBe(true);
  });

  it('skips unauthenticated errors and non-mutation operations', () => {
    expect(
      shouldToastMutationError(
        {graphQLErrors: [{message: 'Unauthenticated'} as never]},
        {kind: 'mutation'},
      ),
    ).toBe(false);
    expect(shouldToastMutationError({graphQLErrors: []}, {kind: 'query'})).toBe(
      false,
    );
  });
});
