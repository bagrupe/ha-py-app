import {Expression} from './expressions.ts';

export type WithUnparsedExpressions<T> = T extends Array<infer U>
  ? Array<WithUnparsedExpressions<U>>
  : T extends object
  ? {
      [key in keyof T]: T[key] extends Expression
        ? string
        : WithUnparsedExpressions<T[key]>;
    }
  : T;

// React-Hook-Form does not allow class instances, so we create a utility that converts Expressions to their string
//  representation for use in forms. That way, the rest of the application can continue to use the Expression instances
//  in their full utility.
export const deepUnparseExpressions = <T>(
  obj: T,
): WithUnparsedExpressions<T> => {
  if (typeof obj !== 'object') return obj as WithUnparsedExpressions<T>;
  if (Array.isArray(obj))
    return obj.map(deepUnparseExpressions) as WithUnparsedExpressions<T>;
  if (!obj) return obj as WithUnparsedExpressions<T>;

  const convertedEntries = Object.entries(obj).map(
    ([key, value]): [string, unknown] => {
      if (value instanceof Expression) return [key, value.expression];
      if (typeof value === 'object')
        return [key, deepUnparseExpressions(value)];

      return [key, value];
    },
  );

  return Object.fromEntries(convertedEntries) as WithUnparsedExpressions<T>;
};
