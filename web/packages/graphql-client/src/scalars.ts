import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

export const buildScalarsConfig = () => ({
  DateTime: (value?: unknown) =>
    typeof value === 'string' ? new Date(value) : value,
  Date: (value?: unknown) =>
    typeof value === 'string' ? new Date(value) : value,
  Instant: (value?: unknown) =>
    typeof value === 'string' ? new Date(value) : value,
  BoolExpression: (value?: unknown) =>
    typeof value === 'string' ? new BoolExpression(value) : value,
  IntExpression: (value?: unknown) =>
    typeof value === 'string' ? new IntExpression(value) : value,
  StringExpression: (value?: unknown) =>
    typeof value === 'string' ? new StringExpression(value) : value,
});
