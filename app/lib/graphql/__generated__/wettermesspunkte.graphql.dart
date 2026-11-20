import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_Wettermesspunkte {
  factory Variables_Query_Wettermesspunkte({required dynamic kommuneId}) =>
      Variables_Query_Wettermesspunkte._({r'kommuneId': kommuneId});

  Variables_Query_Wettermesspunkte._(this._$data);

  factory Variables_Query_Wettermesspunkte.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as dynamic);
    return Variables_Query_Wettermesspunkte._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic get kommuneId => (_$data['kommuneId'] as dynamic);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Wettermesspunkte<Variables_Query_Wettermesspunkte>
  get copyWith => CopyWith_Variables_Query_Wettermesspunkte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Wettermesspunkte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    return Object.hashAll([l$kommuneId]);
  }
}

abstract class CopyWith_Variables_Query_Wettermesspunkte<TRes> {
  factory CopyWith_Variables_Query_Wettermesspunkte(
    Variables_Query_Wettermesspunkte instance,
    TRes Function(Variables_Query_Wettermesspunkte) then,
  ) = _CopyWithImpl_Variables_Query_Wettermesspunkte;

  factory CopyWith_Variables_Query_Wettermesspunkte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Wettermesspunkte;

  TRes call({dynamic? kommuneId});
}

class _CopyWithImpl_Variables_Query_Wettermesspunkte<TRes>
    implements CopyWith_Variables_Query_Wettermesspunkte<TRes> {
  _CopyWithImpl_Variables_Query_Wettermesspunkte(this._instance, this._then);

  final Variables_Query_Wettermesspunkte _instance;

  final TRes Function(Variables_Query_Wettermesspunkte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Wettermesspunkte._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as dynamic),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Wettermesspunkte<TRes>
    implements CopyWith_Variables_Query_Wettermesspunkte<TRes> {
  _CopyWithStubImpl_Variables_Query_Wettermesspunkte(this._res);

  TRes _res;

  call({dynamic? kommuneId}) => _res;
}

class Query_Wettermesspunkte {
  Query_Wettermesspunkte({
    this.wettermesspunkteList,
    this.$__typename = 'Query',
  });

  factory Query_Wettermesspunkte.fromJson(Map<String, dynamic> json) {
    final l$wettermesspunkteList = json['wettermesspunkteList'];
    final l$$__typename = json['__typename'];
    return Query_Wettermesspunkte(
      wettermesspunkteList: l$wettermesspunkteList == null
          ? null
          : Query_Wettermesspunkte_wettermesspunkteList.fromJson(
              (l$wettermesspunkteList as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Wettermesspunkte_wettermesspunkteList? wettermesspunkteList;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$wettermesspunkteList = wettermesspunkteList;
    _resultData['wettermesspunkteList'] = l$wettermesspunkteList?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$wettermesspunkteList = wettermesspunkteList;
    final l$$__typename = $__typename;
    return Object.hashAll([l$wettermesspunkteList, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Wettermesspunkte || runtimeType != other.runtimeType) {
      return false;
    }
    final l$wettermesspunkteList = wettermesspunkteList;
    final lOther$wettermesspunkteList = other.wettermesspunkteList;
    if (l$wettermesspunkteList != lOther$wettermesspunkteList) {
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

extension UtilityExtension_Query_Wettermesspunkte on Query_Wettermesspunkte {
  CopyWith_Query_Wettermesspunkte<Query_Wettermesspunkte> get copyWith =>
      CopyWith_Query_Wettermesspunkte(this, (i) => i);
}

abstract class CopyWith_Query_Wettermesspunkte<TRes> {
  factory CopyWith_Query_Wettermesspunkte(
    Query_Wettermesspunkte instance,
    TRes Function(Query_Wettermesspunkte) then,
  ) = _CopyWithImpl_Query_Wettermesspunkte;

  factory CopyWith_Query_Wettermesspunkte.stub(TRes res) =
      _CopyWithStubImpl_Query_Wettermesspunkte;

  TRes call({
    Query_Wettermesspunkte_wettermesspunkteList? wettermesspunkteList,
    String? $__typename,
  });
  CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes>
  get wettermesspunkteList;
}

class _CopyWithImpl_Query_Wettermesspunkte<TRes>
    implements CopyWith_Query_Wettermesspunkte<TRes> {
  _CopyWithImpl_Query_Wettermesspunkte(this._instance, this._then);

  final Query_Wettermesspunkte _instance;

  final TRes Function(Query_Wettermesspunkte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? wettermesspunkteList = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Wettermesspunkte(
      wettermesspunkteList: wettermesspunkteList == _undefined
          ? _instance.wettermesspunkteList
          : (wettermesspunkteList
                as Query_Wettermesspunkte_wettermesspunkteList?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes>
  get wettermesspunkteList {
    final local$wettermesspunkteList = _instance.wettermesspunkteList;
    return local$wettermesspunkteList == null
        ? CopyWith_Query_Wettermesspunkte_wettermesspunkteList.stub(
            _then(_instance),
          )
        : CopyWith_Query_Wettermesspunkte_wettermesspunkteList(
            local$wettermesspunkteList,
            (e) => call(wettermesspunkteList: e),
          );
  }
}

class _CopyWithStubImpl_Query_Wettermesspunkte<TRes>
    implements CopyWith_Query_Wettermesspunkte<TRes> {
  _CopyWithStubImpl_Query_Wettermesspunkte(this._res);

  TRes _res;

  call({
    Query_Wettermesspunkte_wettermesspunkteList? wettermesspunkteList,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes>
  get wettermesspunkteList =>
      CopyWith_Query_Wettermesspunkte_wettermesspunkteList.stub(_res);
}

const documentNodeQueryWettermesspunkte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Wettermesspunkte'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'wettermesspunkteList'),
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
                        name: NameNode(value: 'location'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'locationName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'weather'),
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
                              name: NameNode(value: 'icon'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'date'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'minTemp'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'maxTemp'),
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
Query_Wettermesspunkte _parserFn_Query_Wettermesspunkte(
  Map<String, dynamic> data,
) => Query_Wettermesspunkte.fromJson(data);
typedef OnQueryComplete_Query_Wettermesspunkte =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Wettermesspunkte?);

class Options_Query_Wettermesspunkte
    extends graphql.QueryOptions<Query_Wettermesspunkte> {
  Options_Query_Wettermesspunkte({
    String? operationName,
    required Variables_Query_Wettermesspunkte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Wettermesspunkte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Wettermesspunkte? onComplete,
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
                 data == null ? null : _parserFn_Query_Wettermesspunkte(data),
               ),
         onError: onError,
         document: documentNodeQueryWettermesspunkte,
         parserFn: _parserFn_Query_Wettermesspunkte,
       );

  final OnQueryComplete_Query_Wettermesspunkte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Wettermesspunkte
    extends graphql.WatchQueryOptions<Query_Wettermesspunkte> {
  WatchOptions_Query_Wettermesspunkte({
    String? operationName,
    required Variables_Query_Wettermesspunkte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Wettermesspunkte? typedOptimisticResult,
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
         document: documentNodeQueryWettermesspunkte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Wettermesspunkte,
       );
}

class FetchMoreOptions_Query_Wettermesspunkte extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Wettermesspunkte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Wettermesspunkte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryWettermesspunkte,
       );
}

extension ClientExtension_Query_Wettermesspunkte on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Wettermesspunkte>> query_Wettermesspunkte(
    Options_Query_Wettermesspunkte options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Wettermesspunkte> watchQuery_Wettermesspunkte(
    WatchOptions_Query_Wettermesspunkte options,
  ) => this.watchQuery(options);

  void writeQuery_Wettermesspunkte({
    required Query_Wettermesspunkte data,
    required Variables_Query_Wettermesspunkte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryWettermesspunkte),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Wettermesspunkte? readQuery_Wettermesspunkte({
    required Variables_Query_Wettermesspunkte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryWettermesspunkte,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Wettermesspunkte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Wettermesspunkte>
useQuery_Wettermesspunkte(Options_Query_Wettermesspunkte options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Wettermesspunkte> useWatchQuery_Wettermesspunkte(
  WatchOptions_Query_Wettermesspunkte options,
) => graphql_flutter.useWatchQuery(options);

class Query_Wettermesspunkte_Widget
    extends graphql_flutter.Query<Query_Wettermesspunkte> {
  Query_Wettermesspunkte_Widget({
    widgets.Key? key,
    required Options_Query_Wettermesspunkte options,
    required graphql_flutter.QueryBuilder<Query_Wettermesspunkte> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Wettermesspunkte_wettermesspunkteList {
  Query_Wettermesspunkte_wettermesspunkteList({
    required this.docs,
    this.$__typename = 'Wettermesspunktes',
  });

  factory Query_Wettermesspunkte_wettermesspunkteList.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_Wettermesspunkte_wettermesspunkteList(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_Wettermesspunkte_wettermesspunkteList_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_Wettermesspunkte_wettermesspunkteList_docs> docs;

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
    if (other is! Query_Wettermesspunkte_wettermesspunkteList ||
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

extension UtilityExtension_Query_Wettermesspunkte_wettermesspunkteList
    on Query_Wettermesspunkte_wettermesspunkteList {
  CopyWith_Query_Wettermesspunkte_wettermesspunkteList<
    Query_Wettermesspunkte_wettermesspunkteList
  >
  get copyWith =>
      CopyWith_Query_Wettermesspunkte_wettermesspunkteList(this, (i) => i);
}

abstract class CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes> {
  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList(
    Query_Wettermesspunkte_wettermesspunkteList instance,
    TRes Function(Query_Wettermesspunkte_wettermesspunkteList) then,
  ) = _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList;

  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList.stub(TRes res) =
      _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList;

  TRes call({
    List<Query_Wettermesspunkte_wettermesspunkteList_docs>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_Wettermesspunkte_wettermesspunkteList_docs> Function(
      Iterable<
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<
          Query_Wettermesspunkte_wettermesspunkteList_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList<TRes>
    implements CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes> {
  _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList(
    this._instance,
    this._then,
  );

  final Query_Wettermesspunkte_wettermesspunkteList _instance;

  final TRes Function(Query_Wettermesspunkte_wettermesspunkteList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Wettermesspunkte_wettermesspunkteList(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs
                    as List<Query_Wettermesspunkte_wettermesspunkteList_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_Wettermesspunkte_wettermesspunkteList_docs> Function(
      Iterable<
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<
          Query_Wettermesspunkte_wettermesspunkteList_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList<TRes>
    implements CopyWith_Query_Wettermesspunkte_wettermesspunkteList<TRes> {
  _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList(this._res);

  TRes _res;

  call({
    List<Query_Wettermesspunkte_wettermesspunkteList_docs>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_Wettermesspunkte_wettermesspunkteList_docs {
  Query_Wettermesspunkte_wettermesspunkteList_docs({
    required this.id,
    required this.location,
    required this.locationName,
    required this.weather,
    this.$__typename = 'Wettermesspunkte',
  });

  factory Query_Wettermesspunkte_wettermesspunkteList_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$location = json['location'];
    final l$locationName = json['locationName'];
    final l$weather = json['weather'];
    final l$$__typename = json['__typename'];
    return Query_Wettermesspunkte_wettermesspunkteList_docs(
      id: (l$id as String),
      location: (l$location as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      locationName: (l$locationName as String),
      weather: (l$weather as List<dynamic>)
          .map(
            (e) =>
                Query_Wettermesspunkte_wettermesspunkteList_docs_weather.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<double> location;

  final String locationName;

  final List<Query_Wettermesspunkte_wettermesspunkteList_docs_weather> weather;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$location = location;
    _resultData['location'] = l$location.map((e) => e).toList();
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$weather = weather;
    _resultData['weather'] = l$weather.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$location = location;
    final l$locationName = locationName;
    final l$weather = weather;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$location.map((v) => v)),
      l$locationName,
      Object.hashAll(l$weather.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Wettermesspunkte_wettermesspunkteList_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$location = location;
    final lOther$location = other.location;
    if (l$location.length != lOther$location.length) {
      return false;
    }
    for (int i = 0; i < l$location.length; i++) {
      final l$location$entry = l$location[i];
      final lOther$location$entry = lOther$location[i];
      if (l$location$entry != lOther$location$entry) {
        return false;
      }
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$weather = weather;
    final lOther$weather = other.weather;
    if (l$weather.length != lOther$weather.length) {
      return false;
    }
    for (int i = 0; i < l$weather.length; i++) {
      final l$weather$entry = l$weather[i];
      final lOther$weather$entry = lOther$weather[i];
      if (l$weather$entry != lOther$weather$entry) {
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

extension UtilityExtension_Query_Wettermesspunkte_wettermesspunkteList_docs
    on Query_Wettermesspunkte_wettermesspunkteList_docs {
  CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<
    Query_Wettermesspunkte_wettermesspunkteList_docs
  >
  get copyWith =>
      CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs(this, (i) => i);
}

abstract class CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<TRes> {
  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs(
    Query_Wettermesspunkte_wettermesspunkteList_docs instance,
    TRes Function(Query_Wettermesspunkte_wettermesspunkteList_docs) then,
  ) = _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs;

  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs;

  TRes call({
    String? id,
    List<double>? location,
    String? locationName,
    List<Query_Wettermesspunkte_wettermesspunkteList_docs_weather>? weather,
    String? $__typename,
  });
  TRes weather(
    Iterable<Query_Wettermesspunkte_wettermesspunkteList_docs_weather> Function(
      Iterable<
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
          Query_Wettermesspunkte_wettermesspunkteList_docs_weather
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs<TRes>
    implements CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<TRes> {
  _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs(
    this._instance,
    this._then,
  );

  final Query_Wettermesspunkte_wettermesspunkteList_docs _instance;

  final TRes Function(Query_Wettermesspunkte_wettermesspunkteList_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? location = _undefined,
    Object? locationName = _undefined,
    Object? weather = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Wettermesspunkte_wettermesspunkteList_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      location: location == _undefined || location == null
          ? _instance.location
          : (location as List<double>),
      locationName: locationName == _undefined || locationName == null
          ? _instance.locationName
          : (locationName as String),
      weather: weather == _undefined || weather == null
          ? _instance.weather
          : (weather
                as List<
                  Query_Wettermesspunkte_wettermesspunkteList_docs_weather
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes weather(
    Iterable<Query_Wettermesspunkte_wettermesspunkteList_docs_weather> Function(
      Iterable<
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
          Query_Wettermesspunkte_wettermesspunkteList_docs_weather
        >
      >,
    )
    _fn,
  ) => call(
    weather: _fn(
      _instance.weather.map(
        (e) =>
            CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs<TRes>
    implements CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs<TRes> {
  _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs(this._res);

  TRes _res;

  call({
    String? id,
    List<double>? location,
    String? locationName,
    List<Query_Wettermesspunkte_wettermesspunkteList_docs_weather>? weather,
    String? $__typename,
  }) => _res;

  weather(_fn) => _res;
}

class Query_Wettermesspunkte_wettermesspunkteList_docs_weather {
  Query_Wettermesspunkte_wettermesspunkteList_docs_weather({
    this.id,
    this.icon,
    this.date,
    this.minTemp,
    this.maxTemp,
    this.$__typename = 'Wettermesspunkte_Weather',
  });

  factory Query_Wettermesspunkte_wettermesspunkteList_docs_weather.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$date = json['date'];
    final l$minTemp = json['minTemp'];
    final l$maxTemp = json['maxTemp'];
    final l$$__typename = json['__typename'];
    return Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
      id: (l$id as String?),
      icon: (l$icon as String?),
      date: l$date == null ? null : DateTime.parse((l$date as String)),
      minTemp: (l$minTemp as num?)?.toDouble(),
      maxTemp: (l$maxTemp as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? icon;

  final DateTime? date;

  final double? minTemp;

  final double? maxTemp;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$icon = icon;
    _resultData['icon'] = l$icon;
    final l$date = date;
    _resultData['date'] = l$date?.toIso8601String();
    final l$minTemp = minTemp;
    _resultData['minTemp'] = l$minTemp;
    final l$maxTemp = maxTemp;
    _resultData['maxTemp'] = l$maxTemp;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$icon = icon;
    final l$date = date;
    final l$minTemp = minTemp;
    final l$maxTemp = maxTemp;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$icon,
      l$date,
      l$minTemp,
      l$maxTemp,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Wettermesspunkte_wettermesspunkteList_docs_weather ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (l$date != lOther$date) {
      return false;
    }
    final l$minTemp = minTemp;
    final lOther$minTemp = other.minTemp;
    if (l$minTemp != lOther$minTemp) {
      return false;
    }
    final l$maxTemp = maxTemp;
    final lOther$maxTemp = other.maxTemp;
    if (l$maxTemp != lOther$maxTemp) {
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

extension UtilityExtension_Query_Wettermesspunkte_wettermesspunkteList_docs_weather
    on Query_Wettermesspunkte_wettermesspunkteList_docs_weather {
  CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
    Query_Wettermesspunkte_wettermesspunkteList_docs_weather
  >
  get copyWith =>
      CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
  TRes
> {
  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
    Query_Wettermesspunkte_wettermesspunkteList_docs_weather instance,
    TRes Function(Query_Wettermesspunkte_wettermesspunkteList_docs_weather)
    then,
  ) = _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather;

  factory CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather;

  TRes call({
    String? id,
    String? icon,
    DateTime? date,
    double? minTemp,
    double? maxTemp,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
  TRes
>
    implements
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
          TRes
        > {
  _CopyWithImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
    this._instance,
    this._then,
  );

  final Query_Wettermesspunkte_wettermesspunkteList_docs_weather _instance;

  final TRes Function(Query_Wettermesspunkte_wettermesspunkteList_docs_weather)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? date = _undefined,
    Object? minTemp = _undefined,
    Object? maxTemp = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
      id: id == _undefined ? _instance.id : (id as String?),
      icon: icon == _undefined ? _instance.icon : (icon as String?),
      date: date == _undefined ? _instance.date : (date as DateTime?),
      minTemp: minTemp == _undefined ? _instance.minTemp : (minTemp as double?),
      maxTemp: maxTemp == _undefined ? _instance.maxTemp : (maxTemp as double?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
  TRes
>
    implements
        CopyWith_Query_Wettermesspunkte_wettermesspunkteList_docs_weather<
          TRes
        > {
  _CopyWithStubImpl_Query_Wettermesspunkte_wettermesspunkteList_docs_weather(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? icon,
    DateTime? date,
    double? minTemp,
    double? maxTemp,
    String? $__typename,
  }) => _res;
}
