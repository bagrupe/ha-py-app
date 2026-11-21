import {IntrospectionQuery} from 'graphql';
export default {
  __schema: {
    queryType: {
      name: 'Query',
      kind: 'OBJECT',
    },
    mutationType: {
      name: 'Mutation',
      kind: 'OBJECT',
    },
    subscriptionType: null,
    types: [
      {
        kind: 'OBJECT',
        name: 'AbschlussAlreadyBookedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussDateInFutureError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussEintragNotAssignedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussMinutesOutOfRangeError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussNoProposalError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussNotVereinbartError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussNoteTooLongError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AbschlussSelfConfirmError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'AddAbteilungError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AddAbteilungPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AddAbteilungError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'mitarbeiterGruppe',
            type: {
              kind: 'OBJECT',
              name: 'MitarbeiterGruppe',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AddGebietEinsatzleitungError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GebietNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'MitarbeiterGruppeDeletedError',
          },
          {
            kind: 'OBJECT',
            name: 'MitarbeiterGruppeOfOtherUntereinheitError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AddGebietEinsatzleitungPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AddGebietEinsatzleitungError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'gebiet',
            type: {
              kind: 'OBJECT',
              name: 'Gebiet',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AddGebieteToLageError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GebietAlreadyInLageError',
          },
          {
            kind: 'OBJECT',
            name: 'GebietOfOtherUntereinheitError',
          },
          {
            kind: 'OBJECT',
            name: 'LageClosedError',
          },
          {
            kind: 'OBJECT',
            name: 'LageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AddGebieteToLagePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AddGebieteToLageError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'Lage',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AddGroupToMitarbeiterPayload',
        fields: [
          {
            name: 'mitarbeiter',
            type: {
              kind: 'INTERFACE',
              name: 'Mitarbeiter',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AddProzessGroupError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AddProzessGroupPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AddProzessGroupError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozessGroup',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Adresse',
        fields: [
          {
            name: 'email',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ort',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'plz',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'strasse',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'telefon',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AnfrageForItselfError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AnfrageNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AnfrageStatusTransitionError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AnfragenFuerEhrenamtsbankEintragCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankAnfrage',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AnonymeAusfuehrungResult',
        fields: [
          {
            name: 'correlationId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AnonymeAusfuehrungStatus',
        fields: [
          {
            name: 'abgeschlossenAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'historie',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Historie',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AnonymeEinreichungNichtErlaubtError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AnonymeEinreichungUnvollstaendigError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'AntragSoftLoeschenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AntragSoftLoeschenPayload',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AntragSoftLoeschenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AntragWeiterleitenError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'AntragWiederherstellenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AntragWiederherstellenPayload',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AntragWiederherstellenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AnzeigeTextBlockFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'text',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivEncryptedValue',
        fields: [
          {
            name: 'cipher',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nonce',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'tag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivSlotWert',
        fields: [
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'encryptedValue',
            type: {
              kind: 'OBJECT',
              name: 'ArchivEncryptedValue',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istFreigegeben',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'plainValue',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivVerlaufEintrag',
        fields: [
          {
            name: 'benutzer',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nachricht',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'statusAenderung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'statusAenderungBeschreibung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ziel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivierteAntraegeCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'ArchivierterAntragListItem',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivierterAntragDetail',
        fields: [
          {
            name: 'abgeschlossenAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'archiviertAm',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessBezeichnung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sharedKeyEncryptedForKommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotWerte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ArchivSlotWert',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'verlauf',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ArchivVerlaufEintrag',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ArchivierterAntragListItem',
        fields: [
          {
            name: 'abgeschlossenAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'archiviertAm',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessBezeichnung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AssignProzessTagError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessNotFound',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessTagNotFound',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AssignProzessTagPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AssignProzessTagError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AufbewahrungsEinstellungen',
        fields: [
          {
            name: 'aktualisiertAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'archivVerzoegerungMinuten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'archivierungAktiv',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hardDeleteAktiv',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hardDeleteVerzoegerungMinuten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AufbewahrungsEinstellungenAktualisierenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AufbewahrungsEinstellungenAktualisierenPayload',
        fields: [
          {
            name: 'einstellungen',
            type: {
              kind: 'OBJECT',
              name: 'AufbewahrungsEinstellungen',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AufbewahrungsEinstellungenAktualisierenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufe',
        fields: [
          {
            name: 'aufrufende',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'beschreibung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'JSON',
                ofType: null,
              },
            },
            args: [
              {
                name: 'depth',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'beschreibungText',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'bild',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufe_Bild',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'endDatum',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'fallbackBildUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'qrCode',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufe_QrCode',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'qrCodeUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'startDatum',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'teaser',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufe_Bild',
        fields: [
          {
            name: 'external',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'internal',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufemedien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufe_QrCode',
        fields: [
          {
            name: 'contact',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufe_QrCode_Contact',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'coordinates',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'SCALAR',
                  name: 'Float',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'type',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufe_QrCode_Contact',
        fields: [
          {
            name: 'address',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'email',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'phone',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufemedien',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalX',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalY',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sizes',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufemedien_Sizes',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'thumbnailURL',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufemedien_Sizes',
        fields: [
          {
            name: 'thumbnail',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufemedien_Sizes_Thumbnail',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufemedien_Sizes_Thumbnail',
        fields: [
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Aufrufes',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Aufrufe',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Ausfuehrung',
        fields: [
          {
            name: 'abgeschlossenAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'aktuellerNutzerFolgt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'bearbeitungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Bearbeitung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'beschreibungstextSlotValues',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'SlotValue',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'currentSchritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'Schritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'geloeschtAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'historie',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Historie',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'LageAssignment',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'loeschgrund',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'manuellAbgeschlossen',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nachrichtMaxLength',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'sharedKeyEncryptedForBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'sharedKeyEncryptedForKommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValue',
            type: {
              kind: 'OBJECT',
              name: 'PlainSlotValue',
              ofType: null,
            },
            args: [
              {
                name: 'names',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'LIST',
                    ofType: {
                      kind: 'NON_NULL',
                      ofType: {
                        kind: 'SCALAR',
                        name: 'String',
                        ofType: null,
                      },
                    },
                  },
                },
              },
            ],
          },
          {
            name: 'slotValues',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'SlotValue',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'imagesRaw',
                type: {
                  kind: 'SCALAR',
                  name: 'Boolean',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'user',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'User',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'userId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'verlauf',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Historie',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AusfuehrungContinueError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtTooLongError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungContinuePayload',
        fields: [
          {
            name: 'ausfuehrungResult',
            type: {
              kind: 'OBJECT',
              name: 'AusfuehrungResult',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AusfuehrungContinueError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AusfuehrungCreateAnonymError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AnonymeEinreichungNichtErlaubtError',
          },
          {
            kind: 'OBJECT',
            name: 'AnonymeEinreichungUnvollstaendigError',
          },
          {
            kind: 'OBJECT',
            name: 'LageErforderlichError',
          },
          {
            kind: 'OBJECT',
            name: 'LageGebietNotLiveError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungCreateAnonymPayload',
        fields: [
          {
            name: 'anonymeAusfuehrungResult',
            type: {
              kind: 'OBJECT',
              name: 'AnonymeAusfuehrungResult',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AusfuehrungCreateAnonymError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungCreatePayload',
        fields: [
          {
            name: 'ausfuehrungResult',
            type: {
              kind: 'OBJECT',
              name: 'AusfuehrungResult',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungFolgenPayload',
        fields: [
          {
            name: 'buerger',
            type: {
              kind: 'OBJECT',
              name: 'Buerger',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungResult',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Ausfuehrung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'shouldContinue',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AusfuehrungUpdateZugewiesenePersonError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'MismatchingKommuneError',
          },
          {
            kind: 'OBJECT',
            name: 'UnauthorizedAccessError',
          },
          {
            kind: 'OBJECT',
            name: 'UserNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungUpdateZugewiesenePersonPayload',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AusfuehrungUpdateZugewiesenePersonError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'AusfuehrungWeiterleitenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AntragWeiterleitenError',
          },
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtRequiredError',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtTooLongError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'UserNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungWeiterleitenPayload',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'AusfuehrungWeiterleitenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'AusfuehrungenCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Ausfuehrung',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BackofficeUser',
        fields: [
          {
            name: 'art',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'ausfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'canBeDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'canBeUpdated',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'dienstleister',
            type: {
              kind: 'OBJECT',
              name: 'Dienstleister',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'eMail',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'funktionsberechtigungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'gefolgteIdeen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'gruppen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'MitarbeiterGruppe',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ideen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isKommuneAdmin',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'maengel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'nachname',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'organisationPrivateKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'organisationseinheiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ResolvedBackofficeUserOrganisationseinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'pendingConfirmation',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'personalPrivateKey',
            type: {
              kind: 'OBJECT',
              name: 'EncryptedValue',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'personalPrivateKeySalt',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'untereinheitPermissions',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'UntereinheitPermissions',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'vorname',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Mitarbeiter',
          },
          {
            kind: 'INTERFACE',
            name: 'User',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'BackofficeUserDeleteError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'BackofficeUserDeletePayload',
        fields: [
          {
            name: 'backofficeUser',
            type: {
              kind: 'OBJECT',
              name: 'BackofficeUser',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'BackofficeUserDeleteError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'BackofficeUserUpdateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'BackofficeUserUpdatePayload',
        fields: [
          {
            name: 'backofficeUser',
            type: {
              kind: 'OBJECT',
              name: 'BackofficeUser',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'BackofficeUserUpdateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Bearbeitung',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Ausfuehrung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ausfuehrungId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextVerbindung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Verbindung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextVerbindungId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'Schritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'user',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'User',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'userId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'warZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BearbeitungNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune',
        fields: [
          {
            name: 'analytics',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune_Analytics',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'bereichAId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'defaultPosition',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'design',
            type: {
              kind: 'OBJECT',
              name: 'KommuneDesign',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ideenmelder',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune_Ideenmelder',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'legal',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune_Legal',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'lizenzen',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune_Lizenzen',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'maengelmelder',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune_Maengelmelder',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'regionalschluessel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune_Analytics',
        fields: [
          {
            name: 'siteId',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune_Ideenmelder',
        fields: [
          {
            name: 'ideenZeitfensterStunden',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune_Legal',
        fields: [
          {
            name: 'impressum',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'privacy',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune_Lizenzen',
        fields: [
          {
            name: 'kartenlizenzen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'JSON',
                ofType: null,
              },
            },
            args: [
              {
                name: 'depth',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'kartenlizenzenHtml',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBKommune_Maengelmelder',
        fields: [
          {
            name: 'maengelZeitfensterStunden',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BereichBUntereinheit',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isGemeinde',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'regionalschluessel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'BezahlenSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'betrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Decimal',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'BezahlenSchrittUrlPayload',
        fields: [
          {
            name: 'string',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'BoolExpression',
      },
      {
        kind: 'SCALAR',
        name: 'Boolean',
      },
      {
        kind: 'OBJECT',
        name: 'Buerger',
        fields: [
          {
            name: 'ausfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'city',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'country',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'emailAddress',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'gefolgteAusfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'gefolgteIdeen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasBundId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasKeyEscrow',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ideen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'maengel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'mitteilungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'nachname',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'organisationseinheitIdsForNewsNotifications',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'personalData',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'BuergerPersonalData',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'personalDataKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'personalPrivateKey',
            type: {
              kind: 'OBJECT',
              name: 'EncryptedValue',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'personalPrivateKeySalt',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'phoneNumberMasked',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'phoneVerified',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'postalCode',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'pushNotificationTokens',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'street',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'vorname',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'User',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'BuergerPersonalData',
        fields: [
          {
            name: 'buergerId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'key',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'EncryptedValue',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'CheckboxListFeldOption',
        fields: [
          {
            name: 'defaultChecked',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'key',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'label',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'CheckboxListFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'options',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'CheckboxListFeldOption',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'CollectionSegmentInfo',
        fields: [
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPreviousPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'ConfirmEhrenamtsbankAbschlussError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AbschlussAlreadyBookedError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussEintragNotAssignedError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNoProposalError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNotVereinbartError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussSelfConfirmError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ConfirmEhrenamtsbankAbschlussPayload',
        fields: [
          {
            name: 'ehrenamtsbankAnfrage',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankAnfrage',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'ConfirmEhrenamtsbankAbschlussError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'CreateEhrenamtsbankAnfrageError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AnfrageForItselfError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotActiveError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'MultipleAnfrageError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'CreateEhrenamtsbankAnfragePayload',
        fields: [
          {
            name: 'ehrenamtsbankAnfrage',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankAnfrage',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'CreateEhrenamtsbankAnfrageError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'CreateEhrenamtsbankEintragError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EintragValidationError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'CreateEhrenamtsbankEintragPayload',
        fields: [
          {
            name: 'ehrenamtsbankEintrag',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankEintrag',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'CreateEhrenamtsbankEintragError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'CreateLageError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GebietOfOtherUntereinheitError',
          },
          {
            kind: 'OBJECT',
            name: 'LageUntereinheitNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'CreateLagePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'CreateLageError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'Lage',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'DateFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'SCALAR',
        name: 'DateTime',
      },
      {
        kind: 'SCALAR',
        name: 'Decimal',
      },
      {
        kind: 'OBJECT',
        name: 'DeleteAbteilungPayload',
        fields: [
          {
            name: 'mitarbeiterGruppe',
            type: {
              kind: 'OBJECT',
              name: 'MitarbeiterGruppe',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessDependencies',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'DeleteAbteilungProzessDependency',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteAbteilungProzessDependency',
        fields: [
          {
            name: 'prozessId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittNamen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DeleteEhrenamtsbankAccountError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NegativeZeitkontoSaldoError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'OffeneAusfuehrungenError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
          {
            kind: 'OBJECT',
            name: 'VereinbarteAnfragenError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteEhrenamtsbankAccountPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteEhrenamtsbankAccountError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'result',
            type: {
              kind: 'OBJECT',
              name: 'DeleteEhrenamtsbankAccountResult',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteEhrenamtsbankAccountResult',
        fields: [
          {
            name: 'buergerId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'token',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DeleteEhrenamtsbankEintragError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EintragConflictError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteEhrenamtsbankEintragPayload',
        fields: [
          {
            name: 'deletedId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteEhrenamtsbankEintragError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DeleteProzessError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessHasVersionen',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessNotFound',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'DeleteProzessGroupError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessGroupAssignedToProzess',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessGroupNotFound',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteProzessGroupPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteProzessGroupError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozessGroup',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteProzessPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteProzessError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DeleteProzessVersionError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionHasAusfuehrungen',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionIsCurrentVersion',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionIsLastPublished',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionNotFound',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteProzessVersionPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteProzessVersionError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'OBJECT',
              name: 'ProzessVersion',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DeleteServicePortalLinkError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ServicePortalLinkNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DeleteServicePortalLinkPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DeleteServicePortalLinkError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'servicePortalLink',
            type: {
              kind: 'OBJECT',
              name: 'ServicePortalLink',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Dienstleister',
        fields: [
          {
            name: 'eMailAdressen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'mandant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'mandantId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'organisationseinheiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Untereinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'DienstleisterCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Dienstleister',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DienstleisterCreateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DienstleisterCreatePayload',
        fields: [
          {
            name: 'dienstleister',
            type: {
              kind: 'OBJECT',
              name: 'Dienstleister',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DienstleisterCreateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DienstleisterDeleteError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DienstleisterDeletePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DienstleisterDeleteError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DienstleisterMitarbeiterInviteError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DienstleisterMitarbeiterInvitePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DienstleisterMitarbeiterInviteError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'DienstleisterUpdateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'DienstleisterUpdatePayload',
        fields: [
          {
            name: 'dienstleister',
            type: {
              kind: 'OBJECT',
              name: 'Dienstleister',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'DienstleisterUpdateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankAnfrage',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'eintrag',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankEintrag',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'eintragId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'interessent',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankProfil',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nachricht',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'proposedById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'proposedDate',
            type: {
              kind: 'SCALAR',
              name: 'LocalDate',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'proposedMinutes',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'proposedNote',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'transaktion',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankTransaktion',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'typ',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'vereinbartAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankEintraegeCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankEintrag',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankEintrag',
        fields: [
          {
            name: 'availability',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'description',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'distanceKm',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [
              {
                name: 'origin',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'estimatedDurationMinutes',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'imageKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kategorie',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankKategorie',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kategorieId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'owner',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankProfil',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'radiusKm',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'reviewedAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'tags',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'typ',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'Untereinheit',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheitId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'urgency',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankKategorie',
        fields: [
          {
            name: 'active',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'parentId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'requiresClearance',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'sort',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankProfil',
        fields: [
          {
            name: 'clearanceVerified',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nachname',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'phone',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'phoneVerified',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'vorname',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankTransaktion',
        fields: [
          {
            name: 'anfrageId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdBy',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'eintragId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'giverId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'minutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'note',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'performedOn',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'LocalDate',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'receiverId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankTransaktionenNutzerCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankTransaktion',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EhrenamtsbankZeitkonto',
        fields: [
          {
            name: 'balanceMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'creditMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'debitMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'startCreditMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EintragConflictError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EintragNotActiveError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EintragNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EintragStatusTransitionError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EintragValidationError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EmailAddressNotProvidedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EmailForwarderExportSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'body',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'StringExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'emailAddress',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'StringExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'subject',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'StringExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EncryptedSlotValue',
        fields: [
          {
            name: 'bearbeitung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Bearbeitung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istFreigegeben',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'EncryptedValue',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'SlotValue',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'EncryptedValue',
        fields: [
          {
            name: 'cipher',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nonce',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'tag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'EndeSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'INTERFACE',
        name: 'Error',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AbschlussAlreadyBookedError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussDateInFutureError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussEintragNotAssignedError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussMinutesOutOfRangeError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNoProposalError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNotVereinbartError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNoteTooLongError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussSelfConfirmError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageForItselfError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageStatusTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'AnonymeEinreichungNichtErlaubtError',
          },
          {
            kind: 'OBJECT',
            name: 'AnonymeEinreichungUnvollstaendigError',
          },
          {
            kind: 'OBJECT',
            name: 'AntragWeiterleitenError',
          },
          {
            kind: 'OBJECT',
            name: 'AusfuehrungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'BearbeitungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragConflictError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotActiveError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragStatusTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragValidationError',
          },
          {
            kind: 'OBJECT',
            name: 'EmailAddressNotProvidedError',
          },
          {
            kind: 'OBJECT',
            name: 'GebietAlreadyInLageError',
          },
          {
            kind: 'OBJECT',
            name: 'GebietNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'GebietNotInLageError',
          },
          {
            kind: 'OBJECT',
            name: 'GebietOfOtherUntereinheitError',
          },
          {
            kind: 'OBJECT',
            name: 'GroupNameInvalid',
          },
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
          {
            kind: 'OBJECT',
            name: 'InvalidLageGebietTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'KommuneNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'LageClosedError',
          },
          {
            kind: 'OBJECT',
            name: 'LageErforderlichError',
          },
          {
            kind: 'OBJECT',
            name: 'LageGebietNotLiveError',
          },
          {
            kind: 'OBJECT',
            name: 'LageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'LageUntereinheitNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'MismatchingKommuneError',
          },
          {
            kind: 'OBJECT',
            name: 'MitarbeiterGruppeDeletedError',
          },
          {
            kind: 'OBJECT',
            name: 'MitarbeiterGruppeOfOtherUntereinheitError',
          },
          {
            kind: 'OBJECT',
            name: 'MultipleAnfrageError',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtRequiredError',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtTooLongError',
          },
          {
            kind: 'OBJECT',
            name: 'NegativeZeitkontoSaldoError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'OffeneAusfuehrungenError',
          },
          {
            kind: 'OBJECT',
            name: 'OrganisationseinheitNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessGroupAssignedToProzess',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessGroupNotFound',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessHasVersionen',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessNotFound',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessTagNotFound',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionHasAusfuehrungen',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionIsCurrentVersion',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionIsLastPublished',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessVersionNotFound',
          },
          {
            kind: 'OBJECT',
            name: 'ServicePortalLinkNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'SlotValueNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
          {
            kind: 'OBJECT',
            name: 'UnauthorizedAccessError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitAssignedToUser',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitIsGemeindeError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'UserNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'VereinbarteAnfragenError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'FilePart',
        fields: [
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'Float',
      },
      {
        kind: 'OBJECT',
        name: 'ForgotPasswordConfirmPayload',
        fields: [
          {
            name: 'result',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ForgotPasswordPayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'INTERFACE',
        name: 'FormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AnzeigeTextBlockFeld',
          },
          {
            kind: 'OBJECT',
            name: 'CheckboxListFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'DateFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'LocationFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'SignatureFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'StringFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'TimeFormularFeld',
          },
          {
            kind: 'OBJECT',
            name: 'UploadFormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'FormularSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'felder',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'FormularFeld',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Fraktion',
        fields: [
          {
            name: 'col',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'FunktionsberechtigungMetadataOfFunktionsberechtigungInOrganisationseinheit',
        fields: [
          {
            name: 'description',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'groupName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'implizit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nutzerArtMindestens',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'FunktionsberechtigungMetadataOfGlobaleFunktionsberechtigung',
        fields: [
          {
            name: 'description',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'groupName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'implizit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nutzerArtMindestens',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'FunktionsberechtigungenMetadata',
        fields: [
          {
            name: 'global',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'FunktionsberechtigungMetadataOfGlobaleFunktionsberechtigung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'inOrganisationseinheit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'FunktionsberechtigungMetadataOfFunktionsberechtigungInOrganisationseinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Gebiet',
        fields: [
          {
            name: 'einsatzleitungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'MitarbeiterGruppe',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'geometry',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheitId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GebietAlreadyInLageError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'GebietNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'GebietNotInLageError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'GebietOfOtherUntereinheitError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'GebietSuggestion',
        fields: [
          {
            name: 'gebietId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gebietName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lageId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lageTitle',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GeloeschteAntraegeCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'GeloeschterAntrag',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GeloeschterAntrag',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'endgueltigGeloeschtAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'geloeschtAm',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'geloeschtVon',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'loeschgrund',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessBezeichnung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GeloeschterAntragDetail',
        fields: [
          {
            name: 'antrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'GeloeschterAntrag',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'sharedKeyEncryptedForKommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotWerte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ArchivSlotWert',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'verlauf',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ArchivVerlaufEintrag',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GeoFlaechen',
        fields: [
          {
            name: 'Geometry',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'JSON',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'GovManagerRestExportSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'exportFilePartsAsPdf',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'exportParts',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'UNION',
                    name: 'IPart',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mandantenSchluessel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'vorgangsSchluessel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'vorgangsTyp',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'GroupNameInvalid',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Historie',
        fields: [
          {
            name: 'benutzer',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nachricht',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'statusAenderung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'statusAenderungBeschreibung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ziel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'ID',
      },
      {
        kind: 'UNION',
        name: 'IJsonValueWithSlots',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'JsonObject',
          },
          {
            kind: 'OBJECT',
            name: 'JsonSlotValue',
          },
          {
            kind: 'OBJECT',
            name: 'JsonStringValue',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'IPart',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'FilePart',
          },
          {
            kind: 'OBJECT',
            name: 'JsonPart',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ImageBlockMedien',
        fields: [
          {
            name: 'blockName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'blockType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'image',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ImageBlockVeranstaltungsmedien',
        fields: [
          {
            name: 'blockName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'blockType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'image',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'Instant',
      },
      {
        kind: 'SCALAR',
        name: 'Int',
      },
      {
        kind: 'OBJECT',
        name: 'Integration',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'integrationtype',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'konfiguration',
            type: {
              kind: 'OBJECT',
              name: 'Integration_Konfiguration',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'OBJECT',
              name: 'Integration_Status',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'zugangsdaten',
            type: {
              kind: 'OBJECT',
              name: 'Integration_Zugangsdaten',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Integration_Konfiguration',
        fields: [
          {
            name: 'artikelSeitenId',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'content',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kategorien',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Integration_Konfiguration_Kategorien',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Integration_Konfiguration_Kategorien',
        fields: [
          {
            name: 'gewichtung',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kategorie',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Integration_Status',
        fields: [
          {
            name: 'erfolg',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'import_log',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'last_import_date',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Integration_Zugangsdaten',
        fields: [
          {
            name: 'benutzername',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'passwort',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'token',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'InvalidEmailError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'InvalidLageGebietTransitionError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'InviteBackofficeUserError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'InviteBackofficeUserPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'InviteBackofficeUserError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'IsInside',
        fields: [
          {
            name: 'isInside',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'message',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'JSON',
      },
      {
        kind: 'OBJECT',
        name: 'JsonField',
        fields: [
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'UNION',
                name: 'IJsonValueWithSlots',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'JsonObject',
        fields: [
          {
            name: 'fields',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'JsonField',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'JsonPart',
        fields: [
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'UNION',
                name: 'IJsonValueWithSlots',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'JsonSlotValue',
        fields: [
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'JsonStringValue',
        fields: [
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Kategorie',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istWurzel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'parentId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheitId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ziel',
            type: {
              kind: 'OBJECT',
              name: 'Zustaendigkeit',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieAusblendungAufhebenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieAusblendungAufhebenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieAusblendungAufhebenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieAusblendungSetzenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieAusblendungSetzenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieAusblendungSetzenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieCreateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieCreatePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieCreateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'kategorie',
            type: {
              kind: 'OBJECT',
              name: 'Kategorie',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieDeleteError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieDeletePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieDeleteError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'success',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieLoeschVorschau',
        fields: [
          {
            name: 'anzahlUnterkategorien',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'betroffeneUntereinheiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'UntereinheitBetroffenheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'istGeteilt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieRenameError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieRenamePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieRenameError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'kategorie',
            type: {
              kind: 'OBJECT',
              name: 'Kategorie',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'KategorieZustaendigkeitSetzenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'KategorieZustaendigkeitSetzenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'KategorieZustaendigkeitSetzenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'kategorie',
            type: {
              kind: 'OBJECT',
              name: 'Kategorie',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Kommune',
        fields: [
          {
            name: 'abfallkalender',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Termin',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'bis',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'DateTime',
                    ofType: null,
                  },
                },
              },
              {
                name: 'standortId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
              {
                name: 'von',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'DateTime',
                    ofType: null,
                  },
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'abfallkalenderEnabled',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'analytics',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BereichBKommune_Analytics',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'bereichBId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'ID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'defaultPosition',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'SCALAR',
                  name: 'Float',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'design',
            type: {
              kind: 'OBJECT',
              name: 'KommuneDesign',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'dienstleister',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Dienstleister',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'fraktionen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Fraktion',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'standortId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'geoFlaechen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'GeoFlaechen',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ideeAusfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'ideenAusfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'isPointInGeoflaeche',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'IsInside',
                ofType: null,
              },
            },
            args: [
              {
                name: 'name',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
              {
                name: 'position',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'lizenzen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BereichBKommune_Lizenzen',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'maengelAusfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'mangelAusfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'mitarbeiter',
            type: {
              kind: 'OBJECT',
              name: 'MitarbeiterCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'art',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'groupId',
                type: {
                  kind: 'SCALAR',
                  name: 'UUID',
                  ofType: null,
                },
              },
              {
                name: 'nurDienstleister',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Boolean',
                    ofType: null,
                  },
                },
              },
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'mitarbeiterGruppen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'MitarbeiterGruppe',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'includeDeleted',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Boolean',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'mitarbeiterPendingConfirmation',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'Mitarbeiter',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'orte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ort',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'privateKey',
            type: {
              kind: 'OBJECT',
              name: 'EncryptedValue',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessById',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Prozess',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'prozessByTag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Prozess',
                ofType: null,
              },
            },
            args: [
              {
                name: 'tag',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'prozessGroups',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ProzessGroup',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'prozessTags',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ProzessTag',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'prozesse',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Prozess',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'groupId',
                type: {
                  kind: 'SCALAR',
                  name: 'UUID',
                  ofType: null,
                },
              },
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'prozesseUndLeistungen',
            type: {
              kind: 'OBJECT',
              name: 'ProzesseUndLeistungenCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'groupId',
                type: {
                  kind: 'SCALAR',
                  name: 'UUID',
                  ofType: null,
                },
              },
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'rechtsTexte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BereichBKommune_Legal',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'servicePortalLink',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ServicePortalLink',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'standorte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Standort',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'strassenId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'strassen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Strasse',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'ortId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'untereinheiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Untereinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'KommuneDesign',
        fields: [
          {
            name: 'colors',
            type: {
              kind: 'OBJECT',
              name: 'KommuneDesignColors',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'fallbackImage',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'fonts',
            type: {
              kind: 'OBJECT',
              name: 'KommuneDesignFonts',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ideenIcon',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'logo',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'mangelIcon',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'KommuneDesignColors',
        fields: [
          {
            name: 'primary',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'primaryLight',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'KommuneDesignFonts',
        fields: [
          {
            name: 'body',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'headings',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'KommuneNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Lage',
        fields: [
          {
            name: 'archivedAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'closedAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'closedById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdById',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gebiete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'LageGebiet',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'note',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheitId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Instant',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'warningText',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'LageAssignment',
        fields: [
          {
            name: 'gebietId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gebietName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lageId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lageTitle',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'LageClosedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'LageErforderlichError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'LageGebiet',
        fields: [
          {
            name: 'calledOutAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'calledOutById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'doneAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'doneById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'endedAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'endedById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'gebiet',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Gebiet',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gebietId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'lageId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'liveAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'liveById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'readyAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'readyById',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'status',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'LageGebietNotLiveError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'LageNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'LageUntereinheitNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'SCALAR',
        name: 'LocalDate',
      },
      {
        kind: 'OBJECT',
        name: 'LocationFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'LoginBuergerWeakPayload',
        fields: [
          {
            name: 'loginPayload',
            type: {
              kind: 'OBJECT',
              name: 'LoginPayload',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'LoginPayload',
        fields: [
          {
            name: 'result',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'token',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'LogoutAllDevicesPayload',
        fields: [
          {
            name: 'logoutAllDevicesResult',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Medien',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalX',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalY',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sha1',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sizes',
            type: {
              kind: 'OBJECT',
              name: 'Medien_Sizes',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'thumbnailURL',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Medien_Sizes',
        fields: [
          {
            name: 'thumbnail',
            type: {
              kind: 'OBJECT',
              name: 'Medien_Sizes_Thumbnail',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Medien_Sizes_Thumbnail',
        fields: [
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MeineEhrenamtsbankAnfragenCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankAnfrage',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MeineEhrenamtsbankEintraegeCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankEintrag',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MeineEhrenamtsbankTransaktionenCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'EhrenamtsbankTransaktion',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MismatchingKommuneError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'INTERFACE',
        name: 'Mitarbeiter',
        fields: [
          {
            name: 'eMail',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gruppen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'MitarbeiterGruppe',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nachname',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'organisationPrivateKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'pendingConfirmation',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'vorname',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'User',
          },
        ],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'BackofficeUser',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'MitarbeiterCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'INTERFACE',
                  name: 'Mitarbeiter',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MitarbeiterGruppe',
        fields: [
          {
            name: 'eMailAdressen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ordinal',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'organisationseinheiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Untereinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'MitarbeiterGruppeDeletedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'MitarbeiterGruppeOfOtherUntereinheitError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'MultipleAnfrageError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Mutation',
        fields: [
          {
            name: 'addAbteilung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AddAbteilungPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'addGebietEinsatzleitung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AddGebietEinsatzleitungPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'addGebieteToLage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AddGebieteToLagePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'addGroupToMitarbeiter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AddGroupToMitarbeiterPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'addProzessGroup',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AddProzessGroupPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'addProzessGroupInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'antragSoftLoeschen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AntragSoftLoeschenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'antragWiederherstellen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AntragWiederherstellenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'assignProzessTag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AssignProzessTagPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'aufbewahrungsEinstellungenAktualisieren',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AufbewahrungsEinstellungenAktualisierenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungContinue',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungContinuePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungCreate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungCreatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungCreateAnonym',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungCreateAnonymPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungFolgen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungFolgenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungUpdateZugewiesenePerson',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungUpdateZugewiesenePersonPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungWeiterleiten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AusfuehrungWeiterleitenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'backofficeUserDelete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BackofficeUserDeletePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'backofficeUserUpdate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BackofficeUserUpdatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'bezahlenSchrittUrl',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BezahlenSchrittUrlPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'confirmEhrenamtsbankAbschluss',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ConfirmEhrenamtsbankAbschlussPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'createEhrenamtsbankAnfrage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CreateEhrenamtsbankAnfragePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'createEhrenamtsbankEintrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CreateEhrenamtsbankEintragPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'createLage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CreateLagePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteAbteilung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteAbteilungPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteEhrenamtsbankAccount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteEhrenamtsbankAccountPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteEhrenamtsbankEintrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteEhrenamtsbankEintragPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteProzess',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteProzessPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'deleteProzessInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteProzessGroup',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteProzessGroupPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'deleteProzessGroupInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteProzessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteProzessVersionPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'deleteProzessVersionInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'deleteServicePortalLink',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DeleteServicePortalLinkPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'deleteServicePortalLinkInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'dienstleisterCreate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DienstleisterCreatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'dienstleisterDelete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DienstleisterDeletePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'dienstleisterMitarbeiterInvite',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DienstleisterMitarbeiterInvitePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'dienstleisterUpdate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'DienstleisterUpdatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'forgotPassword',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ForgotPasswordPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'forgotPasswordConfirm',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ForgotPasswordConfirmPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'inviteBackofficeUser',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'InviteBackofficeUserPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieAusblendungAufheben',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieAusblendungAufhebenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieAusblendungSetzen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieAusblendungSetzenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieCreate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieCreatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieDelete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieDeletePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieRename',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieRenamePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieZustaendigkeitSetzen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieZustaendigkeitSetzenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'login',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'LoginPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'loginBuergerWeak',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'LoginBuergerWeakPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'logoutAllDevices',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'LogoutAllDevicesPayload',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'notificationTokenRegister',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'NotificationTokenRegisterPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'personalDataUpdate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'PersonalDataUpdatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'proposeEhrenamtsbankAbschluss',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProposeEhrenamtsbankAbschlussPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'prozessAktivieren',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessAktivierenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'prozessDeaktivieren',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessDeaktivierenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'prozessUpsert',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessUpsertPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'prozessVersionErstellen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersionErstellenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'prozessVersionVeroeffentlichen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersionVeroeffentlichenPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'registerBackofficeUser',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'RegisterBackofficeUserPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'registerBuergerWeak',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'RegisterBuergerWeakPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'removeGebietEinsatzleitung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'RemoveGebietEinsatzleitungPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'removeGroupFromMitarbeiter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'RemoveGroupFromMitarbeiterPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'requestSmsCode',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'RequestSmsCodePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'resetPassword',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ResetPasswordPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'servicePortalLinkUpsert',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ServicePortalLinkUpsertPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'setGroupToProzess',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'SetGroupToProzessPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'setLageGebietStatus',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'SetLageGebietStatusPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'storeKeyEscrow',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'StoreKeyEscrowPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'untereinheitCreate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UntereinheitCreatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'untereinheitDelete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UntereinheitDeletePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'untereinheitUpdate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UntereinheitUpdatePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateAbteilung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateAbteilungPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateEhrenamtsbankAnfrageStatus',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateEhrenamtsbankAnfrageStatusPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateEhrenamtsbankEintrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateEhrenamtsbankEintragPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateEhrenamtsbankEintragStatus',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateEhrenamtsbankEintragStatusPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateIstFreigegebenSlotValue',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateIstFreigegebenSlotValuePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateLage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateLagePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateMyProfile',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateMyProfilePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateNewsNotificationsPreferences',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateNewsNotificationsPreferencesPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'updateProzessGroup',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UpdateProzessGroupPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'updateProzessGroupInput',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'userConfirm',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'UserConfirmPayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'validateSmsCode',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ValidateSmsCodePayload',
                ofType: null,
              },
            },
            args: [
              {
                name: 'input',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'NachrichtRequiredError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NachrichtSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nachrichtMaxLength',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NachrichtTooLongError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NegativeZeitkontoSaldoError',
        fields: [
          {
            name: 'balanceMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'minBalanceMinutes',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NewsArtikel',
        fields: [
          {
            name: '_status',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'bodyPlaintext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'datum',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'importId',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'inhalte',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'NewsArtikel_Inhalte',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'integration',
            type: {
              kind: 'OBJECT',
              name: 'Integration',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'notified',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ordinal',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'originalUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'teaser',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titelbilder',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'NewsArtikel_Titelbilder',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'visible',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'NewsArtikel_Inhalte',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'ImageBlockVeranstaltungsmedien',
          },
          {
            kind: 'OBJECT',
            name: 'RichTextBlock',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NewsArtikel_Titelbilder',
        fields: [
          {
            name: 'bild',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'bildunterschrift',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'NewsArtikels',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'NewsArtikel',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'NodePosition',
        fields: [
          {
            name: 'x',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Float',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'y',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Float',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'NotAllowedError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'NotificationTokenRegisterError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'KommuneNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'NotificationTokenRegisterPayload',
        fields: [
          {
            name: 'buerger',
            type: {
              kind: 'OBJECT',
              name: 'Buerger',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'NotificationTokenRegisterError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'OffeneAusfuehrungenError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'OrganisationseinheitNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Ort',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PersonalDataUpdatePayload',
        fields: [
          {
            name: 'buerger',
            type: {
              kind: 'OBJECT',
              name: 'Buerger',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PlainSlotValue',
        fields: [
          {
            name: 'bearbeitung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Bearbeitung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istFreigegeben',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'JSON',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'SlotValue',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Poi',
        fields: [
          {
            name: 'additionalInformation',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Poi_AdditionalInformation',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'category',
            type: {
              kind: 'OBJECT',
              name: 'PoiCategory',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'contents',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'Poi_Contents',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'image',
            type: {
              kind: 'OBJECT',
              name: 'Poi_Image',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'lockedForImport',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'objectId',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'position',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'positionString',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'visible',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiCategories',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'PoiCategory',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiCategory',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'icon',
            type: {
              kind: 'OBJECT',
              name: 'PoiIcon',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'supercategory',
            type: {
              kind: 'OBJECT',
              name: 'PoiSupercategory',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'visible',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiIcon',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalX',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalY',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sha1',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sizes',
            type: {
              kind: 'OBJECT',
              name: 'PoiIcon_Sizes',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'thumbnailURL',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiIcon_Sizes',
        fields: [
          {
            name: 'thumbnail',
            type: {
              kind: 'OBJECT',
              name: 'PoiIcon_Sizes_Thumbnail',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiIcon_Sizes_Thumbnail',
        fields: [
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PoiSupercategory',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'visible',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Poi_AdditionalInformation',
        fields: [
          {
            name: 'heading',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kind',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
          {
            name: 'text',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'Poi_Contents',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'ImageBlockMedien',
          },
          {
            kind: 'OBJECT',
            name: 'RichTextBlock',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Poi_Image',
        fields: [
          {
            name: 'external',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'internal',
            type: {
              kind: 'OBJECT',
              name: 'Medien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Pois',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Poi',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProgrammatischerSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'implementationAssemblyQualifiedName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProgrammatischerSchrittDefinition',
        fields: [
          {
            name: 'implementationAssemblyQualifiedName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'liefertZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'ProposeEhrenamtsbankAbschlussError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AbschlussDateInFutureError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussEintragNotAssignedError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussMinutesOutOfRangeError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNotVereinbartError',
          },
          {
            kind: 'OBJECT',
            name: 'AbschlussNoteTooLongError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProposeEhrenamtsbankAbschlussPayload',
        fields: [
          {
            name: 'ehrenamtsbankAnfrage',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankAnfrage',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'ProposeEhrenamtsbankAbschlussError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Prozess',
        fields: [
          {
            name: 'currentVersion',
            type: {
              kind: 'OBJECT',
              name: 'ProzessVersion',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'deaktiviertAm',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'group',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'groupId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istOeffentlich',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'latestVersion',
            type: {
              kind: 'OBJECT',
              name: 'ProzessVersion',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'tags',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ProzessTag',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versionen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ProzessVersion',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versionenCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'UserFacingProzess',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'ProzessAktivierenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessNotFound',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessAktivierenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'ProzessAktivierenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'ProzessDeaktivierenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'ProzessNotFound',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessDeaktivierenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'ProzessDeaktivierenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessGroup',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozesse',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'UserFacingProzess',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessGroupAssignedToProzess',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessGroupNotFound',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessHasVersionen',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessNotFound',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessTag',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozesse',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Prozess',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'tag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessTagNotFound',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessUpsertPayload',
        fields: [
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersion',
        fields: [
          {
            name: 'alleSchritte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'Schritt',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'beschreibungstext',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'StringExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ersteSchritte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'INTERFACE',
                    name: 'Schritt',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hatAusfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Prozess',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'publishedAt',
            type: {
              kind: 'SCALAR',
              name: 'Instant',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'rollen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ZustaendigkeitRolle',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'start',
            type: {
              kind: 'INTERFACE',
              name: 'Schritt',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'ProzessVersionErstellenError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EmailAddressNotProvidedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionErstellenPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'ProzessVersionErstellenError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozess',
            type: {
              kind: 'OBJECT',
              name: 'Prozess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionHasAusfuehrungen',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionIsCurrentVersion',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionIsLastPublished',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionNotFound',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ProzessVersionVeroeffentlichenPayload',
        fields: [
          {
            name: 'prozessVersion',
            type: {
              kind: 'OBJECT',
              name: 'ProzessVersion',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ProzesseUndLeistungenCollectionSegment',
        fields: [
          {
            name: 'items',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'INTERFACE',
                  name: 'UserFacingProzess',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'pageInfo',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'CollectionSegmentInfo',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalCount',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PublicGebiet',
        fields: [
          {
            name: 'geometry',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'PublicLage',
        fields: [
          {
            name: 'gebiete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'PublicGebiet',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'title',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'warningText',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Query',
        fields: [
          {
            name: 'activeLagen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'PublicLage',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'kommuneId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'anfragenFuerEhrenamtsbankEintrag',
            type: {
              kind: 'OBJECT',
              name: 'AnfragenFuerEhrenamtsbankEintragCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'archivierteAntraege',
            type: {
              kind: 'OBJECT',
              name: 'ArchivierteAntraegeCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'archivierterAntrag',
            type: {
              kind: 'OBJECT',
              name: 'ArchivierterAntragDetail',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'aufbewahrungsEinstellungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'AufbewahrungsEinstellungen',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'aufruf',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufe',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'aufrufeList',
            type: {
              kind: 'OBJECT',
              name: 'Aufrufes',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'page',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'ausfuehrung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Ausfuehrung',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungStatusAnonym',
            type: {
              kind: 'OBJECT',
              name: 'AnonymeAusfuehrungStatus',
              ofType: null,
            },
            args: [
              {
                name: 'correlationId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'ausfuehrungen',
            type: {
              kind: 'OBJECT',
              name: 'AusfuehrungenCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'prozessId',
                type: {
                  kind: 'SCALAR',
                  name: 'UUID',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'status',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'zugewiesen',
                type: {
                  kind: 'SCALAR',
                  name: 'Boolean',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'ausgeblendeteKategorien',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Kategorie',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'untereinheitId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'dienstleister',
            type: {
              kind: 'OBJECT',
              name: 'DienstleisterCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'ichKannEinladen',
                type: {
                  kind: 'SCALAR',
                  name: 'Boolean',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'ehrenamtsbankAnfrage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'EhrenamtsbankAnfrage',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'ehrenamtsbankEintraege',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankEintraegeCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'filter',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'ehrenamtsbankEintrag',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'EhrenamtsbankEintrag',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'ehrenamtsbankKategorien',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'EhrenamtsbankKategorie',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'order',
                type: {
                  kind: 'LIST',
                  ofType: {
                    kind: 'NON_NULL',
                    ofType: {
                      kind: 'SCALAR',
                      name: 'Any',
                    },
                  },
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'ehrenamtsbankTransaktionenNutzer',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankTransaktionenNutzerCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'userId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'funktionsberechtigungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FunktionsberechtigungenMetadata',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'gebiete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Gebiet',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'withoutEinsatzleitung',
                type: {
                  kind: 'SCALAR',
                  name: 'Boolean',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'geloeschteAntraege',
            type: {
              kind: 'OBJECT',
              name: 'GeloeschteAntraegeCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'geloeschterAntrag',
            type: {
              kind: 'OBJECT',
              name: 'GeloeschterAntragDetail',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieBaum',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Kategorie',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'untereinheitId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'kategorieLoeschVorschau',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'KategorieLoeschVorschau',
                ofType: null,
              },
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'keyEscrow',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [
              {
                name: 'kommuneId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'kommunen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Kommune',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'Lage',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'lagen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Lage',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'status',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'meinEhrenamtsbankZeitkonto',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'EhrenamtsbankZeitkonto',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'meineEhrenamtsbankAnfrageFuerEintrag',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankAnfrage',
              ofType: null,
            },
            args: [
              {
                name: 'eintragId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'meineEhrenamtsbankAnfragen',
            type: {
              kind: 'OBJECT',
              name: 'MeineEhrenamtsbankAnfragenCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'meineEhrenamtsbankEintraege',
            type: {
              kind: 'OBJECT',
              name: 'MeineEhrenamtsbankEintraegeCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'meineEhrenamtsbankTransaktionen',
            type: {
              kind: 'OBJECT',
              name: 'MeineEhrenamtsbankTransaktionenCollectionSegment',
              ofType: null,
            },
            args: [
              {
                name: 'filter',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'skip',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'take',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'my',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'User',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'newsArtikel',
            type: {
              kind: 'OBJECT',
              name: 'NewsArtikel',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'newsArtikelList',
            type: {
              kind: 'OBJECT',
              name: 'NewsArtikels',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'page',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'poi',
            type: {
              kind: 'OBJECT',
              name: 'Poi',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'poiCategories',
            type: {
              kind: 'OBJECT',
              name: 'PoiCategories',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'pois',
            type: {
              kind: 'OBJECT',
              name: 'Pois',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'programmatischeSchritte',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'ProgrammatischerSchrittDefinition',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sensor',
            type: {
              kind: 'OBJECT',
              name: 'Sensoren',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'sensorArten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'SensorArts',
                ofType: null,
              },
            },
            args: [
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'sensoren',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Sensorens',
                ofType: null,
              },
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'suggestedGebiete',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'GebietSuggestion',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'kommuneId',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'UUID',
                    ofType: null,
                  },
                },
              },
              {
                name: 'latitude',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
              {
                name: 'longitude',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'untereinheitList',
            type: {
              kind: 'OBJECT',
              name: 'Untereinheits',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'veranstaltungsTermine',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTermineResult',
              ofType: null,
            },
            args: [
              {
                name: 'bis',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'categoryIds',
                type: {
                  kind: 'LIST',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
              {
                name: 'kommune',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'page',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'search',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'sortDirection',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'untereinheit',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'untereinheiten',
                type: {
                  kind: 'LIST',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
              {
                name: 'visible',
                type: {
                  kind: 'SCALAR',
                  name: 'Boolean',
                  ofType: null,
                },
              },
              {
                name: 'von',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'veranstaltungskalender',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungskalender',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'veranstaltungskalenderKategories',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungskalenderKategories',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'veranstaltungskalenderList',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungskalenders',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'page',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'veranstaltungskalenderQuellen',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungskalenderQuellen',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'veranstalungskalender',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungskalender',
              ofType: null,
            },
            args: [
              {
                name: 'id',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'wettermesspunkteList',
            type: {
              kind: 'OBJECT',
              name: 'Wettermesspunktes',
              ofType: null,
            },
            args: [
              {
                name: 'limit',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'page',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
              {
                name: 'sort',
                type: {
                  kind: 'SCALAR',
                  name: 'String',
                  ofType: null,
                },
              },
              {
                name: 'where',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'RegisterBackofficeUserPayload',
        fields: [
          {
            name: 'result',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'RegisterBuergerWeakPayload',
        fields: [
          {
            name: 'buergerId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'RemoveGebietEinsatzleitungError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GebietNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'RemoveGebietEinsatzleitungPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'RemoveGebietEinsatzleitungError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'gebiet',
            type: {
              kind: 'OBJECT',
              name: 'Gebiet',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'RemoveGroupFromMitarbeiterPayload',
        fields: [
          {
            name: 'mitarbeiter',
            type: {
              kind: 'INTERFACE',
              name: 'Mitarbeiter',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'RequestSmsCodePayload',
        fields: [
          {
            name: 'requestSmsResult',
            type: {
              kind: 'SCALAR',
              name: 'Any',
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ResetPasswordPayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ResolvedBackofficeUserOrganisationseinheit',
        fields: [
          {
            name: 'alleFunktionsberechtigungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'geerbteFunktionsberechtigungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'nutzerspezifischeFunktionsberechtigungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'organisationseinheit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Untereinheit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'organisationseinheitId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'zugehoerig',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'RichTextBlock',
        fields: [
          {
            name: 'blockName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'blockType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'content',
            type: {
              kind: 'SCALAR',
              name: 'JSON',
              ofType: null,
            },
            args: [
              {
                name: 'depth',
                type: {
                  kind: 'SCALAR',
                  name: 'Int',
                  ofType: null,
                },
              },
            ],
          },
          {
            name: 'contentHtml',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'INTERFACE',
        name: 'Schritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'BezahlenSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'EmailForwarderExportSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'EndeSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'FormularSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'GovManagerRestExportSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'NachrichtSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'ProgrammatischerSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'WarteAufBezahlungAbgeschlossenSchritt',
          },
          {
            kind: 'OBJECT',
            name: 'WarteAufGovManagerSchritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'SensorArt',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'einheit',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'icon',
            type: {
              kind: 'OBJECT',
              name: 'PoiIcon',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'rate',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'title',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'warnstufeText1',
            type: {
              kind: 'OBJECT',
              name: 'SensorArtWarnstufeText',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'warnstufeText2',
            type: {
              kind: 'OBJECT',
              name: 'SensorArtWarnstufeText',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'warnstufeText3',
            type: {
              kind: 'OBJECT',
              name: 'SensorArtWarnstufeText',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'warnstufeText4',
            type: {
              kind: 'OBJECT',
              name: 'SensorArtWarnstufeText',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SensorArtWarnstufeText',
        fields: [
          {
            name: 'beschreibung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'kurzlabel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SensorArts',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'SensorArt',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SensorHistorieEintrag',
        fields: [
          {
            name: 'time',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'DateTime',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Float',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Sensoren',
        fields: [
          {
            name: 'ausstehendeGefahrenstufe',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'felder',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Sensoren_Felder',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'glaetteAlarmLevel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'grenzwertInfo1',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'grenzwertInfo2',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'grenzwertInfo3',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'grenzwertInfo4',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'icon',
            type: {
              kind: 'OBJECT',
              name: 'PoiIcon',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'letzteBenachrichtigteGefahrenstufe',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'letzteMessungZeitpunkt',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pegelGefahrenstufe',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'position',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'positionCorrected',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'shownInApp',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Sensoren_Felder',
        fields: [
          {
            name: 'currentValue',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'hasHistorie',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'historie',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'SensorHistorieEintrag',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'duration',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            ],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sensorname',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'werteart',
            type: {
              kind: 'OBJECT',
              name: 'SensorArt',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Sensorens',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Sensoren',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ServicePortalLink',
        fields: [
          {
            name: 'group',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'groupId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'UserFacingProzess',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ServicePortalLinkNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ServicePortalLinkUpsertPayload',
        fields: [
          {
            name: 'servicePortalLink',
            type: {
              kind: 'OBJECT',
              name: 'ServicePortalLink',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SetGroupToProzessPayload',
        fields: [
          {
            name: 'userFacingProzess',
            type: {
              kind: 'INTERFACE',
              name: 'UserFacingProzess',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'SetLageGebietStatusError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GebietNotInLageError',
          },
          {
            kind: 'OBJECT',
            name: 'InvalidLageGebietTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'LageClosedError',
          },
          {
            kind: 'OBJECT',
            name: 'LageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'SetLageGebietStatusPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'SetLageGebietStatusError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'Lage',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SignatureFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Slot',
        fields: [
          {
            name: 'brauchtFreigabe',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'optional',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'valueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'INTERFACE',
        name: 'SlotValue',
        fields: [
          {
            name: 'bearbeitung',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Bearbeitung',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istFreigegeben',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EncryptedSlotValue',
          },
          {
            kind: 'OBJECT',
            name: 'PlainSlotValue',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'SlotValueNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Standort',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nr',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'zusatz',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'StoreKeyEscrowPayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Strasse',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'String',
      },
      {
        kind: 'SCALAR',
        name: 'StringExpression',
      },
      {
        kind: 'OBJECT',
        name: 'StringFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'durchsuchbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'multiline',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'options',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'StringFormularFeldOption',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'validationType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'StringFormularFeldOption',
        fields: [
          {
            name: 'istRelevant',
            type: {
              kind: 'SCALAR',
              name: 'BoolExpression',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'key',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'value',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'SystemUser',
        fields: [
          {
            name: 'ausfuehrungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'gefolgteIdeen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'ideen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'maengel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Ausfuehrung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'personalPrivateKey',
            type: {
              kind: 'OBJECT',
              name: 'EncryptedValue',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'personalPrivateKeySalt',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'User',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Termin',
        fields: [
          {
            name: 'bemerkung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'datum',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'fraktion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'fraktionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'turnus',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'verschoben',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'TimeFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'SCALAR',
        name: 'UUID',
      },
      {
        kind: 'OBJECT',
        name: 'Unauthenticated',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UnauthorizedAccessError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Untereinheit',
        fields: [
          {
            name: 'eMailAdressen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'String',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isGemeinde',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'mitarbeiterGruppen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'MitarbeiterGruppe',
                    ofType: null,
                  },
                },
              },
            },
            args: [
              {
                name: 'includeDeleted',
                type: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Boolean',
                    ofType: null,
                  },
                },
              },
            ],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'newsNotificationsEnabled',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'regionalschluessel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitAssignedToUser',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitBetroffenheit',
        fields: [
          {
            name: 'anzahlEigeneUnterkategorien',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheitName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UntereinheitCreateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitCreatePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UntereinheitCreateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'Untereinheit',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UntereinheitDeleteError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitAssignedToUser',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitIsGemeindeError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitDeletePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UntereinheitDeleteError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Untereinheit',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitIsGemeindeError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitPermissions',
        fields: [
          {
            name: 'backofficeUserId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Untereinheit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'untereinheitId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UntereinheitUpdateError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitIsGemeindeError',
          },
          {
            kind: 'OBJECT',
            name: 'UntereinheitNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UntereinheitUpdatePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UntereinheitUpdateError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'Untereinheit',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Untereinheits',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'BereichBUntereinheit',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateAbteilungError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'GroupNameInvalid',
          },
          {
            kind: 'OBJECT',
            name: 'InvalidEmailError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateAbteilungPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateAbteilungError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'mitarbeiterGruppe',
            type: {
              kind: 'OBJECT',
              name: 'MitarbeiterGruppe',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateEhrenamtsbankAnfrageStatusError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'AnfrageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'AnfrageStatusTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragConflictError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotActiveError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'Unauthenticated',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateEhrenamtsbankAnfrageStatusPayload',
        fields: [
          {
            name: 'ehrenamtsbankAnfrage',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankAnfrage',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateEhrenamtsbankAnfrageStatusError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateEhrenamtsbankEintragError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EintragConflictError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragValidationError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateEhrenamtsbankEintragPayload',
        fields: [
          {
            name: 'ehrenamtsbankEintrag',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankEintrag',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateEhrenamtsbankEintragError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateEhrenamtsbankEintragStatusError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'EintragConflictError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'EintragStatusTransitionError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateEhrenamtsbankEintragStatusPayload',
        fields: [
          {
            name: 'ehrenamtsbankEintrag',
            type: {
              kind: 'OBJECT',
              name: 'EhrenamtsbankEintrag',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateEhrenamtsbankEintragStatusError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateIstFreigegebenSlotValueError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'BearbeitungNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'SlotValueNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateIstFreigegebenSlotValuePayload',
        fields: [
          {
            name: 'ausfuehrung',
            type: {
              kind: 'OBJECT',
              name: 'Ausfuehrung',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateIstFreigegebenSlotValueError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateLageError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'LageNotFoundError',
          },
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateLagePayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateLageError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'lage',
            type: {
              kind: 'OBJECT',
              name: 'Lage',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateMyProfilePayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateNewsNotificationsPreferencesError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
          {
            kind: 'OBJECT',
            name: 'OrganisationseinheitNotFoundError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateNewsNotificationsPreferencesPayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateNewsNotificationsPreferencesError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'UpdateProzessGroupError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UpdateProzessGroupPayload',
        fields: [
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UpdateProzessGroupError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'prozessGroup',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'UploadFormularFeld',
        fields: [
          {
            name: 'angezeigterName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'brauchtFreigabe',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'document',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'encrypted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhaltsTag',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'multi',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'oeffentlichSichtbar',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'order',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pflichtfeld',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'FormularSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'slotValueType',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'FormularFeld',
          },
        ],
      },
      {
        kind: 'INTERFACE',
        name: 'User',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'isDeleted',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'publicKey',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'BackofficeUser',
          },
          {
            kind: 'OBJECT',
            name: 'Buerger',
          },
          {
            kind: 'OBJECT',
            name: 'SystemUser',
          },
        ],
      },
      {
        kind: 'UNION',
        name: 'UserConfirmError',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'NotAllowedError',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UserConfirmPayload',
        fields: [
          {
            name: 'boolean',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'errors',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'UserConfirmError',
                  ofType: null,
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'INTERFACE',
        name: 'UserFacingProzess',
        fields: [
          {
            name: 'group',
            type: {
              kind: 'OBJECT',
              name: 'ProzessGroup',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'groupId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Kommune',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommuneId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'Prozess',
          },
          {
            kind: 'OBJECT',
            name: 'ServicePortalLink',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'UserNotFoundError',
        fields: [
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'ValidateSmsCodePayload',
        fields: [
          {
            name: 'isNewRegistration',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'refreshToken',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'remainingAttempts',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'result',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'retryAfterSeconds',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'token',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTermin',
        fields: [
          {
            name: 'address',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'anbieterUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'buchungsUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'category',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'OBJECT',
                name: 'VeranstaltungsTerminKategorie',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'coordinates',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'dates',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'OBJECT',
                name: 'VeranstaltungsTerminDate',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'end',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'locationName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'start',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'subtitle',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'teaser',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ticketUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titelbild',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTerminTitelbild',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'veranstalterAdresse',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTerminVeranstalterAdresse',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminDate',
        fields: [
          {
            name: 'end',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'start',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminKategorie',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'label',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminTitelbild',
        fields: [
          {
            name: 'external',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'internal',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTerminTitelbildInternal',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminTitelbildInternal',
        fields: [
          {
            name: 'sizes',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTerminTitelbildInternalSizes',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminTitelbildInternalSizes',
        fields: [
          {
            name: 'thumbnail',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungsTerminTitelbildInternalThumbnail',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminTitelbildInternalThumbnail',
        fields: [
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTerminVeranstalterAdresse',
        fields: [
          {
            name: 'email',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ort',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'plz',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'strasse',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'telefon',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungsTermineResult',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'OBJECT',
                name: 'VeranstaltungsTermin',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungskalender',
        fields: [
          {
            name: 'anbieterUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'buchungsUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'category',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'VeranstaltungskalenderKategorie',
                  ofType: null,
                },
              },
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'inhalte',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'UNION',
                  name: 'Veranstaltungskalender_Inhalte',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'lockedForImport',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'source',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'VeranstaltungskalenderQuelle',
                  ofType: null,
                },
              },
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'subtitle',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'teaser',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'ticketUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'timeAndLocation',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungskalender_TimeAndLocation',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titelbild',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungskalender_Titelbild',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'upstreamUpdateDate',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'veranstalterAdresse',
            type: {
              kind: 'OBJECT',
              name: 'Adresse',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'visible',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungskalenderKategorie',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filterkategorie',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'label',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungskalenderKategories',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'VeranstaltungskalenderKategorie',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungskalenderQuelle',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'logo',
            type: {
              kind: 'OBJECT',
              name: 'VeranstaltungskalenderQuelle_Logo',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungskalenderQuelle_Logo',
        fields: [
          {
            name: 'external',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'internal',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VeranstaltungskalenderQuellen',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'VeranstaltungskalenderQuelle',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'UNION',
        name: 'Veranstaltungskalender_Inhalte',
        possibleTypes: [
          {
            kind: 'OBJECT',
            name: 'ImageBlockVeranstaltungsmedien',
          },
          {
            kind: 'OBJECT',
            name: 'RichTextBlock',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungskalender_TimeAndLocation',
        fields: [
          {
            name: 'address',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'coordinates',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'SCALAR',
                  name: 'Float',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'dates',
            type: {
              kind: 'LIST',
              ofType: {
                kind: 'NON_NULL',
                ofType: {
                  kind: 'OBJECT',
                  name: 'Veranstaltungskalender_TimeAndLocation_Dates',
                  ofType: null,
                },
              },
            },
            args: [],
          },
          {
            name: 'locationName',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungskalender_TimeAndLocation_Dates',
        fields: [
          {
            name: 'end',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'start',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungskalender_Titelbild',
        fields: [
          {
            name: 'external',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'internal',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungskalenders',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Veranstaltungskalender',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungsmedien',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalX',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'focalY',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sizes',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien_Sizes',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'sourceUrl',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'thumbnailURL',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'untereinheit',
            type: {
              kind: 'OBJECT',
              name: 'BereichBUntereinheit',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungsmedien_Sizes',
        fields: [
          {
            name: 'thumbnail',
            type: {
              kind: 'OBJECT',
              name: 'Veranstaltungsmedien_Sizes_Thumbnail',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Veranstaltungsmedien_Sizes_Thumbnail',
        fields: [
          {
            name: 'filename',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'filesize',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'height',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mimeType',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'url',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'width',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Verbindung',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'istRelevant',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'BoolExpression',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nach',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'Schritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nachId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'statusAenderung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'statusAenderungBeschreibung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'von',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'INTERFACE',
                name: 'Schritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'vonId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'VereinbarteAnfragenError',
        fields: [
          {
            name: 'count',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'message',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Error',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'WarteAufBezahlungAbgeschlossenSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'bezahlenSchritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'BezahlenSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'bezahlenSchrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'WarteAufGovManagerSchritt',
        fields: [
          {
            name: 'anweisung',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'erledigungDurchBuerger',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'govManagerSchritt',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'GovManagerRestExportSchritt',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'govManagerSchrittId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'informationstext',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'nodePosition',
            type: {
              kind: 'OBJECT',
              name: 'NodePosition',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'prozessVersion',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'ProzessVersion',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prozessVersionId',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'schreibtRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'schreibtRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'slots',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Slot',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'sollZustaendigkeit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'OBJECT',
                name: 'Zustaendigkeit',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'titel',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'verbindungen',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Verbindung',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'versendeEMailAnMitarbeiterGruppe',
            type: {
              kind: 'SCALAR',
              name: 'Boolean',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [
          {
            kind: 'INTERFACE',
            name: 'Schritt',
          },
        ],
      },
      {
        kind: 'OBJECT',
        name: 'Wettermesspunkte',
        fields: [
          {
            name: 'createdAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'kommune',
            type: {
              kind: 'OBJECT',
              name: 'BereichBKommune',
              ofType: null,
            },
            args: [
              {
                name: 'fallbackLocale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
              {
                name: 'locale',
                type: {
                  kind: 'SCALAR',
                  name: 'Any',
                },
              },
            ],
          },
          {
            name: 'location',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Float',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'locationName',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'updatedAt',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'weather',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Wettermesspunkte_Weather',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Wettermesspunkte_Weather',
        fields: [
          {
            name: 'date',
            type: {
              kind: 'SCALAR',
              name: 'DateTime',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'icon',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'id',
            type: {
              kind: 'SCALAR',
              name: 'String',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'maxTemp',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'minTemp',
            type: {
              kind: 'SCALAR',
              name: 'Float',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Wettermesspunktes',
        fields: [
          {
            name: 'docs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'OBJECT',
                    name: 'Wettermesspunkte',
                    ofType: null,
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'hasNextPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'hasPrevPage',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Boolean',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'limit',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'nextPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'offset',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'page',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'pagingCounter',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'prevPage',
            type: {
              kind: 'SCALAR',
              name: 'Int',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'totalDocs',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'totalPages',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Int',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'Zustaendigkeit',
        fields: [
          {
            name: 'art',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'Any',
              },
            },
            args: [],
          },
          {
            name: 'dienstleister',
            type: {
              kind: 'OBJECT',
              name: 'Dienstleister',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'dienstleisterId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'dynamischeArten',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'LIST',
                ofType: {
                  kind: 'NON_NULL',
                  ofType: {
                    kind: 'SCALAR',
                    name: 'Any',
                  },
                },
              },
            },
            args: [],
          },
          {
            name: 'liestRolle',
            type: {
              kind: 'OBJECT',
              name: 'ZustaendigkeitRolle',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'liestRolleId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mitarbeiterGruppe',
            type: {
              kind: 'OBJECT',
              name: 'MitarbeiterGruppe',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'mitarbeiterGruppeId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'organisationseinheit',
            type: {
              kind: 'OBJECT',
              name: 'Untereinheit',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'organisationseinheitId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'zugewiesenePerson',
            type: {
              kind: 'INTERFACE',
              name: 'Mitarbeiter',
              ofType: null,
            },
            args: [],
          },
          {
            name: 'zugewiesenePersonId',
            type: {
              kind: 'SCALAR',
              name: 'UUID',
              ofType: null,
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'OBJECT',
        name: 'ZustaendigkeitRolle',
        fields: [
          {
            name: 'id',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'UUID',
                ofType: null,
              },
            },
            args: [],
          },
          {
            name: 'name',
            type: {
              kind: 'NON_NULL',
              ofType: {
                kind: 'SCALAR',
                name: 'String',
                ofType: null,
              },
            },
            args: [],
          },
        ],
        interfaces: [],
      },
      {
        kind: 'SCALAR',
        name: 'Any',
      },
    ],
    directives: [],
  },
} as unknown as IntrospectionQuery;
