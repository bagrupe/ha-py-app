import 'dart:async';
import 'kommune.graphql.dart';
import 'package:app/common/expressions/expression.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_ProzessOwnData {
  Fragment_ProzessOwnData({
    required this.id,
    required this.name,
    required this.tags,
    this.$__typename = 'Prozess',
  });

  factory Fragment_ProzessOwnData.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    return Fragment_ProzessOwnData(
      id: (l$id as String),
      name: (l$name as String),
      tags: (l$tags as List<dynamic>)
          .map(
            (e) => Fragment_ProzessOwnData_tags.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment_ProzessOwnData_tags> tags;

  final String $__typename;

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
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$tags = tags;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_ProzessOwnData || runtimeType != other.runtimeType) {
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
    return true;
  }
}

extension UtilityExtension_Fragment_ProzessOwnData on Fragment_ProzessOwnData {
  CopyWith_Fragment_ProzessOwnData<Fragment_ProzessOwnData> get copyWith =>
      CopyWith_Fragment_ProzessOwnData(this, (i) => i);
}

abstract class CopyWith_Fragment_ProzessOwnData<TRes> {
  factory CopyWith_Fragment_ProzessOwnData(
    Fragment_ProzessOwnData instance,
    TRes Function(Fragment_ProzessOwnData) then,
  ) = _CopyWithImpl_Fragment_ProzessOwnData;

  factory CopyWith_Fragment_ProzessOwnData.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ProzessOwnData;

  TRes call({
    String? id,
    String? name,
    List<Fragment_ProzessOwnData_tags>? tags,
    String? $__typename,
  });
  TRes tags(
    Iterable<Fragment_ProzessOwnData_tags> Function(
      Iterable<
        CopyWith_Fragment_ProzessOwnData_tags<Fragment_ProzessOwnData_tags>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_ProzessOwnData<TRes>
    implements CopyWith_Fragment_ProzessOwnData<TRes> {
  _CopyWithImpl_Fragment_ProzessOwnData(this._instance, this._then);

  final Fragment_ProzessOwnData _instance;

  final TRes Function(Fragment_ProzessOwnData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? tags = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_ProzessOwnData(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags as List<Fragment_ProzessOwnData_tags>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes tags(
    Iterable<Fragment_ProzessOwnData_tags> Function(
      Iterable<
        CopyWith_Fragment_ProzessOwnData_tags<Fragment_ProzessOwnData_tags>
      >,
    )
    _fn,
  ) => call(
    tags: _fn(
      _instance.tags.map(
        (e) => CopyWith_Fragment_ProzessOwnData_tags(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_ProzessOwnData<TRes>
    implements CopyWith_Fragment_ProzessOwnData<TRes> {
  _CopyWithStubImpl_Fragment_ProzessOwnData(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment_ProzessOwnData_tags>? tags,
    String? $__typename,
  }) => _res;

  tags(_fn) => _res;
}

const fragmentDefinitionProzessOwnData = FragmentDefinitionNode(
  name: NameNode(value: 'ProzessOwnData'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Prozess'), isNonNull: false),
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
        name: NameNode(value: 'name'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'tags'),
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
              name: NameNode(value: 'tag'),
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
);
const documentNodeFragmentProzessOwnData = DocumentNode(
  definitions: [fragmentDefinitionProzessOwnData],
);

extension ClientExtension_Fragment_ProzessOwnData on graphql.GraphQLClient {
  void writeFragment_ProzessOwnData({
    required Fragment_ProzessOwnData data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ProzessOwnData',
        document: documentNodeFragmentProzessOwnData,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ProzessOwnData? readFragment_ProzessOwnData({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ProzessOwnData',
          document: documentNodeFragmentProzessOwnData,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_ProzessOwnData.fromJson(result);
  }
}

class Fragment_ProzessOwnData_tags {
  Fragment_ProzessOwnData_tags({
    required this.id,
    required this.tag,
    this.$__typename = 'ProzessTag',
  });

  factory Fragment_ProzessOwnData_tags.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$tag = json['tag'];
    final l$$__typename = json['__typename'];
    return Fragment_ProzessOwnData_tags(
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
    if (other is! Fragment_ProzessOwnData_tags ||
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

extension UtilityExtension_Fragment_ProzessOwnData_tags
    on Fragment_ProzessOwnData_tags {
  CopyWith_Fragment_ProzessOwnData_tags<Fragment_ProzessOwnData_tags>
  get copyWith => CopyWith_Fragment_ProzessOwnData_tags(this, (i) => i);
}

abstract class CopyWith_Fragment_ProzessOwnData_tags<TRes> {
  factory CopyWith_Fragment_ProzessOwnData_tags(
    Fragment_ProzessOwnData_tags instance,
    TRes Function(Fragment_ProzessOwnData_tags) then,
  ) = _CopyWithImpl_Fragment_ProzessOwnData_tags;

  factory CopyWith_Fragment_ProzessOwnData_tags.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ProzessOwnData_tags;

  TRes call({String? id, String? tag, String? $__typename});
}

class _CopyWithImpl_Fragment_ProzessOwnData_tags<TRes>
    implements CopyWith_Fragment_ProzessOwnData_tags<TRes> {
  _CopyWithImpl_Fragment_ProzessOwnData_tags(this._instance, this._then);

  final Fragment_ProzessOwnData_tags _instance;

  final TRes Function(Fragment_ProzessOwnData_tags) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? tag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_ProzessOwnData_tags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      tag: tag == _undefined || tag == null ? _instance.tag : (tag as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_ProzessOwnData_tags<TRes>
    implements CopyWith_Fragment_ProzessOwnData_tags<TRes> {
  _CopyWithStubImpl_Fragment_ProzessOwnData_tags(this._res);

  TRes _res;

  call({String? id, String? tag, String? $__typename}) => _res;
}

class Fragment_ProzessVersionOwnData {
  Fragment_ProzessVersionOwnData({
    required this.id,
    this.publishedAt,
    this.$__typename = 'ProzessVersion',
  });

  factory Fragment_ProzessVersionOwnData.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$$__typename = json['__typename'];
    return Fragment_ProzessVersionOwnData(
      id: (l$id as String),
      publishedAt: l$publishedAt == null
          ? null
          : DateTime.parse((l$publishedAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime? publishedAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$publishedAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_ProzessVersionOwnData ||
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
    return true;
  }
}

extension UtilityExtension_Fragment_ProzessVersionOwnData
    on Fragment_ProzessVersionOwnData {
  CopyWith_Fragment_ProzessVersionOwnData<Fragment_ProzessVersionOwnData>
  get copyWith => CopyWith_Fragment_ProzessVersionOwnData(this, (i) => i);
}

abstract class CopyWith_Fragment_ProzessVersionOwnData<TRes> {
  factory CopyWith_Fragment_ProzessVersionOwnData(
    Fragment_ProzessVersionOwnData instance,
    TRes Function(Fragment_ProzessVersionOwnData) then,
  ) = _CopyWithImpl_Fragment_ProzessVersionOwnData;

  factory CopyWith_Fragment_ProzessVersionOwnData.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ProzessVersionOwnData;

  TRes call({String? id, DateTime? publishedAt, String? $__typename});
}

class _CopyWithImpl_Fragment_ProzessVersionOwnData<TRes>
    implements CopyWith_Fragment_ProzessVersionOwnData<TRes> {
  _CopyWithImpl_Fragment_ProzessVersionOwnData(this._instance, this._then);

  final Fragment_ProzessVersionOwnData _instance;

  final TRes Function(Fragment_ProzessVersionOwnData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_ProzessVersionOwnData(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_ProzessVersionOwnData<TRes>
    implements CopyWith_Fragment_ProzessVersionOwnData<TRes> {
  _CopyWithStubImpl_Fragment_ProzessVersionOwnData(this._res);

  TRes _res;

  call({String? id, DateTime? publishedAt, String? $__typename}) => _res;
}

const fragmentDefinitionProzessVersionOwnData = FragmentDefinitionNode(
  name: NameNode(value: 'ProzessVersionOwnData'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ProzessVersion'),
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
        name: NameNode(value: 'publishedAt'),
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
);
const documentNodeFragmentProzessVersionOwnData = DocumentNode(
  definitions: [fragmentDefinitionProzessVersionOwnData],
);

extension ClientExtension_Fragment_ProzessVersionOwnData
    on graphql.GraphQLClient {
  void writeFragment_ProzessVersionOwnData({
    required Fragment_ProzessVersionOwnData data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ProzessVersionOwnData',
        document: documentNodeFragmentProzessVersionOwnData,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ProzessVersionOwnData? readFragment_ProzessVersionOwnData({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ProzessVersionOwnData',
          document: documentNodeFragmentProzessVersionOwnData,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_ProzessVersionOwnData.fromJson(result);
  }
}

class Fragment_Prozess implements Fragment_ProzessOwnData {
  Fragment_Prozess({
    required this.id,
    required this.name,
    required this.tags,
    this.$__typename = 'Prozess',
    required this.kommune,
    this.currentVersion,
  });

  factory Fragment_Prozess.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    final l$kommune = json['kommune'];
    final l$currentVersion = json['currentVersion'];
    return Fragment_Prozess(
      id: (l$id as String),
      name: (l$name as String),
      tags: (l$tags as List<dynamic>)
          .map(
            (e) => Fragment_Prozess_tags.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
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

  final String id;

  final String name;

  final List<Fragment_Prozess_tags> tags;

  final String $__typename;

  final Fragment_KommuneCrypto kommune;

  final Fragment_ProzessVersion? currentVersion;

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
    final l$currentVersion = currentVersion;
    _resultData['currentVersion'] = l$currentVersion?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$tags = tags;
    final l$$__typename = $__typename;
    final l$kommune = kommune;
    final l$currentVersion = currentVersion;
    return Object.hashAll([
      l$id,
      l$name,
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
      l$kommune,
      l$currentVersion,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Prozess || runtimeType != other.runtimeType) {
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
    final l$currentVersion = currentVersion;
    final lOther$currentVersion = other.currentVersion;
    if (l$currentVersion != lOther$currentVersion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Prozess on Fragment_Prozess {
  CopyWith_Fragment_Prozess<Fragment_Prozess> get copyWith =>
      CopyWith_Fragment_Prozess(this, (i) => i);
}

abstract class CopyWith_Fragment_Prozess<TRes> {
  factory CopyWith_Fragment_Prozess(
    Fragment_Prozess instance,
    TRes Function(Fragment_Prozess) then,
  ) = _CopyWithImpl_Fragment_Prozess;

  factory CopyWith_Fragment_Prozess.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Prozess;

  TRes call({
    String? id,
    String? name,
    List<Fragment_Prozess_tags>? tags,
    String? $__typename,
    Fragment_KommuneCrypto? kommune,
    Fragment_ProzessVersion? currentVersion,
  });
  TRes tags(
    Iterable<Fragment_Prozess_tags> Function(
      Iterable<CopyWith_Fragment_Prozess_tags<Fragment_Prozess_tags>>,
    )
    _fn,
  );
  CopyWith_Fragment_KommuneCrypto<TRes> get kommune;
  CopyWith_Fragment_ProzessVersion<TRes> get currentVersion;
}

class _CopyWithImpl_Fragment_Prozess<TRes>
    implements CopyWith_Fragment_Prozess<TRes> {
  _CopyWithImpl_Fragment_Prozess(this._instance, this._then);

  final Fragment_Prozess _instance;

  final TRes Function(Fragment_Prozess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? tags = _undefined,
    Object? $__typename = _undefined,
    Object? kommune = _undefined,
    Object? currentVersion = _undefined,
  }) => _then(
    Fragment_Prozess(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags as List<Fragment_Prozess_tags>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      kommune: kommune == _undefined || kommune == null
          ? _instance.kommune
          : (kommune as Fragment_KommuneCrypto),
      currentVersion: currentVersion == _undefined
          ? _instance.currentVersion
          : (currentVersion as Fragment_ProzessVersion?),
    ),
  );

  TRes tags(
    Iterable<Fragment_Prozess_tags> Function(
      Iterable<CopyWith_Fragment_Prozess_tags<Fragment_Prozess_tags>>,
    )
    _fn,
  ) => call(
    tags: _fn(
      _instance.tags.map((e) => CopyWith_Fragment_Prozess_tags(e, (i) => i)),
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

class _CopyWithStubImpl_Fragment_Prozess<TRes>
    implements CopyWith_Fragment_Prozess<TRes> {
  _CopyWithStubImpl_Fragment_Prozess(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment_Prozess_tags>? tags,
    String? $__typename,
    Fragment_KommuneCrypto? kommune,
    Fragment_ProzessVersion? currentVersion,
  }) => _res;

  tags(_fn) => _res;

  CopyWith_Fragment_KommuneCrypto<TRes> get kommune =>
      CopyWith_Fragment_KommuneCrypto.stub(_res);

  CopyWith_Fragment_ProzessVersion<TRes> get currentVersion =>
      CopyWith_Fragment_ProzessVersion.stub(_res);
}

const fragmentDefinitionProzess = FragmentDefinitionNode(
  name: NameNode(value: 'Prozess'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Prozess'), isNonNull: false),
  ),
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
        name: NameNode(value: 'currentVersion'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentProzess = DocumentNode(
  definitions: [
    fragmentDefinitionProzess,
    fragmentDefinitionProzessOwnData,
    fragmentDefinitionKommuneCrypto,
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
  ],
);

extension ClientExtension_Fragment_Prozess on graphql.GraphQLClient {
  void writeFragment_Prozess({
    required Fragment_Prozess data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'Prozess',
        document: documentNodeFragmentProzess,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_Prozess? readFragment_Prozess({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Prozess',
          document: documentNodeFragmentProzess,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_Prozess.fromJson(result);
  }
}

class Fragment_Prozess_tags implements Fragment_ProzessOwnData_tags {
  Fragment_Prozess_tags({
    required this.id,
    required this.tag,
    this.$__typename = 'ProzessTag',
  });

  factory Fragment_Prozess_tags.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$tag = json['tag'];
    final l$$__typename = json['__typename'];
    return Fragment_Prozess_tags(
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
    if (other is! Fragment_Prozess_tags || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_Prozess_tags on Fragment_Prozess_tags {
  CopyWith_Fragment_Prozess_tags<Fragment_Prozess_tags> get copyWith =>
      CopyWith_Fragment_Prozess_tags(this, (i) => i);
}

abstract class CopyWith_Fragment_Prozess_tags<TRes> {
  factory CopyWith_Fragment_Prozess_tags(
    Fragment_Prozess_tags instance,
    TRes Function(Fragment_Prozess_tags) then,
  ) = _CopyWithImpl_Fragment_Prozess_tags;

  factory CopyWith_Fragment_Prozess_tags.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Prozess_tags;

  TRes call({String? id, String? tag, String? $__typename});
}

class _CopyWithImpl_Fragment_Prozess_tags<TRes>
    implements CopyWith_Fragment_Prozess_tags<TRes> {
  _CopyWithImpl_Fragment_Prozess_tags(this._instance, this._then);

  final Fragment_Prozess_tags _instance;

  final TRes Function(Fragment_Prozess_tags) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? tag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Prozess_tags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      tag: tag == _undefined || tag == null ? _instance.tag : (tag as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Prozess_tags<TRes>
    implements CopyWith_Fragment_Prozess_tags<TRes> {
  _CopyWithStubImpl_Fragment_Prozess_tags(this._res);

  TRes _res;

  call({String? id, String? tag, String? $__typename}) => _res;
}

class Fragment_ProzessVersion implements Fragment_ProzessVersionOwnData {
  Fragment_ProzessVersion({
    required this.id,
    this.publishedAt,
    this.$__typename = 'ProzessVersion',
    required this.ersteSchritte,
    required this.prozess,
  });

  factory Fragment_ProzessVersion.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$$__typename = json['__typename'];
    final l$ersteSchritte = json['ersteSchritte'];
    final l$prozess = json['prozess'];
    return Fragment_ProzessVersion(
      id: (l$id as String),
      publishedAt: l$publishedAt == null
          ? null
          : DateTime.parse((l$publishedAt as String)),
      $__typename: (l$$__typename as String),
      ersteSchritte: (l$ersteSchritte as List<dynamic>)
          .map((e) => Fragment_Schritt.fromJson((e as Map<String, dynamic>)))
          .toList(),
      prozess: Fragment_ProzessOwnData.fromJson(
        (l$prozess as Map<String, dynamic>),
      ),
    );
  }

  final String id;

  final DateTime? publishedAt;

  final String $__typename;

  final List<Fragment_Schritt> ersteSchritte;

  final Fragment_ProzessOwnData prozess;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$ersteSchritte = ersteSchritte;
    _resultData['ersteSchritte'] = l$ersteSchritte
        .map((e) => e.toJson())
        .toList();
    final l$prozess = prozess;
    _resultData['prozess'] = l$prozess.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$$__typename = $__typename;
    final l$ersteSchritte = ersteSchritte;
    final l$prozess = prozess;
    return Object.hashAll([
      l$id,
      l$publishedAt,
      l$$__typename,
      Object.hashAll(l$ersteSchritte.map((v) => v)),
      l$prozess,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_ProzessVersion || runtimeType != other.runtimeType) {
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
    final l$ersteSchritte = ersteSchritte;
    final lOther$ersteSchritte = other.ersteSchritte;
    if (l$ersteSchritte.length != lOther$ersteSchritte.length) {
      return false;
    }
    for (int i = 0; i < l$ersteSchritte.length; i++) {
      final l$ersteSchritte$entry = l$ersteSchritte[i];
      final lOther$ersteSchritte$entry = lOther$ersteSchritte[i];
      if (l$ersteSchritte$entry != lOther$ersteSchritte$entry) {
        return false;
      }
    }
    final l$prozess = prozess;
    final lOther$prozess = other.prozess;
    if (l$prozess != lOther$prozess) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_ProzessVersion on Fragment_ProzessVersion {
  CopyWith_Fragment_ProzessVersion<Fragment_ProzessVersion> get copyWith =>
      CopyWith_Fragment_ProzessVersion(this, (i) => i);
}

abstract class CopyWith_Fragment_ProzessVersion<TRes> {
  factory CopyWith_Fragment_ProzessVersion(
    Fragment_ProzessVersion instance,
    TRes Function(Fragment_ProzessVersion) then,
  ) = _CopyWithImpl_Fragment_ProzessVersion;

  factory CopyWith_Fragment_ProzessVersion.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ProzessVersion;

  TRes call({
    String? id,
    DateTime? publishedAt,
    String? $__typename,
    List<Fragment_Schritt>? ersteSchritte,
    Fragment_ProzessOwnData? prozess,
  });
  TRes ersteSchritte(
    Iterable<Fragment_Schritt> Function(
      Iterable<CopyWith_Fragment_Schritt<Fragment_Schritt>>,
    )
    _fn,
  );
  CopyWith_Fragment_ProzessOwnData<TRes> get prozess;
}

class _CopyWithImpl_Fragment_ProzessVersion<TRes>
    implements CopyWith_Fragment_ProzessVersion<TRes> {
  _CopyWithImpl_Fragment_ProzessVersion(this._instance, this._then);

  final Fragment_ProzessVersion _instance;

  final TRes Function(Fragment_ProzessVersion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? $__typename = _undefined,
    Object? ersteSchritte = _undefined,
    Object? prozess = _undefined,
  }) => _then(
    Fragment_ProzessVersion(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      ersteSchritte: ersteSchritte == _undefined || ersteSchritte == null
          ? _instance.ersteSchritte
          : (ersteSchritte as List<Fragment_Schritt>),
      prozess: prozess == _undefined || prozess == null
          ? _instance.prozess
          : (prozess as Fragment_ProzessOwnData),
    ),
  );

  TRes ersteSchritte(
    Iterable<Fragment_Schritt> Function(
      Iterable<CopyWith_Fragment_Schritt<Fragment_Schritt>>,
    )
    _fn,
  ) => call(
    ersteSchritte: _fn(
      _instance.ersteSchritte.map(
        (e) => CopyWith_Fragment_Schritt(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith_Fragment_ProzessOwnData<TRes> get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Fragment_ProzessOwnData(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Fragment_ProzessVersion<TRes>
    implements CopyWith_Fragment_ProzessVersion<TRes> {
  _CopyWithStubImpl_Fragment_ProzessVersion(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? publishedAt,
    String? $__typename,
    List<Fragment_Schritt>? ersteSchritte,
    Fragment_ProzessOwnData? prozess,
  }) => _res;

  ersteSchritte(_fn) => _res;

  CopyWith_Fragment_ProzessOwnData<TRes> get prozess =>
      CopyWith_Fragment_ProzessOwnData.stub(_res);
}

const fragmentDefinitionProzessVersion = FragmentDefinitionNode(
  name: NameNode(value: 'ProzessVersion'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ProzessVersion'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FragmentSpreadNode(
        name: NameNode(value: 'ProzessVersionOwnData'),
        directives: [],
      ),
      FieldNode(
        name: NameNode(value: 'ersteSchritte'),
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
);
const documentNodeFragmentProzessVersion = DocumentNode(
  definitions: [
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
    fragmentDefinitionProzessOwnData,
  ],
);

extension ClientExtension_Fragment_ProzessVersion on graphql.GraphQLClient {
  void writeFragment_ProzessVersion({
    required Fragment_ProzessVersion data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ProzessVersion',
        document: documentNodeFragmentProzessVersion,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ProzessVersion? readFragment_ProzessVersion({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ProzessVersion',
          document: documentNodeFragmentProzessVersion,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_ProzessVersion.fromJson(result);
  }
}

class Fragment_Schritt {
  Fragment_Schritt({
    required this.id,
    required this.$__typename,
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "FormularSchritt":
        return Fragment_Schritt__FormularSchritt.fromJson(json);

      case "BezahlenSchritt":
        return Fragment_Schritt__BezahlenSchritt.fromJson(json);

      case "EmailForwarderExportSchritt":
        return Fragment_Schritt__EmailForwarderExportSchritt.fromJson(json);

      case "EndeSchritt":
        return Fragment_Schritt__EndeSchritt.fromJson(json);

      case "GovManagerRestExportSchritt":
        return Fragment_Schritt__GovManagerRestExportSchritt.fromJson(json);

      case "NachrichtSchritt":
        return Fragment_Schritt__NachrichtSchritt.fromJson(json);

      case "ProgrammatischerSchritt":
        return Fragment_Schritt__ProgrammatischerSchritt.fromJson(json);

      case "WarteAufBezahlungAbgeschlossenSchritt":
        return Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt.fromJson(
          json,
        );

      case "WarteAufGovManagerSchritt":
        return Fragment_Schritt__WarteAufGovManagerSchritt.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
        final l$titel = json['titel'];
        final l$anweisung = json['anweisung'];
        final l$slots = json['slots'];
        final l$informationstext = json['informationstext'];
        final l$verbindungen = json['verbindungen'];
        return Fragment_Schritt(
          id: (l$id as String),
          $__typename: (l$$__typename as String),
          erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
          titel: (l$titel as String?),
          anweisung: (l$anweisung as String?),
          slots: (l$slots as List<dynamic>)
              .map(
                (e) => Fragment_Schritt_slots.fromJson(
                  (e as Map<String, dynamic>),
                ),
              )
              .toList(),
          informationstext: (l$informationstext as String?),
          verbindungen: (l$verbindungen as List<dynamic>)
              .map(
                (e) => Fragment_Schritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
              )
              .toList(),
        );
    }
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt_verbindungen> verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt || runtimeType != other.runtimeType) {
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt on Fragment_Schritt {
  CopyWith_Fragment_Schritt<Fragment_Schritt> get copyWith =>
      CopyWith_Fragment_Schritt(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_Schritt__FormularSchritt) formularSchritt,
    required _T Function(Fragment_Schritt__BezahlenSchritt) bezahlenSchritt,
    required _T Function(Fragment_Schritt__EmailForwarderExportSchritt)
    emailForwarderExportSchritt,
    required _T Function(Fragment_Schritt__EndeSchritt) endeSchritt,
    required _T Function(Fragment_Schritt__GovManagerRestExportSchritt)
    govManagerRestExportSchritt,
    required _T Function(Fragment_Schritt__NachrichtSchritt) nachrichtSchritt,
    required _T Function(Fragment_Schritt__ProgrammatischerSchritt)
    programmatischerSchritt,
    required _T Function(
      Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt,
    )
    warteAufBezahlungAbgeschlossenSchritt,
    required _T Function(Fragment_Schritt__WarteAufGovManagerSchritt)
    warteAufGovManagerSchritt,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "FormularSchritt":
        return formularSchritt(this as Fragment_Schritt__FormularSchritt);

      case "BezahlenSchritt":
        return bezahlenSchritt(this as Fragment_Schritt__BezahlenSchritt);

      case "EmailForwarderExportSchritt":
        return emailForwarderExportSchritt(
          this as Fragment_Schritt__EmailForwarderExportSchritt,
        );

      case "EndeSchritt":
        return endeSchritt(this as Fragment_Schritt__EndeSchritt);

      case "GovManagerRestExportSchritt":
        return govManagerRestExportSchritt(
          this as Fragment_Schritt__GovManagerRestExportSchritt,
        );

      case "NachrichtSchritt":
        return nachrichtSchritt(this as Fragment_Schritt__NachrichtSchritt);

      case "ProgrammatischerSchritt":
        return programmatischerSchritt(
          this as Fragment_Schritt__ProgrammatischerSchritt,
        );

      case "WarteAufBezahlungAbgeschlossenSchritt":
        return warteAufBezahlungAbgeschlossenSchritt(
          this as Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt,
        );

      case "WarteAufGovManagerSchritt":
        return warteAufGovManagerSchritt(
          this as Fragment_Schritt__WarteAufGovManagerSchritt,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_Schritt__FormularSchritt)? formularSchritt,
    _T Function(Fragment_Schritt__BezahlenSchritt)? bezahlenSchritt,
    _T Function(Fragment_Schritt__EmailForwarderExportSchritt)?
    emailForwarderExportSchritt,
    _T Function(Fragment_Schritt__EndeSchritt)? endeSchritt,
    _T Function(Fragment_Schritt__GovManagerRestExportSchritt)?
    govManagerRestExportSchritt,
    _T Function(Fragment_Schritt__NachrichtSchritt)? nachrichtSchritt,
    _T Function(Fragment_Schritt__ProgrammatischerSchritt)?
    programmatischerSchritt,
    _T Function(Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt)?
    warteAufBezahlungAbgeschlossenSchritt,
    _T Function(Fragment_Schritt__WarteAufGovManagerSchritt)?
    warteAufGovManagerSchritt,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "FormularSchritt":
        if (formularSchritt != null) {
          return formularSchritt(this as Fragment_Schritt__FormularSchritt);
        } else {
          return orElse();
        }

      case "BezahlenSchritt":
        if (bezahlenSchritt != null) {
          return bezahlenSchritt(this as Fragment_Schritt__BezahlenSchritt);
        } else {
          return orElse();
        }

      case "EmailForwarderExportSchritt":
        if (emailForwarderExportSchritt != null) {
          return emailForwarderExportSchritt(
            this as Fragment_Schritt__EmailForwarderExportSchritt,
          );
        } else {
          return orElse();
        }

      case "EndeSchritt":
        if (endeSchritt != null) {
          return endeSchritt(this as Fragment_Schritt__EndeSchritt);
        } else {
          return orElse();
        }

      case "GovManagerRestExportSchritt":
        if (govManagerRestExportSchritt != null) {
          return govManagerRestExportSchritt(
            this as Fragment_Schritt__GovManagerRestExportSchritt,
          );
        } else {
          return orElse();
        }

      case "NachrichtSchritt":
        if (nachrichtSchritt != null) {
          return nachrichtSchritt(this as Fragment_Schritt__NachrichtSchritt);
        } else {
          return orElse();
        }

      case "ProgrammatischerSchritt":
        if (programmatischerSchritt != null) {
          return programmatischerSchritt(
            this as Fragment_Schritt__ProgrammatischerSchritt,
          );
        } else {
          return orElse();
        }

      case "WarteAufBezahlungAbgeschlossenSchritt":
        if (warteAufBezahlungAbgeschlossenSchritt != null) {
          return warteAufBezahlungAbgeschlossenSchritt(
            this as Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt,
          );
        } else {
          return orElse();
        }

      case "WarteAufGovManagerSchritt":
        if (warteAufGovManagerSchritt != null) {
          return warteAufGovManagerSchritt(
            this as Fragment_Schritt__WarteAufGovManagerSchritt,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_Schritt<TRes> {
  factory CopyWith_Fragment_Schritt(
    Fragment_Schritt instance,
    TRes Function(Fragment_Schritt) then,
  ) = _CopyWithImpl_Fragment_Schritt;

  factory CopyWith_Fragment_Schritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt_verbindungen>? verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt_slots> Function(
      Iterable<CopyWith_Fragment_Schritt_slots<Fragment_Schritt_slots>>,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt_verbindungen<Fragment_Schritt_verbindungen>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt<TRes>
    implements CopyWith_Fragment_Schritt<TRes> {
  _CopyWithImpl_Fragment_Schritt(this._instance, this._then);

  final Fragment_Schritt _instance;

  final TRes Function(Fragment_Schritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen as List<Fragment_Schritt_verbindungen>),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt_slots> Function(
      Iterable<CopyWith_Fragment_Schritt_slots<Fragment_Schritt_slots>>,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map((e) => CopyWith_Fragment_Schritt_slots(e, (i) => i)),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt_verbindungen<Fragment_Schritt_verbindungen>
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt_verbindungen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt<TRes>
    implements CopyWith_Fragment_Schritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt_verbindungen>? verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

const fragmentDefinitionSchritt = FragmentDefinitionNode(
  name: NameNode(value: 'Schritt'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Schritt'), isNonNull: false),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'erledigungDurchBuerger'),
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
        name: NameNode(value: 'anweisung'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'slots'),
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
              name: NameNode(value: 'encrypted'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'valueType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'optional'),
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
        name: NameNode(value: 'informationstext'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'verbindungen'),
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
              name: NameNode(value: 'istRelevant'),
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
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'FormularSchritt'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'felder'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'FormularFeld'),
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
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'BezahlenSchritt'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'betrag'),
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
);
const documentNodeFragmentSchritt = DocumentNode(
  definitions: [fragmentDefinitionSchritt, fragmentDefinitionFormularFeld],
);

extension ClientExtension_Fragment_Schritt on graphql.GraphQLClient {
  void writeFragment_Schritt({
    required Fragment_Schritt data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'Schritt',
        document: documentNodeFragmentSchritt,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_Schritt? readFragment_Schritt({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Schritt',
          document: documentNodeFragmentSchritt,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_Schritt.fromJson(result);
  }
}

class Fragment_Schritt_slots {
  Fragment_Schritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt_slots.fromJson(Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt_slots || runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt_slots on Fragment_Schritt_slots {
  CopyWith_Fragment_Schritt_slots<Fragment_Schritt_slots> get copyWith =>
      CopyWith_Fragment_Schritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt_slots(
    Fragment_Schritt_slots instance,
    TRes Function(Fragment_Schritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt_slots;

  factory CopyWith_Fragment_Schritt_slots.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt_slots<TRes>
    implements CopyWith_Fragment_Schritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt_slots(this._instance, this._then);

  final Fragment_Schritt_slots _instance;

  final TRes Function(Fragment_Schritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt_slots<TRes>
    implements CopyWith_Fragment_Schritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt_verbindungen {
  Fragment_Schritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt_verbindungen.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt_verbindungen
    on Fragment_Schritt_verbindungen {
  CopyWith_Fragment_Schritt_verbindungen<Fragment_Schritt_verbindungen>
  get copyWith => CopyWith_Fragment_Schritt_verbindungen(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt_verbindungen<TRes> {
  factory CopyWith_Fragment_Schritt_verbindungen(
    Fragment_Schritt_verbindungen instance,
    TRes Function(Fragment_Schritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt_verbindungen;

  factory CopyWith_Fragment_Schritt_verbindungen.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt_verbindungen(this._instance, this._then);

  final Fragment_Schritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt_verbindungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt_verbindungen(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__FormularSchritt implements Fragment_Schritt {
  Fragment_Schritt__FormularSchritt({
    required this.felder,
    this.$__typename = 'FormularSchritt',
    required this.id,
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__FormularSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$felder = json['felder'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__FormularSchritt(
      felder: (l$felder as List<dynamic>)
          .map(
            (e) => Fragment_FormularFeld.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__FormularSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__FormularSchritt_verbindungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Fragment_FormularFeld> felder;

  final String $__typename;

  final String id;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__FormularSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__FormularSchritt_verbindungen> verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$felder = felder;
    _resultData['felder'] = l$felder.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$felder = felder;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      Object.hashAll(l$felder.map((v) => v)),
      l$$__typename,
      l$id,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__FormularSchritt ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$felder = felder;
    final lOther$felder = other.felder;
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__FormularSchritt
    on Fragment_Schritt__FormularSchritt {
  CopyWith_Fragment_Schritt__FormularSchritt<Fragment_Schritt__FormularSchritt>
  get copyWith => CopyWith_Fragment_Schritt__FormularSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__FormularSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__FormularSchritt(
    Fragment_Schritt__FormularSchritt instance,
    TRes Function(Fragment_Schritt__FormularSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__FormularSchritt;

  factory CopyWith_Fragment_Schritt__FormularSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__FormularSchritt;

  TRes call({
    List<Fragment_FormularFeld>? felder,
    String? $__typename,
    String? id,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__FormularSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__FormularSchritt_verbindungen>? verbindungen,
  });
  TRes felder(
    Iterable<Fragment_FormularFeld> Function(
      Iterable<CopyWith_Fragment_FormularFeld<Fragment_FormularFeld>>,
    )
    _fn,
  );
  TRes slots(
    Iterable<Fragment_Schritt__FormularSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__FormularSchritt_slots<
          Fragment_Schritt__FormularSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__FormularSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<
          Fragment_Schritt__FormularSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__FormularSchritt<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__FormularSchritt(this._instance, this._then);

  final Fragment_Schritt__FormularSchritt _instance;

  final TRes Function(Fragment_Schritt__FormularSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? felder = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__FormularSchritt(
      felder: felder == _undefined || felder == null
          ? _instance.felder
          : (felder as List<Fragment_FormularFeld>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__FormularSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<Fragment_Schritt__FormularSchritt_verbindungen>),
    ),
  );

  TRes felder(
    Iterable<Fragment_FormularFeld> Function(
      Iterable<CopyWith_Fragment_FormularFeld<Fragment_FormularFeld>>,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder.map((e) => CopyWith_Fragment_FormularFeld(e, (i) => i)),
    ).toList(),
  );

  TRes slots(
    Iterable<Fragment_Schritt__FormularSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__FormularSchritt_slots<
          Fragment_Schritt__FormularSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__FormularSchritt_slots(e, (i) => i),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__FormularSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<
          Fragment_Schritt__FormularSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt__FormularSchritt_verbindungen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__FormularSchritt<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__FormularSchritt(this._res);

  TRes _res;

  call({
    List<Fragment_FormularFeld>? felder,
    String? $__typename,
    String? id,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__FormularSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__FormularSchritt_verbindungen>? verbindungen,
  }) => _res;

  felder(_fn) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__BezahlenSchritt implements Fragment_Schritt {
  Fragment_Schritt__BezahlenSchritt({
    required this.betrag,
    this.$__typename = 'BezahlenSchritt',
    required this.id,
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__BezahlenSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$betrag = json['betrag'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__BezahlenSchritt(
      betrag: (l$betrag as num).toDouble(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__BezahlenSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__BezahlenSchritt_verbindungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final double betrag;

  final String $__typename;

  final String id;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__BezahlenSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__BezahlenSchritt_verbindungen> verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$betrag = betrag;
    _resultData['betrag'] = l$betrag;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$betrag = betrag;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$betrag,
      l$$__typename,
      l$id,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__BezahlenSchritt ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$betrag = betrag;
    final lOther$betrag = other.betrag;
    if (l$betrag != lOther$betrag) {
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__BezahlenSchritt
    on Fragment_Schritt__BezahlenSchritt {
  CopyWith_Fragment_Schritt__BezahlenSchritt<Fragment_Schritt__BezahlenSchritt>
  get copyWith => CopyWith_Fragment_Schritt__BezahlenSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__BezahlenSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__BezahlenSchritt(
    Fragment_Schritt__BezahlenSchritt instance,
    TRes Function(Fragment_Schritt__BezahlenSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__BezahlenSchritt;

  factory CopyWith_Fragment_Schritt__BezahlenSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt;

  TRes call({
    double? betrag,
    String? $__typename,
    String? id,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__BezahlenSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__BezahlenSchritt_verbindungen>? verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__BezahlenSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__BezahlenSchritt_slots<
          Fragment_Schritt__BezahlenSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__BezahlenSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<
          Fragment_Schritt__BezahlenSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__BezahlenSchritt<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__BezahlenSchritt(this._instance, this._then);

  final Fragment_Schritt__BezahlenSchritt _instance;

  final TRes Function(Fragment_Schritt__BezahlenSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? betrag = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__BezahlenSchritt(
      betrag: betrag == _undefined || betrag == null
          ? _instance.betrag
          : (betrag as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__BezahlenSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<Fragment_Schritt__BezahlenSchritt_verbindungen>),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__BezahlenSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__BezahlenSchritt_slots<
          Fragment_Schritt__BezahlenSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__BezahlenSchritt_slots(e, (i) => i),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__BezahlenSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<
          Fragment_Schritt__BezahlenSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt(this._res);

  TRes _res;

  call({
    double? betrag,
    String? $__typename,
    String? id,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__BezahlenSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__BezahlenSchritt_verbindungen>? verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__BezahlenSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__BezahlenSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__BezahlenSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__BezahlenSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__BezahlenSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__BezahlenSchritt_slots
    on Fragment_Schritt__BezahlenSchritt_slots {
  CopyWith_Fragment_Schritt__BezahlenSchritt_slots<
    Fragment_Schritt__BezahlenSchritt_slots
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__BezahlenSchritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__BezahlenSchritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt__BezahlenSchritt_slots(
    Fragment_Schritt__BezahlenSchritt_slots instance,
    TRes Function(Fragment_Schritt__BezahlenSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_slots;

  factory CopyWith_Fragment_Schritt__BezahlenSchritt_slots.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__BezahlenSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__BezahlenSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__BezahlenSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__BezahlenSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__BezahlenSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__BezahlenSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__BezahlenSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__BezahlenSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__BezahlenSchritt_verbindungen
    on Fragment_Schritt__BezahlenSchritt_verbindungen {
  CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<
    Fragment_Schritt__BezahlenSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<TRes> {
  factory CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen(
    Fragment_Schritt__BezahlenSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__BezahlenSchritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt__BezahlenSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__BezahlenSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__BezahlenSchritt_verbindungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__BezahlenSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__BezahlenSchritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__BezahlenSchritt_verbindungen(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__EmailForwarderExportSchritt
    implements Fragment_Schritt {
  Fragment_Schritt__EmailForwarderExportSchritt({
    required this.id,
    this.$__typename = 'EmailForwarderExportSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__EmailForwarderExportSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__EmailForwarderExportSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__EmailForwarderExportSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__EmailForwarderExportSchritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__EmailForwarderExportSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__EmailForwarderExportSchritt_verbindungen>
  verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EmailForwarderExportSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__EmailForwarderExportSchritt
    on Fragment_Schritt__EmailForwarderExportSchritt {
  CopyWith_Fragment_Schritt__EmailForwarderExportSchritt<
    Fragment_Schritt__EmailForwarderExportSchritt
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__EmailForwarderExportSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__EmailForwarderExportSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt(
    Fragment_Schritt__EmailForwarderExportSchritt instance,
    TRes Function(Fragment_Schritt__EmailForwarderExportSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt;

  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__EmailForwarderExportSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__EmailForwarderExportSchritt_verbindungen>?
    verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__EmailForwarderExportSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<
          Fragment_Schritt__EmailForwarderExportSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__EmailForwarderExportSchritt_verbindungen>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
          Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt<TRes>
    implements CopyWith_Fragment_Schritt__EmailForwarderExportSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__EmailForwarderExportSchritt _instance;

  final TRes Function(Fragment_Schritt__EmailForwarderExportSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__EmailForwarderExportSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots
                as List<Fragment_Schritt__EmailForwarderExportSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<
                  Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
                >),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__EmailForwarderExportSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<
          Fragment_Schritt__EmailForwarderExportSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__EmailForwarderExportSchritt_verbindungen>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
          Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) =>
            CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt<TRes>
    implements CopyWith_Fragment_Schritt__EmailForwarderExportSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__EmailForwarderExportSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__EmailForwarderExportSchritt_verbindungen>?
    verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__EmailForwarderExportSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__EmailForwarderExportSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__EmailForwarderExportSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__EmailForwarderExportSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EmailForwarderExportSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__EmailForwarderExportSchritt_slots
    on Fragment_Schritt__EmailForwarderExportSchritt_slots {
  CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<
    Fragment_Schritt__EmailForwarderExportSchritt_slots
  >
  get copyWith => CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<
  TRes
> {
  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots(
    Fragment_Schritt__EmailForwarderExportSchritt_slots instance,
    TRes Function(Fragment_Schritt__EmailForwarderExportSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots;

  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots<TRes>
    implements
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__EmailForwarderExportSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__EmailForwarderExportSchritt_slots)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__EmailForwarderExportSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_slots(
    this._res,
  );

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__EmailForwarderExportSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__EmailForwarderExportSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EmailForwarderExportSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
    on Fragment_Schritt__EmailForwarderExportSchritt_verbindungen {
  CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
    Fragment_Schritt__EmailForwarderExportSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
  TRes
> {
  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
    Fragment_Schritt__EmailForwarderExportSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__EmailForwarderExportSchritt_verbindungen)
    then,
  ) = _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
          TRes
        > {
  _CopyWithImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__EmailForwarderExportSchritt_verbindungen _instance;

  final TRes Function(
    Fragment_Schritt__EmailForwarderExportSchritt_verbindungen,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Schritt__EmailForwarderExportSchritt_verbindungen(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__EndeSchritt implements Fragment_Schritt {
  Fragment_Schritt__EndeSchritt({
    required this.id,
    this.$__typename = 'EndeSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__EndeSchritt.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__EndeSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__EndeSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__EndeSchritt_verbindungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__EndeSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__EndeSchritt_verbindungen> verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EndeSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__EndeSchritt
    on Fragment_Schritt__EndeSchritt {
  CopyWith_Fragment_Schritt__EndeSchritt<Fragment_Schritt__EndeSchritt>
  get copyWith => CopyWith_Fragment_Schritt__EndeSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__EndeSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__EndeSchritt(
    Fragment_Schritt__EndeSchritt instance,
    TRes Function(Fragment_Schritt__EndeSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__EndeSchritt;

  factory CopyWith_Fragment_Schritt__EndeSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__EndeSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__EndeSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__EndeSchritt_verbindungen>? verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__EndeSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EndeSchritt_slots<
          Fragment_Schritt__EndeSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__EndeSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<
          Fragment_Schritt__EndeSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__EndeSchritt<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__EndeSchritt(this._instance, this._then);

  final Fragment_Schritt__EndeSchritt _instance;

  final TRes Function(Fragment_Schritt__EndeSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__EndeSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__EndeSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen as List<Fragment_Schritt__EndeSchritt_verbindungen>),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__EndeSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EndeSchritt_slots<
          Fragment_Schritt__EndeSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__EndeSchritt_slots(e, (i) => i),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__EndeSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<
          Fragment_Schritt__EndeSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt__EndeSchritt_verbindungen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EndeSchritt<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__EndeSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__EndeSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__EndeSchritt_verbindungen>? verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__EndeSchritt_slots implements Fragment_Schritt_slots {
  Fragment_Schritt__EndeSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__EndeSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__EndeSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EndeSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__EndeSchritt_slots
    on Fragment_Schritt__EndeSchritt_slots {
  CopyWith_Fragment_Schritt__EndeSchritt_slots<
    Fragment_Schritt__EndeSchritt_slots
  >
  get copyWith => CopyWith_Fragment_Schritt__EndeSchritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__EndeSchritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt__EndeSchritt_slots(
    Fragment_Schritt__EndeSchritt_slots instance,
    TRes Function(Fragment_Schritt__EndeSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__EndeSchritt_slots;

  factory CopyWith_Fragment_Schritt__EndeSchritt_slots.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__EndeSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__EndeSchritt_slots(this._instance, this._then);

  final Fragment_Schritt__EndeSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__EndeSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__EndeSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__EndeSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__EndeSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__EndeSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__EndeSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__EndeSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__EndeSchritt_verbindungen
    on Fragment_Schritt__EndeSchritt_verbindungen {
  CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<
    Fragment_Schritt__EndeSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__EndeSchritt_verbindungen(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<TRes> {
  factory CopyWith_Fragment_Schritt__EndeSchritt_verbindungen(
    Fragment_Schritt__EndeSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__EndeSchritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt__EndeSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__EndeSchritt_verbindungen.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__EndeSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt__EndeSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__EndeSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__EndeSchritt_verbindungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__EndeSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__EndeSchritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__EndeSchritt_verbindungen(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__FormularSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__FormularSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__FormularSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__FormularSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__FormularSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__FormularSchritt_slots
    on Fragment_Schritt__FormularSchritt_slots {
  CopyWith_Fragment_Schritt__FormularSchritt_slots<
    Fragment_Schritt__FormularSchritt_slots
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__FormularSchritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__FormularSchritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt__FormularSchritt_slots(
    Fragment_Schritt__FormularSchritt_slots instance,
    TRes Function(Fragment_Schritt__FormularSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__FormularSchritt_slots;

  factory CopyWith_Fragment_Schritt__FormularSchritt_slots.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__FormularSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__FormularSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__FormularSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__FormularSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__FormularSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__FormularSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__FormularSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__FormularSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__FormularSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__FormularSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__FormularSchritt_verbindungen
    on Fragment_Schritt__FormularSchritt_verbindungen {
  CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<
    Fragment_Schritt__FormularSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__FormularSchritt_verbindungen(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<TRes> {
  factory CopyWith_Fragment_Schritt__FormularSchritt_verbindungen(
    Fragment_Schritt__FormularSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__FormularSchritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt__FormularSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__FormularSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__FormularSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt__FormularSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__FormularSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__FormularSchritt_verbindungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__FormularSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__FormularSchritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__FormularSchritt_verbindungen(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__GovManagerRestExportSchritt
    implements Fragment_Schritt {
  Fragment_Schritt__GovManagerRestExportSchritt({
    required this.id,
    this.$__typename = 'GovManagerRestExportSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__GovManagerRestExportSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__GovManagerRestExportSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__GovManagerRestExportSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__GovManagerRestExportSchritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__GovManagerRestExportSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__GovManagerRestExportSchritt_verbindungen>
  verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__GovManagerRestExportSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__GovManagerRestExportSchritt
    on Fragment_Schritt__GovManagerRestExportSchritt {
  CopyWith_Fragment_Schritt__GovManagerRestExportSchritt<
    Fragment_Schritt__GovManagerRestExportSchritt
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__GovManagerRestExportSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__GovManagerRestExportSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt(
    Fragment_Schritt__GovManagerRestExportSchritt instance,
    TRes Function(Fragment_Schritt__GovManagerRestExportSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt;

  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__GovManagerRestExportSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__GovManagerRestExportSchritt_verbindungen>?
    verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__GovManagerRestExportSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<
          Fragment_Schritt__GovManagerRestExportSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__GovManagerRestExportSchritt_verbindungen>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
          Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt<TRes>
    implements CopyWith_Fragment_Schritt__GovManagerRestExportSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__GovManagerRestExportSchritt _instance;

  final TRes Function(Fragment_Schritt__GovManagerRestExportSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__GovManagerRestExportSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots
                as List<Fragment_Schritt__GovManagerRestExportSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<
                  Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
                >),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__GovManagerRestExportSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<
          Fragment_Schritt__GovManagerRestExportSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__GovManagerRestExportSchritt_verbindungen>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
          Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) =>
            CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt<TRes>
    implements CopyWith_Fragment_Schritt__GovManagerRestExportSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__GovManagerRestExportSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__GovManagerRestExportSchritt_verbindungen>?
    verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__GovManagerRestExportSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__GovManagerRestExportSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__GovManagerRestExportSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__GovManagerRestExportSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__GovManagerRestExportSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__GovManagerRestExportSchritt_slots
    on Fragment_Schritt__GovManagerRestExportSchritt_slots {
  CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<
    Fragment_Schritt__GovManagerRestExportSchritt_slots
  >
  get copyWith => CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<
  TRes
> {
  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots(
    Fragment_Schritt__GovManagerRestExportSchritt_slots instance,
    TRes Function(Fragment_Schritt__GovManagerRestExportSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots;

  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots<TRes>
    implements
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__GovManagerRestExportSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__GovManagerRestExportSchritt_slots)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__GovManagerRestExportSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_slots(
    this._res,
  );

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__GovManagerRestExportSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__GovManagerRestExportSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__GovManagerRestExportSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
    on Fragment_Schritt__GovManagerRestExportSchritt_verbindungen {
  CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
    Fragment_Schritt__GovManagerRestExportSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
  TRes
> {
  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
    Fragment_Schritt__GovManagerRestExportSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__GovManagerRestExportSchritt_verbindungen)
    then,
  ) = _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
          TRes
        > {
  _CopyWithImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__GovManagerRestExportSchritt_verbindungen _instance;

  final TRes Function(
    Fragment_Schritt__GovManagerRestExportSchritt_verbindungen,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Schritt__GovManagerRestExportSchritt_verbindungen(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__NachrichtSchritt implements Fragment_Schritt {
  Fragment_Schritt__NachrichtSchritt({
    required this.id,
    this.$__typename = 'NachrichtSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__NachrichtSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__NachrichtSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__NachrichtSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__NachrichtSchritt_verbindungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__NachrichtSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__NachrichtSchritt_verbindungen> verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__NachrichtSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__NachrichtSchritt
    on Fragment_Schritt__NachrichtSchritt {
  CopyWith_Fragment_Schritt__NachrichtSchritt<
    Fragment_Schritt__NachrichtSchritt
  >
  get copyWith => CopyWith_Fragment_Schritt__NachrichtSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__NachrichtSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__NachrichtSchritt(
    Fragment_Schritt__NachrichtSchritt instance,
    TRes Function(Fragment_Schritt__NachrichtSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__NachrichtSchritt;

  factory CopyWith_Fragment_Schritt__NachrichtSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__NachrichtSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__NachrichtSchritt_verbindungen>? verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__NachrichtSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__NachrichtSchritt_slots<
          Fragment_Schritt__NachrichtSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__NachrichtSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<
          Fragment_Schritt__NachrichtSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__NachrichtSchritt<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__NachrichtSchritt(this._instance, this._then);

  final Fragment_Schritt__NachrichtSchritt _instance;

  final TRes Function(Fragment_Schritt__NachrichtSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__NachrichtSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__NachrichtSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<Fragment_Schritt__NachrichtSchritt_verbindungen>),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__NachrichtSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__NachrichtSchritt_slots<
          Fragment_Schritt__NachrichtSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__NachrichtSchritt_slots(e, (i) => i),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__NachrichtSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<
          Fragment_Schritt__NachrichtSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__NachrichtSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__NachrichtSchritt_verbindungen>? verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__NachrichtSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__NachrichtSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__NachrichtSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__NachrichtSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__NachrichtSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__NachrichtSchritt_slots
    on Fragment_Schritt__NachrichtSchritt_slots {
  CopyWith_Fragment_Schritt__NachrichtSchritt_slots<
    Fragment_Schritt__NachrichtSchritt_slots
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__NachrichtSchritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__NachrichtSchritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt__NachrichtSchritt_slots(
    Fragment_Schritt__NachrichtSchritt_slots instance,
    TRes Function(Fragment_Schritt__NachrichtSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_slots;

  factory CopyWith_Fragment_Schritt__NachrichtSchritt_slots.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__NachrichtSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__NachrichtSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__NachrichtSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__NachrichtSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__NachrichtSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__NachrichtSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__NachrichtSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__NachrichtSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__NachrichtSchritt_verbindungen
    on Fragment_Schritt__NachrichtSchritt_verbindungen {
  CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<
    Fragment_Schritt__NachrichtSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<TRes> {
  factory CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen(
    Fragment_Schritt__NachrichtSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__NachrichtSchritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt__NachrichtSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__NachrichtSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__NachrichtSchritt_verbindungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__NachrichtSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_verbindungen<TRes>
    implements CopyWith_Fragment_Schritt__NachrichtSchritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__NachrichtSchritt_verbindungen(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__ProgrammatischerSchritt implements Fragment_Schritt {
  Fragment_Schritt__ProgrammatischerSchritt({
    required this.id,
    this.$__typename = 'ProgrammatischerSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__ProgrammatischerSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__ProgrammatischerSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__ProgrammatischerSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__ProgrammatischerSchritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__ProgrammatischerSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__ProgrammatischerSchritt_verbindungen>
  verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__ProgrammatischerSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__ProgrammatischerSchritt
    on Fragment_Schritt__ProgrammatischerSchritt {
  CopyWith_Fragment_Schritt__ProgrammatischerSchritt<
    Fragment_Schritt__ProgrammatischerSchritt
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__ProgrammatischerSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__ProgrammatischerSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt(
    Fragment_Schritt__ProgrammatischerSchritt instance,
    TRes Function(Fragment_Schritt__ProgrammatischerSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt;

  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__ProgrammatischerSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__ProgrammatischerSchritt_verbindungen>? verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__ProgrammatischerSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<
          Fragment_Schritt__ProgrammatischerSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__ProgrammatischerSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<
          Fragment_Schritt__ProgrammatischerSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt<TRes>
    implements CopyWith_Fragment_Schritt__ProgrammatischerSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__ProgrammatischerSchritt _instance;

  final TRes Function(Fragment_Schritt__ProgrammatischerSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__ProgrammatischerSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__ProgrammatischerSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<
                  Fragment_Schritt__ProgrammatischerSchritt_verbindungen
                >),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__ProgrammatischerSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<
          Fragment_Schritt__ProgrammatischerSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__ProgrammatischerSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<
          Fragment_Schritt__ProgrammatischerSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) => CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt<TRes>
    implements CopyWith_Fragment_Schritt__ProgrammatischerSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__ProgrammatischerSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__ProgrammatischerSchritt_verbindungen>? verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__ProgrammatischerSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__ProgrammatischerSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__ProgrammatischerSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__ProgrammatischerSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__ProgrammatischerSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__ProgrammatischerSchritt_slots
    on Fragment_Schritt__ProgrammatischerSchritt_slots {
  CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<
    Fragment_Schritt__ProgrammatischerSchritt_slots
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<TRes> {
  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots(
    Fragment_Schritt__ProgrammatischerSchritt_slots instance,
    TRes Function(Fragment_Schritt__ProgrammatischerSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_slots;

  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__ProgrammatischerSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__ProgrammatischerSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__ProgrammatischerSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_slots<TRes>
    implements CopyWith_Fragment_Schritt__ProgrammatischerSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_slots(this._res);

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__ProgrammatischerSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__ProgrammatischerSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__ProgrammatischerSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__ProgrammatischerSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__ProgrammatischerSchritt_verbindungen
    on Fragment_Schritt__ProgrammatischerSchritt_verbindungen {
  CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<
    Fragment_Schritt__ProgrammatischerSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<
  TRes
> {
  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
    Fragment_Schritt__ProgrammatischerSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__ProgrammatischerSchritt_verbindungen) then,
  ) = _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<TRes>
    implements
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<TRes> {
  _CopyWithImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__ProgrammatischerSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__ProgrammatischerSchritt_verbindungen)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__ProgrammatischerSchritt_verbindungen<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__ProgrammatischerSchritt_verbindungen(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt
    implements Fragment_Schritt {
  Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt({
    required this.id,
    this.$__typename = 'WarteAufBezahlungAbgeschlossenSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots>
  slots;

  final String? informationstext;

  final List<
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
  >
  verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt
    on Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt {
  CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<
  TRes
> {
  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt instance,
    TRes Function(Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt;

  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen>?
    verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
          Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<
      Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
    >
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
          Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt _instance;

  final TRes Function(Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots
                as List<
                  Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
                >),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<
                  Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
                >),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots>
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
          Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) =>
            CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<
      Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
    >
    Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
          Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) =>
            CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen>?
    verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
    on Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots {
  CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
  TRes
> {
  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots instance,
    TRes Function(Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots)
    then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots;

  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
          TRes
        > {
  _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots _instance;

  final TRes Function(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_slots(
    this._res,
  );

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
    on Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen {
  CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
  TRes
> {
  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
    instance,
    TRes Function(
      Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen,
    )
    then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
          TRes
        > {
  _CopyWithImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen
  _instance;

  final TRes Function(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt_verbindungen(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__WarteAufGovManagerSchritt implements Fragment_Schritt {
  Fragment_Schritt__WarteAufGovManagerSchritt({
    required this.id,
    this.$__typename = 'WarteAufGovManagerSchritt',
    required this.erledigungDurchBuerger,
    this.titel,
    this.anweisung,
    required this.slots,
    this.informationstext,
    required this.verbindungen,
  });

  factory Fragment_Schritt__WarteAufGovManagerSchritt.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    final l$erledigungDurchBuerger = json['erledigungDurchBuerger'];
    final l$titel = json['titel'];
    final l$anweisung = json['anweisung'];
    final l$slots = json['slots'];
    final l$informationstext = json['informationstext'];
    final l$verbindungen = json['verbindungen'];
    return Fragment_Schritt__WarteAufGovManagerSchritt(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
      erledigungDurchBuerger: (l$erledigungDurchBuerger as bool),
      titel: (l$titel as String?),
      anweisung: (l$anweisung as String?),
      slots: (l$slots as List<dynamic>)
          .map(
            (e) => Fragment_Schritt__WarteAufGovManagerSchritt_slots.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      informationstext: (l$informationstext as String?),
      verbindungen: (l$verbindungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String id;

  final String $__typename;

  final bool erledigungDurchBuerger;

  final String? titel;

  final String? anweisung;

  final List<Fragment_Schritt__WarteAufGovManagerSchritt_slots> slots;

  final String? informationstext;

  final List<Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen>
  verbindungen;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    _resultData['erledigungDurchBuerger'] = l$erledigungDurchBuerger;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$slots = slots;
    _resultData['slots'] = l$slots.map((e) => e.toJson()).toList();
    final l$informationstext = informationstext;
    _resultData['informationstext'] = l$informationstext;
    final l$verbindungen = verbindungen;
    _resultData['verbindungen'] = l$verbindungen
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final l$titel = titel;
    final l$anweisung = anweisung;
    final l$slots = slots;
    final l$informationstext = informationstext;
    final l$verbindungen = verbindungen;
    return Object.hashAll([
      l$id,
      l$$__typename,
      l$erledigungDurchBuerger,
      l$titel,
      l$anweisung,
      Object.hashAll(l$slots.map((v) => v)),
      l$informationstext,
      Object.hashAll(l$verbindungen.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__WarteAufGovManagerSchritt ||
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
    final l$erledigungDurchBuerger = erledigungDurchBuerger;
    final lOther$erledigungDurchBuerger = other.erledigungDurchBuerger;
    if (l$erledigungDurchBuerger != lOther$erledigungDurchBuerger) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$slots = slots;
    final lOther$slots = other.slots;
    if (l$slots.length != lOther$slots.length) {
      return false;
    }
    for (int i = 0; i < l$slots.length; i++) {
      final l$slots$entry = l$slots[i];
      final lOther$slots$entry = lOther$slots[i];
      if (l$slots$entry != lOther$slots$entry) {
        return false;
      }
    }
    final l$informationstext = informationstext;
    final lOther$informationstext = other.informationstext;
    if (l$informationstext != lOther$informationstext) {
      return false;
    }
    final l$verbindungen = verbindungen;
    final lOther$verbindungen = other.verbindungen;
    if (l$verbindungen.length != lOther$verbindungen.length) {
      return false;
    }
    for (int i = 0; i < l$verbindungen.length; i++) {
      final l$verbindungen$entry = l$verbindungen[i];
      final lOther$verbindungen$entry = lOther$verbindungen[i];
      if (l$verbindungen$entry != lOther$verbindungen$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Fragment_Schritt__WarteAufGovManagerSchritt
    on Fragment_Schritt__WarteAufGovManagerSchritt {
  CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt<
    Fragment_Schritt__WarteAufGovManagerSchritt
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt(this, (i) => i);
}

abstract class CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt<TRes> {
  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt(
    Fragment_Schritt__WarteAufGovManagerSchritt instance,
    TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt) then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt;

  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt;

  TRes call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__WarteAufGovManagerSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen>?
    verbindungen,
  });
  TRes slots(
    Iterable<Fragment_Schritt__WarteAufGovManagerSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<
          Fragment_Schritt__WarteAufGovManagerSchritt_slots
        >
      >,
    )
    _fn,
  );
  TRes verbindungen(
    Iterable<Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
          Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt<TRes>
    implements CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt<TRes> {
  _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufGovManagerSchritt _instance;

  final TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
    Object? erledigungDurchBuerger = _undefined,
    Object? titel = _undefined,
    Object? anweisung = _undefined,
    Object? slots = _undefined,
    Object? informationstext = _undefined,
    Object? verbindungen = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufGovManagerSchritt(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      erledigungDurchBuerger:
          erledigungDurchBuerger == _undefined || erledigungDurchBuerger == null
          ? _instance.erledigungDurchBuerger
          : (erledigungDurchBuerger as bool),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      slots: slots == _undefined || slots == null
          ? _instance.slots
          : (slots as List<Fragment_Schritt__WarteAufGovManagerSchritt_slots>),
      informationstext: informationstext == _undefined
          ? _instance.informationstext
          : (informationstext as String?),
      verbindungen: verbindungen == _undefined || verbindungen == null
          ? _instance.verbindungen
          : (verbindungen
                as List<
                  Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
                >),
    ),
  );

  TRes slots(
    Iterable<Fragment_Schritt__WarteAufGovManagerSchritt_slots> Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<
          Fragment_Schritt__WarteAufGovManagerSchritt_slots
        >
      >,
    )
    _fn,
  ) => call(
    slots: _fn(
      _instance.slots.map(
        (e) => CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes verbindungen(
    Iterable<Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen> Function(
      Iterable<
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
          Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
        >
      >,
    )
    _fn,
  ) => call(
    verbindungen: _fn(
      _instance.verbindungen.map(
        (e) =>
            CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt<TRes>
    implements CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
    bool? erledigungDurchBuerger,
    String? titel,
    String? anweisung,
    List<Fragment_Schritt__WarteAufGovManagerSchritt_slots>? slots,
    String? informationstext,
    List<Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen>?
    verbindungen,
  }) => _res;

  slots(_fn) => _res;

  verbindungen(_fn) => _res;
}

class Fragment_Schritt__WarteAufGovManagerSchritt_slots
    implements Fragment_Schritt_slots {
  Fragment_Schritt__WarteAufGovManagerSchritt_slots({
    required this.name,
    required this.encrypted,
    required this.valueType,
    required this.optional,
    this.$__typename = 'Slot',
  });

  factory Fragment_Schritt__WarteAufGovManagerSchritt_slots.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$encrypted = json['encrypted'];
    final l$valueType = json['valueType'];
    final l$optional = json['optional'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__WarteAufGovManagerSchritt_slots(
      name: (l$name as String),
      encrypted: (l$encrypted as bool),
      valueType: fromJson_Enum_SlotValueType((l$valueType as String)),
      optional: (l$optional as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final bool encrypted;

  final Enum_SlotValueType valueType;

  final bool optional;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$encrypted = encrypted;
    _resultData['encrypted'] = l$encrypted;
    final l$valueType = valueType;
    _resultData['valueType'] = toJson_Enum_SlotValueType(l$valueType);
    final l$optional = optional;
    _resultData['optional'] = l$optional;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$encrypted = encrypted;
    final l$valueType = valueType;
    final l$optional = optional;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$encrypted,
      l$valueType,
      l$optional,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__WarteAufGovManagerSchritt_slots ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$encrypted = encrypted;
    final lOther$encrypted = other.encrypted;
    if (l$encrypted != lOther$encrypted) {
      return false;
    }
    final l$valueType = valueType;
    final lOther$valueType = other.valueType;
    if (l$valueType != lOther$valueType) {
      return false;
    }
    final l$optional = optional;
    final lOther$optional = other.optional;
    if (l$optional != lOther$optional) {
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

extension UtilityExtension_Fragment_Schritt__WarteAufGovManagerSchritt_slots
    on Fragment_Schritt__WarteAufGovManagerSchritt_slots {
  CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<
    Fragment_Schritt__WarteAufGovManagerSchritt_slots
  >
  get copyWith => CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<
  TRes
> {
  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots(
    Fragment_Schritt__WarteAufGovManagerSchritt_slots instance,
    TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt_slots) then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots;

  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots;

  TRes call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots<TRes>
    implements
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<TRes> {
  _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufGovManagerSchritt_slots _instance;

  final TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt_slots) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? encrypted = _undefined,
    Object? valueType = _undefined,
    Object? optional = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufGovManagerSchritt_slots(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      encrypted: encrypted == _undefined || encrypted == null
          ? _instance.encrypted
          : (encrypted as bool),
      valueType: valueType == _undefined || valueType == null
          ? _instance.valueType
          : (valueType as Enum_SlotValueType),
      optional: optional == _undefined || optional == null
          ? _instance.optional
          : (optional as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots<TRes>
    implements
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_slots<TRes> {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_slots(
    this._res,
  );

  TRes _res;

  call({
    String? name,
    bool? encrypted,
    Enum_SlotValueType? valueType,
    bool? optional,
    String? $__typename,
  }) => _res;
}

class Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
    implements Fragment_Schritt_verbindungen {
  Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen({
    required this.id,
    this.name,
    required this.istRelevant,
    this.$__typename = 'Verbindung',
  });

  factory Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
      id: (l$id as String),
      name: (l$name as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen ||
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
    on Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen {
  CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
    Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen
  >
  get copyWith =>
      CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
  TRes
> {
  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
    Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen instance,
    TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen)
    then,
  ) = _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen;

  factory CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen;

  TRes call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
          TRes
        > {
  _CopyWithImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
    this._instance,
    this._then,
  );

  final Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen _instance;

  final TRes Function(Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
  TRes
>
    implements
        CopyWith_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Schritt__WarteAufGovManagerSchritt_verbindungen(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld {
  Fragment_FormularFeld({
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
    required this.$__typename,
  });

  factory Fragment_FormularFeld.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "StringFormularFeld":
        return Fragment_FormularFeld__StringFormularFeld.fromJson(json);

      case "UploadFormularFeld":
        return Fragment_FormularFeld__UploadFormularFeld.fromJson(json);

      case "CheckboxListFormularFeld":
        return Fragment_FormularFeld__CheckboxListFormularFeld.fromJson(json);

      case "AnzeigeTextBlockFeld":
        return Fragment_FormularFeld__AnzeigeTextBlockFeld.fromJson(json);

      case "DateFormularFeld":
        return Fragment_FormularFeld__DateFormularFeld.fromJson(json);

      case "LocationFormularFeld":
        return Fragment_FormularFeld__LocationFormularFeld.fromJson(json);

      case "SignatureFormularFeld":
        return Fragment_FormularFeld__SignatureFormularFeld.fromJson(json);

      case "TimeFormularFeld":
        return Fragment_FormularFeld__TimeFormularFeld.fromJson(json);

      default:
        final l$angezeigterName = json['angezeigterName'];
        final l$slotName = json['slotName'];
        final l$pflichtfeld = json['pflichtfeld'];
        final l$anweisung = json['anweisung'];
        final l$inhaltsTag = json['inhaltsTag'];
        final l$istRelevant = json['istRelevant'];
        final l$$__typename = json['__typename'];
        return Fragment_FormularFeld(
          angezeigterName: (l$angezeigterName as String?),
          slotName: (l$slotName as String),
          pflichtfeld: (l$pflichtfeld as bool),
          anweisung: (l$anweisung as String?),
          inhaltsTag: (l$inhaltsTag as String?),
          istRelevant: boolExpressionFromJson(l$istRelevant),
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld || runtimeType != other.runtimeType) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld on Fragment_FormularFeld {
  CopyWith_Fragment_FormularFeld<Fragment_FormularFeld> get copyWith =>
      CopyWith_Fragment_FormularFeld(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_FormularFeld__StringFormularFeld)
    stringFormularFeld,
    required _T Function(Fragment_FormularFeld__UploadFormularFeld)
    uploadFormularFeld,
    required _T Function(Fragment_FormularFeld__CheckboxListFormularFeld)
    checkboxListFormularFeld,
    required _T Function(Fragment_FormularFeld__AnzeigeTextBlockFeld)
    anzeigeTextBlockFeld,
    required _T Function(Fragment_FormularFeld__DateFormularFeld)
    dateFormularFeld,
    required _T Function(Fragment_FormularFeld__LocationFormularFeld)
    locationFormularFeld,
    required _T Function(Fragment_FormularFeld__SignatureFormularFeld)
    signatureFormularFeld,
    required _T Function(Fragment_FormularFeld__TimeFormularFeld)
    timeFormularFeld,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "StringFormularFeld":
        return stringFormularFeld(
          this as Fragment_FormularFeld__StringFormularFeld,
        );

      case "UploadFormularFeld":
        return uploadFormularFeld(
          this as Fragment_FormularFeld__UploadFormularFeld,
        );

      case "CheckboxListFormularFeld":
        return checkboxListFormularFeld(
          this as Fragment_FormularFeld__CheckboxListFormularFeld,
        );

      case "AnzeigeTextBlockFeld":
        return anzeigeTextBlockFeld(
          this as Fragment_FormularFeld__AnzeigeTextBlockFeld,
        );

      case "DateFormularFeld":
        return dateFormularFeld(
          this as Fragment_FormularFeld__DateFormularFeld,
        );

      case "LocationFormularFeld":
        return locationFormularFeld(
          this as Fragment_FormularFeld__LocationFormularFeld,
        );

      case "SignatureFormularFeld":
        return signatureFormularFeld(
          this as Fragment_FormularFeld__SignatureFormularFeld,
        );

      case "TimeFormularFeld":
        return timeFormularFeld(
          this as Fragment_FormularFeld__TimeFormularFeld,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_FormularFeld__StringFormularFeld)? stringFormularFeld,
    _T Function(Fragment_FormularFeld__UploadFormularFeld)? uploadFormularFeld,
    _T Function(Fragment_FormularFeld__CheckboxListFormularFeld)?
    checkboxListFormularFeld,
    _T Function(Fragment_FormularFeld__AnzeigeTextBlockFeld)?
    anzeigeTextBlockFeld,
    _T Function(Fragment_FormularFeld__DateFormularFeld)? dateFormularFeld,
    _T Function(Fragment_FormularFeld__LocationFormularFeld)?
    locationFormularFeld,
    _T Function(Fragment_FormularFeld__SignatureFormularFeld)?
    signatureFormularFeld,
    _T Function(Fragment_FormularFeld__TimeFormularFeld)? timeFormularFeld,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "StringFormularFeld":
        if (stringFormularFeld != null) {
          return stringFormularFeld(
            this as Fragment_FormularFeld__StringFormularFeld,
          );
        } else {
          return orElse();
        }

      case "UploadFormularFeld":
        if (uploadFormularFeld != null) {
          return uploadFormularFeld(
            this as Fragment_FormularFeld__UploadFormularFeld,
          );
        } else {
          return orElse();
        }

      case "CheckboxListFormularFeld":
        if (checkboxListFormularFeld != null) {
          return checkboxListFormularFeld(
            this as Fragment_FormularFeld__CheckboxListFormularFeld,
          );
        } else {
          return orElse();
        }

      case "AnzeigeTextBlockFeld":
        if (anzeigeTextBlockFeld != null) {
          return anzeigeTextBlockFeld(
            this as Fragment_FormularFeld__AnzeigeTextBlockFeld,
          );
        } else {
          return orElse();
        }

      case "DateFormularFeld":
        if (dateFormularFeld != null) {
          return dateFormularFeld(
            this as Fragment_FormularFeld__DateFormularFeld,
          );
        } else {
          return orElse();
        }

      case "LocationFormularFeld":
        if (locationFormularFeld != null) {
          return locationFormularFeld(
            this as Fragment_FormularFeld__LocationFormularFeld,
          );
        } else {
          return orElse();
        }

      case "SignatureFormularFeld":
        if (signatureFormularFeld != null) {
          return signatureFormularFeld(
            this as Fragment_FormularFeld__SignatureFormularFeld,
          );
        } else {
          return orElse();
        }

      case "TimeFormularFeld":
        if (timeFormularFeld != null) {
          return timeFormularFeld(
            this as Fragment_FormularFeld__TimeFormularFeld,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_FormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld(
    Fragment_FormularFeld instance,
    TRes Function(Fragment_FormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld;

  factory CopyWith_Fragment_FormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld;

  TRes call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld(this._instance, this._then);

  final Fragment_FormularFeld _instance;

  final TRes Function(Fragment_FormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld(
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld(this._res);

  TRes _res;

  call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionFormularFeld = FragmentDefinitionNode(
  name: NameNode(value: 'FormularFeld'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'FormularFeld'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'angezeigterName'),
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
      FieldNode(
        name: NameNode(value: 'pflichtfeld'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'anweisung'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'inhaltsTag'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'istRelevant'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'StringFormularFeld'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'multiline'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'options'),
              alias: NameNode(value: 'stringOptions'),
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
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
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'istRelevant'),
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
              name: NameNode(value: 'durchsuchbar'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'validationType'),
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
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'UploadFormularFeld'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'brauchtFreigabe'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'multi'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'document'),
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
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'CheckboxListFormularFeld'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'options'),
              alias: NameNode(value: 'checkOptions'),
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'key'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'label'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'defaultChecked'),
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
      InlineFragmentNode(
        typeCondition: TypeConditionNode(
          on: NamedTypeNode(
            name: NameNode(value: 'AnzeigeTextBlockFeld'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
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
);
const documentNodeFragmentFormularFeld = DocumentNode(
  definitions: [fragmentDefinitionFormularFeld],
);

extension ClientExtension_Fragment_FormularFeld on graphql.GraphQLClient {
  void writeFragment_FormularFeld({
    required Fragment_FormularFeld data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'FormularFeld',
        document: documentNodeFragmentFormularFeld,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_FormularFeld? readFragment_FormularFeld({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'FormularFeld',
          document: documentNodeFragmentFormularFeld,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_FormularFeld.fromJson(result);
  }
}

class Fragment_FormularFeld__StringFormularFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__StringFormularFeld({
    required this.multiline,
    required this.stringOptions,
    required this.durchsuchbar,
    required this.validationType,
    this.$__typename = 'StringFormularFeld',
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
  });

  factory Fragment_FormularFeld__StringFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$multiline = json['multiline'];
    final l$stringOptions = json['stringOptions'];
    final l$durchsuchbar = json['durchsuchbar'];
    final l$validationType = json['validationType'];
    final l$$__typename = json['__typename'];
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    return Fragment_FormularFeld__StringFormularFeld(
      multiline: (l$multiline as bool),
      stringOptions: (l$stringOptions as List<dynamic>)
          .map(
            (e) =>
                Fragment_FormularFeld__StringFormularFeld_stringOptions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      durchsuchbar: (l$durchsuchbar as bool),
      validationType: fromJson_Enum_StringValidationType(
        (l$validationType as String),
      ),
      $__typename: (l$$__typename as String),
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
    );
  }

  final bool multiline;

  final List<Fragment_FormularFeld__StringFormularFeld_stringOptions>
  stringOptions;

  final bool durchsuchbar;

  final Enum_StringValidationType validationType;

  final String $__typename;

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$multiline = multiline;
    _resultData['multiline'] = l$multiline;
    final l$stringOptions = stringOptions;
    _resultData['stringOptions'] = l$stringOptions
        .map((e) => e.toJson())
        .toList();
    final l$durchsuchbar = durchsuchbar;
    _resultData['durchsuchbar'] = l$durchsuchbar;
    final l$validationType = validationType;
    _resultData['validationType'] = toJson_Enum_StringValidationType(
      l$validationType,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$multiline = multiline;
    final l$stringOptions = stringOptions;
    final l$durchsuchbar = durchsuchbar;
    final l$validationType = validationType;
    final l$$__typename = $__typename;
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    return Object.hashAll([
      l$multiline,
      Object.hashAll(l$stringOptions.map((v) => v)),
      l$durchsuchbar,
      l$validationType,
      l$$__typename,
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__StringFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$multiline = multiline;
    final lOther$multiline = other.multiline;
    if (l$multiline != lOther$multiline) {
      return false;
    }
    final l$stringOptions = stringOptions;
    final lOther$stringOptions = other.stringOptions;
    if (l$stringOptions.length != lOther$stringOptions.length) {
      return false;
    }
    for (int i = 0; i < l$stringOptions.length; i++) {
      final l$stringOptions$entry = l$stringOptions[i];
      final lOther$stringOptions$entry = lOther$stringOptions[i];
      if (l$stringOptions$entry != lOther$stringOptions$entry) {
        return false;
      }
    }
    final l$durchsuchbar = durchsuchbar;
    final lOther$durchsuchbar = other.durchsuchbar;
    if (l$durchsuchbar != lOther$durchsuchbar) {
      return false;
    }
    final l$validationType = validationType;
    final lOther$validationType = other.validationType;
    if (l$validationType != lOther$validationType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_FormularFeld__StringFormularFeld
    on Fragment_FormularFeld__StringFormularFeld {
  CopyWith_Fragment_FormularFeld__StringFormularFeld<
    Fragment_FormularFeld__StringFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__StringFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__StringFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__StringFormularFeld(
    Fragment_FormularFeld__StringFormularFeld instance,
    TRes Function(Fragment_FormularFeld__StringFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld;

  factory CopyWith_Fragment_FormularFeld__StringFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld;

  TRes call({
    bool? multiline,
    List<Fragment_FormularFeld__StringFormularFeld_stringOptions>?
    stringOptions,
    bool? durchsuchbar,
    Enum_StringValidationType? validationType,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  });
  TRes stringOptions(
    Iterable<Fragment_FormularFeld__StringFormularFeld_stringOptions> Function(
      Iterable<
        CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<
          Fragment_FormularFeld__StringFormularFeld_stringOptions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__StringFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__StringFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__StringFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? multiline = _undefined,
    Object? stringOptions = _undefined,
    Object? durchsuchbar = _undefined,
    Object? validationType = _undefined,
    Object? $__typename = _undefined,
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
  }) => _then(
    Fragment_FormularFeld__StringFormularFeld(
      multiline: multiline == _undefined || multiline == null
          ? _instance.multiline
          : (multiline as bool),
      stringOptions: stringOptions == _undefined || stringOptions == null
          ? _instance.stringOptions
          : (stringOptions
                as List<
                  Fragment_FormularFeld__StringFormularFeld_stringOptions
                >),
      durchsuchbar: durchsuchbar == _undefined || durchsuchbar == null
          ? _instance.durchsuchbar
          : (durchsuchbar as bool),
      validationType: validationType == _undefined || validationType == null
          ? _instance.validationType
          : (validationType as Enum_StringValidationType),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
    ),
  );

  TRes stringOptions(
    Iterable<Fragment_FormularFeld__StringFormularFeld_stringOptions> Function(
      Iterable<
        CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<
          Fragment_FormularFeld__StringFormularFeld_stringOptions
        >
      >,
    )
    _fn,
  ) => call(
    stringOptions: _fn(
      _instance.stringOptions.map(
        (e) => CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__StringFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld(this._res);

  TRes _res;

  call({
    bool? multiline,
    List<Fragment_FormularFeld__StringFormularFeld_stringOptions>?
    stringOptions,
    bool? durchsuchbar,
    Enum_StringValidationType? validationType,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  }) => _res;

  stringOptions(_fn) => _res;
}

class Fragment_FormularFeld__StringFormularFeld_stringOptions {
  Fragment_FormularFeld__StringFormularFeld_stringOptions({
    required this.key,
    required this.value,
    this.istRelevant,
    this.$__typename = 'StringFormularFeldOption',
  });

  factory Fragment_FormularFeld__StringFormularFeld_stringOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$key = json['key'];
    final l$value = json['value'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__StringFormularFeld_stringOptions(
      key: (l$key as String),
      value: (l$value as String),
      istRelevant: l$istRelevant == null
          ? null
          : boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String key;

  final String value;

  final BoolExpression? istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$key = key;
    _resultData['key'] = l$key;
    final l$value = value;
    _resultData['value'] = l$value;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = l$istRelevant == null
        ? null
        : boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$key = key;
    final l$value = value;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([l$key, l$value, l$istRelevant, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__StringFormularFeld_stringOptions ||
        runtimeType != other.runtimeType) {
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
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld__StringFormularFeld_stringOptions
    on Fragment_FormularFeld__StringFormularFeld_stringOptions {
  CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<
    Fragment_FormularFeld__StringFormularFeld_stringOptions
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<
  TRes
> {
  factory CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions(
    Fragment_FormularFeld__StringFormularFeld_stringOptions instance,
    TRes Function(Fragment_FormularFeld__StringFormularFeld_stringOptions) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions;

  factory CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions;

  TRes call({
    String? key,
    String? value,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions<
  TRes
>
    implements
        CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__StringFormularFeld_stringOptions _instance;

  final TRes Function(Fragment_FormularFeld__StringFormularFeld_stringOptions)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? key = _undefined,
    Object? value = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__StringFormularFeld_stringOptions(
      key: key == _undefined || key == null ? _instance.key : (key as String),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as String),
      istRelevant: istRelevant == _undefined
          ? _instance.istRelevant
          : (istRelevant as BoolExpression?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions<
  TRes
>
    implements
        CopyWith_Fragment_FormularFeld__StringFormularFeld_stringOptions<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__StringFormularFeld_stringOptions(
    this._res,
  );

  TRes _res;

  call({
    String? key,
    String? value,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld__UploadFormularFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__UploadFormularFeld({
    required this.brauchtFreigabe,
    required this.multi,
    required this.document,
    this.$__typename = 'UploadFormularFeld',
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
  });

  factory Fragment_FormularFeld__UploadFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$brauchtFreigabe = json['brauchtFreigabe'];
    final l$multi = json['multi'];
    final l$document = json['document'];
    final l$$__typename = json['__typename'];
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    return Fragment_FormularFeld__UploadFormularFeld(
      brauchtFreigabe: (l$brauchtFreigabe as bool),
      multi: (l$multi as bool),
      document: (l$document as bool),
      $__typename: (l$$__typename as String),
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
    );
  }

  final bool brauchtFreigabe;

  final bool multi;

  final bool document;

  final String $__typename;

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$brauchtFreigabe = brauchtFreigabe;
    _resultData['brauchtFreigabe'] = l$brauchtFreigabe;
    final l$multi = multi;
    _resultData['multi'] = l$multi;
    final l$document = document;
    _resultData['document'] = l$document;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$brauchtFreigabe = brauchtFreigabe;
    final l$multi = multi;
    final l$document = document;
    final l$$__typename = $__typename;
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    return Object.hashAll([
      l$brauchtFreigabe,
      l$multi,
      l$document,
      l$$__typename,
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__UploadFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$brauchtFreigabe = brauchtFreigabe;
    final lOther$brauchtFreigabe = other.brauchtFreigabe;
    if (l$brauchtFreigabe != lOther$brauchtFreigabe) {
      return false;
    }
    final l$multi = multi;
    final lOther$multi = other.multi;
    if (l$multi != lOther$multi) {
      return false;
    }
    final l$document = document;
    final lOther$document = other.document;
    if (l$document != lOther$document) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_FormularFeld__UploadFormularFeld
    on Fragment_FormularFeld__UploadFormularFeld {
  CopyWith_Fragment_FormularFeld__UploadFormularFeld<
    Fragment_FormularFeld__UploadFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__UploadFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__UploadFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__UploadFormularFeld(
    Fragment_FormularFeld__UploadFormularFeld instance,
    TRes Function(Fragment_FormularFeld__UploadFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__UploadFormularFeld;

  factory CopyWith_Fragment_FormularFeld__UploadFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__UploadFormularFeld;

  TRes call({
    bool? brauchtFreigabe,
    bool? multi,
    bool? document,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__UploadFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__UploadFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__UploadFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__UploadFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__UploadFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? brauchtFreigabe = _undefined,
    Object? multi = _undefined,
    Object? document = _undefined,
    Object? $__typename = _undefined,
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
  }) => _then(
    Fragment_FormularFeld__UploadFormularFeld(
      brauchtFreigabe: brauchtFreigabe == _undefined || brauchtFreigabe == null
          ? _instance.brauchtFreigabe
          : (brauchtFreigabe as bool),
      multi: multi == _undefined || multi == null
          ? _instance.multi
          : (multi as bool),
      document: document == _undefined || document == null
          ? _instance.document
          : (document as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__UploadFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__UploadFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__UploadFormularFeld(this._res);

  TRes _res;

  call({
    bool? brauchtFreigabe,
    bool? multi,
    bool? document,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  }) => _res;
}

class Fragment_FormularFeld__CheckboxListFormularFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__CheckboxListFormularFeld({
    required this.checkOptions,
    this.$__typename = 'CheckboxListFormularFeld',
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
  });

  factory Fragment_FormularFeld__CheckboxListFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$checkOptions = json['checkOptions'];
    final l$$__typename = json['__typename'];
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    return Fragment_FormularFeld__CheckboxListFormularFeld(
      checkOptions: (l$checkOptions as List<dynamic>)
          .map(
            (e) =>
                Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
    );
  }

  final List<Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions>
  checkOptions;

  final String $__typename;

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$checkOptions = checkOptions;
    _resultData['checkOptions'] = l$checkOptions
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$checkOptions = checkOptions;
    final l$$__typename = $__typename;
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    return Object.hashAll([
      Object.hashAll(l$checkOptions.map((v) => v)),
      l$$__typename,
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__CheckboxListFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$checkOptions = checkOptions;
    final lOther$checkOptions = other.checkOptions;
    if (l$checkOptions.length != lOther$checkOptions.length) {
      return false;
    }
    for (int i = 0; i < l$checkOptions.length; i++) {
      final l$checkOptions$entry = l$checkOptions[i];
      final lOther$checkOptions$entry = lOther$checkOptions[i];
      if (l$checkOptions$entry != lOther$checkOptions$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_FormularFeld__CheckboxListFormularFeld
    on Fragment_FormularFeld__CheckboxListFormularFeld {
  CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld<
    Fragment_FormularFeld__CheckboxListFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld(
    Fragment_FormularFeld__CheckboxListFormularFeld instance,
    TRes Function(Fragment_FormularFeld__CheckboxListFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld;

  factory CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld;

  TRes call({
    List<Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions>?
    checkOptions,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  });
  TRes checkOptions(
    Iterable<Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions>
    Function(
      Iterable<
        CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
          Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__CheckboxListFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__CheckboxListFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? checkOptions = _undefined,
    Object? $__typename = _undefined,
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
  }) => _then(
    Fragment_FormularFeld__CheckboxListFormularFeld(
      checkOptions: checkOptions == _undefined || checkOptions == null
          ? _instance.checkOptions
          : (checkOptions
                as List<
                  Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
    ),
  );

  TRes checkOptions(
    Iterable<Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions>
    Function(
      Iterable<
        CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
          Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions
        >
      >,
    )
    _fn,
  ) => call(
    checkOptions: _fn(
      _instance.checkOptions.map(
        (e) =>
            CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld(this._res);

  TRes _res;

  call({
    List<Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions>?
    checkOptions,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  }) => _res;

  checkOptions(_fn) => _res;
}

class Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions {
  Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions({
    required this.key,
    required this.label,
    required this.defaultChecked,
    this.$__typename = 'CheckboxListFeldOption',
  });

  factory Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$key = json['key'];
    final l$label = json['label'];
    final l$defaultChecked = json['defaultChecked'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
      key: (l$key as String),
      label: (l$label as String),
      defaultChecked: (l$defaultChecked as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String key;

  final String label;

  final bool defaultChecked;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$key = key;
    _resultData['key'] = l$key;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$defaultChecked = defaultChecked;
    _resultData['defaultChecked'] = l$defaultChecked;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$key = key;
    final l$label = label;
    final l$defaultChecked = defaultChecked;
    final l$$__typename = $__typename;
    return Object.hashAll([l$key, l$label, l$defaultChecked, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$key = key;
    final lOther$key = other.key;
    if (l$key != lOther$key) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
      return false;
    }
    final l$defaultChecked = defaultChecked;
    final lOther$defaultChecked = other.defaultChecked;
    if (l$defaultChecked != lOther$defaultChecked) {
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

extension UtilityExtension_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions
    on Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions {
  CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
    Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
  TRes
> {
  factory CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
    Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions instance,
    TRes Function(Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions)
    then,
  ) = _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions;

  factory CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions;

  TRes call({
    String? key,
    String? label,
    bool? defaultChecked,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
  TRes
>
    implements
        CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
          TRes
        > {
  _CopyWithImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions _instance;

  final TRes Function(
    Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? key = _undefined,
    Object? label = _undefined,
    Object? defaultChecked = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
      key: key == _undefined || key == null ? _instance.key : (key as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
      defaultChecked: defaultChecked == _undefined || defaultChecked == null
          ? _instance.defaultChecked
          : (defaultChecked as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
  TRes
>
    implements
        CopyWith_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions<
          TRes
        > {
  _CopyWithStubImpl_Fragment_FormularFeld__CheckboxListFormularFeld_checkOptions(
    this._res,
  );

  TRes _res;

  call({
    String? key,
    String? label,
    bool? defaultChecked,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld__AnzeigeTextBlockFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__AnzeigeTextBlockFeld({
    required this.text,
    this.$__typename = 'AnzeigeTextBlockFeld',
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
  });

  factory Fragment_FormularFeld__AnzeigeTextBlockFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$text = json['text'];
    final l$$__typename = json['__typename'];
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    return Fragment_FormularFeld__AnzeigeTextBlockFeld(
      text: (l$text as String),
      $__typename: (l$$__typename as String),
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
    );
  }

  final String text;

  final String $__typename;

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$text = text;
    _resultData['text'] = l$text;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$text = text;
    final l$$__typename = $__typename;
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    return Object.hashAll([
      l$text,
      l$$__typename,
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__AnzeigeTextBlockFeld ||
        runtimeType != other.runtimeType) {
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
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_FormularFeld__AnzeigeTextBlockFeld
    on Fragment_FormularFeld__AnzeigeTextBlockFeld {
  CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld<
    Fragment_FormularFeld__AnzeigeTextBlockFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld(
    Fragment_FormularFeld__AnzeigeTextBlockFeld instance,
    TRes Function(Fragment_FormularFeld__AnzeigeTextBlockFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld;

  factory CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld;

  TRes call({
    String? text,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__AnzeigeTextBlockFeld _instance;

  final TRes Function(Fragment_FormularFeld__AnzeigeTextBlockFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? text = _undefined,
    Object? $__typename = _undefined,
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
  }) => _then(
    Fragment_FormularFeld__AnzeigeTextBlockFeld(
      text: text == _undefined || text == null
          ? _instance.text
          : (text as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__AnzeigeTextBlockFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__AnzeigeTextBlockFeld(this._res);

  TRes _res;

  call({
    String? text,
    String? $__typename,
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
  }) => _res;
}

class Fragment_FormularFeld__DateFormularFeld implements Fragment_FormularFeld {
  Fragment_FormularFeld__DateFormularFeld({
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
    this.$__typename = 'DateFormularFeld',
  });

  factory Fragment_FormularFeld__DateFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__DateFormularFeld(
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__DateFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld__DateFormularFeld
    on Fragment_FormularFeld__DateFormularFeld {
  CopyWith_Fragment_FormularFeld__DateFormularFeld<
    Fragment_FormularFeld__DateFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__DateFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__DateFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__DateFormularFeld(
    Fragment_FormularFeld__DateFormularFeld instance,
    TRes Function(Fragment_FormularFeld__DateFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__DateFormularFeld;

  factory CopyWith_Fragment_FormularFeld__DateFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__DateFormularFeld;

  TRes call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__DateFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__DateFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__DateFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__DateFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__DateFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__DateFormularFeld(
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__DateFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__DateFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__DateFormularFeld(this._res);

  TRes _res;

  call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld__LocationFormularFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__LocationFormularFeld({
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
    this.$__typename = 'LocationFormularFeld',
  });

  factory Fragment_FormularFeld__LocationFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__LocationFormularFeld(
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__LocationFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld__LocationFormularFeld
    on Fragment_FormularFeld__LocationFormularFeld {
  CopyWith_Fragment_FormularFeld__LocationFormularFeld<
    Fragment_FormularFeld__LocationFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__LocationFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__LocationFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__LocationFormularFeld(
    Fragment_FormularFeld__LocationFormularFeld instance,
    TRes Function(Fragment_FormularFeld__LocationFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__LocationFormularFeld;

  factory CopyWith_Fragment_FormularFeld__LocationFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__LocationFormularFeld;

  TRes call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__LocationFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__LocationFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__LocationFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__LocationFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__LocationFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__LocationFormularFeld(
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__LocationFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__LocationFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__LocationFormularFeld(this._res);

  TRes _res;

  call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld__SignatureFormularFeld
    implements Fragment_FormularFeld {
  Fragment_FormularFeld__SignatureFormularFeld({
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
    this.$__typename = 'SignatureFormularFeld',
  });

  factory Fragment_FormularFeld__SignatureFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__SignatureFormularFeld(
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__SignatureFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld__SignatureFormularFeld
    on Fragment_FormularFeld__SignatureFormularFeld {
  CopyWith_Fragment_FormularFeld__SignatureFormularFeld<
    Fragment_FormularFeld__SignatureFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__SignatureFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__SignatureFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__SignatureFormularFeld(
    Fragment_FormularFeld__SignatureFormularFeld instance,
    TRes Function(Fragment_FormularFeld__SignatureFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__SignatureFormularFeld;

  factory CopyWith_Fragment_FormularFeld__SignatureFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__SignatureFormularFeld;

  TRes call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__SignatureFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__SignatureFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__SignatureFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__SignatureFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__SignatureFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__SignatureFormularFeld(
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__SignatureFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__SignatureFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__SignatureFormularFeld(this._res);

  TRes _res;

  call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Fragment_FormularFeld__TimeFormularFeld implements Fragment_FormularFeld {
  Fragment_FormularFeld__TimeFormularFeld({
    this.angezeigterName,
    required this.slotName,
    required this.pflichtfeld,
    this.anweisung,
    this.inhaltsTag,
    required this.istRelevant,
    this.$__typename = 'TimeFormularFeld',
  });

  factory Fragment_FormularFeld__TimeFormularFeld.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$angezeigterName = json['angezeigterName'];
    final l$slotName = json['slotName'];
    final l$pflichtfeld = json['pflichtfeld'];
    final l$anweisung = json['anweisung'];
    final l$inhaltsTag = json['inhaltsTag'];
    final l$istRelevant = json['istRelevant'];
    final l$$__typename = json['__typename'];
    return Fragment_FormularFeld__TimeFormularFeld(
      angezeigterName: (l$angezeigterName as String?),
      slotName: (l$slotName as String),
      pflichtfeld: (l$pflichtfeld as bool),
      anweisung: (l$anweisung as String?),
      inhaltsTag: (l$inhaltsTag as String?),
      istRelevant: boolExpressionFromJson(l$istRelevant),
      $__typename: (l$$__typename as String),
    );
  }

  final String? angezeigterName;

  final String slotName;

  final bool pflichtfeld;

  final String? anweisung;

  final String? inhaltsTag;

  final BoolExpression istRelevant;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$angezeigterName = angezeigterName;
    _resultData['angezeigterName'] = l$angezeigterName;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$pflichtfeld = pflichtfeld;
    _resultData['pflichtfeld'] = l$pflichtfeld;
    final l$anweisung = anweisung;
    _resultData['anweisung'] = l$anweisung;
    final l$inhaltsTag = inhaltsTag;
    _resultData['inhaltsTag'] = l$inhaltsTag;
    final l$istRelevant = istRelevant;
    _resultData['istRelevant'] = boolExpressionToJson(l$istRelevant);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$angezeigterName = angezeigterName;
    final l$slotName = slotName;
    final l$pflichtfeld = pflichtfeld;
    final l$anweisung = anweisung;
    final l$inhaltsTag = inhaltsTag;
    final l$istRelevant = istRelevant;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$angezeigterName,
      l$slotName,
      l$pflichtfeld,
      l$anweisung,
      l$inhaltsTag,
      l$istRelevant,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_FormularFeld__TimeFormularFeld ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$angezeigterName = angezeigterName;
    final lOther$angezeigterName = other.angezeigterName;
    if (l$angezeigterName != lOther$angezeigterName) {
      return false;
    }
    final l$slotName = slotName;
    final lOther$slotName = other.slotName;
    if (l$slotName != lOther$slotName) {
      return false;
    }
    final l$pflichtfeld = pflichtfeld;
    final lOther$pflichtfeld = other.pflichtfeld;
    if (l$pflichtfeld != lOther$pflichtfeld) {
      return false;
    }
    final l$anweisung = anweisung;
    final lOther$anweisung = other.anweisung;
    if (l$anweisung != lOther$anweisung) {
      return false;
    }
    final l$inhaltsTag = inhaltsTag;
    final lOther$inhaltsTag = other.inhaltsTag;
    if (l$inhaltsTag != lOther$inhaltsTag) {
      return false;
    }
    final l$istRelevant = istRelevant;
    final lOther$istRelevant = other.istRelevant;
    if (l$istRelevant != lOther$istRelevant) {
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

extension UtilityExtension_Fragment_FormularFeld__TimeFormularFeld
    on Fragment_FormularFeld__TimeFormularFeld {
  CopyWith_Fragment_FormularFeld__TimeFormularFeld<
    Fragment_FormularFeld__TimeFormularFeld
  >
  get copyWith =>
      CopyWith_Fragment_FormularFeld__TimeFormularFeld(this, (i) => i);
}

abstract class CopyWith_Fragment_FormularFeld__TimeFormularFeld<TRes> {
  factory CopyWith_Fragment_FormularFeld__TimeFormularFeld(
    Fragment_FormularFeld__TimeFormularFeld instance,
    TRes Function(Fragment_FormularFeld__TimeFormularFeld) then,
  ) = _CopyWithImpl_Fragment_FormularFeld__TimeFormularFeld;

  factory CopyWith_Fragment_FormularFeld__TimeFormularFeld.stub(TRes res) =
      _CopyWithStubImpl_Fragment_FormularFeld__TimeFormularFeld;

  TRes call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_FormularFeld__TimeFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__TimeFormularFeld<TRes> {
  _CopyWithImpl_Fragment_FormularFeld__TimeFormularFeld(
    this._instance,
    this._then,
  );

  final Fragment_FormularFeld__TimeFormularFeld _instance;

  final TRes Function(Fragment_FormularFeld__TimeFormularFeld) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? angezeigterName = _undefined,
    Object? slotName = _undefined,
    Object? pflichtfeld = _undefined,
    Object? anweisung = _undefined,
    Object? inhaltsTag = _undefined,
    Object? istRelevant = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_FormularFeld__TimeFormularFeld(
      angezeigterName: angezeigterName == _undefined
          ? _instance.angezeigterName
          : (angezeigterName as String?),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      pflichtfeld: pflichtfeld == _undefined || pflichtfeld == null
          ? _instance.pflichtfeld
          : (pflichtfeld as bool),
      anweisung: anweisung == _undefined
          ? _instance.anweisung
          : (anweisung as String?),
      inhaltsTag: inhaltsTag == _undefined
          ? _instance.inhaltsTag
          : (inhaltsTag as String?),
      istRelevant: istRelevant == _undefined || istRelevant == null
          ? _instance.istRelevant
          : (istRelevant as BoolExpression),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_FormularFeld__TimeFormularFeld<TRes>
    implements CopyWith_Fragment_FormularFeld__TimeFormularFeld<TRes> {
  _CopyWithStubImpl_Fragment_FormularFeld__TimeFormularFeld(this._res);

  TRes _res;

  call({
    String? angezeigterName,
    String? slotName,
    bool? pflichtfeld,
    String? anweisung,
    String? inhaltsTag,
    BoolExpression? istRelevant,
    String? $__typename,
  }) => _res;
}

class Variables_Query_SpecialProzess {
  factory Variables_Query_SpecialProzess({
    required String kommuneId,
    required String tag,
  }) =>
      Variables_Query_SpecialProzess._({r'kommuneId': kommuneId, r'tag': tag});

  Variables_Query_SpecialProzess._(this._$data);

  factory Variables_Query_SpecialProzess.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$tag = data['tag'];
    result$data['tag'] = (l$tag as String);
    return Variables_Query_SpecialProzess._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get tag => (_$data['tag'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$tag = tag;
    result$data['tag'] = l$tag;
    return result$data;
  }

  CopyWith_Variables_Query_SpecialProzess<Variables_Query_SpecialProzess>
  get copyWith => CopyWith_Variables_Query_SpecialProzess(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_SpecialProzess ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$tag = tag;
    final lOther$tag = other.tag;
    if (l$tag != lOther$tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$tag = tag;
    return Object.hashAll([l$kommuneId, l$tag]);
  }
}

abstract class CopyWith_Variables_Query_SpecialProzess<TRes> {
  factory CopyWith_Variables_Query_SpecialProzess(
    Variables_Query_SpecialProzess instance,
    TRes Function(Variables_Query_SpecialProzess) then,
  ) = _CopyWithImpl_Variables_Query_SpecialProzess;

  factory CopyWith_Variables_Query_SpecialProzess.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_SpecialProzess;

  TRes call({String? kommuneId, String? tag});
}

class _CopyWithImpl_Variables_Query_SpecialProzess<TRes>
    implements CopyWith_Variables_Query_SpecialProzess<TRes> {
  _CopyWithImpl_Variables_Query_SpecialProzess(this._instance, this._then);

  final Variables_Query_SpecialProzess _instance;

  final TRes Function(Variables_Query_SpecialProzess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? tag = _undefined}) =>
      _then(
        Variables_Query_SpecialProzess._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (tag != _undefined && tag != null) 'tag': (tag as String),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_SpecialProzess<TRes>
    implements CopyWith_Variables_Query_SpecialProzess<TRes> {
  _CopyWithStubImpl_Variables_Query_SpecialProzess(this._res);

  TRes _res;

  call({String? kommuneId, String? tag}) => _res;
}

class Query_SpecialProzess {
  Query_SpecialProzess({required this.kommune, this.$__typename = 'Query'});

  factory Query_SpecialProzess.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_SpecialProzess(
      kommune: Query_SpecialProzess_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_SpecialProzess_kommune kommune;

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
    if (other is! Query_SpecialProzess || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_SpecialProzess on Query_SpecialProzess {
  CopyWith_Query_SpecialProzess<Query_SpecialProzess> get copyWith =>
      CopyWith_Query_SpecialProzess(this, (i) => i);
}

abstract class CopyWith_Query_SpecialProzess<TRes> {
  factory CopyWith_Query_SpecialProzess(
    Query_SpecialProzess instance,
    TRes Function(Query_SpecialProzess) then,
  ) = _CopyWithImpl_Query_SpecialProzess;

  factory CopyWith_Query_SpecialProzess.stub(TRes res) =
      _CopyWithStubImpl_Query_SpecialProzess;

  TRes call({Query_SpecialProzess_kommune? kommune, String? $__typename});
  CopyWith_Query_SpecialProzess_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_SpecialProzess<TRes>
    implements CopyWith_Query_SpecialProzess<TRes> {
  _CopyWithImpl_Query_SpecialProzess(this._instance, this._then);

  final Query_SpecialProzess _instance;

  final TRes Function(Query_SpecialProzess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_SpecialProzess(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_SpecialProzess_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_SpecialProzess_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_SpecialProzess_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_SpecialProzess<TRes>
    implements CopyWith_Query_SpecialProzess<TRes> {
  _CopyWithStubImpl_Query_SpecialProzess(this._res);

  TRes _res;

  call({Query_SpecialProzess_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_SpecialProzess_kommune<TRes> get kommune =>
      CopyWith_Query_SpecialProzess_kommune.stub(_res);
}

const documentNodeQuerySpecialProzess = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SpecialProzess'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tag')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
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
                  name: NameNode(value: 'prozessByTag'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'tag'),
                      value: VariableNode(name: NameNode(value: 'tag')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'Prozess'),
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
    fragmentDefinitionProzess,
    fragmentDefinitionProzessOwnData,
    fragmentDefinitionKommuneCrypto,
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
  ],
);
Query_SpecialProzess _parserFn_Query_SpecialProzess(
  Map<String, dynamic> data,
) => Query_SpecialProzess.fromJson(data);
typedef OnQueryComplete_Query_SpecialProzess =
    FutureOr<void> Function(Map<String, dynamic>?, Query_SpecialProzess?);

class Options_Query_SpecialProzess
    extends graphql.QueryOptions<Query_SpecialProzess> {
  Options_Query_SpecialProzess({
    String? operationName,
    required Variables_Query_SpecialProzess variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_SpecialProzess? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_SpecialProzess? onComplete,
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
                 data == null ? null : _parserFn_Query_SpecialProzess(data),
               ),
         onError: onError,
         document: documentNodeQuerySpecialProzess,
         parserFn: _parserFn_Query_SpecialProzess,
       );

  final OnQueryComplete_Query_SpecialProzess? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_SpecialProzess
    extends graphql.WatchQueryOptions<Query_SpecialProzess> {
  WatchOptions_Query_SpecialProzess({
    String? operationName,
    required Variables_Query_SpecialProzess variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_SpecialProzess? typedOptimisticResult,
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
         document: documentNodeQuerySpecialProzess,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_SpecialProzess,
       );
}

class FetchMoreOptions_Query_SpecialProzess extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_SpecialProzess({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_SpecialProzess variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySpecialProzess,
       );
}

extension ClientExtension_Query_SpecialProzess on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_SpecialProzess>> query_SpecialProzess(
    Options_Query_SpecialProzess options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_SpecialProzess> watchQuery_SpecialProzess(
    WatchOptions_Query_SpecialProzess options,
  ) => this.watchQuery(options);

  void writeQuery_SpecialProzess({
    required Query_SpecialProzess data,
    required Variables_Query_SpecialProzess variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySpecialProzess),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_SpecialProzess? readQuery_SpecialProzess({
    required Variables_Query_SpecialProzess variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySpecialProzess),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_SpecialProzess.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_SpecialProzess> useQuery_SpecialProzess(
  Options_Query_SpecialProzess options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_SpecialProzess> useWatchQuery_SpecialProzess(
  WatchOptions_Query_SpecialProzess options,
) => graphql_flutter.useWatchQuery(options);

class Query_SpecialProzess_Widget
    extends graphql_flutter.Query<Query_SpecialProzess> {
  Query_SpecialProzess_Widget({
    widgets.Key? key,
    required Options_Query_SpecialProzess options,
    required graphql_flutter.QueryBuilder<Query_SpecialProzess> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_SpecialProzess_kommune {
  Query_SpecialProzess_kommune({
    required this.prozessByTag,
    this.$__typename = 'Kommune',
  });

  factory Query_SpecialProzess_kommune.fromJson(Map<String, dynamic> json) {
    final l$prozessByTag = json['prozessByTag'];
    final l$$__typename = json['__typename'];
    return Query_SpecialProzess_kommune(
      prozessByTag: Fragment_Prozess.fromJson(
        (l$prozessByTag as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_Prozess prozessByTag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$prozessByTag = prozessByTag;
    _resultData['prozessByTag'] = l$prozessByTag.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$prozessByTag = prozessByTag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$prozessByTag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_SpecialProzess_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$prozessByTag = prozessByTag;
    final lOther$prozessByTag = other.prozessByTag;
    if (l$prozessByTag != lOther$prozessByTag) {
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

extension UtilityExtension_Query_SpecialProzess_kommune
    on Query_SpecialProzess_kommune {
  CopyWith_Query_SpecialProzess_kommune<Query_SpecialProzess_kommune>
  get copyWith => CopyWith_Query_SpecialProzess_kommune(this, (i) => i);
}

abstract class CopyWith_Query_SpecialProzess_kommune<TRes> {
  factory CopyWith_Query_SpecialProzess_kommune(
    Query_SpecialProzess_kommune instance,
    TRes Function(Query_SpecialProzess_kommune) then,
  ) = _CopyWithImpl_Query_SpecialProzess_kommune;

  factory CopyWith_Query_SpecialProzess_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_SpecialProzess_kommune;

  TRes call({Fragment_Prozess? prozessByTag, String? $__typename});
  CopyWith_Fragment_Prozess<TRes> get prozessByTag;
}

class _CopyWithImpl_Query_SpecialProzess_kommune<TRes>
    implements CopyWith_Query_SpecialProzess_kommune<TRes> {
  _CopyWithImpl_Query_SpecialProzess_kommune(this._instance, this._then);

  final Query_SpecialProzess_kommune _instance;

  final TRes Function(Query_SpecialProzess_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? prozessByTag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_SpecialProzess_kommune(
      prozessByTag: prozessByTag == _undefined || prozessByTag == null
          ? _instance.prozessByTag
          : (prozessByTag as Fragment_Prozess),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_Prozess<TRes> get prozessByTag {
    final local$prozessByTag = _instance.prozessByTag;
    return CopyWith_Fragment_Prozess(
      local$prozessByTag,
      (e) => call(prozessByTag: e),
    );
  }
}

class _CopyWithStubImpl_Query_SpecialProzess_kommune<TRes>
    implements CopyWith_Query_SpecialProzess_kommune<TRes> {
  _CopyWithStubImpl_Query_SpecialProzess_kommune(this._res);

  TRes _res;

  call({Fragment_Prozess? prozessByTag, String? $__typename}) => _res;

  CopyWith_Fragment_Prozess<TRes> get prozessByTag =>
      CopyWith_Fragment_Prozess.stub(_res);
}
