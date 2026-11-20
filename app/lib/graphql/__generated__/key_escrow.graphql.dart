import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables_Mutation_StoreKeyEscrow {
  factory Variables_Mutation_StoreKeyEscrow({
    required Input_StoreKeyEscrowInput input,
  }) => Variables_Mutation_StoreKeyEscrow._({r'input': input});

  Variables_Mutation_StoreKeyEscrow._(this._$data);

  factory Variables_Mutation_StoreKeyEscrow.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_StoreKeyEscrowInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_StoreKeyEscrow._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_StoreKeyEscrowInput get input =>
      (_$data['input'] as Input_StoreKeyEscrowInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_StoreKeyEscrow<Variables_Mutation_StoreKeyEscrow>
  get copyWith => CopyWith_Variables_Mutation_StoreKeyEscrow(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_StoreKeyEscrow ||
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

abstract class CopyWith_Variables_Mutation_StoreKeyEscrow<TRes> {
  factory CopyWith_Variables_Mutation_StoreKeyEscrow(
    Variables_Mutation_StoreKeyEscrow instance,
    TRes Function(Variables_Mutation_StoreKeyEscrow) then,
  ) = _CopyWithImpl_Variables_Mutation_StoreKeyEscrow;

  factory CopyWith_Variables_Mutation_StoreKeyEscrow.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_StoreKeyEscrow;

  TRes call({Input_StoreKeyEscrowInput? input});
}

class _CopyWithImpl_Variables_Mutation_StoreKeyEscrow<TRes>
    implements CopyWith_Variables_Mutation_StoreKeyEscrow<TRes> {
  _CopyWithImpl_Variables_Mutation_StoreKeyEscrow(this._instance, this._then);

  final Variables_Mutation_StoreKeyEscrow _instance;

  final TRes Function(Variables_Mutation_StoreKeyEscrow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_StoreKeyEscrow._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_StoreKeyEscrowInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_StoreKeyEscrow<TRes>
    implements CopyWith_Variables_Mutation_StoreKeyEscrow<TRes> {
  _CopyWithStubImpl_Variables_Mutation_StoreKeyEscrow(this._res);

  TRes _res;

  call({Input_StoreKeyEscrowInput? input}) => _res;
}

class Mutation_StoreKeyEscrow {
  Mutation_StoreKeyEscrow({
    required this.storeKeyEscrow,
    this.$__typename = 'Mutation',
  });

  factory Mutation_StoreKeyEscrow.fromJson(Map<String, dynamic> json) {
    final l$storeKeyEscrow = json['storeKeyEscrow'];
    final l$$__typename = json['__typename'];
    return Mutation_StoreKeyEscrow(
      storeKeyEscrow: Mutation_StoreKeyEscrow_storeKeyEscrow.fromJson(
        (l$storeKeyEscrow as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_StoreKeyEscrow_storeKeyEscrow storeKeyEscrow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$storeKeyEscrow = storeKeyEscrow;
    _resultData['storeKeyEscrow'] = l$storeKeyEscrow.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$storeKeyEscrow = storeKeyEscrow;
    final l$$__typename = $__typename;
    return Object.hashAll([l$storeKeyEscrow, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_StoreKeyEscrow || runtimeType != other.runtimeType) {
      return false;
    }
    final l$storeKeyEscrow = storeKeyEscrow;
    final lOther$storeKeyEscrow = other.storeKeyEscrow;
    if (l$storeKeyEscrow != lOther$storeKeyEscrow) {
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

extension UtilityExtension_Mutation_StoreKeyEscrow on Mutation_StoreKeyEscrow {
  CopyWith_Mutation_StoreKeyEscrow<Mutation_StoreKeyEscrow> get copyWith =>
      CopyWith_Mutation_StoreKeyEscrow(this, (i) => i);
}

abstract class CopyWith_Mutation_StoreKeyEscrow<TRes> {
  factory CopyWith_Mutation_StoreKeyEscrow(
    Mutation_StoreKeyEscrow instance,
    TRes Function(Mutation_StoreKeyEscrow) then,
  ) = _CopyWithImpl_Mutation_StoreKeyEscrow;

  factory CopyWith_Mutation_StoreKeyEscrow.stub(TRes res) =
      _CopyWithStubImpl_Mutation_StoreKeyEscrow;

  TRes call({
    Mutation_StoreKeyEscrow_storeKeyEscrow? storeKeyEscrow,
    String? $__typename,
  });
  CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> get storeKeyEscrow;
}

class _CopyWithImpl_Mutation_StoreKeyEscrow<TRes>
    implements CopyWith_Mutation_StoreKeyEscrow<TRes> {
  _CopyWithImpl_Mutation_StoreKeyEscrow(this._instance, this._then);

  final Mutation_StoreKeyEscrow _instance;

  final TRes Function(Mutation_StoreKeyEscrow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? storeKeyEscrow = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_StoreKeyEscrow(
      storeKeyEscrow: storeKeyEscrow == _undefined || storeKeyEscrow == null
          ? _instance.storeKeyEscrow
          : (storeKeyEscrow as Mutation_StoreKeyEscrow_storeKeyEscrow),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> get storeKeyEscrow {
    final local$storeKeyEscrow = _instance.storeKeyEscrow;
    return CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow(
      local$storeKeyEscrow,
      (e) => call(storeKeyEscrow: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_StoreKeyEscrow<TRes>
    implements CopyWith_Mutation_StoreKeyEscrow<TRes> {
  _CopyWithStubImpl_Mutation_StoreKeyEscrow(this._res);

  TRes _res;

  call({
    Mutation_StoreKeyEscrow_storeKeyEscrow? storeKeyEscrow,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> get storeKeyEscrow =>
      CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow.stub(_res);
}

const documentNodeMutationStoreKeyEscrow = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'StoreKeyEscrow'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'StoreKeyEscrowInput'),
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
            name: NameNode(value: 'storeKeyEscrow'),
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
Mutation_StoreKeyEscrow _parserFn_Mutation_StoreKeyEscrow(
  Map<String, dynamic> data,
) => Mutation_StoreKeyEscrow.fromJson(data);
typedef OnMutationCompleted_Mutation_StoreKeyEscrow =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_StoreKeyEscrow?);

class Options_Mutation_StoreKeyEscrow
    extends graphql.MutationOptions<Mutation_StoreKeyEscrow> {
  Options_Mutation_StoreKeyEscrow({
    String? operationName,
    required Variables_Mutation_StoreKeyEscrow variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_StoreKeyEscrow? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_StoreKeyEscrow? onCompleted,
    graphql.OnMutationUpdate<Mutation_StoreKeyEscrow>? update,
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
                 data == null ? null : _parserFn_Mutation_StoreKeyEscrow(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationStoreKeyEscrow,
         parserFn: _parserFn_Mutation_StoreKeyEscrow,
       );

  final OnMutationCompleted_Mutation_StoreKeyEscrow? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_StoreKeyEscrow
    extends graphql.WatchQueryOptions<Mutation_StoreKeyEscrow> {
  WatchOptions_Mutation_StoreKeyEscrow({
    String? operationName,
    required Variables_Mutation_StoreKeyEscrow variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_StoreKeyEscrow? typedOptimisticResult,
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
         document: documentNodeMutationStoreKeyEscrow,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_StoreKeyEscrow,
       );
}

extension ClientExtension_Mutation_StoreKeyEscrow on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_StoreKeyEscrow>> mutate_StoreKeyEscrow(
    Options_Mutation_StoreKeyEscrow options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_StoreKeyEscrow> watchMutation_StoreKeyEscrow(
    WatchOptions_Mutation_StoreKeyEscrow options,
  ) => this.watchMutation(options);
}

class Mutation_StoreKeyEscrow_HookResult {
  Mutation_StoreKeyEscrow_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_StoreKeyEscrow runMutation;

  final graphql.QueryResult<Mutation_StoreKeyEscrow> result;
}

Mutation_StoreKeyEscrow_HookResult useMutation_StoreKeyEscrow([
  WidgetOptions_Mutation_StoreKeyEscrow? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_StoreKeyEscrow(),
  );
  return Mutation_StoreKeyEscrow_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_StoreKeyEscrow>
useWatchMutation_StoreKeyEscrow(WatchOptions_Mutation_StoreKeyEscrow options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_StoreKeyEscrow
    extends graphql.MutationOptions<Mutation_StoreKeyEscrow> {
  WidgetOptions_Mutation_StoreKeyEscrow({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_StoreKeyEscrow? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_StoreKeyEscrow? onCompleted,
    graphql.OnMutationUpdate<Mutation_StoreKeyEscrow>? update,
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
                 data == null ? null : _parserFn_Mutation_StoreKeyEscrow(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationStoreKeyEscrow,
         parserFn: _parserFn_Mutation_StoreKeyEscrow,
       );

  final OnMutationCompleted_Mutation_StoreKeyEscrow? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_StoreKeyEscrow =
    graphql.MultiSourceResult<Mutation_StoreKeyEscrow> Function(
      Variables_Mutation_StoreKeyEscrow, {
      Object? optimisticResult,
      Mutation_StoreKeyEscrow? typedOptimisticResult,
    });
typedef Builder_Mutation_StoreKeyEscrow =
    widgets.Widget Function(
      RunMutation_Mutation_StoreKeyEscrow,
      graphql.QueryResult<Mutation_StoreKeyEscrow>?,
    );

class Mutation_StoreKeyEscrow_Widget
    extends graphql_flutter.Mutation<Mutation_StoreKeyEscrow> {
  Mutation_StoreKeyEscrow_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_StoreKeyEscrow? options,
    required Builder_Mutation_StoreKeyEscrow builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_StoreKeyEscrow(),
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

class Mutation_StoreKeyEscrow_storeKeyEscrow {
  Mutation_StoreKeyEscrow_storeKeyEscrow({
    this.boolean,
    this.$__typename = 'StoreKeyEscrowPayload',
  });

  factory Mutation_StoreKeyEscrow_storeKeyEscrow.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$boolean = json['boolean'];
    final l$$__typename = json['__typename'];
    return Mutation_StoreKeyEscrow_storeKeyEscrow(
      boolean: (l$boolean as bool?),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? boolean;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$boolean = boolean;
    _resultData['boolean'] = l$boolean;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$boolean = boolean;
    final l$$__typename = $__typename;
    return Object.hashAll([l$boolean, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_StoreKeyEscrow_storeKeyEscrow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$boolean = boolean;
    final lOther$boolean = other.boolean;
    if (l$boolean != lOther$boolean) {
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

extension UtilityExtension_Mutation_StoreKeyEscrow_storeKeyEscrow
    on Mutation_StoreKeyEscrow_storeKeyEscrow {
  CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<
    Mutation_StoreKeyEscrow_storeKeyEscrow
  >
  get copyWith =>
      CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow(this, (i) => i);
}

abstract class CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> {
  factory CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow(
    Mutation_StoreKeyEscrow_storeKeyEscrow instance,
    TRes Function(Mutation_StoreKeyEscrow_storeKeyEscrow) then,
  ) = _CopyWithImpl_Mutation_StoreKeyEscrow_storeKeyEscrow;

  factory CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow.stub(TRes res) =
      _CopyWithStubImpl_Mutation_StoreKeyEscrow_storeKeyEscrow;

  TRes call({bool? boolean, String? $__typename});
}

class _CopyWithImpl_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes>
    implements CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> {
  _CopyWithImpl_Mutation_StoreKeyEscrow_storeKeyEscrow(
    this._instance,
    this._then,
  );

  final Mutation_StoreKeyEscrow_storeKeyEscrow _instance;

  final TRes Function(Mutation_StoreKeyEscrow_storeKeyEscrow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? boolean = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_StoreKeyEscrow_storeKeyEscrow(
          boolean: boolean == _undefined
              ? _instance.boolean
              : (boolean as bool?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes>
    implements CopyWith_Mutation_StoreKeyEscrow_storeKeyEscrow<TRes> {
  _CopyWithStubImpl_Mutation_StoreKeyEscrow_storeKeyEscrow(this._res);

  TRes _res;

  call({bool? boolean, String? $__typename}) => _res;
}

class Query_KeyEscrow {
  Query_KeyEscrow({this.keyEscrow, this.$__typename = 'Query'});

  factory Query_KeyEscrow.fromJson(Map<String, dynamic> json) {
    final l$keyEscrow = json['keyEscrow'];
    final l$$__typename = json['__typename'];
    return Query_KeyEscrow(
      keyEscrow: (l$keyEscrow as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? keyEscrow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$keyEscrow = keyEscrow;
    _resultData['keyEscrow'] = l$keyEscrow;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$keyEscrow = keyEscrow;
    final l$$__typename = $__typename;
    return Object.hashAll([l$keyEscrow, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_KeyEscrow || runtimeType != other.runtimeType) {
      return false;
    }
    final l$keyEscrow = keyEscrow;
    final lOther$keyEscrow = other.keyEscrow;
    if (l$keyEscrow != lOther$keyEscrow) {
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

extension UtilityExtension_Query_KeyEscrow on Query_KeyEscrow {
  CopyWith_Query_KeyEscrow<Query_KeyEscrow> get copyWith =>
      CopyWith_Query_KeyEscrow(this, (i) => i);
}

abstract class CopyWith_Query_KeyEscrow<TRes> {
  factory CopyWith_Query_KeyEscrow(
    Query_KeyEscrow instance,
    TRes Function(Query_KeyEscrow) then,
  ) = _CopyWithImpl_Query_KeyEscrow;

  factory CopyWith_Query_KeyEscrow.stub(TRes res) =
      _CopyWithStubImpl_Query_KeyEscrow;

  TRes call({String? keyEscrow, String? $__typename});
}

class _CopyWithImpl_Query_KeyEscrow<TRes>
    implements CopyWith_Query_KeyEscrow<TRes> {
  _CopyWithImpl_Query_KeyEscrow(this._instance, this._then);

  final Query_KeyEscrow _instance;

  final TRes Function(Query_KeyEscrow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? keyEscrow = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_KeyEscrow(
      keyEscrow: keyEscrow == _undefined
          ? _instance.keyEscrow
          : (keyEscrow as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_KeyEscrow<TRes>
    implements CopyWith_Query_KeyEscrow<TRes> {
  _CopyWithStubImpl_Query_KeyEscrow(this._res);

  TRes _res;

  call({String? keyEscrow, String? $__typename}) => _res;
}

const documentNodeQueryKeyEscrow = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'KeyEscrow'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'keyEscrow'),
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
);
Query_KeyEscrow _parserFn_Query_KeyEscrow(Map<String, dynamic> data) =>
    Query_KeyEscrow.fromJson(data);
typedef OnQueryComplete_Query_KeyEscrow =
    FutureOr<void> Function(Map<String, dynamic>?, Query_KeyEscrow?);

class Options_Query_KeyEscrow extends graphql.QueryOptions<Query_KeyEscrow> {
  Options_Query_KeyEscrow({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_KeyEscrow? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_KeyEscrow? onComplete,
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
                 data == null ? null : _parserFn_Query_KeyEscrow(data),
               ),
         onError: onError,
         document: documentNodeQueryKeyEscrow,
         parserFn: _parserFn_Query_KeyEscrow,
       );

  final OnQueryComplete_Query_KeyEscrow? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_KeyEscrow
    extends graphql.WatchQueryOptions<Query_KeyEscrow> {
  WatchOptions_Query_KeyEscrow({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_KeyEscrow? typedOptimisticResult,
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
         document: documentNodeQueryKeyEscrow,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_KeyEscrow,
       );
}

class FetchMoreOptions_Query_KeyEscrow extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_KeyEscrow({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryKeyEscrow);
}

extension ClientExtension_Query_KeyEscrow on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_KeyEscrow>> query_KeyEscrow([
    Options_Query_KeyEscrow? options,
  ]) async => await this.query(options ?? Options_Query_KeyEscrow());

  graphql.ObservableQuery<Query_KeyEscrow> watchQuery_KeyEscrow([
    WatchOptions_Query_KeyEscrow? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_KeyEscrow());

  void writeQuery_KeyEscrow({
    required Query_KeyEscrow data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryKeyEscrow),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_KeyEscrow? readQuery_KeyEscrow({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryKeyEscrow),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_KeyEscrow.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_KeyEscrow> useQuery_KeyEscrow([
  Options_Query_KeyEscrow? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_KeyEscrow());
graphql.ObservableQuery<Query_KeyEscrow> useWatchQuery_KeyEscrow([
  WatchOptions_Query_KeyEscrow? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_KeyEscrow());

class Query_KeyEscrow_Widget extends graphql_flutter.Query<Query_KeyEscrow> {
  Query_KeyEscrow_Widget({
    widgets.Key? key,
    Options_Query_KeyEscrow? options,
    required graphql_flutter.QueryBuilder<Query_KeyEscrow> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_KeyEscrow(),
         builder: builder,
       );
}
