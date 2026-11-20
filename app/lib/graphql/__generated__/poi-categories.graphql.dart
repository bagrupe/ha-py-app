import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_PoiCategoryForKommune {
  factory Variables_Query_PoiCategoryForKommune({
    required dynamic kommuneIdBereichB,
    String? sort,
  }) => Variables_Query_PoiCategoryForKommune._({
    r'kommuneIdBereichB': kommuneIdBereichB,
    if (sort != null) r'sort': sort,
  });

  Variables_Query_PoiCategoryForKommune._(this._$data);

  factory Variables_Query_PoiCategoryForKommune.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichB = data['kommuneIdBereichB'];
    result$data['kommuneIdBereichB'] = (l$kommuneIdBereichB as dynamic);
    if (data.containsKey('sort')) {
      final l$sort = data['sort'];
      result$data['sort'] = (l$sort as String?);
    }
    return Variables_Query_PoiCategoryForKommune._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic get kommuneIdBereichB => (_$data['kommuneIdBereichB'] as dynamic);

  String? get sort => (_$data['sort'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichB = kommuneIdBereichB;
    result$data['kommuneIdBereichB'] = l$kommuneIdBereichB;
    if (_$data.containsKey('sort')) {
      final l$sort = sort;
      result$data['sort'] = l$sort;
    }
    return result$data;
  }

  CopyWith_Variables_Query_PoiCategoryForKommune<
    Variables_Query_PoiCategoryForKommune
  >
  get copyWith =>
      CopyWith_Variables_Query_PoiCategoryForKommune(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_PoiCategoryForKommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneIdBereichB = kommuneIdBereichB;
    final lOther$kommuneIdBereichB = other.kommuneIdBereichB;
    if (l$kommuneIdBereichB != lOther$kommuneIdBereichB) {
      return false;
    }
    final l$sort = sort;
    final lOther$sort = other.sort;
    if (_$data.containsKey('sort') != other._$data.containsKey('sort')) {
      return false;
    }
    if (l$sort != lOther$sort) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneIdBereichB = kommuneIdBereichB;
    final l$sort = sort;
    return Object.hashAll([
      l$kommuneIdBereichB,
      _$data.containsKey('sort') ? l$sort : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_PoiCategoryForKommune<TRes> {
  factory CopyWith_Variables_Query_PoiCategoryForKommune(
    Variables_Query_PoiCategoryForKommune instance,
    TRes Function(Variables_Query_PoiCategoryForKommune) then,
  ) = _CopyWithImpl_Variables_Query_PoiCategoryForKommune;

  factory CopyWith_Variables_Query_PoiCategoryForKommune.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_PoiCategoryForKommune;

  TRes call({dynamic? kommuneIdBereichB, String? sort});
}

class _CopyWithImpl_Variables_Query_PoiCategoryForKommune<TRes>
    implements CopyWith_Variables_Query_PoiCategoryForKommune<TRes> {
  _CopyWithImpl_Variables_Query_PoiCategoryForKommune(
    this._instance,
    this._then,
  );

  final Variables_Query_PoiCategoryForKommune _instance;

  final TRes Function(Variables_Query_PoiCategoryForKommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneIdBereichB = _undefined,
    Object? sort = _undefined,
  }) => _then(
    Variables_Query_PoiCategoryForKommune._({
      ..._instance._$data,
      if (kommuneIdBereichB != _undefined && kommuneIdBereichB != null)
        'kommuneIdBereichB': (kommuneIdBereichB as dynamic),
      if (sort != _undefined) 'sort': (sort as String?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_PoiCategoryForKommune<TRes>
    implements CopyWith_Variables_Query_PoiCategoryForKommune<TRes> {
  _CopyWithStubImpl_Variables_Query_PoiCategoryForKommune(this._res);

  TRes _res;

  call({dynamic? kommuneIdBereichB, String? sort}) => _res;
}

class Query_PoiCategoryForKommune {
  Query_PoiCategoryForKommune({
    this.poiCategories,
    required this.sensorArten,
    this.$__typename = 'Query',
  });

  factory Query_PoiCategoryForKommune.fromJson(Map<String, dynamic> json) {
    final l$poiCategories = json['poiCategories'];
    final l$sensorArten = json['sensorArten'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune(
      poiCategories: l$poiCategories == null
          ? null
          : Query_PoiCategoryForKommune_poiCategories.fromJson(
              (l$poiCategories as Map<String, dynamic>),
            ),
      sensorArten: Query_PoiCategoryForKommune_sensorArten.fromJson(
        (l$sensorArten as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_PoiCategoryForKommune_poiCategories? poiCategories;

  final Query_PoiCategoryForKommune_sensorArten sensorArten;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$poiCategories = poiCategories;
    _resultData['poiCategories'] = l$poiCategories?.toJson();
    final l$sensorArten = sensorArten;
    _resultData['sensorArten'] = l$sensorArten.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$poiCategories = poiCategories;
    final l$sensorArten = sensorArten;
    final l$$__typename = $__typename;
    return Object.hashAll([l$poiCategories, l$sensorArten, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiCategoryForKommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$poiCategories = poiCategories;
    final lOther$poiCategories = other.poiCategories;
    if (l$poiCategories != lOther$poiCategories) {
      return false;
    }
    final l$sensorArten = sensorArten;
    final lOther$sensorArten = other.sensorArten;
    if (l$sensorArten != lOther$sensorArten) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune
    on Query_PoiCategoryForKommune {
  CopyWith_Query_PoiCategoryForKommune<Query_PoiCategoryForKommune>
  get copyWith => CopyWith_Query_PoiCategoryForKommune(this, (i) => i);
}

abstract class CopyWith_Query_PoiCategoryForKommune<TRes> {
  factory CopyWith_Query_PoiCategoryForKommune(
    Query_PoiCategoryForKommune instance,
    TRes Function(Query_PoiCategoryForKommune) then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune;

  factory CopyWith_Query_PoiCategoryForKommune.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiCategoryForKommune;

  TRes call({
    Query_PoiCategoryForKommune_poiCategories? poiCategories,
    Query_PoiCategoryForKommune_sensorArten? sensorArten,
    String? $__typename,
  });
  CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> get poiCategories;
  CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> get sensorArten;
}

class _CopyWithImpl_Query_PoiCategoryForKommune<TRes>
    implements CopyWith_Query_PoiCategoryForKommune<TRes> {
  _CopyWithImpl_Query_PoiCategoryForKommune(this._instance, this._then);

  final Query_PoiCategoryForKommune _instance;

  final TRes Function(Query_PoiCategoryForKommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? poiCategories = _undefined,
    Object? sensorArten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiCategoryForKommune(
      poiCategories: poiCategories == _undefined
          ? _instance.poiCategories
          : (poiCategories as Query_PoiCategoryForKommune_poiCategories?),
      sensorArten: sensorArten == _undefined || sensorArten == null
          ? _instance.sensorArten
          : (sensorArten as Query_PoiCategoryForKommune_sensorArten),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> get poiCategories {
    final local$poiCategories = _instance.poiCategories;
    return local$poiCategories == null
        ? CopyWith_Query_PoiCategoryForKommune_poiCategories.stub(
            _then(_instance),
          )
        : CopyWith_Query_PoiCategoryForKommune_poiCategories(
            local$poiCategories,
            (e) => call(poiCategories: e),
          );
  }

  CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> get sensorArten {
    final local$sensorArten = _instance.sensorArten;
    return CopyWith_Query_PoiCategoryForKommune_sensorArten(
      local$sensorArten,
      (e) => call(sensorArten: e),
    );
  }
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune<TRes>
    implements CopyWith_Query_PoiCategoryForKommune<TRes> {
  _CopyWithStubImpl_Query_PoiCategoryForKommune(this._res);

  TRes _res;

  call({
    Query_PoiCategoryForKommune_poiCategories? poiCategories,
    Query_PoiCategoryForKommune_sensorArten? sensorArten,
    String? $__typename,
  }) => _res;

  CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> get poiCategories =>
      CopyWith_Query_PoiCategoryForKommune_poiCategories.stub(_res);

  CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> get sensorArten =>
      CopyWith_Query_PoiCategoryForKommune_sensorArten.stub(_res);
}

const documentNodeQueryPoiCategoryForKommune = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PoiCategoryForKommune'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneIdBereichB')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sort')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'poiCategories'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'kommune'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'equals'),
                            value: VariableNode(
                              name: NameNode(value: 'kommuneIdBereichB'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'sort'),
                value: VariableNode(name: NameNode(value: 'sort')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '999'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'title'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'icon'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'PoiIcon'),
                              directives: [],
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'supercategory'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'title'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: 'sensorArten'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'kommune'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'equals'),
                            value: VariableNode(
                              name: NameNode(value: 'kommuneIdBereichB'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'icon'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'PoiIcon'),
                              directives: [],
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionPoiIcon,
  ],
);
Query_PoiCategoryForKommune _parserFn_Query_PoiCategoryForKommune(
  Map<String, dynamic> data,
) => Query_PoiCategoryForKommune.fromJson(data);
typedef OnQueryComplete_Query_PoiCategoryForKommune =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_PoiCategoryForKommune?,
    );

class Options_Query_PoiCategoryForKommune
    extends graphql.QueryOptions<Query_PoiCategoryForKommune> {
  Options_Query_PoiCategoryForKommune({
    String? operationName,
    required Variables_Query_PoiCategoryForKommune variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_PoiCategoryForKommune? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_PoiCategoryForKommune? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null
                     ? null
                     : _parserFn_Query_PoiCategoryForKommune(data),
               ),
         onError: onError,
         document: documentNodeQueryPoiCategoryForKommune,
         parserFn: _parserFn_Query_PoiCategoryForKommune,
       );

  final OnQueryComplete_Query_PoiCategoryForKommune? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_PoiCategoryForKommune
    extends graphql.WatchQueryOptions<Query_PoiCategoryForKommune> {
  WatchOptions_Query_PoiCategoryForKommune({
    String? operationName,
    required Variables_Query_PoiCategoryForKommune variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_PoiCategoryForKommune? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryPoiCategoryForKommune,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_PoiCategoryForKommune,
       );
}

class FetchMoreOptions_Query_PoiCategoryForKommune
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_PoiCategoryForKommune({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_PoiCategoryForKommune variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryPoiCategoryForKommune,
       );
}

extension ClientExtension_Query_PoiCategoryForKommune on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_PoiCategoryForKommune>>
  query_PoiCategoryForKommune(
    Options_Query_PoiCategoryForKommune options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_PoiCategoryForKommune>
  watchQuery_PoiCategoryForKommune(
    WatchOptions_Query_PoiCategoryForKommune options,
  ) => this.watchQuery(options);

  void writeQuery_PoiCategoryForKommune({
    required Query_PoiCategoryForKommune data,
    required Variables_Query_PoiCategoryForKommune variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryPoiCategoryForKommune,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_PoiCategoryForKommune? readQuery_PoiCategoryForKommune({
    required Variables_Query_PoiCategoryForKommune variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryPoiCategoryForKommune,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_PoiCategoryForKommune.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_PoiCategoryForKommune>
useQuery_PoiCategoryForKommune(Options_Query_PoiCategoryForKommune options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_PoiCategoryForKommune>
useWatchQuery_PoiCategoryForKommune(
  WatchOptions_Query_PoiCategoryForKommune options,
) => graphql_flutter.useWatchQuery(options);

class Query_PoiCategoryForKommune_Widget
    extends graphql_flutter.Query<Query_PoiCategoryForKommune> {
  Query_PoiCategoryForKommune_Widget({
    widgets.Key? key,
    required Options_Query_PoiCategoryForKommune options,
    required graphql_flutter.QueryBuilder<Query_PoiCategoryForKommune> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_PoiCategoryForKommune_poiCategories {
  Query_PoiCategoryForKommune_poiCategories({
    required this.docs,
    this.$__typename = 'PoiCategories',
  });

  factory Query_PoiCategoryForKommune_poiCategories.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune_poiCategories(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_PoiCategoryForKommune_poiCategories_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_PoiCategoryForKommune_poiCategories_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiCategoryForKommune_poiCategories ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune_poiCategories
    on Query_PoiCategoryForKommune_poiCategories {
  CopyWith_Query_PoiCategoryForKommune_poiCategories<
    Query_PoiCategoryForKommune_poiCategories
  >
  get copyWith =>
      CopyWith_Query_PoiCategoryForKommune_poiCategories(this, (i) => i);
}

abstract class CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> {
  factory CopyWith_Query_PoiCategoryForKommune_poiCategories(
    Query_PoiCategoryForKommune_poiCategories instance,
    TRes Function(Query_PoiCategoryForKommune_poiCategories) then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories;

  factory CopyWith_Query_PoiCategoryForKommune_poiCategories.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories;

  TRes call({
    List<Query_PoiCategoryForKommune_poiCategories_docs>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_PoiCategoryForKommune_poiCategories_docs> Function(
      Iterable<
        CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<
          Query_PoiCategoryForKommune_poiCategories_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> {
  _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories(
    this._instance,
    this._then,
  );

  final Query_PoiCategoryForKommune_poiCategories _instance;

  final TRes Function(Query_PoiCategoryForKommune_poiCategories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_PoiCategoryForKommune_poiCategories(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_PoiCategoryForKommune_poiCategories_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_PoiCategoryForKommune_poiCategories_docs> Function(
      Iterable<
        CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<
          Query_PoiCategoryForKommune_poiCategories_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_PoiCategoryForKommune_poiCategories_docs(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_poiCategories<TRes> {
  _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories(this._res);

  TRes _res;

  call({
    List<Query_PoiCategoryForKommune_poiCategories_docs>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_PoiCategoryForKommune_poiCategories_docs {
  Query_PoiCategoryForKommune_poiCategories_docs({
    required this.id,
    required this.title,
    this.icon,
    this.supercategory,
    this.$__typename = 'PoiCategory',
  });

  factory Query_PoiCategoryForKommune_poiCategories_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$icon = json['icon'];
    final l$supercategory = json['supercategory'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune_poiCategories_docs(
      id: (l$id as String),
      title: (l$title as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      supercategory: l$supercategory == null
          ? null
          : Query_PoiCategoryForKommune_poiCategories_docs_supercategory.fromJson(
              (l$supercategory as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final Fragment_PoiIcon? icon;

  final Query_PoiCategoryForKommune_poiCategories_docs_supercategory?
  supercategory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$supercategory = supercategory;
    _resultData['supercategory'] = l$supercategory?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$icon = icon;
    final l$supercategory = supercategory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$icon,
      l$supercategory,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiCategoryForKommune_poiCategories_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
      return false;
    }
    final l$supercategory = supercategory;
    final lOther$supercategory = other.supercategory;
    if (l$supercategory != lOther$supercategory) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune_poiCategories_docs
    on Query_PoiCategoryForKommune_poiCategories_docs {
  CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<
    Query_PoiCategoryForKommune_poiCategories_docs
  >
  get copyWith =>
      CopyWith_Query_PoiCategoryForKommune_poiCategories_docs(this, (i) => i);
}

abstract class CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<TRes> {
  factory CopyWith_Query_PoiCategoryForKommune_poiCategories_docs(
    Query_PoiCategoryForKommune_poiCategories_docs instance,
    TRes Function(Query_PoiCategoryForKommune_poiCategories_docs) then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs;

  factory CopyWith_Query_PoiCategoryForKommune_poiCategories_docs.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs;

  TRes call({
    String? id,
    String? title,
    Fragment_PoiIcon? icon,
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory? supercategory,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<TRes>
  get supercategory;
}

class _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<TRes> {
  _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs(
    this._instance,
    this._then,
  );

  final Query_PoiCategoryForKommune_poiCategories_docs _instance;

  final TRes Function(Query_PoiCategoryForKommune_poiCategories_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? icon = _undefined,
    Object? supercategory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiCategoryForKommune_poiCategories_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      supercategory: supercategory == _undefined
          ? _instance.supercategory
          : (supercategory
                as Query_PoiCategoryForKommune_poiCategories_docs_supercategory?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }

  CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<TRes>
  get supercategory {
    final local$supercategory = _instance.supercategory;
    return local$supercategory == null
        ? CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory.stub(
            _then(_instance),
          )
        : CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
            local$supercategory,
            (e) => call(supercategory: e),
          );
  }
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_poiCategories_docs<TRes> {
  _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    Fragment_PoiIcon? icon,
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory? supercategory,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<TRes>
  get supercategory =>
      CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory.stub(
        _res,
      );
}

class Query_PoiCategoryForKommune_poiCategories_docs_supercategory {
  Query_PoiCategoryForKommune_poiCategories_docs_supercategory({
    required this.id,
    required this.title,
    this.$__typename = 'PoiSupercategory',
  });

  factory Query_PoiCategoryForKommune_poiCategories_docs_supercategory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
      id: (l$id as String),
      title: (l$title as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$title, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_PoiCategoryForKommune_poiCategories_docs_supercategory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune_poiCategories_docs_supercategory
    on Query_PoiCategoryForKommune_poiCategories_docs_supercategory {
  CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory
  >
  get copyWith =>
      CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
  TRes
> {
  factory CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory instance,
    TRes Function(Query_PoiCategoryForKommune_poiCategories_docs_supercategory)
    then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory;

  factory CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory;

  TRes call({String? id, String? title, String? $__typename});
}

class _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
  TRes
>
    implements
        CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
          TRes
        > {
  _CopyWithImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
    this._instance,
    this._then,
  );

  final Query_PoiCategoryForKommune_poiCategories_docs_supercategory _instance;

  final TRes Function(
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
  TRes
>
    implements
        CopyWith_Query_PoiCategoryForKommune_poiCategories_docs_supercategory<
          TRes
        > {
  _CopyWithStubImpl_Query_PoiCategoryForKommune_poiCategories_docs_supercategory(
    this._res,
  );

  TRes _res;

  call({String? id, String? title, String? $__typename}) => _res;
}

class Query_PoiCategoryForKommune_sensorArten {
  Query_PoiCategoryForKommune_sensorArten({
    required this.docs,
    this.$__typename = 'SensorArts',
  });

  factory Query_PoiCategoryForKommune_sensorArten.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune_sensorArten(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_PoiCategoryForKommune_sensorArten_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_PoiCategoryForKommune_sensorArten_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiCategoryForKommune_sensorArten ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune_sensorArten
    on Query_PoiCategoryForKommune_sensorArten {
  CopyWith_Query_PoiCategoryForKommune_sensorArten<
    Query_PoiCategoryForKommune_sensorArten
  >
  get copyWith =>
      CopyWith_Query_PoiCategoryForKommune_sensorArten(this, (i) => i);
}

abstract class CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> {
  factory CopyWith_Query_PoiCategoryForKommune_sensorArten(
    Query_PoiCategoryForKommune_sensorArten instance,
    TRes Function(Query_PoiCategoryForKommune_sensorArten) then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten;

  factory CopyWith_Query_PoiCategoryForKommune_sensorArten.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten;

  TRes call({
    List<Query_PoiCategoryForKommune_sensorArten_docs>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_PoiCategoryForKommune_sensorArten_docs> Function(
      Iterable<
        CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<
          Query_PoiCategoryForKommune_sensorArten_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> {
  _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten(
    this._instance,
    this._then,
  );

  final Query_PoiCategoryForKommune_sensorArten _instance;

  final TRes Function(Query_PoiCategoryForKommune_sensorArten) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_PoiCategoryForKommune_sensorArten(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_PoiCategoryForKommune_sensorArten_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_PoiCategoryForKommune_sensorArten_docs> Function(
      Iterable<
        CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<
          Query_PoiCategoryForKommune_sensorArten_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) =>
            CopyWith_Query_PoiCategoryForKommune_sensorArten_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_sensorArten<TRes> {
  _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten(this._res);

  TRes _res;

  call({
    List<Query_PoiCategoryForKommune_sensorArten_docs>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_PoiCategoryForKommune_sensorArten_docs {
  Query_PoiCategoryForKommune_sensorArten_docs({
    required this.id,
    required this.name,
    this.icon,
    this.$__typename = 'SensorArt',
  });

  factory Query_PoiCategoryForKommune_sensorArten_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query_PoiCategoryForKommune_sensorArten_docs(
      id: (l$id as String),
      name: (l$name as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Fragment_PoiIcon? icon;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$icon = icon;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$icon, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiCategoryForKommune_sensorArten_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_PoiCategoryForKommune_sensorArten_docs
    on Query_PoiCategoryForKommune_sensorArten_docs {
  CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<
    Query_PoiCategoryForKommune_sensorArten_docs
  >
  get copyWith =>
      CopyWith_Query_PoiCategoryForKommune_sensorArten_docs(this, (i) => i);
}

abstract class CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<TRes> {
  factory CopyWith_Query_PoiCategoryForKommune_sensorArten_docs(
    Query_PoiCategoryForKommune_sensorArten_docs instance,
    TRes Function(Query_PoiCategoryForKommune_sensorArten_docs) then,
  ) = _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten_docs;

  factory CopyWith_Query_PoiCategoryForKommune_sensorArten_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten_docs;

  TRes call({
    String? id,
    String? name,
    Fragment_PoiIcon? icon,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten_docs<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<TRes> {
  _CopyWithImpl_Query_PoiCategoryForKommune_sensorArten_docs(
    this._instance,
    this._then,
  );

  final Query_PoiCategoryForKommune_sensorArten_docs _instance;

  final TRes Function(Query_PoiCategoryForKommune_sensorArten_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiCategoryForKommune_sensorArten_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }
}

class _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten_docs<TRes>
    implements CopyWith_Query_PoiCategoryForKommune_sensorArten_docs<TRes> {
  _CopyWithStubImpl_Query_PoiCategoryForKommune_sensorArten_docs(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Fragment_PoiIcon? icon,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}

class Variables_Query_SensorArtIds {
  factory Variables_Query_SensorArtIds({required dynamic kommuneIdBereichB}) =>
      Variables_Query_SensorArtIds._({r'kommuneIdBereichB': kommuneIdBereichB});

  Variables_Query_SensorArtIds._(this._$data);

  factory Variables_Query_SensorArtIds.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichB = data['kommuneIdBereichB'];
    result$data['kommuneIdBereichB'] = (l$kommuneIdBereichB as dynamic);
    return Variables_Query_SensorArtIds._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic get kommuneIdBereichB => (_$data['kommuneIdBereichB'] as dynamic);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichB = kommuneIdBereichB;
    result$data['kommuneIdBereichB'] = l$kommuneIdBereichB;
    return result$data;
  }

  CopyWith_Variables_Query_SensorArtIds<Variables_Query_SensorArtIds>
  get copyWith => CopyWith_Variables_Query_SensorArtIds(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_SensorArtIds ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneIdBereichB = kommuneIdBereichB;
    final lOther$kommuneIdBereichB = other.kommuneIdBereichB;
    if (l$kommuneIdBereichB != lOther$kommuneIdBereichB) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneIdBereichB = kommuneIdBereichB;
    return Object.hashAll([l$kommuneIdBereichB]);
  }
}

abstract class CopyWith_Variables_Query_SensorArtIds<TRes> {
  factory CopyWith_Variables_Query_SensorArtIds(
    Variables_Query_SensorArtIds instance,
    TRes Function(Variables_Query_SensorArtIds) then,
  ) = _CopyWithImpl_Variables_Query_SensorArtIds;

  factory CopyWith_Variables_Query_SensorArtIds.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_SensorArtIds;

  TRes call({dynamic? kommuneIdBereichB});
}

class _CopyWithImpl_Variables_Query_SensorArtIds<TRes>
    implements CopyWith_Variables_Query_SensorArtIds<TRes> {
  _CopyWithImpl_Variables_Query_SensorArtIds(this._instance, this._then);

  final Variables_Query_SensorArtIds _instance;

  final TRes Function(Variables_Query_SensorArtIds) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneIdBereichB = _undefined}) => _then(
    Variables_Query_SensorArtIds._({
      ..._instance._$data,
      if (kommuneIdBereichB != _undefined && kommuneIdBereichB != null)
        'kommuneIdBereichB': (kommuneIdBereichB as dynamic),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_SensorArtIds<TRes>
    implements CopyWith_Variables_Query_SensorArtIds<TRes> {
  _CopyWithStubImpl_Variables_Query_SensorArtIds(this._res);

  TRes _res;

  call({dynamic? kommuneIdBereichB}) => _res;
}

class Query_SensorArtIds {
  Query_SensorArtIds({required this.sensorArten, this.$__typename = 'Query'});

  factory Query_SensorArtIds.fromJson(Map<String, dynamic> json) {
    final l$sensorArten = json['sensorArten'];
    final l$$__typename = json['__typename'];
    return Query_SensorArtIds(
      sensorArten: Query_SensorArtIds_sensorArten.fromJson(
        (l$sensorArten as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_SensorArtIds_sensorArten sensorArten;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sensorArten = sensorArten;
    _resultData['sensorArten'] = l$sensorArten.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sensorArten = sensorArten;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sensorArten, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_SensorArtIds || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sensorArten = sensorArten;
    final lOther$sensorArten = other.sensorArten;
    if (l$sensorArten != lOther$sensorArten) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_SensorArtIds on Query_SensorArtIds {
  CopyWith_Query_SensorArtIds<Query_SensorArtIds> get copyWith =>
      CopyWith_Query_SensorArtIds(this, (i) => i);
}

abstract class CopyWith_Query_SensorArtIds<TRes> {
  factory CopyWith_Query_SensorArtIds(
    Query_SensorArtIds instance,
    TRes Function(Query_SensorArtIds) then,
  ) = _CopyWithImpl_Query_SensorArtIds;

  factory CopyWith_Query_SensorArtIds.stub(TRes res) =
      _CopyWithStubImpl_Query_SensorArtIds;

  TRes call({Query_SensorArtIds_sensorArten? sensorArten, String? $__typename});
  CopyWith_Query_SensorArtIds_sensorArten<TRes> get sensorArten;
}

class _CopyWithImpl_Query_SensorArtIds<TRes>
    implements CopyWith_Query_SensorArtIds<TRes> {
  _CopyWithImpl_Query_SensorArtIds(this._instance, this._then);

  final Query_SensorArtIds _instance;

  final TRes Function(Query_SensorArtIds) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sensorArten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_SensorArtIds(
      sensorArten: sensorArten == _undefined || sensorArten == null
          ? _instance.sensorArten
          : (sensorArten as Query_SensorArtIds_sensorArten),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_SensorArtIds_sensorArten<TRes> get sensorArten {
    final local$sensorArten = _instance.sensorArten;
    return CopyWith_Query_SensorArtIds_sensorArten(
      local$sensorArten,
      (e) => call(sensorArten: e),
    );
  }
}

class _CopyWithStubImpl_Query_SensorArtIds<TRes>
    implements CopyWith_Query_SensorArtIds<TRes> {
  _CopyWithStubImpl_Query_SensorArtIds(this._res);

  TRes _res;

  call({Query_SensorArtIds_sensorArten? sensorArten, String? $__typename}) =>
      _res;

  CopyWith_Query_SensorArtIds_sensorArten<TRes> get sensorArten =>
      CopyWith_Query_SensorArtIds_sensorArten.stub(_res);
}

const documentNodeQuerySensorArtIds = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SensorArtIds'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneIdBereichB')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sensorArten'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'kommune'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'equals'),
                            value: VariableNode(
                              name: NameNode(value: 'kommuneIdBereichB'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);
Query_SensorArtIds _parserFn_Query_SensorArtIds(Map<String, dynamic> data) =>
    Query_SensorArtIds.fromJson(data);
typedef OnQueryComplete_Query_SensorArtIds =
    FutureOr<void> Function(Map<String, dynamic>?, Query_SensorArtIds?);

class Options_Query_SensorArtIds
    extends graphql.QueryOptions<Query_SensorArtIds> {
  Options_Query_SensorArtIds({
    String? operationName,
    required Variables_Query_SensorArtIds variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_SensorArtIds? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_SensorArtIds? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn_Query_SensorArtIds(data),
               ),
         onError: onError,
         document: documentNodeQuerySensorArtIds,
         parserFn: _parserFn_Query_SensorArtIds,
       );

  final OnQueryComplete_Query_SensorArtIds? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_SensorArtIds
    extends graphql.WatchQueryOptions<Query_SensorArtIds> {
  WatchOptions_Query_SensorArtIds({
    String? operationName,
    required Variables_Query_SensorArtIds variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_SensorArtIds? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySensorArtIds,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_SensorArtIds,
       );
}

class FetchMoreOptions_Query_SensorArtIds extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_SensorArtIds({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_SensorArtIds variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySensorArtIds,
       );
}

extension ClientExtension_Query_SensorArtIds on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_SensorArtIds>> query_SensorArtIds(
    Options_Query_SensorArtIds options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_SensorArtIds> watchQuery_SensorArtIds(
    WatchOptions_Query_SensorArtIds options,
  ) => this.watchQuery(options);

  void writeQuery_SensorArtIds({
    required Query_SensorArtIds data,
    required Variables_Query_SensorArtIds variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySensorArtIds),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_SensorArtIds? readQuery_SensorArtIds({
    required Variables_Query_SensorArtIds variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySensorArtIds),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_SensorArtIds.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_SensorArtIds> useQuery_SensorArtIds(
  Options_Query_SensorArtIds options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_SensorArtIds> useWatchQuery_SensorArtIds(
  WatchOptions_Query_SensorArtIds options,
) => graphql_flutter.useWatchQuery(options);

class Query_SensorArtIds_Widget
    extends graphql_flutter.Query<Query_SensorArtIds> {
  Query_SensorArtIds_Widget({
    widgets.Key? key,
    required Options_Query_SensorArtIds options,
    required graphql_flutter.QueryBuilder<Query_SensorArtIds> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_SensorArtIds_sensorArten {
  Query_SensorArtIds_sensorArten({
    required this.docs,
    this.$__typename = 'SensorArts',
  });

  factory Query_SensorArtIds_sensorArten.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_SensorArtIds_sensorArten(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_SensorArtIds_sensorArten_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_SensorArtIds_sensorArten_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_SensorArtIds_sensorArten ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_SensorArtIds_sensorArten
    on Query_SensorArtIds_sensorArten {
  CopyWith_Query_SensorArtIds_sensorArten<Query_SensorArtIds_sensorArten>
  get copyWith => CopyWith_Query_SensorArtIds_sensorArten(this, (i) => i);
}

abstract class CopyWith_Query_SensorArtIds_sensorArten<TRes> {
  factory CopyWith_Query_SensorArtIds_sensorArten(
    Query_SensorArtIds_sensorArten instance,
    TRes Function(Query_SensorArtIds_sensorArten) then,
  ) = _CopyWithImpl_Query_SensorArtIds_sensorArten;

  factory CopyWith_Query_SensorArtIds_sensorArten.stub(TRes res) =
      _CopyWithStubImpl_Query_SensorArtIds_sensorArten;

  TRes call({
    List<Query_SensorArtIds_sensorArten_docs>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_SensorArtIds_sensorArten_docs> Function(
      Iterable<
        CopyWith_Query_SensorArtIds_sensorArten_docs<
          Query_SensorArtIds_sensorArten_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_SensorArtIds_sensorArten<TRes>
    implements CopyWith_Query_SensorArtIds_sensorArten<TRes> {
  _CopyWithImpl_Query_SensorArtIds_sensorArten(this._instance, this._then);

  final Query_SensorArtIds_sensorArten _instance;

  final TRes Function(Query_SensorArtIds_sensorArten) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_SensorArtIds_sensorArten(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_SensorArtIds_sensorArten_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_SensorArtIds_sensorArten_docs> Function(
      Iterable<
        CopyWith_Query_SensorArtIds_sensorArten_docs<
          Query_SensorArtIds_sensorArten_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_SensorArtIds_sensorArten_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_SensorArtIds_sensorArten<TRes>
    implements CopyWith_Query_SensorArtIds_sensorArten<TRes> {
  _CopyWithStubImpl_Query_SensorArtIds_sensorArten(this._res);

  TRes _res;

  call({
    List<Query_SensorArtIds_sensorArten_docs>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_SensorArtIds_sensorArten_docs {
  Query_SensorArtIds_sensorArten_docs({
    required this.id,
    this.$__typename = 'SensorArt',
  });

  factory Query_SensorArtIds_sensorArten_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_SensorArtIds_sensorArten_docs(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_SensorArtIds_sensorArten_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_SensorArtIds_sensorArten_docs
    on Query_SensorArtIds_sensorArten_docs {
  CopyWith_Query_SensorArtIds_sensorArten_docs<
    Query_SensorArtIds_sensorArten_docs
  >
  get copyWith => CopyWith_Query_SensorArtIds_sensorArten_docs(this, (i) => i);
}

abstract class CopyWith_Query_SensorArtIds_sensorArten_docs<TRes> {
  factory CopyWith_Query_SensorArtIds_sensorArten_docs(
    Query_SensorArtIds_sensorArten_docs instance,
    TRes Function(Query_SensorArtIds_sensorArten_docs) then,
  ) = _CopyWithImpl_Query_SensorArtIds_sensorArten_docs;

  factory CopyWith_Query_SensorArtIds_sensorArten_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_SensorArtIds_sensorArten_docs;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_SensorArtIds_sensorArten_docs<TRes>
    implements CopyWith_Query_SensorArtIds_sensorArten_docs<TRes> {
  _CopyWithImpl_Query_SensorArtIds_sensorArten_docs(this._instance, this._then);

  final Query_SensorArtIds_sensorArten_docs _instance;

  final TRes Function(Query_SensorArtIds_sensorArten_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_SensorArtIds_sensorArten_docs(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_SensorArtIds_sensorArten_docs<TRes>
    implements CopyWith_Query_SensorArtIds_sensorArten_docs<TRes> {
  _CopyWithStubImpl_Query_SensorArtIds_sensorArten_docs(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}
