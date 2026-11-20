import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_VeranstaltungskalenderFilter {
  factory Variables_Query_VeranstaltungskalenderFilter({
    required dynamic kommuneId,
    required String kommuneBereichAId,
  }) => Variables_Query_VeranstaltungskalenderFilter._({
    r'kommuneId': kommuneId,
    r'kommuneBereichAId': kommuneBereichAId,
  });

  Variables_Query_VeranstaltungskalenderFilter._(this._$data);

  factory Variables_Query_VeranstaltungskalenderFilter.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as dynamic);
    final l$kommuneBereichAId = data['kommuneBereichAId'];
    result$data['kommuneBereichAId'] = (l$kommuneBereichAId as String);
    return Variables_Query_VeranstaltungskalenderFilter._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic get kommuneId => (_$data['kommuneId'] as dynamic);

  String get kommuneBereichAId => (_$data['kommuneBereichAId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$kommuneBereichAId = kommuneBereichAId;
    result$data['kommuneBereichAId'] = l$kommuneBereichAId;
    return result$data;
  }

  CopyWith_Variables_Query_VeranstaltungskalenderFilter<
    Variables_Query_VeranstaltungskalenderFilter
  >
  get copyWith =>
      CopyWith_Variables_Query_VeranstaltungskalenderFilter(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_VeranstaltungskalenderFilter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$kommuneBereichAId = kommuneBereichAId;
    final lOther$kommuneBereichAId = other.kommuneBereichAId;
    if (l$kommuneBereichAId != lOther$kommuneBereichAId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$kommuneBereichAId = kommuneBereichAId;
    return Object.hashAll([l$kommuneId, l$kommuneBereichAId]);
  }
}

abstract class CopyWith_Variables_Query_VeranstaltungskalenderFilter<TRes> {
  factory CopyWith_Variables_Query_VeranstaltungskalenderFilter(
    Variables_Query_VeranstaltungskalenderFilter instance,
    TRes Function(Variables_Query_VeranstaltungskalenderFilter) then,
  ) = _CopyWithImpl_Variables_Query_VeranstaltungskalenderFilter;

  factory CopyWith_Variables_Query_VeranstaltungskalenderFilter.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_VeranstaltungskalenderFilter;

  TRes call({dynamic? kommuneId, String? kommuneBereichAId});
}

class _CopyWithImpl_Variables_Query_VeranstaltungskalenderFilter<TRes>
    implements CopyWith_Variables_Query_VeranstaltungskalenderFilter<TRes> {
  _CopyWithImpl_Variables_Query_VeranstaltungskalenderFilter(
    this._instance,
    this._then,
  );

  final Variables_Query_VeranstaltungskalenderFilter _instance;

  final TRes Function(Variables_Query_VeranstaltungskalenderFilter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? kommuneBereichAId = _undefined,
  }) => _then(
    Variables_Query_VeranstaltungskalenderFilter._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as dynamic),
      if (kommuneBereichAId != _undefined && kommuneBereichAId != null)
        'kommuneBereichAId': (kommuneBereichAId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_VeranstaltungskalenderFilter<TRes>
    implements CopyWith_Variables_Query_VeranstaltungskalenderFilter<TRes> {
  _CopyWithStubImpl_Variables_Query_VeranstaltungskalenderFilter(this._res);

  TRes _res;

  call({dynamic? kommuneId, String? kommuneBereichAId}) => _res;
}

class Query_VeranstaltungskalenderFilter {
  Query_VeranstaltungskalenderFilter({
    this.veranstaltungskalenderKategories,
    this.veranstaltungskalenderQuellen,
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_VeranstaltungskalenderFilter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$veranstaltungskalenderKategories =
        json['veranstaltungskalenderKategories'];
    final l$veranstaltungskalenderQuellen =
        json['veranstaltungskalenderQuellen'];
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter(
      veranstaltungskalenderKategories:
          l$veranstaltungskalenderKategories == null
          ? null
          : Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories.fromJson(
              (l$veranstaltungskalenderKategories as Map<String, dynamic>),
            ),
      veranstaltungskalenderQuellen: l$veranstaltungskalenderQuellen == null
          ? null
          : Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen.fromJson(
              (l$veranstaltungskalenderQuellen as Map<String, dynamic>),
            ),
      kommune: Query_VeranstaltungskalenderFilter_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories?
  veranstaltungskalenderKategories;

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen?
  veranstaltungskalenderQuellen;

  final Query_VeranstaltungskalenderFilter_kommune kommune;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$veranstaltungskalenderKategories = veranstaltungskalenderKategories;
    _resultData['veranstaltungskalenderKategories'] =
        l$veranstaltungskalenderKategories?.toJson();
    final l$veranstaltungskalenderQuellen = veranstaltungskalenderQuellen;
    _resultData['veranstaltungskalenderQuellen'] =
        l$veranstaltungskalenderQuellen?.toJson();
    final l$kommune = kommune;
    _resultData['kommune'] = l$kommune.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$veranstaltungskalenderKategories = veranstaltungskalenderKategories;
    final l$veranstaltungskalenderQuellen = veranstaltungskalenderQuellen;
    final l$kommune = kommune;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$veranstaltungskalenderKategories,
      l$veranstaltungskalenderQuellen,
      l$kommune,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungskalenderFilter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$veranstaltungskalenderKategories = veranstaltungskalenderKategories;
    final lOther$veranstaltungskalenderKategories =
        other.veranstaltungskalenderKategories;
    if (l$veranstaltungskalenderKategories !=
        lOther$veranstaltungskalenderKategories) {
      return false;
    }
    final l$veranstaltungskalenderQuellen = veranstaltungskalenderQuellen;
    final lOther$veranstaltungskalenderQuellen =
        other.veranstaltungskalenderQuellen;
    if (l$veranstaltungskalenderQuellen !=
        lOther$veranstaltungskalenderQuellen) {
      return false;
    }
    final l$kommune = kommune;
    final lOther$kommune = other.kommune;
    if (l$kommune != lOther$kommune) {
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

extension UtilityExtension_Query_VeranstaltungskalenderFilter
    on Query_VeranstaltungskalenderFilter {
  CopyWith_Query_VeranstaltungskalenderFilter<
    Query_VeranstaltungskalenderFilter
  >
  get copyWith => CopyWith_Query_VeranstaltungskalenderFilter(this, (i) => i);
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter<TRes> {
  factory CopyWith_Query_VeranstaltungskalenderFilter(
    Query_VeranstaltungskalenderFilter instance,
    TRes Function(Query_VeranstaltungskalenderFilter) then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter;

  factory CopyWith_Query_VeranstaltungskalenderFilter.stub(TRes res) =
      _CopyWithStubImpl_Query_VeranstaltungskalenderFilter;

  TRes call({
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories?
    veranstaltungskalenderKategories,
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen?
    veranstaltungskalenderQuellen,
    Query_VeranstaltungskalenderFilter_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
    TRes
  >
  get veranstaltungskalenderKategories;
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
    TRes
  >
  get veranstaltungskalenderQuellen;
  CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter<TRes>
    implements CopyWith_Query_VeranstaltungskalenderFilter<TRes> {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter(this._instance, this._then);

  final Query_VeranstaltungskalenderFilter _instance;

  final TRes Function(Query_VeranstaltungskalenderFilter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? veranstaltungskalenderKategories = _undefined,
    Object? veranstaltungskalenderQuellen = _undefined,
    Object? kommune = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter(
      veranstaltungskalenderKategories:
          veranstaltungskalenderKategories == _undefined
          ? _instance.veranstaltungskalenderKategories
          : (veranstaltungskalenderKategories
                as Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories?),
      veranstaltungskalenderQuellen: veranstaltungskalenderQuellen == _undefined
          ? _instance.veranstaltungskalenderQuellen
          : (veranstaltungskalenderQuellen
                as Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen?),
      kommune: kommune == _undefined || kommune == null
          ? _instance.kommune
          : (kommune as Query_VeranstaltungskalenderFilter_kommune),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
    TRes
  >
  get veranstaltungskalenderKategories {
    final local$veranstaltungskalenderKategories =
        _instance.veranstaltungskalenderKategories;
    return local$veranstaltungskalenderKategories == null
        ? CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories.stub(
            _then(_instance),
          )
        : CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
            local$veranstaltungskalenderKategories,
            (e) => call(veranstaltungskalenderKategories: e),
          );
  }

  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
    TRes
  >
  get veranstaltungskalenderQuellen {
    final local$veranstaltungskalenderQuellen =
        _instance.veranstaltungskalenderQuellen;
    return local$veranstaltungskalenderQuellen == null
        ? CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen.stub(
            _then(_instance),
          )
        : CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
            local$veranstaltungskalenderQuellen,
            (e) => call(veranstaltungskalenderQuellen: e),
          );
  }

  CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_VeranstaltungskalenderFilter_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter<TRes>
    implements CopyWith_Query_VeranstaltungskalenderFilter<TRes> {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter(this._res);

  TRes _res;

  call({
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories?
    veranstaltungskalenderKategories,
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen?
    veranstaltungskalenderQuellen,
    Query_VeranstaltungskalenderFilter_kommune? kommune,
    String? $__typename,
  }) => _res;

  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
    TRes
  >
  get veranstaltungskalenderKategories =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories.stub(
        _res,
      );

  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
    TRes
  >
  get veranstaltungskalenderQuellen =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen.stub(
        _res,
      );

  CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> get kommune =>
      CopyWith_Query_VeranstaltungskalenderFilter_kommune.stub(_res);
}

const documentNodeQueryVeranstaltungskalenderFilter = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VeranstaltungskalenderFilter'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneBereichAId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'veranstaltungskalenderKategories'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'AND'),
                      value: ListValueNode(
                        values: [
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'kommune'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'equals'),
                                      value: VariableNode(
                                        name: NameNode(value: 'kommuneId'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'filterkategorie'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'equals'),
                                      value: BooleanValueNode(value: true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '600'),
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
                        name: NameNode(value: 'label'),
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
            name: NameNode(value: 'veranstaltungskalenderQuellen'),
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
                              name: NameNode(value: 'kommuneId'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '600'),
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
            name: NameNode(value: 'kommune'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommuneId'),
                value: VariableNode(name: NameNode(value: 'kommuneBereichAId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'untereinheiten'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'where'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'isGemeinde'),
                            value: ObjectValueNode(
                              fields: [
                                ObjectFieldNode(
                                  name: NameNode(value: 'eq'),
                                  value: BooleanValueNode(value: true),
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
Query_VeranstaltungskalenderFilter _parserFn_Query_VeranstaltungskalenderFilter(
  Map<String, dynamic> data,
) => Query_VeranstaltungskalenderFilter.fromJson(data);
typedef OnQueryComplete_Query_VeranstaltungskalenderFilter =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_VeranstaltungskalenderFilter?,
    );

class Options_Query_VeranstaltungskalenderFilter
    extends graphql.QueryOptions<Query_VeranstaltungskalenderFilter> {
  Options_Query_VeranstaltungskalenderFilter({
    String? operationName,
    required Variables_Query_VeranstaltungskalenderFilter variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VeranstaltungskalenderFilter? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VeranstaltungskalenderFilter? onComplete,
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
                     : _parserFn_Query_VeranstaltungskalenderFilter(data),
               ),
         onError: onError,
         document: documentNodeQueryVeranstaltungskalenderFilter,
         parserFn: _parserFn_Query_VeranstaltungskalenderFilter,
       );

  final OnQueryComplete_Query_VeranstaltungskalenderFilter?
  onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VeranstaltungskalenderFilter
    extends graphql.WatchQueryOptions<Query_VeranstaltungskalenderFilter> {
  WatchOptions_Query_VeranstaltungskalenderFilter({
    String? operationName,
    required Variables_Query_VeranstaltungskalenderFilter variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VeranstaltungskalenderFilter? typedOptimisticResult,
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
         document: documentNodeQueryVeranstaltungskalenderFilter,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VeranstaltungskalenderFilter,
       );
}

class FetchMoreOptions_Query_VeranstaltungskalenderFilter
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VeranstaltungskalenderFilter({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_VeranstaltungskalenderFilter variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryVeranstaltungskalenderFilter,
       );
}

extension ClientExtension_Query_VeranstaltungskalenderFilter
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VeranstaltungskalenderFilter>>
  query_VeranstaltungskalenderFilter(
    Options_Query_VeranstaltungskalenderFilter options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_VeranstaltungskalenderFilter>
  watchQuery_VeranstaltungskalenderFilter(
    WatchOptions_Query_VeranstaltungskalenderFilter options,
  ) => this.watchQuery(options);

  void writeQuery_VeranstaltungskalenderFilter({
    required Query_VeranstaltungskalenderFilter data,
    required Variables_Query_VeranstaltungskalenderFilter variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryVeranstaltungskalenderFilter,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VeranstaltungskalenderFilter? readQuery_VeranstaltungskalenderFilter({
    required Variables_Query_VeranstaltungskalenderFilter variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryVeranstaltungskalenderFilter,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_VeranstaltungskalenderFilter.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VeranstaltungskalenderFilter>
useQuery_VeranstaltungskalenderFilter(
  Options_Query_VeranstaltungskalenderFilter options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_VeranstaltungskalenderFilter>
useWatchQuery_VeranstaltungskalenderFilter(
  WatchOptions_Query_VeranstaltungskalenderFilter options,
) => graphql_flutter.useWatchQuery(options);

class Query_VeranstaltungskalenderFilter_Widget
    extends graphql_flutter.Query<Query_VeranstaltungskalenderFilter> {
  Query_VeranstaltungskalenderFilter_Widget({
    widgets.Key? key,
    required Options_Query_VeranstaltungskalenderFilter options,
    required graphql_flutter.QueryBuilder<Query_VeranstaltungskalenderFilter>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories {
  Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories({
    required this.docs,
    this.$__typename = 'VeranstaltungskalenderKategories',
  });

  factory Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
  >
  docs;

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
    if (other
            is! Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories ||
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

extension UtilityExtension_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories
    on Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories {
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
  TRes
> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories
    instance,
    TRes Function(
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories;

  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories;

  TRes call({
    List<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    >?
    docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    >
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
          Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories
  _instance;

  final TRes Function(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? docs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
      docs: docs == _undefined || docs == null
          ? _instance.docs
          : (docs
                as List<
                  Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    >
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
          Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) =>
            CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories(
    this._res,
  );

  TRes _res;

  call({
    List<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    >?
    docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs {
  Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs({
    required this.id,
    required this.label,
    this.$__typename = 'VeranstaltungskalenderKategorie',
  });

  factory Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
      id: (l$id as String),
      label: (l$label as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

extension UtilityExtension_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    on Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs {
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
  TRes
> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
    instance,
    TRes Function(
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs;

  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs;

  TRes call({String? id, String? label, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs
  _instance;

  final TRes Function(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? label = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderKategories_docs(
    this._res,
  );

  TRes _res;

  call({String? id, String? label, String? $__typename}) => _res;
}

class Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen {
  Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen({
    required this.docs,
    this.$__typename = 'VeranstaltungskalenderQuellen',
  });

  factory Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
  >
  docs;

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
    if (other
            is! Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen ||
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

extension UtilityExtension_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen
    on Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen {
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
  TRes
> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen instance,
    TRes Function(
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen;

  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen;

  TRes call({
    List<Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs>?
    docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
    >
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
          Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen
  _instance;

  final TRes Function(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? docs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
      docs: docs == _undefined || docs == null
          ? _instance.docs
          : (docs
                as List<
                  Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
    >
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
          Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) =>
            CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen(
    this._res,
  );

  TRes _res;

  call({
    List<Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs>?
    docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs {
  Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs({
    required this.id,
    this.name,
    this.$__typename = 'VeranstaltungskalenderQuelle',
  });

  factory Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
      id: (l$id as String),
      name: (l$name as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
    on Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs {
  CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
  TRes
> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
    instance,
    TRes Function(
      Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs;

  factory CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs
  _instance;

  final TRes Function(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_veranstaltungskalenderQuellen_docs(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query_VeranstaltungskalenderFilter_kommune {
  Query_VeranstaltungskalenderFilter_kommune({
    required this.untereinheiten,
    this.$__typename = 'Kommune',
  });

  factory Query_VeranstaltungskalenderFilter_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$untereinheiten = json['untereinheiten'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_kommune(
      untereinheiten: (l$untereinheiten as List<dynamic>)
          .map(
            (e) =>
                Query_VeranstaltungskalenderFilter_kommune_untereinheiten.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_VeranstaltungskalenderFilter_kommune_untereinheiten>
  untereinheiten;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$untereinheiten = untereinheiten;
    _resultData['untereinheiten'] = l$untereinheiten
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$untereinheiten = untereinheiten;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$untereinheiten.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungskalenderFilter_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$untereinheiten = untereinheiten;
    final lOther$untereinheiten = other.untereinheiten;
    if (l$untereinheiten.length != lOther$untereinheiten.length) {
      return false;
    }
    for (int i = 0; i < l$untereinheiten.length; i++) {
      final l$untereinheiten$entry = l$untereinheiten[i];
      final lOther$untereinheiten$entry = lOther$untereinheiten[i];
      if (l$untereinheiten$entry != lOther$untereinheiten$entry) {
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

extension UtilityExtension_Query_VeranstaltungskalenderFilter_kommune
    on Query_VeranstaltungskalenderFilter_kommune {
  CopyWith_Query_VeranstaltungskalenderFilter_kommune<
    Query_VeranstaltungskalenderFilter_kommune
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_kommune(this, (i) => i);
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_kommune(
    Query_VeranstaltungskalenderFilter_kommune instance,
    TRes Function(Query_VeranstaltungskalenderFilter_kommune) then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune;

  factory CopyWith_Query_VeranstaltungskalenderFilter_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune;

  TRes call({
    List<Query_VeranstaltungskalenderFilter_kommune_untereinheiten>?
    untereinheiten,
    String? $__typename,
  });
  TRes untereinheiten(
    Iterable<Query_VeranstaltungskalenderFilter_kommune_untereinheiten>
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
          Query_VeranstaltungskalenderFilter_kommune_untereinheiten
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune<TRes>
    implements CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_kommune _instance;

  final TRes Function(Query_VeranstaltungskalenderFilter_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? untereinheiten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_kommune(
      untereinheiten: untereinheiten == _undefined || untereinheiten == null
          ? _instance.untereinheiten
          : (untereinheiten
                as List<
                  Query_VeranstaltungskalenderFilter_kommune_untereinheiten
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes untereinheiten(
    Iterable<Query_VeranstaltungskalenderFilter_kommune_untereinheiten>
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
          Query_VeranstaltungskalenderFilter_kommune_untereinheiten
        >
      >,
    )
    _fn,
  ) => call(
    untereinheiten: _fn(
      _instance.untereinheiten.map(
        (e) =>
            CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune<TRes>
    implements CopyWith_Query_VeranstaltungskalenderFilter_kommune<TRes> {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune(this._res);

  TRes _res;

  call({
    List<Query_VeranstaltungskalenderFilter_kommune_untereinheiten>?
    untereinheiten,
    String? $__typename,
  }) => _res;

  untereinheiten(_fn) => _res;
}

class Query_VeranstaltungskalenderFilter_kommune_untereinheiten {
  Query_VeranstaltungskalenderFilter_kommune_untereinheiten({
    required this.id,
    required this.name,
    this.$__typename = 'Untereinheit',
  });

  factory Query_VeranstaltungskalenderFilter_kommune_untereinheiten.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungskalenderFilter_kommune_untereinheiten ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_VeranstaltungskalenderFilter_kommune_untereinheiten
    on Query_VeranstaltungskalenderFilter_kommune_untereinheiten {
  CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
    Query_VeranstaltungskalenderFilter_kommune_untereinheiten
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
  TRes
> {
  factory CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
    Query_VeranstaltungskalenderFilter_kommune_untereinheiten instance,
    TRes Function(Query_VeranstaltungskalenderFilter_kommune_untereinheiten)
    then,
  ) = _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten;

  factory CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungskalenderFilter_kommune_untereinheiten _instance;

  final TRes Function(Query_VeranstaltungskalenderFilter_kommune_untereinheiten)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungskalenderFilter_kommune_untereinheiten<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungskalenderFilter_kommune_untereinheiten(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}
