import {useLayoutEffect, useRef, useState} from 'react';

// Reports whether the ref'd element's content is currently clipped (its full
// content is taller than the box actually shows), kept in sync as either the
// box or the content changes. Works with `-webkit-line-clamp`, since that
// still lays out the full content internally while only painting the
// clamped lines, so `scrollHeight` reflects the untruncated height.
export const useIsTruncated = <T extends HTMLElement = HTMLElement>(
  axis: 'vertical' | 'horizontal' = 'vertical',
) => {
  const ref = useRef<T>(null);
  const [isTruncated, setIsTruncated] = useState(false);

  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return;

    const measure = () => {
      const truncated =
        axis === 'vertical'
          ? el.scrollHeight > el.clientHeight + 1
          : el.scrollWidth > el.clientWidth + 1;
      setIsTruncated((current) =>
        current === truncated ? current : truncated,
      );
    };

    measure();
    if (typeof ResizeObserver === 'undefined') return;

    const observer = new ResizeObserver(measure);
    observer.observe(el);
    return () => observer.disconnect();
  }, [axis]);

  return {ref, isTruncated};
};
