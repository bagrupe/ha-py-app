/**
 * Entfernt aus einem Typ `T` die Eigenschaften `K` distributiv über alle möglichen Typen von `T`.
 * @template T Der Typ, von dem Eigenschaften entfernt werden sollen.
 * @template K Die Schlüssel der zu entfernenden Eigenschaften.
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type DistributiveOmit<T, K extends keyof any> = T extends any
  ? Omit<T, K>
  : never;
