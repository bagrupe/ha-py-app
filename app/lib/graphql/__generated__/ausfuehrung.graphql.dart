import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'prozess.graphql.dart';
import 'schema.graphql.dart';

class Fragment_ReportExecutionPlainSlotValue {
  Fragment_ReportExecutionPlainSlotValue({
    required this.id,
    required this.slotName,
    required this.value,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
  });

  factory Fragment_ReportExecutionPlainSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$value = json['value'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    return Fragment_ReportExecutionPlainSlotValue(
      id: (l$id as String),
      slotName: (l$slotName as String),
      value: (l$value as dynamic),
      slotValueCount: (l$slotValueCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slotName;

  final dynamic value;

  final int slotValueCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$value = value;
    _resultData['value'] = l$value;
    final l$slotValueCount = slotValueCount;
    _resultData['slotValueCount'] = l$slotValueCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$slotName = slotName;
    final l$value = value;
    final l$slotValueCount = slotValueCount;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$slotName,
      l$value,
      l$slotValueCount,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_ReportExecutionPlainSlotValue ||
        runtimeType != other.runtimeType) {
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
    return true;
  }
}

extension UtilityExtension_Fragment_ReportExecutionPlainSlotValue
    on Fragment_ReportExecutionPlainSlotValue {
  CopyWith_Fragment_ReportExecutionPlainSlotValue<
    Fragment_ReportExecutionPlainSlotValue
  >
  get copyWith =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue(this, (i) => i);
}

abstract class CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> {
  factory CopyWith_Fragment_ReportExecutionPlainSlotValue(
    Fragment_ReportExecutionPlainSlotValue instance,
    TRes Function(Fragment_ReportExecutionPlainSlotValue) then,
  ) = _CopyWithImpl_Fragment_ReportExecutionPlainSlotValue;

  factory CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ReportExecutionPlainSlotValue;

  TRes call({
    String? id,
    String? slotName,
    dynamic? value,
    int? slotValueCount,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_ReportExecutionPlainSlotValue<TRes>
    implements CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> {
  _CopyWithImpl_Fragment_ReportExecutionPlainSlotValue(
    this._instance,
    this._then,
  );

  final Fragment_ReportExecutionPlainSlotValue _instance;

  final TRes Function(Fragment_ReportExecutionPlainSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? value = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_ReportExecutionPlainSlotValue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as dynamic),
      slotValueCount: slotValueCount == _undefined || slotValueCount == null
          ? _instance.slotValueCount
          : (slotValueCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_ReportExecutionPlainSlotValue<TRes>
    implements CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_ReportExecutionPlainSlotValue(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    dynamic? value,
    int? slotValueCount,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionReportExecutionPlainSlotValue = FragmentDefinitionNode(
  name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
      FieldNode(
        name: NameNode(value: 'value'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'slotValueCount'),
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
const documentNodeFragmentReportExecutionPlainSlotValue = DocumentNode(
  definitions: [fragmentDefinitionReportExecutionPlainSlotValue],
);

extension ClientExtension_Fragment_ReportExecutionPlainSlotValue
    on graphql.GraphQLClient {
  void writeFragment_ReportExecutionPlainSlotValue({
    required Fragment_ReportExecutionPlainSlotValue data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ReportExecutionPlainSlotValue',
        document: documentNodeFragmentReportExecutionPlainSlotValue,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ReportExecutionPlainSlotValue?
  readFragment_ReportExecutionPlainSlotValue({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ReportExecutionPlainSlotValue',
          document: documentNodeFragmentReportExecutionPlainSlotValue,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_ReportExecutionPlainSlotValue.fromJson(result);
  }
}

class Fragment_ReportExecutionSlotValue {
  Fragment_ReportExecutionSlotValue({
    required this.$__typename,
    required this.id,
    required this.slotName,
  });

  factory Fragment_ReportExecutionSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "PlainSlotValue":
        return Fragment_ReportExecutionSlotValue__PlainSlotValue.fromJson(json);

      case "EncryptedSlotValue":
        return Fragment_ReportExecutionSlotValue__EncryptedSlotValue.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        final l$id = json['id'];
        final l$slotName = json['slotName'];
        return Fragment_ReportExecutionSlotValue(
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
    if (other is! Fragment_ReportExecutionSlotValue ||
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

extension UtilityExtension_Fragment_ReportExecutionSlotValue
    on Fragment_ReportExecutionSlotValue {
  CopyWith_Fragment_ReportExecutionSlotValue<Fragment_ReportExecutionSlotValue>
  get copyWith => CopyWith_Fragment_ReportExecutionSlotValue(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_ReportExecutionSlotValue__PlainSlotValue)
    plainSlotValue,
    required _T Function(Fragment_ReportExecutionSlotValue__EncryptedSlotValue)
    encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        return plainSlotValue(
          this as Fragment_ReportExecutionSlotValue__PlainSlotValue,
        );

      case "EncryptedSlotValue":
        return encryptedSlotValue(
          this as Fragment_ReportExecutionSlotValue__EncryptedSlotValue,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_ReportExecutionSlotValue__PlainSlotValue)?
    plainSlotValue,
    _T Function(Fragment_ReportExecutionSlotValue__EncryptedSlotValue)?
    encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        if (plainSlotValue != null) {
          return plainSlotValue(
            this as Fragment_ReportExecutionSlotValue__PlainSlotValue,
          );
        } else {
          return orElse();
        }

      case "EncryptedSlotValue":
        if (encryptedSlotValue != null) {
          return encryptedSlotValue(
            this as Fragment_ReportExecutionSlotValue__EncryptedSlotValue,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_ReportExecutionSlotValue<TRes> {
  factory CopyWith_Fragment_ReportExecutionSlotValue(
    Fragment_ReportExecutionSlotValue instance,
    TRes Function(Fragment_ReportExecutionSlotValue) then,
  ) = _CopyWithImpl_Fragment_ReportExecutionSlotValue;

  factory CopyWith_Fragment_ReportExecutionSlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ReportExecutionSlotValue;

  TRes call({String? $__typename, String? id, String? slotName});
}

class _CopyWithImpl_Fragment_ReportExecutionSlotValue<TRes>
    implements CopyWith_Fragment_ReportExecutionSlotValue<TRes> {
  _CopyWithImpl_Fragment_ReportExecutionSlotValue(this._instance, this._then);

  final Fragment_ReportExecutionSlotValue _instance;

  final TRes Function(Fragment_ReportExecutionSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Fragment_ReportExecutionSlotValue(
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

class _CopyWithStubImpl_Fragment_ReportExecutionSlotValue<TRes>
    implements CopyWith_Fragment_ReportExecutionSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_ReportExecutionSlotValue(this._res);

  TRes _res;

  call({String? $__typename, String? id, String? slotName}) => _res;
}

const fragmentDefinitionReportExecutionSlotValue = FragmentDefinitionNode(
  name: NameNode(value: 'ReportExecutionSlotValue'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SlotValue'), isNonNull: false),
  ),
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
              name: NameNode(value: 'slotValueCount'),
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
const documentNodeFragmentReportExecutionSlotValue = DocumentNode(
  definitions: [fragmentDefinitionReportExecutionSlotValue],
);

extension ClientExtension_Fragment_ReportExecutionSlotValue
    on graphql.GraphQLClient {
  void writeFragment_ReportExecutionSlotValue({
    required Fragment_ReportExecutionSlotValue data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ReportExecutionSlotValue',
        document: documentNodeFragmentReportExecutionSlotValue,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ReportExecutionSlotValue? readFragment_ReportExecutionSlotValue({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ReportExecutionSlotValue',
          document: documentNodeFragmentReportExecutionSlotValue,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_ReportExecutionSlotValue.fromJson(result);
  }
}

class Fragment_ReportExecutionSlotValue__PlainSlotValue
    implements Fragment_ReportExecutionSlotValue {
  Fragment_ReportExecutionSlotValue__PlainSlotValue({
    required this.value,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
    required this.id,
    required this.slotName,
  });

  factory Fragment_ReportExecutionSlotValue__PlainSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$value = json['value'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    return Fragment_ReportExecutionSlotValue__PlainSlotValue(
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
    if (other is! Fragment_ReportExecutionSlotValue__PlainSlotValue ||
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

extension UtilityExtension_Fragment_ReportExecutionSlotValue__PlainSlotValue
    on Fragment_ReportExecutionSlotValue__PlainSlotValue {
  CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue<
    Fragment_ReportExecutionSlotValue__PlainSlotValue
  >
  get copyWith => CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue<
  TRes
> {
  factory CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue(
    Fragment_ReportExecutionSlotValue__PlainSlotValue instance,
    TRes Function(Fragment_ReportExecutionSlotValue__PlainSlotValue) then,
  ) = _CopyWithImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue;

  factory CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue;

  TRes call({
    dynamic? value,
    int? slotValueCount,
    String? $__typename,
    String? id,
    String? slotName,
  });
}

class _CopyWithImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue<TRes>
    implements
        CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue<TRes> {
  _CopyWithImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue(
    this._instance,
    this._then,
  );

  final Fragment_ReportExecutionSlotValue__PlainSlotValue _instance;

  final TRes Function(Fragment_ReportExecutionSlotValue__PlainSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? value = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Fragment_ReportExecutionSlotValue__PlainSlotValue(
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

class _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue<TRes>
    implements
        CopyWith_Fragment_ReportExecutionSlotValue__PlainSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__PlainSlotValue(
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

class Fragment_ReportExecutionSlotValue__EncryptedSlotValue
    implements Fragment_ReportExecutionSlotValue {
  Fragment_ReportExecutionSlotValue__EncryptedSlotValue({
    this.$__typename = 'EncryptedSlotValue',
    required this.id,
    required this.slotName,
  });

  factory Fragment_ReportExecutionSlotValue__EncryptedSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    return Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
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
    if (other is! Fragment_ReportExecutionSlotValue__EncryptedSlotValue ||
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

extension UtilityExtension_Fragment_ReportExecutionSlotValue__EncryptedSlotValue
    on Fragment_ReportExecutionSlotValue__EncryptedSlotValue {
  CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<
    Fragment_ReportExecutionSlotValue__EncryptedSlotValue
  >
  get copyWith =>
      CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<
  TRes
> {
  factory CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
    Fragment_ReportExecutionSlotValue__EncryptedSlotValue instance,
    TRes Function(Fragment_ReportExecutionSlotValue__EncryptedSlotValue) then,
  ) = _CopyWithImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue;

  factory CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue;

  TRes call({String? $__typename, String? id, String? slotName});
}

class _CopyWithImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<TRes>
    implements
        CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<TRes> {
  _CopyWithImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
    this._instance,
    this._then,
  );

  final Fragment_ReportExecutionSlotValue__EncryptedSlotValue _instance;

  final TRes Function(Fragment_ReportExecutionSlotValue__EncryptedSlotValue)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
  }) => _then(
    Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
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

class _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<
  TRes
>
    implements
        CopyWith_Fragment_ReportExecutionSlotValue__EncryptedSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_ReportExecutionSlotValue__EncryptedSlotValue(
    this._res,
  );

  TRes _res;

  call({String? $__typename, String? id, String? slotName}) => _res;
}

class Variables_Query_AusfuehrungHistorie {
  factory Variables_Query_AusfuehrungHistorie({required String id}) =>
      Variables_Query_AusfuehrungHistorie._({r'id': id});

  Variables_Query_AusfuehrungHistorie._(this._$data);

  factory Variables_Query_AusfuehrungHistorie.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_AusfuehrungHistorie._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_AusfuehrungHistorie<
    Variables_Query_AusfuehrungHistorie
  >
  get copyWith => CopyWith_Variables_Query_AusfuehrungHistorie(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AusfuehrungHistorie ||
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

abstract class CopyWith_Variables_Query_AusfuehrungHistorie<TRes> {
  factory CopyWith_Variables_Query_AusfuehrungHistorie(
    Variables_Query_AusfuehrungHistorie instance,
    TRes Function(Variables_Query_AusfuehrungHistorie) then,
  ) = _CopyWithImpl_Variables_Query_AusfuehrungHistorie;

  factory CopyWith_Variables_Query_AusfuehrungHistorie.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AusfuehrungHistorie;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_AusfuehrungHistorie<TRes>
    implements CopyWith_Variables_Query_AusfuehrungHistorie<TRes> {
  _CopyWithImpl_Variables_Query_AusfuehrungHistorie(this._instance, this._then);

  final Variables_Query_AusfuehrungHistorie _instance;

  final TRes Function(Variables_Query_AusfuehrungHistorie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_AusfuehrungHistorie._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_AusfuehrungHistorie<TRes>
    implements CopyWith_Variables_Query_AusfuehrungHistorie<TRes> {
  _CopyWithStubImpl_Variables_Query_AusfuehrungHistorie(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_AusfuehrungHistorie {
  Query_AusfuehrungHistorie({
    required this.ausfuehrung,
    this.$__typename = 'Query',
  });

  factory Query_AusfuehrungHistorie.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrung = json['ausfuehrung'];
    final l$$__typename = json['__typename'];
    return Query_AusfuehrungHistorie(
      ausfuehrung: Query_AusfuehrungHistorie_ausfuehrung.fromJson(
        (l$ausfuehrung as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AusfuehrungHistorie_ausfuehrung ausfuehrung;

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
    if (other is! Query_AusfuehrungHistorie ||
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

extension UtilityExtension_Query_AusfuehrungHistorie
    on Query_AusfuehrungHistorie {
  CopyWith_Query_AusfuehrungHistorie<Query_AusfuehrungHistorie> get copyWith =>
      CopyWith_Query_AusfuehrungHistorie(this, (i) => i);
}

abstract class CopyWith_Query_AusfuehrungHistorie<TRes> {
  factory CopyWith_Query_AusfuehrungHistorie(
    Query_AusfuehrungHistorie instance,
    TRes Function(Query_AusfuehrungHistorie) then,
  ) = _CopyWithImpl_Query_AusfuehrungHistorie;

  factory CopyWith_Query_AusfuehrungHistorie.stub(TRes res) =
      _CopyWithStubImpl_Query_AusfuehrungHistorie;

  TRes call({
    Query_AusfuehrungHistorie_ausfuehrung? ausfuehrung,
    String? $__typename,
  });
  CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> get ausfuehrung;
}

class _CopyWithImpl_Query_AusfuehrungHistorie<TRes>
    implements CopyWith_Query_AusfuehrungHistorie<TRes> {
  _CopyWithImpl_Query_AusfuehrungHistorie(this._instance, this._then);

  final Query_AusfuehrungHistorie _instance;

  final TRes Function(Query_AusfuehrungHistorie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AusfuehrungHistorie(
      ausfuehrung: ausfuehrung == _undefined || ausfuehrung == null
          ? _instance.ausfuehrung
          : (ausfuehrung as Query_AusfuehrungHistorie_ausfuehrung),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> get ausfuehrung {
    final local$ausfuehrung = _instance.ausfuehrung;
    return CopyWith_Query_AusfuehrungHistorie_ausfuehrung(
      local$ausfuehrung,
      (e) => call(ausfuehrung: e),
    );
  }
}

class _CopyWithStubImpl_Query_AusfuehrungHistorie<TRes>
    implements CopyWith_Query_AusfuehrungHistorie<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungHistorie(this._res);

  TRes _res;

  call({
    Query_AusfuehrungHistorie_ausfuehrung? ausfuehrung,
    String? $__typename,
  }) => _res;

  CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> get ausfuehrung =>
      CopyWith_Query_AusfuehrungHistorie_ausfuehrung.stub(_res);
}

const documentNodeQueryAusfuehrungHistorie = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AusfuehrungHistorie'),
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
                  name: NameNode(value: 'slotValue'),
                  alias: NameNode(value: 'titel'),
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'names'),
                      value: ListValueNode(
                        values: [
                          StringValueNode(value: 'titel', isBlock: false),
                          StringValueNode(value: 'title', isBlock: false),
                        ],
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
                  name: NameNode(value: 'slotValue'),
                  alias: NameNode(value: 'beschreibung'),
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'names'),
                      value: ListValueNode(
                        values: [
                          StringValueNode(
                            value: 'beschreibung',
                            isBlock: false,
                          ),
                          StringValueNode(value: 'description', isBlock: false),
                        ],
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
                  name: NameNode(value: 'slotValue'),
                  alias: NameNode(value: 'adresse'),
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'names'),
                      value: ListValueNode(
                        values: [
                          StringValueNode(value: 'adresse', isBlock: false),
                          StringValueNode(value: 'address', isBlock: false),
                        ],
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
                  name: NameNode(value: 'slotValue'),
                  alias: NameNode(value: 'kategorie'),
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'names'),
                      value: ListValueNode(
                        values: [
                          StringValueNode(value: '_kategorie', isBlock: false),
                          StringValueNode(value: '_wurzel', isBlock: false),
                          StringValueNode(value: 'kategorie', isBlock: false),
                          StringValueNode(value: 'category', isBlock: false),
                        ],
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
                  name: NameNode(value: 'slotValue'),
                  alias: NameNode(value: 'bilder'),
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'names'),
                      value: ListValueNode(
                        values: [
                          StringValueNode(value: 'bilder', isBlock: false),
                          StringValueNode(value: 'images', isBlock: false),
                        ],
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionPlainSlotValue'),
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
                  name: NameNode(value: 'slotValues'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'ReportExecutionSlotValue'),
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
                  name: NameNode(value: 'historie'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'HistorieEintrag'),
                        directives: [],
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
    fragmentDefinitionReportExecutionPlainSlotValue,
    fragmentDefinitionReportExecutionSlotValue,
    fragmentDefinitionProzessVersion,
    fragmentDefinitionProzessVersionOwnData,
    fragmentDefinitionSchritt,
    fragmentDefinitionFormularFeld,
    fragmentDefinitionProzessOwnData,
    fragmentDefinitionHistorieEintrag,
  ],
);
Query_AusfuehrungHistorie _parserFn_Query_AusfuehrungHistorie(
  Map<String, dynamic> data,
) => Query_AusfuehrungHistorie.fromJson(data);
typedef OnQueryComplete_Query_AusfuehrungHistorie =
    FutureOr<void> Function(Map<String, dynamic>?, Query_AusfuehrungHistorie?);

class Options_Query_AusfuehrungHistorie
    extends graphql.QueryOptions<Query_AusfuehrungHistorie> {
  Options_Query_AusfuehrungHistorie({
    String? operationName,
    required Variables_Query_AusfuehrungHistorie variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AusfuehrungHistorie? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AusfuehrungHistorie? onComplete,
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
                     : _parserFn_Query_AusfuehrungHistorie(data),
               ),
         onError: onError,
         document: documentNodeQueryAusfuehrungHistorie,
         parserFn: _parserFn_Query_AusfuehrungHistorie,
       );

  final OnQueryComplete_Query_AusfuehrungHistorie? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AusfuehrungHistorie
    extends graphql.WatchQueryOptions<Query_AusfuehrungHistorie> {
  WatchOptions_Query_AusfuehrungHistorie({
    String? operationName,
    required Variables_Query_AusfuehrungHistorie variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AusfuehrungHistorie? typedOptimisticResult,
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
         document: documentNodeQueryAusfuehrungHistorie,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AusfuehrungHistorie,
       );
}

class FetchMoreOptions_Query_AusfuehrungHistorie
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AusfuehrungHistorie({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AusfuehrungHistorie variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAusfuehrungHistorie,
       );
}

extension ClientExtension_Query_AusfuehrungHistorie on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AusfuehrungHistorie>>
  query_AusfuehrungHistorie(Options_Query_AusfuehrungHistorie options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query_AusfuehrungHistorie>
  watchQuery_AusfuehrungHistorie(
    WatchOptions_Query_AusfuehrungHistorie options,
  ) => this.watchQuery(options);

  void writeQuery_AusfuehrungHistorie({
    required Query_AusfuehrungHistorie data,
    required Variables_Query_AusfuehrungHistorie variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAusfuehrungHistorie,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AusfuehrungHistorie? readQuery_AusfuehrungHistorie({
    required Variables_Query_AusfuehrungHistorie variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAusfuehrungHistorie,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_AusfuehrungHistorie.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AusfuehrungHistorie>
useQuery_AusfuehrungHistorie(Options_Query_AusfuehrungHistorie options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AusfuehrungHistorie>
useWatchQuery_AusfuehrungHistorie(
  WatchOptions_Query_AusfuehrungHistorie options,
) => graphql_flutter.useWatchQuery(options);

class Query_AusfuehrungHistorie_Widget
    extends graphql_flutter.Query<Query_AusfuehrungHistorie> {
  Query_AusfuehrungHistorie_Widget({
    widgets.Key? key,
    required Options_Query_AusfuehrungHistorie options,
    required graphql_flutter.QueryBuilder<Query_AusfuehrungHistorie> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AusfuehrungHistorie_ausfuehrung {
  Query_AusfuehrungHistorie_ausfuehrung({
    required this.id,
    this.titel,
    this.beschreibung,
    this.adresse,
    this.kategorie,
    this.bilder,
    required this.slotValues,
    required this.prozessVersion,
    required this.status,
    required this.historie,
    this.$__typename = 'Ausfuehrung',
  });

  factory Query_AusfuehrungHistorie_ausfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$adresse = json['adresse'];
    final l$kategorie = json['kategorie'];
    final l$bilder = json['bilder'];
    final l$slotValues = json['slotValues'];
    final l$prozessVersion = json['prozessVersion'];
    final l$status = json['status'];
    final l$historie = json['historie'];
    final l$$__typename = json['__typename'];
    return Query_AusfuehrungHistorie_ausfuehrung(
      id: (l$id as String),
      titel: l$titel == null
          ? null
          : Fragment_ReportExecutionPlainSlotValue.fromJson(
              (l$titel as Map<String, dynamic>),
            ),
      beschreibung: l$beschreibung == null
          ? null
          : Fragment_ReportExecutionPlainSlotValue.fromJson(
              (l$beschreibung as Map<String, dynamic>),
            ),
      adresse: l$adresse == null
          ? null
          : Fragment_ReportExecutionPlainSlotValue.fromJson(
              (l$adresse as Map<String, dynamic>),
            ),
      kategorie: l$kategorie == null
          ? null
          : Fragment_ReportExecutionPlainSlotValue.fromJson(
              (l$kategorie as Map<String, dynamic>),
            ),
      bilder: l$bilder == null
          ? null
          : Fragment_ReportExecutionPlainSlotValue.fromJson(
              (l$bilder as Map<String, dynamic>),
            ),
      slotValues: (l$slotValues as List<dynamic>)
          .map(
            (e) => Fragment_ReportExecutionSlotValue.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      prozessVersion: Fragment_ProzessVersion.fromJson(
        (l$prozessVersion as Map<String, dynamic>),
      ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
      historie: (l$historie as List<dynamic>)
          .map(
            (e) => Query_AusfuehrungHistorie_ausfuehrung_historie.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Fragment_ReportExecutionPlainSlotValue? titel;

  final Fragment_ReportExecutionPlainSlotValue? beschreibung;

  final Fragment_ReportExecutionPlainSlotValue? adresse;

  final Fragment_ReportExecutionPlainSlotValue? kategorie;

  final Fragment_ReportExecutionPlainSlotValue? bilder;

  final List<Fragment_ReportExecutionSlotValue> slotValues;

  final Fragment_ProzessVersion prozessVersion;

  final Enum_AusfuehrungStatus status;

  final List<Query_AusfuehrungHistorie_ausfuehrung_historie> historie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel?.toJson();
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung?.toJson();
    final l$adresse = adresse;
    _resultData['adresse'] = l$adresse?.toJson();
    final l$kategorie = kategorie;
    _resultData['kategorie'] = l$kategorie?.toJson();
    final l$bilder = bilder;
    _resultData['bilder'] = l$bilder?.toJson();
    final l$slotValues = slotValues;
    _resultData['slotValues'] = l$slotValues.map((e) => e.toJson()).toList();
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    final l$historie = historie;
    _resultData['historie'] = l$historie.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$adresse = adresse;
    final l$kategorie = kategorie;
    final l$bilder = bilder;
    final l$slotValues = slotValues;
    final l$prozessVersion = prozessVersion;
    final l$status = status;
    final l$historie = historie;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$titel,
      l$beschreibung,
      l$adresse,
      l$kategorie,
      l$bilder,
      Object.hashAll(l$slotValues.map((v) => v)),
      l$prozessVersion,
      l$status,
      Object.hashAll(l$historie.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AusfuehrungHistorie_ausfuehrung ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
      return false;
    }
    final l$beschreibung = beschreibung;
    final lOther$beschreibung = other.beschreibung;
    if (l$beschreibung != lOther$beschreibung) {
      return false;
    }
    final l$adresse = adresse;
    final lOther$adresse = other.adresse;
    if (l$adresse != lOther$adresse) {
      return false;
    }
    final l$kategorie = kategorie;
    final lOther$kategorie = other.kategorie;
    if (l$kategorie != lOther$kategorie) {
      return false;
    }
    final l$bilder = bilder;
    final lOther$bilder = other.bilder;
    if (l$bilder != lOther$bilder) {
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

extension UtilityExtension_Query_AusfuehrungHistorie_ausfuehrung
    on Query_AusfuehrungHistorie_ausfuehrung {
  CopyWith_Query_AusfuehrungHistorie_ausfuehrung<
    Query_AusfuehrungHistorie_ausfuehrung
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungHistorie_ausfuehrung(this, (i) => i);
}

abstract class CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> {
  factory CopyWith_Query_AusfuehrungHistorie_ausfuehrung(
    Query_AusfuehrungHistorie_ausfuehrung instance,
    TRes Function(Query_AusfuehrungHistorie_ausfuehrung) then,
  ) = _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung;

  factory CopyWith_Query_AusfuehrungHistorie_ausfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung;

  TRes call({
    String? id,
    Fragment_ReportExecutionPlainSlotValue? titel,
    Fragment_ReportExecutionPlainSlotValue? beschreibung,
    Fragment_ReportExecutionPlainSlotValue? adresse,
    Fragment_ReportExecutionPlainSlotValue? kategorie,
    Fragment_ReportExecutionPlainSlotValue? bilder,
    List<Fragment_ReportExecutionSlotValue>? slotValues,
    Fragment_ProzessVersion? prozessVersion,
    Enum_AusfuehrungStatus? status,
    List<Query_AusfuehrungHistorie_ausfuehrung_historie>? historie,
    String? $__typename,
  });
  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get titel;
  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get beschreibung;
  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get adresse;
  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get kategorie;
  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get bilder;
  TRes slotValues(
    Iterable<Fragment_ReportExecutionSlotValue> Function(
      Iterable<
        CopyWith_Fragment_ReportExecutionSlotValue<
          Fragment_ReportExecutionSlotValue
        >
      >,
    )
    _fn,
  );
  CopyWith_Fragment_ProzessVersion<TRes> get prozessVersion;
  TRes historie(
    Iterable<Query_AusfuehrungHistorie_ausfuehrung_historie> Function(
      Iterable<
        CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<
          Query_AusfuehrungHistorie_ausfuehrung_historie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung<TRes>
    implements CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> {
  _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungHistorie_ausfuehrung _instance;

  final TRes Function(Query_AusfuehrungHistorie_ausfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? adresse = _undefined,
    Object? kategorie = _undefined,
    Object? bilder = _undefined,
    Object? slotValues = _undefined,
    Object? prozessVersion = _undefined,
    Object? status = _undefined,
    Object? historie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AusfuehrungHistorie_ausfuehrung(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      titel: titel == _undefined
          ? _instance.titel
          : (titel as Fragment_ReportExecutionPlainSlotValue?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as Fragment_ReportExecutionPlainSlotValue?),
      adresse: adresse == _undefined
          ? _instance.adresse
          : (adresse as Fragment_ReportExecutionPlainSlotValue?),
      kategorie: kategorie == _undefined
          ? _instance.kategorie
          : (kategorie as Fragment_ReportExecutionPlainSlotValue?),
      bilder: bilder == _undefined
          ? _instance.bilder
          : (bilder as Fragment_ReportExecutionPlainSlotValue?),
      slotValues: slotValues == _undefined || slotValues == null
          ? _instance.slotValues
          : (slotValues as List<Fragment_ReportExecutionSlotValue>),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion as Fragment_ProzessVersion),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
      historie: historie == _undefined || historie == null
          ? _instance.historie
          : (historie as List<Query_AusfuehrungHistorie_ausfuehrung_historie>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get titel {
    final local$titel = _instance.titel;
    return local$titel == null
        ? CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_ReportExecutionPlainSlotValue(
            local$titel,
            (e) => call(titel: e),
          );
  }

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get beschreibung {
    final local$beschreibung = _instance.beschreibung;
    return local$beschreibung == null
        ? CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_ReportExecutionPlainSlotValue(
            local$beschreibung,
            (e) => call(beschreibung: e),
          );
  }

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get adresse {
    final local$adresse = _instance.adresse;
    return local$adresse == null
        ? CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_ReportExecutionPlainSlotValue(
            local$adresse,
            (e) => call(adresse: e),
          );
  }

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get kategorie {
    final local$kategorie = _instance.kategorie;
    return local$kategorie == null
        ? CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_ReportExecutionPlainSlotValue(
            local$kategorie,
            (e) => call(kategorie: e),
          );
  }

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get bilder {
    final local$bilder = _instance.bilder;
    return local$bilder == null
        ? CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_ReportExecutionPlainSlotValue(
            local$bilder,
            (e) => call(bilder: e),
          );
  }

  TRes slotValues(
    Iterable<Fragment_ReportExecutionSlotValue> Function(
      Iterable<
        CopyWith_Fragment_ReportExecutionSlotValue<
          Fragment_ReportExecutionSlotValue
        >
      >,
    )
    _fn,
  ) => call(
    slotValues: _fn(
      _instance.slotValues.map(
        (e) => CopyWith_Fragment_ReportExecutionSlotValue(e, (i) => i),
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

  TRes historie(
    Iterable<Query_AusfuehrungHistorie_ausfuehrung_historie> Function(
      Iterable<
        CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<
          Query_AusfuehrungHistorie_ausfuehrung_historie
        >
      >,
    )
    _fn,
  ) => call(
    historie: _fn(
      _instance.historie.map(
        (e) => CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung<TRes>
    implements CopyWith_Query_AusfuehrungHistorie_ausfuehrung<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung(this._res);

  TRes _res;

  call({
    String? id,
    Fragment_ReportExecutionPlainSlotValue? titel,
    Fragment_ReportExecutionPlainSlotValue? beschreibung,
    Fragment_ReportExecutionPlainSlotValue? adresse,
    Fragment_ReportExecutionPlainSlotValue? kategorie,
    Fragment_ReportExecutionPlainSlotValue? bilder,
    List<Fragment_ReportExecutionSlotValue>? slotValues,
    Fragment_ProzessVersion? prozessVersion,
    Enum_AusfuehrungStatus? status,
    List<Query_AusfuehrungHistorie_ausfuehrung_historie>? historie,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get titel =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_res);

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get beschreibung =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_res);

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get adresse =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_res);

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get kategorie =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_res);

  CopyWith_Fragment_ReportExecutionPlainSlotValue<TRes> get bilder =>
      CopyWith_Fragment_ReportExecutionPlainSlotValue.stub(_res);

  slotValues(_fn) => _res;

  CopyWith_Fragment_ProzessVersion<TRes> get prozessVersion =>
      CopyWith_Fragment_ProzessVersion.stub(_res);

  historie(_fn) => _res;
}

class Query_AusfuehrungHistorie_ausfuehrung_historie
    implements Fragment_HistorieEintrag {
  Query_AusfuehrungHistorie_ausfuehrung_historie({
    required this.id,
    required this.createdAt,
    this.statusAenderung,
    this.statusAenderungBeschreibung,
    this.$__typename = 'Historie',
    this.nachricht,
  });

  factory Query_AusfuehrungHistorie_ausfuehrung_historie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$statusAenderung = json['statusAenderung'];
    final l$statusAenderungBeschreibung = json['statusAenderungBeschreibung'];
    final l$$__typename = json['__typename'];
    final l$nachricht = json['nachricht'];
    return Query_AusfuehrungHistorie_ausfuehrung_historie(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      statusAenderung: (l$statusAenderung as String?),
      statusAenderungBeschreibung: (l$statusAenderungBeschreibung as String?),
      $__typename: (l$$__typename as String),
      nachricht: (l$nachricht as String?),
    );
  }

  final String id;

  final DateTime createdAt;

  final String? statusAenderung;

  final String? statusAenderungBeschreibung;

  final String $__typename;

  final String? nachricht;

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
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$nachricht = nachricht;
    _resultData['nachricht'] = l$nachricht;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$createdAt = createdAt;
    final l$statusAenderung = statusAenderung;
    final l$statusAenderungBeschreibung = statusAenderungBeschreibung;
    final l$$__typename = $__typename;
    final l$nachricht = nachricht;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$statusAenderung,
      l$statusAenderungBeschreibung,
      l$$__typename,
      l$nachricht,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AusfuehrungHistorie_ausfuehrung_historie ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$nachricht = nachricht;
    final lOther$nachricht = other.nachricht;
    if (l$nachricht != lOther$nachricht) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_AusfuehrungHistorie_ausfuehrung_historie
    on Query_AusfuehrungHistorie_ausfuehrung_historie {
  CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<
    Query_AusfuehrungHistorie_ausfuehrung_historie
  >
  get copyWith =>
      CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie(this, (i) => i);
}

abstract class CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<TRes> {
  factory CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie(
    Query_AusfuehrungHistorie_ausfuehrung_historie instance,
    TRes Function(Query_AusfuehrungHistorie_ausfuehrung_historie) then,
  ) = _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung_historie;

  factory CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung_historie;

  TRes call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? $__typename,
    String? nachricht,
  });
}

class _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung_historie<TRes>
    implements CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<TRes> {
  _CopyWithImpl_Query_AusfuehrungHistorie_ausfuehrung_historie(
    this._instance,
    this._then,
  );

  final Query_AusfuehrungHistorie_ausfuehrung_historie _instance;

  final TRes Function(Query_AusfuehrungHistorie_ausfuehrung_historie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? statusAenderung = _undefined,
    Object? statusAenderungBeschreibung = _undefined,
    Object? $__typename = _undefined,
    Object? nachricht = _undefined,
  }) => _then(
    Query_AusfuehrungHistorie_ausfuehrung_historie(
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
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
    ),
  );
}

class _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung_historie<TRes>
    implements CopyWith_Query_AusfuehrungHistorie_ausfuehrung_historie<TRes> {
  _CopyWithStubImpl_Query_AusfuehrungHistorie_ausfuehrung_historie(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? $__typename,
    String? nachricht,
  }) => _res;
}
