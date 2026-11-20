export const compact = <T>(items?: readonly (T | null)[] | null): T[] =>
  items?.filter((item): item is T => item !== null) ?? [];
