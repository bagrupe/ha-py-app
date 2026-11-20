import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';

export type JsonValueWithSlotsRecursive_JsonObject_Fragment = {
  __typename?: 'JsonObject';
  fields: Array<{
    __typename?: 'JsonField';
    value:
      | ({
          __typename?: 'JsonObject';
          fields: Array<{
            __typename?: 'JsonField';
            value:
              | ({
                  __typename?: 'JsonObject';
                  fields: Array<{
                    __typename?: 'JsonField';
                    value:
                      | ({
                          __typename?: 'JsonObject';
                          fields: Array<{
                            __typename?: 'JsonField';
                            value:
                              | ({
                                  __typename?: 'JsonObject';
                                  fields: Array<{
                                    __typename?: 'JsonField';
                                    value:
                                      | ({
                                          __typename?: 'JsonObject';
                                          fields: Array<{
                                            __typename?: 'JsonField';
                                            value:
                                              | ({
                                                  __typename?: 'JsonObject';
                                                  fields: Array<{
                                                    __typename?: 'JsonField';
                                                    value:
                                                      | ({
                                                          __typename?: 'JsonObject';
                                                        } & JsonValueWithSlots_JsonObject_Fragment)
                                                      | ({
                                                          __typename?: 'JsonSlotValue';
                                                        } & JsonValueWithSlots_JsonSlotValue_Fragment)
                                                      | ({
                                                          __typename?: 'JsonStringValue';
                                                        } & JsonValueWithSlots_JsonStringValue_Fragment);
                                                  }>;
                                                } & JsonValueWithSlots_JsonObject_Fragment)
                                              | ({
                                                  __typename?: 'JsonSlotValue';
                                                } & JsonValueWithSlots_JsonSlotValue_Fragment)
                                              | ({
                                                  __typename?: 'JsonStringValue';
                                                } & JsonValueWithSlots_JsonStringValue_Fragment);
                                          }>;
                                        } & JsonValueWithSlots_JsonObject_Fragment)
                                      | ({
                                          __typename?: 'JsonSlotValue';
                                        } & JsonValueWithSlots_JsonSlotValue_Fragment)
                                      | ({
                                          __typename?: 'JsonStringValue';
                                        } & JsonValueWithSlots_JsonStringValue_Fragment);
                                  }>;
                                } & JsonValueWithSlots_JsonObject_Fragment)
                              | ({
                                  __typename?: 'JsonSlotValue';
                                } & JsonValueWithSlots_JsonSlotValue_Fragment)
                              | ({
                                  __typename?: 'JsonStringValue';
                                } & JsonValueWithSlots_JsonStringValue_Fragment);
                          }>;
                        } & JsonValueWithSlots_JsonObject_Fragment)
                      | ({
                          __typename?: 'JsonSlotValue';
                        } & JsonValueWithSlots_JsonSlotValue_Fragment)
                      | ({
                          __typename?: 'JsonStringValue';
                        } & JsonValueWithSlots_JsonStringValue_Fragment);
                  }>;
                } & JsonValueWithSlots_JsonObject_Fragment)
              | ({
                  __typename?: 'JsonSlotValue';
                } & JsonValueWithSlots_JsonSlotValue_Fragment)
              | ({
                  __typename?: 'JsonStringValue';
                } & JsonValueWithSlots_JsonStringValue_Fragment);
          }>;
        } & JsonValueWithSlots_JsonObject_Fragment)
      | ({
          __typename?: 'JsonSlotValue';
        } & JsonValueWithSlots_JsonSlotValue_Fragment)
      | ({
          __typename?: 'JsonStringValue';
        } & JsonValueWithSlots_JsonStringValue_Fragment);
  }>;
} & JsonValueWithSlots_JsonObject_Fragment;

export type JsonValueWithSlotsRecursive_JsonSlotValue_Fragment = {
  __typename?: 'JsonSlotValue';
} & JsonValueWithSlots_JsonSlotValue_Fragment;

export type JsonValueWithSlotsRecursive_JsonStringValue_Fragment = {
  __typename?: 'JsonStringValue';
} & JsonValueWithSlots_JsonStringValue_Fragment;

export type JsonValueWithSlotsRecursiveFragment =
  | JsonValueWithSlotsRecursive_JsonObject_Fragment
  | JsonValueWithSlotsRecursive_JsonSlotValue_Fragment
  | JsonValueWithSlotsRecursive_JsonStringValue_Fragment;

export type JsonValueWithSlots_JsonObject_Fragment = {
  __typename: 'JsonObject';
  fields: Array<{
    __typename?: 'JsonField';
    name: string;
    value:
      | {__typename: 'JsonObject'}
      | {__typename: 'JsonSlotValue'}
      | {__typename: 'JsonStringValue'};
  }>;
};

export type JsonValueWithSlots_JsonSlotValue_Fragment = {
  __typename: 'JsonSlotValue';
  slotName: string;
};

export type JsonValueWithSlots_JsonStringValue_Fragment = {
  __typename: 'JsonStringValue';
  value: string;
};

export type JsonValueWithSlotsFragment =
  | JsonValueWithSlots_JsonObject_Fragment
  | JsonValueWithSlots_JsonSlotValue_Fragment
  | JsonValueWithSlots_JsonStringValue_Fragment;

export type JsonFieldFragment = {
  __typename: 'JsonField';
  name: string;
  value:
    | ({
        __typename?: 'JsonObject';
      } & JsonValueWithSlotsRecursive_JsonObject_Fragment)
    | ({
        __typename?: 'JsonSlotValue';
      } & JsonValueWithSlotsRecursive_JsonSlotValue_Fragment)
    | ({
        __typename?: 'JsonStringValue';
      } & JsonValueWithSlotsRecursive_JsonStringValue_Fragment);
};

export type JsonPartFragment = {
  __typename: 'JsonPart';
  value:
    | ({
        __typename?: 'JsonObject';
      } & JsonValueWithSlotsRecursive_JsonObject_Fragment)
    | ({
        __typename?: 'JsonSlotValue';
      } & JsonValueWithSlotsRecursive_JsonSlotValue_Fragment)
    | ({
        __typename?: 'JsonStringValue';
      } & JsonValueWithSlotsRecursive_JsonStringValue_Fragment);
};

export const JsonValueWithSlotsFragmentDoc = gql`
  fragment JsonValueWithSlots on IJsonValueWithSlots {
    __typename
    ... on JsonObject {
      fields {
        name
        value {
          __typename
        }
      }
    }
    ... on JsonStringValue {
      __typename
      value
    }
    ... on JsonSlotValue {
      __typename
      slotName
    }
  }
`;
export const JsonValueWithSlotsRecursiveFragmentDoc = gql`
  fragment JsonValueWithSlotsRecursive on IJsonValueWithSlots {
    ...JsonValueWithSlots
    ... on JsonObject {
      fields {
        value {
          ...JsonValueWithSlots
          ... on JsonObject {
            fields {
              value {
                ...JsonValueWithSlots
                ... on JsonObject {
                  fields {
                    value {
                      ...JsonValueWithSlots
                      ... on JsonObject {
                        fields {
                          value {
                            ...JsonValueWithSlots
                            ... on JsonObject {
                              fields {
                                value {
                                  ...JsonValueWithSlots
                                  ... on JsonObject {
                                    fields {
                                      value {
                                        ...JsonValueWithSlots
                                        ... on JsonObject {
                                          fields {
                                            value {
                                              ...JsonValueWithSlots
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ${JsonValueWithSlotsFragmentDoc}
`;
export const JsonFieldFragmentDoc = gql`
  fragment JsonField on JsonField {
    __typename
    name
    value {
      ...JsonValueWithSlotsRecursive
    }
  }
  ${JsonValueWithSlotsRecursiveFragmentDoc}
`;
export const JsonPartFragmentDoc = gql`
  fragment JsonPart on JsonPart {
    __typename
    value {
      ...JsonValueWithSlotsRecursive
    }
  }
  ${JsonValueWithSlotsRecursiveFragmentDoc}
`;
