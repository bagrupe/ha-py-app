import 'dart:async';
import 'kommune.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'prozess.graphql.dart';
import 'schema.graphql.dart';

class Variables_Query_ErsteSchritte {
  factory Variables_Query_ErsteSchritte({
    required String kommuneId,
    int? skip,
    int? take,
  }) => Variables_Query_ErsteSchritte._({
    r'kommuneId': kommuneId,
    if (skip != null) r'skip': skip,
    if (take != null) r'take': take,
  });

  Variables_Query_ErsteSchritte._(this._$data);

  factory Variables_Query_ErsteSchritte.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    if (data.containsKey('skip')) {
      final l$skip = data['skip'];
      result$data['skip'] = (l$skip as int?);
    }
    if (data.containsKey('take')) {
      final l$take = data['take'];
      result$data['take'] = (l$take as int?);
    }
    return Variables_Query_ErsteSchritte._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  int? get skip => (_$data['skip'] as int?);

  int? get take => (_$data['take'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    if (_$data.containsKey('skip')) {
      final l$skip = skip;
      result$data['skip'] = l$skip;
    }
    if (_$data.containsKey('take')) {
      final l$take = take;
      result$data['take'] = l$take;
    }
    return result$data;
  }

  CopyWith_Variables_Query_ErsteSchritte<Variables_Query_ErsteSchritte>
  get copyWith => CopyWith_Variables_Query_ErsteSchritte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_ErsteSchritte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (_$data.containsKey('skip') != other._$data.containsKey('skip')) {
      return false;
    }
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (_$data.containsKey('take') != other._$data.containsKey('take')) {
      return false;
    }
    if (l$take != lOther$take) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$skip = skip;
    final l$take = take;
    return Object.hashAll([
      l$kommuneId,
      _$data.containsKey('skip') ? l$skip : const {},
      _$data.containsKey('take') ? l$take : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_ErsteSchritte<TRes> {
  factory CopyWith_Variables_Query_ErsteSchritte(
    Variables_Query_ErsteSchritte instance,
    TRes Function(Variables_Query_ErsteSchritte) then,
  ) = _CopyWithImpl_Variables_Query_ErsteSchritte;

  factory CopyWith_Variables_Query_ErsteSchritte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_ErsteSchritte;

  TRes call({String? kommuneId, int? skip, int? take});
}

class _CopyWithImpl_Variables_Query_ErsteSchritte<TRes>
    implements CopyWith_Variables_Query_ErsteSchritte<TRes> {
  _CopyWithImpl_Variables_Query_ErsteSchritte(this._instance, this._then);

  final Variables_Query_ErsteSchritte _instance;

  final TRes Function(Variables_Query_ErsteSchritte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? skip = _undefined,
    Object? take = _undefined,
  }) => _then(
    Variables_Query_ErsteSchritte._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
      if (skip != _undefined) 'skip': (skip as int?),
      if (take != _undefined) 'take': (take as int?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_ErsteSchritte<TRes>
    implements CopyWith_Variables_Query_ErsteSchritte<TRes> {
  _CopyWithStubImpl_Variables_Query_ErsteSchritte(this._res);

  TRes _res;

  call({String? kommuneId, int? skip, int? take}) => _res;
}

class Query_ErsteSchritte {
  Query_ErsteSchritte({required this.kommune, this.$__typename = 'Query'});

  factory Query_ErsteSchritte.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte(
      kommune: Query_ErsteSchritte_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_ErsteSchritte_kommune kommune;

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
    if (other is! Query_ErsteSchritte || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_ErsteSchritte on Query_ErsteSchritte {
  CopyWith_Query_ErsteSchritte<Query_ErsteSchritte> get copyWith =>
      CopyWith_Query_ErsteSchritte(this, (i) => i);
}

abstract class CopyWith_Query_ErsteSchritte<TRes> {
  factory CopyWith_Query_ErsteSchritte(
    Query_ErsteSchritte instance,
    TRes Function(Query_ErsteSchritte) then,
  ) = _CopyWithImpl_Query_ErsteSchritte;

  factory CopyWith_Query_ErsteSchritte.stub(TRes res) =
      _CopyWithStubImpl_Query_ErsteSchritte;

  TRes call({Query_ErsteSchritte_kommune? kommune, String? $__typename});
  CopyWith_Query_ErsteSchritte_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_ErsteSchritte<TRes>
    implements CopyWith_Query_ErsteSchritte<TRes> {
  _CopyWithImpl_Query_ErsteSchritte(this._instance, this._then);

  final Query_ErsteSchritte _instance;

  final TRes Function(Query_ErsteSchritte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_ErsteSchritte(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_ErsteSchritte_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_ErsteSchritte_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_ErsteSchritte_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte<TRes>
    implements CopyWith_Query_ErsteSchritte<TRes> {
  _CopyWithStubImpl_Query_ErsteSchritte(this._res);

  TRes _res;

  call({Query_ErsteSchritte_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_ErsteSchritte_kommune<TRes> get kommune =>
      CopyWith_Query_ErsteSchritte_kommune.stub(_res);
}

const documentNodeQueryErsteSchritte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ErsteSchritte'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'skip')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'take')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
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
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'prozessGroups'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
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
                  name: NameNode(value: 'prozesseUndLeistungen'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'skip'),
                      value: VariableNode(name: NameNode(value: 'skip')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'take'),
                      value: VariableNode(name: NameNode(value: 'take')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'items'),
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
                              name: NameNode(value: 'group'),
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
                            FragmentSpreadNode(
                              name: NameNode(value: 'Prozess'),
                              directives: [],
                            ),
                            InlineFragmentNode(
                              typeCondition: TypeConditionNode(
                                on: NamedTypeNode(
                                  name: NameNode(value: 'ServicePortalLink'),
                                  isNonNull: false,
                                ),
                              ),
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'url'),
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
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'pageInfo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'hasNextPage'),
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
    fragmentDefinitionProzess,
    fragmentDefinitionProzessOwnData,
    fragmentDefinitionKommuneCrypto,
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
  ],
);
Query_ErsteSchritte _parserFn_Query_ErsteSchritte(Map<String, dynamic> data) =>
    Query_ErsteSchritte.fromJson(data);
typedef OnQueryComplete_Query_ErsteSchritte =
    FutureOr<void> Function(Map<String, dynamic>?, Query_ErsteSchritte?);

class Options_Query_ErsteSchritte
    extends graphql.QueryOptions<Query_ErsteSchritte> {
  Options_Query_ErsteSchritte({
    String? operationName,
    required Variables_Query_ErsteSchritte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_ErsteSchritte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_ErsteSchritte? onComplete,
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
                 data == null ? null : _parserFn_Query_ErsteSchritte(data),
               ),
         onError: onError,
         document: documentNodeQueryErsteSchritte,
         parserFn: _parserFn_Query_ErsteSchritte,
       );

  final OnQueryComplete_Query_ErsteSchritte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_ErsteSchritte
    extends graphql.WatchQueryOptions<Query_ErsteSchritte> {
  WatchOptions_Query_ErsteSchritte({
    String? operationName,
    required Variables_Query_ErsteSchritte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_ErsteSchritte? typedOptimisticResult,
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
         document: documentNodeQueryErsteSchritte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_ErsteSchritte,
       );
}

class FetchMoreOptions_Query_ErsteSchritte extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_ErsteSchritte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_ErsteSchritte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryErsteSchritte,
       );
}

extension ClientExtension_Query_ErsteSchritte on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_ErsteSchritte>> query_ErsteSchritte(
    Options_Query_ErsteSchritte options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_ErsteSchritte> watchQuery_ErsteSchritte(
    WatchOptions_Query_ErsteSchritte options,
  ) => this.watchQuery(options);

  void writeQuery_ErsteSchritte({
    required Query_ErsteSchritte data,
    required Variables_Query_ErsteSchritte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryErsteSchritte),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_ErsteSchritte? readQuery_ErsteSchritte({
    required Variables_Query_ErsteSchritte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryErsteSchritte),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_ErsteSchritte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_ErsteSchritte> useQuery_ErsteSchritte(
  Options_Query_ErsteSchritte options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_ErsteSchritte> useWatchQuery_ErsteSchritte(
  WatchOptions_Query_ErsteSchritte options,
) => graphql_flutter.useWatchQuery(options);

class Query_ErsteSchritte_Widget
    extends graphql_flutter.Query<Query_ErsteSchritte> {
  Query_ErsteSchritte_Widget({
    widgets.Key? key,
    required Options_Query_ErsteSchritte options,
    required graphql_flutter.QueryBuilder<Query_ErsteSchritte> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_ErsteSchritte_kommune {
  Query_ErsteSchritte_kommune({
    required this.id,
    required this.name,
    required this.prozessGroups,
    this.prozesseUndLeistungen,
    this.$__typename = 'Kommune',
  });

  factory Query_ErsteSchritte_kommune.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$prozessGroups = json['prozessGroups'];
    final l$prozesseUndLeistungen = json['prozesseUndLeistungen'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune(
      id: (l$id as String),
      name: (l$name as String),
      prozessGroups: (l$prozessGroups as List<dynamic>)
          .map(
            (e) => Query_ErsteSchritte_kommune_prozessGroups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      prozesseUndLeistungen: l$prozesseUndLeistungen == null
          ? null
          : Query_ErsteSchritte_kommune_prozesseUndLeistungen.fromJson(
              (l$prozesseUndLeistungen as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Query_ErsteSchritte_kommune_prozessGroups> prozessGroups;

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen?
  prozesseUndLeistungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$prozessGroups = prozessGroups;
    _resultData['prozessGroups'] = l$prozessGroups
        .map((e) => e.toJson())
        .toList();
    final l$prozesseUndLeistungen = prozesseUndLeistungen;
    _resultData['prozesseUndLeistungen'] = l$prozesseUndLeistungen?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$prozessGroups = prozessGroups;
    final l$prozesseUndLeistungen = prozesseUndLeistungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      Object.hashAll(l$prozessGroups.map((v) => v)),
      l$prozesseUndLeistungen,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ErsteSchritte_kommune ||
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
    final l$prozessGroups = prozessGroups;
    final lOther$prozessGroups = other.prozessGroups;
    if (l$prozessGroups.length != lOther$prozessGroups.length) {
      return false;
    }
    for (int i = 0; i < l$prozessGroups.length; i++) {
      final l$prozessGroups$entry = l$prozessGroups[i];
      final lOther$prozessGroups$entry = lOther$prozessGroups[i];
      if (l$prozessGroups$entry != lOther$prozessGroups$entry) {
        return false;
      }
    }
    final l$prozesseUndLeistungen = prozesseUndLeistungen;
    final lOther$prozesseUndLeistungen = other.prozesseUndLeistungen;
    if (l$prozesseUndLeistungen != lOther$prozesseUndLeistungen) {
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

extension UtilityExtension_Query_ErsteSchritte_kommune
    on Query_ErsteSchritte_kommune {
  CopyWith_Query_ErsteSchritte_kommune<Query_ErsteSchritte_kommune>
  get copyWith => CopyWith_Query_ErsteSchritte_kommune(this, (i) => i);
}

abstract class CopyWith_Query_ErsteSchritte_kommune<TRes> {
  factory CopyWith_Query_ErsteSchritte_kommune(
    Query_ErsteSchritte_kommune instance,
    TRes Function(Query_ErsteSchritte_kommune) then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune;

  factory CopyWith_Query_ErsteSchritte_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_ErsteSchritte_kommune;

  TRes call({
    String? id,
    String? name,
    List<Query_ErsteSchritte_kommune_prozessGroups>? prozessGroups,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen? prozesseUndLeistungen,
    String? $__typename,
  });
  TRes prozessGroups(
    Iterable<Query_ErsteSchritte_kommune_prozessGroups> Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozessGroups<
          Query_ErsteSchritte_kommune_prozessGroups
        >
      >,
    )
    _fn,
  );
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes>
  get prozesseUndLeistungen;
}

class _CopyWithImpl_Query_ErsteSchritte_kommune<TRes>
    implements CopyWith_Query_ErsteSchritte_kommune<TRes> {
  _CopyWithImpl_Query_ErsteSchritte_kommune(this._instance, this._then);

  final Query_ErsteSchritte_kommune _instance;

  final TRes Function(Query_ErsteSchritte_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? prozessGroups = _undefined,
    Object? prozesseUndLeistungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      prozessGroups: prozessGroups == _undefined || prozessGroups == null
          ? _instance.prozessGroups
          : (prozessGroups as List<Query_ErsteSchritte_kommune_prozessGroups>),
      prozesseUndLeistungen: prozesseUndLeistungen == _undefined
          ? _instance.prozesseUndLeistungen
          : (prozesseUndLeistungen
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes prozessGroups(
    Iterable<Query_ErsteSchritte_kommune_prozessGroups> Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozessGroups<
          Query_ErsteSchritte_kommune_prozessGroups
        >
      >,
    )
    _fn,
  ) => call(
    prozessGroups: _fn(
      _instance.prozessGroups.map(
        (e) => CopyWith_Query_ErsteSchritte_kommune_prozessGroups(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes>
  get prozesseUndLeistungen {
    final local$prozesseUndLeistungen = _instance.prozesseUndLeistungen;
    return local$prozesseUndLeistungen == null
        ? CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen.stub(
            _then(_instance),
          )
        : CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen(
            local$prozesseUndLeistungen,
            (e) => call(prozesseUndLeistungen: e),
          );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune<TRes>
    implements CopyWith_Query_ErsteSchritte_kommune<TRes> {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Query_ErsteSchritte_kommune_prozessGroups>? prozessGroups,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen? prozesseUndLeistungen,
    String? $__typename,
  }) => _res;

  prozessGroups(_fn) => _res;

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes>
  get prozesseUndLeistungen =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen.stub(_res);
}

class Query_ErsteSchritte_kommune_prozessGroups {
  Query_ErsteSchritte_kommune_prozessGroups({
    required this.name,
    required this.id,
    this.$__typename = 'ProzessGroup',
  });

  factory Query_ErsteSchritte_kommune_prozessGroups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozessGroups(
      name: (l$name as String),
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$name, l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ErsteSchritte_kommune_prozessGroups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozessGroups
    on Query_ErsteSchritte_kommune_prozessGroups {
  CopyWith_Query_ErsteSchritte_kommune_prozessGroups<
    Query_ErsteSchritte_kommune_prozessGroups
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozessGroups(this, (i) => i);
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozessGroups<TRes> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozessGroups(
    Query_ErsteSchritte_kommune_prozessGroups instance,
    TRes Function(Query_ErsteSchritte_kommune_prozessGroups) then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozessGroups;

  factory CopyWith_Query_ErsteSchritte_kommune_prozessGroups.stub(TRes res) =
      _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozessGroups;

  TRes call({String? name, String? id, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozessGroups<TRes>
    implements CopyWith_Query_ErsteSchritte_kommune_prozessGroups<TRes> {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozessGroups(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozessGroups _instance;

  final TRes Function(Query_ErsteSchritte_kommune_prozessGroups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozessGroups(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozessGroups<TRes>
    implements CopyWith_Query_ErsteSchritte_kommune_prozessGroups<TRes> {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozessGroups(this._res);

  TRes _res;

  call({String? name, String? id, String? $__typename}) => _res;
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen({
    this.items,
    required this.pageInfo,
    this.$__typename = 'ProzesseUndLeistungenCollectionSegment',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$pageInfo = json['pageInfo'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen(
      items: (l$items as List<dynamic>?)
          ?.map(
            (e) =>
                Query_ErsteSchritte_kommune_prozesseUndLeistungen_items.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      pageInfo:
          Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo.fromJson(
            (l$pageInfo as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items>? items;

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo pageInfo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items?.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$pageInfo = pageInfo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$items == null ? null : Object.hashAll(l$items.map((v) => v)),
      l$pageInfo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ErsteSchritte_kommune_prozesseUndLeistungen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items != null && lOther$items != null) {
      if (l$items.length != lOther$items.length) {
        return false;
      }
      for (int i = 0; i < l$items.length; i++) {
        final l$items$entry = l$items[i];
        final lOther$items$entry = lOther$items[i];
        if (l$items$entry != lOther$items$entry) {
          return false;
        }
      }
    } else if (l$items != lOther$items) {
      return false;
    }
    final l$pageInfo = pageInfo;
    final lOther$pageInfo = other.pageInfo;
    if (l$pageInfo != lOther$pageInfo) {
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen
  >
  get copyWith => CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen instance,
    TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen) then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen;

  TRes call({
    List<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items>? items,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo? pageInfo,
    String? $__typename,
  });
  TRes items(
    Iterable<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items>? Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
          Query_ErsteSchritte_kommune_prozesseUndLeistungen_items
        >
      >?,
    )
    _fn,
  );
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<TRes>
  get pageInfo;
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes> {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen _instance;

  final TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? pageInfo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen(
      items: items == _undefined
          ? _instance.items
          : (items
                as List<
                  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items
                >?),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items>? Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
          Query_ErsteSchritte_kommune_prozesseUndLeistungen_items
        >
      >?,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items?.map(
        (e) => CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<TRes>
  get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen<TRes> {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen(
    this._res,
  );

  TRes _res;

  call({
    List<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items>? items,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo? pageInfo,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<TRes>
  get pageInfo =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo.stub(
        _res,
      );
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items({
    required this.$__typename,
    required this.id,
    required this.name,
    this.group,
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "ServicePortalLink":
        return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink.fromJson(
          json,
        );

      case "Prozess":
        return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        final l$id = json['id'];
        final l$name = json['name'];
        final l$group = json['group'];
        return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
          $__typename: (l$$__typename as String),
          id: (l$id as String),
          name: (l$name as String),
          group: l$group == null
              ? null
              : Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group.fromJson(
                  (l$group as Map<String, dynamic>),
                ),
        );
    }
  }

  final String $__typename;

  final String id;

  final String name;

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group? group;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$group = group;
    _resultData['group'] = l$group?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$name = name;
    final l$group = group;
    return Object.hashAll([l$$__typename, l$id, l$name, l$group]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
    )
    servicePortalLink,
    required _T Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
    )
    prozess,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "ServicePortalLink":
        return servicePortalLink(
          this
              as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
        );

      case "Prozess":
        return prozess(
          this
              as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
    )?
    servicePortalLink,
    _T Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
    )?
    prozess,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "ServicePortalLink":
        if (servicePortalLink != null) {
          return servicePortalLink(
            this
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
          );
        } else {
          return orElse();
        }

      case "Prozess":
        if (prozess != null) {
          return prozess(
            this
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items instance,
    TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen_items) then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items;

  TRes call({
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group? group,
  });
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<TRes>
  get group;
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<TRes> {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items _instance;

  final TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen_items)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? name = _undefined,
    Object? group = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      group: group == _undefined
          ? _instance.group
          : (group
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group?),
    ),
  );

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<TRes>
  get group {
    final local$group = _instance.group;
    return local$group == null
        ? CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group.stub(
            _then(_instance),
          )
        : CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
            local$group,
            (e) => call(group: e),
          );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items<TRes> {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items(
    this._res,
  );

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group? group,
  }) => _res;

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<TRes>
  get group =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group.stub(
        _res,
      );
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group({
    required this.id,
    required this.name,
    this.$__typename = 'ProzessGroup',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
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
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group ||
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group instance,
    TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group)
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
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

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink
    implements Query_ErsteSchritte_kommune_prozesseUndLeistungen_items {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink({
    required this.url,
    this.$__typename = 'ServicePortalLink',
    required this.id,
    required this.name,
    this.group,
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$name = json['name'];
    final l$group = json['group'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
      url: (l$url as String),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      name: (l$name as String),
      group: l$group == null
          ? null
          : Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group.fromJson(
              (l$group as Map<String, dynamic>),
            ),
    );
  }

  final String url;

  final String $__typename;

  final String id;

  final String name;

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group?
  group;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$group = group;
    _resultData['group'] = l$group?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$name = name;
    final l$group = group;
    return Object.hashAll([l$url, l$$__typename, l$id, l$name, l$group]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink
    instance,
    TRes Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
    )
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink;

  TRes call({
    String? url,
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group?
    group,
  });
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
    TRes
  >
  get group;
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink
  _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? url = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? name = _undefined,
    Object? group = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
      url: url == _undefined || url == null ? _instance.url : (url as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      group: group == _undefined
          ? _instance.group
          : (group
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group?),
    ),
  );

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
    TRes
  >
  get group {
    final local$group = _instance.group;
    return local$group == null
        ? CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group.stub(
            _then(_instance),
          )
        : CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
            local$group,
            (e) => call(group: e),
          );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink(
    this._res,
  );

  TRes _res;

  call({
    String? url,
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group?
    group,
  }) => _res;

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
    TRes
  >
  get group =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group.stub(
        _res,
      );
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess
    implements
        Fragment_Prozess,
        Fragment_ProzessOwnData,
        Query_ErsteSchritte_kommune_prozesseUndLeistungen_items {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess({
    this.$__typename = 'Prozess',
    required this.id,
    required this.name,
    this.group,
    required this.tags,
    required this.kommune,
    this.currentVersion,
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$name = json['name'];
    final l$group = json['group'];
    final l$tags = json['tags'];
    final l$kommune = json['kommune'];
    final l$currentVersion = json['currentVersion'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      name: (l$name as String),
      group: l$group == null
          ? null
          : Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group.fromJson(
              (l$group as Map<String, dynamic>),
            ),
      tags: (l$tags as List<dynamic>)
          .map(
            (e) =>
                Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      kommune: Fragment_KommuneCrypto.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      currentVersion: l$currentVersion == null
          ? null
          : Fragment_ProzessVersion.fromJson(
              (l$currentVersion as Map<String, dynamic>),
            ),
    );
  }

  final String $__typename;

  final String id;

  final String name;

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group?
  group;

  final List<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
  >
  tags;

  final Fragment_KommuneCrypto kommune;

  final Fragment_ProzessVersion? currentVersion;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$group = group;
    _resultData['group'] = l$group?.toJson();
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$kommune = kommune;
    _resultData['kommune'] = l$kommune.toJson();
    final l$currentVersion = currentVersion;
    _resultData['currentVersion'] = l$currentVersion?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$name = name;
    final l$group = group;
    final l$tags = tags;
    final l$kommune = kommune;
    final l$currentVersion = currentVersion;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$name,
      l$group,
      Object.hashAll(l$tags.map((v) => v)),
      l$kommune,
      l$currentVersion,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
        return false;
      }
    }
    final l$kommune = kommune;
    final lOther$kommune = other.kommune;
    if (l$kommune != lOther$kommune) {
      return false;
    }
    final l$currentVersion = currentVersion;
    final lOther$currentVersion = other.currentVersion;
    if (l$currentVersion != lOther$currentVersion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess instance,
    TRes Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
    )
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess;

  TRes call({
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group?
    group,
    List<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags>?
    tags,
    Fragment_KommuneCrypto? kommune,
    Fragment_ProzessVersion? currentVersion,
  });
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
    TRes
  >
  get group;
  TRes tags(
    Iterable<
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
    >
    Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
          Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
        >
      >,
    )
    _fn,
  );
  CopyWith_Fragment_KommuneCrypto<TRes> get kommune;
  CopyWith_Fragment_ProzessVersion<TRes> get currentVersion;
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess
  _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? name = _undefined,
    Object? group = _undefined,
    Object? tags = _undefined,
    Object? kommune = _undefined,
    Object? currentVersion = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      group: group == _undefined
          ? _instance.group
          : (group
                as Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group?),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags
                as List<
                  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
                >),
      kommune: kommune == _undefined || kommune == null
          ? _instance.kommune
          : (kommune as Fragment_KommuneCrypto),
      currentVersion: currentVersion == _undefined
          ? _instance.currentVersion
          : (currentVersion as Fragment_ProzessVersion?),
    ),
  );

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
    TRes
  >
  get group {
    final local$group = _instance.group;
    return local$group == null
        ? CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group.stub(
            _then(_instance),
          )
        : CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
            local$group,
            (e) => call(group: e),
          );
  }

  TRes tags(
    Iterable<
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
    >
    Function(
      Iterable<
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
          Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
        >
      >,
    )
    _fn,
  ) => call(
    tags: _fn(
      _instance.tags.map(
        (e) =>
            CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith_Fragment_KommuneCrypto<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Fragment_KommuneCrypto(
      local$kommune,
      (e) => call(kommune: e),
    );
  }

  CopyWith_Fragment_ProzessVersion<TRes> get currentVersion {
    final local$currentVersion = _instance.currentVersion;
    return local$currentVersion == null
        ? CopyWith_Fragment_ProzessVersion.stub(_then(_instance))
        : CopyWith_Fragment_ProzessVersion(
            local$currentVersion,
            (e) => call(currentVersion: e),
          );
  }
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess(
    this._res,
  );

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? name,
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group?
    group,
    List<Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags>?
    tags,
    Fragment_KommuneCrypto? kommune,
    Fragment_ProzessVersion? currentVersion,
  }) => _res;

  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
    TRes
  >
  get group =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group.stub(
        _res,
      );

  tags(_fn) => _res;

  CopyWith_Fragment_KommuneCrypto<TRes> get kommune =>
      CopyWith_Fragment_KommuneCrypto.stub(_res);

  CopyWith_Fragment_ProzessVersion<TRes> get currentVersion =>
      CopyWith_Fragment_ProzessVersion.stub(_res);
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group
    implements Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group({
    required this.id,
    required this.name,
    this.$__typename = 'ProzessGroup',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
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
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group ||
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group
    instance,
    TRes Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group,
    )
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group
  _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
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

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_group(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
    implements Fragment_Prozess_tags, Fragment_ProzessOwnData_tags {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags({
    required this.id,
    required this.tag,
    this.$__typename = 'ProzessTag',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$tag = json['tag'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
      id: (l$id as String),
      tag: (l$tag as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String tag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$tag = tag;
    _resultData['tag'] = l$tag;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$tag = tag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$tag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$tag = tag;
    final lOther$tag = other.tag;
    if (l$tag != lOther$tag) {
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
    instance,
    TRes Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags,
    )
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags;

  TRes call({String? id, String? tag, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags
  _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? tag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      tag: tag == _undefined || tag == null ? _instance.tag : (tag as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess_tags(
    this._res,
  );

  TRes _res;

  call({String? id, String? tag, String? $__typename}) => _res;
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group
    implements Query_ErsteSchritte_kommune_prozesseUndLeistungen_items_group {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group({
    required this.id,
    required this.name,
    this.$__typename = 'ProzessGroup',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
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
    if (other
            is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group ||
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group
    on
        Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group
    instance,
    TRes Function(
      Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group,
    )
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group
  _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
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

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink_group(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo {
  Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo({
    required this.hasNextPage,
    this.$__typename = 'CollectionSegmentInfo',
  });

  factory Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$$__typename = json['__typename'];
    return Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
      hasNextPage: (l$hasNextPage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool hasNextPage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasNextPage = hasNextPage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$hasNextPage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
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

extension UtilityExtension_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo
    on Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo {
  CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo
  >
  get copyWith =>
      CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
  TRes
> {
  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo instance,
    TRes Function(Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo)
    then,
  ) = _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo;

  factory CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo;

  TRes call({bool? hasNextPage, String? $__typename});
}

class _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
          TRes
        > {
  _CopyWithImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
    this._instance,
    this._then,
  );

  final Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo _instance;

  final TRes Function(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
  TRes
>
    implements
        CopyWith_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo<
          TRes
        > {
  _CopyWithStubImpl_Query_ErsteSchritte_kommune_prozesseUndLeistungen_pageInfo(
    this._res,
  );

  TRes _res;

  call({bool? hasNextPage, String? $__typename}) => _res;
}

class Variables_Mutation_AusfuehrungErstellen {
  factory Variables_Mutation_AusfuehrungErstellen({
    required Input_AusfuehrungCreateInput input,
  }) => Variables_Mutation_AusfuehrungErstellen._({r'input': input});

  Variables_Mutation_AusfuehrungErstellen._(this._$data);

  factory Variables_Mutation_AusfuehrungErstellen.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_AusfuehrungCreateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_AusfuehrungErstellen._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_AusfuehrungCreateInput get input =>
      (_$data['input'] as Input_AusfuehrungCreateInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_AusfuehrungErstellen<
    Variables_Mutation_AusfuehrungErstellen
  >
  get copyWith =>
      CopyWith_Variables_Mutation_AusfuehrungErstellen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_AusfuehrungErstellen ||
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

abstract class CopyWith_Variables_Mutation_AusfuehrungErstellen<TRes> {
  factory CopyWith_Variables_Mutation_AusfuehrungErstellen(
    Variables_Mutation_AusfuehrungErstellen instance,
    TRes Function(Variables_Mutation_AusfuehrungErstellen) then,
  ) = _CopyWithImpl_Variables_Mutation_AusfuehrungErstellen;

  factory CopyWith_Variables_Mutation_AusfuehrungErstellen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_AusfuehrungErstellen;

  TRes call({Input_AusfuehrungCreateInput? input});
}

class _CopyWithImpl_Variables_Mutation_AusfuehrungErstellen<TRes>
    implements CopyWith_Variables_Mutation_AusfuehrungErstellen<TRes> {
  _CopyWithImpl_Variables_Mutation_AusfuehrungErstellen(
    this._instance,
    this._then,
  );

  final Variables_Mutation_AusfuehrungErstellen _instance;

  final TRes Function(Variables_Mutation_AusfuehrungErstellen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_AusfuehrungErstellen._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_AusfuehrungCreateInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_AusfuehrungErstellen<TRes>
    implements CopyWith_Variables_Mutation_AusfuehrungErstellen<TRes> {
  _CopyWithStubImpl_Variables_Mutation_AusfuehrungErstellen(this._res);

  TRes _res;

  call({Input_AusfuehrungCreateInput? input}) => _res;
}

class Mutation_AusfuehrungErstellen {
  Mutation_AusfuehrungErstellen({
    required this.ausfuehrungCreate,
    this.$__typename = 'Mutation',
  });

  factory Mutation_AusfuehrungErstellen.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrungCreate = json['ausfuehrungCreate'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen(
      ausfuehrungCreate:
          Mutation_AusfuehrungErstellen_ausfuehrungCreate.fromJson(
            (l$ausfuehrungCreate as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate ausfuehrungCreate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrungCreate = ausfuehrungCreate;
    _resultData['ausfuehrungCreate'] = l$ausfuehrungCreate.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrungCreate = ausfuehrungCreate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrungCreate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_AusfuehrungErstellen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungCreate = ausfuehrungCreate;
    final lOther$ausfuehrungCreate = other.ausfuehrungCreate;
    if (l$ausfuehrungCreate != lOther$ausfuehrungCreate) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen
    on Mutation_AusfuehrungErstellen {
  CopyWith_Mutation_AusfuehrungErstellen<Mutation_AusfuehrungErstellen>
  get copyWith => CopyWith_Mutation_AusfuehrungErstellen(this, (i) => i);
}

abstract class CopyWith_Mutation_AusfuehrungErstellen<TRes> {
  factory CopyWith_Mutation_AusfuehrungErstellen(
    Mutation_AusfuehrungErstellen instance,
    TRes Function(Mutation_AusfuehrungErstellen) then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen;

  factory CopyWith_Mutation_AusfuehrungErstellen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_AusfuehrungErstellen;

  TRes call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate? ausfuehrungCreate,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes>
  get ausfuehrungCreate;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen<TRes>
    implements CopyWith_Mutation_AusfuehrungErstellen<TRes> {
  _CopyWithImpl_Mutation_AusfuehrungErstellen(this._instance, this._then);

  final Mutation_AusfuehrungErstellen _instance;

  final TRes Function(Mutation_AusfuehrungErstellen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungCreate = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen(
      ausfuehrungCreate:
          ausfuehrungCreate == _undefined || ausfuehrungCreate == null
          ? _instance.ausfuehrungCreate
          : (ausfuehrungCreate
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes>
  get ausfuehrungCreate {
    final local$ausfuehrungCreate = _instance.ausfuehrungCreate;
    return CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate(
      local$ausfuehrungCreate,
      (e) => call(ausfuehrungCreate: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen<TRes>
    implements CopyWith_Mutation_AusfuehrungErstellen<TRes> {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen(this._res);

  TRes _res;

  call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate? ausfuehrungCreate,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes>
  get ausfuehrungCreate =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate.stub(_res);
}

const documentNodeMutationAusfuehrungErstellen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'AusfuehrungErstellen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'AusfuehrungCreateInput'),
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
            name: NameNode(value: 'ausfuehrungCreate'),
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
                  name: NameNode(value: 'ausfuehrungResult'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'ausfuehrung'),
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
                              name: NameNode(value: 'prozessVersion'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'prozess'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: SelectionSetNode(
                                      selections: [
                                        FieldNode(
                                          name: NameNode(value: 'kommune'),
                                          alias: null,
                                          arguments: [],
                                          directives: [],
                                          selectionSet: SelectionSetNode(
                                            selections: [
                                              FieldNode(
                                                name: NameNode(
                                                  value: 'maengelAusfuehrungen',
                                                ),
                                                alias: null,
                                                arguments: [],
                                                directives: [],
                                                selectionSet: SelectionSetNode(
                                                  selections: [
                                                    FieldNode(
                                                      name: NameNode(
                                                        value: 'id',
                                                      ),
                                                      alias: null,
                                                      arguments: [],
                                                      directives: [],
                                                      selectionSet: null,
                                                    ),
                                                    FieldNode(
                                                      name: NameNode(
                                                        value: '__typename',
                                                      ),
                                                      alias: null,
                                                      arguments: [],
                                                      directives: [],
                                                      selectionSet: null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              FieldNode(
                                                name: NameNode(
                                                  value: '__typename',
                                                ),
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
                      FieldNode(
                        name: NameNode(value: 'shouldContinue'),
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
Mutation_AusfuehrungErstellen _parserFn_Mutation_AusfuehrungErstellen(
  Map<String, dynamic> data,
) => Mutation_AusfuehrungErstellen.fromJson(data);
typedef OnMutationCompleted_Mutation_AusfuehrungErstellen =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_AusfuehrungErstellen?,
    );

class Options_Mutation_AusfuehrungErstellen
    extends graphql.MutationOptions<Mutation_AusfuehrungErstellen> {
  Options_Mutation_AusfuehrungErstellen({
    String? operationName,
    required Variables_Mutation_AusfuehrungErstellen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungErstellen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_AusfuehrungErstellen? onCompleted,
    graphql.OnMutationUpdate<Mutation_AusfuehrungErstellen>? update,
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
                     : _parserFn_Mutation_AusfuehrungErstellen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAusfuehrungErstellen,
         parserFn: _parserFn_Mutation_AusfuehrungErstellen,
       );

  final OnMutationCompleted_Mutation_AusfuehrungErstellen?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_AusfuehrungErstellen
    extends graphql.WatchQueryOptions<Mutation_AusfuehrungErstellen> {
  WatchOptions_Mutation_AusfuehrungErstellen({
    String? operationName,
    required Variables_Mutation_AusfuehrungErstellen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungErstellen? typedOptimisticResult,
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
         document: documentNodeMutationAusfuehrungErstellen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_AusfuehrungErstellen,
       );
}

extension ClientExtension_Mutation_AusfuehrungErstellen
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_AusfuehrungErstellen>>
  mutate_AusfuehrungErstellen(
    Options_Mutation_AusfuehrungErstellen options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_AusfuehrungErstellen>
  watchMutation_AusfuehrungErstellen(
    WatchOptions_Mutation_AusfuehrungErstellen options,
  ) => this.watchMutation(options);
}

class Mutation_AusfuehrungErstellen_HookResult {
  Mutation_AusfuehrungErstellen_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_AusfuehrungErstellen runMutation;

  final graphql.QueryResult<Mutation_AusfuehrungErstellen> result;
}

Mutation_AusfuehrungErstellen_HookResult useMutation_AusfuehrungErstellen([
  WidgetOptions_Mutation_AusfuehrungErstellen? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_AusfuehrungErstellen(),
  );
  return Mutation_AusfuehrungErstellen_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_AusfuehrungErstellen>
useWatchMutation_AusfuehrungErstellen(
  WatchOptions_Mutation_AusfuehrungErstellen options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_AusfuehrungErstellen
    extends graphql.MutationOptions<Mutation_AusfuehrungErstellen> {
  WidgetOptions_Mutation_AusfuehrungErstellen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungErstellen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_AusfuehrungErstellen? onCompleted,
    graphql.OnMutationUpdate<Mutation_AusfuehrungErstellen>? update,
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
                     : _parserFn_Mutation_AusfuehrungErstellen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAusfuehrungErstellen,
         parserFn: _parserFn_Mutation_AusfuehrungErstellen,
       );

  final OnMutationCompleted_Mutation_AusfuehrungErstellen?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_AusfuehrungErstellen =
    graphql.MultiSourceResult<Mutation_AusfuehrungErstellen> Function(
      Variables_Mutation_AusfuehrungErstellen, {
      Object? optimisticResult,
      Mutation_AusfuehrungErstellen? typedOptimisticResult,
    });
typedef Builder_Mutation_AusfuehrungErstellen =
    widgets.Widget Function(
      RunMutation_Mutation_AusfuehrungErstellen,
      graphql.QueryResult<Mutation_AusfuehrungErstellen>?,
    );

class Mutation_AusfuehrungErstellen_Widget
    extends graphql_flutter.Mutation<Mutation_AusfuehrungErstellen> {
  Mutation_AusfuehrungErstellen_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_AusfuehrungErstellen? options,
    required Builder_Mutation_AusfuehrungErstellen builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_AusfuehrungErstellen(),
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

class Mutation_AusfuehrungErstellen_ausfuehrungCreate {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate({
    this.ausfuehrungResult,
    this.$__typename = 'AusfuehrungCreatePayload',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ausfuehrungResult = json['ausfuehrungResult'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate(
      ausfuehrungResult: l$ausfuehrungResult == null
          ? null
          : Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult.fromJson(
              (l$ausfuehrungResult as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult?
  ausfuehrungResult;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrungResult = ausfuehrungResult;
    _resultData['ausfuehrungResult'] = l$ausfuehrungResult?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrungResult = ausfuehrungResult;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrungResult, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_AusfuehrungErstellen_ausfuehrungCreate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungResult = ausfuehrungResult;
    final lOther$ausfuehrungResult = other.ausfuehrungResult;
    if (l$ausfuehrungResult != lOther$ausfuehrungResult) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate
    on Mutation_AusfuehrungErstellen_ausfuehrungCreate {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate(this, (i) => i);
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate instance,
    TRes Function(Mutation_AusfuehrungErstellen_ausfuehrungCreate) then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate;

  TRes call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult?
    ausfuehrungResult,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes>
    implements CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes> {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate _instance;

  final TRes Function(Mutation_AusfuehrungErstellen_ausfuehrungCreate) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungResult = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate(
      ausfuehrungResult: ausfuehrungResult == _undefined
          ? _instance.ausfuehrungResult
          : (ausfuehrungResult
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult {
    final local$ausfuehrungResult = _instance.ausfuehrungResult;
    return local$ausfuehrungResult == null
        ? CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
            local$ausfuehrungResult,
            (e) => call(ausfuehrungResult: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes>
    implements CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate<TRes> {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate(this._res);

  TRes _res;

  call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult?
    ausfuehrungResult,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult.stub(
        _res,
      );
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult({
    required this.ausfuehrung,
    required this.shouldContinue,
    this.$__typename = 'AusfuehrungResult',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ausfuehrung = json['ausfuehrung'];
    final l$shouldContinue = json['shouldContinue'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
      ausfuehrung:
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung.fromJson(
            (l$ausfuehrung as Map<String, dynamic>),
          ),
      shouldContinue: (l$shouldContinue as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung
  ausfuehrung;

  final bool shouldContinue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrung = ausfuehrung;
    _resultData['ausfuehrung'] = l$ausfuehrung.toJson();
    final l$shouldContinue = shouldContinue;
    _resultData['shouldContinue'] = l$shouldContinue;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrung = ausfuehrung;
    final l$shouldContinue = shouldContinue;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrung, l$shouldContinue, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrung = ausfuehrung;
    final lOther$ausfuehrung = other.ausfuehrung;
    if (l$ausfuehrung != lOther$ausfuehrung) {
      return false;
    }
    final l$shouldContinue = shouldContinue;
    final lOther$shouldContinue = other.shouldContinue;
    if (l$shouldContinue != lOther$shouldContinue) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult
    on Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult;

  TRes call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung?
    ausfuehrung,
    bool? shouldContinue,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrung = _undefined,
    Object? shouldContinue = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
      ausfuehrung: ausfuehrung == _undefined || ausfuehrung == null
          ? _instance.ausfuehrung
          : (ausfuehrung
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung),
      shouldContinue: shouldContinue == _undefined || shouldContinue == null
          ? _instance.shouldContinue
          : (shouldContinue as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung {
    final local$ausfuehrung = _instance.ausfuehrung;
    return CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
      local$ausfuehrung,
      (e) => call(ausfuehrung: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult(
    this._res,
  );

  TRes _res;

  call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung?
    ausfuehrung,
    bool? shouldContinue,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung.stub(
        _res,
      );
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung({
    required this.id,
    required this.prozessVersion,
    this.$__typename = 'Ausfuehrung',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$prozessVersion = json['prozessVersion'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
      id: (l$id as String),
      prozessVersion:
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion.fromJson(
            (l$prozessVersion as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion
  prozessVersion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$prozessVersion = prozessVersion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$prozessVersion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$prozessVersion = prozessVersion;
    final lOther$prozessVersion = other.prozessVersion;
    if (l$prozessVersion != lOther$prozessVersion) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung
    on Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung
    instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung;

  TRes call({
    String? id,
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion?
    prozessVersion,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
    TRes
  >
  get prozessVersion;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? prozessVersion = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
    TRes
  >
  get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion?
    prozessVersion,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
    TRes
  >
  get prozessVersion =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion.stub(
        _res,
      );
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion({
    required this.prozess,
    this.$__typename = 'ProzessVersion',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$prozess = json['prozess'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
      prozess:
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess.fromJson(
            (l$prozess as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess
  prozess;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$prozess = prozess;
    _resultData['prozess'] = l$prozess.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$prozess = prozess;
    final l$$__typename = $__typename;
    return Object.hashAll([l$prozess, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$prozess = prozess;
    final lOther$prozess = other.prozess;
    if (l$prozess != lOther$prozess) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion
    on
        Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion
    instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion;

  TRes call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess?
    prozess,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
    TRes
  >
  get prozess;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? prozess = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
      prozess: prozess == _undefined || prozess == null
          ? _instance.prozess
          : (prozess
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
    TRes
  >
  get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion(
    this._res,
  );

  TRes _res;

  call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess?
    prozess,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
    TRes
  >
  get prozess =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess.stub(
        _res,
      );
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess({
    required this.kommune,
    this.$__typename = 'Prozess',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
      kommune:
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune.fromJson(
            (l$kommune as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune
  kommune;

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
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess ||
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess
    on
        Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess
    instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess;

  TRes call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune?
    kommune,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
    TRes
  >
  get kommune;
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommune = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
      kommune: kommune == _undefined || kommune == null
          ? _instance.kommune
          : (kommune
                as Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
    TRes
  >
  get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess(
    this._res,
  );

  TRes _res;

  call({
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune?
    kommune,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
    TRes
  >
  get kommune =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune.stub(
        _res,
      );
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune({
    required this.maengelAusfuehrungen,
    this.$__typename = 'Kommune',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$maengelAusfuehrungen = json['maengelAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
      maengelAusfuehrungen: (l$maengelAusfuehrungen as List<dynamic>)
          .map(
            (e) =>
                Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
  >
  maengelAusfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    _resultData['maengelAusfuehrungen'] = l$maengelAusfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$maengelAusfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final lOther$maengelAusfuehrungen = other.maengelAusfuehrungen;
    if (l$maengelAusfuehrungen.length != lOther$maengelAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$maengelAusfuehrungen.length; i++) {
      final l$maengelAusfuehrungen$entry = l$maengelAusfuehrungen[i];
      final lOther$maengelAusfuehrungen$entry = lOther$maengelAusfuehrungen[i];
      if (l$maengelAusfuehrungen$entry != lOther$maengelAusfuehrungen$entry) {
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune
    on
        Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune
    instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune;

  TRes call({
    List<
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    >?
    maengelAusfuehrungen,
    String? $__typename,
  });
  TRes maengelAusfuehrungen(
    Iterable<
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    >
    Function(
      Iterable<
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? maengelAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
      maengelAusfuehrungen:
          maengelAusfuehrungen == _undefined || maengelAusfuehrungen == null
          ? _instance.maengelAusfuehrungen
          : (maengelAusfuehrungen
                as List<
                  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes maengelAusfuehrungen(
    Iterable<
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    >
    Function(
      Iterable<
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
          Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
        >
      >,
    )
    _fn,
  ) => call(
    maengelAusfuehrungen: _fn(
      _instance.maengelAusfuehrungen.map(
        (e) =>
            CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune(
    this._res,
  );

  TRes _res;

  call({
    List<
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    >?
    maengelAusfuehrungen,
    String? $__typename,
  }) => _res;

  maengelAusfuehrungen(_fn) => _res;
}

class Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen {
  Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen({
    required this.id,
    this.$__typename = 'Ausfuehrung',
  });

  factory Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
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
    if (other
            is! Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen ||
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

extension UtilityExtension_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    on
        Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen {
  CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
    instance,
    TRes Function(
      Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen;

  factory CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen
  _instance;

  final TRes Function(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungErstellen_ausfuehrungCreate_ausfuehrungResult_ausfuehrung_prozessVersion_prozess_kommune_maengelAusfuehrungen(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables_Mutation_AusfuehrungFortsetzen {
  factory Variables_Mutation_AusfuehrungFortsetzen({
    required Input_AusfuehrungContinueInput input,
  }) => Variables_Mutation_AusfuehrungFortsetzen._({r'input': input});

  Variables_Mutation_AusfuehrungFortsetzen._(this._$data);

  factory Variables_Mutation_AusfuehrungFortsetzen.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_AusfuehrungContinueInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_AusfuehrungFortsetzen._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_AusfuehrungContinueInput get input =>
      (_$data['input'] as Input_AusfuehrungContinueInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_AusfuehrungFortsetzen<
    Variables_Mutation_AusfuehrungFortsetzen
  >
  get copyWith =>
      CopyWith_Variables_Mutation_AusfuehrungFortsetzen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_AusfuehrungFortsetzen ||
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

abstract class CopyWith_Variables_Mutation_AusfuehrungFortsetzen<TRes> {
  factory CopyWith_Variables_Mutation_AusfuehrungFortsetzen(
    Variables_Mutation_AusfuehrungFortsetzen instance,
    TRes Function(Variables_Mutation_AusfuehrungFortsetzen) then,
  ) = _CopyWithImpl_Variables_Mutation_AusfuehrungFortsetzen;

  factory CopyWith_Variables_Mutation_AusfuehrungFortsetzen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_AusfuehrungFortsetzen;

  TRes call({Input_AusfuehrungContinueInput? input});
}

class _CopyWithImpl_Variables_Mutation_AusfuehrungFortsetzen<TRes>
    implements CopyWith_Variables_Mutation_AusfuehrungFortsetzen<TRes> {
  _CopyWithImpl_Variables_Mutation_AusfuehrungFortsetzen(
    this._instance,
    this._then,
  );

  final Variables_Mutation_AusfuehrungFortsetzen _instance;

  final TRes Function(Variables_Mutation_AusfuehrungFortsetzen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_AusfuehrungFortsetzen._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_AusfuehrungContinueInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_AusfuehrungFortsetzen<TRes>
    implements CopyWith_Variables_Mutation_AusfuehrungFortsetzen<TRes> {
  _CopyWithStubImpl_Variables_Mutation_AusfuehrungFortsetzen(this._res);

  TRes _res;

  call({Input_AusfuehrungContinueInput? input}) => _res;
}

class Mutation_AusfuehrungFortsetzen {
  Mutation_AusfuehrungFortsetzen({
    required this.ausfuehrungContinue,
    this.$__typename = 'Mutation',
  });

  factory Mutation_AusfuehrungFortsetzen.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrungContinue = json['ausfuehrungContinue'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungFortsetzen(
      ausfuehrungContinue:
          Mutation_AusfuehrungFortsetzen_ausfuehrungContinue.fromJson(
            (l$ausfuehrungContinue as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue ausfuehrungContinue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrungContinue = ausfuehrungContinue;
    _resultData['ausfuehrungContinue'] = l$ausfuehrungContinue.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrungContinue = ausfuehrungContinue;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrungContinue, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_AusfuehrungFortsetzen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungContinue = ausfuehrungContinue;
    final lOther$ausfuehrungContinue = other.ausfuehrungContinue;
    if (l$ausfuehrungContinue != lOther$ausfuehrungContinue) {
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

extension UtilityExtension_Mutation_AusfuehrungFortsetzen
    on Mutation_AusfuehrungFortsetzen {
  CopyWith_Mutation_AusfuehrungFortsetzen<Mutation_AusfuehrungFortsetzen>
  get copyWith => CopyWith_Mutation_AusfuehrungFortsetzen(this, (i) => i);
}

abstract class CopyWith_Mutation_AusfuehrungFortsetzen<TRes> {
  factory CopyWith_Mutation_AusfuehrungFortsetzen(
    Mutation_AusfuehrungFortsetzen instance,
    TRes Function(Mutation_AusfuehrungFortsetzen) then,
  ) = _CopyWithImpl_Mutation_AusfuehrungFortsetzen;

  factory CopyWith_Mutation_AusfuehrungFortsetzen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen;

  TRes call({
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue? ausfuehrungContinue,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes>
  get ausfuehrungContinue;
}

class _CopyWithImpl_Mutation_AusfuehrungFortsetzen<TRes>
    implements CopyWith_Mutation_AusfuehrungFortsetzen<TRes> {
  _CopyWithImpl_Mutation_AusfuehrungFortsetzen(this._instance, this._then);

  final Mutation_AusfuehrungFortsetzen _instance;

  final TRes Function(Mutation_AusfuehrungFortsetzen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungContinue = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungFortsetzen(
      ausfuehrungContinue:
          ausfuehrungContinue == _undefined || ausfuehrungContinue == null
          ? _instance.ausfuehrungContinue
          : (ausfuehrungContinue
                as Mutation_AusfuehrungFortsetzen_ausfuehrungContinue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes>
  get ausfuehrungContinue {
    final local$ausfuehrungContinue = _instance.ausfuehrungContinue;
    return CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
      local$ausfuehrungContinue,
      (e) => call(ausfuehrungContinue: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen<TRes>
    implements CopyWith_Mutation_AusfuehrungFortsetzen<TRes> {
  _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen(this._res);

  TRes _res;

  call({
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue? ausfuehrungContinue,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes>
  get ausfuehrungContinue =>
      CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue.stub(_res);
}

const documentNodeMutationAusfuehrungFortsetzen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'AusfuehrungFortsetzen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'AusfuehrungContinueInput'),
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
            name: NameNode(value: 'ausfuehrungContinue'),
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
                  name: NameNode(value: 'ausfuehrungResult'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'shouldContinue'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'ausfuehrung'),
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
Mutation_AusfuehrungFortsetzen _parserFn_Mutation_AusfuehrungFortsetzen(
  Map<String, dynamic> data,
) => Mutation_AusfuehrungFortsetzen.fromJson(data);
typedef OnMutationCompleted_Mutation_AusfuehrungFortsetzen =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_AusfuehrungFortsetzen?,
    );

class Options_Mutation_AusfuehrungFortsetzen
    extends graphql.MutationOptions<Mutation_AusfuehrungFortsetzen> {
  Options_Mutation_AusfuehrungFortsetzen({
    String? operationName,
    required Variables_Mutation_AusfuehrungFortsetzen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungFortsetzen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_AusfuehrungFortsetzen? onCompleted,
    graphql.OnMutationUpdate<Mutation_AusfuehrungFortsetzen>? update,
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
                     : _parserFn_Mutation_AusfuehrungFortsetzen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAusfuehrungFortsetzen,
         parserFn: _parserFn_Mutation_AusfuehrungFortsetzen,
       );

  final OnMutationCompleted_Mutation_AusfuehrungFortsetzen?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_AusfuehrungFortsetzen
    extends graphql.WatchQueryOptions<Mutation_AusfuehrungFortsetzen> {
  WatchOptions_Mutation_AusfuehrungFortsetzen({
    String? operationName,
    required Variables_Mutation_AusfuehrungFortsetzen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungFortsetzen? typedOptimisticResult,
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
         document: documentNodeMutationAusfuehrungFortsetzen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_AusfuehrungFortsetzen,
       );
}

extension ClientExtension_Mutation_AusfuehrungFortsetzen
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_AusfuehrungFortsetzen>>
  mutate_AusfuehrungFortsetzen(
    Options_Mutation_AusfuehrungFortsetzen options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_AusfuehrungFortsetzen>
  watchMutation_AusfuehrungFortsetzen(
    WatchOptions_Mutation_AusfuehrungFortsetzen options,
  ) => this.watchMutation(options);
}

class Mutation_AusfuehrungFortsetzen_HookResult {
  Mutation_AusfuehrungFortsetzen_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_AusfuehrungFortsetzen runMutation;

  final graphql.QueryResult<Mutation_AusfuehrungFortsetzen> result;
}

Mutation_AusfuehrungFortsetzen_HookResult useMutation_AusfuehrungFortsetzen([
  WidgetOptions_Mutation_AusfuehrungFortsetzen? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_AusfuehrungFortsetzen(),
  );
  return Mutation_AusfuehrungFortsetzen_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_AusfuehrungFortsetzen>
useWatchMutation_AusfuehrungFortsetzen(
  WatchOptions_Mutation_AusfuehrungFortsetzen options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_AusfuehrungFortsetzen
    extends graphql.MutationOptions<Mutation_AusfuehrungFortsetzen> {
  WidgetOptions_Mutation_AusfuehrungFortsetzen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_AusfuehrungFortsetzen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_AusfuehrungFortsetzen? onCompleted,
    graphql.OnMutationUpdate<Mutation_AusfuehrungFortsetzen>? update,
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
                     : _parserFn_Mutation_AusfuehrungFortsetzen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationAusfuehrungFortsetzen,
         parserFn: _parserFn_Mutation_AusfuehrungFortsetzen,
       );

  final OnMutationCompleted_Mutation_AusfuehrungFortsetzen?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_AusfuehrungFortsetzen =
    graphql.MultiSourceResult<Mutation_AusfuehrungFortsetzen> Function(
      Variables_Mutation_AusfuehrungFortsetzen, {
      Object? optimisticResult,
      Mutation_AusfuehrungFortsetzen? typedOptimisticResult,
    });
typedef Builder_Mutation_AusfuehrungFortsetzen =
    widgets.Widget Function(
      RunMutation_Mutation_AusfuehrungFortsetzen,
      graphql.QueryResult<Mutation_AusfuehrungFortsetzen>?,
    );

class Mutation_AusfuehrungFortsetzen_Widget
    extends graphql_flutter.Mutation<Mutation_AusfuehrungFortsetzen> {
  Mutation_AusfuehrungFortsetzen_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_AusfuehrungFortsetzen? options,
    required Builder_Mutation_AusfuehrungFortsetzen builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_AusfuehrungFortsetzen(),
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

class Mutation_AusfuehrungFortsetzen_ausfuehrungContinue {
  Mutation_AusfuehrungFortsetzen_ausfuehrungContinue({
    this.ausfuehrungResult,
    this.$__typename = 'AusfuehrungContinuePayload',
  });

  factory Mutation_AusfuehrungFortsetzen_ausfuehrungContinue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ausfuehrungResult = json['ausfuehrungResult'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
      ausfuehrungResult: l$ausfuehrungResult == null
          ? null
          : Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult.fromJson(
              (l$ausfuehrungResult as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult?
  ausfuehrungResult;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrungResult = ausfuehrungResult;
    _resultData['ausfuehrungResult'] = l$ausfuehrungResult?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrungResult = ausfuehrungResult;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrungResult, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_AusfuehrungFortsetzen_ausfuehrungContinue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungResult = ausfuehrungResult;
    final lOther$ausfuehrungResult = other.ausfuehrungResult;
    if (l$ausfuehrungResult != lOther$ausfuehrungResult) {
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

extension UtilityExtension_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue
    on Mutation_AusfuehrungFortsetzen_ausfuehrungContinue {
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue
  >
  get copyWith => CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue instance,
    TRes Function(Mutation_AusfuehrungFortsetzen_ausfuehrungContinue) then,
  ) = _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue;

  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue;

  TRes call({
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult?
    ausfuehrungResult,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult;
}

class _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes> {
  _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue _instance;

  final TRes Function(Mutation_AusfuehrungFortsetzen_ausfuehrungContinue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungResult = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
      ausfuehrungResult: ausfuehrungResult == _undefined
          ? _instance.ausfuehrungResult
          : (ausfuehrungResult
                as Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult {
    final local$ausfuehrungResult = _instance.ausfuehrungResult;
    return local$ausfuehrungResult == null
        ? CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
            local$ausfuehrungResult,
            (e) => call(ausfuehrungResult: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue<TRes> {
  _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue(
    this._res,
  );

  TRes _res;

  call({
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult?
    ausfuehrungResult,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
    TRes
  >
  get ausfuehrungResult =>
      CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult.stub(
        _res,
      );
}

class Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult {
  Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult({
    required this.shouldContinue,
    required this.ausfuehrung,
    this.$__typename = 'AusfuehrungResult',
  });

  factory Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$shouldContinue = json['shouldContinue'];
    final l$ausfuehrung = json['ausfuehrung'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
      shouldContinue: (l$shouldContinue as bool),
      ausfuehrung:
          Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung.fromJson(
            (l$ausfuehrung as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool shouldContinue;

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung
  ausfuehrung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shouldContinue = shouldContinue;
    _resultData['shouldContinue'] = l$shouldContinue;
    final l$ausfuehrung = ausfuehrung;
    _resultData['ausfuehrung'] = l$ausfuehrung.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shouldContinue = shouldContinue;
    final l$ausfuehrung = ausfuehrung;
    final l$$__typename = $__typename;
    return Object.hashAll([l$shouldContinue, l$ausfuehrung, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$shouldContinue = shouldContinue;
    final lOther$shouldContinue = other.shouldContinue;
    if (l$shouldContinue != lOther$shouldContinue) {
      return false;
    }
    final l$ausfuehrung = ausfuehrung;
    final lOther$ausfuehrung = other.ausfuehrung;
    if (l$ausfuehrung != lOther$ausfuehrung) {
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

extension UtilityExtension_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult
    on Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult {
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult
    instance,
    TRes Function(
      Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult;

  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult;

  TRes call({
    bool? shouldContinue,
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung?
    ausfuehrung,
    String? $__typename,
  });
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung;
}

class _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult
  _instance;

  final TRes Function(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? shouldContinue = _undefined,
    Object? ausfuehrung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
      shouldContinue: shouldContinue == _undefined || shouldContinue == null
          ? _instance.shouldContinue
          : (shouldContinue as bool),
      ausfuehrung: ausfuehrung == _undefined || ausfuehrung == null
          ? _instance.ausfuehrung
          : (ausfuehrung
                as Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung {
    final local$ausfuehrung = _instance.ausfuehrung;
    return CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
      local$ausfuehrung,
      (e) => call(ausfuehrung: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult(
    this._res,
  );

  TRes _res;

  call({
    bool? shouldContinue,
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung?
    ausfuehrung,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
    TRes
  >
  get ausfuehrung =>
      CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung.stub(
        _res,
      );
}

class Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung {
  Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung({
    required this.id,
    this.$__typename = 'Ausfuehrung',
  });

  factory Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
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
    if (other
            is! Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung ||
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

extension UtilityExtension_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung
    on
        Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung {
  CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung
  >
  get copyWith =>
      CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
  TRes
> {
  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung
    instance,
    TRes Function(
      Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung,
    )
    then,
  ) = _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung;

  factory CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
          TRes
        > {
  _CopyWithImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
    this._instance,
    this._then,
  );

  final Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung
  _instance;

  final TRes Function(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
  TRes
>
    implements
        CopyWith_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung<
          TRes
        > {
  _CopyWithStubImpl_Mutation_AusfuehrungFortsetzen_ausfuehrungContinue_ausfuehrungResult_ausfuehrung(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_Ausfuehrungen {
  Query_Ausfuehrungen({required this.my, this.$__typename = 'Query'});

  factory Query_Ausfuehrungen.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_Ausfuehrungen(
      my: Query_Ausfuehrungen_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Ausfuehrungen_my my;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$my = my;
    _resultData['my'] = l$my.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$my = my;
    final l$$__typename = $__typename;
    return Object.hashAll([l$my, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Ausfuehrungen || runtimeType != other.runtimeType) {
      return false;
    }
    final l$my = my;
    final lOther$my = other.my;
    if (l$my != lOther$my) {
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

extension UtilityExtension_Query_Ausfuehrungen on Query_Ausfuehrungen {
  CopyWith_Query_Ausfuehrungen<Query_Ausfuehrungen> get copyWith =>
      CopyWith_Query_Ausfuehrungen(this, (i) => i);
}

abstract class CopyWith_Query_Ausfuehrungen<TRes> {
  factory CopyWith_Query_Ausfuehrungen(
    Query_Ausfuehrungen instance,
    TRes Function(Query_Ausfuehrungen) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen;

  factory CopyWith_Query_Ausfuehrungen.stub(TRes res) =
      _CopyWithStubImpl_Query_Ausfuehrungen;

  TRes call({Query_Ausfuehrungen_my? my, String? $__typename});
  CopyWith_Query_Ausfuehrungen_my<TRes> get my;
}

class _CopyWithImpl_Query_Ausfuehrungen<TRes>
    implements CopyWith_Query_Ausfuehrungen<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen(this._instance, this._then);

  final Query_Ausfuehrungen _instance;

  final TRes Function(Query_Ausfuehrungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Ausfuehrungen(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_Ausfuehrungen_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Ausfuehrungen_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_Ausfuehrungen_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_Ausfuehrungen<TRes>
    implements CopyWith_Query_Ausfuehrungen<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen(this._res);

  TRes _res;

  call({Query_Ausfuehrungen_my? my, String? $__typename}) => _res;

  CopyWith_Query_Ausfuehrungen_my<TRes> get my =>
      CopyWith_Query_Ausfuehrungen_my.stub(_res);
}

const documentNodeQueryAusfuehrungen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Ausfuehrungen'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'my'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Buerger'),
                      isNonNull: false,
                    ),
                  ),
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
                        name: NameNode(value: 'ausfuehrungen'),
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
                              name: NameNode(value: 'createdAt'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(
                                value: 'sharedKeyEncryptedForBuerger',
                              ),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'slotValues'),
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
                                  FieldNode(
                                    name: NameNode(value: 'id'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'slotName'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  InlineFragmentNode(
                                    typeCondition: TypeConditionNode(
                                      on: NamedTypeNode(
                                        name: NameNode(value: 'PlainSlotValue'),
                                        isNonNull: false,
                                      ),
                                    ),
                                    directives: [],
                                    selectionSet: SelectionSetNode(
                                      selections: [
                                        FieldNode(
                                          name: NameNode(value: 'value'),
                                          alias: null,
                                          arguments: [],
                                          directives: [],
                                          selectionSet: null,
                                        ),
                                        FieldNode(
                                          name: NameNode(
                                            value: 'slotValueCount',
                                          ),
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
                                ],
                              ),
                            ),
                            FieldNode(
                              name: NameNode(value: 'prozessVersion'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'ProzessVersion'),
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
                              name: NameNode(value: 'status'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'updatedAt'),
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
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
    fragmentDefinitionProzessOwnData,
  ],
);
Query_Ausfuehrungen _parserFn_Query_Ausfuehrungen(Map<String, dynamic> data) =>
    Query_Ausfuehrungen.fromJson(data);
typedef OnQueryComplete_Query_Ausfuehrungen =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Ausfuehrungen?);

class Options_Query_Ausfuehrungen
    extends graphql.QueryOptions<Query_Ausfuehrungen> {
  Options_Query_Ausfuehrungen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Ausfuehrungen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Ausfuehrungen? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
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
                 data == null ? null : _parserFn_Query_Ausfuehrungen(data),
               ),
         onError: onError,
         document: documentNodeQueryAusfuehrungen,
         parserFn: _parserFn_Query_Ausfuehrungen,
       );

  final OnQueryComplete_Query_Ausfuehrungen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Ausfuehrungen
    extends graphql.WatchQueryOptions<Query_Ausfuehrungen> {
  WatchOptions_Query_Ausfuehrungen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Ausfuehrungen? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryAusfuehrungen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Ausfuehrungen,
       );
}

class FetchMoreOptions_Query_Ausfuehrungen extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Ausfuehrungen({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryAusfuehrungen,
       );
}

extension ClientExtension_Query_Ausfuehrungen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Ausfuehrungen>> query_Ausfuehrungen([
    Options_Query_Ausfuehrungen? options,
  ]) async => await this.query(options ?? Options_Query_Ausfuehrungen());

  graphql.ObservableQuery<Query_Ausfuehrungen> watchQuery_Ausfuehrungen([
    WatchOptions_Query_Ausfuehrungen? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_Ausfuehrungen());

  void writeQuery_Ausfuehrungen({
    required Query_Ausfuehrungen data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryAusfuehrungen),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Ausfuehrungen? readQuery_Ausfuehrungen({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryAusfuehrungen),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Ausfuehrungen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Ausfuehrungen> useQuery_Ausfuehrungen([
  Options_Query_Ausfuehrungen? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_Ausfuehrungen());
graphql.ObservableQuery<Query_Ausfuehrungen> useWatchQuery_Ausfuehrungen([
  WatchOptions_Query_Ausfuehrungen? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_Ausfuehrungen(),
);

class Query_Ausfuehrungen_Widget
    extends graphql_flutter.Query<Query_Ausfuehrungen> {
  Query_Ausfuehrungen_Widget({
    widgets.Key? key,
    Options_Query_Ausfuehrungen? options,
    required graphql_flutter.QueryBuilder<Query_Ausfuehrungen> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_Ausfuehrungen(),
         builder: builder,
       );
}

class Query_Ausfuehrungen_my {
  Query_Ausfuehrungen_my({required this.$__typename});

  factory Query_Ausfuehrungen_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_Ausfuehrungen_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_Ausfuehrungen_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_Ausfuehrungen_my__SystemUser.fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Query_Ausfuehrungen_my($__typename: (l$$__typename as String));
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
    if (other is! Query_Ausfuehrungen_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Ausfuehrungen_my on Query_Ausfuehrungen_my {
  CopyWith_Query_Ausfuehrungen_my<Query_Ausfuehrungen_my> get copyWith =>
      CopyWith_Query_Ausfuehrungen_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_Ausfuehrungen_my__Buerger) buerger,
    required _T Function(Query_Ausfuehrungen_my__BackofficeUser) backofficeUser,
    required _T Function(Query_Ausfuehrungen_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_Ausfuehrungen_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_Ausfuehrungen_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_Ausfuehrungen_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_Ausfuehrungen_my__Buerger)? buerger,
    _T Function(Query_Ausfuehrungen_my__BackofficeUser)? backofficeUser,
    _T Function(Query_Ausfuehrungen_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_Ausfuehrungen_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(this as Query_Ausfuehrungen_my__BackofficeUser);
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_Ausfuehrungen_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_Ausfuehrungen_my<TRes> {
  factory CopyWith_Query_Ausfuehrungen_my(
    Query_Ausfuehrungen_my instance,
    TRes Function(Query_Ausfuehrungen_my) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my;

  factory CopyWith_Query_Ausfuehrungen_my.stub(TRes res) =
      _CopyWithStubImpl_Query_Ausfuehrungen_my;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Query_Ausfuehrungen_my<TRes>
    implements CopyWith_Query_Ausfuehrungen_my<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen_my(this._instance, this._then);

  final Query_Ausfuehrungen_my _instance;

  final TRes Function(Query_Ausfuehrungen_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query_Ausfuehrungen_my(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my<TRes>
    implements CopyWith_Query_Ausfuehrungen_my<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen_my(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query_Ausfuehrungen_my__Buerger implements Query_Ausfuehrungen_my {
  Query_Ausfuehrungen_my__Buerger({
    required this.id,
    required this.ausfuehrungen,
    this.$__typename = 'Buerger',
  });

  factory Query_Ausfuehrungen_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$ausfuehrungen = json['ausfuehrungen'];
    final l$$__typename = json['__typename'];
    return Query_Ausfuehrungen_my__Buerger(
      id: (l$id as String),
      ausfuehrungen: (l$ausfuehrungen as List<dynamic>)
          .map(
            (e) => Query_Ausfuehrungen_my__Buerger_ausfuehrungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen> ausfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$ausfuehrungen = ausfuehrungen;
    _resultData['ausfuehrungen'] = l$ausfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$ausfuehrungen = ausfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$ausfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Ausfuehrungen_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$ausfuehrungen = ausfuehrungen;
    final lOther$ausfuehrungen = other.ausfuehrungen;
    if (l$ausfuehrungen.length != lOther$ausfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$ausfuehrungen.length; i++) {
      final l$ausfuehrungen$entry = l$ausfuehrungen[i];
      final lOther$ausfuehrungen$entry = lOther$ausfuehrungen[i];
      if (l$ausfuehrungen$entry != lOther$ausfuehrungen$entry) {
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

extension UtilityExtension_Query_Ausfuehrungen_my__Buerger
    on Query_Ausfuehrungen_my__Buerger {
  CopyWith_Query_Ausfuehrungen_my__Buerger<Query_Ausfuehrungen_my__Buerger>
  get copyWith => CopyWith_Query_Ausfuehrungen_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_Ausfuehrungen_my__Buerger<TRes> {
  factory CopyWith_Query_Ausfuehrungen_my__Buerger(
    Query_Ausfuehrungen_my__Buerger instance,
    TRes Function(Query_Ausfuehrungen_my__Buerger) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__Buerger;

  factory CopyWith_Query_Ausfuehrungen_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger;

  TRes call({
    String? id,
    List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen>? ausfuehrungen,
    String? $__typename,
  });
  TRes ausfuehrungen(
    Iterable<Query_Ausfuehrungen_my__Buerger_ausfuehrungen> Function(
      Iterable<
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<
          Query_Ausfuehrungen_my__Buerger_ausfuehrungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Ausfuehrungen_my__Buerger<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__Buerger<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen_my__Buerger(this._instance, this._then);

  final Query_Ausfuehrungen_my__Buerger _instance;

  final TRes Function(Query_Ausfuehrungen_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? ausfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Ausfuehrungen_my__Buerger(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      ausfuehrungen: ausfuehrungen == _undefined || ausfuehrungen == null
          ? _instance.ausfuehrungen
          : (ausfuehrungen
                as List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes ausfuehrungen(
    Iterable<Query_Ausfuehrungen_my__Buerger_ausfuehrungen> Function(
      Iterable<
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<
          Query_Ausfuehrungen_my__Buerger_ausfuehrungen
        >
      >,
    )
    _fn,
  ) => call(
    ausfuehrungen: _fn(
      _instance.ausfuehrungen.map(
        (e) =>
            CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger(this._res);

  TRes _res;

  call({
    String? id,
    List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen>? ausfuehrungen,
    String? $__typename,
  }) => _res;

  ausfuehrungen(_fn) => _res;
}

class Query_Ausfuehrungen_my__Buerger_ausfuehrungen {
  Query_Ausfuehrungen_my__Buerger_ausfuehrungen({
    required this.id,
    required this.createdAt,
    required this.sharedKeyEncryptedForBuerger,
    required this.slotValues,
    required this.prozessVersion,
    required this.status,
    required this.updatedAt,
    this.$__typename = 'Ausfuehrung',
  });

  factory Query_Ausfuehrungen_my__Buerger_ausfuehrungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$sharedKeyEncryptedForBuerger = json['sharedKeyEncryptedForBuerger'];
    final l$slotValues = json['slotValues'];
    final l$prozessVersion = json['prozessVersion'];
    final l$status = json['status'];
    final l$updatedAt = json['updatedAt'];
    final l$$__typename = json['__typename'];
    return Query_Ausfuehrungen_my__Buerger_ausfuehrungen(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      sharedKeyEncryptedForBuerger: (l$sharedKeyEncryptedForBuerger as String),
      slotValues: (l$slotValues as List<dynamic>)
          .map(
            (e) =>
                Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      prozessVersion: Fragment_ProzessVersion.fromJson(
        (l$prozessVersion as Map<String, dynamic>),
      ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
      updatedAt: DateTime.parse((l$updatedAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final String sharedKeyEncryptedForBuerger;

  final List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues>
  slotValues;

  final Fragment_ProzessVersion prozessVersion;

  final Enum_AusfuehrungStatus status;

  final DateTime updatedAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    _resultData['sharedKeyEncryptedForBuerger'] =
        l$sharedKeyEncryptedForBuerger;
    final l$slotValues = slotValues;
    _resultData['slotValues'] = l$slotValues.map((e) => e.toJson()).toList();
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$createdAt = createdAt;
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    final l$slotValues = slotValues;
    final l$prozessVersion = prozessVersion;
    final l$status = status;
    final l$updatedAt = updatedAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$sharedKeyEncryptedForBuerger,
      Object.hashAll(l$slotValues.map((v) => v)),
      l$prozessVersion,
      l$status,
      l$updatedAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Ausfuehrungen_my__Buerger_ausfuehrungen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    final lOther$sharedKeyEncryptedForBuerger =
        other.sharedKeyEncryptedForBuerger;
    if (l$sharedKeyEncryptedForBuerger != lOther$sharedKeyEncryptedForBuerger) {
      return false;
    }
    final l$slotValues = slotValues;
    final lOther$slotValues = other.slotValues;
    if (l$slotValues.length != lOther$slotValues.length) {
      return false;
    }
    for (int i = 0; i < l$slotValues.length; i++) {
      final l$slotValues$entry = l$slotValues[i];
      final lOther$slotValues$entry = lOther$slotValues[i];
      if (l$slotValues$entry != lOther$slotValues$entry) {
        return false;
      }
    }
    final l$prozessVersion = prozessVersion;
    final lOther$prozessVersion = other.prozessVersion;
    if (l$prozessVersion != lOther$prozessVersion) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
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

extension UtilityExtension_Query_Ausfuehrungen_my__Buerger_ausfuehrungen
    on Query_Ausfuehrungen_my__Buerger_ausfuehrungen {
  CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen
  >
  get copyWith =>
      CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen(this, (i) => i);
}

abstract class CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<TRes> {
  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen instance,
    TRes Function(Query_Ausfuehrungen_my__Buerger_ausfuehrungen) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen;

  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen;

  TRes call({
    String? id,
    DateTime? createdAt,
    String? sharedKeyEncryptedForBuerger,
    List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues>? slotValues,
    Fragment_ProzessVersion? prozessVersion,
    Enum_AusfuehrungStatus? status,
    DateTime? updatedAt,
    String? $__typename,
  });
  TRes slotValues(
    Iterable<Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues> Function(
      Iterable<
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
          Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues
        >
      >,
    )
    _fn,
  );
  CopyWith_Fragment_ProzessVersion<TRes> get prozessVersion;
}

class _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen(
    this._instance,
    this._then,
  );

  final Query_Ausfuehrungen_my__Buerger_ausfuehrungen _instance;

  final TRes Function(Query_Ausfuehrungen_my__Buerger_ausfuehrungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? sharedKeyEncryptedForBuerger = _undefined,
    Object? slotValues = _undefined,
    Object? prozessVersion = _undefined,
    Object? status = _undefined,
    Object? updatedAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      sharedKeyEncryptedForBuerger:
          sharedKeyEncryptedForBuerger == _undefined ||
              sharedKeyEncryptedForBuerger == null
          ? _instance.sharedKeyEncryptedForBuerger
          : (sharedKeyEncryptedForBuerger as String),
      slotValues: slotValues == _undefined || slotValues == null
          ? _instance.slotValues
          : (slotValues
                as List<
                  Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues
                >),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion as Fragment_ProzessVersion),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as DateTime),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes slotValues(
    Iterable<Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues> Function(
      Iterable<
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
          Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues
        >
      >,
    )
    _fn,
  ) => call(
    slotValues: _fn(
      _instance.slotValues.map(
        (e) =>
            CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith_Fragment_ProzessVersion<TRes> get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Fragment_ProzessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    String? sharedKeyEncryptedForBuerger,
    List<Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues>? slotValues,
    Fragment_ProzessVersion? prozessVersion,
    Enum_AusfuehrungStatus? status,
    DateTime? updatedAt,
    String? $__typename,
  }) => _res;

  slotValues(_fn) => _res;

  CopyWith_Fragment_ProzessVersion<TRes> get prozessVersion =>
      CopyWith_Fragment_ProzessVersion.stub(_res);
}

class Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues {
  Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues({
    required this.$__typename,
    required this.id,
    required this.slotName,
  });

  factory Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "PlainSlotValue":
        return Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue.fromJson(
          json,
        );

      case "EncryptedSlotValue":
        return Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        final l$id = json['id'];
        final l$slotName = json['slotName'];
        return Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
          $__typename: (l$$__typename as String),
          id: (l$id as String),
          slotName: (l$slotName as String),
        );
    }
  }

  final String $__typename;

  final String id;

  final String slotName;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$slotName = slotName;
    return Object.hashAll([l$$__typename, l$id, l$slotName]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues
    on Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues {
  CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues
  >
  get copyWith =>
      CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
    )
    plainSlotValue,
    required _T Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
    )
    encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        return plainSlotValue(
          this
              as Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
        );

      case "EncryptedSlotValue":
        return encryptedSlotValue(
          this
              as Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
    )?
    plainSlotValue,
    _T Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
    )?
    encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        if (plainSlotValue != null) {
          return plainSlotValue(
            this
                as Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
          );
        } else {
          return orElse();
        }

      case "EncryptedSlotValue":
        if (encryptedSlotValue != null) {
          return encryptedSlotValue(
            this
                as Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
  TRes
> {
  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues instance,
    TRes Function(Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues)
    then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues;

  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues;

  TRes call({String? $__typename, String? id, String? slotName});
}

class _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
          TRes
        > {
  _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
    this._instance,
    this._then,
  );

  final Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues _instance;

  final TRes Function(Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues<
          TRes
        > {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues(
    this._res,
  );

  TRes _res;

  call({String? $__typename, String? id, String? slotName}) => _res;
}

class Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue
    implements Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues {
  Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue({
    required this.value,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
    required this.id,
    required this.slotName,
  });

  factory Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$value = json['value'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    return Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
      value: (l$value as dynamic),
      slotValueCount: (l$slotValueCount as int),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      slotName: (l$slotName as String),
    );
  }

  final dynamic value;

  final int slotValueCount;

  final String $__typename;

  final String id;

  final String slotName;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$value = value;
    _resultData['value'] = l$value;
    final l$slotValueCount = slotValueCount;
    _resultData['slotValueCount'] = l$slotValueCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$value = value;
    final l$slotValueCount = slotValueCount;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$slotName = slotName;
    return Object.hashAll([
      l$value,
      l$slotValueCount,
      l$$__typename,
      l$id,
      l$slotName,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
      return false;
    }
    final l$slotValueCount = slotValueCount;
    final lOther$slotValueCount = other.slotValueCount;
    if (l$slotValueCount != lOther$slotValueCount) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue
    on Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue {
  CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue
  >
  get copyWith =>
      CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
  TRes
> {
  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue
    instance,
    TRes Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
    )
    then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue;

  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue;

  TRes call({
    dynamic? value,
    int? slotValueCount,
    String? $__typename,
    String? id,
    String? slotName,
  });
}

class _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
          TRes
        > {
  _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
    this._instance,
    this._then,
  );

  final Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue
  _instance;

  final TRes Function(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? value = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
      value: value == _undefined || value == null
          ? _instance.value
          : (value as dynamic),
      slotValueCount: slotValueCount == _undefined || slotValueCount == null
          ? _instance.slotValueCount
          : (slotValueCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue<
          TRes
        > {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__PlainSlotValue(
    this._res,
  );

  TRes _res;

  call({
    dynamic? value,
    int? slotValueCount,
    String? $__typename,
    String? id,
    String? slotName,
  }) => _res;
}

class Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue
    implements Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues {
  Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue({
    this.$__typename = 'EncryptedSlotValue',
    required this.id,
    required this.slotName,
  });

  factory Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    return Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      slotName: (l$slotName as String),
    );
  }

  final String $__typename;

  final String id;

  final String slotName;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$slotName = slotName;
    return Object.hashAll([l$$__typename, l$id, l$slotName]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue
    on Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue {
  CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue
  >
  get copyWith =>
      CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
  TRes
> {
  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue
    instance,
    TRes Function(
      Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
    )
    then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue;

  factory CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue;

  TRes call({String? $__typename, String? id, String? slotName});
}

class _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
          TRes
        > {
  _CopyWithImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
    this._instance,
    this._then,
  );

  final Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue
  _instance;

  final TRes Function(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
  TRes
>
    implements
        CopyWith_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue<
          TRes
        > {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__Buerger_ausfuehrungen_slotValues__EncryptedSlotValue(
    this._res,
  );

  TRes _res;

  call({String? $__typename, String? id, String? slotName}) => _res;
}

class Query_Ausfuehrungen_my__BackofficeUser implements Query_Ausfuehrungen_my {
  Query_Ausfuehrungen_my__BackofficeUser({this.$__typename = 'BackofficeUser'});

  factory Query_Ausfuehrungen_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Query_Ausfuehrungen_my__BackofficeUser(
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
    if (other is! Query_Ausfuehrungen_my__BackofficeUser ||
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

extension UtilityExtension_Query_Ausfuehrungen_my__BackofficeUser
    on Query_Ausfuehrungen_my__BackofficeUser {
  CopyWith_Query_Ausfuehrungen_my__BackofficeUser<
    Query_Ausfuehrungen_my__BackofficeUser
  >
  get copyWith =>
      CopyWith_Query_Ausfuehrungen_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_Ausfuehrungen_my__BackofficeUser<TRes> {
  factory CopyWith_Query_Ausfuehrungen_my__BackofficeUser(
    Query_Ausfuehrungen_my__BackofficeUser instance,
    TRes Function(Query_Ausfuehrungen_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__BackofficeUser;

  factory CopyWith_Query_Ausfuehrungen_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_Ausfuehrungen_my__BackofficeUser;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Query_Ausfuehrungen_my__BackofficeUser<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen_my__BackofficeUser(
    this._instance,
    this._then,
  );

  final Query_Ausfuehrungen_my__BackofficeUser _instance;

  final TRes Function(Query_Ausfuehrungen_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query_Ausfuehrungen_my__BackofficeUser(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__BackofficeUser<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__BackofficeUser(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query_Ausfuehrungen_my__SystemUser implements Query_Ausfuehrungen_my {
  Query_Ausfuehrungen_my__SystemUser({this.$__typename = 'SystemUser'});

  factory Query_Ausfuehrungen_my__SystemUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    return Query_Ausfuehrungen_my__SystemUser(
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
    if (other is! Query_Ausfuehrungen_my__SystemUser ||
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

extension UtilityExtension_Query_Ausfuehrungen_my__SystemUser
    on Query_Ausfuehrungen_my__SystemUser {
  CopyWith_Query_Ausfuehrungen_my__SystemUser<
    Query_Ausfuehrungen_my__SystemUser
  >
  get copyWith => CopyWith_Query_Ausfuehrungen_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_Ausfuehrungen_my__SystemUser<TRes> {
  factory CopyWith_Query_Ausfuehrungen_my__SystemUser(
    Query_Ausfuehrungen_my__SystemUser instance,
    TRes Function(Query_Ausfuehrungen_my__SystemUser) then,
  ) = _CopyWithImpl_Query_Ausfuehrungen_my__SystemUser;

  factory CopyWith_Query_Ausfuehrungen_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_Ausfuehrungen_my__SystemUser;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Query_Ausfuehrungen_my__SystemUser<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__SystemUser<TRes> {
  _CopyWithImpl_Query_Ausfuehrungen_my__SystemUser(this._instance, this._then);

  final Query_Ausfuehrungen_my__SystemUser _instance;

  final TRes Function(Query_Ausfuehrungen_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query_Ausfuehrungen_my__SystemUser(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Ausfuehrungen_my__SystemUser<TRes>
    implements CopyWith_Query_Ausfuehrungen_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_Ausfuehrungen_my__SystemUser(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Variables_Query_AusfuehrungFortsetzung {
  factory Variables_Query_AusfuehrungFortsetzung({required String id}) =>
      Variables_Query_AusfuehrungFortsetzung._({r'id': id});

  Variables_Query_AusfuehrungFortsetzung._(this._$data);

  factory Variables_Query_AusfuehrungFortsetzung.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_AusfuehrungFortsetzung._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_AusfuehrungFortsetzung<
    Variables_Query_AusfuehrungFortsetzung
  >
  get copyWith =>
      CopyWith_Variables_Query_AusfuehrungFortsetzung(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AusfuehrungFortsetzung ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith_Variables_Query_AusfuehrungFortsetzung<TRes> {
  factory CopyWith_Variables_Query_AusfuehrungFortsetzung(
    Variables_Query_AusfuehrungFortsetzung instance,
    TRes Function(Variables_Query_AusfuehrungFortsetzung) then,
  ) = _CopyWithImpl_Variables_Query_AusfuehrungFortsetzung;

  factory CopyWith_Variables_Query_AusfuehrungFortsetzung.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AusfuehrungFortsetzung;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_AusfuehrungFortsetzung<TRes>
    implements CopyWith_Variables_Query_AusfuehrungFortsetzung<TRes> {
  _CopyWithImpl_Variables_Query_AusfuehrungFortsetzung(
    this._instance,
    this._then,
  );

  final Variables_Query_AusfuehrungFortsetzung _instance;

  final TRes Function(Variables_Query_AusfuehrungFortsetzung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_AusfuehrungFortsetzung._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_AusfuehrungFortsetzung<TRes>
    implements CopyWith_Variables_Query_AusfuehrungFortsetzung<TRes> {
  _CopyWithStubImpl_Variables_Query_AusfuehrungFortsetzung(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_AusfuehrungFortsetzung {
  Query_AusfuehrungFortsetzung({
    required this.ausfuehrung,
    this.$__typename = 'Query',
  });

  factory Query_AusfuehrungFortsetzung.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrung = json['ausfuehrung'];
    final l$$__typename = json['__typename'];
    return Query_AusfuehrungFortsetzung(
      ausfuehrung: Query_AusfuehrungFortsetzung_ausfuehrung.fromJson(
        (l$ausfuehrung as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AusfuehrungFortsetzung_ausfuehrung ausfuehrung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrung = ausfuehrung;
    _resultData['ausfuehrung'] = l$ausfuehrung.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrung = ausfuehrung;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrung, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AusfuehrungFortsetzung ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrung = ausfuehrung;
    final lOther$ausfuehrung = other.ausfuehrung;
    if (l$ausfuehrung != lOther$ausfuehrung) {
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

extension UtilityExtension_Query_AusfuehrungFortsetzung
    on Query_AusfuehrungFortsetzung {
  CopyWith_Query_AusfuehrungFortsetzung<Query_AusfuehrungFortsetzung>
  get copyWith => CopyWith_Query_AusfuehrungFortsetzung(this, (i) => i);
}

abstract class CopyWith_Query_AusfuehrungFortsetzung<TRes> {
  factory CopyWith_Query_AusfuehrungFortsetzung(
    Query_AusfuehrungFortsetzung instance,
    TRes Function(Query_AusfuehrungFortsetzung) then,
  ) = _CopyWithImpl_Query_AusfuehrungFortsetzung;

  factory CopyWith_Query_AusfuehrungFortsetzung.stub(TRes res) =
      _CopyWithStubImpl_Query_AusfuehrungFortsetzung;

  TRes call({
    Query_AusfuehrungFortsetzung_ausfuehrung? ausfuehrung,
    String? $__typename,
  });
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> get ausfuehrung;
}

class _CopyWithImpl_Query_AusfuehrungFortsetzung<TRes>
    implements CopyWith_Query_AusfuehrungFortsetzung<TRes> {
  _CopyWithImpl_Query_AusfuehrungFortsetzung(this._instance, this._then);

  final Query_AusfuehrungFortsetzung _instance;

  final TRes Function(Query_AusfuehrungFortsetzung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AusfuehrungFortsetzung(
      ausfuehrung: ausfuehrung == _undefined || ausfuehrung == null
          ? _instance.ausfuehrung
          : (ausfuehrung as Query_AusfuehrungFortsetzung_ausfuehrung),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> get ausfuehrung {
    final local$ausfuehrung = _instance.ausfuehrung;
    return CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung(
      local$ausfuehrung,
      (e) => call(ausfuehrung: e),
    );
  }
}

class _CopyWithStubImpl_Query_AusfuehrungFortsetzung<TRes>
    implements CopyWith_Query_AusfuehrungFortsetzung<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungFortsetzung(this._res);

  TRes _res;

  call({
    Query_AusfuehrungFortsetzung_ausfuehrung? ausfuehrung,
    String? $__typename,
  }) => _res;

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> get ausfuehrung =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung.stub(_res);
}

const documentNodeQueryAusfuehrungFortsetzung = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AusfuehrungFortsetzung'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'ausfuehrung'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
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
                  name: NameNode(value: 'sharedKeyEncryptedForBuerger'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'currentSchritt'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'Schritt'),
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
                  name: NameNode(value: 'prozessVersion'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ProzessVersionOwnData'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'prozess'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'ProzessOwnData'),
                              directives: [],
                            ),
                            FieldNode(
                              name: NameNode(value: 'kommune'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'KommuneCrypto'),
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
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionProzessOwnData,
    fragmentDefinitionKommuneCrypto,
  ],
);
Query_AusfuehrungFortsetzung _parserFn_Query_AusfuehrungFortsetzung(
  Map<String, dynamic> data,
) => Query_AusfuehrungFortsetzung.fromJson(data);
typedef OnQueryComplete_Query_AusfuehrungFortsetzung =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_AusfuehrungFortsetzung?,
    );

class Options_Query_AusfuehrungFortsetzung
    extends graphql.QueryOptions<Query_AusfuehrungFortsetzung> {
  Options_Query_AusfuehrungFortsetzung({
    String? operationName,
    required Variables_Query_AusfuehrungFortsetzung variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AusfuehrungFortsetzung? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AusfuehrungFortsetzung? onComplete,
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
                     : _parserFn_Query_AusfuehrungFortsetzung(data),
               ),
         onError: onError,
         document: documentNodeQueryAusfuehrungFortsetzung,
         parserFn: _parserFn_Query_AusfuehrungFortsetzung,
       );

  final OnQueryComplete_Query_AusfuehrungFortsetzung? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AusfuehrungFortsetzung
    extends graphql.WatchQueryOptions<Query_AusfuehrungFortsetzung> {
  WatchOptions_Query_AusfuehrungFortsetzung({
    String? operationName,
    required Variables_Query_AusfuehrungFortsetzung variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AusfuehrungFortsetzung? typedOptimisticResult,
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
         document: documentNodeQueryAusfuehrungFortsetzung,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AusfuehrungFortsetzung,
       );
}

class FetchMoreOptions_Query_AusfuehrungFortsetzung
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AusfuehrungFortsetzung({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AusfuehrungFortsetzung variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAusfuehrungFortsetzung,
       );
}

extension ClientExtension_Query_AusfuehrungFortsetzung
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AusfuehrungFortsetzung>>
  query_AusfuehrungFortsetzung(
    Options_Query_AusfuehrungFortsetzung options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_AusfuehrungFortsetzung>
  watchQuery_AusfuehrungFortsetzung(
    WatchOptions_Query_AusfuehrungFortsetzung options,
  ) => this.watchQuery(options);

  void writeQuery_AusfuehrungFortsetzung({
    required Query_AusfuehrungFortsetzung data,
    required Variables_Query_AusfuehrungFortsetzung variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAusfuehrungFortsetzung,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AusfuehrungFortsetzung? readQuery_AusfuehrungFortsetzung({
    required Variables_Query_AusfuehrungFortsetzung variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAusfuehrungFortsetzung,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_AusfuehrungFortsetzung.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AusfuehrungFortsetzung>
useQuery_AusfuehrungFortsetzung(Options_Query_AusfuehrungFortsetzung options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AusfuehrungFortsetzung>
useWatchQuery_AusfuehrungFortsetzung(
  WatchOptions_Query_AusfuehrungFortsetzung options,
) => graphql_flutter.useWatchQuery(options);

class Query_AusfuehrungFortsetzung_Widget
    extends graphql_flutter.Query<Query_AusfuehrungFortsetzung> {
  Query_AusfuehrungFortsetzung_Widget({
    widgets.Key? key,
    required Options_Query_AusfuehrungFortsetzung options,
    required graphql_flutter.QueryBuilder<Query_AusfuehrungFortsetzung> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AusfuehrungFortsetzung_ausfuehrung {
  Query_AusfuehrungFortsetzung_ausfuehrung({
    required this.id,
    required this.sharedKeyEncryptedForBuerger,
    required this.currentSchritt,
    required this.prozessVersion,
    this.$__typename = 'Ausfuehrung',
  });

  factory Query_AusfuehrungFortsetzung_ausfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$sharedKeyEncryptedForBuerger = json['sharedKeyEncryptedForBuerger'];
    final l$currentSchritt = json['currentSchritt'];
    final l$prozessVersion = json['prozessVersion'];
    final l$$__typename = json['__typename'];
    return Query_AusfuehrungFortsetzung_ausfuehrung(
      id: (l$id as String),
      sharedKeyEncryptedForBuerger: (l$sharedKeyEncryptedForBuerger as String),
      currentSchritt: Fragment_Schritt.fromJson(
        (l$currentSchritt as Map<String, dynamic>),
      ),
      prozessVersion:
          Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion.fromJson(
            (l$prozessVersion as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String sharedKeyEncryptedForBuerger;

  final Fragment_Schritt currentSchritt;

  final Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion prozessVersion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    _resultData['sharedKeyEncryptedForBuerger'] =
        l$sharedKeyEncryptedForBuerger;
    final l$currentSchritt = currentSchritt;
    _resultData['currentSchritt'] = l$currentSchritt.toJson();
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    final l$currentSchritt = currentSchritt;
    final l$prozessVersion = prozessVersion;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$sharedKeyEncryptedForBuerger,
      l$currentSchritt,
      l$prozessVersion,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AusfuehrungFortsetzung_ausfuehrung ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$sharedKeyEncryptedForBuerger = sharedKeyEncryptedForBuerger;
    final lOther$sharedKeyEncryptedForBuerger =
        other.sharedKeyEncryptedForBuerger;
    if (l$sharedKeyEncryptedForBuerger != lOther$sharedKeyEncryptedForBuerger) {
      return false;
    }
    final l$currentSchritt = currentSchritt;
    final lOther$currentSchritt = other.currentSchritt;
    if (l$currentSchritt != lOther$currentSchritt) {
      return false;
    }
    final l$prozessVersion = prozessVersion;
    final lOther$prozessVersion = other.prozessVersion;
    if (l$prozessVersion != lOther$prozessVersion) {
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

extension UtilityExtension_Query_AusfuehrungFortsetzung_ausfuehrung
    on Query_AusfuehrungFortsetzung_ausfuehrung {
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<
    Query_AusfuehrungFortsetzung_ausfuehrung
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung(this, (i) => i);
}

abstract class CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> {
  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung(
    Query_AusfuehrungFortsetzung_ausfuehrung instance,
    TRes Function(Query_AusfuehrungFortsetzung_ausfuehrung) then,
  ) = _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung;

  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung;

  TRes call({
    String? id,
    String? sharedKeyEncryptedForBuerger,
    Fragment_Schritt? currentSchritt,
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion? prozessVersion,
    String? $__typename,
  });
  CopyWith_Fragment_Schritt<TRes> get currentSchritt;
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<TRes>
  get prozessVersion;
}

class _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung<TRes>
    implements CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> {
  _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungFortsetzung_ausfuehrung _instance;

  final TRes Function(Query_AusfuehrungFortsetzung_ausfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? sharedKeyEncryptedForBuerger = _undefined,
    Object? currentSchritt = _undefined,
    Object? prozessVersion = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AusfuehrungFortsetzung_ausfuehrung(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      sharedKeyEncryptedForBuerger:
          sharedKeyEncryptedForBuerger == _undefined ||
              sharedKeyEncryptedForBuerger == null
          ? _instance.sharedKeyEncryptedForBuerger
          : (sharedKeyEncryptedForBuerger as String),
      currentSchritt: currentSchritt == _undefined || currentSchritt == null
          ? _instance.currentSchritt
          : (currentSchritt as Fragment_Schritt),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion
                as Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_Schritt<TRes> get currentSchritt {
    final local$currentSchritt = _instance.currentSchritt;
    return CopyWith_Fragment_Schritt(
      local$currentSchritt,
      (e) => call(currentSchritt: e),
    );
  }

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<TRes>
  get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }
}

class _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung<TRes>
    implements CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung(this._res);

  TRes _res;

  call({
    String? id,
    String? sharedKeyEncryptedForBuerger,
    Fragment_Schritt? currentSchritt,
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion? prozessVersion,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_Schritt<TRes> get currentSchritt =>
      CopyWith_Fragment_Schritt.stub(_res);

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<TRes>
  get prozessVersion =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion.stub(
        _res,
      );
}

class Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion
    implements Fragment_ProzessVersionOwnData {
  Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion({
    required this.id,
    this.publishedAt,
    this.$__typename = 'ProzessVersion',
    required this.prozess,
  });

  factory Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$$__typename = json['__typename'];
    final l$prozess = json['prozess'];
    return Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
      id: (l$id as String),
      publishedAt: l$publishedAt == null
          ? null
          : DateTime.parse((l$publishedAt as String)),
      $__typename: (l$$__typename as String),
      prozess:
          Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess.fromJson(
            (l$prozess as Map<String, dynamic>),
          ),
    );
  }

  final String id;

  final DateTime? publishedAt;

  final String $__typename;

  final Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess prozess;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$prozess = prozess;
    _resultData['prozess'] = l$prozess.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$$__typename = $__typename;
    final l$prozess = prozess;
    return Object.hashAll([l$id, l$publishedAt, l$$__typename, l$prozess]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publishedAt = publishedAt;
    final lOther$publishedAt = other.publishedAt;
    if (l$publishedAt != lOther$publishedAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$prozess = prozess;
    final lOther$prozess = other.prozess;
    if (l$prozess != lOther$prozess) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion
    on Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion {
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<
  TRes
> {
  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion instance,
    TRes Function(Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion) then,
  ) = _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion;

  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion;

  TRes call({
    String? id,
    DateTime? publishedAt,
    String? $__typename,
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess? prozess,
  });
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<TRes>
  get prozess;
}

class _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<TRes> {
  _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion _instance;

  final TRes Function(Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? $__typename = _undefined,
    Object? prozess = _undefined,
  }) => _then(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      prozess: prozess == _undefined || prozess == null
          ? _instance.prozess
          : (prozess
                as Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess),
    ),
  );

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<TRes>
  get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    DateTime? publishedAt,
    String? $__typename,
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess? prozess,
  }) => _res;

  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<TRes>
  get prozess =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess.stub(
        _res,
      );
}

class Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess
    implements Fragment_ProzessOwnData {
  Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess({
    required this.id,
    required this.name,
    required this.tags,
    this.$__typename = 'Prozess',
    required this.kommune,
  });

  factory Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    final l$kommune = json['kommune'];
    return Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
      id: (l$id as String),
      name: (l$name as String),
      tags: (l$tags as List<dynamic>)
          .map(
            (e) =>
                Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      kommune: Fragment_KommuneCrypto.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final String name;

  final List<
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
  >
  tags;

  final String $__typename;

  final Fragment_KommuneCrypto kommune;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$kommune = kommune;
    _resultData['kommune'] = l$kommune.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$tags = tags;
    final l$$__typename = $__typename;
    final l$kommune = kommune;
    return Object.hashAll([
      l$id,
      l$name,
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
      l$kommune,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess ||
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
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$kommune = kommune;
    final lOther$kommune = other.kommune;
    if (l$kommune != lOther$kommune) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess
    on Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess {
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
  TRes
> {
  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess instance,
    TRes Function(
      Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess,
    )
    then,
  ) = _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess;

  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess;

  TRes call({
    String? id,
    String? name,
    List<Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags>?
    tags,
    String? $__typename,
    Fragment_KommuneCrypto? kommune,
  });
  TRes tags(
    Iterable<
      Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
    >
    Function(
      Iterable<
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
          Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
        >
      >,
    )
    _fn,
  );
  CopyWith_Fragment_KommuneCrypto<TRes> get kommune;
}

class _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess
  _instance;

  final TRes Function(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? tags = _undefined,
    Object? $__typename = _undefined,
    Object? kommune = _undefined,
  }) => _then(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags
                as List<
                  Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      kommune: kommune == _undefined || kommune == null
          ? _instance.kommune
          : (kommune as Fragment_KommuneCrypto),
    ),
  );

  TRes tags(
    Iterable<
      Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
    >
    Function(
      Iterable<
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
          Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
        >
      >,
    )
    _fn,
  ) => call(
    tags: _fn(
      _instance.tags.map(
        (e) =>
            CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith_Fragment_KommuneCrypto<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Fragment_KommuneCrypto(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    List<Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags>?
    tags,
    String? $__typename,
    Fragment_KommuneCrypto? kommune,
  }) => _res;

  tags(_fn) => _res;

  CopyWith_Fragment_KommuneCrypto<TRes> get kommune =>
      CopyWith_Fragment_KommuneCrypto.stub(_res);
}

class Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
    implements Fragment_ProzessOwnData_tags {
  Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags({
    required this.id,
    required this.tag,
    this.$__typename = 'ProzessTag',
  });

  factory Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$tag = json['tag'];
    final l$$__typename = json['__typename'];
    return Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
      id: (l$id as String),
      tag: (l$tag as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String tag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$tag = tag;
    _resultData['tag'] = l$tag;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$tag = tag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$tag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$tag = tag;
    final lOther$tag = other.tag;
    if (l$tag != lOther$tag) {
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

extension UtilityExtension_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
    on Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags {
  CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
  TRes
> {
  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
    instance,
    TRes Function(
      Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags,
    )
    then,
  ) = _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags;

  factory CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags;

  TRes call({String? id, String? tag, String? $__typename});
}

class _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
          TRes
        > {
  _CopyWithImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags
  _instance;

  final TRes Function(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? tag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      tag: tag == _undefined || tag == null ? _instance.tag : (tag as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
  TRes
>
    implements
        CopyWith_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags<
          TRes
        > {
  _CopyWithStubImpl_Query_AusfuehrungFortsetzung_ausfuehrung_prozessVersion_prozess_tags(
    this._res,
  );

  TRes _res;

  call({String? id, String? tag, String? $__typename}) => _res;
}

class Variables_Mutation_BezahlenSchrittUrl {
  factory Variables_Mutation_BezahlenSchrittUrl({
    required String ausfuehrungId,
    required String bezahlenSchrittId,
  }) => Variables_Mutation_BezahlenSchrittUrl._({
    r'ausfuehrungId': ausfuehrungId,
    r'bezahlenSchrittId': bezahlenSchrittId,
  });

  Variables_Mutation_BezahlenSchrittUrl._(this._$data);

  factory Variables_Mutation_BezahlenSchrittUrl.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$ausfuehrungId = data['ausfuehrungId'];
    result$data['ausfuehrungId'] = (l$ausfuehrungId as String);
    final l$bezahlenSchrittId = data['bezahlenSchrittId'];
    result$data['bezahlenSchrittId'] = (l$bezahlenSchrittId as String);
    return Variables_Mutation_BezahlenSchrittUrl._(result$data);
  }

  Map<String, dynamic> _$data;

  String get ausfuehrungId => (_$data['ausfuehrungId'] as String);

  String get bezahlenSchrittId => (_$data['bezahlenSchrittId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$ausfuehrungId = ausfuehrungId;
    result$data['ausfuehrungId'] = l$ausfuehrungId;
    final l$bezahlenSchrittId = bezahlenSchrittId;
    result$data['bezahlenSchrittId'] = l$bezahlenSchrittId;
    return result$data;
  }

  CopyWith_Variables_Mutation_BezahlenSchrittUrl<
    Variables_Mutation_BezahlenSchrittUrl
  >
  get copyWith =>
      CopyWith_Variables_Mutation_BezahlenSchrittUrl(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_BezahlenSchrittUrl ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungId = ausfuehrungId;
    final lOther$ausfuehrungId = other.ausfuehrungId;
    if (l$ausfuehrungId != lOther$ausfuehrungId) {
      return false;
    }
    final l$bezahlenSchrittId = bezahlenSchrittId;
    final lOther$bezahlenSchrittId = other.bezahlenSchrittId;
    if (l$bezahlenSchrittId != lOther$bezahlenSchrittId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ausfuehrungId = ausfuehrungId;
    final l$bezahlenSchrittId = bezahlenSchrittId;
    return Object.hashAll([l$ausfuehrungId, l$bezahlenSchrittId]);
  }
}

abstract class CopyWith_Variables_Mutation_BezahlenSchrittUrl<TRes> {
  factory CopyWith_Variables_Mutation_BezahlenSchrittUrl(
    Variables_Mutation_BezahlenSchrittUrl instance,
    TRes Function(Variables_Mutation_BezahlenSchrittUrl) then,
  ) = _CopyWithImpl_Variables_Mutation_BezahlenSchrittUrl;

  factory CopyWith_Variables_Mutation_BezahlenSchrittUrl.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_BezahlenSchrittUrl;

  TRes call({String? ausfuehrungId, String? bezahlenSchrittId});
}

class _CopyWithImpl_Variables_Mutation_BezahlenSchrittUrl<TRes>
    implements CopyWith_Variables_Mutation_BezahlenSchrittUrl<TRes> {
  _CopyWithImpl_Variables_Mutation_BezahlenSchrittUrl(
    this._instance,
    this._then,
  );

  final Variables_Mutation_BezahlenSchrittUrl _instance;

  final TRes Function(Variables_Mutation_BezahlenSchrittUrl) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungId = _undefined,
    Object? bezahlenSchrittId = _undefined,
  }) => _then(
    Variables_Mutation_BezahlenSchrittUrl._({
      ..._instance._$data,
      if (ausfuehrungId != _undefined && ausfuehrungId != null)
        'ausfuehrungId': (ausfuehrungId as String),
      if (bezahlenSchrittId != _undefined && bezahlenSchrittId != null)
        'bezahlenSchrittId': (bezahlenSchrittId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_BezahlenSchrittUrl<TRes>
    implements CopyWith_Variables_Mutation_BezahlenSchrittUrl<TRes> {
  _CopyWithStubImpl_Variables_Mutation_BezahlenSchrittUrl(this._res);

  TRes _res;

  call({String? ausfuehrungId, String? bezahlenSchrittId}) => _res;
}

class Mutation_BezahlenSchrittUrl {
  Mutation_BezahlenSchrittUrl({
    required this.bezahlenSchrittUrl,
    this.$__typename = 'Mutation',
  });

  factory Mutation_BezahlenSchrittUrl.fromJson(Map<String, dynamic> json) {
    final l$bezahlenSchrittUrl = json['bezahlenSchrittUrl'];
    final l$$__typename = json['__typename'];
    return Mutation_BezahlenSchrittUrl(
      bezahlenSchrittUrl:
          Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl.fromJson(
            (l$bezahlenSchrittUrl as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl bezahlenSchrittUrl;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$bezahlenSchrittUrl = bezahlenSchrittUrl;
    _resultData['bezahlenSchrittUrl'] = l$bezahlenSchrittUrl.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$bezahlenSchrittUrl = bezahlenSchrittUrl;
    final l$$__typename = $__typename;
    return Object.hashAll([l$bezahlenSchrittUrl, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_BezahlenSchrittUrl ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$bezahlenSchrittUrl = bezahlenSchrittUrl;
    final lOther$bezahlenSchrittUrl = other.bezahlenSchrittUrl;
    if (l$bezahlenSchrittUrl != lOther$bezahlenSchrittUrl) {
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

extension UtilityExtension_Mutation_BezahlenSchrittUrl
    on Mutation_BezahlenSchrittUrl {
  CopyWith_Mutation_BezahlenSchrittUrl<Mutation_BezahlenSchrittUrl>
  get copyWith => CopyWith_Mutation_BezahlenSchrittUrl(this, (i) => i);
}

abstract class CopyWith_Mutation_BezahlenSchrittUrl<TRes> {
  factory CopyWith_Mutation_BezahlenSchrittUrl(
    Mutation_BezahlenSchrittUrl instance,
    TRes Function(Mutation_BezahlenSchrittUrl) then,
  ) = _CopyWithImpl_Mutation_BezahlenSchrittUrl;

  factory CopyWith_Mutation_BezahlenSchrittUrl.stub(TRes res) =
      _CopyWithStubImpl_Mutation_BezahlenSchrittUrl;

  TRes call({
    Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl? bezahlenSchrittUrl,
    String? $__typename,
  });
  CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes>
  get bezahlenSchrittUrl;
}

class _CopyWithImpl_Mutation_BezahlenSchrittUrl<TRes>
    implements CopyWith_Mutation_BezahlenSchrittUrl<TRes> {
  _CopyWithImpl_Mutation_BezahlenSchrittUrl(this._instance, this._then);

  final Mutation_BezahlenSchrittUrl _instance;

  final TRes Function(Mutation_BezahlenSchrittUrl) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? bezahlenSchrittUrl = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_BezahlenSchrittUrl(
      bezahlenSchrittUrl:
          bezahlenSchrittUrl == _undefined || bezahlenSchrittUrl == null
          ? _instance.bezahlenSchrittUrl
          : (bezahlenSchrittUrl
                as Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes>
  get bezahlenSchrittUrl {
    final local$bezahlenSchrittUrl = _instance.bezahlenSchrittUrl;
    return CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(
      local$bezahlenSchrittUrl,
      (e) => call(bezahlenSchrittUrl: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_BezahlenSchrittUrl<TRes>
    implements CopyWith_Mutation_BezahlenSchrittUrl<TRes> {
  _CopyWithStubImpl_Mutation_BezahlenSchrittUrl(this._res);

  TRes _res;

  call({
    Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl? bezahlenSchrittUrl,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes>
  get bezahlenSchrittUrl =>
      CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl.stub(_res);
}

const documentNodeMutationBezahlenSchrittUrl = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'BezahlenSchrittUrl'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'ausfuehrungId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bezahlenSchrittId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'bezahlenSchrittUrl'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'ausfuehrungId'),
                      value: VariableNode(
                        name: NameNode(value: 'ausfuehrungId'),
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'bezahlenSchrittId'),
                      value: VariableNode(
                        name: NameNode(value: 'bezahlenSchrittId'),
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
                  name: NameNode(value: 'string'),
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
  ],
);
Mutation_BezahlenSchrittUrl _parserFn_Mutation_BezahlenSchrittUrl(
  Map<String, dynamic> data,
) => Mutation_BezahlenSchrittUrl.fromJson(data);
typedef OnMutationCompleted_Mutation_BezahlenSchrittUrl =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_BezahlenSchrittUrl?,
    );

class Options_Mutation_BezahlenSchrittUrl
    extends graphql.MutationOptions<Mutation_BezahlenSchrittUrl> {
  Options_Mutation_BezahlenSchrittUrl({
    String? operationName,
    required Variables_Mutation_BezahlenSchrittUrl variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_BezahlenSchrittUrl? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_BezahlenSchrittUrl? onCompleted,
    graphql.OnMutationUpdate<Mutation_BezahlenSchrittUrl>? update,
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
                     : _parserFn_Mutation_BezahlenSchrittUrl(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationBezahlenSchrittUrl,
         parserFn: _parserFn_Mutation_BezahlenSchrittUrl,
       );

  final OnMutationCompleted_Mutation_BezahlenSchrittUrl? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_BezahlenSchrittUrl
    extends graphql.WatchQueryOptions<Mutation_BezahlenSchrittUrl> {
  WatchOptions_Mutation_BezahlenSchrittUrl({
    String? operationName,
    required Variables_Mutation_BezahlenSchrittUrl variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_BezahlenSchrittUrl? typedOptimisticResult,
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
         document: documentNodeMutationBezahlenSchrittUrl,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_BezahlenSchrittUrl,
       );
}

extension ClientExtension_Mutation_BezahlenSchrittUrl on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_BezahlenSchrittUrl>>
  mutate_BezahlenSchrittUrl(
    Options_Mutation_BezahlenSchrittUrl options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_BezahlenSchrittUrl>
  watchMutation_BezahlenSchrittUrl(
    WatchOptions_Mutation_BezahlenSchrittUrl options,
  ) => this.watchMutation(options);
}

class Mutation_BezahlenSchrittUrl_HookResult {
  Mutation_BezahlenSchrittUrl_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_BezahlenSchrittUrl runMutation;

  final graphql.QueryResult<Mutation_BezahlenSchrittUrl> result;
}

Mutation_BezahlenSchrittUrl_HookResult useMutation_BezahlenSchrittUrl([
  WidgetOptions_Mutation_BezahlenSchrittUrl? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_BezahlenSchrittUrl(),
  );
  return Mutation_BezahlenSchrittUrl_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_BezahlenSchrittUrl>
useWatchMutation_BezahlenSchrittUrl(
  WatchOptions_Mutation_BezahlenSchrittUrl options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_BezahlenSchrittUrl
    extends graphql.MutationOptions<Mutation_BezahlenSchrittUrl> {
  WidgetOptions_Mutation_BezahlenSchrittUrl({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_BezahlenSchrittUrl? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_BezahlenSchrittUrl? onCompleted,
    graphql.OnMutationUpdate<Mutation_BezahlenSchrittUrl>? update,
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
                     : _parserFn_Mutation_BezahlenSchrittUrl(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationBezahlenSchrittUrl,
         parserFn: _parserFn_Mutation_BezahlenSchrittUrl,
       );

  final OnMutationCompleted_Mutation_BezahlenSchrittUrl? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_BezahlenSchrittUrl =
    graphql.MultiSourceResult<Mutation_BezahlenSchrittUrl> Function(
      Variables_Mutation_BezahlenSchrittUrl, {
      Object? optimisticResult,
      Mutation_BezahlenSchrittUrl? typedOptimisticResult,
    });
typedef Builder_Mutation_BezahlenSchrittUrl =
    widgets.Widget Function(
      RunMutation_Mutation_BezahlenSchrittUrl,
      graphql.QueryResult<Mutation_BezahlenSchrittUrl>?,
    );

class Mutation_BezahlenSchrittUrl_Widget
    extends graphql_flutter.Mutation<Mutation_BezahlenSchrittUrl> {
  Mutation_BezahlenSchrittUrl_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_BezahlenSchrittUrl? options,
    required Builder_Mutation_BezahlenSchrittUrl builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_BezahlenSchrittUrl(),
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

class Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl {
  Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl({
    this.string,
    this.$__typename = 'BezahlenSchrittUrlPayload',
  });

  factory Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$string = json['string'];
    final l$$__typename = json['__typename'];
    return Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(
      string: (l$string as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? string;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$string = string;
    _resultData['string'] = l$string;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$string = string;
    final l$$__typename = $__typename;
    return Object.hashAll([l$string, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$string = string;
    final lOther$string = other.string;
    if (l$string != lOther$string) {
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

extension UtilityExtension_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl
    on Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl {
  CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<
    Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl
  >
  get copyWith =>
      CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(this, (i) => i);
}

abstract class CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes> {
  factory CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(
    Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl instance,
    TRes Function(Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl) then,
  ) = _CopyWithImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl;

  factory CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl;

  TRes call({String? string, String? $__typename});
}

class _CopyWithImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes>
    implements CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes> {
  _CopyWithImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(
    this._instance,
    this._then,
  );

  final Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl _instance;

  final TRes Function(Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? string = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(
          string: string == _undefined ? _instance.string : (string as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes>
    implements CopyWith_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl<TRes> {
  _CopyWithStubImpl_Mutation_BezahlenSchrittUrl_bezahlenSchrittUrl(this._res);

  TRes _res;

  call({String? string, String? $__typename}) => _res;
}
