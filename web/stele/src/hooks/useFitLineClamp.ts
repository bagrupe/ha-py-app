import {useLayoutEffect, useRef, useState} from 'react';

// Computes how many lines of the given line-height fit in the ref'd element's
// current height, kept in sync as the box resizes. Put the ref on a slot whose
// height is fixed by layout (not by the clamped text), so the measurement
// doesn't chase the very clamp it drives.
export const useFitLineClamp = <T extends HTMLElement = HTMLElement>(
  lineHeight: number,
) => {
  const ref = useRef<T>(null);
  const [lines, setLines] = useState<number>();

  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return;

    const measure = () => {
      const nextLines = Math.max(1, Math.floor(el.clientHeight / lineHeight));
      setLines((currentLines) =>
        currentLines === nextLines ? currentLines : nextLines,
      );
    };

    measure();
    if (typeof ResizeObserver === 'undefined') return;

    const observer = new ResizeObserver(measure);
    observer.observe(el);
    return () => observer.disconnect();
  }, [lineHeight]);

  return {ref, lines};
};
