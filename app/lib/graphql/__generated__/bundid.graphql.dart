import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Variables_Mutation_RequestSmsCode {
  factory Variables_Mutation_RequestSmsCode({
    required Input_RequestSmsCodeInput input,
  }) => Variables_Mutation_RequestSmsCode._({r'input': input});

  Variables_Mutation_RequestSmsCode._(this._$data);

  factory Variables_Mutation_RequestSmsCode.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_RequestSmsCodeInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_RequestSmsCode._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_RequestSmsCodeInput get input =>
      (_$data['input'] as Input_RequestSmsCodeInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_RequestSmsCode<Variables_Mutation_RequestSmsCode>
  get copyWith => CopyWith_Variables_Mutation_RequestSmsCode(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_RequestSmsCode ||
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

abstract class CopyWith_Variables_Mutation_RequestSmsCode<TRes> {
  factory CopyWith_Variables_Mutation_RequestSmsCode(
    Variables_Mutation_RequestSmsCode instance,
    TRes Function(Variables_Mutation_RequestSmsCode) then,
  ) = _CopyWithImpl_Variables_Mutation_RequestSmsCode;

  factory CopyWith_Variables_Mutation_RequestSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_RequestSmsCode;

  TRes call({Input_RequestSmsCodeInput? input});
}

class _CopyWithImpl_Variables_Mutation_RequestSmsCode<TRes>
    implements CopyWith_Variables_Mutation_RequestSmsCode<TRes> {
  _CopyWithImpl_Variables_Mutation_RequestSmsCode(this._instance, this._then);

  final Variables_Mutation_RequestSmsCode _instance;

  final TRes Function(Variables_Mutation_RequestSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_RequestSmsCode._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_RequestSmsCodeInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_RequestSmsCode<TRes>
    implements CopyWith_Variables_Mutation_RequestSmsCode<TRes> {
  _CopyWithStubImpl_Variables_Mutation_RequestSmsCode(this._res);

  TRes _res;

  call({Input_RequestSmsCodeInput? input}) => _res;
}

class Mutation_RequestSmsCode {
  Mutation_RequestSmsCode({
    required this.requestSmsCode,
    this.$__typename = 'Mutation',
  });

  factory Mutation_RequestSmsCode.fromJson(Map<String, dynamic> json) {
    final l$requestSmsCode = json['requestSmsCode'];
    final l$$__typename = json['__typename'];
    return Mutation_RequestSmsCode(
      requestSmsCode: Mutation_RequestSmsCode_requestSmsCode.fromJson(
        (l$requestSmsCode as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_RequestSmsCode_requestSmsCode requestSmsCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$requestSmsCode = requestSmsCode;
    _resultData['requestSmsCode'] = l$requestSmsCode.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$requestSmsCode = requestSmsCode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$requestSmsCode, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_RequestSmsCode || runtimeType != other.runtimeType) {
      return false;
    }
    final l$requestSmsCode = requestSmsCode;
    final lOther$requestSmsCode = other.requestSmsCode;
    if (l$requestSmsCode != lOther$requestSmsCode) {
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

extension UtilityExtension_Mutation_RequestSmsCode on Mutation_RequestSmsCode {
  CopyWith_Mutation_RequestSmsCode<Mutation_RequestSmsCode> get copyWith =>
      CopyWith_Mutation_RequestSmsCode(this, (i) => i);
}

abstract class CopyWith_Mutation_RequestSmsCode<TRes> {
  factory CopyWith_Mutation_RequestSmsCode(
    Mutation_RequestSmsCode instance,
    TRes Function(Mutation_RequestSmsCode) then,
  ) = _CopyWithImpl_Mutation_RequestSmsCode;

  factory CopyWith_Mutation_RequestSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Mutation_RequestSmsCode;

  TRes call({
    Mutation_RequestSmsCode_requestSmsCode? requestSmsCode,
    String? $__typename,
  });
  CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> get requestSmsCode;
}

class _CopyWithImpl_Mutation_RequestSmsCode<TRes>
    implements CopyWith_Mutation_RequestSmsCode<TRes> {
  _CopyWithImpl_Mutation_RequestSmsCode(this._instance, this._then);

  final Mutation_RequestSmsCode _instance;

  final TRes Function(Mutation_RequestSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? requestSmsCode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_RequestSmsCode(
      requestSmsCode: requestSmsCode == _undefined || requestSmsCode == null
          ? _instance.requestSmsCode
          : (requestSmsCode as Mutation_RequestSmsCode_requestSmsCode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> get requestSmsCode {
    final local$requestSmsCode = _instance.requestSmsCode;
    return CopyWith_Mutation_RequestSmsCode_requestSmsCode(
      local$requestSmsCode,
      (e) => call(requestSmsCode: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_RequestSmsCode<TRes>
    implements CopyWith_Mutation_RequestSmsCode<TRes> {
  _CopyWithStubImpl_Mutation_RequestSmsCode(this._res);

  TRes _res;

  call({
    Mutation_RequestSmsCode_requestSmsCode? requestSmsCode,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> get requestSmsCode =>
      CopyWith_Mutation_RequestSmsCode_requestSmsCode.stub(_res);
}

const documentNodeMutationRequestSmsCode = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RequestSmsCode'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'RequestSmsCodeInput'),
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
            name: NameNode(value: 'requestSmsCode'),
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
                  name: NameNode(value: 'requestSmsResult'),
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
Mutation_RequestSmsCode _parserFn_Mutation_RequestSmsCode(
  Map<String, dynamic> data,
) => Mutation_RequestSmsCode.fromJson(data);
typedef OnMutationCompleted_Mutation_RequestSmsCode =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_RequestSmsCode?);

class Options_Mutation_RequestSmsCode
    extends graphql.MutationOptions<Mutation_RequestSmsCode> {
  Options_Mutation_RequestSmsCode({
    String? operationName,
    required Variables_Mutation_RequestSmsCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RequestSmsCode? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_RequestSmsCode? onCompleted,
    graphql.OnMutationUpdate<Mutation_RequestSmsCode>? update,
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
                 data == null ? null : _parserFn_Mutation_RequestSmsCode(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationRequestSmsCode,
         parserFn: _parserFn_Mutation_RequestSmsCode,
       );

  final OnMutationCompleted_Mutation_RequestSmsCode? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_RequestSmsCode
    extends graphql.WatchQueryOptions<Mutation_RequestSmsCode> {
  WatchOptions_Mutation_RequestSmsCode({
    String? operationName,
    required Variables_Mutation_RequestSmsCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RequestSmsCode? typedOptimisticResult,
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
         document: documentNodeMutationRequestSmsCode,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_RequestSmsCode,
       );
}

extension ClientExtension_Mutation_RequestSmsCode on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_RequestSmsCode>> mutate_RequestSmsCode(
    Options_Mutation_RequestSmsCode options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_RequestSmsCode> watchMutation_RequestSmsCode(
    WatchOptions_Mutation_RequestSmsCode options,
  ) => this.watchMutation(options);
}

class Mutation_RequestSmsCode_HookResult {
  Mutation_RequestSmsCode_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_RequestSmsCode runMutation;

  final graphql.QueryResult<Mutation_RequestSmsCode> result;
}

Mutation_RequestSmsCode_HookResult useMutation_RequestSmsCode([
  WidgetOptions_Mutation_RequestSmsCode? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_RequestSmsCode(),
  );
  return Mutation_RequestSmsCode_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_RequestSmsCode>
useWatchMutation_RequestSmsCode(WatchOptions_Mutation_RequestSmsCode options) =>
    graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_RequestSmsCode
    extends graphql.MutationOptions<Mutation_RequestSmsCode> {
  WidgetOptions_Mutation_RequestSmsCode({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_RequestSmsCode? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_RequestSmsCode? onCompleted,
    graphql.OnMutationUpdate<Mutation_RequestSmsCode>? update,
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
                 data == null ? null : _parserFn_Mutation_RequestSmsCode(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationRequestSmsCode,
         parserFn: _parserFn_Mutation_RequestSmsCode,
       );

  final OnMutationCompleted_Mutation_RequestSmsCode? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_RequestSmsCode =
    graphql.MultiSourceResult<Mutation_RequestSmsCode> Function(
      Variables_Mutation_RequestSmsCode, {
      Object? optimisticResult,
      Mutation_RequestSmsCode? typedOptimisticResult,
    });
typedef Builder_Mutation_RequestSmsCode =
    widgets.Widget Function(
      RunMutation_Mutation_RequestSmsCode,
      graphql.QueryResult<Mutation_RequestSmsCode>?,
    );

class Mutation_RequestSmsCode_Widget
    extends graphql_flutter.Mutation<Mutation_RequestSmsCode> {
  Mutation_RequestSmsCode_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_RequestSmsCode? options,
    required Builder_Mutation_RequestSmsCode builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_RequestSmsCode(),
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

class Mutation_RequestSmsCode_requestSmsCode {
  Mutation_RequestSmsCode_requestSmsCode({
    this.requestSmsResult,
    this.$__typename = 'RequestSmsCodePayload',
  });

  factory Mutation_RequestSmsCode_requestSmsCode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$requestSmsResult = json['requestSmsResult'];
    final l$$__typename = json['__typename'];
    return Mutation_RequestSmsCode_requestSmsCode(
      requestSmsResult: l$requestSmsResult == null
          ? null
          : fromJson_Enum_RequestSmsResult((l$requestSmsResult as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum_RequestSmsResult? requestSmsResult;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$requestSmsResult = requestSmsResult;
    _resultData['requestSmsResult'] = l$requestSmsResult == null
        ? null
        : toJson_Enum_RequestSmsResult(l$requestSmsResult);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$requestSmsResult = requestSmsResult;
    final l$$__typename = $__typename;
    return Object.hashAll([l$requestSmsResult, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_RequestSmsCode_requestSmsCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$requestSmsResult = requestSmsResult;
    final lOther$requestSmsResult = other.requestSmsResult;
    if (l$requestSmsResult != lOther$requestSmsResult) {
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

extension UtilityExtension_Mutation_RequestSmsCode_requestSmsCode
    on Mutation_RequestSmsCode_requestSmsCode {
  CopyWith_Mutation_RequestSmsCode_requestSmsCode<
    Mutation_RequestSmsCode_requestSmsCode
  >
  get copyWith =>
      CopyWith_Mutation_RequestSmsCode_requestSmsCode(this, (i) => i);
}

abstract class CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> {
  factory CopyWith_Mutation_RequestSmsCode_requestSmsCode(
    Mutation_RequestSmsCode_requestSmsCode instance,
    TRes Function(Mutation_RequestSmsCode_requestSmsCode) then,
  ) = _CopyWithImpl_Mutation_RequestSmsCode_requestSmsCode;

  factory CopyWith_Mutation_RequestSmsCode_requestSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Mutation_RequestSmsCode_requestSmsCode;

  TRes call({Enum_RequestSmsResult? requestSmsResult, String? $__typename});
}

class _CopyWithImpl_Mutation_RequestSmsCode_requestSmsCode<TRes>
    implements CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> {
  _CopyWithImpl_Mutation_RequestSmsCode_requestSmsCode(
    this._instance,
    this._then,
  );

  final Mutation_RequestSmsCode_requestSmsCode _instance;

  final TRes Function(Mutation_RequestSmsCode_requestSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? requestSmsResult = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_RequestSmsCode_requestSmsCode(
      requestSmsResult: requestSmsResult == _undefined
          ? _instance.requestSmsResult
          : (requestSmsResult as Enum_RequestSmsResult?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_RequestSmsCode_requestSmsCode<TRes>
    implements CopyWith_Mutation_RequestSmsCode_requestSmsCode<TRes> {
  _CopyWithStubImpl_Mutation_RequestSmsCode_requestSmsCode(this._res);

  TRes _res;

  call({Enum_RequestSmsResult? requestSmsResult, String? $__typename}) => _res;
}

class Variables_Mutation_ValidateSmsCode {
  factory Variables_Mutation_ValidateSmsCode({
    required Input_ValidateSmsCodeInput input,
  }) => Variables_Mutation_ValidateSmsCode._({r'input': input});

  Variables_Mutation_ValidateSmsCode._(this._$data);

  factory Variables_Mutation_ValidateSmsCode.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_ValidateSmsCodeInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_ValidateSmsCode._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_ValidateSmsCodeInput get input =>
      (_$data['input'] as Input_ValidateSmsCodeInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_ValidateSmsCode<
    Variables_Mutation_ValidateSmsCode
  >
  get copyWith => CopyWith_Variables_Mutation_ValidateSmsCode(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_ValidateSmsCode ||
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

abstract class CopyWith_Variables_Mutation_ValidateSmsCode<TRes> {
  factory CopyWith_Variables_Mutation_ValidateSmsCode(
    Variables_Mutation_ValidateSmsCode instance,
    TRes Function(Variables_Mutation_ValidateSmsCode) then,
  ) = _CopyWithImpl_Variables_Mutation_ValidateSmsCode;

  factory CopyWith_Variables_Mutation_ValidateSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_ValidateSmsCode;

  TRes call({Input_ValidateSmsCodeInput? input});
}

class _CopyWithImpl_Variables_Mutation_ValidateSmsCode<TRes>
    implements CopyWith_Variables_Mutation_ValidateSmsCode<TRes> {
  _CopyWithImpl_Variables_Mutation_ValidateSmsCode(this._instance, this._then);

  final Variables_Mutation_ValidateSmsCode _instance;

  final TRes Function(Variables_Mutation_ValidateSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_ValidateSmsCode._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_ValidateSmsCodeInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_ValidateSmsCode<TRes>
    implements CopyWith_Variables_Mutation_ValidateSmsCode<TRes> {
  _CopyWithStubImpl_Variables_Mutation_ValidateSmsCode(this._res);

  TRes _res;

  call({Input_ValidateSmsCodeInput? input}) => _res;
}

class Mutation_ValidateSmsCode {
  Mutation_ValidateSmsCode({
    required this.validateSmsCode,
    this.$__typename = 'Mutation',
  });

  factory Mutation_ValidateSmsCode.fromJson(Map<String, dynamic> json) {
    final l$validateSmsCode = json['validateSmsCode'];
    final l$$__typename = json['__typename'];
    return Mutation_ValidateSmsCode(
      validateSmsCode: Mutation_ValidateSmsCode_validateSmsCode.fromJson(
        (l$validateSmsCode as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_ValidateSmsCode_validateSmsCode validateSmsCode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$validateSmsCode = validateSmsCode;
    _resultData['validateSmsCode'] = l$validateSmsCode.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$validateSmsCode = validateSmsCode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$validateSmsCode, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_ValidateSmsCode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$validateSmsCode = validateSmsCode;
    final lOther$validateSmsCode = other.validateSmsCode;
    if (l$validateSmsCode != lOther$validateSmsCode) {
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

extension UtilityExtension_Mutation_ValidateSmsCode
    on Mutation_ValidateSmsCode {
  CopyWith_Mutation_ValidateSmsCode<Mutation_ValidateSmsCode> get copyWith =>
      CopyWith_Mutation_ValidateSmsCode(this, (i) => i);
}

abstract class CopyWith_Mutation_ValidateSmsCode<TRes> {
  factory CopyWith_Mutation_ValidateSmsCode(
    Mutation_ValidateSmsCode instance,
    TRes Function(Mutation_ValidateSmsCode) then,
  ) = _CopyWithImpl_Mutation_ValidateSmsCode;

  factory CopyWith_Mutation_ValidateSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Mutation_ValidateSmsCode;

  TRes call({
    Mutation_ValidateSmsCode_validateSmsCode? validateSmsCode,
    String? $__typename,
  });
  CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> get validateSmsCode;
}

class _CopyWithImpl_Mutation_ValidateSmsCode<TRes>
    implements CopyWith_Mutation_ValidateSmsCode<TRes> {
  _CopyWithImpl_Mutation_ValidateSmsCode(this._instance, this._then);

  final Mutation_ValidateSmsCode _instance;

  final TRes Function(Mutation_ValidateSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? validateSmsCode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ValidateSmsCode(
      validateSmsCode: validateSmsCode == _undefined || validateSmsCode == null
          ? _instance.validateSmsCode
          : (validateSmsCode as Mutation_ValidateSmsCode_validateSmsCode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> get validateSmsCode {
    final local$validateSmsCode = _instance.validateSmsCode;
    return CopyWith_Mutation_ValidateSmsCode_validateSmsCode(
      local$validateSmsCode,
      (e) => call(validateSmsCode: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_ValidateSmsCode<TRes>
    implements CopyWith_Mutation_ValidateSmsCode<TRes> {
  _CopyWithStubImpl_Mutation_ValidateSmsCode(this._res);

  TRes _res;

  call({
    Mutation_ValidateSmsCode_validateSmsCode? validateSmsCode,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> get validateSmsCode =>
      CopyWith_Mutation_ValidateSmsCode_validateSmsCode.stub(_res);
}

const documentNodeMutationValidateSmsCode = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ValidateSmsCode'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ValidateSmsCodeInput'),
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
            name: NameNode(value: 'validateSmsCode'),
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
                  name: NameNode(value: 'refreshToken'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'isNewRegistration'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'remainingAttempts'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'retryAfterSeconds'),
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
Mutation_ValidateSmsCode _parserFn_Mutation_ValidateSmsCode(
  Map<String, dynamic> data,
) => Mutation_ValidateSmsCode.fromJson(data);
typedef OnMutationCompleted_Mutation_ValidateSmsCode =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_ValidateSmsCode?);

class Options_Mutation_ValidateSmsCode
    extends graphql.MutationOptions<Mutation_ValidateSmsCode> {
  Options_Mutation_ValidateSmsCode({
    String? operationName,
    required Variables_Mutation_ValidateSmsCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ValidateSmsCode? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ValidateSmsCode? onCompleted,
    graphql.OnMutationUpdate<Mutation_ValidateSmsCode>? update,
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
                 data == null ? null : _parserFn_Mutation_ValidateSmsCode(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationValidateSmsCode,
         parserFn: _parserFn_Mutation_ValidateSmsCode,
       );

  final OnMutationCompleted_Mutation_ValidateSmsCode? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_ValidateSmsCode
    extends graphql.WatchQueryOptions<Mutation_ValidateSmsCode> {
  WatchOptions_Mutation_ValidateSmsCode({
    String? operationName,
    required Variables_Mutation_ValidateSmsCode variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ValidateSmsCode? typedOptimisticResult,
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
         document: documentNodeMutationValidateSmsCode,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_ValidateSmsCode,
       );
}

extension ClientExtension_Mutation_ValidateSmsCode on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_ValidateSmsCode>> mutate_ValidateSmsCode(
    Options_Mutation_ValidateSmsCode options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_ValidateSmsCode>
  watchMutation_ValidateSmsCode(
    WatchOptions_Mutation_ValidateSmsCode options,
  ) => this.watchMutation(options);
}

class Mutation_ValidateSmsCode_HookResult {
  Mutation_ValidateSmsCode_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_ValidateSmsCode runMutation;

  final graphql.QueryResult<Mutation_ValidateSmsCode> result;
}

Mutation_ValidateSmsCode_HookResult useMutation_ValidateSmsCode([
  WidgetOptions_Mutation_ValidateSmsCode? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_ValidateSmsCode(),
  );
  return Mutation_ValidateSmsCode_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_ValidateSmsCode>
useWatchMutation_ValidateSmsCode(
  WatchOptions_Mutation_ValidateSmsCode options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_ValidateSmsCode
    extends graphql.MutationOptions<Mutation_ValidateSmsCode> {
  WidgetOptions_Mutation_ValidateSmsCode({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ValidateSmsCode? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ValidateSmsCode? onCompleted,
    graphql.OnMutationUpdate<Mutation_ValidateSmsCode>? update,
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
                 data == null ? null : _parserFn_Mutation_ValidateSmsCode(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationValidateSmsCode,
         parserFn: _parserFn_Mutation_ValidateSmsCode,
       );

  final OnMutationCompleted_Mutation_ValidateSmsCode? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_ValidateSmsCode =
    graphql.MultiSourceResult<Mutation_ValidateSmsCode> Function(
      Variables_Mutation_ValidateSmsCode, {
      Object? optimisticResult,
      Mutation_ValidateSmsCode? typedOptimisticResult,
    });
typedef Builder_Mutation_ValidateSmsCode =
    widgets.Widget Function(
      RunMutation_Mutation_ValidateSmsCode,
      graphql.QueryResult<Mutation_ValidateSmsCode>?,
    );

class Mutation_ValidateSmsCode_Widget
    extends graphql_flutter.Mutation<Mutation_ValidateSmsCode> {
  Mutation_ValidateSmsCode_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_ValidateSmsCode? options,
    required Builder_Mutation_ValidateSmsCode builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_ValidateSmsCode(),
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

class Mutation_ValidateSmsCode_validateSmsCode {
  Mutation_ValidateSmsCode_validateSmsCode({
    required this.result,
    this.token,
    this.refreshToken,
    required this.isNewRegistration,
    this.remainingAttempts,
    this.retryAfterSeconds,
    this.$__typename = 'ValidateSmsCodePayload',
  });

  factory Mutation_ValidateSmsCode_validateSmsCode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$result = json['result'];
    final l$token = json['token'];
    final l$refreshToken = json['refreshToken'];
    final l$isNewRegistration = json['isNewRegistration'];
    final l$remainingAttempts = json['remainingAttempts'];
    final l$retryAfterSeconds = json['retryAfterSeconds'];
    final l$$__typename = json['__typename'];
    return Mutation_ValidateSmsCode_validateSmsCode(
      result: fromJson_Enum_ValidateCodeResult((l$result as String)),
      token: (l$token as String?),
      refreshToken: (l$refreshToken as String?),
      isNewRegistration: (l$isNewRegistration as bool),
      remainingAttempts: (l$remainingAttempts as int?),
      retryAfterSeconds: (l$retryAfterSeconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum_ValidateCodeResult result;

  final String? token;

  final String? refreshToken;

  final bool isNewRegistration;

  final int? remainingAttempts;

  final int? retryAfterSeconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$result = result;
    _resultData['result'] = toJson_Enum_ValidateCodeResult(l$result);
    final l$token = token;
    _resultData['token'] = l$token;
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken;
    final l$isNewRegistration = isNewRegistration;
    _resultData['isNewRegistration'] = l$isNewRegistration;
    final l$remainingAttempts = remainingAttempts;
    _resultData['remainingAttempts'] = l$remainingAttempts;
    final l$retryAfterSeconds = retryAfterSeconds;
    _resultData['retryAfterSeconds'] = l$retryAfterSeconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$result = result;
    final l$token = token;
    final l$refreshToken = refreshToken;
    final l$isNewRegistration = isNewRegistration;
    final l$remainingAttempts = remainingAttempts;
    final l$retryAfterSeconds = retryAfterSeconds;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$result,
      l$token,
      l$refreshToken,
      l$isNewRegistration,
      l$remainingAttempts,
      l$retryAfterSeconds,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_ValidateSmsCode_validateSmsCode ||
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
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    final l$isNewRegistration = isNewRegistration;
    final lOther$isNewRegistration = other.isNewRegistration;
    if (l$isNewRegistration != lOther$isNewRegistration) {
      return false;
    }
    final l$remainingAttempts = remainingAttempts;
    final lOther$remainingAttempts = other.remainingAttempts;
    if (l$remainingAttempts != lOther$remainingAttempts) {
      return false;
    }
    final l$retryAfterSeconds = retryAfterSeconds;
    final lOther$retryAfterSeconds = other.retryAfterSeconds;
    if (l$retryAfterSeconds != lOther$retryAfterSeconds) {
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

extension UtilityExtension_Mutation_ValidateSmsCode_validateSmsCode
    on Mutation_ValidateSmsCode_validateSmsCode {
  CopyWith_Mutation_ValidateSmsCode_validateSmsCode<
    Mutation_ValidateSmsCode_validateSmsCode
  >
  get copyWith =>
      CopyWith_Mutation_ValidateSmsCode_validateSmsCode(this, (i) => i);
}

abstract class CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> {
  factory CopyWith_Mutation_ValidateSmsCode_validateSmsCode(
    Mutation_ValidateSmsCode_validateSmsCode instance,
    TRes Function(Mutation_ValidateSmsCode_validateSmsCode) then,
  ) = _CopyWithImpl_Mutation_ValidateSmsCode_validateSmsCode;

  factory CopyWith_Mutation_ValidateSmsCode_validateSmsCode.stub(TRes res) =
      _CopyWithStubImpl_Mutation_ValidateSmsCode_validateSmsCode;

  TRes call({
    Enum_ValidateCodeResult? result,
    String? token,
    String? refreshToken,
    bool? isNewRegistration,
    int? remainingAttempts,
    int? retryAfterSeconds,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_ValidateSmsCode_validateSmsCode<TRes>
    implements CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> {
  _CopyWithImpl_Mutation_ValidateSmsCode_validateSmsCode(
    this._instance,
    this._then,
  );

  final Mutation_ValidateSmsCode_validateSmsCode _instance;

  final TRes Function(Mutation_ValidateSmsCode_validateSmsCode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? result = _undefined,
    Object? token = _undefined,
    Object? refreshToken = _undefined,
    Object? isNewRegistration = _undefined,
    Object? remainingAttempts = _undefined,
    Object? retryAfterSeconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ValidateSmsCode_validateSmsCode(
      result: result == _undefined || result == null
          ? _instance.result
          : (result as Enum_ValidateCodeResult),
      token: token == _undefined ? _instance.token : (token as String?),
      refreshToken: refreshToken == _undefined
          ? _instance.refreshToken
          : (refreshToken as String?),
      isNewRegistration:
          isNewRegistration == _undefined || isNewRegistration == null
          ? _instance.isNewRegistration
          : (isNewRegistration as bool),
      remainingAttempts: remainingAttempts == _undefined
          ? _instance.remainingAttempts
          : (remainingAttempts as int?),
      retryAfterSeconds: retryAfterSeconds == _undefined
          ? _instance.retryAfterSeconds
          : (retryAfterSeconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ValidateSmsCode_validateSmsCode<TRes>
    implements CopyWith_Mutation_ValidateSmsCode_validateSmsCode<TRes> {
  _CopyWithStubImpl_Mutation_ValidateSmsCode_validateSmsCode(this._res);

  TRes _res;

  call({
    Enum_ValidateCodeResult? result,
    String? token,
    String? refreshToken,
    bool? isNewRegistration,
    int? remainingAttempts,
    int? retryAfterSeconds,
    String? $__typename,
  }) => _res;
}

class Variables_Mutation_UpdateMyProfile {
  factory Variables_Mutation_UpdateMyProfile({
    required Input_UpdateMyProfileInput input,
  }) => Variables_Mutation_UpdateMyProfile._({r'input': input});

  Variables_Mutation_UpdateMyProfile._(this._$data);

  factory Variables_Mutation_UpdateMyProfile.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_UpdateMyProfileInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_UpdateMyProfile._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_UpdateMyProfileInput get input =>
      (_$data['input'] as Input_UpdateMyProfileInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_UpdateMyProfile<
    Variables_Mutation_UpdateMyProfile
  >
  get copyWith => CopyWith_Variables_Mutation_UpdateMyProfile(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_UpdateMyProfile ||
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

abstract class CopyWith_Variables_Mutation_UpdateMyProfile<TRes> {
  factory CopyWith_Variables_Mutation_UpdateMyProfile(
    Variables_Mutation_UpdateMyProfile instance,
    TRes Function(Variables_Mutation_UpdateMyProfile) then,
  ) = _CopyWithImpl_Variables_Mutation_UpdateMyProfile;

  factory CopyWith_Variables_Mutation_UpdateMyProfile.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_UpdateMyProfile;

  TRes call({Input_UpdateMyProfileInput? input});
}

class _CopyWithImpl_Variables_Mutation_UpdateMyProfile<TRes>
    implements CopyWith_Variables_Mutation_UpdateMyProfile<TRes> {
  _CopyWithImpl_Variables_Mutation_UpdateMyProfile(this._instance, this._then);

  final Variables_Mutation_UpdateMyProfile _instance;

  final TRes Function(Variables_Mutation_UpdateMyProfile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_UpdateMyProfile._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_UpdateMyProfileInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_UpdateMyProfile<TRes>
    implements CopyWith_Variables_Mutation_UpdateMyProfile<TRes> {
  _CopyWithStubImpl_Variables_Mutation_UpdateMyProfile(this._res);

  TRes _res;

  call({Input_UpdateMyProfileInput? input}) => _res;
}

class Mutation_UpdateMyProfile {
  Mutation_UpdateMyProfile({
    required this.updateMyProfile,
    this.$__typename = 'Mutation',
  });

  factory Mutation_UpdateMyProfile.fromJson(Map<String, dynamic> json) {
    final l$updateMyProfile = json['updateMyProfile'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateMyProfile(
      updateMyProfile: Mutation_UpdateMyProfile_updateMyProfile.fromJson(
        (l$updateMyProfile as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdateMyProfile_updateMyProfile updateMyProfile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateMyProfile = updateMyProfile;
    _resultData['updateMyProfile'] = l$updateMyProfile.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateMyProfile = updateMyProfile;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateMyProfile, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdateMyProfile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateMyProfile = updateMyProfile;
    final lOther$updateMyProfile = other.updateMyProfile;
    if (l$updateMyProfile != lOther$updateMyProfile) {
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

extension UtilityExtension_Mutation_UpdateMyProfile
    on Mutation_UpdateMyProfile {
  CopyWith_Mutation_UpdateMyProfile<Mutation_UpdateMyProfile> get copyWith =>
      CopyWith_Mutation_UpdateMyProfile(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdateMyProfile<TRes> {
  factory CopyWith_Mutation_UpdateMyProfile(
    Mutation_UpdateMyProfile instance,
    TRes Function(Mutation_UpdateMyProfile) then,
  ) = _CopyWithImpl_Mutation_UpdateMyProfile;

  factory CopyWith_Mutation_UpdateMyProfile.stub(TRes res) =
      _CopyWithStubImpl_Mutation_UpdateMyProfile;

  TRes call({
    Mutation_UpdateMyProfile_updateMyProfile? updateMyProfile,
    String? $__typename,
  });
  CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> get updateMyProfile;
}

class _CopyWithImpl_Mutation_UpdateMyProfile<TRes>
    implements CopyWith_Mutation_UpdateMyProfile<TRes> {
  _CopyWithImpl_Mutation_UpdateMyProfile(this._instance, this._then);

  final Mutation_UpdateMyProfile _instance;

  final TRes Function(Mutation_UpdateMyProfile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateMyProfile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateMyProfile(
      updateMyProfile: updateMyProfile == _undefined || updateMyProfile == null
          ? _instance.updateMyProfile
          : (updateMyProfile as Mutation_UpdateMyProfile_updateMyProfile),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> get updateMyProfile {
    final local$updateMyProfile = _instance.updateMyProfile;
    return CopyWith_Mutation_UpdateMyProfile_updateMyProfile(
      local$updateMyProfile,
      (e) => call(updateMyProfile: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_UpdateMyProfile<TRes>
    implements CopyWith_Mutation_UpdateMyProfile<TRes> {
  _CopyWithStubImpl_Mutation_UpdateMyProfile(this._res);

  TRes _res;

  call({
    Mutation_UpdateMyProfile_updateMyProfile? updateMyProfile,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> get updateMyProfile =>
      CopyWith_Mutation_UpdateMyProfile_updateMyProfile.stub(_res);
}

const documentNodeMutationUpdateMyProfile = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateMyProfile'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateMyProfileInput'),
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
            name: NameNode(value: 'updateMyProfile'),
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
Mutation_UpdateMyProfile _parserFn_Mutation_UpdateMyProfile(
  Map<String, dynamic> data,
) => Mutation_UpdateMyProfile.fromJson(data);
typedef OnMutationCompleted_Mutation_UpdateMyProfile =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_UpdateMyProfile?);

class Options_Mutation_UpdateMyProfile
    extends graphql.MutationOptions<Mutation_UpdateMyProfile> {
  Options_Mutation_UpdateMyProfile({
    String? operationName,
    required Variables_Mutation_UpdateMyProfile variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateMyProfile? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateMyProfile? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateMyProfile>? update,
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
                 data == null ? null : _parserFn_Mutation_UpdateMyProfile(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateMyProfile,
         parserFn: _parserFn_Mutation_UpdateMyProfile,
       );

  final OnMutationCompleted_Mutation_UpdateMyProfile? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_UpdateMyProfile
    extends graphql.WatchQueryOptions<Mutation_UpdateMyProfile> {
  WatchOptions_Mutation_UpdateMyProfile({
    String? operationName,
    required Variables_Mutation_UpdateMyProfile variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateMyProfile? typedOptimisticResult,
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
         document: documentNodeMutationUpdateMyProfile,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_UpdateMyProfile,
       );
}

extension ClientExtension_Mutation_UpdateMyProfile on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_UpdateMyProfile>> mutate_UpdateMyProfile(
    Options_Mutation_UpdateMyProfile options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_UpdateMyProfile>
  watchMutation_UpdateMyProfile(
    WatchOptions_Mutation_UpdateMyProfile options,
  ) => this.watchMutation(options);
}

class Mutation_UpdateMyProfile_HookResult {
  Mutation_UpdateMyProfile_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_UpdateMyProfile runMutation;

  final graphql.QueryResult<Mutation_UpdateMyProfile> result;
}

Mutation_UpdateMyProfile_HookResult useMutation_UpdateMyProfile([
  WidgetOptions_Mutation_UpdateMyProfile? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_UpdateMyProfile(),
  );
  return Mutation_UpdateMyProfile_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_UpdateMyProfile>
useWatchMutation_UpdateMyProfile(
  WatchOptions_Mutation_UpdateMyProfile options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_UpdateMyProfile
    extends graphql.MutationOptions<Mutation_UpdateMyProfile> {
  WidgetOptions_Mutation_UpdateMyProfile({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateMyProfile? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateMyProfile? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateMyProfile>? update,
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
                 data == null ? null : _parserFn_Mutation_UpdateMyProfile(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateMyProfile,
         parserFn: _parserFn_Mutation_UpdateMyProfile,
       );

  final OnMutationCompleted_Mutation_UpdateMyProfile? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_UpdateMyProfile =
    graphql.MultiSourceResult<Mutation_UpdateMyProfile> Function(
      Variables_Mutation_UpdateMyProfile, {
      Object? optimisticResult,
      Mutation_UpdateMyProfile? typedOptimisticResult,
    });
typedef Builder_Mutation_UpdateMyProfile =
    widgets.Widget Function(
      RunMutation_Mutation_UpdateMyProfile,
      graphql.QueryResult<Mutation_UpdateMyProfile>?,
    );

class Mutation_UpdateMyProfile_Widget
    extends graphql_flutter.Mutation<Mutation_UpdateMyProfile> {
  Mutation_UpdateMyProfile_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_UpdateMyProfile? options,
    required Builder_Mutation_UpdateMyProfile builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_UpdateMyProfile(),
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

class Mutation_UpdateMyProfile_updateMyProfile {
  Mutation_UpdateMyProfile_updateMyProfile({
    this.boolean,
    this.$__typename = 'UpdateMyProfilePayload',
  });

  factory Mutation_UpdateMyProfile_updateMyProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$boolean = json['boolean'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateMyProfile_updateMyProfile(
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
    if (other is! Mutation_UpdateMyProfile_updateMyProfile ||
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

extension UtilityExtension_Mutation_UpdateMyProfile_updateMyProfile
    on Mutation_UpdateMyProfile_updateMyProfile {
  CopyWith_Mutation_UpdateMyProfile_updateMyProfile<
    Mutation_UpdateMyProfile_updateMyProfile
  >
  get copyWith =>
      CopyWith_Mutation_UpdateMyProfile_updateMyProfile(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> {
  factory CopyWith_Mutation_UpdateMyProfile_updateMyProfile(
    Mutation_UpdateMyProfile_updateMyProfile instance,
    TRes Function(Mutation_UpdateMyProfile_updateMyProfile) then,
  ) = _CopyWithImpl_Mutation_UpdateMyProfile_updateMyProfile;

  factory CopyWith_Mutation_UpdateMyProfile_updateMyProfile.stub(TRes res) =
      _CopyWithStubImpl_Mutation_UpdateMyProfile_updateMyProfile;

  TRes call({bool? boolean, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateMyProfile_updateMyProfile<TRes>
    implements CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> {
  _CopyWithImpl_Mutation_UpdateMyProfile_updateMyProfile(
    this._instance,
    this._then,
  );

  final Mutation_UpdateMyProfile_updateMyProfile _instance;

  final TRes Function(Mutation_UpdateMyProfile_updateMyProfile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? boolean = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_UpdateMyProfile_updateMyProfile(
          boolean: boolean == _undefined
              ? _instance.boolean
              : (boolean as bool?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Mutation_UpdateMyProfile_updateMyProfile<TRes>
    implements CopyWith_Mutation_UpdateMyProfile_updateMyProfile<TRes> {
  _CopyWithStubImpl_Mutation_UpdateMyProfile_updateMyProfile(this._res);

  TRes _res;

  call({bool? boolean, String? $__typename}) => _res;
}

class Query_MyProfile {
  Query_MyProfile({required this.my, this.$__typename = 'Query'});

  factory Query_MyProfile.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_MyProfile(
      my: Query_MyProfile_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyProfile_my my;

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
    if (other is! Query_MyProfile || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyProfile on Query_MyProfile {
  CopyWith_Query_MyProfile<Query_MyProfile> get copyWith =>
      CopyWith_Query_MyProfile(this, (i) => i);
}

abstract class CopyWith_Query_MyProfile<TRes> {
  factory CopyWith_Query_MyProfile(
    Query_MyProfile instance,
    TRes Function(Query_MyProfile) then,
  ) = _CopyWithImpl_Query_MyProfile;

  factory CopyWith_Query_MyProfile.stub(TRes res) =
      _CopyWithStubImpl_Query_MyProfile;

  TRes call({Query_MyProfile_my? my, String? $__typename});
  CopyWith_Query_MyProfile_my<TRes> get my;
}

class _CopyWithImpl_Query_MyProfile<TRes>
    implements CopyWith_Query_MyProfile<TRes> {
  _CopyWithImpl_Query_MyProfile(this._instance, this._then);

  final Query_MyProfile _instance;

  final TRes Function(Query_MyProfile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyProfile(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_MyProfile_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MyProfile_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_MyProfile_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_MyProfile<TRes>
    implements CopyWith_Query_MyProfile<TRes> {
  _CopyWithStubImpl_Query_MyProfile(this._res);

  TRes _res;

  call({Query_MyProfile_my? my, String? $__typename}) => _res;

  CopyWith_Query_MyProfile_my<TRes> get my =>
      CopyWith_Query_MyProfile_my.stub(_res);
}

const documentNodeQueryMyProfile = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyProfile'),
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
                        name: NameNode(value: 'vorname'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'nachname'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'emailAddress'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'street'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'postalCode'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'city'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'country'),
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
                        name: NameNode(value: 'phoneNumberMasked'),
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
  ],
);
Query_MyProfile _parserFn_Query_MyProfile(Map<String, dynamic> data) =>
    Query_MyProfile.fromJson(data);
typedef OnQueryComplete_Query_MyProfile =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MyProfile?);

class Options_Query_MyProfile extends graphql.QueryOptions<Query_MyProfile> {
  Options_Query_MyProfile({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyProfile? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyProfile? onComplete,
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
                 data == null ? null : _parserFn_Query_MyProfile(data),
               ),
         onError: onError,
         document: documentNodeQueryMyProfile,
         parserFn: _parserFn_Query_MyProfile,
       );

  final OnQueryComplete_Query_MyProfile? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyProfile
    extends graphql.WatchQueryOptions<Query_MyProfile> {
  WatchOptions_Query_MyProfile({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyProfile? typedOptimisticResult,
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
         document: documentNodeQueryMyProfile,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyProfile,
       );
}

class FetchMoreOptions_Query_MyProfile extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyProfile({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryMyProfile);
}

extension ClientExtension_Query_MyProfile on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyProfile>> query_MyProfile([
    Options_Query_MyProfile? options,
  ]) async => await this.query(options ?? Options_Query_MyProfile());

  graphql.ObservableQuery<Query_MyProfile> watchQuery_MyProfile([
    WatchOptions_Query_MyProfile? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MyProfile());

  void writeQuery_MyProfile({
    required Query_MyProfile data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMyProfile),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyProfile? readQuery_MyProfile({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMyProfile),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyProfile.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyProfile> useQuery_MyProfile([
  Options_Query_MyProfile? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_MyProfile());
graphql.ObservableQuery<Query_MyProfile> useWatchQuery_MyProfile([
  WatchOptions_Query_MyProfile? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_MyProfile());

class Query_MyProfile_Widget extends graphql_flutter.Query<Query_MyProfile> {
  Query_MyProfile_Widget({
    widgets.Key? key,
    Options_Query_MyProfile? options,
    required graphql_flutter.QueryBuilder<Query_MyProfile> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MyProfile(),
         builder: builder,
       );
}

class Query_MyProfile_my {
  Query_MyProfile_my({required this.id, required this.$__typename});

  factory Query_MyProfile_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_MyProfile_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_MyProfile_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_MyProfile_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        return Query_MyProfile_my(
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
    if (other is! Query_MyProfile_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MyProfile_my on Query_MyProfile_my {
  CopyWith_Query_MyProfile_my<Query_MyProfile_my> get copyWith =>
      CopyWith_Query_MyProfile_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_MyProfile_my__Buerger) buerger,
    required _T Function(Query_MyProfile_my__BackofficeUser) backofficeUser,
    required _T Function(Query_MyProfile_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_MyProfile_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_MyProfile_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_MyProfile_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_MyProfile_my__Buerger)? buerger,
    _T Function(Query_MyProfile_my__BackofficeUser)? backofficeUser,
    _T Function(Query_MyProfile_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_MyProfile_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(this as Query_MyProfile_my__BackofficeUser);
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_MyProfile_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_MyProfile_my<TRes> {
  factory CopyWith_Query_MyProfile_my(
    Query_MyProfile_my instance,
    TRes Function(Query_MyProfile_my) then,
  ) = _CopyWithImpl_Query_MyProfile_my;

  factory CopyWith_Query_MyProfile_my.stub(TRes res) =
      _CopyWithStubImpl_Query_MyProfile_my;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyProfile_my<TRes>
    implements CopyWith_Query_MyProfile_my<TRes> {
  _CopyWithImpl_Query_MyProfile_my(this._instance, this._then);

  final Query_MyProfile_my _instance;

  final TRes Function(Query_MyProfile_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyProfile_my(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyProfile_my<TRes>
    implements CopyWith_Query_MyProfile_my<TRes> {
  _CopyWithStubImpl_Query_MyProfile_my(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyProfile_my__Buerger implements Query_MyProfile_my {
  Query_MyProfile_my__Buerger({
    this.vorname,
    this.nachname,
    this.emailAddress,
    this.street,
    this.postalCode,
    this.city,
    this.country,
    required this.phoneVerified,
    this.phoneNumberMasked,
    required this.hasBundId,
    this.$__typename = 'Buerger',
    required this.id,
  });

  factory Query_MyProfile_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$vorname = json['vorname'];
    final l$nachname = json['nachname'];
    final l$emailAddress = json['emailAddress'];
    final l$street = json['street'];
    final l$postalCode = json['postalCode'];
    final l$city = json['city'];
    final l$country = json['country'];
    final l$phoneVerified = json['phoneVerified'];
    final l$phoneNumberMasked = json['phoneNumberMasked'];
    final l$hasBundId = json['hasBundId'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query_MyProfile_my__Buerger(
      vorname: (l$vorname as String?),
      nachname: (l$nachname as String?),
      emailAddress: (l$emailAddress as String?),
      street: (l$street as String?),
      postalCode: (l$postalCode as String?),
      city: (l$city as String?),
      country: (l$country as String?),
      phoneVerified: (l$phoneVerified as bool),
      phoneNumberMasked: (l$phoneNumberMasked as String?),
      hasBundId: (l$hasBundId as bool),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final String? vorname;

  final String? nachname;

  final String? emailAddress;

  final String? street;

  final String? postalCode;

  final String? city;

  final String? country;

  final bool phoneVerified;

  final String? phoneNumberMasked;

  final bool hasBundId;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$vorname = vorname;
    _resultData['vorname'] = l$vorname;
    final l$nachname = nachname;
    _resultData['nachname'] = l$nachname;
    final l$emailAddress = emailAddress;
    _resultData['emailAddress'] = l$emailAddress;
    final l$street = street;
    _resultData['street'] = l$street;
    final l$postalCode = postalCode;
    _resultData['postalCode'] = l$postalCode;
    final l$city = city;
    _resultData['city'] = l$city;
    final l$country = country;
    _resultData['country'] = l$country;
    final l$phoneVerified = phoneVerified;
    _resultData['phoneVerified'] = l$phoneVerified;
    final l$phoneNumberMasked = phoneNumberMasked;
    _resultData['phoneNumberMasked'] = l$phoneNumberMasked;
    final l$hasBundId = hasBundId;
    _resultData['hasBundId'] = l$hasBundId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$vorname = vorname;
    final l$nachname = nachname;
    final l$emailAddress = emailAddress;
    final l$street = street;
    final l$postalCode = postalCode;
    final l$city = city;
    final l$country = country;
    final l$phoneVerified = phoneVerified;
    final l$phoneNumberMasked = phoneNumberMasked;
    final l$hasBundId = hasBundId;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      l$vorname,
      l$nachname,
      l$emailAddress,
      l$street,
      l$postalCode,
      l$city,
      l$country,
      l$phoneVerified,
      l$phoneNumberMasked,
      l$hasBundId,
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyProfile_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$vorname = vorname;
    final lOther$vorname = other.vorname;
    if (l$vorname != lOther$vorname) {
      return false;
    }
    final l$nachname = nachname;
    final lOther$nachname = other.nachname;
    if (l$nachname != lOther$nachname) {
      return false;
    }
    final l$emailAddress = emailAddress;
    final lOther$emailAddress = other.emailAddress;
    if (l$emailAddress != lOther$emailAddress) {
      return false;
    }
    final l$street = street;
    final lOther$street = other.street;
    if (l$street != lOther$street) {
      return false;
    }
    final l$postalCode = postalCode;
    final lOther$postalCode = other.postalCode;
    if (l$postalCode != lOther$postalCode) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (l$city != lOther$city) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$phoneVerified = phoneVerified;
    final lOther$phoneVerified = other.phoneVerified;
    if (l$phoneVerified != lOther$phoneVerified) {
      return false;
    }
    final l$phoneNumberMasked = phoneNumberMasked;
    final lOther$phoneNumberMasked = other.phoneNumberMasked;
    if (l$phoneNumberMasked != lOther$phoneNumberMasked) {
      return false;
    }
    final l$hasBundId = hasBundId;
    final lOther$hasBundId = other.hasBundId;
    if (l$hasBundId != lOther$hasBundId) {
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
    return true;
  }
}

extension UtilityExtension_Query_MyProfile_my__Buerger
    on Query_MyProfile_my__Buerger {
  CopyWith_Query_MyProfile_my__Buerger<Query_MyProfile_my__Buerger>
  get copyWith => CopyWith_Query_MyProfile_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_MyProfile_my__Buerger<TRes> {
  factory CopyWith_Query_MyProfile_my__Buerger(
    Query_MyProfile_my__Buerger instance,
    TRes Function(Query_MyProfile_my__Buerger) then,
  ) = _CopyWithImpl_Query_MyProfile_my__Buerger;

  factory CopyWith_Query_MyProfile_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_MyProfile_my__Buerger;

  TRes call({
    String? vorname,
    String? nachname,
    String? emailAddress,
    String? street,
    String? postalCode,
    String? city,
    String? country,
    bool? phoneVerified,
    String? phoneNumberMasked,
    bool? hasBundId,
    String? $__typename,
    String? id,
  });
}

class _CopyWithImpl_Query_MyProfile_my__Buerger<TRes>
    implements CopyWith_Query_MyProfile_my__Buerger<TRes> {
  _CopyWithImpl_Query_MyProfile_my__Buerger(this._instance, this._then);

  final Query_MyProfile_my__Buerger _instance;

  final TRes Function(Query_MyProfile_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? vorname = _undefined,
    Object? nachname = _undefined,
    Object? emailAddress = _undefined,
    Object? street = _undefined,
    Object? postalCode = _undefined,
    Object? city = _undefined,
    Object? country = _undefined,
    Object? phoneVerified = _undefined,
    Object? phoneNumberMasked = _undefined,
    Object? hasBundId = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) => _then(
    Query_MyProfile_my__Buerger(
      vorname: vorname == _undefined ? _instance.vorname : (vorname as String?),
      nachname: nachname == _undefined
          ? _instance.nachname
          : (nachname as String?),
      emailAddress: emailAddress == _undefined
          ? _instance.emailAddress
          : (emailAddress as String?),
      street: street == _undefined ? _instance.street : (street as String?),
      postalCode: postalCode == _undefined
          ? _instance.postalCode
          : (postalCode as String?),
      city: city == _undefined ? _instance.city : (city as String?),
      country: country == _undefined ? _instance.country : (country as String?),
      phoneVerified: phoneVerified == _undefined || phoneVerified == null
          ? _instance.phoneVerified
          : (phoneVerified as bool),
      phoneNumberMasked: phoneNumberMasked == _undefined
          ? _instance.phoneNumberMasked
          : (phoneNumberMasked as String?),
      hasBundId: hasBundId == _undefined || hasBundId == null
          ? _instance.hasBundId
          : (hasBundId as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyProfile_my__Buerger<TRes>
    implements CopyWith_Query_MyProfile_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_MyProfile_my__Buerger(this._res);

  TRes _res;

  call({
    String? vorname,
    String? nachname,
    String? emailAddress,
    String? street,
    String? postalCode,
    String? city,
    String? country,
    bool? phoneVerified,
    String? phoneNumberMasked,
    bool? hasBundId,
    String? $__typename,
    String? id,
  }) => _res;
}

class Query_MyProfile_my__BackofficeUser implements Query_MyProfile_my {
  Query_MyProfile_my__BackofficeUser({
    required this.id,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_MyProfile_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyProfile_my__BackofficeUser(
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
    if (other is! Query_MyProfile_my__BackofficeUser ||
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

extension UtilityExtension_Query_MyProfile_my__BackofficeUser
    on Query_MyProfile_my__BackofficeUser {
  CopyWith_Query_MyProfile_my__BackofficeUser<
    Query_MyProfile_my__BackofficeUser
  >
  get copyWith => CopyWith_Query_MyProfile_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_MyProfile_my__BackofficeUser<TRes> {
  factory CopyWith_Query_MyProfile_my__BackofficeUser(
    Query_MyProfile_my__BackofficeUser instance,
    TRes Function(Query_MyProfile_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_MyProfile_my__BackofficeUser;

  factory CopyWith_Query_MyProfile_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyProfile_my__BackofficeUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyProfile_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyProfile_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_MyProfile_my__BackofficeUser(this._instance, this._then);

  final Query_MyProfile_my__BackofficeUser _instance;

  final TRes Function(Query_MyProfile_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyProfile_my__BackofficeUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyProfile_my__BackofficeUser<TRes>
    implements CopyWith_Query_MyProfile_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_MyProfile_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MyProfile_my__SystemUser implements Query_MyProfile_my {
  Query_MyProfile_my__SystemUser({
    required this.id,
    this.$__typename = 'SystemUser',
  });

  factory Query_MyProfile_my__SystemUser.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MyProfile_my__SystemUser(
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
    if (other is! Query_MyProfile_my__SystemUser ||
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

extension UtilityExtension_Query_MyProfile_my__SystemUser
    on Query_MyProfile_my__SystemUser {
  CopyWith_Query_MyProfile_my__SystemUser<Query_MyProfile_my__SystemUser>
  get copyWith => CopyWith_Query_MyProfile_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_MyProfile_my__SystemUser<TRes> {
  factory CopyWith_Query_MyProfile_my__SystemUser(
    Query_MyProfile_my__SystemUser instance,
    TRes Function(Query_MyProfile_my__SystemUser) then,
  ) = _CopyWithImpl_Query_MyProfile_my__SystemUser;

  factory CopyWith_Query_MyProfile_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MyProfile_my__SystemUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MyProfile_my__SystemUser<TRes>
    implements CopyWith_Query_MyProfile_my__SystemUser<TRes> {
  _CopyWithImpl_Query_MyProfile_my__SystemUser(this._instance, this._then);

  final Query_MyProfile_my__SystemUser _instance;

  final TRes Function(Query_MyProfile_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MyProfile_my__SystemUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MyProfile_my__SystemUser<TRes>
    implements CopyWith_Query_MyProfile_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_MyProfile_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Mutation_LogoutAllDevices {
  Mutation_LogoutAllDevices({
    required this.logoutAllDevices,
    this.$__typename = 'Mutation',
  });

  factory Mutation_LogoutAllDevices.fromJson(Map<String, dynamic> json) {
    final l$logoutAllDevices = json['logoutAllDevices'];
    final l$$__typename = json['__typename'];
    return Mutation_LogoutAllDevices(
      logoutAllDevices: Mutation_LogoutAllDevices_logoutAllDevices.fromJson(
        (l$logoutAllDevices as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_LogoutAllDevices_logoutAllDevices logoutAllDevices;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$logoutAllDevices = logoutAllDevices;
    _resultData['logoutAllDevices'] = l$logoutAllDevices.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$logoutAllDevices = logoutAllDevices;
    final l$$__typename = $__typename;
    return Object.hashAll([l$logoutAllDevices, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_LogoutAllDevices ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$logoutAllDevices = logoutAllDevices;
    final lOther$logoutAllDevices = other.logoutAllDevices;
    if (l$logoutAllDevices != lOther$logoutAllDevices) {
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

extension UtilityExtension_Mutation_LogoutAllDevices
    on Mutation_LogoutAllDevices {
  CopyWith_Mutation_LogoutAllDevices<Mutation_LogoutAllDevices> get copyWith =>
      CopyWith_Mutation_LogoutAllDevices(this, (i) => i);
}

abstract class CopyWith_Mutation_LogoutAllDevices<TRes> {
  factory CopyWith_Mutation_LogoutAllDevices(
    Mutation_LogoutAllDevices instance,
    TRes Function(Mutation_LogoutAllDevices) then,
  ) = _CopyWithImpl_Mutation_LogoutAllDevices;

  factory CopyWith_Mutation_LogoutAllDevices.stub(TRes res) =
      _CopyWithStubImpl_Mutation_LogoutAllDevices;

  TRes call({
    Mutation_LogoutAllDevices_logoutAllDevices? logoutAllDevices,
    String? $__typename,
  });
  CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes>
  get logoutAllDevices;
}

class _CopyWithImpl_Mutation_LogoutAllDevices<TRes>
    implements CopyWith_Mutation_LogoutAllDevices<TRes> {
  _CopyWithImpl_Mutation_LogoutAllDevices(this._instance, this._then);

  final Mutation_LogoutAllDevices _instance;

  final TRes Function(Mutation_LogoutAllDevices) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? logoutAllDevices = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_LogoutAllDevices(
      logoutAllDevices:
          logoutAllDevices == _undefined || logoutAllDevices == null
          ? _instance.logoutAllDevices
          : (logoutAllDevices as Mutation_LogoutAllDevices_logoutAllDevices),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes>
  get logoutAllDevices {
    final local$logoutAllDevices = _instance.logoutAllDevices;
    return CopyWith_Mutation_LogoutAllDevices_logoutAllDevices(
      local$logoutAllDevices,
      (e) => call(logoutAllDevices: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_LogoutAllDevices<TRes>
    implements CopyWith_Mutation_LogoutAllDevices<TRes> {
  _CopyWithStubImpl_Mutation_LogoutAllDevices(this._res);

  TRes _res;

  call({
    Mutation_LogoutAllDevices_logoutAllDevices? logoutAllDevices,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes>
  get logoutAllDevices =>
      CopyWith_Mutation_LogoutAllDevices_logoutAllDevices.stub(_res);
}

const documentNodeMutationLogoutAllDevices = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'LogoutAllDevices'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'logoutAllDevices'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'logoutAllDevicesResult'),
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
Mutation_LogoutAllDevices _parserFn_Mutation_LogoutAllDevices(
  Map<String, dynamic> data,
) => Mutation_LogoutAllDevices.fromJson(data);
typedef OnMutationCompleted_Mutation_LogoutAllDevices =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_LogoutAllDevices?);

class Options_Mutation_LogoutAllDevices
    extends graphql.MutationOptions<Mutation_LogoutAllDevices> {
  Options_Mutation_LogoutAllDevices({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_LogoutAllDevices? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_LogoutAllDevices? onCompleted,
    graphql.OnMutationUpdate<Mutation_LogoutAllDevices>? update,
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
                     : _parserFn_Mutation_LogoutAllDevices(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationLogoutAllDevices,
         parserFn: _parserFn_Mutation_LogoutAllDevices,
       );

  final OnMutationCompleted_Mutation_LogoutAllDevices? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_LogoutAllDevices
    extends graphql.WatchQueryOptions<Mutation_LogoutAllDevices> {
  WatchOptions_Mutation_LogoutAllDevices({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_LogoutAllDevices? typedOptimisticResult,
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
         document: documentNodeMutationLogoutAllDevices,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_LogoutAllDevices,
       );
}

extension ClientExtension_Mutation_LogoutAllDevices on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_LogoutAllDevices>>
  mutate_LogoutAllDevices([Options_Mutation_LogoutAllDevices? options]) async =>
      await this.mutate(options ?? Options_Mutation_LogoutAllDevices());

  graphql.ObservableQuery<Mutation_LogoutAllDevices>
  watchMutation_LogoutAllDevices([
    WatchOptions_Mutation_LogoutAllDevices? options,
  ]) => this.watchMutation(options ?? WatchOptions_Mutation_LogoutAllDevices());
}

class Mutation_LogoutAllDevices_HookResult {
  Mutation_LogoutAllDevices_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_LogoutAllDevices runMutation;

  final graphql.QueryResult<Mutation_LogoutAllDevices> result;
}

Mutation_LogoutAllDevices_HookResult useMutation_LogoutAllDevices([
  WidgetOptions_Mutation_LogoutAllDevices? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_LogoutAllDevices(),
  );
  return Mutation_LogoutAllDevices_HookResult(
    ({optimisticResult, typedOptimisticResult}) => result.runMutation(
      const {},
      optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
    ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_LogoutAllDevices>
useWatchMutation_LogoutAllDevices([
  WatchOptions_Mutation_LogoutAllDevices? options,
]) => graphql_flutter.useWatchMutation(
  options ?? WatchOptions_Mutation_LogoutAllDevices(),
);

class WidgetOptions_Mutation_LogoutAllDevices
    extends graphql.MutationOptions<Mutation_LogoutAllDevices> {
  WidgetOptions_Mutation_LogoutAllDevices({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_LogoutAllDevices? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_LogoutAllDevices? onCompleted,
    graphql.OnMutationUpdate<Mutation_LogoutAllDevices>? update,
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
                     : _parserFn_Mutation_LogoutAllDevices(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationLogoutAllDevices,
         parserFn: _parserFn_Mutation_LogoutAllDevices,
       );

  final OnMutationCompleted_Mutation_LogoutAllDevices? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_LogoutAllDevices =
    graphql.MultiSourceResult<Mutation_LogoutAllDevices> Function({
      Object? optimisticResult,
      Mutation_LogoutAllDevices? typedOptimisticResult,
    });
typedef Builder_Mutation_LogoutAllDevices =
    widgets.Widget Function(
      RunMutation_Mutation_LogoutAllDevices,
      graphql.QueryResult<Mutation_LogoutAllDevices>?,
    );

class Mutation_LogoutAllDevices_Widget
    extends graphql_flutter.Mutation<Mutation_LogoutAllDevices> {
  Mutation_LogoutAllDevices_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_LogoutAllDevices? options,
    required Builder_Mutation_LogoutAllDevices builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_LogoutAllDevices(),
         builder: (run, result) => builder(
           ({optimisticResult, typedOptimisticResult}) => run(
             const {},
             optimisticResult:
                 optimisticResult ?? typedOptimisticResult?.toJson(),
           ),
           result,
         ),
       );
}

class Mutation_LogoutAllDevices_logoutAllDevices {
  Mutation_LogoutAllDevices_logoutAllDevices({
    this.logoutAllDevicesResult,
    this.$__typename = 'LogoutAllDevicesPayload',
  });

  factory Mutation_LogoutAllDevices_logoutAllDevices.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$logoutAllDevicesResult = json['logoutAllDevicesResult'];
    final l$$__typename = json['__typename'];
    return Mutation_LogoutAllDevices_logoutAllDevices(
      logoutAllDevicesResult: l$logoutAllDevicesResult == null
          ? null
          : fromJson_Enum_LogoutAllDevicesResult(
              (l$logoutAllDevicesResult as String),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum_LogoutAllDevicesResult? logoutAllDevicesResult;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$logoutAllDevicesResult = logoutAllDevicesResult;
    _resultData['logoutAllDevicesResult'] = l$logoutAllDevicesResult == null
        ? null
        : toJson_Enum_LogoutAllDevicesResult(l$logoutAllDevicesResult);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$logoutAllDevicesResult = logoutAllDevicesResult;
    final l$$__typename = $__typename;
    return Object.hashAll([l$logoutAllDevicesResult, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_LogoutAllDevices_logoutAllDevices ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$logoutAllDevicesResult = logoutAllDevicesResult;
    final lOther$logoutAllDevicesResult = other.logoutAllDevicesResult;
    if (l$logoutAllDevicesResult != lOther$logoutAllDevicesResult) {
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

extension UtilityExtension_Mutation_LogoutAllDevices_logoutAllDevices
    on Mutation_LogoutAllDevices_logoutAllDevices {
  CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<
    Mutation_LogoutAllDevices_logoutAllDevices
  >
  get copyWith =>
      CopyWith_Mutation_LogoutAllDevices_logoutAllDevices(this, (i) => i);
}

abstract class CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes> {
  factory CopyWith_Mutation_LogoutAllDevices_logoutAllDevices(
    Mutation_LogoutAllDevices_logoutAllDevices instance,
    TRes Function(Mutation_LogoutAllDevices_logoutAllDevices) then,
  ) = _CopyWithImpl_Mutation_LogoutAllDevices_logoutAllDevices;

  factory CopyWith_Mutation_LogoutAllDevices_logoutAllDevices.stub(TRes res) =
      _CopyWithStubImpl_Mutation_LogoutAllDevices_logoutAllDevices;

  TRes call({
    Enum_LogoutAllDevicesResult? logoutAllDevicesResult,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_LogoutAllDevices_logoutAllDevices<TRes>
    implements CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes> {
  _CopyWithImpl_Mutation_LogoutAllDevices_logoutAllDevices(
    this._instance,
    this._then,
  );

  final Mutation_LogoutAllDevices_logoutAllDevices _instance;

  final TRes Function(Mutation_LogoutAllDevices_logoutAllDevices) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? logoutAllDevicesResult = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_LogoutAllDevices_logoutAllDevices(
      logoutAllDevicesResult: logoutAllDevicesResult == _undefined
          ? _instance.logoutAllDevicesResult
          : (logoutAllDevicesResult as Enum_LogoutAllDevicesResult?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_LogoutAllDevices_logoutAllDevices<TRes>
    implements CopyWith_Mutation_LogoutAllDevices_logoutAllDevices<TRes> {
  _CopyWithStubImpl_Mutation_LogoutAllDevices_logoutAllDevices(this._res);

  TRes _res;

  call({
    Enum_LogoutAllDevicesResult? logoutAllDevicesResult,
    String? $__typename,
  }) => _res;
}
