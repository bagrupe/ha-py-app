import {type DependencyList, useEffect, useState} from 'react';

export type AsyncMemoResult<T> = {
  value: T | undefined;
  error: unknown | undefined;
};

/**
 * React-Hook, der einen asynchronen Wert basierend auf einer Factory-Funktion berechnet und zwischenspeichert.
 * @param factory Funktion, die ein Promise mit dem Wert zurückgibt oder undefined/null.
 * @param deps Abhängigkeiten, bei deren Änderung die Factory erneut ausgeführt wird.
 * @returns Den asynchron geladenen Wert und einen möglichen Fehler.
 */
export function useAsyncMemo<T>(
  factory: () => Promise<T> | undefined | null,
  deps: DependencyList,
): AsyncMemoResult<T> {
  const [val, setVal] = useState<T | undefined>(undefined);
  const [error, setError] = useState<unknown | undefined>(undefined);
  useEffect(() => {
    let cancel = false;
    setError(undefined);
    try {
      const promise = factory();
      if (promise === undefined || promise === null) return;
      promise.then(
        (resolvedVal) => {
          if (!cancel) {
            setVal(resolvedVal);
          }
        },
        (reason: unknown) => {
          if (!cancel) {
            setError(reason);
          }
        },
      );
    } catch (reason) {
      setError(reason);
    }
    return () => {
      cancel = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
  return {value: val, error};
}

/**
 * React-Hook, der einen asynchronen Wert basierend auf einer Factory-Funktion berechnet und bei Änderung der Abhängigkeiten zurücksetzt.
 * @param factory Funktion, die ein Promise mit dem Wert zurückgibt oder undefined/null.
 * @param deps Abhängigkeiten, bei deren Änderung die Factory erneut ausgeführt wird und der Wert auf undefined zurückgesetzt wird.
 * @returns Den asynchron geladenen Wert und einen möglichen Fehler.
 */
export function useAsyncMemoAndResetOnChange<T>(
  factory: () => Promise<T> | undefined | null,
  deps: DependencyList,
): AsyncMemoResult<T> {
  const [val, setVal] = useState<T | undefined>(undefined);
  const [error, setError] = useState<unknown | undefined>(undefined);
  useEffect(() => {
    let cancel = false;
    setVal(undefined);
    setError(undefined);
    try {
      const promise = factory();
      if (promise === undefined || promise === null) return;
      promise.then(
        (resolvedVal) => {
          if (!cancel) {
            setVal(resolvedVal);
          }
        },
        (reason: unknown) => {
          if (!cancel) {
            setError(reason);
          }
        },
      );
    } catch (reason) {
      setError(reason);
    }
    return () => {
      cancel = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
  return {value: val, error};
}
