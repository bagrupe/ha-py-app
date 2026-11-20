import '../../../../../graphql/__generated__/schema.graphql.dart';
import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_GemeindeNewsPreferences {
  factory Variables_Query_GemeindeNewsPreferences({
    required String kommuneId,
  }) => Variables_Query_GemeindeNewsPreferences._({r'kommuneId': kommuneId});

  Variables_Query_GemeindeNewsPreferences._(this._$data);

  factory Variables_Query_GemeindeNewsPreferences.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_GemeindeNewsPreferences._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_GemeindeNewsPreferences<
    Variables_Query_GemeindeNewsPreferences
  >
  get copyWith =>
      CopyWith_Variables_Query_GemeindeNewsPreferences(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_GemeindeNewsPreferences ||
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

abstract class CopyWith_Variables_Query_GemeindeNewsPreferences<TRes> {
  factory CopyWith_Variables_Query_GemeindeNewsPreferences(
    Variables_Query_GemeindeNewsPreferences instance,
    TRes Function(Variables_Query_GemeindeNewsPreferences) then,
  ) = _CopyWithImpl_Variables_Query_GemeindeNewsPreferences;

  factory CopyWith_Variables_Query_GemeindeNewsPreferences.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_GemeindeNewsPreferences;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_GemeindeNewsPreferences<TRes>
    implements CopyWith_Variables_Query_GemeindeNewsPreferences<TRes> {
  _CopyWithImpl_Variables_Query_GemeindeNewsPreferences(
    this._instance,
    this._then,
  );

  final Variables_Query_GemeindeNewsPreferences _instance;

  final TRes Function(Variables_Query_GemeindeNewsPreferences) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_GemeindeNewsPreferences._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_GemeindeNewsPreferences<TRes>
    implements CopyWith_Variables_Query_GemeindeNewsPreferences<TRes> {
  _CopyWithStubImpl_Variables_Query_GemeindeNewsPreferences(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_GemeindeNewsPreferences {
  Query_GemeindeNewsPreferences({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_GemeindeNewsPreferences.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_GemeindeNewsPreferences(
      kommune: Query_GemeindeNewsPreferences_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_GemeindeNewsPreferences_kommune kommune;

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
    if (other is! Query_GemeindeNewsPreferences ||
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

extension UtilityExtension_Query_GemeindeNewsPreferences
    on Query_GemeindeNewsPreferences {
  CopyWith_Query_GemeindeNewsPreferences<Query_GemeindeNewsPreferences>
  get copyWith => CopyWith_Query_GemeindeNewsPreferences(this, (i) => i);
}

abstract class CopyWith_Query_GemeindeNewsPreferences<TRes> {
  factory CopyWith_Query_GemeindeNewsPreferences(
    Query_GemeindeNewsPreferences instance,
    TRes Function(Query_GemeindeNewsPreferences) then,
  ) = _CopyWithImpl_Query_GemeindeNewsPreferences;

  factory CopyWith_Query_GemeindeNewsPreferences.stub(TRes res) =
      _CopyWithStubImpl_Query_GemeindeNewsPreferences;

  TRes call({
    Query_GemeindeNewsPreferences_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_GemeindeNewsPreferences<TRes>
    implements CopyWith_Query_GemeindeNewsPreferences<TRes> {
  _CopyWithImpl_Query_GemeindeNewsPreferences(this._instance, this._then);

  final Query_GemeindeNewsPreferences _instance;

  final TRes Function(Query_GemeindeNewsPreferences) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_GemeindeNewsPreferences(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_GemeindeNewsPreferences_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_GemeindeNewsPreferences_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_GemeindeNewsPreferences<TRes>
    implements CopyWith_Query_GemeindeNewsPreferences<TRes> {
  _CopyWithStubImpl_Query_GemeindeNewsPreferences(this._res);

  TRes _res;

  call({Query_GemeindeNewsPreferences_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> get kommune =>
      CopyWith_Query_GemeindeNewsPreferences_kommune.stub(_res);
}

const documentNodeQueryGemeindeNewsPreferences = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GemeindeNewsPreferences'),
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
                  alias: NameNode(value: 'organisationseinheiten'),
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
Query_GemeindeNewsPreferences _parserFn_Query_GemeindeNewsPreferences(
  Map<String, dynamic> data,
) => Query_GemeindeNewsPreferences.fromJson(data);
typedef OnQueryComplete_Query_GemeindeNewsPreferences =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_GemeindeNewsPreferences?,
    );

class Options_Query_GemeindeNewsPreferences
    extends graphql.QueryOptions<Query_GemeindeNewsPreferences> {
  Options_Query_GemeindeNewsPreferences({
    String? operationName,
    required Variables_Query_GemeindeNewsPreferences variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_GemeindeNewsPreferences? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_GemeindeNewsPreferences? onComplete,
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
                     : _parserFn_Query_GemeindeNewsPreferences(data),
               ),
         onError: onError,
         document: documentNodeQueryGemeindeNewsPreferences,
         parserFn: _parserFn_Query_GemeindeNewsPreferences,
       );

  final OnQueryComplete_Query_GemeindeNewsPreferences? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_GemeindeNewsPreferences
    extends graphql.WatchQueryOptions<Query_GemeindeNewsPreferences> {
  WatchOptions_Query_GemeindeNewsPreferences({
    String? operationName,
    required Variables_Query_GemeindeNewsPreferences variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_GemeindeNewsPreferences? typedOptimisticResult,
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
         document: documentNodeQueryGemeindeNewsPreferences,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_GemeindeNewsPreferences,
       );
}

class FetchMoreOptions_Query_GemeindeNewsPreferences
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_GemeindeNewsPreferences({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_GemeindeNewsPreferences variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGemeindeNewsPreferences,
       );
}

extension ClientExtension_Query_GemeindeNewsPreferences
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_GemeindeNewsPreferences>>
  query_GemeindeNewsPreferences(
    Options_Query_GemeindeNewsPreferences options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_GemeindeNewsPreferences>
  watchQuery_GemeindeNewsPreferences(
    WatchOptions_Query_GemeindeNewsPreferences options,
  ) => this.watchQuery(options);

  void writeQuery_GemeindeNewsPreferences({
    required Query_GemeindeNewsPreferences data,
    required Variables_Query_GemeindeNewsPreferences variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGemeindeNewsPreferences,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_GemeindeNewsPreferences? readQuery_GemeindeNewsPreferences({
    required Variables_Query_GemeindeNewsPreferences variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGemeindeNewsPreferences,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_GemeindeNewsPreferences.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_GemeindeNewsPreferences>
useQuery_GemeindeNewsPreferences(
  Options_Query_GemeindeNewsPreferences options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_GemeindeNewsPreferences>
useWatchQuery_GemeindeNewsPreferences(
  WatchOptions_Query_GemeindeNewsPreferences options,
) => graphql_flutter.useWatchQuery(options);

class Query_GemeindeNewsPreferences_Widget
    extends graphql_flutter.Query<Query_GemeindeNewsPreferences> {
  Query_GemeindeNewsPreferences_Widget({
    widgets.Key? key,
    required Options_Query_GemeindeNewsPreferences options,
    required graphql_flutter.QueryBuilder<Query_GemeindeNewsPreferences>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_GemeindeNewsPreferences_kommune {
  Query_GemeindeNewsPreferences_kommune({
    required this.organisationseinheiten,
    this.$__typename = 'Kommune',
  });

  factory Query_GemeindeNewsPreferences_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$organisationseinheiten = json['organisationseinheiten'];
    final l$$__typename = json['__typename'];
    return Query_GemeindeNewsPreferences_kommune(
      organisationseinheiten: (l$organisationseinheiten as List<dynamic>)
          .map(
            (e) =>
                Query_GemeindeNewsPreferences_kommune_organisationseinheiten.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_GemeindeNewsPreferences_kommune_organisationseinheiten>
  organisationseinheiten;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$organisationseinheiten = organisationseinheiten;
    _resultData['organisationseinheiten'] = l$organisationseinheiten
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$organisationseinheiten = organisationseinheiten;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$organisationseinheiten.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_GemeindeNewsPreferences_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$organisationseinheiten = organisationseinheiten;
    final lOther$organisationseinheiten = other.organisationseinheiten;
    if (l$organisationseinheiten.length !=
        lOther$organisationseinheiten.length) {
      return false;
    }
    for (int i = 0; i < l$organisationseinheiten.length; i++) {
      final l$organisationseinheiten$entry = l$organisationseinheiten[i];
      final lOther$organisationseinheiten$entry =
          lOther$organisationseinheiten[i];
      if (l$organisationseinheiten$entry !=
          lOther$organisationseinheiten$entry) {
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

extension UtilityExtension_Query_GemeindeNewsPreferences_kommune
    on Query_GemeindeNewsPreferences_kommune {
  CopyWith_Query_GemeindeNewsPreferences_kommune<
    Query_GemeindeNewsPreferences_kommune
  >
  get copyWith =>
      CopyWith_Query_GemeindeNewsPreferences_kommune(this, (i) => i);
}

abstract class CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> {
  factory CopyWith_Query_GemeindeNewsPreferences_kommune(
    Query_GemeindeNewsPreferences_kommune instance,
    TRes Function(Query_GemeindeNewsPreferences_kommune) then,
  ) = _CopyWithImpl_Query_GemeindeNewsPreferences_kommune;

  factory CopyWith_Query_GemeindeNewsPreferences_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune;

  TRes call({
    List<Query_GemeindeNewsPreferences_kommune_organisationseinheiten>?
    organisationseinheiten,
    String? $__typename,
  });
  TRes organisationseinheiten(
    Iterable<Query_GemeindeNewsPreferences_kommune_organisationseinheiten>
    Function(
      Iterable<
        CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
          Query_GemeindeNewsPreferences_kommune_organisationseinheiten
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_GemeindeNewsPreferences_kommune<TRes>
    implements CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> {
  _CopyWithImpl_Query_GemeindeNewsPreferences_kommune(
    this._instance,
    this._then,
  );

  final Query_GemeindeNewsPreferences_kommune _instance;

  final TRes Function(Query_GemeindeNewsPreferences_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? organisationseinheiten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_GemeindeNewsPreferences_kommune(
      organisationseinheiten:
          organisationseinheiten == _undefined || organisationseinheiten == null
          ? _instance.organisationseinheiten
          : (organisationseinheiten
                as List<
                  Query_GemeindeNewsPreferences_kommune_organisationseinheiten
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes organisationseinheiten(
    Iterable<Query_GemeindeNewsPreferences_kommune_organisationseinheiten>
    Function(
      Iterable<
        CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
          Query_GemeindeNewsPreferences_kommune_organisationseinheiten
        >
      >,
    )
    _fn,
  ) => call(
    organisationseinheiten: _fn(
      _instance.organisationseinheiten.map(
        (e) =>
            CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune<TRes>
    implements CopyWith_Query_GemeindeNewsPreferences_kommune<TRes> {
  _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune(this._res);

  TRes _res;

  call({
    List<Query_GemeindeNewsPreferences_kommune_organisationseinheiten>?
    organisationseinheiten,
    String? $__typename,
  }) => _res;

  organisationseinheiten(_fn) => _res;
}

class Query_GemeindeNewsPreferences_kommune_organisationseinheiten {
  Query_GemeindeNewsPreferences_kommune_organisationseinheiten({
    required this.id,
    required this.name,
    required this.newsNotificationsEnabled,
    this.$__typename = 'Untereinheit',
  });

  factory Query_GemeindeNewsPreferences_kommune_organisationseinheiten.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$newsNotificationsEnabled = json['newsNotificationsEnabled'];
    final l$$__typename = json['__typename'];
    return Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
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
    if (other
            is! Query_GemeindeNewsPreferences_kommune_organisationseinheiten ||
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

extension UtilityExtension_Query_GemeindeNewsPreferences_kommune_organisationseinheiten
    on Query_GemeindeNewsPreferences_kommune_organisationseinheiten {
  CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
    Query_GemeindeNewsPreferences_kommune_organisationseinheiten
  >
  get copyWith =>
      CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
  TRes
> {
  factory CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
    Query_GemeindeNewsPreferences_kommune_organisationseinheiten instance,
    TRes Function(Query_GemeindeNewsPreferences_kommune_organisationseinheiten)
    then,
  ) = _CopyWithImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten;

  factory CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten;

  TRes call({
    String? id,
    String? name,
    bool? newsNotificationsEnabled,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
  TRes
>
    implements
        CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
          TRes
        > {
  _CopyWithImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
    this._instance,
    this._then,
  );

  final Query_GemeindeNewsPreferences_kommune_organisationseinheiten _instance;

  final TRes Function(
    Query_GemeindeNewsPreferences_kommune_organisationseinheiten,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? newsNotificationsEnabled = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
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

class _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
  TRes
>
    implements
        CopyWith_Query_GemeindeNewsPreferences_kommune_organisationseinheiten<
          TRes
        > {
  _CopyWithStubImpl_Query_GemeindeNewsPreferences_kommune_organisationseinheiten(
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

class Variables_Mutation_UpdateNewsNotificationsPreferences {
  factory Variables_Mutation_UpdateNewsNotificationsPreferences({
    required Input_UpdateNewsNotificationsPreferencesInput input,
  }) => Variables_Mutation_UpdateNewsNotificationsPreferences._({
    r'input': input,
  });

  Variables_Mutation_UpdateNewsNotificationsPreferences._(this._$data);

  factory Variables_Mutation_UpdateNewsNotificationsPreferences.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] =
        Input_UpdateNewsNotificationsPreferencesInput.fromJson(
          (l$input as Map<String, dynamic>),
        );
    return Variables_Mutation_UpdateNewsNotificationsPreferences._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_UpdateNewsNotificationsPreferencesInput get input =>
      (_$data['input'] as Input_UpdateNewsNotificationsPreferencesInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences<
    Variables_Mutation_UpdateNewsNotificationsPreferences
  >
  get copyWith =>
      CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_UpdateNewsNotificationsPreferences ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences<
  TRes
> {
  factory CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences(
    Variables_Mutation_UpdateNewsNotificationsPreferences instance,
    TRes Function(Variables_Mutation_UpdateNewsNotificationsPreferences) then,
  ) = _CopyWithImpl_Variables_Mutation_UpdateNewsNotificationsPreferences;

  factory CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences.stub(
    TRes res,
  ) = _CopyWithStubImpl_Variables_Mutation_UpdateNewsNotificationsPreferences;

  TRes call({Input_UpdateNewsNotificationsPreferencesInput? input});
}

class _CopyWithImpl_Variables_Mutation_UpdateNewsNotificationsPreferences<TRes>
    implements
        CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences<TRes> {
  _CopyWithImpl_Variables_Mutation_UpdateNewsNotificationsPreferences(
    this._instance,
    this._then,
  );

  final Variables_Mutation_UpdateNewsNotificationsPreferences _instance;

  final TRes Function(Variables_Mutation_UpdateNewsNotificationsPreferences)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_UpdateNewsNotificationsPreferences._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_UpdateNewsNotificationsPreferencesInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_UpdateNewsNotificationsPreferences<
  TRes
>
    implements
        CopyWith_Variables_Mutation_UpdateNewsNotificationsPreferences<TRes> {
  _CopyWithStubImpl_Variables_Mutation_UpdateNewsNotificationsPreferences(
    this._res,
  );

  TRes _res;

  call({Input_UpdateNewsNotificationsPreferencesInput? input}) => _res;
}

class Mutation_UpdateNewsNotificationsPreferences {
  Mutation_UpdateNewsNotificationsPreferences({
    required this.updateNewsNotificationsPreferences,
    this.$__typename = 'Mutation',
  });

  factory Mutation_UpdateNewsNotificationsPreferences.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$updateNewsNotificationsPreferences =
        json['updateNewsNotificationsPreferences'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateNewsNotificationsPreferences(
      updateNewsNotificationsPreferences:
          Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences.fromJson(
            (l$updateNewsNotificationsPreferences as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences
  updateNewsNotificationsPreferences;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateNewsNotificationsPreferences =
        updateNewsNotificationsPreferences;
    _resultData['updateNewsNotificationsPreferences'] =
        l$updateNewsNotificationsPreferences.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateNewsNotificationsPreferences =
        updateNewsNotificationsPreferences;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$updateNewsNotificationsPreferences,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdateNewsNotificationsPreferences ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateNewsNotificationsPreferences =
        updateNewsNotificationsPreferences;
    final lOther$updateNewsNotificationsPreferences =
        other.updateNewsNotificationsPreferences;
    if (l$updateNewsNotificationsPreferences !=
        lOther$updateNewsNotificationsPreferences) {
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

extension UtilityExtension_Mutation_UpdateNewsNotificationsPreferences
    on Mutation_UpdateNewsNotificationsPreferences {
  CopyWith_Mutation_UpdateNewsNotificationsPreferences<
    Mutation_UpdateNewsNotificationsPreferences
  >
  get copyWith =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdateNewsNotificationsPreferences<TRes> {
  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences(
    Mutation_UpdateNewsNotificationsPreferences instance,
    TRes Function(Mutation_UpdateNewsNotificationsPreferences) then,
  ) = _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences;

  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences.stub(TRes res) =
      _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences;

  TRes call({
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences?
    updateNewsNotificationsPreferences,
    String? $__typename,
  });
  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
    TRes
  >
  get updateNewsNotificationsPreferences;
}

class _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences<TRes>
    implements CopyWith_Mutation_UpdateNewsNotificationsPreferences<TRes> {
  _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences(
    this._instance,
    this._then,
  );

  final Mutation_UpdateNewsNotificationsPreferences _instance;

  final TRes Function(Mutation_UpdateNewsNotificationsPreferences) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateNewsNotificationsPreferences = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateNewsNotificationsPreferences(
      updateNewsNotificationsPreferences:
          updateNewsNotificationsPreferences == _undefined ||
              updateNewsNotificationsPreferences == null
          ? _instance.updateNewsNotificationsPreferences
          : (updateNewsNotificationsPreferences
                as Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
    TRes
  >
  get updateNewsNotificationsPreferences {
    final local$updateNewsNotificationsPreferences =
        _instance.updateNewsNotificationsPreferences;
    return CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
      local$updateNewsNotificationsPreferences,
      (e) => call(updateNewsNotificationsPreferences: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences<TRes>
    implements CopyWith_Mutation_UpdateNewsNotificationsPreferences<TRes> {
  _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences(this._res);

  TRes _res;

  call({
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences?
    updateNewsNotificationsPreferences,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
    TRes
  >
  get updateNewsNotificationsPreferences =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences.stub(
        _res,
      );
}

const documentNodeMutationUpdateNewsNotificationsPreferences = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateNewsNotificationsPreferences'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateNewsNotificationsPreferencesInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'updateNewsNotificationsPreferences'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'boolean'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'errors'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
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
Mutation_UpdateNewsNotificationsPreferences
_parserFn_Mutation_UpdateNewsNotificationsPreferences(
  Map<String, dynamic> data,
) => Mutation_UpdateNewsNotificationsPreferences.fromJson(data);
typedef OnMutationCompleted_Mutation_UpdateNewsNotificationsPreferences =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_UpdateNewsNotificationsPreferences?,
    );

class Options_Mutation_UpdateNewsNotificationsPreferences
    extends
        graphql.MutationOptions<Mutation_UpdateNewsNotificationsPreferences> {
  Options_Mutation_UpdateNewsNotificationsPreferences({
    String? operationName,
    required Variables_Mutation_UpdateNewsNotificationsPreferences variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateNewsNotificationsPreferences? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateNewsNotificationsPreferences?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateNewsNotificationsPreferences>?
    update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null
                     ? null
                     : _parserFn_Mutation_UpdateNewsNotificationsPreferences(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateNewsNotificationsPreferences,
         parserFn: _parserFn_Mutation_UpdateNewsNotificationsPreferences,
       );

  final OnMutationCompleted_Mutation_UpdateNewsNotificationsPreferences?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_UpdateNewsNotificationsPreferences
    extends
        graphql.WatchQueryOptions<Mutation_UpdateNewsNotificationsPreferences> {
  WatchOptions_Mutation_UpdateNewsNotificationsPreferences({
    String? operationName,
    required Variables_Mutation_UpdateNewsNotificationsPreferences variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateNewsNotificationsPreferences? typedOptimisticResult,
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
         document: documentNodeMutationUpdateNewsNotificationsPreferences,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_UpdateNewsNotificationsPreferences,
       );
}

extension ClientExtension_Mutation_UpdateNewsNotificationsPreferences
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_UpdateNewsNotificationsPreferences>>
  mutate_UpdateNewsNotificationsPreferences(
    Options_Mutation_UpdateNewsNotificationsPreferences options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_UpdateNewsNotificationsPreferences>
  watchMutation_UpdateNewsNotificationsPreferences(
    WatchOptions_Mutation_UpdateNewsNotificationsPreferences options,
  ) => this.watchMutation(options);
}

class Mutation_UpdateNewsNotificationsPreferences_HookResult {
  Mutation_UpdateNewsNotificationsPreferences_HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation_Mutation_UpdateNewsNotificationsPreferences runMutation;

  final graphql.QueryResult<Mutation_UpdateNewsNotificationsPreferences> result;
}

Mutation_UpdateNewsNotificationsPreferences_HookResult
useMutation_UpdateNewsNotificationsPreferences([
  WidgetOptions_Mutation_UpdateNewsNotificationsPreferences? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_UpdateNewsNotificationsPreferences(),
  );
  return Mutation_UpdateNewsNotificationsPreferences_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_UpdateNewsNotificationsPreferences>
useWatchMutation_UpdateNewsNotificationsPreferences(
  WatchOptions_Mutation_UpdateNewsNotificationsPreferences options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_UpdateNewsNotificationsPreferences
    extends
        graphql.MutationOptions<Mutation_UpdateNewsNotificationsPreferences> {
  WidgetOptions_Mutation_UpdateNewsNotificationsPreferences({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateNewsNotificationsPreferences? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateNewsNotificationsPreferences?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateNewsNotificationsPreferences>?
    update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null
                     ? null
                     : _parserFn_Mutation_UpdateNewsNotificationsPreferences(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateNewsNotificationsPreferences,
         parserFn: _parserFn_Mutation_UpdateNewsNotificationsPreferences,
       );

  final OnMutationCompleted_Mutation_UpdateNewsNotificationsPreferences?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_UpdateNewsNotificationsPreferences =
    graphql.MultiSourceResult<Mutation_UpdateNewsNotificationsPreferences>
    Function(
      Variables_Mutation_UpdateNewsNotificationsPreferences, {
      Object? optimisticResult,
      Mutation_UpdateNewsNotificationsPreferences? typedOptimisticResult,
    });
typedef Builder_Mutation_UpdateNewsNotificationsPreferences =
    widgets.Widget Function(
      RunMutation_Mutation_UpdateNewsNotificationsPreferences,
      graphql.QueryResult<Mutation_UpdateNewsNotificationsPreferences>?,
    );

class Mutation_UpdateNewsNotificationsPreferences_Widget
    extends
        graphql_flutter.Mutation<Mutation_UpdateNewsNotificationsPreferences> {
  Mutation_UpdateNewsNotificationsPreferences_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_UpdateNewsNotificationsPreferences? options,
    required Builder_Mutation_UpdateNewsNotificationsPreferences builder,
  }) : super(
         key: key,
         options:
             options ??
             WidgetOptions_Mutation_UpdateNewsNotificationsPreferences(),
         builder: (run, result) => builder(
           (variables, {optimisticResult, typedOptimisticResult}) => run(
             variables.toJson(),
             optimisticResult:
                 optimisticResult ?? typedOptimisticResult?.toJson(),
           ),
           result,
         ),
       );
}

class Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences {
  Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences({
    this.boolean,
    this.errors,
    this.$__typename = 'UpdateNewsNotificationsPreferencesPayload',
  });

  factory Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$boolean = json['boolean'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
      boolean: (l$boolean as bool?),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? boolean;

  final List<
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$boolean = boolean;
    _resultData['boolean'] = l$boolean;
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$boolean = boolean;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$boolean,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$boolean = boolean;
    final lOther$boolean = other.boolean;
    if (l$boolean != lOther$boolean) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences
    on Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences {
  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences
  >
  get copyWith =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
  TRes
> {
  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences
    instance,
    TRes Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences;

  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences;

  TRes call({
    bool? boolean,
    List<
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    >?
    errors,
    String? $__typename,
  });
  TRes errors(
    Iterable<
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
          Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
    this._instance,
    this._then,
  );

  final Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences
  _instance;

  final TRes Function(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? boolean = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
      boolean: boolean == _undefined ? _instance.boolean : (boolean as bool?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes errors(
    Iterable<
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
          Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences(
    this._res,
  );

  TRes _res;

  call({
    bool? boolean,
    List<
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    >?
    errors,
    String? $__typename,
  }) => _res;

  errors(_fn) => _res;
}

class Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors {
  Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors({
    required this.$__typename,
  });

  factory Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "OrganisationseinheitNotFoundError":
        return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    on
        Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors {
  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
  >
  get copyWith =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
    )
    organisationseinheitNotFoundError,
    required _T Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "OrganisationseinheitNotFoundError":
        return organisationseinheitNotFoundError(
          this
              as Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
    )?
    organisationseinheitNotFoundError,
    _T Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
    )?
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "OrganisationseinheitNotFoundError":
        if (organisationseinheitNotFoundError != null) {
          return organisationseinheitNotFoundError(
            this
                as Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
  TRes
> {
  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
    instance,
    TRes Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors;

  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
    this._instance,
    this._then,
  );

  final Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors
  _instance;

  final TRes Function(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError
    implements
        Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors {
  Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError({
    this.$__typename = 'OrganisationseinheitNotFoundError',
  });

  factory Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
      $__typename: (l$$__typename as String),
    );
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError
    on
        Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError {
  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError
    instance,
    TRes Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError;

  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError
  _instance;

  final TRes Function(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__OrganisationseinheitNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError
    implements
        Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors {
  Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError({
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
      $__typename: (l$$__typename as String),
    );
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError
    on
        Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError {
  CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError;

  factory CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateNewsNotificationsPreferences_updateNewsNotificationsPreferences_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}
