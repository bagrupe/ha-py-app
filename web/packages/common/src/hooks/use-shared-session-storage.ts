import {useCallback, useEffect, useMemo, useRef, useState} from 'react';

const KEY = '__ka_session';
const REQUEST_SESSION_DATA = 'REQUEST_SESSION_DATA';
const CLEAR_SESSION_DATA = 'CLEAR_SESSION_DATA';
const SESSION_DATA = 'SESSION_DATA';
// To be clear: this is not a security measure, just good manners.
const B64_ENCODE = true;

export const useSharedSessionStorage = <T extends Record<string, unknown>>(
  options: {broadcastTimeout?: number} = {},
) => {
  const [loading, setLoading] = useState(true);
  const [sessionDataState, setSessionDataState] = useState<T | undefined>(
    undefined,
  );

  const channelRef = useRef<BroadcastChannel | undefined>(undefined);
  const sessionDataRef = useRef<T | undefined>(undefined);

  const setSessionData = useCallback(
    async (data: T) => {
      setSessionDataState(data);
      sessionDataRef.current = data;
      let serialized = JSON.stringify(await serializeShallow(data));
      if (B64_ENCODE) serialized = btoa(serialized);
      sessionStorage.setItem(KEY, serialized);
    },
    [setSessionDataState],
  );

  const clearSessionData = useCallback(() => {
    channelRef.current?.postMessage({
      type: CLEAR_SESSION_DATA,
    });
    sessionStorage.removeItem(KEY);
    setSessionDataState(undefined);
    sessionDataRef.current = undefined;
  }, []);

  useEffect(() => {
    const channel = (channelRef.current = new BroadcastChannel(KEY));
    const clientId = Math.random().toString();
    channel.onmessage = async (event) => {
      if (event.data.clientId == clientId) {
        // Ignore own messages
        return;
      }

      // Grab from ref to avoid capturing possibly stale `sessionData` in this closure
      // (`sessionData` is not in dependency array because we only want this effect to run once)
      const sessionData = sessionDataRef.current;

      switch (event.data.type) {
        case REQUEST_SESSION_DATA:
          if (sessionData) {
            channel.postMessage({
              type: SESSION_DATA,
              clientId,
              sessionData: sessionData,
            });
          }
          break;
        case CLEAR_SESSION_DATA:
          sessionStorage.removeItem(KEY);
          setSessionDataState(undefined);
          sessionDataRef.current = undefined;
          break;
        case SESSION_DATA:
          await setSessionData(event.data.sessionData);
          setLoading(false);
          break;
      }
    };

    let sessionDataRaw = sessionStorage.getItem(KEY);
    let timeout: number | undefined;

    if (sessionDataRaw) {
      if (B64_ENCODE) sessionDataRaw = atob(sessionDataRaw);
      (deserializeShallow(JSON.parse(sessionDataRaw)) as Promise<T>)
        .then(setSessionData)
        .finally(() => setLoading(false));
    } else {
      channel.postMessage({type: REQUEST_SESSION_DATA, clientId});
      // Wait for response on broadcast channel
      timeout = window.setTimeout(() => {
        setLoading(false);
      }, options.broadcastTimeout ?? 1000);
    }

    return () => {
      channel.close();
      window.clearTimeout(timeout);
    };
    // Mount-once effect: BroadcastChannel and initial session restore must
    // not re-run on `setSessionData` / `options.broadcastTimeout` changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return useMemo(
    () => ({
      data: sessionDataState,
      setData: setSessionData,
      clear: clearSessionData,
      loading,
    }),
    [sessionDataState, setSessionData, clearSessionData, loading],
  );
};

type SerializedCryptoKey = {
  __kind: 'CryptoKey';
  keyData: JsonWebKey;
  algorithm: KeyAlgorithm;
};

const serializeShallow = async (x: Record<string, unknown>) => {
  const pairs = await Promise.all(
    Object.entries(x).map(async ([key, value]) => {
      if (value instanceof CryptoKey) {
        value = {
          __kind: 'CryptoKey',
          keyData: await crypto.subtle.exportKey('jwk', value),
          algorithm: value.algorithm,
        } satisfies SerializedCryptoKey;
      }
      return [key, value] as const;
    }),
  );
  return Object.fromEntries(pairs);
};

const deserializeShallow = async (x: Record<string, unknown>) => {
  const pairs = await Promise.all(
    Object.entries(x).map(async ([key, value]) => {
      if (isSerializedCryptoKey(value)) {
        value = await crypto.subtle.importKey(
          'jwk',
          value.keyData,
          value.algorithm,
          value.keyData.ext ?? false,
          value.keyData.key_ops as KeyUsage[],
        );
      }
      return [key, value] as const;
    }),
  );
  return Object.fromEntries(pairs);
};

const isSerializedCryptoKey = (thing: unknown): thing is SerializedCryptoKey =>
  thing != null &&
  typeof thing === 'object' &&
  (thing as {__kind: string}).__kind === 'CryptoKey';
