export default {
  introspection: {
    type: 'url',
    url: 'http://localhost:5000/graphql',
  },
  website: {
    template: 'carbon-multi-page',
    options: {
      queryGenerationFactories: {
        'Int!': 42,
        String: 'abc',
        StringExpression: '""',
        BoolExpression: 'true',
        UUID: '482f10b1-efb9-419f-8c38-a206bb115c82',
        Decimal: '42.24',
      },
    },
  },
};
