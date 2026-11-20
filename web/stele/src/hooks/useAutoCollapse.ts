import {useEffect, useRef, useState} from 'react';

const ACTIVITY_EVENTS = ['pointerdown', 'touchstart', 'keydown'] as const;
const TICK_MS = 250;

const fallbackTimeoutMs = 30_000;
const configuredTimeoutMs = Number(
  import.meta.env.VITE_CAROUSEL_AUTO_COLLAPSE_TIMEOUT_MS,
);
const defaultTimeoutMs =
  Number.isFinite(configuredTimeoutMs) && configuredTimeoutMs > 0
    ? configuredTimeoutMs
    : fallbackTimeoutMs;

/**
 * Owns an "expanded id" (e.g. for a tappable carousel card) that
 * auto-collapses back to `null` after `timeoutMs` of inactivity, so a kiosk
 * card doesn't stay expanded forever once the visitor walks away. Any
 * tap/touch/key press while something is expanded resets the countdown.
 * Defaults to VITE_CAROUSEL_AUTO_COLLAPSE_TIMEOUT_MS or 30000 (30s).
 */
export const useAutoCollapse = (timeoutMs = defaultTimeoutMs) => {
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [remainingMs, setRemainingMs] = useState(timeoutMs);
  const deadlineRef = useRef(0);

  // Set synchronously in the event handler (not the effect below) so the
  // countdown starts at the exact moment of the tap that expands a card.
  const toggle = (id: string) => {
    const next = expandedId === id ? null : id;
    setExpandedId(next);
    if (next !== null) {
      deadlineRef.current = Date.now() + timeoutMs;
      setRemainingMs(timeoutMs);
    }
  };

  useEffect(() => {
    if (expandedId === null) return;

    const resetDeadline = () => {
      deadlineRef.current = Date.now() + timeoutMs;
    };

    ACTIVITY_EVENTS.forEach((event) =>
      document.addEventListener(event, resetDeadline, {passive: true}),
    );

    const interval = setInterval(() => {
      const remaining = deadlineRef.current - Date.now();
      if (remaining <= 0) {
        setExpandedId(null);
        return;
      }
      setRemainingMs(remaining);
    }, TICK_MS);

    return () => {
      ACTIVITY_EVENTS.forEach((event) =>
        document.removeEventListener(event, resetDeadline),
      );
      clearInterval(interval);
    };
  }, [expandedId, timeoutMs]);

  // Unconditional reset (unlike `toggle`, which only clears when called with
  // the currently-expanded id) - used e.g. when the carousel moves to a
  // different slide so the previously-expanded card doesn't stay expanded
  // (and autoplay doesn't stay paused) after it's no longer visible.
  const collapse = () => setExpandedId(null);

  return {
    expandedId,
    toggle,
    collapse,
    remainingSeconds:
      expandedId === null ? undefined : Math.ceil(remainingMs / 1000),
  };
};
