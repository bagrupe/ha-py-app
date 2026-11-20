import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_Kartenlizenzen {
  factory Variables_Query_Kartenlizenzen({required String kommuneId}) =>
      Variables_Query_Kartenlizenzen._({r'kommuneId': kommuneId});

  Variables_Query_Kartenlizenzen._(this._$data);

  factory Variables_Query_Kartenlizenzen.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_Kartenlizenzen._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Kartenlizenzen<Variables_Query_Kartenlizenzen>
  get copyWith => CopyWith_Variables_Query_Kartenlizenzen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Kartenlizenzen ||
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

abstract class CopyWith_Variables_Query_Kartenlizenzen<TRes> {
  factory CopyWith_Variables_Query_Kartenlizenzen(
    Variables_Query_Kartenlizenzen instance,
    TRes Function(Variables_Query_Kartenlizenzen) then,
  ) = _CopyWithImpl_Variables_Query_Kartenlizenzen;

  factory CopyWith_Variables_Query_Kartenlizenzen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Kartenlizenzen;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_Kartenlizenzen<TRes>
    implements CopyWith_Variables_Query_Kartenlizenzen<TRes> {
  _CopyWithImpl_Variables_Query_Kartenlizenzen(this._instance, this._then);

  final Variables_Query_Kartenlizenzen _instance;

  final TRes Function(Variables_Query_Kartenlizenzen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Kartenlizenzen._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Kartenlizenzen<TRes>
    implements CopyWith_Variables_Query_Kartenlizenzen<TRes> {
  _CopyWithStubImpl_Variables_Query_Kartenlizenzen(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_Kartenlizenzen {
  Query_Kartenlizenzen({required this.kommune, this.$__typename = 'Query'});

  factory Query_Kartenlizenzen.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Kartenlizenzen(
      kommune: Query_Kartenlizenzen_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Kartenlizenzen_kommune kommune;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kommune = kommune;
    _resultData['kommune'] = l$kommune.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kommune = kommune;
    final l$$__typename = $__typename;
    return Object.hashAll([l$kommune, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Kartenlizenzen || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Kartenlizenzen on Query_Kartenlizenzen {
  CopyWith_Query_Kartenlizenzen<Query_Kartenlizenzen> get copyWith =>
      CopyWith_Query_Kartenlizenzen(this, (i) => i);
}

abstract class CopyWith_Query_Kartenlizenzen<TRes> {
  factory CopyWith_Query_Kartenlizenzen(
    Query_Kartenlizenzen instance,
    TRes Function(Query_Kartenlizenzen) then,
  ) = _CopyWithImpl_Query_Kartenlizenzen;

  factory CopyWith_Query_Kartenlizenzen.stub(TRes res) =
      _CopyWithStubImpl_Query_Kartenlizenzen;

  TRes call({Query_Kartenlizenzen_kommune? kommune, String? $__typename});
  CopyWith_Query_Kartenlizenzen_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Kartenlizenzen<TRes>
    implements CopyWith_Query_Kartenlizenzen<TRes> {
  _CopyWithImpl_Query_Kartenlizenzen(this._instance, this._then);

  final Query_Kartenlizenzen _instance;

  final TRes Function(Query_Kartenlizenzen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Kartenlizenzen(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Kartenlizenzen_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Kartenlizenzen_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Kartenlizenzen_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_Kartenlizenzen<TRes>
    implements CopyWith_Query_Kartenlizenzen<TRes> {
  _CopyWithStubImpl_Query_Kartenlizenzen(this._res);

  TRes _res;

  call({Query_Kartenlizenzen_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_Kartenlizenzen_kommune<TRes> get kommune =>
      CopyWith_Query_Kartenlizenzen_kommune.stub(_res);
}

const documentNodeQueryKartenlizenzen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Kartenlizenzen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'kommune'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommuneId'),
                value: VariableNode(name: NameNode(value: 'kommuneId')),
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
                  name: NameNode(value: 'lizenzen'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'kartenlizenzenHtml'),
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
Query_Kartenlizenzen _parserFn_Query_Kartenlizenzen(
  Map<String, dynamic> data,
) => Query_Kartenlizenzen.fromJson(data);
typedef OnQueryComplete_Query_Kartenlizenzen =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Kartenlizenzen?);

class Options_Query_Kartenlizenzen
    extends graphql.QueryOptions<Query_Kartenlizenzen> {
  Options_Query_Kartenlizenzen({
    String? operationName,
    required Variables_Query_Kartenlizenzen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Kartenlizenzen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Kartenlizenzen? onComplete,
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
                 data == null ? null : _parserFn_Query_Kartenlizenzen(data),
               ),
         onError: onError,
         document: documentNodeQueryKartenlizenzen,
         parserFn: _parserFn_Query_Kartenlizenzen,
       );

  final OnQueryComplete_Query_Kartenlizenzen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Kartenlizenzen
    extends graphql.WatchQueryOptions<Query_Kartenlizenzen> {
  WatchOptions_Query_Kartenlizenzen({
    String? operationName,
    required Variables_Query_Kartenlizenzen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Kartenlizenzen? typedOptimisticResult,
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
         document: documentNodeQueryKartenlizenzen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Kartenlizenzen,
       );
}

class FetchMoreOptions_Query_Kartenlizenzen extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Kartenlizenzen({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Kartenlizenzen variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryKartenlizenzen,
       );
}

extension ClientExtension_Query_Kartenlizenzen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Kartenlizenzen>> query_Kartenlizenzen(
    Options_Query_Kartenlizenzen options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Kartenlizenzen> watchQuery_Kartenlizenzen(
    WatchOptions_Query_Kartenlizenzen options,
  ) => this.watchQuery(options);

  void writeQuery_Kartenlizenzen({
    required Query_Kartenlizenzen data,
    required Variables_Query_Kartenlizenzen variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryKartenlizenzen),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Kartenlizenzen? readQuery_Kartenlizenzen({
    required Variables_Query_Kartenlizenzen variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryKartenlizenzen),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Kartenlizenzen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Kartenlizenzen> useQuery_Kartenlizenzen(
  Options_Query_Kartenlizenzen options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Kartenlizenzen> useWatchQuery_Kartenlizenzen(
  WatchOptions_Query_Kartenlizenzen options,
) => graphql_flutter.useWatchQuery(options);

class Query_Kartenlizenzen_Widget
    extends graphql_flutter.Query<Query_Kartenlizenzen> {
  Query_Kartenlizenzen_Widget({
    widgets.Key? key,
    required Options_Query_Kartenlizenzen options,
    required graphql_flutter.QueryBuilder<Query_Kartenlizenzen> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Kartenlizenzen_kommune {
  Query_Kartenlizenzen_kommune({
    required this.id,
    required this.lizenzen,
    this.$__typename = 'Kommune',
  });

  factory Query_Kartenlizenzen_kommune.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$lizenzen = json['lizenzen'];
    final l$$__typename = json['__typename'];
    return Query_Kartenlizenzen_kommune(
      id: (l$id as String),
      lizenzen: Query_Kartenlizenzen_kommune_lizenzen.fromJson(
        (l$lizenzen as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query_Kartenlizenzen_kommune_lizenzen lizenzen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$lizenzen = lizenzen;
    _resultData['lizenzen'] = l$lizenzen.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$lizenzen = lizenzen;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$lizenzen, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Kartenlizenzen_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$lizenzen = lizenzen;
    final lOther$lizenzen = other.lizenzen;
    if (l$lizenzen != lOther$lizenzen) {
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

extension UtilityExtension_Query_Kartenlizenzen_kommune
    on Query_Kartenlizenzen_kommune {
  CopyWith_Query_Kartenlizenzen_kommune<Query_Kartenlizenzen_kommune>
  get copyWith => CopyWith_Query_Kartenlizenzen_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Kartenlizenzen_kommune<TRes> {
  factory CopyWith_Query_Kartenlizenzen_kommune(
    Query_Kartenlizenzen_kommune instance,
    TRes Function(Query_Kartenlizenzen_kommune) then,
  ) = _CopyWithImpl_Query_Kartenlizenzen_kommune;

  factory CopyWith_Query_Kartenlizenzen_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Kartenlizenzen_kommune;

  TRes call({
    String? id,
    Query_Kartenlizenzen_kommune_lizenzen? lizenzen,
    String? $__typename,
  });
  CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> get lizenzen;
}

class _CopyWithImpl_Query_Kartenlizenzen_kommune<TRes>
    implements CopyWith_Query_Kartenlizenzen_kommune<TRes> {
  _CopyWithImpl_Query_Kartenlizenzen_kommune(this._instance, this._then);

  final Query_Kartenlizenzen_kommune _instance;

  final TRes Function(Query_Kartenlizenzen_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? lizenzen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Kartenlizenzen_kommune(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      lizenzen: lizenzen == _undefined || lizenzen == null
          ? _instance.lizenzen
          : (lizenzen as Query_Kartenlizenzen_kommune_lizenzen),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> get lizenzen {
    final local$lizenzen = _instance.lizenzen;
    return CopyWith_Query_Kartenlizenzen_kommune_lizenzen(
      local$lizenzen,
      (e) => call(lizenzen: e),
    );
  }
}

class _CopyWithStubImpl_Query_Kartenlizenzen_kommune<TRes>
    implements CopyWith_Query_Kartenlizenzen_kommune<TRes> {
  _CopyWithStubImpl_Query_Kartenlizenzen_kommune(this._res);

  TRes _res;

  call({
    String? id,
    Query_Kartenlizenzen_kommune_lizenzen? lizenzen,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> get lizenzen =>
      CopyWith_Query_Kartenlizenzen_kommune_lizenzen.stub(_res);
}

class Query_Kartenlizenzen_kommune_lizenzen {
  Query_Kartenlizenzen_kommune_lizenzen({
    this.kartenlizenzenHtml,
    this.$__typename = 'BereichBKommune_Lizenzen',
  });

  factory Query_Kartenlizenzen_kommune_lizenzen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kartenlizenzenHtml = json['kartenlizenzenHtml'];
    final l$$__typename = json['__typename'];
    return Query_Kartenlizenzen_kommune_lizenzen(
      kartenlizenzenHtml: (l$kartenlizenzenHtml as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kartenlizenzenHtml;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kartenlizenzenHtml = kartenlizenzenHtml;
    _resultData['kartenlizenzenHtml'] = l$kartenlizenzenHtml;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kartenlizenzenHtml = kartenlizenzenHtml;
    final l$$__typename = $__typename;
    return Object.hashAll([l$kartenlizenzenHtml, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Kartenlizenzen_kommune_lizenzen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kartenlizenzenHtml = kartenlizenzenHtml;
    final lOther$kartenlizenzenHtml = other.kartenlizenzenHtml;
    if (l$kartenlizenzenHtml != lOther$kartenlizenzenHtml) {
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

extension UtilityExtension_Query_Kartenlizenzen_kommune_lizenzen
    on Query_Kartenlizenzen_kommune_lizenzen {
  CopyWith_Query_Kartenlizenzen_kommune_lizenzen<
    Query_Kartenlizenzen_kommune_lizenzen
  >
  get copyWith =>
      CopyWith_Query_Kartenlizenzen_kommune_lizenzen(this, (i) => i);
}

abstract class CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> {
  factory CopyWith_Query_Kartenlizenzen_kommune_lizenzen(
    Query_Kartenlizenzen_kommune_lizenzen instance,
    TRes Function(Query_Kartenlizenzen_kommune_lizenzen) then,
  ) = _CopyWithImpl_Query_Kartenlizenzen_kommune_lizenzen;

  factory CopyWith_Query_Kartenlizenzen_kommune_lizenzen.stub(TRes res) =
      _CopyWithStubImpl_Query_Kartenlizenzen_kommune_lizenzen;

  TRes call({String? kartenlizenzenHtml, String? $__typename});
}

class _CopyWithImpl_Query_Kartenlizenzen_kommune_lizenzen<TRes>
    implements CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> {
  _CopyWithImpl_Query_Kartenlizenzen_kommune_lizenzen(
    this._instance,
    this._then,
  );

  final Query_Kartenlizenzen_kommune_lizenzen _instance;

  final TRes Function(Query_Kartenlizenzen_kommune_lizenzen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kartenlizenzenHtml = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Kartenlizenzen_kommune_lizenzen(
      kartenlizenzenHtml: kartenlizenzenHtml == _undefined
          ? _instance.kartenlizenzenHtml
          : (kartenlizenzenHtml as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Kartenlizenzen_kommune_lizenzen<TRes>
    implements CopyWith_Query_Kartenlizenzen_kommune_lizenzen<TRes> {
  _CopyWithStubImpl_Query_Kartenlizenzen_kommune_lizenzen(this._res);

  TRes _res;

  call({String? kartenlizenzenHtml, String? $__typename}) => _res;
}
