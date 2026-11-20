import {useEffect, useRef} from 'react';

const ACTIVITY_EVENTS = ['pointerdown', 'touchstart', 'keydown'] as const;

const fallbackTimeoutMs = 30_000;
const configuredTimeoutMs = Number(
  import.meta.env.VITE_VERANSTALTUNGEN_FILTER_AUTO_RESET_TIMEOUT_MS,
);
const defaultTimeoutMs =
  Number.isFinite(configuredTimeoutMs) && configuredTimeoutMs > 0
    ? configuredTimeoutMs
    : fallbackTimeoutMs;

export const useFilterRowAutoReset = (
  active: boolean,
  onTimeout: () => void,
  timeoutMs = defaultTimeoutMs,
) => {
  const onTimeoutRef = useRef(onTimeout);
  useEffect(() => {
    onTimeoutRef.current = onTimeout;
  });

  useEffect(() => {
    if (!active) return;

    let timeoutId = window.setTimeout(() => onTimeoutRef.current(), timeoutMs);
    const resetTimeout = () => {
      window.clearTimeout(timeoutId);
      timeoutId = window.setTimeout(() => onTimeoutRef.current(), timeoutMs);
    };

    ACTIVITY_EVENTS.forEach((event) =>
      document.addEventListener(event, resetTimeout, {passive: true}),
    );

    return () => {
      window.clearTimeout(timeoutId);
      ACTIVITY_EVENTS.forEach((event) =>
        document.removeEventListener(event, resetTimeout),
      );
    };
  }, [active, timeoutMs]);
};
