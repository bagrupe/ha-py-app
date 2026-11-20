import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables_Mutation_WeakLogin {
  factory Variables_Mutation_WeakLogin({
    required Input_LoginBuergerWeakInput input,
  }) => Variables_Mutation_WeakLogin._({r'input': input});

  Variables_Mutation_WeakLogin._(this._$data);

  factory Variables_Mutation_WeakLogin.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_LoginBuergerWeakInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_WeakLogin._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_LoginBuergerWeakInput get input =>
      (_$data['input'] as Input_LoginBuergerWeakInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_WeakLogin<Variables_Mutation_WeakLogin>
  get copyWith => CopyWith_Variables_Mutation_WeakLogin(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_WeakLogin ||
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

abstract class CopyWith_Variables_Mutation_WeakLogin<TRes> {
  factory CopyWith_Variables_Mutation_WeakLogin(
    Variables_Mutation_WeakLogin instance,
    TRes Function(Variables_Mutation_WeakLogin) then,
  ) = _CopyWithImpl_Variables_Mutation_WeakLogin;

  factory CopyWith_Variables_Mutation_WeakLogin.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_WeakLogin;

  TRes call({Input_LoginBuergerWeakInput? input});
}

class _CopyWithImpl_Variables_Mutation_WeakLogin<TRes>
    implements CopyWith_Variables_Mutation_WeakLogin<TRes> {
  _CopyWithImpl_Variables_Mutation_WeakLogin(this._instance, this._then);

  final Variables_Mutation_WeakLogin _instance;

  final TRes Function(Variables_Mutation_WeakLogin) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_WeakLogin._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_LoginBuergerWeakInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_WeakLogin<TRes>
    implements CopyWith_Variables_Mutation_WeakLogin<TRes> {
  _CopyWithStubImpl_Variables_Mutation_WeakLogin(this._res);

  TRes _res;

  call({Input_LoginBuergerWeakInput? input}) => _res;
}

class Mutation_WeakLogin {
  Mutation_WeakLogin({
    required this.loginBuergerWeak,
    this.$__typename = 'Mutation',
  });

  factory Mutation_WeakLogin.fromJson(Map<String, dynamic> json) {
    final l$loginBuergerWeak = json['loginBuergerWeak'];
    final l$$__typename = json['__typename'];
    return Mutation_WeakLogin(
      loginBuergerWeak: Mutation_WeakLogin_loginBuergerWeak.fromJson(
        (l$loginBuergerWeak as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_WeakLogin_loginBuergerWeak loginBuergerWeak;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loginBuergerWeak = loginBuergerWeak;
    _resultData['loginBuergerWeak'] = l$loginBuergerWeak.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loginBuergerWeak = loginBuergerWeak;
    final l$$__typename = $__typename;
    return Object.hashAll([l$loginBuergerWeak, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_WeakLogin || runtimeType != other.runtimeType) {
      return false;
    }
    final l$loginBuergerWeak = loginBuergerWeak;
    final lOther$loginBuergerWeak = other.loginBuergerWeak;
    if (l$loginBuergerWeak != lOther$loginBuergerWeak) {
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

extension UtilityExtension_Mutation_WeakLogin on Mutation_WeakLogin {
  CopyWith_Mutation_WeakLogin<Mutation_WeakLogin> get copyWith =>
      CopyWith_Mutation_WeakLogin(this, (i) => i);
}

abstract class CopyWith_Mutation_WeakLogin<TRes> {
  factory CopyWith_Mutation_WeakLogin(
    Mutation_WeakLogin instance,
    TRes Function(Mutation_WeakLogin) then,
  ) = _CopyWithImpl_Mutation_WeakLogin;

  factory CopyWith_Mutation_WeakLogin.stub(TRes res) =
      _CopyWithStubImpl_Mutation_WeakLogin;

  TRes call({
    Mutation_WeakLogin_loginBuergerWeak? loginBuergerWeak,
    String? $__typename,
  });
  CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> get loginBuergerWeak;
}

class _CopyWithImpl_Mutation_WeakLogin<TRes>
    implements CopyWith_Mutation_WeakLogin<TRes> {
  _CopyWithImpl_Mutation_WeakLogin(this._instance, this._then);

  final Mutation_WeakLogin _instance;

  final TRes Function(Mutation_WeakLogin) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loginBuergerWeak = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_WeakLogin(
      loginBuergerWeak:
          loginBuergerWeak == _undefined || loginBuergerWeak == null
          ? _instance.loginBuergerWeak
          : (loginBuergerWeak as Mutation_WeakLogin_loginBuergerWeak),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> get loginBuergerWeak {
    final local$loginBuergerWeak = _instance.loginBuergerWeak;
    return CopyWith_Mutation_WeakLogin_loginBuergerWeak(
      local$loginBuergerWeak,
      (e) => call(loginBuergerWeak: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_WeakLogin<TRes>
    implements CopyWith_Mutation_WeakLogin<TRes> {
  _CopyWithStubImpl_Mutation_WeakLogin(this._res);

  TRes _res;

  call({
    Mutation_WeakLogin_loginBuergerWeak? loginBuergerWeak,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> get loginBuergerWeak =>
      CopyWith_Mutation_WeakLogin_loginBuergerWeak.stub(_res);
}

const documentNodeMutationWeakLogin = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'WeakLogin'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'LoginBuergerWeakInput'),
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
            name: NameNode(value: 'loginBuergerWeak'),
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
                  name: NameNode(value: 'loginPayload'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'result'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'token'),
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
Mutation_WeakLogin _parserFn_Mutation_WeakLogin(Map<String, dynamic> data) =>
    Mutation_WeakLogin.fromJson(data);
typedef OnMutationCompleted_Mutation_WeakLogin =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_WeakLogin?);

class Options_Mutation_WeakLogin
    extends graphql.MutationOptions<Mutation_WeakLogin> {
  Options_Mutation_WeakLogin({
    String? operationName,
    required Variables_Mutation_WeakLogin variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakLogin? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_WeakLogin? onCompleted,
    graphql.OnMutationUpdate<Mutation_WeakLogin>? update,
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
                 data == null ? null : _parserFn_Mutation_WeakLogin(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationWeakLogin,
         parserFn: _parserFn_Mutation_WeakLogin,
       );

  final OnMutationCompleted_Mutation_WeakLogin? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_WeakLogin
    extends graphql.WatchQueryOptions<Mutation_WeakLogin> {
  WatchOptions_Mutation_WeakLogin({
    String? operationName,
    required Variables_Mutation_WeakLogin variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakLogin? typedOptimisticResult,
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
         document: documentNodeMutationWeakLogin,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_WeakLogin,
       );
}

extension ClientExtension_Mutation_WeakLogin on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_WeakLogin>> mutate_WeakLogin(
    Options_Mutation_WeakLogin options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_WeakLogin> watchMutation_WeakLogin(
    WatchOptions_Mutation_WeakLogin options,
  ) => this.watchMutation(options);
}

class Mutation_WeakLogin_HookResult {
  Mutation_WeakLogin_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_WeakLogin runMutation;

  final graphql.QueryResult<Mutation_WeakLogin> result;
}

Mutation_WeakLogin_HookResult useMutation_WeakLogin([
  WidgetOptions_Mutation_WeakLogin? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_WeakLogin(),
  );
  return Mutation_WeakLogin_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_WeakLogin> useWatchMutation_WeakLogin(
  WatchOptions_Mutation_WeakLogin options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_WeakLogin
    extends graphql.MutationOptions<Mutation_WeakLogin> {
  WidgetOptions_Mutation_WeakLogin({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_WeakLogin? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_WeakLogin? onCompleted,
    graphql.OnMutationUpdate<Mutation_WeakLogin>? update,
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
                 data == null ? null : _parserFn_Mutation_WeakLogin(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationWeakLogin,
         parserFn: _parserFn_Mutation_WeakLogin,
       );

  final OnMutationCompleted_Mutation_WeakLogin? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_WeakLogin =
    graphql.MultiSourceResult<Mutation_WeakLogin> Function(
      Variables_Mutation_WeakLogin, {
      Object? optimisticResult,
      Mutation_WeakLogin? typedOptimisticResult,
    });
typedef Builder_Mutation_WeakLogin =
    widgets.Widget Function(
      RunMutation_Mutation_WeakLogin,
      graphql.QueryResult<Mutation_WeakLogin>?,
    );

class Mutation_WeakLogin_Widget
    extends graphql_flutter.Mutation<Mutation_WeakLogin> {
  Mutation_WeakLogin_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_WeakLogin? options,
    required Builder_Mutation_WeakLogin builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_WeakLogin(),
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

class Mutation_WeakLogin_loginBuergerWeak {
  Mutation_WeakLogin_loginBuergerWeak({
    this.loginPayload,
    this.$__typename = 'LoginBuergerWeakPayload',
  });

  factory Mutation_WeakLogin_loginBuergerWeak.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$loginPayload = json['loginPayload'];
    final l$$__typename = json['__typename'];
    return Mutation_WeakLogin_loginBuergerWeak(
      loginPayload: l$loginPayload == null
          ? null
          : Mutation_WeakLogin_loginBuergerWeak_loginPayload.fromJson(
              (l$loginPayload as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_WeakLogin_loginBuergerWeak_loginPayload? loginPayload;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$loginPayload = loginPayload;
    _resultData['loginPayload'] = l$loginPayload?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$loginPayload = loginPayload;
    final l$$__typename = $__typename;
    return Object.hashAll([l$loginPayload, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_WeakLogin_loginBuergerWeak ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$loginPayload = loginPayload;
    final lOther$loginPayload = other.loginPayload;
    if (l$loginPayload != lOther$loginPayload) {
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

extension UtilityExtension_Mutation_WeakLogin_loginBuergerWeak
    on Mutation_WeakLogin_loginBuergerWeak {
  CopyWith_Mutation_WeakLogin_loginBuergerWeak<
    Mutation_WeakLogin_loginBuergerWeak
  >
  get copyWith => CopyWith_Mutation_WeakLogin_loginBuergerWeak(this, (i) => i);
}

abstract class CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> {
  factory CopyWith_Mutation_WeakLogin_loginBuergerWeak(
    Mutation_WeakLogin_loginBuergerWeak instance,
    TRes Function(Mutation_WeakLogin_loginBuergerWeak) then,
  ) = _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak;

  factory CopyWith_Mutation_WeakLogin_loginBuergerWeak.stub(TRes res) =
      _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak;

  TRes call({
    Mutation_WeakLogin_loginBuergerWeak_loginPayload? loginPayload,
    String? $__typename,
  });
  CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes>
  get loginPayload;
}

class _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak<TRes>
    implements CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> {
  _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak(this._instance, this._then);

  final Mutation_WeakLogin_loginBuergerWeak _instance;

  final TRes Function(Mutation_WeakLogin_loginBuergerWeak) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? loginPayload = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_WeakLogin_loginBuergerWeak(
      loginPayload: loginPayload == _undefined
          ? _instance.loginPayload
          : (loginPayload as Mutation_WeakLogin_loginBuergerWeak_loginPayload?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes>
  get loginPayload {
    final local$loginPayload = _instance.loginPayload;
    return local$loginPayload == null
        ? CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload(
            local$loginPayload,
            (e) => call(loginPayload: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak<TRes>
    implements CopyWith_Mutation_WeakLogin_loginBuergerWeak<TRes> {
  _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak(this._res);

  TRes _res;

  call({
    Mutation_WeakLogin_loginBuergerWeak_loginPayload? loginPayload,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes>
  get loginPayload =>
      CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload.stub(_res);
}

class Mutation_WeakLogin_loginBuergerWeak_loginPayload {
  Mutation_WeakLogin_loginBuergerWeak_loginPayload({
    required this.result,
    this.token,
    this.$__typename = 'LoginPayload',
  });

  factory Mutation_WeakLogin_loginBuergerWeak_loginPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$result = json['result'];
    final l$token = json['token'];
    final l$$__typename = json['__typename'];
    return Mutation_WeakLogin_loginBuergerWeak_loginPayload(
      result: fromJson_Enum_LoginResult((l$result as String)),
      token: (l$token as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum_LoginResult result;

  final String? token;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$result = result;
    _resultData['result'] = toJson_Enum_LoginResult(l$result);
    final l$token = token;
    _resultData['token'] = l$token;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$result = result;
    final l$token = token;
    final l$$__typename = $__typename;
    return Object.hashAll([l$result, l$token, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_WeakLogin_loginBuergerWeak_loginPayload ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$result = result;
    final lOther$result = other.result;
    if (l$result != lOther$result) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
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

extension UtilityExtension_Mutation_WeakLogin_loginBuergerWeak_loginPayload
    on Mutation_WeakLogin_loginBuergerWeak_loginPayload {
  CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<
    Mutation_WeakLogin_loginBuergerWeak_loginPayload
  >
  get copyWith =>
      CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload(this, (i) => i);
}

abstract class CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes> {
  factory CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload(
    Mutation_WeakLogin_loginBuergerWeak_loginPayload instance,
    TRes Function(Mutation_WeakLogin_loginBuergerWeak_loginPayload) then,
  ) = _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload;

  factory CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload;

  TRes call({Enum_LoginResult? result, String? token, String? $__typename});
}

class _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes>
    implements CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes> {
  _CopyWithImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload(
    this._instance,
    this._then,
  );

  final Mutation_WeakLogin_loginBuergerWeak_loginPayload _instance;

  final TRes Function(Mutation_WeakLogin_loginBuergerWeak_loginPayload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? result = _undefined,
    Object? token = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_WeakLogin_loginBuergerWeak_loginPayload(
      result: result == _undefined || result == null
          ? _instance.result
          : (result as Enum_LoginResult),
      token: token == _undefined ? _instance.token : (token as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes>
    implements CopyWith_Mutation_WeakLogin_loginBuergerWeak_loginPayload<TRes> {
  _CopyWithStubImpl_Mutation_WeakLogin_loginBuergerWeak_loginPayload(this._res);

  TRes _res;

  call({Enum_LoginResult? result, String? token, String? $__typename}) => _res;
}

class Variables_Mutation_RegisterToken {
  factory Variables_Mutation_RegisterToken({
    required Input_NotificationTokenRegisterInput input,
  }) => Variables_Mutation_RegisterToken._({r'input': input});

  Variables_Mutation_RegisterToken._(this._$data);

  factory Variables_Mutation_RegisterToken.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_NotificationTokenRegisterInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_RegisterToken._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_NotificationTokenRegisterInput get input =>
      (_$data['input'] as Input_NotificationTokenRegisterInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_RegisterToken<Variables_Mutation_RegisterToken>
  get copyWith => CopyWith_Variables_Mutation_RegisterToken(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_RegisterToken ||
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

abstract class CopyWith_Variables_Mutation_RegisterToken<TRes> {
  factory CopyWith_Variables_Mutation_RegisterToken(
    Variables_Mutation_RegisterToken instance,
    TRes Function(Variables_Mutation_RegisterToken) then,
  ) = _CopyWithImpl_Variables_Mutation_RegisterToken;

  factory CopyWith_Variables_Mutation_RegisterToken.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_RegisterToken;

  TRes call({Input_NotificationTokenRegisterInput? input});
}

class _CopyWithImpl_Variables_Mutation_RegisterToken<TRes>
    implements CopyWith_Variables_Mutation_RegisterToken<TRes> {
  _CopyWithImpl_Variables_Mutation_RegisterToken(this._instance, this._then);

  final Variables_Mutation_RegisterToken _instance;

  final TRes Function(Variables_Mutation_RegisterToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_RegisterToken._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_NotificationTokenRegisterInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_RegisterToken<TRes>
    implements CopyWith_Variables_Mutation_RegisterToken<TRes> {
  _CopyWithStubImpl_Variables_Mutation_RegisterToken(this._res);

  TRes _res;

  call({Input_NotificationTokenRegisterInput? input}) => _res;
}

class Mutation_RegisterToken {
  Mutation_RegisterToken({
    required this.notificationTokenRegister,
    this.$__typename = 'Mutation',
  });

  factory Mutation_RegisterToken.fromJson(Map<String, dynamic> json) {
    final l$notificationTokenRegister = json['notificationTokenRegister'];
    final l$$__typename = json['__typename'];
    return Mutation_RegisterToken(
      notificationTokenRegister:
          Mutation_RegisterToken_notificationTokenRegister.fromJson(
            (l$notificationTokenRegister as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_RegisterToken_notificationTokenRegister
  notificationTokenRegister;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$notificationTokenRegister = notificationTokenRegister;
    _resultData['notificationTokenRegister'] = l$notificationTokenRegister
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$notificationTokenRegister = notificationTokenRegister;
    final l$$__typename = $__typename;
    return Object.hashAll([l$notificationTokenRegister, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_RegisterToken || runtimeType != other.runtimeType) {
      return false;
    }
    final l$notificationTokenRegister = notificationTokenRegister;
    final lOther$notificationTokenRegister = other.notificationTokenRegister;
    if (l$notificationTokenRegister != lOther$notificationTokenRegister) {
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

extension UtilityExtension_Mutation_RegisterToken on Mutation_RegisterToken {
  CopyWith_Mutation_RegisterToken<Mutation_RegisterToken> get copyWith =>
      CopyWith_Mutation_RegisterToken(this, (i) => i);
}

abstract class CopyWith_Mutation_RegisterToken<TRes> {
  factory CopyWith_Mutation_RegisterToken(
    Mutation_RegisterToken instance,
    TRes Function(Mutation_RegisterToken) then,
  ) = _CopyWithImpl_Mutation_RegisterToken;

  factory CopyWith_Mutation_RegisterToken.stub(TRes res) =
      _CopyWithStubImpl_Mutation_RegisterToken;

  TRes call({
    Mutation_RegisterToken_notificationTokenRegister? notificationTokenRegister,
    String? $__typename,
  });
  CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes>
  get notificationTokenRegister;
}

class _CopyWithImpl_Mutation_RegisterToken<TRes>
    implements CopyWith_Mutation_RegisterToken<TRes> {
  _CopyWithImpl_Mutation_RegisterToken(this._instance, this._then);

  final Mutation_RegisterToken _instance;

  final TRes Function(Mutation_RegisterToken) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? notificationTokenRegister = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_RegisterToken(
      notificationTokenRegister:
          notificationTokenRegister == _undefined ||
              notificationTokenRegister == null
          ? _instance.notificationTokenRegister
          : (notificationTokenRegister
                as Mutation_RegisterToken_notificationTokenRegister),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes>
  get notificationTokenRegister {
    final local$notificationTokenRegister = _instance.notificationTokenRegister;
    return CopyWith_Mutation_RegisterToken_notificationTokenRegister(
      local$notificationTokenRegister,
      (e) => call(notificationTokenRegister: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_RegisterToken<TRes>
    implements CopyWith_Mutation_RegisterToken<TRes> {
  _CopyWithStubImpl_Mutation_RegisterToken(this._res);

  TRes _res;

  call({
    Mutation_RegisterToken_notificationTokenRegister? notificationTokenRegister,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes>
  get notificationTokenRegister =>
      CopyWith_Mutation_RegisterToken_notificationTokenRegister.stub(_res);
}

const documentNodeMutationRegisterToken = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegisterToken'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'NotificationTokenRegisterInput'),
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
            name: NameNode(value: 'notificationTokenRegister'),
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
Mutation_RegisterToken _parserFn_Mutation_RegisterToken(
  Map<String, dynamic> data,
) => Mutation_RegisterToken.fromJson(data);
typedef OnMutationCompleted_Mutation_RegisterToken =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_RegisterToken?);

class Options_Mutation_RegisterToken
    extends graphql.MutationOptions<Mutation_RegisterToken> {
  Options_Mutation_RegisterToken({
    String? operationName,
    required Variables_Mutation_RegisterToken variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RegisterToken? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_RegisterToken? onCompleted,
    graphql.OnMutationUpdate<Mutation_RegisterToken>? update,
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
                 data == null ? null : _parserFn_Mutation_RegisterToken(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationRegisterToken,
         parserFn: _parserFn_Mutation_RegisterToken,
       );

  final OnMutationCompleted_Mutation_RegisterToken? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_RegisterToken
    extends graphql.WatchQueryOptions<Mutation_RegisterToken> {
  WatchOptions_Mutation_RegisterToken({
    String? operationName,
    required Variables_Mutation_RegisterToken variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RegisterToken? typedOptimisticResult,
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
         document: documentNodeMutationRegisterToken,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_RegisterToken,
       );
}

extension ClientExtension_Mutation_RegisterToken on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_RegisterToken>> mutate_RegisterToken(
    Options_Mutation_RegisterToken options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_RegisterToken> watchMutation_RegisterToken(
    WatchOptions_Mutation_RegisterToken options,
  ) => this.watchMutation(options);
}

class Mutation_RegisterToken_HookResult {
  Mutation_RegisterToken_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_RegisterToken runMutation;

  final graphql.QueryResult<Mutation_RegisterToken> result;
}

Mutation_RegisterToken_HookResult useMutation_RegisterToken([
  WidgetOptions_Mutation_RegisterToken? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_RegisterToken(),
  );
  return Mutation_RegisterToken_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_RegisterToken> useWatchMutation_RegisterToken(
  WatchOptions_Mutation_RegisterToken options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_RegisterToken
    extends graphql.MutationOptions<Mutation_RegisterToken> {
  WidgetOptions_Mutation_RegisterToken({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RegisterToken? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_RegisterToken? onCompleted,
    graphql.OnMutationUpdate<Mutation_RegisterToken>? update,
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
                 data == null ? null : _parserFn_Mutation_RegisterToken(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationRegisterToken,
         parserFn: _parserFn_Mutation_RegisterToken,
       );

  final OnMutationCompleted_Mutation_RegisterToken? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_RegisterToken =
    graphql.MultiSourceResult<Mutation_RegisterToken> Function(
      Variables_Mutation_RegisterToken, {
      Object? optimisticResult,
      Mutation_RegisterToken? typedOptimisticResult,
    });
typedef Builder_Mutation_RegisterToken =
    widgets.Widget Function(
      RunMutation_Mutation_RegisterToken,
      graphql.QueryResult<Mutation_RegisterToken>?,
    );

class Mutation_RegisterToken_Widget
    extends graphql_flutter.Mutation<Mutation_RegisterToken> {
  Mutation_RegisterToken_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_RegisterToken? options,
    required Builder_Mutation_RegisterToken builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_RegisterToken(),
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

class Mutation_RegisterToken_notificationTokenRegister {
  Mutation_RegisterToken_notificationTokenRegister({
    this.buerger,
    this.$__typename = 'NotificationTokenRegisterPayload',
  });

  factory Mutation_RegisterToken_notificationTokenRegister.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$buerger = json['buerger'];
    final l$$__typename = json['__typename'];
    return Mutation_RegisterToken_notificationTokenRegister(
      buerger: l$buerger == null
          ? null
          : Mutation_RegisterToken_notificationTokenRegister_buerger.fromJson(
              (l$buerger as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_RegisterToken_notificationTokenRegister_buerger? buerger;

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
    if (other is! Mutation_RegisterToken_notificationTokenRegister ||
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

extension UtilityExtension_Mutation_RegisterToken_notificationTokenRegister
    on Mutation_RegisterToken_notificationTokenRegister {
  CopyWith_Mutation_RegisterToken_notificationTokenRegister<
    Mutation_RegisterToken_notificationTokenRegister
  >
  get copyWith =>
      CopyWith_Mutation_RegisterToken_notificationTokenRegister(this, (i) => i);
}

abstract class CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes> {
  factory CopyWith_Mutation_RegisterToken_notificationTokenRegister(
    Mutation_RegisterToken_notificationTokenRegister instance,
    TRes Function(Mutation_RegisterToken_notificationTokenRegister) then,
  ) = _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister;

  factory CopyWith_Mutation_RegisterToken_notificationTokenRegister.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister;

  TRes call({
    Mutation_RegisterToken_notificationTokenRegister_buerger? buerger,
    String? $__typename,
  });
  CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<TRes>
  get buerger;
}

class _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister<TRes>
    implements CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes> {
  _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister(
    this._instance,
    this._then,
  );

  final Mutation_RegisterToken_notificationTokenRegister _instance;

  final TRes Function(Mutation_RegisterToken_notificationTokenRegister) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? buerger = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_RegisterToken_notificationTokenRegister(
      buerger: buerger == _undefined
          ? _instance.buerger
          : (buerger
                as Mutation_RegisterToken_notificationTokenRegister_buerger?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<TRes>
  get buerger {
    final local$buerger = _instance.buerger;
    return local$buerger == null
        ? CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger(
            local$buerger,
            (e) => call(buerger: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister<TRes>
    implements CopyWith_Mutation_RegisterToken_notificationTokenRegister<TRes> {
  _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister(this._res);

  TRes _res;

  call({
    Mutation_RegisterToken_notificationTokenRegister_buerger? buerger,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<TRes>
  get buerger =>
      CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger.stub(
        _res,
      );
}

class Mutation_RegisterToken_notificationTokenRegister_buerger {
  Mutation_RegisterToken_notificationTokenRegister_buerger({
    required this.id,
    this.$__typename = 'Buerger',
  });

  factory Mutation_RegisterToken_notificationTokenRegister_buerger.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation_RegisterToken_notificationTokenRegister_buerger(
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
    if (other is! Mutation_RegisterToken_notificationTokenRegister_buerger ||
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

extension UtilityExtension_Mutation_RegisterToken_notificationTokenRegister_buerger
    on Mutation_RegisterToken_notificationTokenRegister_buerger {
  CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<
    Mutation_RegisterToken_notificationTokenRegister_buerger
  >
  get copyWith =>
      CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<
  TRes
> {
  factory CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger(
    Mutation_RegisterToken_notificationTokenRegister_buerger instance,
    TRes Function(Mutation_RegisterToken_notificationTokenRegister_buerger)
    then,
  ) = _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister_buerger;

  factory CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister_buerger;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister_buerger<
  TRes
>
    implements
        CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<
          TRes
        > {
  _CopyWithImpl_Mutation_RegisterToken_notificationTokenRegister_buerger(
    this._instance,
    this._then,
  );

  final Mutation_RegisterToken_notificationTokenRegister_buerger _instance;

  final TRes Function(Mutation_RegisterToken_notificationTokenRegister_buerger)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_RegisterToken_notificationTokenRegister_buerger(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister_buerger<
  TRes
>
    implements
        CopyWith_Mutation_RegisterToken_notificationTokenRegister_buerger<
          TRes
        > {
  _CopyWithStubImpl_Mutation_RegisterToken_notificationTokenRegister_buerger(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}
