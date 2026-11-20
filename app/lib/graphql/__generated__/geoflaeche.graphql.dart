import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables_Query_IsInside {
  factory Variables_Query_IsInside({
    required String kommuneId,
    required String name,
    required Input_Position position,
  }) => Variables_Query_IsInside._({
    r'kommuneId': kommuneId,
    r'name': name,
    r'position': position,
  });

  Variables_Query_IsInside._(this._$data);

  factory Variables_Query_IsInside.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$position = data['position'];
    result$data['position'] = Input_Position.fromJson(
      (l$position as Map<String, dynamic>),
    );
    return Variables_Query_IsInside._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get name => (_$data['name'] as String);

  Input_Position get position => (_$data['position'] as Input_Position);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$name = name;
    result$data['name'] = l$name;
    final l$position = position;
    result$data['position'] = l$position.toJson();
    return result$data;
  }

  CopyWith_Variables_Query_IsInside<Variables_Query_IsInside> get copyWith =>
      CopyWith_Variables_Query_IsInside(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_IsInside ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position != lOther$position) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$name = name;
    final l$position = position;
    return Object.hashAll([l$kommuneId, l$name, l$position]);
  }
}

abstract class CopyWith_Variables_Query_IsInside<TRes> {
  factory CopyWith_Variables_Query_IsInside(
    Variables_Query_IsInside instance,
    TRes Function(Variables_Query_IsInside) then,
  ) = _CopyWithImpl_Variables_Query_IsInside;

  factory CopyWith_Variables_Query_IsInside.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_IsInside;

  TRes call({String? kommuneId, String? name, Input_Position? position});
}

class _CopyWithImpl_Variables_Query_IsInside<TRes>
    implements CopyWith_Variables_Query_IsInside<TRes> {
  _CopyWithImpl_Variables_Query_IsInside(this._instance, this._then);

  final Variables_Query_IsInside _instance;

  final TRes Function(Variables_Query_IsInside) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? name = _undefined,
    Object? position = _undefined,
  }) => _then(
    Variables_Query_IsInside._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
      if (name != _undefined && name != null) 'name': (name as String),
      if (position != _undefined && position != null)
        'position': (position as Input_Position),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_IsInside<TRes>
    implements CopyWith_Variables_Query_IsInside<TRes> {
  _CopyWithStubImpl_Variables_Query_IsInside(this._res);

  TRes _res;

  call({String? kommuneId, String? name, Input_Position? position}) => _res;
}

class Query_IsInside {
  Query_IsInside({required this.kommune, this.$__typename = 'Query'});

  factory Query_IsInside.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_IsInside(
      kommune: Query_IsInside_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_IsInside_kommune kommune;

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
    if (other is! Query_IsInside || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_IsInside on Query_IsInside {
  CopyWith_Query_IsInside<Query_IsInside> get copyWith =>
      CopyWith_Query_IsInside(this, (i) => i);
}

abstract class CopyWith_Query_IsInside<TRes> {
  factory CopyWith_Query_IsInside(
    Query_IsInside instance,
    TRes Function(Query_IsInside) then,
  ) = _CopyWithImpl_Query_IsInside;

  factory CopyWith_Query_IsInside.stub(TRes res) =
      _CopyWithStubImpl_Query_IsInside;

  TRes call({Query_IsInside_kommune? kommune, String? $__typename});
  CopyWith_Query_IsInside_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_IsInside<TRes>
    implements CopyWith_Query_IsInside<TRes> {
  _CopyWithImpl_Query_IsInside(this._instance, this._then);

  final Query_IsInside _instance;

  final TRes Function(Query_IsInside) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_IsInside(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_IsInside_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_IsInside_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_IsInside_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_IsInside<TRes>
    implements CopyWith_Query_IsInside<TRes> {
  _CopyWithStubImpl_Query_IsInside(this._res);

  TRes _res;

  call({Query_IsInside_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_IsInside_kommune<TRes> get kommune =>
      CopyWith_Query_IsInside_kommune.stub(_res);
}

const documentNodeQueryIsInside = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'IsInside'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'name')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'position')),
          type: NamedTypeNode(
            name: NameNode(value: 'Position'),
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
                  name: NameNode(value: 'isPointInGeoflaeche'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'name'),
                      value: VariableNode(name: NameNode(value: 'name')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'position'),
                      value: VariableNode(name: NameNode(value: 'position')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'isInside'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'message'),
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
Query_IsInside _parserFn_Query_IsInside(Map<String, dynamic> data) =>
    Query_IsInside.fromJson(data);
typedef OnQueryComplete_Query_IsInside =
    FutureOr<void> Function(Map<String, dynamic>?, Query_IsInside?);

class Options_Query_IsInside extends graphql.QueryOptions<Query_IsInside> {
  Options_Query_IsInside({
    String? operationName,
    required Variables_Query_IsInside variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_IsInside? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_IsInside? onComplete,
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
                 data == null ? null : _parserFn_Query_IsInside(data),
               ),
         onError: onError,
         document: documentNodeQueryIsInside,
         parserFn: _parserFn_Query_IsInside,
       );

  final OnQueryComplete_Query_IsInside? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_IsInside
    extends graphql.WatchQueryOptions<Query_IsInside> {
  WatchOptions_Query_IsInside({
    String? operationName,
    required Variables_Query_IsInside variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_IsInside? typedOptimisticResult,
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
         document: documentNodeQueryIsInside,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_IsInside,
       );
}

class FetchMoreOptions_Query_IsInside extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_IsInside({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_IsInside variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryIsInside,
       );
}

extension ClientExtension_Query_IsInside on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_IsInside>> query_IsInside(
    Options_Query_IsInside options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_IsInside> watchQuery_IsInside(
    WatchOptions_Query_IsInside options,
  ) => this.watchQuery(options);

  void writeQuery_IsInside({
    required Query_IsInside data,
    required Variables_Query_IsInside variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryIsInside),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_IsInside? readQuery_IsInside({
    required Variables_Query_IsInside variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryIsInside),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_IsInside.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_IsInside> useQuery_IsInside(
  Options_Query_IsInside options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_IsInside> useWatchQuery_IsInside(
  WatchOptions_Query_IsInside options,
) => graphql_flutter.useWatchQuery(options);

class Query_IsInside_Widget extends graphql_flutter.Query<Query_IsInside> {
  Query_IsInside_Widget({
    widgets.Key? key,
    required Options_Query_IsInside options,
    required graphql_flutter.QueryBuilder<Query_IsInside> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_IsInside_kommune {
  Query_IsInside_kommune({
    required this.isPointInGeoflaeche,
    this.$__typename = 'Kommune',
  });

  factory Query_IsInside_kommune.fromJson(Map<String, dynamic> json) {
    final l$isPointInGeoflaeche = json['isPointInGeoflaeche'];
    final l$$__typename = json['__typename'];
    return Query_IsInside_kommune(
      isPointInGeoflaeche: Query_IsInside_kommune_isPointInGeoflaeche.fromJson(
        (l$isPointInGeoflaeche as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_IsInside_kommune_isPointInGeoflaeche isPointInGeoflaeche;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isPointInGeoflaeche = isPointInGeoflaeche;
    _resultData['isPointInGeoflaeche'] = l$isPointInGeoflaeche.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isPointInGeoflaeche = isPointInGeoflaeche;
    final l$$__typename = $__typename;
    return Object.hashAll([l$isPointInGeoflaeche, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_IsInside_kommune || runtimeType != other.runtimeType) {
      return false;
    }
    final l$isPointInGeoflaeche = isPointInGeoflaeche;
    final lOther$isPointInGeoflaeche = other.isPointInGeoflaeche;
    if (l$isPointInGeoflaeche != lOther$isPointInGeoflaeche) {
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

extension UtilityExtension_Query_IsInside_kommune on Query_IsInside_kommune {
  CopyWith_Query_IsInside_kommune<Query_IsInside_kommune> get copyWith =>
      CopyWith_Query_IsInside_kommune(this, (i) => i);
}

abstract class CopyWith_Query_IsInside_kommune<TRes> {
  factory CopyWith_Query_IsInside_kommune(
    Query_IsInside_kommune instance,
    TRes Function(Query_IsInside_kommune) then,
  ) = _CopyWithImpl_Query_IsInside_kommune;

  factory CopyWith_Query_IsInside_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_IsInside_kommune;

  TRes call({
    Query_IsInside_kommune_isPointInGeoflaeche? isPointInGeoflaeche,
    String? $__typename,
  });
  CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes>
  get isPointInGeoflaeche;
}

class _CopyWithImpl_Query_IsInside_kommune<TRes>
    implements CopyWith_Query_IsInside_kommune<TRes> {
  _CopyWithImpl_Query_IsInside_kommune(this._instance, this._then);

  final Query_IsInside_kommune _instance;

  final TRes Function(Query_IsInside_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isPointInGeoflaeche = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_IsInside_kommune(
      isPointInGeoflaeche:
          isPointInGeoflaeche == _undefined || isPointInGeoflaeche == null
          ? _instance.isPointInGeoflaeche
          : (isPointInGeoflaeche as Query_IsInside_kommune_isPointInGeoflaeche),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes>
  get isPointInGeoflaeche {
    final local$isPointInGeoflaeche = _instance.isPointInGeoflaeche;
    return CopyWith_Query_IsInside_kommune_isPointInGeoflaeche(
      local$isPointInGeoflaeche,
      (e) => call(isPointInGeoflaeche: e),
    );
  }
}

class _CopyWithStubImpl_Query_IsInside_kommune<TRes>
    implements CopyWith_Query_IsInside_kommune<TRes> {
  _CopyWithStubImpl_Query_IsInside_kommune(this._res);

  TRes _res;

  call({
    Query_IsInside_kommune_isPointInGeoflaeche? isPointInGeoflaeche,
    String? $__typename,
  }) => _res;

  CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes>
  get isPointInGeoflaeche =>
      CopyWith_Query_IsInside_kommune_isPointInGeoflaeche.stub(_res);
}

class Query_IsInside_kommune_isPointInGeoflaeche {
  Query_IsInside_kommune_isPointInGeoflaeche({
    this.isInside,
    this.message,
    this.$__typename = 'IsInside',
  });

  factory Query_IsInside_kommune_isPointInGeoflaeche.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$isInside = json['isInside'];
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Query_IsInside_kommune_isPointInGeoflaeche(
      isInside: (l$isInside as bool?),
      message: (l$message as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? isInside;

  final String? message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$isInside = isInside;
    _resultData['isInside'] = l$isInside;
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$isInside = isInside;
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$isInside, l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_IsInside_kommune_isPointInGeoflaeche ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$isInside = isInside;
    final lOther$isInside = other.isInside;
    if (l$isInside != lOther$isInside) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Query_IsInside_kommune_isPointInGeoflaeche
    on Query_IsInside_kommune_isPointInGeoflaeche {
  CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<
    Query_IsInside_kommune_isPointInGeoflaeche
  >
  get copyWith =>
      CopyWith_Query_IsInside_kommune_isPointInGeoflaeche(this, (i) => i);
}

abstract class CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes> {
  factory CopyWith_Query_IsInside_kommune_isPointInGeoflaeche(
    Query_IsInside_kommune_isPointInGeoflaeche instance,
    TRes Function(Query_IsInside_kommune_isPointInGeoflaeche) then,
  ) = _CopyWithImpl_Query_IsInside_kommune_isPointInGeoflaeche;

  factory CopyWith_Query_IsInside_kommune_isPointInGeoflaeche.stub(TRes res) =
      _CopyWithStubImpl_Query_IsInside_kommune_isPointInGeoflaeche;

  TRes call({bool? isInside, String? message, String? $__typename});
}

class _CopyWithImpl_Query_IsInside_kommune_isPointInGeoflaeche<TRes>
    implements CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes> {
  _CopyWithImpl_Query_IsInside_kommune_isPointInGeoflaeche(
    this._instance,
    this._then,
  );

  final Query_IsInside_kommune_isPointInGeoflaeche _instance;

  final TRes Function(Query_IsInside_kommune_isPointInGeoflaeche) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? isInside = _undefined,
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_IsInside_kommune_isPointInGeoflaeche(
      isInside: isInside == _undefined
          ? _instance.isInside
          : (isInside as bool?),
      message: message == _undefined ? _instance.message : (message as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_IsInside_kommune_isPointInGeoflaeche<TRes>
    implements CopyWith_Query_IsInside_kommune_isPointInGeoflaeche<TRes> {
  _CopyWithStubImpl_Query_IsInside_kommune_isPointInGeoflaeche(this._res);

  TRes _res;

  call({bool? isInside, String? message, String? $__typename}) => _res;
}
