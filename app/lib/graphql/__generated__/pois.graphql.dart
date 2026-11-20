import 'blocks.graphql.dart';
import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables_Query_Poi {
  factory Variables_Query_Poi({required String id}) =>
      Variables_Query_Poi._({r'id': id});

  Variables_Query_Poi._(this._$data);

  factory Variables_Query_Poi.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_Poi._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_Poi<Variables_Query_Poi> get copyWith =>
      CopyWith_Variables_Query_Poi(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Poi || runtimeType != other.runtimeType) {
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

abstract class CopyWith_Variables_Query_Poi<TRes> {
  factory CopyWith_Variables_Query_Poi(
    Variables_Query_Poi instance,
    TRes Function(Variables_Query_Poi) then,
  ) = _CopyWithImpl_Variables_Query_Poi;

  factory CopyWith_Variables_Query_Poi.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Poi;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_Poi<TRes>
    implements CopyWith_Variables_Query_Poi<TRes> {
  _CopyWithImpl_Variables_Query_Poi(this._instance, this._then);

  final Variables_Query_Poi _instance;

  final TRes Function(Variables_Query_Poi) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_Poi._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Poi<TRes>
    implements CopyWith_Variables_Query_Poi<TRes> {
  _CopyWithStubImpl_Variables_Query_Poi(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_Poi {
  Query_Poi({this.poi, this.$__typename = 'Query'});

  factory Query_Poi.fromJson(Map<String, dynamic> json) {
    final l$poi = json['poi'];
    final l$$__typename = json['__typename'];
    return Query_Poi(
      poi: l$poi == null
          ? null
          : Query_Poi_poi.fromJson((l$poi as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Poi_poi? poi;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$poi = poi;
    _resultData['poi'] = l$poi?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$poi = poi;
    final l$$__typename = $__typename;
    return Object.hashAll([l$poi, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi || runtimeType != other.runtimeType) {
      return false;
    }
    final l$poi = poi;
    final lOther$poi = other.poi;
    if (l$poi != lOther$poi) {
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

extension UtilityExtension_Query_Poi on Query_Poi {
  CopyWith_Query_Poi<Query_Poi> get copyWith =>
      CopyWith_Query_Poi(this, (i) => i);
}

abstract class CopyWith_Query_Poi<TRes> {
  factory CopyWith_Query_Poi(
    Query_Poi instance,
    TRes Function(Query_Poi) then,
  ) = _CopyWithImpl_Query_Poi;

  factory CopyWith_Query_Poi.stub(TRes res) = _CopyWithStubImpl_Query_Poi;

  TRes call({Query_Poi_poi? poi, String? $__typename});
  CopyWith_Query_Poi_poi<TRes> get poi;
}

class _CopyWithImpl_Query_Poi<TRes> implements CopyWith_Query_Poi<TRes> {
  _CopyWithImpl_Query_Poi(this._instance, this._then);

  final Query_Poi _instance;

  final TRes Function(Query_Poi) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? poi = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Poi(
          poi: poi == _undefined ? _instance.poi : (poi as Query_Poi_poi?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Poi_poi<TRes> get poi {
    final local$poi = _instance.poi;
    return local$poi == null
        ? CopyWith_Query_Poi_poi.stub(_then(_instance))
        : CopyWith_Query_Poi_poi(local$poi, (e) => call(poi: e));
  }
}

class _CopyWithStubImpl_Query_Poi<TRes> implements CopyWith_Query_Poi<TRes> {
  _CopyWithStubImpl_Query_Poi(this._res);

  TRes _res;

  call({Query_Poi_poi? poi, String? $__typename}) => _res;

  CopyWith_Query_Poi_poi<TRes> get poi => CopyWith_Query_Poi_poi.stub(_res);
}

const documentNodeQueryPoi = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Poi'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'poi'),
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
                  name: NameNode(value: 'title'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'image'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'external'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'url'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'internal'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'MedienImage'),
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
                  name: NameNode(value: 'position'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'positionString'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'contents'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'RichTextBlock'),
                        directives: [],
                      ),
                      FragmentSpreadNode(
                        name: NameNode(value: 'ImageBlockMedien'),
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
                  name: NameNode(value: 'additionalInformation'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'heading'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'text'),
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
    fragmentDefinitionMedienImage,
    fragmentDefinitionRichTextBlock,
    fragmentDefinitionImageBlockMedien,
  ],
);
Query_Poi _parserFn_Query_Poi(Map<String, dynamic> data) =>
    Query_Poi.fromJson(data);
typedef OnQueryComplete_Query_Poi =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Poi?);

class Options_Query_Poi extends graphql.QueryOptions<Query_Poi> {
  Options_Query_Poi({
    String? operationName,
    required Variables_Query_Poi variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Poi? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Poi? onComplete,
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
                 data == null ? null : _parserFn_Query_Poi(data),
               ),
         onError: onError,
         document: documentNodeQueryPoi,
         parserFn: _parserFn_Query_Poi,
       );

  final OnQueryComplete_Query_Poi? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Poi extends graphql.WatchQueryOptions<Query_Poi> {
  WatchOptions_Query_Poi({
    String? operationName,
    required Variables_Query_Poi variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Poi? typedOptimisticResult,
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
         document: documentNodeQueryPoi,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Poi,
       );
}

class FetchMoreOptions_Query_Poi extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Poi({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Poi variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryPoi,
       );
}

extension ClientExtension_Query_Poi on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Poi>> query_Poi(
    Options_Query_Poi options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Poi> watchQuery_Poi(
    WatchOptions_Query_Poi options,
  ) => this.watchQuery(options);

  void writeQuery_Poi({
    required Query_Poi data,
    required Variables_Query_Poi variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryPoi),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Poi? readQuery_Poi({
    required Variables_Query_Poi variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryPoi),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Poi.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Poi> useQuery_Poi(
  Options_Query_Poi options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Poi> useWatchQuery_Poi(
  WatchOptions_Query_Poi options,
) => graphql_flutter.useWatchQuery(options);

class Query_Poi_Widget extends graphql_flutter.Query<Query_Poi> {
  Query_Poi_Widget({
    widgets.Key? key,
    required Options_Query_Poi options,
    required graphql_flutter.QueryBuilder<Query_Poi> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Poi_poi {
  Query_Poi_poi({
    required this.id,
    required this.title,
    this.image,
    required this.position,
    this.positionString,
    this.contents,
    this.additionalInformation,
    this.$__typename = 'Poi',
  });

  factory Query_Poi_poi.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$image = json['image'];
    final l$position = json['position'];
    final l$positionString = json['positionString'];
    final l$contents = json['contents'];
    final l$additionalInformation = json['additionalInformation'];
    final l$$__typename = json['__typename'];
    return Query_Poi_poi(
      id: (l$id as String),
      title: (l$title as String),
      image: l$image == null
          ? null
          : Query_Poi_poi_image.fromJson((l$image as Map<String, dynamic>)),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      positionString: (l$positionString as String?),
      contents: (l$contents as List<dynamic>?)
          ?.map(
            (e) => Query_Poi_poi_contents.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      additionalInformation: (l$additionalInformation as List<dynamic>?)
          ?.map(
            (e) => Query_Poi_poi_additionalInformation.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final Query_Poi_poi_image? image;

  final List<double> position;

  final String? positionString;

  final List<Query_Poi_poi_contents>? contents;

  final List<Query_Poi_poi_additionalInformation>? additionalInformation;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$image = image;
    _resultData['image'] = l$image?.toJson();
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$positionString = positionString;
    _resultData['positionString'] = l$positionString;
    final l$contents = contents;
    _resultData['contents'] = l$contents?.map((e) => e.toJson()).toList();
    final l$additionalInformation = additionalInformation;
    _resultData['additionalInformation'] = l$additionalInformation
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$image = image;
    final l$position = position;
    final l$positionString = positionString;
    final l$contents = contents;
    final l$additionalInformation = additionalInformation;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$image,
      Object.hashAll(l$position.map((v) => v)),
      l$positionString,
      l$contents == null ? null : Object.hashAll(l$contents.map((v) => v)),
      l$additionalInformation == null
          ? null
          : Object.hashAll(l$additionalInformation.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi_poi || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$image = image;
    final lOther$image = other.image;
    if (l$image != lOther$image) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position.length != lOther$position.length) {
      return false;
    }
    for (int i = 0; i < l$position.length; i++) {
      final l$position$entry = l$position[i];
      final lOther$position$entry = lOther$position[i];
      if (l$position$entry != lOther$position$entry) {
        return false;
      }
    }
    final l$positionString = positionString;
    final lOther$positionString = other.positionString;
    if (l$positionString != lOther$positionString) {
      return false;
    }
    final l$contents = contents;
    final lOther$contents = other.contents;
    if (l$contents != null && lOther$contents != null) {
      if (l$contents.length != lOther$contents.length) {
        return false;
      }
      for (int i = 0; i < l$contents.length; i++) {
        final l$contents$entry = l$contents[i];
        final lOther$contents$entry = lOther$contents[i];
        if (l$contents$entry != lOther$contents$entry) {
          return false;
        }
      }
    } else if (l$contents != lOther$contents) {
      return false;
    }
    final l$additionalInformation = additionalInformation;
    final lOther$additionalInformation = other.additionalInformation;
    if (l$additionalInformation != null &&
        lOther$additionalInformation != null) {
      if (l$additionalInformation.length !=
          lOther$additionalInformation.length) {
        return false;
      }
      for (int i = 0; i < l$additionalInformation.length; i++) {
        final l$additionalInformation$entry = l$additionalInformation[i];
        final lOther$additionalInformation$entry =
            lOther$additionalInformation[i];
        if (l$additionalInformation$entry !=
            lOther$additionalInformation$entry) {
          return false;
        }
      }
    } else if (l$additionalInformation != lOther$additionalInformation) {
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

extension UtilityExtension_Query_Poi_poi on Query_Poi_poi {
  CopyWith_Query_Poi_poi<Query_Poi_poi> get copyWith =>
      CopyWith_Query_Poi_poi(this, (i) => i);
}

abstract class CopyWith_Query_Poi_poi<TRes> {
  factory CopyWith_Query_Poi_poi(
    Query_Poi_poi instance,
    TRes Function(Query_Poi_poi) then,
  ) = _CopyWithImpl_Query_Poi_poi;

  factory CopyWith_Query_Poi_poi.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi;

  TRes call({
    String? id,
    String? title,
    Query_Poi_poi_image? image,
    List<double>? position,
    String? positionString,
    List<Query_Poi_poi_contents>? contents,
    List<Query_Poi_poi_additionalInformation>? additionalInformation,
    String? $__typename,
  });
  CopyWith_Query_Poi_poi_image<TRes> get image;
  TRes contents(
    Iterable<Query_Poi_poi_contents>? Function(
      Iterable<CopyWith_Query_Poi_poi_contents<Query_Poi_poi_contents>>?,
    )
    _fn,
  );
  TRes additionalInformation(
    Iterable<Query_Poi_poi_additionalInformation>? Function(
      Iterable<
        CopyWith_Query_Poi_poi_additionalInformation<
          Query_Poi_poi_additionalInformation
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Poi_poi<TRes>
    implements CopyWith_Query_Poi_poi<TRes> {
  _CopyWithImpl_Query_Poi_poi(this._instance, this._then);

  final Query_Poi_poi _instance;

  final TRes Function(Query_Poi_poi) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? image = _undefined,
    Object? position = _undefined,
    Object? positionString = _undefined,
    Object? contents = _undefined,
    Object? additionalInformation = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Poi_poi(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      image: image == _undefined
          ? _instance.image
          : (image as Query_Poi_poi_image?),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      positionString: positionString == _undefined
          ? _instance.positionString
          : (positionString as String?),
      contents: contents == _undefined
          ? _instance.contents
          : (contents as List<Query_Poi_poi_contents>?),
      additionalInformation: additionalInformation == _undefined
          ? _instance.additionalInformation
          : (additionalInformation
                as List<Query_Poi_poi_additionalInformation>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Poi_poi_image<TRes> get image {
    final local$image = _instance.image;
    return local$image == null
        ? CopyWith_Query_Poi_poi_image.stub(_then(_instance))
        : CopyWith_Query_Poi_poi_image(local$image, (e) => call(image: e));
  }

  TRes contents(
    Iterable<Query_Poi_poi_contents>? Function(
      Iterable<CopyWith_Query_Poi_poi_contents<Query_Poi_poi_contents>>?,
    )
    _fn,
  ) => call(
    contents: _fn(
      _instance.contents?.map(
        (e) => CopyWith_Query_Poi_poi_contents(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes additionalInformation(
    Iterable<Query_Poi_poi_additionalInformation>? Function(
      Iterable<
        CopyWith_Query_Poi_poi_additionalInformation<
          Query_Poi_poi_additionalInformation
        >
      >?,
    )
    _fn,
  ) => call(
    additionalInformation: _fn(
      _instance.additionalInformation?.map(
        (e) => CopyWith_Query_Poi_poi_additionalInformation(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_Poi_poi<TRes>
    implements CopyWith_Query_Poi_poi<TRes> {
  _CopyWithStubImpl_Query_Poi_poi(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    Query_Poi_poi_image? image,
    List<double>? position,
    String? positionString,
    List<Query_Poi_poi_contents>? contents,
    List<Query_Poi_poi_additionalInformation>? additionalInformation,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Poi_poi_image<TRes> get image =>
      CopyWith_Query_Poi_poi_image.stub(_res);

  contents(_fn) => _res;

  additionalInformation(_fn) => _res;
}

class Query_Poi_poi_image {
  Query_Poi_poi_image({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'Poi_Image',
  });

  factory Query_Poi_poi_image.fromJson(Map<String, dynamic> json) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Query_Poi_poi_image(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Fragment_MedienImage.fromJson((l$internal as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Fragment_MedienImage? internal;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$external = $external;
    _resultData['external'] = l$$external;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$internal = internal;
    _resultData['internal'] = l$internal?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$external = $external;
    final l$url = url;
    final l$internal = internal;
    final l$$__typename = $__typename;
    return Object.hashAll([l$$external, l$url, l$internal, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi_poi_image || runtimeType != other.runtimeType) {
      return false;
    }
    final l$$external = $external;
    final lOther$$external = other.$external;
    if (l$$external != lOther$$external) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$internal = internal;
    final lOther$internal = other.internal;
    if (l$internal != lOther$internal) {
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

extension UtilityExtension_Query_Poi_poi_image on Query_Poi_poi_image {
  CopyWith_Query_Poi_poi_image<Query_Poi_poi_image> get copyWith =>
      CopyWith_Query_Poi_poi_image(this, (i) => i);
}

abstract class CopyWith_Query_Poi_poi_image<TRes> {
  factory CopyWith_Query_Poi_poi_image(
    Query_Poi_poi_image instance,
    TRes Function(Query_Poi_poi_image) then,
  ) = _CopyWithImpl_Query_Poi_poi_image;

  factory CopyWith_Query_Poi_poi_image.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi_image;

  TRes call({
    bool? $external,
    String? url,
    Fragment_MedienImage? internal,
    String? $__typename,
  });
  CopyWith_Fragment_MedienImage<TRes> get internal;
}

class _CopyWithImpl_Query_Poi_poi_image<TRes>
    implements CopyWith_Query_Poi_poi_image<TRes> {
  _CopyWithImpl_Query_Poi_poi_image(this._instance, this._then);

  final Query_Poi_poi_image _instance;

  final TRes Function(Query_Poi_poi_image) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Poi_poi_image(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal as Fragment_MedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_MedienImage<TRes> get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Fragment_MedienImage.stub(_then(_instance))
        : CopyWith_Fragment_MedienImage(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Query_Poi_poi_image<TRes>
    implements CopyWith_Query_Poi_poi_image<TRes> {
  _CopyWithStubImpl_Query_Poi_poi_image(this._res);

  TRes _res;

  call({
    bool? $external,
    String? url,
    Fragment_MedienImage? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_MedienImage<TRes> get internal =>
      CopyWith_Fragment_MedienImage.stub(_res);
}

class Query_Poi_poi_contents {
  Query_Poi_poi_contents({required this.$__typename});

  factory Query_Poi_poi_contents.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "RichTextBlock":
        return Query_Poi_poi_contents__RichTextBlock.fromJson(json);

      case "ImageBlockMedien":
        return Query_Poi_poi_contents__ImageBlockMedien.fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Query_Poi_poi_contents($__typename: (l$$__typename as String));
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
    if (other is! Query_Poi_poi_contents || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Poi_poi_contents on Query_Poi_poi_contents {
  CopyWith_Query_Poi_poi_contents<Query_Poi_poi_contents> get copyWith =>
      CopyWith_Query_Poi_poi_contents(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_Poi_poi_contents__RichTextBlock) richTextBlock,
    required _T Function(Query_Poi_poi_contents__ImageBlockMedien)
    imageBlockMedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        return richTextBlock(this as Query_Poi_poi_contents__RichTextBlock);

      case "ImageBlockMedien":
        return imageBlockMedien(
          this as Query_Poi_poi_contents__ImageBlockMedien,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_Poi_poi_contents__RichTextBlock)? richTextBlock,
    _T Function(Query_Poi_poi_contents__ImageBlockMedien)? imageBlockMedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        if (richTextBlock != null) {
          return richTextBlock(this as Query_Poi_poi_contents__RichTextBlock);
        } else {
          return orElse();
        }

      case "ImageBlockMedien":
        if (imageBlockMedien != null) {
          return imageBlockMedien(
            this as Query_Poi_poi_contents__ImageBlockMedien,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_Poi_poi_contents<TRes> {
  factory CopyWith_Query_Poi_poi_contents(
    Query_Poi_poi_contents instance,
    TRes Function(Query_Poi_poi_contents) then,
  ) = _CopyWithImpl_Query_Poi_poi_contents;

  factory CopyWith_Query_Poi_poi_contents.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi_contents;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Query_Poi_poi_contents<TRes>
    implements CopyWith_Query_Poi_poi_contents<TRes> {
  _CopyWithImpl_Query_Poi_poi_contents(this._instance, this._then);

  final Query_Poi_poi_contents _instance;

  final TRes Function(Query_Poi_poi_contents) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query_Poi_poi_contents(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Poi_poi_contents<TRes>
    implements CopyWith_Query_Poi_poi_contents<TRes> {
  _CopyWithStubImpl_Query_Poi_poi_contents(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query_Poi_poi_contents__RichTextBlock
    implements Fragment_RichTextBlock, Query_Poi_poi_contents {
  Query_Poi_poi_contents__RichTextBlock({
    this.contentHtml,
    this.$__typename = 'RichTextBlock',
  });

  factory Query_Poi_poi_contents__RichTextBlock.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$contentHtml = json['contentHtml'];
    final l$$__typename = json['__typename'];
    return Query_Poi_poi_contents__RichTextBlock(
      contentHtml: (l$contentHtml as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? contentHtml;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$contentHtml = contentHtml;
    _resultData['contentHtml'] = l$contentHtml;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$contentHtml = contentHtml;
    final l$$__typename = $__typename;
    return Object.hashAll([l$contentHtml, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi_poi_contents__RichTextBlock ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$contentHtml = contentHtml;
    final lOther$contentHtml = other.contentHtml;
    if (l$contentHtml != lOther$contentHtml) {
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

extension UtilityExtension_Query_Poi_poi_contents__RichTextBlock
    on Query_Poi_poi_contents__RichTextBlock {
  CopyWith_Query_Poi_poi_contents__RichTextBlock<
    Query_Poi_poi_contents__RichTextBlock
  >
  get copyWith =>
      CopyWith_Query_Poi_poi_contents__RichTextBlock(this, (i) => i);
}

abstract class CopyWith_Query_Poi_poi_contents__RichTextBlock<TRes> {
  factory CopyWith_Query_Poi_poi_contents__RichTextBlock(
    Query_Poi_poi_contents__RichTextBlock instance,
    TRes Function(Query_Poi_poi_contents__RichTextBlock) then,
  ) = _CopyWithImpl_Query_Poi_poi_contents__RichTextBlock;

  factory CopyWith_Query_Poi_poi_contents__RichTextBlock.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi_contents__RichTextBlock;

  TRes call({String? contentHtml, String? $__typename});
}

class _CopyWithImpl_Query_Poi_poi_contents__RichTextBlock<TRes>
    implements CopyWith_Query_Poi_poi_contents__RichTextBlock<TRes> {
  _CopyWithImpl_Query_Poi_poi_contents__RichTextBlock(
    this._instance,
    this._then,
  );

  final Query_Poi_poi_contents__RichTextBlock _instance;

  final TRes Function(Query_Poi_poi_contents__RichTextBlock) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentHtml = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Poi_poi_contents__RichTextBlock(
      contentHtml: contentHtml == _undefined
          ? _instance.contentHtml
          : (contentHtml as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Poi_poi_contents__RichTextBlock<TRes>
    implements CopyWith_Query_Poi_poi_contents__RichTextBlock<TRes> {
  _CopyWithStubImpl_Query_Poi_poi_contents__RichTextBlock(this._res);

  TRes _res;

  call({String? contentHtml, String? $__typename}) => _res;
}

class Query_Poi_poi_contents__ImageBlockMedien
    implements Fragment_ImageBlockMedien, Query_Poi_poi_contents {
  Query_Poi_poi_contents__ImageBlockMedien({
    this.image,
    this.$__typename = 'ImageBlockMedien',
  });

  factory Query_Poi_poi_contents__ImageBlockMedien.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Query_Poi_poi_contents__ImageBlockMedien(
      image: l$image == null
          ? null
          : Fragment_MedienImage.fromJson((l$image as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_MedienImage? image;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$image = image;
    _resultData['image'] = l$image?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$image = image;
    final l$$__typename = $__typename;
    return Object.hashAll([l$image, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi_poi_contents__ImageBlockMedien ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$image = image;
    final lOther$image = other.image;
    if (l$image != lOther$image) {
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

extension UtilityExtension_Query_Poi_poi_contents__ImageBlockMedien
    on Query_Poi_poi_contents__ImageBlockMedien {
  CopyWith_Query_Poi_poi_contents__ImageBlockMedien<
    Query_Poi_poi_contents__ImageBlockMedien
  >
  get copyWith =>
      CopyWith_Query_Poi_poi_contents__ImageBlockMedien(this, (i) => i);
}

abstract class CopyWith_Query_Poi_poi_contents__ImageBlockMedien<TRes> {
  factory CopyWith_Query_Poi_poi_contents__ImageBlockMedien(
    Query_Poi_poi_contents__ImageBlockMedien instance,
    TRes Function(Query_Poi_poi_contents__ImageBlockMedien) then,
  ) = _CopyWithImpl_Query_Poi_poi_contents__ImageBlockMedien;

  factory CopyWith_Query_Poi_poi_contents__ImageBlockMedien.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi_contents__ImageBlockMedien;

  TRes call({Fragment_MedienImage? image, String? $__typename});
  CopyWith_Fragment_MedienImage<TRes> get image;
}

class _CopyWithImpl_Query_Poi_poi_contents__ImageBlockMedien<TRes>
    implements CopyWith_Query_Poi_poi_contents__ImageBlockMedien<TRes> {
  _CopyWithImpl_Query_Poi_poi_contents__ImageBlockMedien(
    this._instance,
    this._then,
  );

  final Query_Poi_poi_contents__ImageBlockMedien _instance;

  final TRes Function(Query_Poi_poi_contents__ImageBlockMedien) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? image = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Poi_poi_contents__ImageBlockMedien(
          image: image == _undefined
              ? _instance.image
              : (image as Fragment_MedienImage?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Fragment_MedienImage<TRes> get image {
    final local$image = _instance.image;
    return local$image == null
        ? CopyWith_Fragment_MedienImage.stub(_then(_instance))
        : CopyWith_Fragment_MedienImage(local$image, (e) => call(image: e));
  }
}

class _CopyWithStubImpl_Query_Poi_poi_contents__ImageBlockMedien<TRes>
    implements CopyWith_Query_Poi_poi_contents__ImageBlockMedien<TRes> {
  _CopyWithStubImpl_Query_Poi_poi_contents__ImageBlockMedien(this._res);

  TRes _res;

  call({Fragment_MedienImage? image, String? $__typename}) => _res;

  CopyWith_Fragment_MedienImage<TRes> get image =>
      CopyWith_Fragment_MedienImage.stub(_res);
}

class Query_Poi_poi_additionalInformation {
  Query_Poi_poi_additionalInformation({
    this.heading,
    this.text,
    this.$__typename = 'Poi_AdditionalInformation',
  });

  factory Query_Poi_poi_additionalInformation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$heading = json['heading'];
    final l$text = json['text'];
    final l$$__typename = json['__typename'];
    return Query_Poi_poi_additionalInformation(
      heading: (l$heading as String?),
      text: (l$text as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? heading;

  final String? text;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$heading = heading;
    _resultData['heading'] = l$heading;
    final l$text = text;
    _resultData['text'] = l$text;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$heading = heading;
    final l$text = text;
    final l$$__typename = $__typename;
    return Object.hashAll([l$heading, l$text, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Poi_poi_additionalInformation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$heading = heading;
    final lOther$heading = other.heading;
    if (l$heading != lOther$heading) {
      return false;
    }
    final l$text = text;
    final lOther$text = other.text;
    if (l$text != lOther$text) {
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

extension UtilityExtension_Query_Poi_poi_additionalInformation
    on Query_Poi_poi_additionalInformation {
  CopyWith_Query_Poi_poi_additionalInformation<
    Query_Poi_poi_additionalInformation
  >
  get copyWith => CopyWith_Query_Poi_poi_additionalInformation(this, (i) => i);
}

abstract class CopyWith_Query_Poi_poi_additionalInformation<TRes> {
  factory CopyWith_Query_Poi_poi_additionalInformation(
    Query_Poi_poi_additionalInformation instance,
    TRes Function(Query_Poi_poi_additionalInformation) then,
  ) = _CopyWithImpl_Query_Poi_poi_additionalInformation;

  factory CopyWith_Query_Poi_poi_additionalInformation.stub(TRes res) =
      _CopyWithStubImpl_Query_Poi_poi_additionalInformation;

  TRes call({String? heading, String? text, String? $__typename});
}

class _CopyWithImpl_Query_Poi_poi_additionalInformation<TRes>
    implements CopyWith_Query_Poi_poi_additionalInformation<TRes> {
  _CopyWithImpl_Query_Poi_poi_additionalInformation(this._instance, this._then);

  final Query_Poi_poi_additionalInformation _instance;

  final TRes Function(Query_Poi_poi_additionalInformation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? heading = _undefined,
    Object? text = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Poi_poi_additionalInformation(
      heading: heading == _undefined ? _instance.heading : (heading as String?),
      text: text == _undefined ? _instance.text : (text as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Poi_poi_additionalInformation<TRes>
    implements CopyWith_Query_Poi_poi_additionalInformation<TRes> {
  _CopyWithStubImpl_Query_Poi_poi_additionalInformation(this._res);

  TRes _res;

  call({String? heading, String? text, String? $__typename}) => _res;
}

class Variables_Query_Pois {
  factory Variables_Query_Pois({
    dynamic? kommuneId,
    String? sort,
    int? limit,
  }) => Variables_Query_Pois._({
    if (kommuneId != null) r'kommuneId': kommuneId,
    if (sort != null) r'sort': sort,
    if (limit != null) r'limit': limit,
  });

  Variables_Query_Pois._(this._$data);

  factory Variables_Query_Pois.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('kommuneId')) {
      final l$kommuneId = data['kommuneId'];
      result$data['kommuneId'] = (l$kommuneId as dynamic?);
    }
    if (data.containsKey('sort')) {
      final l$sort = data['sort'];
      result$data['sort'] = (l$sort as String?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables_Query_Pois._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic? get kommuneId => (_$data['kommuneId'] as dynamic?);

  String? get sort => (_$data['sort'] as String?);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('kommuneId')) {
      final l$kommuneId = kommuneId;
      result$data['kommuneId'] = l$kommuneId;
    }
    if (_$data.containsKey('sort')) {
      final l$sort = sort;
      result$data['sort'] = l$sort;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith_Variables_Query_Pois<Variables_Query_Pois> get copyWith =>
      CopyWith_Variables_Query_Pois(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Pois || runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (_$data.containsKey('kommuneId') !=
        other._$data.containsKey('kommuneId')) {
      return false;
    }
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$sort = sort;
    final lOther$sort = other.sort;
    if (_$data.containsKey('sort') != other._$data.containsKey('sort')) {
      return false;
    }
    if (l$sort != lOther$sort) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (_$data.containsKey('limit') != other._$data.containsKey('limit')) {
      return false;
    }
    if (l$limit != lOther$limit) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$sort = sort;
    final l$limit = limit;
    return Object.hashAll([
      _$data.containsKey('kommuneId') ? l$kommuneId : const {},
      _$data.containsKey('sort') ? l$sort : const {},
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_Pois<TRes> {
  factory CopyWith_Variables_Query_Pois(
    Variables_Query_Pois instance,
    TRes Function(Variables_Query_Pois) then,
  ) = _CopyWithImpl_Variables_Query_Pois;

  factory CopyWith_Variables_Query_Pois.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Pois;

  TRes call({dynamic? kommuneId, String? sort, int? limit});
}

class _CopyWithImpl_Variables_Query_Pois<TRes>
    implements CopyWith_Variables_Query_Pois<TRes> {
  _CopyWithImpl_Variables_Query_Pois(this._instance, this._then);

  final Variables_Query_Pois _instance;

  final TRes Function(Variables_Query_Pois) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? sort = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Variables_Query_Pois._({
      ..._instance._$data,
      if (kommuneId != _undefined) 'kommuneId': (kommuneId as dynamic?),
      if (sort != _undefined) 'sort': (sort as String?),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Pois<TRes>
    implements CopyWith_Variables_Query_Pois<TRes> {
  _CopyWithStubImpl_Variables_Query_Pois(this._res);

  TRes _res;

  call({dynamic? kommuneId, String? sort, int? limit}) => _res;
}

class Query_Pois {
  Query_Pois({this.pois, this.$__typename = 'Query'});

  factory Query_Pois.fromJson(Map<String, dynamic> json) {
    final l$pois = json['pois'];
    final l$$__typename = json['__typename'];
    return Query_Pois(
      pois: l$pois == null
          ? null
          : Query_Pois_pois.fromJson((l$pois as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Pois_pois? pois;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$pois = pois;
    _resultData['pois'] = l$pois?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$pois = pois;
    final l$$__typename = $__typename;
    return Object.hashAll([l$pois, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Pois || runtimeType != other.runtimeType) {
      return false;
    }
    final l$pois = pois;
    final lOther$pois = other.pois;
    if (l$pois != lOther$pois) {
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

extension UtilityExtension_Query_Pois on Query_Pois {
  CopyWith_Query_Pois<Query_Pois> get copyWith =>
      CopyWith_Query_Pois(this, (i) => i);
}

abstract class CopyWith_Query_Pois<TRes> {
  factory CopyWith_Query_Pois(
    Query_Pois instance,
    TRes Function(Query_Pois) then,
  ) = _CopyWithImpl_Query_Pois;

  factory CopyWith_Query_Pois.stub(TRes res) = _CopyWithStubImpl_Query_Pois;

  TRes call({Query_Pois_pois? pois, String? $__typename});
  CopyWith_Query_Pois_pois<TRes> get pois;
}

class _CopyWithImpl_Query_Pois<TRes> implements CopyWith_Query_Pois<TRes> {
  _CopyWithImpl_Query_Pois(this._instance, this._then);

  final Query_Pois _instance;

  final TRes Function(Query_Pois) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? pois = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Pois(
          pois: pois == _undefined
              ? _instance.pois
              : (pois as Query_Pois_pois?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Pois_pois<TRes> get pois {
    final local$pois = _instance.pois;
    return local$pois == null
        ? CopyWith_Query_Pois_pois.stub(_then(_instance))
        : CopyWith_Query_Pois_pois(local$pois, (e) => call(pois: e));
  }
}

class _CopyWithStubImpl_Query_Pois<TRes> implements CopyWith_Query_Pois<TRes> {
  _CopyWithStubImpl_Query_Pois(this._res);

  TRes _res;

  call({Query_Pois_pois? pois, String? $__typename}) => _res;

  CopyWith_Query_Pois_pois<TRes> get pois =>
      CopyWith_Query_Pois_pois.stub(_res);
}

const documentNodeQueryPois = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Pois'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sort')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'limit')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'pois'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'kommune'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'equals'),
                            value: VariableNode(
                              name: NameNode(value: 'kommuneId'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'sort'),
                value: VariableNode(name: NameNode(value: 'sort')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
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
                        name: NameNode(value: 'position'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'category'),
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
                              name: NameNode(value: 'icon'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'PoiIcon'),
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
    fragmentDefinitionPoiIcon,
  ],
);
Query_Pois _parserFn_Query_Pois(Map<String, dynamic> data) =>
    Query_Pois.fromJson(data);
typedef OnQueryComplete_Query_Pois =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Pois?);

class Options_Query_Pois extends graphql.QueryOptions<Query_Pois> {
  Options_Query_Pois({
    String? operationName,
    Variables_Query_Pois? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Pois? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Pois? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
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
                 data == null ? null : _parserFn_Query_Pois(data),
               ),
         onError: onError,
         document: documentNodeQueryPois,
         parserFn: _parserFn_Query_Pois,
       );

  final OnQueryComplete_Query_Pois? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Pois extends graphql.WatchQueryOptions<Query_Pois> {
  WatchOptions_Query_Pois({
    String? operationName,
    Variables_Query_Pois? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Pois? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryPois,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Pois,
       );
}

class FetchMoreOptions_Query_Pois extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Pois({
    required graphql.UpdateQuery updateQuery,
    Variables_Query_Pois? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryPois,
       );
}

extension ClientExtension_Query_Pois on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Pois>> query_Pois([
    Options_Query_Pois? options,
  ]) async => await this.query(options ?? Options_Query_Pois());

  graphql.ObservableQuery<Query_Pois> watchQuery_Pois([
    WatchOptions_Query_Pois? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_Pois());

  void writeQuery_Pois({
    required Query_Pois data,
    Variables_Query_Pois? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryPois),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Pois? readQuery_Pois({
    Variables_Query_Pois? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryPois),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Pois.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Pois> useQuery_Pois([
  Options_Query_Pois? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_Pois());
graphql.ObservableQuery<Query_Pois> useWatchQuery_Pois([
  WatchOptions_Query_Pois? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_Pois());

class Query_Pois_Widget extends graphql_flutter.Query<Query_Pois> {
  Query_Pois_Widget({
    widgets.Key? key,
    Options_Query_Pois? options,
    required graphql_flutter.QueryBuilder<Query_Pois> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_Pois(),
         builder: builder,
       );
}

class Query_Pois_pois {
  Query_Pois_pois({required this.docs, this.$__typename = 'Pois'});

  factory Query_Pois_pois.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_Pois_pois(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_Pois_pois_docs.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_Pois_pois_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Pois_pois || runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
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

extension UtilityExtension_Query_Pois_pois on Query_Pois_pois {
  CopyWith_Query_Pois_pois<Query_Pois_pois> get copyWith =>
      CopyWith_Query_Pois_pois(this, (i) => i);
}

abstract class CopyWith_Query_Pois_pois<TRes> {
  factory CopyWith_Query_Pois_pois(
    Query_Pois_pois instance,
    TRes Function(Query_Pois_pois) then,
  ) = _CopyWithImpl_Query_Pois_pois;

  factory CopyWith_Query_Pois_pois.stub(TRes res) =
      _CopyWithStubImpl_Query_Pois_pois;

  TRes call({List<Query_Pois_pois_docs>? docs, String? $__typename});
  TRes docs(
    Iterable<Query_Pois_pois_docs> Function(
      Iterable<CopyWith_Query_Pois_pois_docs<Query_Pois_pois_docs>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Pois_pois<TRes>
    implements CopyWith_Query_Pois_pois<TRes> {
  _CopyWithImpl_Query_Pois_pois(this._instance, this._then);

  final Query_Pois_pois _instance;

  final TRes Function(Query_Pois_pois) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Pois_pois(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_Pois_pois_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_Pois_pois_docs> Function(
      Iterable<CopyWith_Query_Pois_pois_docs<Query_Pois_pois_docs>>,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map((e) => CopyWith_Query_Pois_pois_docs(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Pois_pois<TRes>
    implements CopyWith_Query_Pois_pois<TRes> {
  _CopyWithStubImpl_Query_Pois_pois(this._res);

  TRes _res;

  call({List<Query_Pois_pois_docs>? docs, String? $__typename}) => _res;

  docs(_fn) => _res;
}

class Query_Pois_pois_docs {
  Query_Pois_pois_docs({
    required this.id,
    required this.position,
    this.category,
    this.$__typename = 'Poi',
  });

  factory Query_Pois_pois_docs.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$position = json['position'];
    final l$category = json['category'];
    final l$$__typename = json['__typename'];
    return Query_Pois_pois_docs(
      id: (l$id as String),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      category: l$category == null
          ? null
          : Query_Pois_pois_docs_category.fromJson(
              (l$category as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<double> position;

  final Query_Pois_pois_docs_category? category;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$category = category;
    _resultData['category'] = l$category?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$position = position;
    final l$category = category;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$position.map((v) => v)),
      l$category,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Pois_pois_docs || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position.length != lOther$position.length) {
      return false;
    }
    for (int i = 0; i < l$position.length; i++) {
      final l$position$entry = l$position[i];
      final lOther$position$entry = lOther$position[i];
      if (l$position$entry != lOther$position$entry) {
        return false;
      }
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
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

extension UtilityExtension_Query_Pois_pois_docs on Query_Pois_pois_docs {
  CopyWith_Query_Pois_pois_docs<Query_Pois_pois_docs> get copyWith =>
      CopyWith_Query_Pois_pois_docs(this, (i) => i);
}

abstract class CopyWith_Query_Pois_pois_docs<TRes> {
  factory CopyWith_Query_Pois_pois_docs(
    Query_Pois_pois_docs instance,
    TRes Function(Query_Pois_pois_docs) then,
  ) = _CopyWithImpl_Query_Pois_pois_docs;

  factory CopyWith_Query_Pois_pois_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_Pois_pois_docs;

  TRes call({
    String? id,
    List<double>? position,
    Query_Pois_pois_docs_category? category,
    String? $__typename,
  });
  CopyWith_Query_Pois_pois_docs_category<TRes> get category;
}

class _CopyWithImpl_Query_Pois_pois_docs<TRes>
    implements CopyWith_Query_Pois_pois_docs<TRes> {
  _CopyWithImpl_Query_Pois_pois_docs(this._instance, this._then);

  final Query_Pois_pois_docs _instance;

  final TRes Function(Query_Pois_pois_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? position = _undefined,
    Object? category = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Pois_pois_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      category: category == _undefined
          ? _instance.category
          : (category as Query_Pois_pois_docs_category?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Pois_pois_docs_category<TRes> get category {
    final local$category = _instance.category;
    return local$category == null
        ? CopyWith_Query_Pois_pois_docs_category.stub(_then(_instance))
        : CopyWith_Query_Pois_pois_docs_category(
            local$category,
            (e) => call(category: e),
          );
  }
}

class _CopyWithStubImpl_Query_Pois_pois_docs<TRes>
    implements CopyWith_Query_Pois_pois_docs<TRes> {
  _CopyWithStubImpl_Query_Pois_pois_docs(this._res);

  TRes _res;

  call({
    String? id,
    List<double>? position,
    Query_Pois_pois_docs_category? category,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Pois_pois_docs_category<TRes> get category =>
      CopyWith_Query_Pois_pois_docs_category.stub(_res);
}

class Query_Pois_pois_docs_category {
  Query_Pois_pois_docs_category({
    required this.id,
    this.icon,
    this.$__typename = 'PoiCategory',
  });

  factory Query_Pois_pois_docs_category.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query_Pois_pois_docs_category(
      id: (l$id as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Fragment_PoiIcon? icon;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$icon = icon;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$icon, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Pois_pois_docs_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
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

extension UtilityExtension_Query_Pois_pois_docs_category
    on Query_Pois_pois_docs_category {
  CopyWith_Query_Pois_pois_docs_category<Query_Pois_pois_docs_category>
  get copyWith => CopyWith_Query_Pois_pois_docs_category(this, (i) => i);
}

abstract class CopyWith_Query_Pois_pois_docs_category<TRes> {
  factory CopyWith_Query_Pois_pois_docs_category(
    Query_Pois_pois_docs_category instance,
    TRes Function(Query_Pois_pois_docs_category) then,
  ) = _CopyWithImpl_Query_Pois_pois_docs_category;

  factory CopyWith_Query_Pois_pois_docs_category.stub(TRes res) =
      _CopyWithStubImpl_Query_Pois_pois_docs_category;

  TRes call({String? id, Fragment_PoiIcon? icon, String? $__typename});
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Query_Pois_pois_docs_category<TRes>
    implements CopyWith_Query_Pois_pois_docs_category<TRes> {
  _CopyWithImpl_Query_Pois_pois_docs_category(this._instance, this._then);

  final Query_Pois_pois_docs_category _instance;

  final TRes Function(Query_Pois_pois_docs_category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Pois_pois_docs_category(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }
}

class _CopyWithStubImpl_Query_Pois_pois_docs_category<TRes>
    implements CopyWith_Query_Pois_pois_docs_category<TRes> {
  _CopyWithStubImpl_Query_Pois_pois_docs_category(this._res);

  TRes _res;

  call({String? id, Fragment_PoiIcon? icon, String? $__typename}) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}

class Variables_Query_PoiSearch {
  factory Variables_Query_PoiSearch({
    required String name,
    required dynamic kommuneId,
  }) => Variables_Query_PoiSearch._({r'name': name, r'kommuneId': kommuneId});

  Variables_Query_PoiSearch._(this._$data);

  factory Variables_Query_PoiSearch.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as dynamic);
    return Variables_Query_PoiSearch._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  dynamic get kommuneId => (_$data['kommuneId'] as dynamic);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_PoiSearch<Variables_Query_PoiSearch> get copyWith =>
      CopyWith_Variables_Query_PoiSearch(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_PoiSearch ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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
    final l$name = name;
    final l$kommuneId = kommuneId;
    return Object.hashAll([l$name, l$kommuneId]);
  }
}

abstract class CopyWith_Variables_Query_PoiSearch<TRes> {
  factory CopyWith_Variables_Query_PoiSearch(
    Variables_Query_PoiSearch instance,
    TRes Function(Variables_Query_PoiSearch) then,
  ) = _CopyWithImpl_Variables_Query_PoiSearch;

  factory CopyWith_Variables_Query_PoiSearch.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_PoiSearch;

  TRes call({String? name, dynamic? kommuneId});
}

class _CopyWithImpl_Variables_Query_PoiSearch<TRes>
    implements CopyWith_Variables_Query_PoiSearch<TRes> {
  _CopyWithImpl_Variables_Query_PoiSearch(this._instance, this._then);

  final Variables_Query_PoiSearch _instance;

  final TRes Function(Variables_Query_PoiSearch) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? kommuneId = _undefined}) =>
      _then(
        Variables_Query_PoiSearch._({
          ..._instance._$data,
          if (name != _undefined && name != null) 'name': (name as String),
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as dynamic),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_PoiSearch<TRes>
    implements CopyWith_Variables_Query_PoiSearch<TRes> {
  _CopyWithStubImpl_Variables_Query_PoiSearch(this._res);

  TRes _res;

  call({String? name, dynamic? kommuneId}) => _res;
}

class Query_PoiSearch {
  Query_PoiSearch({
    this.pois,
    required this.sensoren,
    this.$__typename = 'Query',
  });

  factory Query_PoiSearch.fromJson(Map<String, dynamic> json) {
    final l$pois = json['pois'];
    final l$sensoren = json['sensoren'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch(
      pois: l$pois == null
          ? null
          : Query_PoiSearch_pois.fromJson((l$pois as Map<String, dynamic>)),
      sensoren: Query_PoiSearch_sensoren.fromJson(
        (l$sensoren as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_PoiSearch_pois? pois;

  final Query_PoiSearch_sensoren sensoren;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$pois = pois;
    _resultData['pois'] = l$pois?.toJson();
    final l$sensoren = sensoren;
    _resultData['sensoren'] = l$sensoren.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$pois = pois;
    final l$sensoren = sensoren;
    final l$$__typename = $__typename;
    return Object.hashAll([l$pois, l$sensoren, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch || runtimeType != other.runtimeType) {
      return false;
    }
    final l$pois = pois;
    final lOther$pois = other.pois;
    if (l$pois != lOther$pois) {
      return false;
    }
    final l$sensoren = sensoren;
    final lOther$sensoren = other.sensoren;
    if (l$sensoren != lOther$sensoren) {
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

extension UtilityExtension_Query_PoiSearch on Query_PoiSearch {
  CopyWith_Query_PoiSearch<Query_PoiSearch> get copyWith =>
      CopyWith_Query_PoiSearch(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch<TRes> {
  factory CopyWith_Query_PoiSearch(
    Query_PoiSearch instance,
    TRes Function(Query_PoiSearch) then,
  ) = _CopyWithImpl_Query_PoiSearch;

  factory CopyWith_Query_PoiSearch.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch;

  TRes call({
    Query_PoiSearch_pois? pois,
    Query_PoiSearch_sensoren? sensoren,
    String? $__typename,
  });
  CopyWith_Query_PoiSearch_pois<TRes> get pois;
  CopyWith_Query_PoiSearch_sensoren<TRes> get sensoren;
}

class _CopyWithImpl_Query_PoiSearch<TRes>
    implements CopyWith_Query_PoiSearch<TRes> {
  _CopyWithImpl_Query_PoiSearch(this._instance, this._then);

  final Query_PoiSearch _instance;

  final TRes Function(Query_PoiSearch) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? pois = _undefined,
    Object? sensoren = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch(
      pois: pois == _undefined
          ? _instance.pois
          : (pois as Query_PoiSearch_pois?),
      sensoren: sensoren == _undefined || sensoren == null
          ? _instance.sensoren
          : (sensoren as Query_PoiSearch_sensoren),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_PoiSearch_pois<TRes> get pois {
    final local$pois = _instance.pois;
    return local$pois == null
        ? CopyWith_Query_PoiSearch_pois.stub(_then(_instance))
        : CopyWith_Query_PoiSearch_pois(local$pois, (e) => call(pois: e));
  }

  CopyWith_Query_PoiSearch_sensoren<TRes> get sensoren {
    final local$sensoren = _instance.sensoren;
    return CopyWith_Query_PoiSearch_sensoren(
      local$sensoren,
      (e) => call(sensoren: e),
    );
  }
}

class _CopyWithStubImpl_Query_PoiSearch<TRes>
    implements CopyWith_Query_PoiSearch<TRes> {
  _CopyWithStubImpl_Query_PoiSearch(this._res);

  TRes _res;

  call({
    Query_PoiSearch_pois? pois,
    Query_PoiSearch_sensoren? sensoren,
    String? $__typename,
  }) => _res;

  CopyWith_Query_PoiSearch_pois<TRes> get pois =>
      CopyWith_Query_PoiSearch_pois.stub(_res);

  CopyWith_Query_PoiSearch_sensoren<TRes> get sensoren =>
      CopyWith_Query_PoiSearch_sensoren.stub(_res);
}

const documentNodeQueryPoiSearch = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PoiSearch'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'name')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'pois'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'AND'),
                      value: ListValueNode(
                        values: [
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'kommune'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'equals'),
                                      value: VariableNode(
                                        name: NameNode(value: 'kommuneId'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'title'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'contains'),
                                      value: VariableNode(
                                        name: NameNode(value: 'name'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '10'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
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
                        name: NameNode(value: 'title'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'position'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'category'),
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
                              name: NameNode(value: 'title'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'icon'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'PoiIcon'),
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
            name: NameNode(value: 'sensoren'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'AND'),
                      value: ListValueNode(
                        values: [
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'kommune'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'equals'),
                                      value: VariableNode(
                                        name: NameNode(value: 'kommuneId'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'titel'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'contains'),
                                      value: VariableNode(
                                        name: NameNode(value: 'name'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ObjectFieldNode(
                                name: NameNode(value: 'shownInApp'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'equals'),
                                      value: BooleanValueNode(value: true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '10'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'docs'),
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
                        name: NameNode(value: 'position'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'titel'),
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
                        name: NameNode(value: 'icon'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'PoiIcon'),
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
                        name: NameNode(value: 'felder'),
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
                              name: NameNode(value: 'werteart'),
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
                                    name: NameNode(value: 'icon'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: SelectionSetNode(
                                      selections: [
                                        FragmentSpreadNode(
                                          name: NameNode(value: 'PoiIcon'),
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
    fragmentDefinitionPoiIcon,
  ],
);
Query_PoiSearch _parserFn_Query_PoiSearch(Map<String, dynamic> data) =>
    Query_PoiSearch.fromJson(data);
typedef OnQueryComplete_Query_PoiSearch =
    FutureOr<void> Function(Map<String, dynamic>?, Query_PoiSearch?);

class Options_Query_PoiSearch extends graphql.QueryOptions<Query_PoiSearch> {
  Options_Query_PoiSearch({
    String? operationName,
    required Variables_Query_PoiSearch variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_PoiSearch? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_PoiSearch? onComplete,
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
                 data == null ? null : _parserFn_Query_PoiSearch(data),
               ),
         onError: onError,
         document: documentNodeQueryPoiSearch,
         parserFn: _parserFn_Query_PoiSearch,
       );

  final OnQueryComplete_Query_PoiSearch? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_PoiSearch
    extends graphql.WatchQueryOptions<Query_PoiSearch> {
  WatchOptions_Query_PoiSearch({
    String? operationName,
    required Variables_Query_PoiSearch variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_PoiSearch? typedOptimisticResult,
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
         document: documentNodeQueryPoiSearch,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_PoiSearch,
       );
}

class FetchMoreOptions_Query_PoiSearch extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_PoiSearch({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_PoiSearch variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryPoiSearch,
       );
}

extension ClientExtension_Query_PoiSearch on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_PoiSearch>> query_PoiSearch(
    Options_Query_PoiSearch options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_PoiSearch> watchQuery_PoiSearch(
    WatchOptions_Query_PoiSearch options,
  ) => this.watchQuery(options);

  void writeQuery_PoiSearch({
    required Query_PoiSearch data,
    required Variables_Query_PoiSearch variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryPoiSearch),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_PoiSearch? readQuery_PoiSearch({
    required Variables_Query_PoiSearch variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryPoiSearch),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_PoiSearch.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_PoiSearch> useQuery_PoiSearch(
  Options_Query_PoiSearch options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_PoiSearch> useWatchQuery_PoiSearch(
  WatchOptions_Query_PoiSearch options,
) => graphql_flutter.useWatchQuery(options);

class Query_PoiSearch_Widget extends graphql_flutter.Query<Query_PoiSearch> {
  Query_PoiSearch_Widget({
    widgets.Key? key,
    required Options_Query_PoiSearch options,
    required graphql_flutter.QueryBuilder<Query_PoiSearch> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_PoiSearch_pois {
  Query_PoiSearch_pois({required this.docs, this.$__typename = 'Pois'});

  factory Query_PoiSearch_pois.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_pois(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Query_PoiSearch_pois_docs.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_PoiSearch_pois_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_pois || runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
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

extension UtilityExtension_Query_PoiSearch_pois on Query_PoiSearch_pois {
  CopyWith_Query_PoiSearch_pois<Query_PoiSearch_pois> get copyWith =>
      CopyWith_Query_PoiSearch_pois(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_pois<TRes> {
  factory CopyWith_Query_PoiSearch_pois(
    Query_PoiSearch_pois instance,
    TRes Function(Query_PoiSearch_pois) then,
  ) = _CopyWithImpl_Query_PoiSearch_pois;

  factory CopyWith_Query_PoiSearch_pois.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_pois;

  TRes call({List<Query_PoiSearch_pois_docs>? docs, String? $__typename});
  TRes docs(
    Iterable<Query_PoiSearch_pois_docs> Function(
      Iterable<CopyWith_Query_PoiSearch_pois_docs<Query_PoiSearch_pois_docs>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_PoiSearch_pois<TRes>
    implements CopyWith_Query_PoiSearch_pois<TRes> {
  _CopyWithImpl_Query_PoiSearch_pois(this._instance, this._then);

  final Query_PoiSearch_pois _instance;

  final TRes Function(Query_PoiSearch_pois) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_PoiSearch_pois(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_PoiSearch_pois_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_PoiSearch_pois_docs> Function(
      Iterable<CopyWith_Query_PoiSearch_pois_docs<Query_PoiSearch_pois_docs>>,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_PoiSearch_pois_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_PoiSearch_pois<TRes>
    implements CopyWith_Query_PoiSearch_pois<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_pois(this._res);

  TRes _res;

  call({List<Query_PoiSearch_pois_docs>? docs, String? $__typename}) => _res;

  docs(_fn) => _res;
}

class Query_PoiSearch_pois_docs {
  Query_PoiSearch_pois_docs({
    required this.id,
    required this.title,
    required this.position,
    this.category,
    this.$__typename = 'Poi',
  });

  factory Query_PoiSearch_pois_docs.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$position = json['position'];
    final l$category = json['category'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_pois_docs(
      id: (l$id as String),
      title: (l$title as String),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      category: l$category == null
          ? null
          : Query_PoiSearch_pois_docs_category.fromJson(
              (l$category as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final List<double> position;

  final Query_PoiSearch_pois_docs_category? category;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$category = category;
    _resultData['category'] = l$category?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$position = position;
    final l$category = category;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      Object.hashAll(l$position.map((v) => v)),
      l$category,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_pois_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position.length != lOther$position.length) {
      return false;
    }
    for (int i = 0; i < l$position.length; i++) {
      final l$position$entry = l$position[i];
      final lOther$position$entry = lOther$position[i];
      if (l$position$entry != lOther$position$entry) {
        return false;
      }
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != lOther$category) {
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

extension UtilityExtension_Query_PoiSearch_pois_docs
    on Query_PoiSearch_pois_docs {
  CopyWith_Query_PoiSearch_pois_docs<Query_PoiSearch_pois_docs> get copyWith =>
      CopyWith_Query_PoiSearch_pois_docs(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_pois_docs<TRes> {
  factory CopyWith_Query_PoiSearch_pois_docs(
    Query_PoiSearch_pois_docs instance,
    TRes Function(Query_PoiSearch_pois_docs) then,
  ) = _CopyWithImpl_Query_PoiSearch_pois_docs;

  factory CopyWith_Query_PoiSearch_pois_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_pois_docs;

  TRes call({
    String? id,
    String? title,
    List<double>? position,
    Query_PoiSearch_pois_docs_category? category,
    String? $__typename,
  });
  CopyWith_Query_PoiSearch_pois_docs_category<TRes> get category;
}

class _CopyWithImpl_Query_PoiSearch_pois_docs<TRes>
    implements CopyWith_Query_PoiSearch_pois_docs<TRes> {
  _CopyWithImpl_Query_PoiSearch_pois_docs(this._instance, this._then);

  final Query_PoiSearch_pois_docs _instance;

  final TRes Function(Query_PoiSearch_pois_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? position = _undefined,
    Object? category = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch_pois_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      category: category == _undefined
          ? _instance.category
          : (category as Query_PoiSearch_pois_docs_category?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_PoiSearch_pois_docs_category<TRes> get category {
    final local$category = _instance.category;
    return local$category == null
        ? CopyWith_Query_PoiSearch_pois_docs_category.stub(_then(_instance))
        : CopyWith_Query_PoiSearch_pois_docs_category(
            local$category,
            (e) => call(category: e),
          );
  }
}

class _CopyWithStubImpl_Query_PoiSearch_pois_docs<TRes>
    implements CopyWith_Query_PoiSearch_pois_docs<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_pois_docs(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    List<double>? position,
    Query_PoiSearch_pois_docs_category? category,
    String? $__typename,
  }) => _res;

  CopyWith_Query_PoiSearch_pois_docs_category<TRes> get category =>
      CopyWith_Query_PoiSearch_pois_docs_category.stub(_res);
}

class Query_PoiSearch_pois_docs_category {
  Query_PoiSearch_pois_docs_category({
    required this.id,
    required this.title,
    this.icon,
    this.$__typename = 'PoiCategory',
  });

  factory Query_PoiSearch_pois_docs_category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_pois_docs_category(
      id: (l$id as String),
      title: (l$title as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final Fragment_PoiIcon? icon;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$icon = icon;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$title, l$icon, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_pois_docs_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
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

extension UtilityExtension_Query_PoiSearch_pois_docs_category
    on Query_PoiSearch_pois_docs_category {
  CopyWith_Query_PoiSearch_pois_docs_category<
    Query_PoiSearch_pois_docs_category
  >
  get copyWith => CopyWith_Query_PoiSearch_pois_docs_category(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_pois_docs_category<TRes> {
  factory CopyWith_Query_PoiSearch_pois_docs_category(
    Query_PoiSearch_pois_docs_category instance,
    TRes Function(Query_PoiSearch_pois_docs_category) then,
  ) = _CopyWithImpl_Query_PoiSearch_pois_docs_category;

  factory CopyWith_Query_PoiSearch_pois_docs_category.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_pois_docs_category;

  TRes call({
    String? id,
    String? title,
    Fragment_PoiIcon? icon,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Query_PoiSearch_pois_docs_category<TRes>
    implements CopyWith_Query_PoiSearch_pois_docs_category<TRes> {
  _CopyWithImpl_Query_PoiSearch_pois_docs_category(this._instance, this._then);

  final Query_PoiSearch_pois_docs_category _instance;

  final TRes Function(Query_PoiSearch_pois_docs_category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch_pois_docs_category(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }
}

class _CopyWithStubImpl_Query_PoiSearch_pois_docs_category<TRes>
    implements CopyWith_Query_PoiSearch_pois_docs_category<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_pois_docs_category(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    Fragment_PoiIcon? icon,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}

class Query_PoiSearch_sensoren {
  Query_PoiSearch_sensoren({
    required this.docs,
    this.$__typename = 'Sensorens',
  });

  factory Query_PoiSearch_sensoren.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_sensoren(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_PoiSearch_sensoren_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_PoiSearch_sensoren_docs> docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_sensoren ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs.length != lOther$docs.length) {
      return false;
    }
    for (int i = 0; i < l$docs.length; i++) {
      final l$docs$entry = l$docs[i];
      final lOther$docs$entry = lOther$docs[i];
      if (l$docs$entry != lOther$docs$entry) {
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

extension UtilityExtension_Query_PoiSearch_sensoren
    on Query_PoiSearch_sensoren {
  CopyWith_Query_PoiSearch_sensoren<Query_PoiSearch_sensoren> get copyWith =>
      CopyWith_Query_PoiSearch_sensoren(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_sensoren<TRes> {
  factory CopyWith_Query_PoiSearch_sensoren(
    Query_PoiSearch_sensoren instance,
    TRes Function(Query_PoiSearch_sensoren) then,
  ) = _CopyWithImpl_Query_PoiSearch_sensoren;

  factory CopyWith_Query_PoiSearch_sensoren.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_sensoren;

  TRes call({List<Query_PoiSearch_sensoren_docs>? docs, String? $__typename});
  TRes docs(
    Iterable<Query_PoiSearch_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_PoiSearch_sensoren_docs<Query_PoiSearch_sensoren_docs>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_PoiSearch_sensoren<TRes>
    implements CopyWith_Query_PoiSearch_sensoren<TRes> {
  _CopyWithImpl_Query_PoiSearch_sensoren(this._instance, this._then);

  final Query_PoiSearch_sensoren _instance;

  final TRes Function(Query_PoiSearch_sensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_PoiSearch_sensoren(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_PoiSearch_sensoren_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_PoiSearch_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_PoiSearch_sensoren_docs<Query_PoiSearch_sensoren_docs>
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_PoiSearch_sensoren_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_PoiSearch_sensoren<TRes>
    implements CopyWith_Query_PoiSearch_sensoren<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_sensoren(this._res);

  TRes _res;

  call({List<Query_PoiSearch_sensoren_docs>? docs, String? $__typename}) =>
      _res;

  docs(_fn) => _res;
}

class Query_PoiSearch_sensoren_docs {
  Query_PoiSearch_sensoren_docs({
    required this.id,
    required this.position,
    this.titel,
    required this.name,
    this.icon,
    this.felder,
    this.$__typename = 'Sensoren',
  });

  factory Query_PoiSearch_sensoren_docs.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$position = json['position'];
    final l$titel = json['titel'];
    final l$name = json['name'];
    final l$icon = json['icon'];
    final l$felder = json['felder'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_sensoren_docs(
      id: (l$id as String),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      titel: (l$titel as String?),
      name: (l$name as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      felder: (l$felder as List<dynamic>?)
          ?.map(
            (e) => Query_PoiSearch_sensoren_docs_felder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<double> position;

  final String? titel;

  final String name;

  final Fragment_PoiIcon? icon;

  final List<Query_PoiSearch_sensoren_docs_felder>? felder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$felder = felder;
    _resultData['felder'] = l$felder?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$position = position;
    final l$titel = titel;
    final l$name = name;
    final l$icon = icon;
    final l$felder = felder;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$position.map((v) => v)),
      l$titel,
      l$name,
      l$icon,
      l$felder == null ? null : Object.hashAll(l$felder.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_sensoren_docs ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position.length != lOther$position.length) {
      return false;
    }
    for (int i = 0; i < l$position.length; i++) {
      final l$position$entry = l$position[i];
      final lOther$position$entry = lOther$position[i];
      if (l$position$entry != lOther$position$entry) {
        return false;
      }
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
      return false;
    }
    final l$felder = felder;
    final lOther$felder = other.felder;
    if (l$felder != null && lOther$felder != null) {
      if (l$felder.length != lOther$felder.length) {
        return false;
      }
      for (int i = 0; i < l$felder.length; i++) {
        final l$felder$entry = l$felder[i];
        final lOther$felder$entry = lOther$felder[i];
        if (l$felder$entry != lOther$felder$entry) {
          return false;
        }
      }
    } else if (l$felder != lOther$felder) {
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

extension UtilityExtension_Query_PoiSearch_sensoren_docs
    on Query_PoiSearch_sensoren_docs {
  CopyWith_Query_PoiSearch_sensoren_docs<Query_PoiSearch_sensoren_docs>
  get copyWith => CopyWith_Query_PoiSearch_sensoren_docs(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_sensoren_docs<TRes> {
  factory CopyWith_Query_PoiSearch_sensoren_docs(
    Query_PoiSearch_sensoren_docs instance,
    TRes Function(Query_PoiSearch_sensoren_docs) then,
  ) = _CopyWithImpl_Query_PoiSearch_sensoren_docs;

  factory CopyWith_Query_PoiSearch_sensoren_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_sensoren_docs;

  TRes call({
    String? id,
    List<double>? position,
    String? titel,
    String? name,
    Fragment_PoiIcon? icon,
    List<Query_PoiSearch_sensoren_docs_felder>? felder,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  TRes felder(
    Iterable<Query_PoiSearch_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_PoiSearch_sensoren_docs_felder<
          Query_PoiSearch_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_PoiSearch_sensoren_docs<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs<TRes> {
  _CopyWithImpl_Query_PoiSearch_sensoren_docs(this._instance, this._then);

  final Query_PoiSearch_sensoren_docs _instance;

  final TRes Function(Query_PoiSearch_sensoren_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? position = _undefined,
    Object? titel = _undefined,
    Object? name = _undefined,
    Object? icon = _undefined,
    Object? felder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch_sensoren_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      felder: felder == _undefined
          ? _instance.felder
          : (felder as List<Query_PoiSearch_sensoren_docs_felder>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }

  TRes felder(
    Iterable<Query_PoiSearch_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_PoiSearch_sensoren_docs_felder<
          Query_PoiSearch_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder?.map(
        (e) => CopyWith_Query_PoiSearch_sensoren_docs_felder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_PoiSearch_sensoren_docs<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_sensoren_docs(this._res);

  TRes _res;

  call({
    String? id,
    List<double>? position,
    String? titel,
    String? name,
    Fragment_PoiIcon? icon,
    List<Query_PoiSearch_sensoren_docs_felder>? felder,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  felder(_fn) => _res;
}

class Query_PoiSearch_sensoren_docs_felder {
  Query_PoiSearch_sensoren_docs_felder({
    this.id,
    this.werteart,
    this.$__typename = 'Sensoren_Felder',
  });

  factory Query_PoiSearch_sensoren_docs_felder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$werteart = json['werteart'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_sensoren_docs_felder(
      id: (l$id as String?),
      werteart: l$werteart == null
          ? null
          : Query_PoiSearch_sensoren_docs_felder_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final Query_PoiSearch_sensoren_docs_felder_werteart? werteart;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$werteart = werteart;
    _resultData['werteart'] = l$werteart?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$werteart = werteart;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$werteart, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_sensoren_docs_felder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$werteart = werteart;
    final lOther$werteart = other.werteart;
    if (l$werteart != lOther$werteart) {
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

extension UtilityExtension_Query_PoiSearch_sensoren_docs_felder
    on Query_PoiSearch_sensoren_docs_felder {
  CopyWith_Query_PoiSearch_sensoren_docs_felder<
    Query_PoiSearch_sensoren_docs_felder
  >
  get copyWith => CopyWith_Query_PoiSearch_sensoren_docs_felder(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_sensoren_docs_felder<TRes> {
  factory CopyWith_Query_PoiSearch_sensoren_docs_felder(
    Query_PoiSearch_sensoren_docs_felder instance,
    TRes Function(Query_PoiSearch_sensoren_docs_felder) then,
  ) = _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder;

  factory CopyWith_Query_PoiSearch_sensoren_docs_felder.stub(TRes res) =
      _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder;

  TRes call({
    String? id,
    Query_PoiSearch_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
  });
  CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> get werteart;
}

class _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs_felder<TRes> {
  _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder(
    this._instance,
    this._then,
  );

  final Query_PoiSearch_sensoren_docs_felder _instance;

  final TRes Function(Query_PoiSearch_sensoren_docs_felder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? werteart = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch_sensoren_docs_felder(
      id: id == _undefined ? _instance.id : (id as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Query_PoiSearch_sensoren_docs_felder_werteart?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart.stub(
            _then(_instance),
          )
        : CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }
}

class _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs_felder<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder(this._res);

  TRes _res;

  call({
    String? id,
    Query_PoiSearch_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
  }) => _res;

  CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> get werteart =>
      CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart.stub(_res);
}

class Query_PoiSearch_sensoren_docs_felder_werteart {
  Query_PoiSearch_sensoren_docs_felder_werteart({
    required this.id,
    this.icon,
    this.$__typename = 'SensorArt',
  });

  factory Query_PoiSearch_sensoren_docs_felder_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query_PoiSearch_sensoren_docs_felder_werteart(
      id: (l$id as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Fragment_PoiIcon? icon;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$icon = icon;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$icon, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_PoiSearch_sensoren_docs_felder_werteart ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
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

extension UtilityExtension_Query_PoiSearch_sensoren_docs_felder_werteart
    on Query_PoiSearch_sensoren_docs_felder_werteart {
  CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<
    Query_PoiSearch_sensoren_docs_felder_werteart
  >
  get copyWith =>
      CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart(this, (i) => i);
}

abstract class CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> {
  factory CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart(
    Query_PoiSearch_sensoren_docs_felder_werteart instance,
    TRes Function(Query_PoiSearch_sensoren_docs_felder_werteart) then,
  ) = _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder_werteart;

  factory CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder_werteart;

  TRes call({String? id, Fragment_PoiIcon? icon, String? $__typename});
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> {
  _CopyWithImpl_Query_PoiSearch_sensoren_docs_felder_werteart(
    this._instance,
    this._then,
  );

  final Query_PoiSearch_sensoren_docs_felder_werteart _instance;

  final TRes Function(Query_PoiSearch_sensoren_docs_felder_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_PoiSearch_sensoren_docs_felder_werteart(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }
}

class _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_PoiSearch_sensoren_docs_felder_werteart<TRes> {
  _CopyWithStubImpl_Query_PoiSearch_sensoren_docs_felder_werteart(this._res);

  TRes _res;

  call({String? id, Fragment_PoiIcon? icon, String? $__typename}) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}
