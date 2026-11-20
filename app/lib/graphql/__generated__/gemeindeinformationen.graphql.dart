import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_Gemeindeinformationen {
  factory Variables_Query_Gemeindeinformationen({required String kommuneId}) =>
      Variables_Query_Gemeindeinformationen._({r'kommuneId': kommuneId});

  Variables_Query_Gemeindeinformationen._(this._$data);

  factory Variables_Query_Gemeindeinformationen.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_Gemeindeinformationen._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Gemeindeinformationen<
    Variables_Query_Gemeindeinformationen
  >
  get copyWith =>
      CopyWith_Variables_Query_Gemeindeinformationen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Gemeindeinformationen ||
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

abstract class CopyWith_Variables_Query_Gemeindeinformationen<TRes> {
  factory CopyWith_Variables_Query_Gemeindeinformationen(
    Variables_Query_Gemeindeinformationen instance,
    TRes Function(Variables_Query_Gemeindeinformationen) then,
  ) = _CopyWithImpl_Variables_Query_Gemeindeinformationen;

  factory CopyWith_Variables_Query_Gemeindeinformationen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Gemeindeinformationen;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_Gemeindeinformationen<TRes>
    implements CopyWith_Variables_Query_Gemeindeinformationen<TRes> {
  _CopyWithImpl_Variables_Query_Gemeindeinformationen(
    this._instance,
    this._then,
  );

  final Variables_Query_Gemeindeinformationen _instance;

  final TRes Function(Variables_Query_Gemeindeinformationen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Gemeindeinformationen._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Gemeindeinformationen<TRes>
    implements CopyWith_Variables_Query_Gemeindeinformationen<TRes> {
  _CopyWithStubImpl_Variables_Query_Gemeindeinformationen(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_Gemeindeinformationen {
  Query_Gemeindeinformationen({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_Gemeindeinformationen.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Gemeindeinformationen(
      kommune: Query_Gemeindeinformationen_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Gemeindeinformationen_kommune kommune;

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
    if (other is! Query_Gemeindeinformationen ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Gemeindeinformationen
    on Query_Gemeindeinformationen {
  CopyWith_Query_Gemeindeinformationen<Query_Gemeindeinformationen>
  get copyWith => CopyWith_Query_Gemeindeinformationen(this, (i) => i);
}

abstract class CopyWith_Query_Gemeindeinformationen<TRes> {
  factory CopyWith_Query_Gemeindeinformationen(
    Query_Gemeindeinformationen instance,
    TRes Function(Query_Gemeindeinformationen) then,
  ) = _CopyWithImpl_Query_Gemeindeinformationen;

  factory CopyWith_Query_Gemeindeinformationen.stub(TRes res) =
      _CopyWithStubImpl_Query_Gemeindeinformationen;

  TRes call({
    Query_Gemeindeinformationen_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_Gemeindeinformationen_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Gemeindeinformationen<TRes>
    implements CopyWith_Query_Gemeindeinformationen<TRes> {
  _CopyWithImpl_Query_Gemeindeinformationen(this._instance, this._then);

  final Query_Gemeindeinformationen _instance;

  final TRes Function(Query_Gemeindeinformationen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Gemeindeinformationen(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Gemeindeinformationen_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Gemeindeinformationen_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Gemeindeinformationen_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_Gemeindeinformationen<TRes>
    implements CopyWith_Query_Gemeindeinformationen<TRes> {
  _CopyWithStubImpl_Query_Gemeindeinformationen(this._res);

  TRes _res;

  call({Query_Gemeindeinformationen_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_Gemeindeinformationen_kommune<TRes> get kommune =>
      CopyWith_Query_Gemeindeinformationen_kommune.stub(_res);
}

const documentNodeQueryGemeindeinformationen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Gemeindeinformationen'),
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
                        name: NameNode(value: 'newsNotificationsEnabled'),
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
Query_Gemeindeinformationen _parserFn_Query_Gemeindeinformationen(
  Map<String, dynamic> data,
) => Query_Gemeindeinformationen.fromJson(data);
typedef OnQueryComplete_Query_Gemeindeinformationen =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_Gemeindeinformationen?,
    );

class Options_Query_Gemeindeinformationen
    extends graphql.QueryOptions<Query_Gemeindeinformationen> {
  Options_Query_Gemeindeinformationen({
    String? operationName,
    required Variables_Query_Gemeindeinformationen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Gemeindeinformationen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Gemeindeinformationen? onComplete,
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
                     : _parserFn_Query_Gemeindeinformationen(data),
               ),
         onError: onError,
         document: documentNodeQueryGemeindeinformationen,
         parserFn: _parserFn_Query_Gemeindeinformationen,
       );

  final OnQueryComplete_Query_Gemeindeinformationen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Gemeindeinformationen
    extends graphql.WatchQueryOptions<Query_Gemeindeinformationen> {
  WatchOptions_Query_Gemeindeinformationen({
    String? operationName,
    required Variables_Query_Gemeindeinformationen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Gemeindeinformationen? typedOptimisticResult,
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
         document: documentNodeQueryGemeindeinformationen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Gemeindeinformationen,
       );
}

class FetchMoreOptions_Query_Gemeindeinformationen
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Gemeindeinformationen({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Gemeindeinformationen variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGemeindeinformationen,
       );
}

extension ClientExtension_Query_Gemeindeinformationen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Gemeindeinformationen>>
  query_Gemeindeinformationen(
    Options_Query_Gemeindeinformationen options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Gemeindeinformationen>
  watchQuery_Gemeindeinformationen(
    WatchOptions_Query_Gemeindeinformationen options,
  ) => this.watchQuery(options);

  void writeQuery_Gemeindeinformationen({
    required Query_Gemeindeinformationen data,
    required Variables_Query_Gemeindeinformationen variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGemeindeinformationen,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Gemeindeinformationen? readQuery_Gemeindeinformationen({
    required Variables_Query_Gemeindeinformationen variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGemeindeinformationen,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Gemeindeinformationen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Gemeindeinformationen>
useQuery_Gemeindeinformationen(Options_Query_Gemeindeinformationen options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Gemeindeinformationen>
useWatchQuery_Gemeindeinformationen(
  WatchOptions_Query_Gemeindeinformationen options,
) => graphql_flutter.useWatchQuery(options);

class Query_Gemeindeinformationen_Widget
    extends graphql_flutter.Query<Query_Gemeindeinformationen> {
  Query_Gemeindeinformationen_Widget({
    widgets.Key? key,
    required Options_Query_Gemeindeinformationen options,
    required graphql_flutter.QueryBuilder<Query_Gemeindeinformationen> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Gemeindeinformationen_kommune {
  Query_Gemeindeinformationen_kommune({
    required this.untereinheiten,
    this.$__typename = 'Kommune',
  });

  factory Query_Gemeindeinformationen_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$untereinheiten = json['untereinheiten'];
    final l$$__typename = json['__typename'];
    return Query_Gemeindeinformationen_kommune(
      untereinheiten: (l$untereinheiten as List<dynamic>)
          .map(
            (e) => Query_Gemeindeinformationen_kommune_untereinheiten.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_Gemeindeinformationen_kommune_untereinheiten> untereinheiten;

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
    if (other is! Query_Gemeindeinformationen_kommune ||
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

extension UtilityExtension_Query_Gemeindeinformationen_kommune
    on Query_Gemeindeinformationen_kommune {
  CopyWith_Query_Gemeindeinformationen_kommune<
    Query_Gemeindeinformationen_kommune
  >
  get copyWith => CopyWith_Query_Gemeindeinformationen_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Gemeindeinformationen_kommune<TRes> {
  factory CopyWith_Query_Gemeindeinformationen_kommune(
    Query_Gemeindeinformationen_kommune instance,
    TRes Function(Query_Gemeindeinformationen_kommune) then,
  ) = _CopyWithImpl_Query_Gemeindeinformationen_kommune;

  factory CopyWith_Query_Gemeindeinformationen_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Gemeindeinformationen_kommune;

  TRes call({
    List<Query_Gemeindeinformationen_kommune_untereinheiten>? untereinheiten,
    String? $__typename,
  });
  TRes untereinheiten(
    Iterable<Query_Gemeindeinformationen_kommune_untereinheiten> Function(
      Iterable<
        CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<
          Query_Gemeindeinformationen_kommune_untereinheiten
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Gemeindeinformationen_kommune<TRes>
    implements CopyWith_Query_Gemeindeinformationen_kommune<TRes> {
  _CopyWithImpl_Query_Gemeindeinformationen_kommune(this._instance, this._then);

  final Query_Gemeindeinformationen_kommune _instance;

  final TRes Function(Query_Gemeindeinformationen_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? untereinheiten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Gemeindeinformationen_kommune(
      untereinheiten: untereinheiten == _undefined || untereinheiten == null
          ? _instance.untereinheiten
          : (untereinheiten
                as List<Query_Gemeindeinformationen_kommune_untereinheiten>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes untereinheiten(
    Iterable<Query_Gemeindeinformationen_kommune_untereinheiten> Function(
      Iterable<
        CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<
          Query_Gemeindeinformationen_kommune_untereinheiten
        >
      >,
    )
    _fn,
  ) => call(
    untereinheiten: _fn(
      _instance.untereinheiten.map(
        (e) => CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Gemeindeinformationen_kommune<TRes>
    implements CopyWith_Query_Gemeindeinformationen_kommune<TRes> {
  _CopyWithStubImpl_Query_Gemeindeinformationen_kommune(this._res);

  TRes _res;

  call({
    List<Query_Gemeindeinformationen_kommune_untereinheiten>? untereinheiten,
    String? $__typename,
  }) => _res;

  untereinheiten(_fn) => _res;
}

class Query_Gemeindeinformationen_kommune_untereinheiten {
  Query_Gemeindeinformationen_kommune_untereinheiten({
    required this.id,
    required this.name,
    required this.newsNotificationsEnabled,
    this.$__typename = 'Untereinheit',
  });

  factory Query_Gemeindeinformationen_kommune_untereinheiten.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$newsNotificationsEnabled = json['newsNotificationsEnabled'];
    final l$$__typename = json['__typename'];
    return Query_Gemeindeinformationen_kommune_untereinheiten(
      id: (l$id as String),
      name: (l$name as String),
      newsNotificationsEnabled: (l$newsNotificationsEnabled as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final bool newsNotificationsEnabled;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$newsNotificationsEnabled = newsNotificationsEnabled;
    _resultData['newsNotificationsEnabled'] = l$newsNotificationsEnabled;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$newsNotificationsEnabled = newsNotificationsEnabled;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$newsNotificationsEnabled,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Gemeindeinformationen_kommune_untereinheiten ||
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
    final l$newsNotificationsEnabled = newsNotificationsEnabled;
    final lOther$newsNotificationsEnabled = other.newsNotificationsEnabled;
    if (l$newsNotificationsEnabled != lOther$newsNotificationsEnabled) {
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

extension UtilityExtension_Query_Gemeindeinformationen_kommune_untereinheiten
    on Query_Gemeindeinformationen_kommune_untereinheiten {
  CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<
    Query_Gemeindeinformationen_kommune_untereinheiten
  >
  get copyWith => CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<
  TRes
> {
  factory CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten(
    Query_Gemeindeinformationen_kommune_untereinheiten instance,
    TRes Function(Query_Gemeindeinformationen_kommune_untereinheiten) then,
  ) = _CopyWithImpl_Query_Gemeindeinformationen_kommune_untereinheiten;

  factory CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Gemeindeinformationen_kommune_untereinheiten;

  TRes call({
    String? id,
    String? name,
    bool? newsNotificationsEnabled,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Gemeindeinformationen_kommune_untereinheiten<TRes>
    implements
        CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<TRes> {
  _CopyWithImpl_Query_Gemeindeinformationen_kommune_untereinheiten(
    this._instance,
    this._then,
  );

  final Query_Gemeindeinformationen_kommune_untereinheiten _instance;

  final TRes Function(Query_Gemeindeinformationen_kommune_untereinheiten) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? newsNotificationsEnabled = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Gemeindeinformationen_kommune_untereinheiten(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      newsNotificationsEnabled:
          newsNotificationsEnabled == _undefined ||
              newsNotificationsEnabled == null
          ? _instance.newsNotificationsEnabled
          : (newsNotificationsEnabled as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Gemeindeinformationen_kommune_untereinheiten<TRes>
    implements
        CopyWith_Query_Gemeindeinformationen_kommune_untereinheiten<TRes> {
  _CopyWithStubImpl_Query_Gemeindeinformationen_kommune_untereinheiten(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    bool? newsNotificationsEnabled,
    String? $__typename,
  }) => _res;
}
