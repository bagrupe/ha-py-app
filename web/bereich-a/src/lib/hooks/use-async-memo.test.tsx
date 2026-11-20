/** @vitest-environment jsdom */
import {renderHook, waitFor} from '@testing-library/react';
import {describe, expect, it} from 'vitest';
import {useAsyncMemo, useAsyncMemoAndResetOnChange} from './use-async-memo.ts';

describe('async memo hooks', () => {
  it('exposes a resolved value', async () => {
    const {result} = renderHook(() =>
      useAsyncMemo(async () => 'entschlüsselt', []),
    );

    await waitFor(() => expect(result.current.value).toBe('entschlüsselt'));
    expect(result.current.error).toBeUndefined();
  });

  it('exposes rejected promises without an unhandled rejection', async () => {
    const failure = new Error('kaputt');
    const {result} = renderHook(() =>
      useAsyncMemo(async () => Promise.reject(failure), []),
    );

    await waitFor(() => expect(result.current.error).toBe(failure));
    expect(result.current.value).toBeUndefined();
  });

  it('exposes synchronous factory errors in the reset variant', async () => {
    const failure = new Error('kaputt');
    const {result} = renderHook(() =>
      useAsyncMemoAndResetOnChange(() => {
        throw failure;
      }, []),
    );

    await waitFor(() => expect(result.current.error).toBe(failure));
    expect(result.current.value).toBeUndefined();
  });
});
