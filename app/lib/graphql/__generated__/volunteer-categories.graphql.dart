import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Query_VolunteerCategories {
  Query_VolunteerCategories({
    required this.ehrenamtsbankKategorien,
    this.$__typename = 'Query',
  });

  factory Query_VolunteerCategories.fromJson(Map<String, dynamic> json) {
    final l$ehrenamtsbankKategorien = json['ehrenamtsbankKategorien'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerCategories(
      ehrenamtsbankKategorien: (l$ehrenamtsbankKategorien as List<dynamic>)
          .map(
            (e) => Query_VolunteerCategories_ehrenamtsbankKategorien.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_VolunteerCategories_ehrenamtsbankKategorien>
  ehrenamtsbankKategorien;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankKategorien = ehrenamtsbankKategorien;
    _resultData['ehrenamtsbankKategorien'] = l$ehrenamtsbankKategorien
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankKategorien = ehrenamtsbankKategorien;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$ehrenamtsbankKategorien.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VolunteerCategories ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankKategorien = ehrenamtsbankKategorien;
    final lOther$ehrenamtsbankKategorien = other.ehrenamtsbankKategorien;
    if (l$ehrenamtsbankKategorien.length !=
        lOther$ehrenamtsbankKategorien.length) {
      return false;
    }
    for (int i = 0; i < l$ehrenamtsbankKategorien.length; i++) {
      final l$ehrenamtsbankKategorien$entry = l$ehrenamtsbankKategorien[i];
      final lOther$ehrenamtsbankKategorien$entry =
          lOther$ehrenamtsbankKategorien[i];
      if (l$ehrenamtsbankKategorien$entry !=
          lOther$ehrenamtsbankKategorien$entry) {
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

extension UtilityExtension_Query_VolunteerCategories
    on Query_VolunteerCategories {
  CopyWith_Query_VolunteerCategories<Query_VolunteerCategories> get copyWith =>
      CopyWith_Query_VolunteerCategories(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerCategories<TRes> {
  factory CopyWith_Query_VolunteerCategories(
    Query_VolunteerCategories instance,
    TRes Function(Query_VolunteerCategories) then,
  ) = _CopyWithImpl_Query_VolunteerCategories;

  factory CopyWith_Query_VolunteerCategories.stub(TRes res) =
      _CopyWithStubImpl_Query_VolunteerCategories;

  TRes call({
    List<Query_VolunteerCategories_ehrenamtsbankKategorien>?
    ehrenamtsbankKategorien,
    String? $__typename,
  });
  TRes ehrenamtsbankKategorien(
    Iterable<Query_VolunteerCategories_ehrenamtsbankKategorien> Function(
      Iterable<
        CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<
          Query_VolunteerCategories_ehrenamtsbankKategorien
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VolunteerCategories<TRes>
    implements CopyWith_Query_VolunteerCategories<TRes> {
  _CopyWithImpl_Query_VolunteerCategories(this._instance, this._then);

  final Query_VolunteerCategories _instance;

  final TRes Function(Query_VolunteerCategories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankKategorien = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerCategories(
      ehrenamtsbankKategorien:
          ehrenamtsbankKategorien == _undefined ||
              ehrenamtsbankKategorien == null
          ? _instance.ehrenamtsbankKategorien
          : (ehrenamtsbankKategorien
                as List<Query_VolunteerCategories_ehrenamtsbankKategorien>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes ehrenamtsbankKategorien(
    Iterable<Query_VolunteerCategories_ehrenamtsbankKategorien> Function(
      Iterable<
        CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<
          Query_VolunteerCategories_ehrenamtsbankKategorien
        >
      >,
    )
    _fn,
  ) => call(
    ehrenamtsbankKategorien: _fn(
      _instance.ehrenamtsbankKategorien.map(
        (e) => CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_VolunteerCategories<TRes>
    implements CopyWith_Query_VolunteerCategories<TRes> {
  _CopyWithStubImpl_Query_VolunteerCategories(this._res);

  TRes _res;

  call({
    List<Query_VolunteerCategories_ehrenamtsbankKategorien>?
    ehrenamtsbankKategorien,
    String? $__typename,
  }) => _res;

  ehrenamtsbankKategorien(_fn) => _res;
}

const documentNodeQueryVolunteerCategories = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VolunteerCategories'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'ehrenamtsbankKategorien'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'requiresClearance'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'eq'),
                            value: BooleanValueNode(value: false),
                          ),
                        ],
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'parentId'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'eq'),
                            value: NullValueNode(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'order'),
                value: ListValueNode(
                  values: [
                    ObjectValueNode(
                      fields: [
                        ObjectFieldNode(
                          name: NameNode(value: 'name'),
                          value: EnumValueNode(name: NameNode(value: 'ASC')),
                        ),
                      ],
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
Query_VolunteerCategories _parserFn_Query_VolunteerCategories(
  Map<String, dynamic> data,
) => Query_VolunteerCategories.fromJson(data);
typedef OnQueryComplete_Query_VolunteerCategories =
    FutureOr<void> Function(Map<String, dynamic>?, Query_VolunteerCategories?);

class Options_Query_VolunteerCategories
    extends graphql.QueryOptions<Query_VolunteerCategories> {
  Options_Query_VolunteerCategories({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerCategories? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VolunteerCategories? onComplete,
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
                 data == null
                     ? null
                     : _parserFn_Query_VolunteerCategories(data),
               ),
         onError: onError,
         document: documentNodeQueryVolunteerCategories,
         parserFn: _parserFn_Query_VolunteerCategories,
       );

  final OnQueryComplete_Query_VolunteerCategories? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VolunteerCategories
    extends graphql.WatchQueryOptions<Query_VolunteerCategories> {
  WatchOptions_Query_VolunteerCategories({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerCategories? typedOptimisticResult,
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
         document: documentNodeQueryVolunteerCategories,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VolunteerCategories,
       );
}

class FetchMoreOptions_Query_VolunteerCategories
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VolunteerCategories({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryVolunteerCategories,
       );
}

extension ClientExtension_Query_VolunteerCategories on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VolunteerCategories>>
  query_VolunteerCategories([
    Options_Query_VolunteerCategories? options,
  ]) async => await this.query(options ?? Options_Query_VolunteerCategories());

  graphql.ObservableQuery<Query_VolunteerCategories>
  watchQuery_VolunteerCategories([
    WatchOptions_Query_VolunteerCategories? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_VolunteerCategories());

  void writeQuery_VolunteerCategories({
    required Query_VolunteerCategories data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryVolunteerCategories,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VolunteerCategories? readQuery_VolunteerCategories({
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryVolunteerCategories,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_VolunteerCategories.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VolunteerCategories>
useQuery_VolunteerCategories([Options_Query_VolunteerCategories? options]) =>
    graphql_flutter.useQuery(options ?? Options_Query_VolunteerCategories());
graphql.ObservableQuery<Query_VolunteerCategories>
useWatchQuery_VolunteerCategories([
  WatchOptions_Query_VolunteerCategories? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_VolunteerCategories(),
);

class Query_VolunteerCategories_Widget
    extends graphql_flutter.Query<Query_VolunteerCategories> {
  Query_VolunteerCategories_Widget({
    widgets.Key? key,
    Options_Query_VolunteerCategories? options,
    required graphql_flutter.QueryBuilder<Query_VolunteerCategories> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_VolunteerCategories(),
         builder: builder,
       );
}

class Query_VolunteerCategories_ehrenamtsbankKategorien {
  Query_VolunteerCategories_ehrenamtsbankKategorien({
    required this.id,
    required this.name,
    this.$__typename = 'EhrenamtsbankKategorie',
  });

  factory Query_VolunteerCategories_ehrenamtsbankKategorien.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerCategories_ehrenamtsbankKategorien(
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
    if (other is! Query_VolunteerCategories_ehrenamtsbankKategorien ||
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

extension UtilityExtension_Query_VolunteerCategories_ehrenamtsbankKategorien
    on Query_VolunteerCategories_ehrenamtsbankKategorien {
  CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<
    Query_VolunteerCategories_ehrenamtsbankKategorien
  >
  get copyWith => CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<
  TRes
> {
  factory CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien(
    Query_VolunteerCategories_ehrenamtsbankKategorien instance,
    TRes Function(Query_VolunteerCategories_ehrenamtsbankKategorien) then,
  ) = _CopyWithImpl_Query_VolunteerCategories_ehrenamtsbankKategorien;

  factory CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VolunteerCategories_ehrenamtsbankKategorien;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_VolunteerCategories_ehrenamtsbankKategorien<TRes>
    implements
        CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<TRes> {
  _CopyWithImpl_Query_VolunteerCategories_ehrenamtsbankKategorien(
    this._instance,
    this._then,
  );

  final Query_VolunteerCategories_ehrenamtsbankKategorien _instance;

  final TRes Function(Query_VolunteerCategories_ehrenamtsbankKategorien) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerCategories_ehrenamtsbankKategorien(
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

class _CopyWithStubImpl_Query_VolunteerCategories_ehrenamtsbankKategorien<TRes>
    implements
        CopyWith_Query_VolunteerCategories_ehrenamtsbankKategorien<TRes> {
  _CopyWithStubImpl_Query_VolunteerCategories_ehrenamtsbankKategorien(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Variables_Query_VolunteerMunicipalities {
  factory Variables_Query_VolunteerMunicipalities({
    required String kommuneId,
  }) => Variables_Query_VolunteerMunicipalities._({r'kommuneId': kommuneId});

  Variables_Query_VolunteerMunicipalities._(this._$data);

  factory Variables_Query_VolunteerMunicipalities.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_VolunteerMunicipalities._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_VolunteerMunicipalities<
    Variables_Query_VolunteerMunicipalities
  >
  get copyWith =>
      CopyWith_Variables_Query_VolunteerMunicipalities(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_VolunteerMunicipalities ||
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

abstract class CopyWith_Variables_Query_VolunteerMunicipalities<TRes> {
  factory CopyWith_Variables_Query_VolunteerMunicipalities(
    Variables_Query_VolunteerMunicipalities instance,
    TRes Function(Variables_Query_VolunteerMunicipalities) then,
  ) = _CopyWithImpl_Variables_Query_VolunteerMunicipalities;

  factory CopyWith_Variables_Query_VolunteerMunicipalities.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_VolunteerMunicipalities;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_VolunteerMunicipalities<TRes>
    implements CopyWith_Variables_Query_VolunteerMunicipalities<TRes> {
  _CopyWithImpl_Variables_Query_VolunteerMunicipalities(
    this._instance,
    this._then,
  );

  final Variables_Query_VolunteerMunicipalities _instance;

  final TRes Function(Variables_Query_VolunteerMunicipalities) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_VolunteerMunicipalities._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_VolunteerMunicipalities<TRes>
    implements CopyWith_Variables_Query_VolunteerMunicipalities<TRes> {
  _CopyWithStubImpl_Variables_Query_VolunteerMunicipalities(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_VolunteerMunicipalities {
  Query_VolunteerMunicipalities({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_VolunteerMunicipalities.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerMunicipalities(
      kommune: Query_VolunteerMunicipalities_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_VolunteerMunicipalities_kommune kommune;

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
    if (other is! Query_VolunteerMunicipalities ||
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

extension UtilityExtension_Query_VolunteerMunicipalities
    on Query_VolunteerMunicipalities {
  CopyWith_Query_VolunteerMunicipalities<Query_VolunteerMunicipalities>
  get copyWith => CopyWith_Query_VolunteerMunicipalities(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerMunicipalities<TRes> {
  factory CopyWith_Query_VolunteerMunicipalities(
    Query_VolunteerMunicipalities instance,
    TRes Function(Query_VolunteerMunicipalities) then,
  ) = _CopyWithImpl_Query_VolunteerMunicipalities;

  factory CopyWith_Query_VolunteerMunicipalities.stub(TRes res) =
      _CopyWithStubImpl_Query_VolunteerMunicipalities;

  TRes call({
    Query_VolunteerMunicipalities_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_VolunteerMunicipalities_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_VolunteerMunicipalities<TRes>
    implements CopyWith_Query_VolunteerMunicipalities<TRes> {
  _CopyWithImpl_Query_VolunteerMunicipalities(this._instance, this._then);

  final Query_VolunteerMunicipalities _instance;

  final TRes Function(Query_VolunteerMunicipalities) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_VolunteerMunicipalities(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_VolunteerMunicipalities_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_VolunteerMunicipalities_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_VolunteerMunicipalities_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_VolunteerMunicipalities<TRes>
    implements CopyWith_Query_VolunteerMunicipalities<TRes> {
  _CopyWithStubImpl_Query_VolunteerMunicipalities(this._res);

  TRes _res;

  call({Query_VolunteerMunicipalities_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_VolunteerMunicipalities_kommune<TRes> get kommune =>
      CopyWith_Query_VolunteerMunicipalities_kommune.stub(_res);
}

const documentNodeQueryVolunteerMunicipalities = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VolunteerMunicipalities'),
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
Query_VolunteerMunicipalities _parserFn_Query_VolunteerMunicipalities(
  Map<String, dynamic> data,
) => Query_VolunteerMunicipalities.fromJson(data);
typedef OnQueryComplete_Query_VolunteerMunicipalities =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_VolunteerMunicipalities?,
    );

class Options_Query_VolunteerMunicipalities
    extends graphql.QueryOptions<Query_VolunteerMunicipalities> {
  Options_Query_VolunteerMunicipalities({
    String? operationName,
    required Variables_Query_VolunteerMunicipalities variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerMunicipalities? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VolunteerMunicipalities? onComplete,
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
                     : _parserFn_Query_VolunteerMunicipalities(data),
               ),
         onError: onError,
         document: documentNodeQueryVolunteerMunicipalities,
         parserFn: _parserFn_Query_VolunteerMunicipalities,
       );

  final OnQueryComplete_Query_VolunteerMunicipalities? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VolunteerMunicipalities
    extends graphql.WatchQueryOptions<Query_VolunteerMunicipalities> {
  WatchOptions_Query_VolunteerMunicipalities({
    String? operationName,
    required Variables_Query_VolunteerMunicipalities variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerMunicipalities? typedOptimisticResult,
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
         document: documentNodeQueryVolunteerMunicipalities,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VolunteerMunicipalities,
       );
}

class FetchMoreOptions_Query_VolunteerMunicipalities
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VolunteerMunicipalities({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_VolunteerMunicipalities variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryVolunteerMunicipalities,
       );
}

extension ClientExtension_Query_VolunteerMunicipalities
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VolunteerMunicipalities>>
  query_VolunteerMunicipalities(
    Options_Query_VolunteerMunicipalities options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_VolunteerMunicipalities>
  watchQuery_VolunteerMunicipalities(
    WatchOptions_Query_VolunteerMunicipalities options,
  ) => this.watchQuery(options);

  void writeQuery_VolunteerMunicipalities({
    required Query_VolunteerMunicipalities data,
    required Variables_Query_VolunteerMunicipalities variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryVolunteerMunicipalities,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VolunteerMunicipalities? readQuery_VolunteerMunicipalities({
    required Variables_Query_VolunteerMunicipalities variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryVolunteerMunicipalities,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_VolunteerMunicipalities.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VolunteerMunicipalities>
useQuery_VolunteerMunicipalities(
  Options_Query_VolunteerMunicipalities options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_VolunteerMunicipalities>
useWatchQuery_VolunteerMunicipalities(
  WatchOptions_Query_VolunteerMunicipalities options,
) => graphql_flutter.useWatchQuery(options);

class Query_VolunteerMunicipalities_Widget
    extends graphql_flutter.Query<Query_VolunteerMunicipalities> {
  Query_VolunteerMunicipalities_Widget({
    widgets.Key? key,
    required Options_Query_VolunteerMunicipalities options,
    required graphql_flutter.QueryBuilder<Query_VolunteerMunicipalities>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_VolunteerMunicipalities_kommune {
  Query_VolunteerMunicipalities_kommune({
    required this.untereinheiten,
    this.$__typename = 'Kommune',
  });

  factory Query_VolunteerMunicipalities_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$untereinheiten = json['untereinheiten'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerMunicipalities_kommune(
      untereinheiten: (l$untereinheiten as List<dynamic>)
          .map(
            (e) =>
                Query_VolunteerMunicipalities_kommune_untereinheiten.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_VolunteerMunicipalities_kommune_untereinheiten>
  untereinheiten;

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
    if (other is! Query_VolunteerMunicipalities_kommune ||
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

extension UtilityExtension_Query_VolunteerMunicipalities_kommune
    on Query_VolunteerMunicipalities_kommune {
  CopyWith_Query_VolunteerMunicipalities_kommune<
    Query_VolunteerMunicipalities_kommune
  >
  get copyWith =>
      CopyWith_Query_VolunteerMunicipalities_kommune(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerMunicipalities_kommune<TRes> {
  factory CopyWith_Query_VolunteerMunicipalities_kommune(
    Query_VolunteerMunicipalities_kommune instance,
    TRes Function(Query_VolunteerMunicipalities_kommune) then,
  ) = _CopyWithImpl_Query_VolunteerMunicipalities_kommune;

  factory CopyWith_Query_VolunteerMunicipalities_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune;

  TRes call({
    List<Query_VolunteerMunicipalities_kommune_untereinheiten>? untereinheiten,
    String? $__typename,
  });
  TRes untereinheiten(
    Iterable<Query_VolunteerMunicipalities_kommune_untereinheiten> Function(
      Iterable<
        CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<
          Query_VolunteerMunicipalities_kommune_untereinheiten
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VolunteerMunicipalities_kommune<TRes>
    implements CopyWith_Query_VolunteerMunicipalities_kommune<TRes> {
  _CopyWithImpl_Query_VolunteerMunicipalities_kommune(
    this._instance,
    this._then,
  );

  final Query_VolunteerMunicipalities_kommune _instance;

  final TRes Function(Query_VolunteerMunicipalities_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? untereinheiten = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerMunicipalities_kommune(
      untereinheiten: untereinheiten == _undefined || untereinheiten == null
          ? _instance.untereinheiten
          : (untereinheiten
                as List<Query_VolunteerMunicipalities_kommune_untereinheiten>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes untereinheiten(
    Iterable<Query_VolunteerMunicipalities_kommune_untereinheiten> Function(
      Iterable<
        CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<
          Query_VolunteerMunicipalities_kommune_untereinheiten
        >
      >,
    )
    _fn,
  ) => call(
    untereinheiten: _fn(
      _instance.untereinheiten.map(
        (e) => CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune<TRes>
    implements CopyWith_Query_VolunteerMunicipalities_kommune<TRes> {
  _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune(this._res);

  TRes _res;

  call({
    List<Query_VolunteerMunicipalities_kommune_untereinheiten>? untereinheiten,
    String? $__typename,
  }) => _res;

  untereinheiten(_fn) => _res;
}

class Query_VolunteerMunicipalities_kommune_untereinheiten {
  Query_VolunteerMunicipalities_kommune_untereinheiten({
    required this.id,
    required this.name,
    this.$__typename = 'Untereinheit',
  });

  factory Query_VolunteerMunicipalities_kommune_untereinheiten.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerMunicipalities_kommune_untereinheiten(
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
    if (other is! Query_VolunteerMunicipalities_kommune_untereinheiten ||
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

extension UtilityExtension_Query_VolunteerMunicipalities_kommune_untereinheiten
    on Query_VolunteerMunicipalities_kommune_untereinheiten {
  CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<
    Query_VolunteerMunicipalities_kommune_untereinheiten
  >
  get copyWith => CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<
  TRes
> {
  factory CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten(
    Query_VolunteerMunicipalities_kommune_untereinheiten instance,
    TRes Function(Query_VolunteerMunicipalities_kommune_untereinheiten) then,
  ) = _CopyWithImpl_Query_VolunteerMunicipalities_kommune_untereinheiten;

  factory CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune_untereinheiten;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_VolunteerMunicipalities_kommune_untereinheiten<TRes>
    implements
        CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<TRes> {
  _CopyWithImpl_Query_VolunteerMunicipalities_kommune_untereinheiten(
    this._instance,
    this._then,
  );

  final Query_VolunteerMunicipalities_kommune_untereinheiten _instance;

  final TRes Function(Query_VolunteerMunicipalities_kommune_untereinheiten)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerMunicipalities_kommune_untereinheiten(
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

class _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune_untereinheiten<
  TRes
>
    implements
        CopyWith_Query_VolunteerMunicipalities_kommune_untereinheiten<TRes> {
  _CopyWithStubImpl_Query_VolunteerMunicipalities_kommune_untereinheiten(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}
