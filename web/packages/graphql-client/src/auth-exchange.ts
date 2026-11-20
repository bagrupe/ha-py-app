import {authExchange} from '@urql/exchange-auth';

export interface CreateAuthExchangeOptions {
  getToken?: () => string | undefined;
}

export const createAuthExchange = ({
  getToken,
}: CreateAuthExchangeOptions = {}) =>
  authExchange(async (util) => ({
    didAuthError: () => false,
    getAuth: async () => null,
    willAuthError: () => false,
    refreshAuth: () => Promise.resolve(),
    addAuthToOperation(operation) {
      const token = getToken?.();
      if (token === undefined) return operation;
      return util.appendHeaders(operation, {Authorization: `Bearer ${token}`});
    },
  }));
