import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables_Mutation_WeakRegister {
  factory Variables_Mutation_WeakRegister({
    required Input_RegisterBuergerWeakInput input,
  }) => Variables_Mutation_WeakRegister._({r'input': input});

  Variables_Mutation_WeakRegister._(this._$data);

  factory Variables_Mutation_WeakRegister.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_RegisterBuergerWeakInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_WeakRegister._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_RegisterBuergerWeakInput get input =>
      (_$data['input'] as Input_RegisterBuergerWeakInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_WeakRegister<Variables_Mutation_WeakRegister>
  get copyWith => CopyWith_Variables_Mutation_WeakRegister(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_WeakRegister ||
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

abstract class CopyWith_Variables_Mutation_WeakRegister<TRes> {
  factory CopyWith_Variables_Mutation_WeakRegister(
    Variables_Mutation_WeakRegister instance,
    TRes Function(Variables_Mutation_WeakRegister) then,
  ) = _CopyWithImpl_Variables_Mutation_WeakRegister;

  factory CopyWith_Variables_Mutation_WeakRegister.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_WeakRegister;

  TRes call({Input_RegisterBuergerWeakInput? input});
}

class _CopyWithImpl_Variables_Mutation_WeakRegister<TRes>
    implements CopyWith_Variables_Mutation_WeakRegister<TRes> {
  _CopyWithImpl_Variables_Mutation_WeakRegister(this._instance, this._then);

  final Variables_Mutation_WeakRegister _instance;

  final TRes Function(Variables_Mutation_WeakRegister) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_WeakRegister._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_RegisterBuergerWeakInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_WeakRegister<TRes>
    implements CopyWith_Variables_Mutation_WeakRegister<TRes> {
  _CopyWithStubImpl_Variables_Mutation_WeakRegister(this._res);

  TRes _res;

  call({Input_RegisterBuergerWeakInput? input}) => _res;
}

class Mutation_WeakRegister {
  Mutation_WeakRegister({
    required this.registerBuergerWeak,
    this.$__typename = 'Mutation',
  });

  factory Mutation_WeakRegister.fromJson(Map<String, dynamic> json) {
    final l$registerBuergerWeak = json['registerBuergerWeak'];
    final l$$__typename = json['__typename'];
    return Mutation_WeakRegister(
      registerBuergerWeak: Mutation_WeakRegister_registerBuergerWeak.fromJson(
        (l$registerBuergerWeak as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_WeakRegister_registerBuergerWeak registerBuergerWeak;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerBuergerWeak = registerBuergerWeak;
    _resultData['registerBuergerWeak'] = l$registerBuergerWeak.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerBuergerWeak = registerBuergerWeak;
    final l$$__typename = $__typename;
    return Object.hashAll([l$registerBuergerWeak, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_WeakRegister || runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerBuergerWeak = registerBuergerWeak;
    final lOther$registerBuergerWeak = other.registerBuergerWeak;
    if (l$registerBuergerWeak != lOther$registerBuergerWeak) {
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

extension UtilityExtension_Mutation_WeakRegister on Mutation_WeakRegister {
  CopyWith_Mutation_WeakRegister<Mutation_WeakRegister> get copyWith =>
      CopyWith_Mutation_WeakRegister(this, (i) => i);
}

abstract class CopyWith_Mutation_WeakRegister<TRes> {
  factory CopyWith_Mutation_WeakRegister(
    Mutation_WeakRegister instance,
    TRes Function(Mutation_WeakRegister) then,
  ) = _CopyWithImpl_Mutation_WeakRegister;

  factory CopyWith_Mutation_WeakRegister.stub(TRes res) =
      _CopyWithStubImpl_Mutation_WeakRegister;

  TRes call({
    Mutation_WeakRegister_registerBuergerWeak? registerBuergerWeak,
    String? $__typename,
  });
  CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes>
  get registerBuergerWeak;
}

class _CopyWithImpl_Mutation_WeakRegister<TRes>
    implements CopyWith_Mutation_WeakRegister<TRes> {
  _CopyWithImpl_Mutation_WeakRegister(this._instance, this._then);

  final Mutation_WeakRegister _instance;

  final TRes Function(Mutation_WeakRegister) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? registerBuergerWeak = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_WeakRegister(
      registerBuergerWeak:
          registerBuergerWeak == _undefined || registerBuergerWeak == null
          ? _instance.registerBuergerWeak
          : (registerBuergerWeak as Mutation_WeakRegister_registerBuergerWeak),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes>
  get registerBuergerWeak {
    final local$registerBuergerWeak = _instance.registerBuergerWeak;
    return CopyWith_Mutation_WeakRegister_registerBuergerWeak(
      local$registerBuergerWeak,
      (e) => call(registerBuergerWeak: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_WeakRegister<TRes>
    implements CopyWith_Mutation_WeakRegister<TRes> {
  _CopyWithStubImpl_Mutation_WeakRegister(this._res);

  TRes _res;

  call({
    Mutation_WeakRegister_registerBuergerWeak? registerBuergerWeak,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes>
  get registerBuergerWeak =>
      CopyWith_Mutation_WeakRegister_registerBuergerWeak.stub(_res);
}

const documentNodeMutationWeakRegister = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'WeakRegister'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RegisterBuergerWeakInput'),
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
            name: NameNode(value: 'registerBuergerWeak'),
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
                  name: NameNode(value: 'buergerId'),
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
Mutation_WeakRegister _parserFn_Mutation_WeakRegister(
  Map<String, dynamic> data,
) => Mutation_WeakRegister.fromJson(data);
typedef OnMutationCompleted_Mutation_WeakRegister =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_WeakRegister?);

class Options_Mutation_WeakRegister
    extends graphql.MutationOptions<Mutation_WeakRegister> {
  Options_Mutation_WeakRegister({
    String? operationName,
    required Variables_Mutation_WeakRegister variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakRegister? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_WeakRegister? onCompleted,
    graphql.OnMutationUpdate<Mutation_WeakRegister>? update,
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
                 data == null ? null : _parserFn_Mutation_WeakRegister(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationWeakRegister,
         parserFn: _parserFn_Mutation_WeakRegister,
       );

  final OnMutationCompleted_Mutation_WeakRegister? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_WeakRegister
    extends graphql.WatchQueryOptions<Mutation_WeakRegister> {
  WatchOptions_Mutation_WeakRegister({
    String? operationName,
    required Variables_Mutation_WeakRegister variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakRegister? typedOptimisticResult,
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
         document: documentNodeMutationWeakRegister,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_WeakRegister,
       );
}

extension ClientExtension_Mutation_WeakRegister on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_WeakRegister>> mutate_WeakRegister(
    Options_Mutation_WeakRegister options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_WeakRegister> watchMutation_WeakRegister(
    WatchOptions_Mutation_WeakRegister options,
  ) => this.watchMutation(options);
}

class Mutation_WeakRegister_HookResult {
  Mutation_WeakRegister_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_WeakRegister runMutation;

  final graphql.QueryResult<Mutation_WeakRegister> result;
}

Mutation_WeakRegister_HookResult useMutation_WeakRegister([
  WidgetOptions_Mutation_WeakRegister? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_WeakRegister(),
  );
  return Mutation_WeakRegister_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_WeakRegister> useWatchMutation_WeakRegister(
  WatchOptions_Mutation_WeakRegister options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_WeakRegister
    extends graphql.MutationOptions<Mutation_WeakRegister> {
  WidgetOptions_Mutation_WeakRegister({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakRegister? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_WeakRegister? onCompleted,
    graphql.OnMutationUpdate<Mutation_WeakRegister>? update,
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
                 data == null ? null : _parserFn_Mutation_WeakRegister(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationWeakRegister,
         parserFn: _parserFn_Mutation_WeakRegister,
       );

  final OnMutationCompleted_Mutation_WeakRegister? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_WeakRegister =
    graphql.MultiSourceResult<Mutation_WeakRegister> Function(
      Variables_Mutation_WeakRegister, {
      Object? optimisticResult,
      Mutation_WeakRegister? typedOptimisticResult,
    });
typedef Builder_Mutation_WeakRegister =
    widgets.Widget Function(
      RunMutation_Mutation_WeakRegister,
      graphql.QueryResult<Mutation_WeakRegister>?,
    );

class Mutation_WeakRegister_Widget
    extends graphql_flutter.Mutation<Mutation_WeakRegister> {
  Mutation_WeakRegister_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_WeakRegister? options,
    required Builder_Mutation_WeakRegister builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_WeakRegister(),
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

class Mutation_WeakRegister_registerBuergerWeak {
  Mutation_WeakRegister_registerBuergerWeak({
    this.buergerId,
    this.$__typename = 'RegisterBuergerWeakPayload',
  });

  factory Mutation_WeakRegister_registerBuergerWeak.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$buergerId = json['buergerId'];
    final l$$__typename = json['__typename'];
    return Mutation_WeakRegister_registerBuergerWeak(
      buergerId: (l$buergerId as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? buergerId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$buergerId = buergerId;
    _resultData['buergerId'] = l$buergerId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$buergerId = buergerId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$buergerId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_WeakRegister_registerBuergerWeak ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$buergerId = buergerId;
    final lOther$buergerId = other.buergerId;
    if (l$buergerId != lOther$buergerId) {
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

extension UtilityExtension_Mutation_WeakRegister_registerBuergerWeak
    on Mutation_WeakRegister_registerBuergerWeak {
  CopyWith_Mutation_WeakRegister_registerBuergerWeak<
    Mutation_WeakRegister_registerBuergerWeak
  >
  get copyWith =>
      CopyWith_Mutation_WeakRegister_registerBuergerWeak(this, (i) => i);
}

abstract class CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes> {
  factory CopyWith_Mutation_WeakRegister_registerBuergerWeak(
    Mutation_WeakRegister_registerBuergerWeak instance,
    TRes Function(Mutation_WeakRegister_registerBuergerWeak) then,
  ) = _CopyWithImpl_Mutation_WeakRegister_registerBuergerWeak;

  factory CopyWith_Mutation_WeakRegister_registerBuergerWeak.stub(TRes res) =
      _CopyWithStubImpl_Mutation_WeakRegister_registerBuergerWeak;

  TRes call({String? buergerId, String? $__typename});
}

class _CopyWithImpl_Mutation_WeakRegister_registerBuergerWeak<TRes>
    implements CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes> {
  _CopyWithImpl_Mutation_WeakRegister_registerBuergerWeak(
    this._instance,
    this._then,
  );

  final Mutation_WeakRegister_registerBuergerWeak _instance;

  final TRes Function(Mutation_WeakRegister_registerBuergerWeak) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? buergerId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_WeakRegister_registerBuergerWeak(
      buergerId: buergerId == _undefined
          ? _instance.buergerId
          : (buergerId as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_WeakRegister_registerBuergerWeak<TRes>
    implements CopyWith_Mutation_WeakRegister_registerBuergerWeak<TRes> {
  _CopyWithStubImpl_Mutation_WeakRegister_registerBuergerWeak(this._res);

  TRes _res;

  call({String? buergerId, String? $__typename}) => _res;
}
