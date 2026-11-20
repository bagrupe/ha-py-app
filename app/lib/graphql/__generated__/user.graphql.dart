import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Query_My {
  Query_My({required this.my, this.$__typename = 'Query'});

  factory Query_My.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_My(
      my: Query_My_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_My_my my;

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
    if (other is! Query_My || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_My on Query_My {
  CopyWith_Query_My<Query_My> get copyWith => CopyWith_Query_My(this, (i) => i);
}

abstract class CopyWith_Query_My<TRes> {
  factory CopyWith_Query_My(Query_My instance, TRes Function(Query_My) then) =
      _CopyWithImpl_Query_My;

  factory CopyWith_Query_My.stub(TRes res) = _CopyWithStubImpl_Query_My;

  TRes call({Query_My_my? my, String? $__typename});
  CopyWith_Query_My_my<TRes> get my;
}

class _CopyWithImpl_Query_My<TRes> implements CopyWith_Query_My<TRes> {
  _CopyWithImpl_Query_My(this._instance, this._then);

  final Query_My _instance;

  final TRes Function(Query_My) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_My(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_My_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_My_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_My_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_My<TRes> implements CopyWith_Query_My<TRes> {
  _CopyWithStubImpl_Query_My(this._res);

  TRes _res;

  call({Query_My_my? my, String? $__typename}) => _res;

  CopyWith_Query_My_my<TRes> get my => CopyWith_Query_My_my.stub(_res);
}

const documentNodeQueryMy = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'My'),
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
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'publicKey'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
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
                        name: NameNode(value: 'personalPrivateKey'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'EncryptedValue'),
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
                        name: NameNode(value: 'personalPrivateKeySalt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'personalDataKey'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'hasKeyEscrow'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'hasBundId'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'phoneVerified'),
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
    fragmentDefinitionEncryptedValue,
  ],
);
Query_My _parserFn_Query_My(Map<String, dynamic> data) =>
    Query_My.fromJson(data);
typedef OnQueryComplete_Query_My =
    FutureOr<void> Function(Map<String, dynamic>?, Query_My?);

class Options_Query_My extends graphql.QueryOptions<Query_My> {
  Options_Query_My({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_My? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_My? onComplete,
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
                 data == null ? null : _parserFn_Query_My(data),
               ),
         onError: onError,
         document: documentNodeQueryMy,
         parserFn: _parserFn_Query_My,
       );

  final OnQueryComplete_Query_My? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_My extends graphql.WatchQueryOptions<Query_My> {
  WatchOptions_Query_My({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_My? typedOptimisticResult,
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
         document: documentNodeQueryMy,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_My,
       );
}

class FetchMoreOptions_Query_My extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_My({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryMy);
}

extension ClientExtension_Query_My on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_My>> query_My([
    Options_Query_My? options,
  ]) async => await this.query(options ?? Options_Query_My());

  graphql.ObservableQuery<Query_My> watchQuery_My([
    WatchOptions_Query_My? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_My());

  void writeQuery_My({required Query_My data, bool broadcast = true}) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryMy),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query_My? readQuery_My({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMy),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_My.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_My> useQuery_My([
  Options_Query_My? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_My());
graphql.ObservableQuery<Query_My> useWatchQuery_My([
  WatchOptions_Query_My? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_My());

class Query_My_Widget extends graphql_flutter.Query<Query_My> {
  Query_My_Widget({
    widgets.Key? key,
    Options_Query_My? options,
    required graphql_flutter.QueryBuilder<Query_My> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_My(),
         builder: builder,
       );
}

class Query_My_my {
  Query_My_my({required this.id, this.publicKey, required this.$__typename});

  factory Query_My_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_My_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_My_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_My_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$publicKey = json['publicKey'];
        final l$$__typename = json['__typename'];
        return Query_My_my(
          id: (l$id as String),
          publicKey: (l$publicKey as String?),
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String id;

  final String? publicKey;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publicKey = publicKey;
    _resultData['publicKey'] = l$publicKey;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publicKey = publicKey;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$publicKey, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_My_my || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publicKey = publicKey;
    final lOther$publicKey = other.publicKey;
    if (l$publicKey != lOther$publicKey) {
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

extension UtilityExtension_Query_My_my on Query_My_my {
  CopyWith_Query_My_my<Query_My_my> get copyWith =>
      CopyWith_Query_My_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_My_my__Buerger) buerger,
    required _T Function(Query_My_my__BackofficeUser) backofficeUser,
    required _T Function(Query_My_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_My_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_My_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_My_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_My_my__Buerger)? buerger,
    _T Function(Query_My_my__BackofficeUser)? backofficeUser,
    _T Function(Query_My_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_My_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(this as Query_My_my__BackofficeUser);
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_My_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_My_my<TRes> {
  factory CopyWith_Query_My_my(
    Query_My_my instance,
    TRes Function(Query_My_my) then,
  ) = _CopyWithImpl_Query_My_my;

  factory CopyWith_Query_My_my.stub(TRes res) = _CopyWithStubImpl_Query_My_my;

  TRes call({String? id, String? publicKey, String? $__typename});
}

class _CopyWithImpl_Query_My_my<TRes> implements CopyWith_Query_My_my<TRes> {
  _CopyWithImpl_Query_My_my(this._instance, this._then);

  final Query_My_my _instance;

  final TRes Function(Query_My_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publicKey = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_My_my(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publicKey: publicKey == _undefined
          ? _instance.publicKey
          : (publicKey as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_My_my<TRes>
    implements CopyWith_Query_My_my<TRes> {
  _CopyWithStubImpl_Query_My_my(this._res);

  TRes _res;

  call({String? id, String? publicKey, String? $__typename}) => _res;
}

class Query_My_my__Buerger implements Query_My_my {
  Query_My_my__Buerger({
    this.personalPrivateKey,
    this.personalPrivateKeySalt,
    this.personalDataKey,
    required this.hasKeyEscrow,
    required this.hasBundId,
    required this.phoneVerified,
    this.$__typename = 'Buerger',
    required this.id,
    this.publicKey,
  });

  factory Query_My_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$personalPrivateKey = json['personalPrivateKey'];
    final l$personalPrivateKeySalt = json['personalPrivateKeySalt'];
    final l$personalDataKey = json['personalDataKey'];
    final l$hasKeyEscrow = json['hasKeyEscrow'];
    final l$hasBundId = json['hasBundId'];
    final l$phoneVerified = json['phoneVerified'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$publicKey = json['publicKey'];
    return Query_My_my__Buerger(
      personalPrivateKey: l$personalPrivateKey == null
          ? null
          : Fragment_EncryptedValue.fromJson(
              (l$personalPrivateKey as Map<String, dynamic>),
            ),
      personalPrivateKeySalt: (l$personalPrivateKeySalt as String?),
      personalDataKey: (l$personalDataKey as String?),
      hasKeyEscrow: (l$hasKeyEscrow as bool),
      hasBundId: (l$hasBundId as bool),
      phoneVerified: (l$phoneVerified as bool),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      publicKey: (l$publicKey as String?),
    );
  }

  final Fragment_EncryptedValue? personalPrivateKey;

  final String? personalPrivateKeySalt;

  final String? personalDataKey;

  final bool hasKeyEscrow;

  final bool hasBundId;

  final bool phoneVerified;

  final String $__typename;

  final String id;

  final String? publicKey;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$personalPrivateKey = personalPrivateKey;
    _resultData['personalPrivateKey'] = l$personalPrivateKey?.toJson();
    final l$personalPrivateKeySalt = personalPrivateKeySalt;
    _resultData['personalPrivateKeySalt'] = l$personalPrivateKeySalt;
    final l$personalDataKey = personalDataKey;
    _resultData['personalDataKey'] = l$personalDataKey;
    final l$hasKeyEscrow = hasKeyEscrow;
    _resultData['hasKeyEscrow'] = l$hasKeyEscrow;
    final l$hasBundId = hasBundId;
    _resultData['hasBundId'] = l$hasBundId;
    final l$phoneVerified = phoneVerified;
    _resultData['phoneVerified'] = l$phoneVerified;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publicKey = publicKey;
    _resultData['publicKey'] = l$publicKey;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$personalPrivateKey = personalPrivateKey;
    final l$personalPrivateKeySalt = personalPrivateKeySalt;
    final l$personalDataKey = personalDataKey;
    final l$hasKeyEscrow = hasKeyEscrow;
    final l$hasBundId = hasBundId;
    final l$phoneVerified = phoneVerified;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$publicKey = publicKey;
    return Object.hashAll([
      l$personalPrivateKey,
      l$personalPrivateKeySalt,
      l$personalDataKey,
      l$hasKeyEscrow,
      l$hasBundId,
      l$phoneVerified,
      l$$__typename,
      l$id,
      l$publicKey,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_My_my__Buerger || runtimeType != other.runtimeType) {
      return false;
    }
    final l$personalPrivateKey = personalPrivateKey;
    final lOther$personalPrivateKey = other.personalPrivateKey;
    if (l$personalPrivateKey != lOther$personalPrivateKey) {
      return false;
    }
    final l$personalPrivateKeySalt = personalPrivateKeySalt;
    final lOther$personalPrivateKeySalt = other.personalPrivateKeySalt;
    if (l$personalPrivateKeySalt != lOther$personalPrivateKeySalt) {
      return false;
    }
    final l$personalDataKey = personalDataKey;
    final lOther$personalDataKey = other.personalDataKey;
    if (l$personalDataKey != lOther$personalDataKey) {
      return false;
    }
    final l$hasKeyEscrow = hasKeyEscrow;
    final lOther$hasKeyEscrow = other.hasKeyEscrow;
    if (l$hasKeyEscrow != lOther$hasKeyEscrow) {
      return false;
    }
    final l$hasBundId = hasBundId;
    final lOther$hasBundId = other.hasBundId;
    if (l$hasBundId != lOther$hasBundId) {
      return false;
    }
    final l$phoneVerified = phoneVerified;
    final lOther$phoneVerified = other.phoneVerified;
    if (l$phoneVerified != lOther$phoneVerified) {
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
    final l$publicKey = publicKey;
    final lOther$publicKey = other.publicKey;
    if (l$publicKey != lOther$publicKey) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_My_my__Buerger on Query_My_my__Buerger {
  CopyWith_Query_My_my__Buerger<Query_My_my__Buerger> get copyWith =>
      CopyWith_Query_My_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_My_my__Buerger<TRes> {
  factory CopyWith_Query_My_my__Buerger(
    Query_My_my__Buerger instance,
    TRes Function(Query_My_my__Buerger) then,
  ) = _CopyWithImpl_Query_My_my__Buerger;

  factory CopyWith_Query_My_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_My_my__Buerger;

  TRes call({
    Fragment_EncryptedValue? personalPrivateKey,
    String? personalPrivateKeySalt,
    String? personalDataKey,
    bool? hasKeyEscrow,
    bool? hasBundId,
    bool? phoneVerified,
    String? $__typename,
    String? id,
    String? publicKey,
  });
  CopyWith_Fragment_EncryptedValue<TRes> get personalPrivateKey;
}

class _CopyWithImpl_Query_My_my__Buerger<TRes>
    implements CopyWith_Query_My_my__Buerger<TRes> {
  _CopyWithImpl_Query_My_my__Buerger(this._instance, this._then);

  final Query_My_my__Buerger _instance;

  final TRes Function(Query_My_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personalPrivateKey = _undefined,
    Object? personalPrivateKeySalt = _undefined,
    Object? personalDataKey = _undefined,
    Object? hasKeyEscrow = _undefined,
    Object? hasBundId = _undefined,
    Object? phoneVerified = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? publicKey = _undefined,
  }) => _then(
    Query_My_my__Buerger(
      personalPrivateKey: personalPrivateKey == _undefined
          ? _instance.personalPrivateKey
          : (personalPrivateKey as Fragment_EncryptedValue?),
      personalPrivateKeySalt: personalPrivateKeySalt == _undefined
          ? _instance.personalPrivateKeySalt
          : (personalPrivateKeySalt as String?),
      personalDataKey: personalDataKey == _undefined
          ? _instance.personalDataKey
          : (personalDataKey as String?),
      hasKeyEscrow: hasKeyEscrow == _undefined || hasKeyEscrow == null
          ? _instance.hasKeyEscrow
          : (hasKeyEscrow as bool),
      hasBundId: hasBundId == _undefined || hasBundId == null
          ? _instance.hasBundId
          : (hasBundId as bool),
      phoneVerified: phoneVerified == _undefined || phoneVerified == null
          ? _instance.phoneVerified
          : (phoneVerified as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publicKey: publicKey == _undefined
          ? _instance.publicKey
          : (publicKey as String?),
    ),
  );

  CopyWith_Fragment_EncryptedValue<TRes> get personalPrivateKey {
    final local$personalPrivateKey = _instance.personalPrivateKey;
    return local$personalPrivateKey == null
        ? CopyWith_Fragment_EncryptedValue.stub(_then(_instance))
        : CopyWith_Fragment_EncryptedValue(
            local$personalPrivateKey,
            (e) => call(personalPrivateKey: e),
          );
  }
}

class _CopyWithStubImpl_Query_My_my__Buerger<TRes>
    implements CopyWith_Query_My_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_My_my__Buerger(this._res);

  TRes _res;

  call({
    Fragment_EncryptedValue? personalPrivateKey,
    String? personalPrivateKeySalt,
    String? personalDataKey,
    bool? hasKeyEscrow,
    bool? hasBundId,
    bool? phoneVerified,
    String? $__typename,
    String? id,
    String? publicKey,
  }) => _res;

  CopyWith_Fragment_EncryptedValue<TRes> get personalPrivateKey =>
      CopyWith_Fragment_EncryptedValue.stub(_res);
}

class Query_My_my__BackofficeUser implements Query_My_my {
  Query_My_my__BackofficeUser({
    required this.id,
    this.publicKey,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_My_my__BackofficeUser.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$publicKey = json['publicKey'];
    final l$$__typename = json['__typename'];
    return Query_My_my__BackofficeUser(
      id: (l$id as String),
      publicKey: (l$publicKey as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publicKey;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publicKey = publicKey;
    _resultData['publicKey'] = l$publicKey;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publicKey = publicKey;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$publicKey, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_My_my__BackofficeUser ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publicKey = publicKey;
    final lOther$publicKey = other.publicKey;
    if (l$publicKey != lOther$publicKey) {
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

extension UtilityExtension_Query_My_my__BackofficeUser
    on Query_My_my__BackofficeUser {
  CopyWith_Query_My_my__BackofficeUser<Query_My_my__BackofficeUser>
  get copyWith => CopyWith_Query_My_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_My_my__BackofficeUser<TRes> {
  factory CopyWith_Query_My_my__BackofficeUser(
    Query_My_my__BackofficeUser instance,
    TRes Function(Query_My_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_My_my__BackofficeUser;

  factory CopyWith_Query_My_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_My_my__BackofficeUser;

  TRes call({String? id, String? publicKey, String? $__typename});
}

class _CopyWithImpl_Query_My_my__BackofficeUser<TRes>
    implements CopyWith_Query_My_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_My_my__BackofficeUser(this._instance, this._then);

  final Query_My_my__BackofficeUser _instance;

  final TRes Function(Query_My_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publicKey = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_My_my__BackofficeUser(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publicKey: publicKey == _undefined
          ? _instance.publicKey
          : (publicKey as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_My_my__BackofficeUser<TRes>
    implements CopyWith_Query_My_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_My_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? publicKey, String? $__typename}) => _res;
}

class Query_My_my__SystemUser implements Query_My_my {
  Query_My_my__SystemUser({
    required this.id,
    this.publicKey,
    this.$__typename = 'SystemUser',
  });

  factory Query_My_my__SystemUser.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$publicKey = json['publicKey'];
    final l$$__typename = json['__typename'];
    return Query_My_my__SystemUser(
      id: (l$id as String),
      publicKey: (l$publicKey as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publicKey;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publicKey = publicKey;
    _resultData['publicKey'] = l$publicKey;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publicKey = publicKey;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$publicKey, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_My_my__SystemUser || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publicKey = publicKey;
    final lOther$publicKey = other.publicKey;
    if (l$publicKey != lOther$publicKey) {
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

extension UtilityExtension_Query_My_my__SystemUser on Query_My_my__SystemUser {
  CopyWith_Query_My_my__SystemUser<Query_My_my__SystemUser> get copyWith =>
      CopyWith_Query_My_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_My_my__SystemUser<TRes> {
  factory CopyWith_Query_My_my__SystemUser(
    Query_My_my__SystemUser instance,
    TRes Function(Query_My_my__SystemUser) then,
  ) = _CopyWithImpl_Query_My_my__SystemUser;

  factory CopyWith_Query_My_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_My_my__SystemUser;

  TRes call({String? id, String? publicKey, String? $__typename});
}

class _CopyWithImpl_Query_My_my__SystemUser<TRes>
    implements CopyWith_Query_My_my__SystemUser<TRes> {
  _CopyWithImpl_Query_My_my__SystemUser(this._instance, this._then);

  final Query_My_my__SystemUser _instance;

  final TRes Function(Query_My_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publicKey = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_My_my__SystemUser(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publicKey: publicKey == _undefined
          ? _instance.publicKey
          : (publicKey as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_My_my__SystemUser<TRes>
    implements CopyWith_Query_My_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_My_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? publicKey, String? $__typename}) => _res;
}

class Query_MyPersonalData {
  Query_MyPersonalData({required this.my, this.$__typename = 'Query'});

  factory Query_MyPersonalData.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_MyPersonalData(
      my: Query_MyPersonalData_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyPersonalData_my my;

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
    if (other is! Query_MyPersonalData || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyPersonalData on Query_MyPersonalData {
  CopyWith_Query_MyPersonalData<Query_MyPersonalData> get copyWith =>
      CopyWith_Query_MyPersonalData(this, (i) => i);
}

abstract class CopyWith_Query_MyPersonalData<TRes> {
  factory CopyWith_Query_MyPersonalData(
    Query_MyPersonalData instance,
    TRes Function(Query_MyPersonalData) then,
  ) = _CopyWithImpl_Query_MyPersonalData;

  factory CopyWith_Query_MyPersonalData.stub(TRes res) =
      _CopyWithStubImpl_Query_MyPersonalData;

  TRes call({Query_MyPersonalData_my? my, String? $__typename});
  CopyWith_Query_MyPersonalData_my<TRes> get my;
}

class _CopyWithImpl_Query_MyPersonalData<TRes>
    implements CopyWith_Query_MyPersonalData<TRes> {
  _CopyWithImpl_Query_MyPersonalData(this._instance, this._then);

  final Query_MyPersonalData _instance;

  final TRes Function(Query_MyPersonalData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyPersonalData(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_MyPersonalData_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MyPersonalData_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_MyPersonalData_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_MyPersonalData<TRes>
    implements CopyWith_Query_MyPersonalData<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData(this._res);

  TRes _res;

  call({Query_MyPersonalData_my? my, String? $__typename}) => _res;

  CopyWith_Query_MyPersonalData_my<TRes> get my =>
      CopyWith_Query_MyPersonalData_my.stub(_res);
}

const documentNodeQueryMyPersonalData = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyPersonalData'),
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
                        name: NameNode(value: 'personalData'),
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
                              name: NameNode(value: 'key'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'value'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'EncryptedValue'),
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
    fragmentDefinitionEncryptedValue,
  ],
);
Query_MyPersonalData _parserFn_Query_MyPersonalData(
  Map<String, dynamic> data,
) => Query_MyPersonalData.fromJson(data);
typedef OnQueryComplete_Query_MyPersonalData =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MyPersonalData?);

class Options_Query_MyPersonalData
    extends graphql.QueryOptions<Query_MyPersonalData> {
  Options_Query_MyPersonalData({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyPersonalData? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyPersonalData? onComplete,
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
                 data == null ? null : _parserFn_Query_MyPersonalData(data),
               ),
         onError: onError,
         document: documentNodeQueryMyPersonalData,
         parserFn: _parserFn_Query_MyPersonalData,
       );

  final OnQueryComplete_Query_MyPersonalData? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyPersonalData
    extends graphql.WatchQueryOptions<Query_MyPersonalData> {
  WatchOptions_Query_MyPersonalData({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyPersonalData? typedOptimisticResult,
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
         document: documentNodeQueryMyPersonalData,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyPersonalData,
       );
}

class FetchMoreOptions_Query_MyPersonalData extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyPersonalData({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryMyPersonalData,
       );
}

extension ClientExtension_Query_MyPersonalData on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyPersonalData>> query_MyPersonalData([
    Options_Query_MyPersonalData? options,
  ]) async => await this.query(options ?? Options_Query_MyPersonalData());

  graphql.ObservableQuery<Query_MyPersonalData> watchQuery_MyPersonalData([
    WatchOptions_Query_MyPersonalData? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MyPersonalData());

  void writeQuery_MyPersonalData({
    required Query_MyPersonalData data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMyPersonalData),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyPersonalData? readQuery_MyPersonalData({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMyPersonalData),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyPersonalData.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyPersonalData> useQuery_MyPersonalData([
  Options_Query_MyPersonalData? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_MyPersonalData());
graphql.ObservableQuery<Query_MyPersonalData> useWatchQuery_MyPersonalData([
  WatchOptions_Query_MyPersonalData? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_MyPersonalData(),
);

class Query_MyPersonalData_Widget
    extends graphql_flutter.Query<Query_MyPersonalData> {
  Query_MyPersonalData_Widget({
    widgets.Key? key,
    Options_Query_MyPersonalData? options,
    required graphql_flutter.QueryBuilder<Query_MyPersonalData> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MyPersonalData(),
         builder: builder,
       );
}

class Query_MyPersonalData_my {
  Query_MyPersonalData_my({required this.id, required this.$__typename});

  factory Query_MyPersonalData_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_MyPersonalData_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_MyPersonalData_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_MyPersonalData_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        return Query_MyPersonalData_my(
          id: (l$id as String),
          $__typename: (l$$__typename as String),
        );
    }
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
    if (other is! Query_MyPersonalData_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyPersonalData_my on Query_MyPersonalData_my {
  CopyWith_Query_MyPersonalData_my<Query_MyPersonalData_my> get copyWith =>
      CopyWith_Query_MyPersonalData_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_MyPersonalData_my__Buerger) buerger,
    required _T Function(Query_MyPersonalData_my__BackofficeUser)
    backofficeUser,
    required _T Function(Query_MyPersonalData_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_MyPersonalData_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_MyPersonalData_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_MyPersonalData_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_MyPersonalData_my__Buerger)? buerger,
    _T Function(Query_MyPersonalData_my__BackofficeUser)? backofficeUser,
    _T Function(Query_MyPersonalData_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_MyPersonalData_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(
            this as Query_MyPersonalData_my__BackofficeUser,
          );
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_MyPersonalData_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_MyPersonalData_my<TRes> {
  factory CopyWith_Query_MyPersonalData_my(
    Query_MyPersonalData_my instance,
    TRes Function(Query_MyPersonalData_my) then,
  ) = _CopyWithImpl_Query_MyPersonalData_my;

  factory CopyWith_Query_MyPersonalData_my.stub(TRes res) =
      _CopyWithStubImpl_Query_MyPersonalData_my;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyPersonalData_my<TRes>
    implements CopyWith_Query_MyPersonalData_my<TRes> {
  _CopyWithImpl_Query_MyPersonalData_my(this._instance, this._then);

  final Query_MyPersonalData_my _instance;

  final TRes Function(Query_MyPersonalData_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyPersonalData_my(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyPersonalData_my<TRes>
    implements CopyWith_Query_MyPersonalData_my<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData_my(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyPersonalData_my__Buerger implements Query_MyPersonalData_my {
  Query_MyPersonalData_my__Buerger({
    required this.personalData,
    this.$__typename = 'Buerger',
    required this.id,
  });

  factory Query_MyPersonalData_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$personalData = json['personalData'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query_MyPersonalData_my__Buerger(
      personalData: (l$personalData as List<dynamic>)
          .map(
            (e) => Query_MyPersonalData_my__Buerger_personalData.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final List<Query_MyPersonalData_my__Buerger_personalData> personalData;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$personalData = personalData;
    _resultData['personalData'] = l$personalData
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$personalData = personalData;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      Object.hashAll(l$personalData.map((v) => v)),
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyPersonalData_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$personalData = personalData;
    final lOther$personalData = other.personalData;
    if (l$personalData.length != lOther$personalData.length) {
      return false;
    }
    for (int i = 0; i < l$personalData.length; i++) {
      final l$personalData$entry = l$personalData[i];
      final lOther$personalData$entry = lOther$personalData[i];
      if (l$personalData$entry != lOther$personalData$entry) {
        return false;
      }
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
    return true;
  }
}

extension UtilityExtension_Query_MyPersonalData_my__Buerger
    on Query_MyPersonalData_my__Buerger {
  CopyWith_Query_MyPersonalData_my__Buerger<Query_MyPersonalData_my__Buerger>
  get copyWith => CopyWith_Query_MyPersonalData_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_MyPersonalData_my__Buerger<TRes> {
  factory CopyWith_Query_MyPersonalData_my__Buerger(
    Query_MyPersonalData_my__Buerger instance,
    TRes Function(Query_MyPersonalData_my__Buerger) then,
  ) = _CopyWithImpl_Query_MyPersonalData_my__Buerger;

  factory CopyWith_Query_MyPersonalData_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_MyPersonalData_my__Buerger;

  TRes call({
    List<Query_MyPersonalData_my__Buerger_personalData>? personalData,
    String? $__typename,
    String? id,
  });
  TRes personalData(
    Iterable<Query_MyPersonalData_my__Buerger_personalData> Function(
      Iterable<
        CopyWith_Query_MyPersonalData_my__Buerger_personalData<
          Query_MyPersonalData_my__Buerger_personalData
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MyPersonalData_my__Buerger<TRes>
    implements CopyWith_Query_MyPersonalData_my__Buerger<TRes> {
  _CopyWithImpl_Query_MyPersonalData_my__Buerger(this._instance, this._then);

  final Query_MyPersonalData_my__Buerger _instance;

  final TRes Function(Query_MyPersonalData_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personalData = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) => _then(
    Query_MyPersonalData_my__Buerger(
      personalData: personalData == _undefined || personalData == null
          ? _instance.personalData
          : (personalData
                as List<Query_MyPersonalData_my__Buerger_personalData>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
    ),
  );

  TRes personalData(
    Iterable<Query_MyPersonalData_my__Buerger_personalData> Function(
      Iterable<
        CopyWith_Query_MyPersonalData_my__Buerger_personalData<
          Query_MyPersonalData_my__Buerger_personalData
        >
      >,
    )
    _fn,
  ) => call(
    personalData: _fn(
      _instance.personalData.map(
        (e) =>
            CopyWith_Query_MyPersonalData_my__Buerger_personalData(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MyPersonalData_my__Buerger<TRes>
    implements CopyWith_Query_MyPersonalData_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData_my__Buerger(this._res);

  TRes _res;

  call({
    List<Query_MyPersonalData_my__Buerger_personalData>? personalData,
    String? $__typename,
    String? id,
  }) => _res;

  personalData(_fn) => _res;
}

class Query_MyPersonalData_my__Buerger_personalData {
  Query_MyPersonalData_my__Buerger_personalData({
    required this.id,
    required this.key,
    required this.value,
    this.$__typename = 'BuergerPersonalData',
  });

  factory Query_MyPersonalData_my__Buerger_personalData.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$key = json['key'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query_MyPersonalData_my__Buerger_personalData(
      id: (l$id as String),
      key: (l$key as String),
      value: Fragment_EncryptedValue.fromJson(
        (l$value as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String key;

  final Fragment_EncryptedValue value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$key = key;
    _resultData['key'] = l$key;
    final l$value = value;
    _resultData['value'] = l$value.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$key = key;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$key, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyPersonalData_my__Buerger_personalData ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$key = key;
    final lOther$key = other.key;
    if (l$key != lOther$key) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
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

extension UtilityExtension_Query_MyPersonalData_my__Buerger_personalData
    on Query_MyPersonalData_my__Buerger_personalData {
  CopyWith_Query_MyPersonalData_my__Buerger_personalData<
    Query_MyPersonalData_my__Buerger_personalData
  >
  get copyWith =>
      CopyWith_Query_MyPersonalData_my__Buerger_personalData(this, (i) => i);
}

abstract class CopyWith_Query_MyPersonalData_my__Buerger_personalData<TRes> {
  factory CopyWith_Query_MyPersonalData_my__Buerger_personalData(
    Query_MyPersonalData_my__Buerger_personalData instance,
    TRes Function(Query_MyPersonalData_my__Buerger_personalData) then,
  ) = _CopyWithImpl_Query_MyPersonalData_my__Buerger_personalData;

  factory CopyWith_Query_MyPersonalData_my__Buerger_personalData.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyPersonalData_my__Buerger_personalData;

  TRes call({
    String? id,
    String? key,
    Fragment_EncryptedValue? value,
    String? $__typename,
  });
  CopyWith_Fragment_EncryptedValue<TRes> get value;
}

class _CopyWithImpl_Query_MyPersonalData_my__Buerger_personalData<TRes>
    implements CopyWith_Query_MyPersonalData_my__Buerger_personalData<TRes> {
  _CopyWithImpl_Query_MyPersonalData_my__Buerger_personalData(
    this._instance,
    this._then,
  );

  final Query_MyPersonalData_my__Buerger_personalData _instance;

  final TRes Function(Query_MyPersonalData_my__Buerger_personalData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? key = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyPersonalData_my__Buerger_personalData(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      key: key == _undefined || key == null ? _instance.key : (key as String),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as Fragment_EncryptedValue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_EncryptedValue<TRes> get value {
    final local$value = _instance.value;
    return CopyWith_Fragment_EncryptedValue(local$value, (e) => call(value: e));
  }
}

class _CopyWithStubImpl_Query_MyPersonalData_my__Buerger_personalData<TRes>
    implements CopyWith_Query_MyPersonalData_my__Buerger_personalData<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData_my__Buerger_personalData(this._res);

  TRes _res;

  call({
    String? id,
    String? key,
    Fragment_EncryptedValue? value,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_EncryptedValue<TRes> get value =>
      CopyWith_Fragment_EncryptedValue.stub(_res);
}

class Query_MyPersonalData_my__BackofficeUser
    implements Query_MyPersonalData_my {
  Query_MyPersonalData_my__BackofficeUser({
    required this.id,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_MyPersonalData_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyPersonalData_my__BackofficeUser(
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
    if (other is! Query_MyPersonalData_my__BackofficeUser ||
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

extension UtilityExtension_Query_MyPersonalData_my__BackofficeUser
    on Query_MyPersonalData_my__BackofficeUser {
  CopyWith_Query_MyPersonalData_my__BackofficeUser<
    Query_MyPersonalData_my__BackofficeUser
  >
  get copyWith =>
      CopyWith_Query_MyPersonalData_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_MyPersonalData_my__BackofficeUser<TRes> {
  factory CopyWith_Query_MyPersonalData_my__BackofficeUser(
    Query_MyPersonalData_my__BackofficeUser instance,
    TRes Function(Query_MyPersonalData_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_MyPersonalData_my__BackofficeUser;

  factory CopyWith_Query_MyPersonalData_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyPersonalData_my__BackofficeUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyPersonalData_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyPersonalData_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_MyPersonalData_my__BackofficeUser(
    this._instance,
    this._then,
  );

  final Query_MyPersonalData_my__BackofficeUser _instance;

  final TRes Function(Query_MyPersonalData_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyPersonalData_my__BackofficeUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyPersonalData_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyPersonalData_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyPersonalData_my__SystemUser implements Query_MyPersonalData_my {
  Query_MyPersonalData_my__SystemUser({
    required this.id,
    this.$__typename = 'SystemUser',
  });

  factory Query_MyPersonalData_my__SystemUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyPersonalData_my__SystemUser(
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
    if (other is! Query_MyPersonalData_my__SystemUser ||
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

extension UtilityExtension_Query_MyPersonalData_my__SystemUser
    on Query_MyPersonalData_my__SystemUser {
  CopyWith_Query_MyPersonalData_my__SystemUser<
    Query_MyPersonalData_my__SystemUser
  >
  get copyWith => CopyWith_Query_MyPersonalData_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_MyPersonalData_my__SystemUser<TRes> {
  factory CopyWith_Query_MyPersonalData_my__SystemUser(
    Query_MyPersonalData_my__SystemUser instance,
    TRes Function(Query_MyPersonalData_my__SystemUser) then,
  ) = _CopyWithImpl_Query_MyPersonalData_my__SystemUser;

  factory CopyWith_Query_MyPersonalData_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyPersonalData_my__SystemUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyPersonalData_my__SystemUser<TRes>
    implements CopyWith_Query_MyPersonalData_my__SystemUser<TRes> {
  _CopyWithImpl_Query_MyPersonalData_my__SystemUser(this._instance, this._then);

  final Query_MyPersonalData_my__SystemUser _instance;

  final TRes Function(Query_MyPersonalData_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyPersonalData_my__SystemUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyPersonalData_my__SystemUser<TRes>
    implements CopyWith_Query_MyPersonalData_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_MyPersonalData_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyMitteilungen {
  Query_MyMitteilungen({required this.my, this.$__typename = 'Query'});

  factory Query_MyMitteilungen.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen(
      my: Query_MyMitteilungen_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyMitteilungen_my my;

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
    if (other is! Query_MyMitteilungen || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyMitteilungen on Query_MyMitteilungen {
  CopyWith_Query_MyMitteilungen<Query_MyMitteilungen> get copyWith =>
      CopyWith_Query_MyMitteilungen(this, (i) => i);
}

abstract class CopyWith_Query_MyMitteilungen<TRes> {
  factory CopyWith_Query_MyMitteilungen(
    Query_MyMitteilungen instance,
    TRes Function(Query_MyMitteilungen) then,
  ) = _CopyWithImpl_Query_MyMitteilungen;

  factory CopyWith_Query_MyMitteilungen.stub(TRes res) =
      _CopyWithStubImpl_Query_MyMitteilungen;

  TRes call({Query_MyMitteilungen_my? my, String? $__typename});
  CopyWith_Query_MyMitteilungen_my<TRes> get my;
}

class _CopyWithImpl_Query_MyMitteilungen<TRes>
    implements CopyWith_Query_MyMitteilungen<TRes> {
  _CopyWithImpl_Query_MyMitteilungen(this._instance, this._then);

  final Query_MyMitteilungen _instance;

  final TRes Function(Query_MyMitteilungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyMitteilungen(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_MyMitteilungen_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MyMitteilungen_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_MyMitteilungen_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_MyMitteilungen<TRes>
    implements CopyWith_Query_MyMitteilungen<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen(this._res);

  TRes _res;

  call({Query_MyMitteilungen_my? my, String? $__typename}) => _res;

  CopyWith_Query_MyMitteilungen_my<TRes> get my =>
      CopyWith_Query_MyMitteilungen_my.stub(_res);
}

const documentNodeQueryMyMitteilungen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyMitteilungen'),
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
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
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
                        name: NameNode(value: 'mitteilungen'),
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
                              name: NameNode(value: 'historie'),
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
                                    name: NameNode(value: 'statusAenderung'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(
                                      value: 'statusAenderungBeschreibung',
                                    ),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'nachricht'),
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
Query_MyMitteilungen _parserFn_Query_MyMitteilungen(
  Map<String, dynamic> data,
) => Query_MyMitteilungen.fromJson(data);
typedef OnQueryComplete_Query_MyMitteilungen =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MyMitteilungen?);

class Options_Query_MyMitteilungen
    extends graphql.QueryOptions<Query_MyMitteilungen> {
  Options_Query_MyMitteilungen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyMitteilungen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyMitteilungen? onComplete,
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
                 data == null ? null : _parserFn_Query_MyMitteilungen(data),
               ),
         onError: onError,
         document: documentNodeQueryMyMitteilungen,
         parserFn: _parserFn_Query_MyMitteilungen,
       );

  final OnQueryComplete_Query_MyMitteilungen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyMitteilungen
    extends graphql.WatchQueryOptions<Query_MyMitteilungen> {
  WatchOptions_Query_MyMitteilungen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyMitteilungen? typedOptimisticResult,
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
         document: documentNodeQueryMyMitteilungen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyMitteilungen,
       );
}

class FetchMoreOptions_Query_MyMitteilungen extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyMitteilungen({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryMyMitteilungen,
       );
}

extension ClientExtension_Query_MyMitteilungen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyMitteilungen>> query_MyMitteilungen([
    Options_Query_MyMitteilungen? options,
  ]) async => await this.query(options ?? Options_Query_MyMitteilungen());

  graphql.ObservableQuery<Query_MyMitteilungen> watchQuery_MyMitteilungen([
    WatchOptions_Query_MyMitteilungen? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MyMitteilungen());

  void writeQuery_MyMitteilungen({
    required Query_MyMitteilungen data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMyMitteilungen),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyMitteilungen? readQuery_MyMitteilungen({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMyMitteilungen),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyMitteilungen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyMitteilungen> useQuery_MyMitteilungen([
  Options_Query_MyMitteilungen? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_MyMitteilungen());
graphql.ObservableQuery<Query_MyMitteilungen> useWatchQuery_MyMitteilungen([
  WatchOptions_Query_MyMitteilungen? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_MyMitteilungen(),
);

class Query_MyMitteilungen_Widget
    extends graphql_flutter.Query<Query_MyMitteilungen> {
  Query_MyMitteilungen_Widget({
    widgets.Key? key,
    Options_Query_MyMitteilungen? options,
    required graphql_flutter.QueryBuilder<Query_MyMitteilungen> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MyMitteilungen(),
         builder: builder,
       );
}

class Query_MyMitteilungen_my {
  Query_MyMitteilungen_my({required this.id, required this.$__typename});

  factory Query_MyMitteilungen_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_MyMitteilungen_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_MyMitteilungen_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_MyMitteilungen_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        return Query_MyMitteilungen_my(
          id: (l$id as String),
          $__typename: (l$$__typename as String),
        );
    }
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
    if (other is! Query_MyMitteilungen_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyMitteilungen_my on Query_MyMitteilungen_my {
  CopyWith_Query_MyMitteilungen_my<Query_MyMitteilungen_my> get copyWith =>
      CopyWith_Query_MyMitteilungen_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_MyMitteilungen_my__Buerger) buerger,
    required _T Function(Query_MyMitteilungen_my__BackofficeUser)
    backofficeUser,
    required _T Function(Query_MyMitteilungen_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_MyMitteilungen_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_MyMitteilungen_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_MyMitteilungen_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_MyMitteilungen_my__Buerger)? buerger,
    _T Function(Query_MyMitteilungen_my__BackofficeUser)? backofficeUser,
    _T Function(Query_MyMitteilungen_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_MyMitteilungen_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(
            this as Query_MyMitteilungen_my__BackofficeUser,
          );
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_MyMitteilungen_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_MyMitteilungen_my<TRes> {
  factory CopyWith_Query_MyMitteilungen_my(
    Query_MyMitteilungen_my instance,
    TRes Function(Query_MyMitteilungen_my) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my;

  factory CopyWith_Query_MyMitteilungen_my.stub(TRes res) =
      _CopyWithStubImpl_Query_MyMitteilungen_my;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyMitteilungen_my<TRes>
    implements CopyWith_Query_MyMitteilungen_my<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my(this._instance, this._then);

  final Query_MyMitteilungen_my _instance;

  final TRes Function(Query_MyMitteilungen_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyMitteilungen_my(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my<TRes>
    implements CopyWith_Query_MyMitteilungen_my<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyMitteilungen_my__Buerger implements Query_MyMitteilungen_my {
  Query_MyMitteilungen_my__Buerger({
    required this.mitteilungen,
    this.$__typename = 'Buerger',
    required this.id,
  });

  factory Query_MyMitteilungen_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$mitteilungen = json['mitteilungen'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query_MyMitteilungen_my__Buerger(
      mitteilungen: (l$mitteilungen as List<dynamic>)
          .map(
            (e) => Query_MyMitteilungen_my__Buerger_mitteilungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final List<Query_MyMitteilungen_my__Buerger_mitteilungen> mitteilungen;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mitteilungen = mitteilungen;
    _resultData['mitteilungen'] = l$mitteilungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mitteilungen = mitteilungen;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      Object.hashAll(l$mitteilungen.map((v) => v)),
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyMitteilungen_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mitteilungen = mitteilungen;
    final lOther$mitteilungen = other.mitteilungen;
    if (l$mitteilungen.length != lOther$mitteilungen.length) {
      return false;
    }
    for (int i = 0; i < l$mitteilungen.length; i++) {
      final l$mitteilungen$entry = l$mitteilungen[i];
      final lOther$mitteilungen$entry = lOther$mitteilungen[i];
      if (l$mitteilungen$entry != lOther$mitteilungen$entry) {
        return false;
      }
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
    return true;
  }
}

extension UtilityExtension_Query_MyMitteilungen_my__Buerger
    on Query_MyMitteilungen_my__Buerger {
  CopyWith_Query_MyMitteilungen_my__Buerger<Query_MyMitteilungen_my__Buerger>
  get copyWith => CopyWith_Query_MyMitteilungen_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_MyMitteilungen_my__Buerger<TRes> {
  factory CopyWith_Query_MyMitteilungen_my__Buerger(
    Query_MyMitteilungen_my__Buerger instance,
    TRes Function(Query_MyMitteilungen_my__Buerger) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__Buerger;

  factory CopyWith_Query_MyMitteilungen_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger;

  TRes call({
    List<Query_MyMitteilungen_my__Buerger_mitteilungen>? mitteilungen,
    String? $__typename,
    String? id,
  });
  TRes mitteilungen(
    Iterable<Query_MyMitteilungen_my__Buerger_mitteilungen> Function(
      Iterable<
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<
          Query_MyMitteilungen_my__Buerger_mitteilungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MyMitteilungen_my__Buerger<TRes>
    implements CopyWith_Query_MyMitteilungen_my__Buerger<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my__Buerger(this._instance, this._then);

  final Query_MyMitteilungen_my__Buerger _instance;

  final TRes Function(Query_MyMitteilungen_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? mitteilungen = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) => _then(
    Query_MyMitteilungen_my__Buerger(
      mitteilungen: mitteilungen == _undefined || mitteilungen == null
          ? _instance.mitteilungen
          : (mitteilungen
                as List<Query_MyMitteilungen_my__Buerger_mitteilungen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
    ),
  );

  TRes mitteilungen(
    Iterable<Query_MyMitteilungen_my__Buerger_mitteilungen> Function(
      Iterable<
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<
          Query_MyMitteilungen_my__Buerger_mitteilungen
        >
      >,
    )
    _fn,
  ) => call(
    mitteilungen: _fn(
      _instance.mitteilungen.map(
        (e) =>
            CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger<TRes>
    implements CopyWith_Query_MyMitteilungen_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger(this._res);

  TRes _res;

  call({
    List<Query_MyMitteilungen_my__Buerger_mitteilungen>? mitteilungen,
    String? $__typename,
    String? id,
  }) => _res;

  mitteilungen(_fn) => _res;
}

class Query_MyMitteilungen_my__Buerger_mitteilungen {
  Query_MyMitteilungen_my__Buerger_mitteilungen({
    required this.id,
    required this.prozessVersion,
    required this.historie,
    this.$__typename = 'Ausfuehrung',
  });

  factory Query_MyMitteilungen_my__Buerger_mitteilungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$prozessVersion = json['prozessVersion'];
    final l$historie = json['historie'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__Buerger_mitteilungen(
      id: (l$id as String),
      prozessVersion:
          Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion.fromJson(
            (l$prozessVersion as Map<String, dynamic>),
          ),
      historie: (l$historie as List<dynamic>)
          .map(
            (e) =>
                Query_MyMitteilungen_my__Buerger_mitteilungen_historie.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion
  prozessVersion;

  final List<Query_MyMitteilungen_my__Buerger_mitteilungen_historie> historie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    final l$historie = historie;
    _resultData['historie'] = l$historie.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$prozessVersion = prozessVersion;
    final l$historie = historie;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$prozessVersion,
      Object.hashAll(l$historie.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyMitteilungen_my__Buerger_mitteilungen ||
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
    final l$historie = historie;
    final lOther$historie = other.historie;
    if (l$historie.length != lOther$historie.length) {
      return false;
    }
    for (int i = 0; i < l$historie.length; i++) {
      final l$historie$entry = l$historie[i];
      final lOther$historie$entry = lOther$historie[i];
      if (l$historie$entry != lOther$historie$entry) {
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

extension UtilityExtension_Query_MyMitteilungen_my__Buerger_mitteilungen
    on Query_MyMitteilungen_my__Buerger_mitteilungen {
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<
    Query_MyMitteilungen_my__Buerger_mitteilungen
  >
  get copyWith =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen(this, (i) => i);
}

abstract class CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<TRes> {
  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen(
    Query_MyMitteilungen_my__Buerger_mitteilungen instance,
    TRes Function(Query_MyMitteilungen_my__Buerger_mitteilungen) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen;

  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen;

  TRes call({
    String? id,
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion?
    prozessVersion,
    List<Query_MyMitteilungen_my__Buerger_mitteilungen_historie>? historie,
    String? $__typename,
  });
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<TRes>
  get prozessVersion;
  TRes historie(
    Iterable<Query_MyMitteilungen_my__Buerger_mitteilungen_historie> Function(
      Iterable<
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<
          Query_MyMitteilungen_my__Buerger_mitteilungen_historie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen<TRes>
    implements CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen(
    this._instance,
    this._then,
  );

  final Query_MyMitteilungen_my__Buerger_mitteilungen _instance;

  final TRes Function(Query_MyMitteilungen_my__Buerger_mitteilungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? prozessVersion = _undefined,
    Object? historie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyMitteilungen_my__Buerger_mitteilungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion
                as Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion),
      historie: historie == _undefined || historie == null
          ? _instance.historie
          : (historie
                as List<
                  Query_MyMitteilungen_my__Buerger_mitteilungen_historie
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<TRes>
  get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }

  TRes historie(
    Iterable<Query_MyMitteilungen_my__Buerger_mitteilungen_historie> Function(
      Iterable<
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<
          Query_MyMitteilungen_my__Buerger_mitteilungen_historie
        >
      >,
    )
    _fn,
  ) => call(
    historie: _fn(
      _instance.historie.map(
        (e) => CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen<TRes>
    implements CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen(this._res);

  TRes _res;

  call({
    String? id,
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion?
    prozessVersion,
    List<Query_MyMitteilungen_my__Buerger_mitteilungen_historie>? historie,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<TRes>
  get prozessVersion =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion.stub(
        _res,
      );

  historie(_fn) => _res;
}

class Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion {
  Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion({
    required this.prozess,
    this.$__typename = 'ProzessVersion',
  });

  factory Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$prozess = json['prozess'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
      prozess:
          Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess.fromJson(
            (l$prozess as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess
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
            is! Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion ||
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

extension UtilityExtension_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion
    on Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion {
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion
  >
  get copyWith =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
  TRes
> {
  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion instance,
    TRes Function(Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion)
    then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion;

  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion;

  TRes call({
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess?
    prozess,
    String? $__typename,
  });
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
    TRes
  >
  get prozess;
}

class _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
  TRes
>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
          TRes
        > {
  _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
    this._instance,
    this._then,
  );

  final Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion _instance;

  final TRes Function(
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? prozess = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
      prozess: prozess == _undefined || prozess == null
          ? _instance.prozess
          : (prozess
                as Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
    TRes
  >
  get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
  TRes
>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion<
          TRes
        > {
  _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion(
    this._res,
  );

  TRes _res;

  call({
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess?
    prozess,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
    TRes
  >
  get prozess =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess.stub(
        _res,
      );
}

class Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess {
  Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess({
    required this.name,
    this.$__typename = 'Prozess',
  });

  factory Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess
    on Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess {
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess
  >
  get copyWith =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
  TRes
> {
  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess
    instance,
    TRes Function(
      Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess,
    )
    then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess;

  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess;

  TRes call({String? name, String? $__typename});
}

class _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
          TRes
        > {
  _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
    this._instance,
    this._then,
  );

  final Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess
  _instance;

  final TRes Function(
    Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
          name: name == _undefined || name == null
              ? _instance.name
              : (name as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess<
          TRes
        > {
  _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_prozessVersion_prozess(
    this._res,
  );

  TRes _res;

  call({String? name, String? $__typename}) => _res;
}

class Query_MyMitteilungen_my__Buerger_mitteilungen_historie {
  Query_MyMitteilungen_my__Buerger_mitteilungen_historie({
    required this.id,
    required this.createdAt,
    this.statusAenderung,
    this.statusAenderungBeschreibung,
    this.nachricht,
    this.$__typename = 'Historie',
  });

  factory Query_MyMitteilungen_my__Buerger_mitteilungen_historie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$statusAenderung = json['statusAenderung'];
    final l$statusAenderungBeschreibung = json['statusAenderungBeschreibung'];
    final l$nachricht = json['nachricht'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      statusAenderung: (l$statusAenderung as String?),
      statusAenderungBeschreibung: (l$statusAenderungBeschreibung as String?),
      nachricht: (l$nachricht as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final String? statusAenderung;

  final String? statusAenderungBeschreibung;

  final String? nachricht;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$statusAenderung = statusAenderung;
    _resultData['statusAenderung'] = l$statusAenderung;
    final l$statusAenderungBeschreibung = statusAenderungBeschreibung;
    _resultData['statusAenderungBeschreibung'] = l$statusAenderungBeschreibung;
    final l$nachricht = nachricht;
    _resultData['nachricht'] = l$nachricht;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$createdAt = createdAt;
    final l$statusAenderung = statusAenderung;
    final l$statusAenderungBeschreibung = statusAenderungBeschreibung;
    final l$nachricht = nachricht;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$statusAenderung,
      l$statusAenderungBeschreibung,
      l$nachricht,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyMitteilungen_my__Buerger_mitteilungen_historie ||
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
    final l$statusAenderung = statusAenderung;
    final lOther$statusAenderung = other.statusAenderung;
    if (l$statusAenderung != lOther$statusAenderung) {
      return false;
    }
    final l$statusAenderungBeschreibung = statusAenderungBeschreibung;
    final lOther$statusAenderungBeschreibung =
        other.statusAenderungBeschreibung;
    if (l$statusAenderungBeschreibung != lOther$statusAenderungBeschreibung) {
      return false;
    }
    final l$nachricht = nachricht;
    final lOther$nachricht = other.nachricht;
    if (l$nachricht != lOther$nachricht) {
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

extension UtilityExtension_Query_MyMitteilungen_my__Buerger_mitteilungen_historie
    on Query_MyMitteilungen_my__Buerger_mitteilungen_historie {
  CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<
    Query_MyMitteilungen_my__Buerger_mitteilungen_historie
  >
  get copyWith =>
      CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<
  TRes
> {
  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
    Query_MyMitteilungen_my__Buerger_mitteilungen_historie instance,
    TRes Function(Query_MyMitteilungen_my__Buerger_mitteilungen_historie) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie;

  factory CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie;

  TRes call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? nachricht,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<TRes>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
    this._instance,
    this._then,
  );

  final Query_MyMitteilungen_my__Buerger_mitteilungen_historie _instance;

  final TRes Function(Query_MyMitteilungen_my__Buerger_mitteilungen_historie)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? statusAenderung = _undefined,
    Object? statusAenderungBeschreibung = _undefined,
    Object? nachricht = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      statusAenderung: statusAenderung == _undefined
          ? _instance.statusAenderung
          : (statusAenderung as String?),
      statusAenderungBeschreibung: statusAenderungBeschreibung == _undefined
          ? _instance.statusAenderungBeschreibung
          : (statusAenderungBeschreibung as String?),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<
  TRes
>
    implements
        CopyWith_Query_MyMitteilungen_my__Buerger_mitteilungen_historie<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my__Buerger_mitteilungen_historie(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? nachricht,
    String? $__typename,
  }) => _res;
}

class Query_MyMitteilungen_my__BackofficeUser
    implements Query_MyMitteilungen_my {
  Query_MyMitteilungen_my__BackofficeUser({
    required this.id,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_MyMitteilungen_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__BackofficeUser(
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
    if (other is! Query_MyMitteilungen_my__BackofficeUser ||
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

extension UtilityExtension_Query_MyMitteilungen_my__BackofficeUser
    on Query_MyMitteilungen_my__BackofficeUser {
  CopyWith_Query_MyMitteilungen_my__BackofficeUser<
    Query_MyMitteilungen_my__BackofficeUser
  >
  get copyWith =>
      CopyWith_Query_MyMitteilungen_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_MyMitteilungen_my__BackofficeUser<TRes> {
  factory CopyWith_Query_MyMitteilungen_my__BackofficeUser(
    Query_MyMitteilungen_my__BackofficeUser instance,
    TRes Function(Query_MyMitteilungen_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__BackofficeUser;

  factory CopyWith_Query_MyMitteilungen_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyMitteilungen_my__BackofficeUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyMitteilungen_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyMitteilungen_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my__BackofficeUser(
    this._instance,
    this._then,
  );

  final Query_MyMitteilungen_my__BackofficeUser _instance;

  final TRes Function(Query_MyMitteilungen_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyMitteilungen_my__BackofficeUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyMitteilungen_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyMitteilungen_my__SystemUser implements Query_MyMitteilungen_my {
  Query_MyMitteilungen_my__SystemUser({
    required this.id,
    this.$__typename = 'SystemUser',
  });

  factory Query_MyMitteilungen_my__SystemUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyMitteilungen_my__SystemUser(
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
    if (other is! Query_MyMitteilungen_my__SystemUser ||
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

extension UtilityExtension_Query_MyMitteilungen_my__SystemUser
    on Query_MyMitteilungen_my__SystemUser {
  CopyWith_Query_MyMitteilungen_my__SystemUser<
    Query_MyMitteilungen_my__SystemUser
  >
  get copyWith => CopyWith_Query_MyMitteilungen_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_MyMitteilungen_my__SystemUser<TRes> {
  factory CopyWith_Query_MyMitteilungen_my__SystemUser(
    Query_MyMitteilungen_my__SystemUser instance,
    TRes Function(Query_MyMitteilungen_my__SystemUser) then,
  ) = _CopyWithImpl_Query_MyMitteilungen_my__SystemUser;

  factory CopyWith_Query_MyMitteilungen_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyMitteilungen_my__SystemUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyMitteilungen_my__SystemUser<TRes>
    implements CopyWith_Query_MyMitteilungen_my__SystemUser<TRes> {
  _CopyWithImpl_Query_MyMitteilungen_my__SystemUser(this._instance, this._then);

  final Query_MyMitteilungen_my__SystemUser _instance;

  final TRes Function(Query_MyMitteilungen_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyMitteilungen_my__SystemUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyMitteilungen_my__SystemUser<TRes>
    implements CopyWith_Query_MyMitteilungen_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_MyMitteilungen_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables_Mutation_UpdatePersonalData {
  factory Variables_Mutation_UpdatePersonalData({
    required Input_PersonalDataUpdateInput input,
  }) => Variables_Mutation_UpdatePersonalData._({r'input': input});

  Variables_Mutation_UpdatePersonalData._(this._$data);

  factory Variables_Mutation_UpdatePersonalData.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_PersonalDataUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_UpdatePersonalData._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_PersonalDataUpdateInput get input =>
      (_$data['input'] as Input_PersonalDataUpdateInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_UpdatePersonalData<
    Variables_Mutation_UpdatePersonalData
  >
  get copyWith =>
      CopyWith_Variables_Mutation_UpdatePersonalData(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_UpdatePersonalData ||
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

abstract class CopyWith_Variables_Mutation_UpdatePersonalData<TRes> {
  factory CopyWith_Variables_Mutation_UpdatePersonalData(
    Variables_Mutation_UpdatePersonalData instance,
    TRes Function(Variables_Mutation_UpdatePersonalData) then,
  ) = _CopyWithImpl_Variables_Mutation_UpdatePersonalData;

  factory CopyWith_Variables_Mutation_UpdatePersonalData.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_UpdatePersonalData;

  TRes call({Input_PersonalDataUpdateInput? input});
}

class _CopyWithImpl_Variables_Mutation_UpdatePersonalData<TRes>
    implements CopyWith_Variables_Mutation_UpdatePersonalData<TRes> {
  _CopyWithImpl_Variables_Mutation_UpdatePersonalData(
    this._instance,
    this._then,
  );

  final Variables_Mutation_UpdatePersonalData _instance;

  final TRes Function(Variables_Mutation_UpdatePersonalData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_UpdatePersonalData._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_PersonalDataUpdateInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_UpdatePersonalData<TRes>
    implements CopyWith_Variables_Mutation_UpdatePersonalData<TRes> {
  _CopyWithStubImpl_Variables_Mutation_UpdatePersonalData(this._res);

  TRes _res;

  call({Input_PersonalDataUpdateInput? input}) => _res;
}

class Mutation_UpdatePersonalData {
  Mutation_UpdatePersonalData({
    required this.personalDataUpdate,
    this.$__typename = 'Mutation',
  });

  factory Mutation_UpdatePersonalData.fromJson(Map<String, dynamic> json) {
    final l$personalDataUpdate = json['personalDataUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdatePersonalData(
      personalDataUpdate:
          Mutation_UpdatePersonalData_personalDataUpdate.fromJson(
            (l$personalDataUpdate as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdatePersonalData_personalDataUpdate personalDataUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$personalDataUpdate = personalDataUpdate;
    _resultData['personalDataUpdate'] = l$personalDataUpdate.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$personalDataUpdate = personalDataUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$personalDataUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdatePersonalData ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$personalDataUpdate = personalDataUpdate;
    final lOther$personalDataUpdate = other.personalDataUpdate;
    if (l$personalDataUpdate != lOther$personalDataUpdate) {
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

extension UtilityExtension_Mutation_UpdatePersonalData
    on Mutation_UpdatePersonalData {
  CopyWith_Mutation_UpdatePersonalData<Mutation_UpdatePersonalData>
  get copyWith => CopyWith_Mutation_UpdatePersonalData(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdatePersonalData<TRes> {
  factory CopyWith_Mutation_UpdatePersonalData(
    Mutation_UpdatePersonalData instance,
    TRes Function(Mutation_UpdatePersonalData) then,
  ) = _CopyWithImpl_Mutation_UpdatePersonalData;

  factory CopyWith_Mutation_UpdatePersonalData.stub(TRes res) =
      _CopyWithStubImpl_Mutation_UpdatePersonalData;

  TRes call({
    Mutation_UpdatePersonalData_personalDataUpdate? personalDataUpdate,
    String? $__typename,
  });
  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes>
  get personalDataUpdate;
}

class _CopyWithImpl_Mutation_UpdatePersonalData<TRes>
    implements CopyWith_Mutation_UpdatePersonalData<TRes> {
  _CopyWithImpl_Mutation_UpdatePersonalData(this._instance, this._then);

  final Mutation_UpdatePersonalData _instance;

  final TRes Function(Mutation_UpdatePersonalData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personalDataUpdate = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdatePersonalData(
      personalDataUpdate:
          personalDataUpdate == _undefined || personalDataUpdate == null
          ? _instance.personalDataUpdate
          : (personalDataUpdate
                as Mutation_UpdatePersonalData_personalDataUpdate),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes>
  get personalDataUpdate {
    final local$personalDataUpdate = _instance.personalDataUpdate;
    return CopyWith_Mutation_UpdatePersonalData_personalDataUpdate(
      local$personalDataUpdate,
      (e) => call(personalDataUpdate: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_UpdatePersonalData<TRes>
    implements CopyWith_Mutation_UpdatePersonalData<TRes> {
  _CopyWithStubImpl_Mutation_UpdatePersonalData(this._res);

  TRes _res;

  call({
    Mutation_UpdatePersonalData_personalDataUpdate? personalDataUpdate,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes>
  get personalDataUpdate =>
      CopyWith_Mutation_UpdatePersonalData_personalDataUpdate.stub(_res);
}

const documentNodeMutationUpdatePersonalData = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdatePersonalData'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'PersonalDataUpdateInput'),
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
            name: NameNode(value: 'personalDataUpdate'),
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
                  name: NameNode(value: 'buerger'),
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
                      FieldNode(
                        name: NameNode(value: 'personalData'),
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
                              name: NameNode(value: 'key'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'value'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'EncryptedValue'),
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
    fragmentDefinitionEncryptedValue,
  ],
);
Mutation_UpdatePersonalData _parserFn_Mutation_UpdatePersonalData(
  Map<String, dynamic> data,
) => Mutation_UpdatePersonalData.fromJson(data);
typedef OnMutationCompleted_Mutation_UpdatePersonalData =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_UpdatePersonalData?,
    );

class Options_Mutation_UpdatePersonalData
    extends graphql.MutationOptions<Mutation_UpdatePersonalData> {
  Options_Mutation_UpdatePersonalData({
    String? operationName,
    required Variables_Mutation_UpdatePersonalData variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdatePersonalData? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdatePersonalData? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdatePersonalData>? update,
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
                     : _parserFn_Mutation_UpdatePersonalData(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdatePersonalData,
         parserFn: _parserFn_Mutation_UpdatePersonalData,
       );

  final OnMutationCompleted_Mutation_UpdatePersonalData? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_UpdatePersonalData
    extends graphql.WatchQueryOptions<Mutation_UpdatePersonalData> {
  WatchOptions_Mutation_UpdatePersonalData({
    String? operationName,
    required Variables_Mutation_UpdatePersonalData variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdatePersonalData? typedOptimisticResult,
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
         document: documentNodeMutationUpdatePersonalData,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_UpdatePersonalData,
       );
}

extension ClientExtension_Mutation_UpdatePersonalData on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_UpdatePersonalData>>
  mutate_UpdatePersonalData(
    Options_Mutation_UpdatePersonalData options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_UpdatePersonalData>
  watchMutation_UpdatePersonalData(
    WatchOptions_Mutation_UpdatePersonalData options,
  ) => this.watchMutation(options);
}

class Mutation_UpdatePersonalData_HookResult {
  Mutation_UpdatePersonalData_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_UpdatePersonalData runMutation;

  final graphql.QueryResult<Mutation_UpdatePersonalData> result;
}

Mutation_UpdatePersonalData_HookResult useMutation_UpdatePersonalData([
  WidgetOptions_Mutation_UpdatePersonalData? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_UpdatePersonalData(),
  );
  return Mutation_UpdatePersonalData_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_UpdatePersonalData>
useWatchMutation_UpdatePersonalData(
  WatchOptions_Mutation_UpdatePersonalData options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_UpdatePersonalData
    extends graphql.MutationOptions<Mutation_UpdatePersonalData> {
  WidgetOptions_Mutation_UpdatePersonalData({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdatePersonalData? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdatePersonalData? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdatePersonalData>? update,
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
                     : _parserFn_Mutation_UpdatePersonalData(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdatePersonalData,
         parserFn: _parserFn_Mutation_UpdatePersonalData,
       );

  final OnMutationCompleted_Mutation_UpdatePersonalData? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_UpdatePersonalData =
    graphql.MultiSourceResult<Mutation_UpdatePersonalData> Function(
      Variables_Mutation_UpdatePersonalData, {
      Object? optimisticResult,
      Mutation_UpdatePersonalData? typedOptimisticResult,
    });
typedef Builder_Mutation_UpdatePersonalData =
    widgets.Widget Function(
      RunMutation_Mutation_UpdatePersonalData,
      graphql.QueryResult<Mutation_UpdatePersonalData>?,
    );

class Mutation_UpdatePersonalData_Widget
    extends graphql_flutter.Mutation<Mutation_UpdatePersonalData> {
  Mutation_UpdatePersonalData_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_UpdatePersonalData? options,
    required Builder_Mutation_UpdatePersonalData builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_UpdatePersonalData(),
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

class Mutation_UpdatePersonalData_personalDataUpdate {
  Mutation_UpdatePersonalData_personalDataUpdate({
    this.buerger,
    this.$__typename = 'PersonalDataUpdatePayload',
  });

  factory Mutation_UpdatePersonalData_personalDataUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$buerger = json['buerger'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdatePersonalData_personalDataUpdate(
      buerger: l$buerger == null
          ? null
          : Mutation_UpdatePersonalData_personalDataUpdate_buerger.fromJson(
              (l$buerger as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdatePersonalData_personalDataUpdate_buerger? buerger;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$buerger = buerger;
    _resultData['buerger'] = l$buerger?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$buerger = buerger;
    final l$$__typename = $__typename;
    return Object.hashAll([l$buerger, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdatePersonalData_personalDataUpdate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$buerger = buerger;
    final lOther$buerger = other.buerger;
    if (l$buerger != lOther$buerger) {
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

extension UtilityExtension_Mutation_UpdatePersonalData_personalDataUpdate
    on Mutation_UpdatePersonalData_personalDataUpdate {
  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<
    Mutation_UpdatePersonalData_personalDataUpdate
  >
  get copyWith =>
      CopyWith_Mutation_UpdatePersonalData_personalDataUpdate(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes> {
  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate(
    Mutation_UpdatePersonalData_personalDataUpdate instance,
    TRes Function(Mutation_UpdatePersonalData_personalDataUpdate) then,
  ) = _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate;

  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate;

  TRes call({
    Mutation_UpdatePersonalData_personalDataUpdate_buerger? buerger,
    String? $__typename,
  });
  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes>
  get buerger;
}

class _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate<TRes>
    implements CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes> {
  _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate(
    this._instance,
    this._then,
  );

  final Mutation_UpdatePersonalData_personalDataUpdate _instance;

  final TRes Function(Mutation_UpdatePersonalData_personalDataUpdate) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? buerger = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_UpdatePersonalData_personalDataUpdate(
          buerger: buerger == _undefined
              ? _instance.buerger
              : (buerger
                    as Mutation_UpdatePersonalData_personalDataUpdate_buerger?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes>
  get buerger {
    final local$buerger = _instance.buerger;
    return local$buerger == null
        ? CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger(
            local$buerger,
            (e) => call(buerger: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate<TRes>
    implements CopyWith_Mutation_UpdatePersonalData_personalDataUpdate<TRes> {
  _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate(this._res);

  TRes _res;

  call({
    Mutation_UpdatePersonalData_personalDataUpdate_buerger? buerger,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes>
  get buerger =>
      CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger.stub(
        _res,
      );
}

class Mutation_UpdatePersonalData_personalDataUpdate_buerger {
  Mutation_UpdatePersonalData_personalDataUpdate_buerger({
    required this.id,
    this.$__typename = 'Buerger',
    required this.personalData,
  });

  factory Mutation_UpdatePersonalData_personalDataUpdate_buerger.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$personalData = json['personalData'];
    return Mutation_UpdatePersonalData_personalDataUpdate_buerger(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      personalData: (l$personalData as List<dynamic>)
          .map(
            (e) =>
                Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final List<
    Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
  >
  personalData;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$personalData = personalData;
    _resultData['personalData'] = l$personalData
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$personalData = personalData;
    return Object.hashAll([
      l$id,
      l$$__typename,
      Object.hashAll(l$personalData.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdatePersonalData_personalDataUpdate_buerger ||
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
    final l$personalData = personalData;
    final lOther$personalData = other.personalData;
    if (l$personalData.length != lOther$personalData.length) {
      return false;
    }
    for (int i = 0; i < l$personalData.length; i++) {
      final l$personalData$entry = l$personalData[i];
      final lOther$personalData$entry = lOther$personalData[i];
      if (l$personalData$entry != lOther$personalData$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Mutation_UpdatePersonalData_personalDataUpdate_buerger
    on Mutation_UpdatePersonalData_personalDataUpdate_buerger {
  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<
    Mutation_UpdatePersonalData_personalDataUpdate_buerger
  >
  get copyWith =>
      CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<
  TRes
> {
  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger(
    Mutation_UpdatePersonalData_personalDataUpdate_buerger instance,
    TRes Function(Mutation_UpdatePersonalData_personalDataUpdate_buerger) then,
  ) = _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger;

  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger;

  TRes call({
    String? id,
    String? $__typename,
    List<Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData>?
    personalData,
  });
  TRes personalData(
    Iterable<
      Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
    >
    Function(
      Iterable<
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
          Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes>
    implements
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes> {
  _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger(
    this._instance,
    this._then,
  );

  final Mutation_UpdatePersonalData_personalDataUpdate_buerger _instance;

  final TRes Function(Mutation_UpdatePersonalData_personalDataUpdate_buerger)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? personalData = _undefined,
  }) => _then(
    Mutation_UpdatePersonalData_personalDataUpdate_buerger(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      personalData: personalData == _undefined || personalData == null
          ? _instance.personalData
          : (personalData
                as List<
                  Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
                >),
    ),
  );

  TRes personalData(
    Iterable<
      Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
    >
    Function(
      Iterable<
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
          Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
        >
      >,
    )
    _fn,
  ) => call(
    personalData: _fn(
      _instance.personalData.map(
        (e) =>
            CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger<
  TRes
>
    implements
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger<TRes> {
  _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? $__typename,
    List<Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData>?
    personalData,
  }) => _res;

  personalData(_fn) => _res;
}

class Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData {
  Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData({
    required this.id,
    required this.key,
    required this.value,
    this.$__typename = 'BuergerPersonalData',
  });

  factory Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$key = json['key'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
      id: (l$id as String),
      key: (l$key as String),
      value: Fragment_EncryptedValue.fromJson(
        (l$value as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String key;

  final Fragment_EncryptedValue value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$key = key;
    _resultData['key'] = l$key;
    final l$value = value;
    _resultData['value'] = l$value.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$key = key;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$key, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$key = key;
    final lOther$key = other.key;
    if (l$key != lOther$key) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
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

extension UtilityExtension_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
    on Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData {
  CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
    Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
  >
  get copyWith =>
      CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
  TRes
> {
  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
    Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
    instance,
    TRes Function(
      Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData;

  factory CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData;

  TRes call({
    String? id,
    String? key,
    Fragment_EncryptedValue? value,
    String? $__typename,
  });
  CopyWith_Fragment_EncryptedValue<TRes> get value;
}

class _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
  TRes
>
    implements
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
    this._instance,
    this._then,
  );

  final Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData
  _instance;

  final TRes Function(
    Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? key = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      key: key == _undefined || key == null ? _instance.key : (key as String),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as Fragment_EncryptedValue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_EncryptedValue<TRes> get value {
    final local$value = _instance.value;
    return CopyWith_Fragment_EncryptedValue(local$value, (e) => call(value: e));
  }
}

class _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
  TRes
>
    implements
        CopyWith_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdatePersonalData_personalDataUpdate_buerger_personalData(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? key,
    Fragment_EncryptedValue? value,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_EncryptedValue<TRes> get value =>
      CopyWith_Fragment_EncryptedValue.stub(_res);
}
