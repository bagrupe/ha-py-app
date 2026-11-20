import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'schema.graphql.dart';

class Fragment_EncryptedValue {
  Fragment_EncryptedValue({
    required this.cipher,
    required this.nonce,
    required this.tag,
    this.$__typename = 'EncryptedValue',
  });

  factory Fragment_EncryptedValue.fromJson(Map<String, dynamic> json) {
    final l$cipher = json['cipher'];
    final l$nonce = json['nonce'];
    final l$tag = json['tag'];
    final l$$__typename = json['__typename'];
    return Fragment_EncryptedValue(
      cipher: (l$cipher as String),
      nonce: (l$nonce as String),
      tag: (l$tag as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String cipher;

  final String nonce;

  final String tag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cipher = cipher;
    _resultData['cipher'] = l$cipher;
    final l$nonce = nonce;
    _resultData['nonce'] = l$nonce;
    final l$tag = tag;
    _resultData['tag'] = l$tag;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cipher = cipher;
    final l$nonce = nonce;
    final l$tag = tag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cipher, l$nonce, l$tag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_EncryptedValue || runtimeType != other.runtimeType) {
      return false;
    }
    final l$cipher = cipher;
    final lOther$cipher = other.cipher;
    if (l$cipher != lOther$cipher) {
      return false;
    }
    final l$nonce = nonce;
    final lOther$nonce = other.nonce;
    if (l$nonce != lOther$nonce) {
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

extension UtilityExtension_Fragment_EncryptedValue on Fragment_EncryptedValue {
  CopyWith_Fragment_EncryptedValue<Fragment_EncryptedValue> get copyWith =>
      CopyWith_Fragment_EncryptedValue(this, (i) => i);
}

abstract class CopyWith_Fragment_EncryptedValue<TRes> {
  factory CopyWith_Fragment_EncryptedValue(
    Fragment_EncryptedValue instance,
    TRes Function(Fragment_EncryptedValue) then,
  ) = _CopyWithImpl_Fragment_EncryptedValue;

  factory CopyWith_Fragment_EncryptedValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_EncryptedValue;

  TRes call({String? cipher, String? nonce, String? tag, String? $__typename});
}

class _CopyWithImpl_Fragment_EncryptedValue<TRes>
    implements CopyWith_Fragment_EncryptedValue<TRes> {
  _CopyWithImpl_Fragment_EncryptedValue(this._instance, this._then);

  final Fragment_EncryptedValue _instance;

  final TRes Function(Fragment_EncryptedValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? cipher = _undefined,
    Object? nonce = _undefined,
    Object? tag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_EncryptedValue(
      cipher: cipher == _undefined || cipher == null
          ? _instance.cipher
          : (cipher as String),
      nonce: nonce == _undefined || nonce == null
          ? _instance.nonce
          : (nonce as String),
      tag: tag == _undefined || tag == null ? _instance.tag : (tag as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_EncryptedValue<TRes>
    implements CopyWith_Fragment_EncryptedValue<TRes> {
  _CopyWithStubImpl_Fragment_EncryptedValue(this._res);

  TRes _res;

  call({String? cipher, String? nonce, String? tag, String? $__typename}) =>
      _res;
}

const fragmentDefinitionEncryptedValue = FragmentDefinitionNode(
  name: NameNode(value: 'EncryptedValue'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'EncryptedValue'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'cipher'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'nonce'),
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
);
const documentNodeFragmentEncryptedValue = DocumentNode(
  definitions: [fragmentDefinitionEncryptedValue],
);

extension ClientExtension_Fragment_EncryptedValue on graphql.GraphQLClient {
  void writeFragment_EncryptedValue({
    required Fragment_EncryptedValue data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'EncryptedValue',
        document: documentNodeFragmentEncryptedValue,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_EncryptedValue? readFragment_EncryptedValue({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'EncryptedValue',
          document: documentNodeFragmentEncryptedValue,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_EncryptedValue.fromJson(result);
  }
}

class Fragment_SlotValue {
  Fragment_SlotValue({
    required this.id,
    required this.slotName,
    this.istFreigegeben,
    required this.$__typename,
  });

  factory Fragment_SlotValue.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "PlainSlotValue":
        return Fragment_SlotValue__PlainSlotValue.fromJson(json);

      case "EncryptedSlotValue":
        return Fragment_SlotValue__EncryptedSlotValue.fromJson(json);

      default:
        final l$id = json['id'];
        final l$slotName = json['slotName'];
        final l$istFreigegeben = json['istFreigegeben'];
        final l$$__typename = json['__typename'];
        return Fragment_SlotValue(
          id: (l$id as String),
          slotName: (l$slotName as String),
          istFreigegeben: (l$istFreigegeben as bool?),
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String id;

  final String slotName;

  final bool? istFreigegeben;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$istFreigegeben = istFreigegeben;
    _resultData['istFreigegeben'] = l$istFreigegeben;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$slotName = slotName;
    final l$istFreigegeben = istFreigegeben;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$slotName, l$istFreigegeben, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SlotValue || runtimeType != other.runtimeType) {
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
    final l$istFreigegeben = istFreigegeben;
    final lOther$istFreigegeben = other.istFreigegeben;
    if (l$istFreigegeben != lOther$istFreigegeben) {
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

extension UtilityExtension_Fragment_SlotValue on Fragment_SlotValue {
  CopyWith_Fragment_SlotValue<Fragment_SlotValue> get copyWith =>
      CopyWith_Fragment_SlotValue(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_SlotValue__PlainSlotValue) plainSlotValue,
    required _T Function(Fragment_SlotValue__EncryptedSlotValue)
    encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        return plainSlotValue(this as Fragment_SlotValue__PlainSlotValue);

      case "EncryptedSlotValue":
        return encryptedSlotValue(
          this as Fragment_SlotValue__EncryptedSlotValue,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_SlotValue__PlainSlotValue)? plainSlotValue,
    _T Function(Fragment_SlotValue__EncryptedSlotValue)? encryptedSlotValue,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "PlainSlotValue":
        if (plainSlotValue != null) {
          return plainSlotValue(this as Fragment_SlotValue__PlainSlotValue);
        } else {
          return orElse();
        }

      case "EncryptedSlotValue":
        if (encryptedSlotValue != null) {
          return encryptedSlotValue(
            this as Fragment_SlotValue__EncryptedSlotValue,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_SlotValue<TRes> {
  factory CopyWith_Fragment_SlotValue(
    Fragment_SlotValue instance,
    TRes Function(Fragment_SlotValue) then,
  ) = _CopyWithImpl_Fragment_SlotValue;

  factory CopyWith_Fragment_SlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SlotValue;

  TRes call({
    String? id,
    String? slotName,
    bool? istFreigegeben,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SlotValue<TRes>
    implements CopyWith_Fragment_SlotValue<TRes> {
  _CopyWithImpl_Fragment_SlotValue(this._instance, this._then);

  final Fragment_SlotValue _instance;

  final TRes Function(Fragment_SlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? istFreigegeben = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SlotValue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      istFreigegeben: istFreigegeben == _undefined
          ? _instance.istFreigegeben
          : (istFreigegeben as bool?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SlotValue<TRes>
    implements CopyWith_Fragment_SlotValue<TRes> {
  _CopyWithStubImpl_Fragment_SlotValue(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    bool? istFreigegeben,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionSlotValue = FragmentDefinitionNode(
  name: NameNode(value: 'SlotValue'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SlotValue'), isNonNull: false),
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
        name: NameNode(value: 'istFreigegeben'),
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
              alias: NameNode(value: 'plainValue'),
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
            name: NameNode(value: 'EncryptedSlotValue'),
            isNonNull: false,
          ),
        ),
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'value'),
              alias: NameNode(value: 'encryptedValue'),
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
);
const documentNodeFragmentSlotValue = DocumentNode(
  definitions: [fragmentDefinitionSlotValue, fragmentDefinitionEncryptedValue],
);

extension ClientExtension_Fragment_SlotValue on graphql.GraphQLClient {
  void writeFragment_SlotValue({
    required Fragment_SlotValue data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SlotValue',
        document: documentNodeFragmentSlotValue,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_SlotValue? readFragment_SlotValue({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SlotValue',
          document: documentNodeFragmentSlotValue,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_SlotValue.fromJson(result);
  }
}

class Fragment_SlotValue__PlainSlotValue implements Fragment_SlotValue {
  Fragment_SlotValue__PlainSlotValue({
    required this.plainValue,
    this.$__typename = 'PlainSlotValue',
    required this.id,
    required this.slotName,
    this.istFreigegeben,
  });

  factory Fragment_SlotValue__PlainSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$plainValue = json['plainValue'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$istFreigegeben = json['istFreigegeben'];
    return Fragment_SlotValue__PlainSlotValue(
      plainValue: (l$plainValue as dynamic),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      slotName: (l$slotName as String),
      istFreigegeben: (l$istFreigegeben as bool?),
    );
  }

  final dynamic plainValue;

  final String $__typename;

  final String id;

  final String slotName;

  final bool? istFreigegeben;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$plainValue = plainValue;
    _resultData['plainValue'] = l$plainValue;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$istFreigegeben = istFreigegeben;
    _resultData['istFreigegeben'] = l$istFreigegeben;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$plainValue = plainValue;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$slotName = slotName;
    final l$istFreigegeben = istFreigegeben;
    return Object.hashAll([
      l$plainValue,
      l$$__typename,
      l$id,
      l$slotName,
      l$istFreigegeben,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SlotValue__PlainSlotValue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$plainValue = plainValue;
    final lOther$plainValue = other.plainValue;
    if (l$plainValue != lOther$plainValue) {
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
    final l$istFreigegeben = istFreigegeben;
    final lOther$istFreigegeben = other.istFreigegeben;
    if (l$istFreigegeben != lOther$istFreigegeben) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SlotValue__PlainSlotValue
    on Fragment_SlotValue__PlainSlotValue {
  CopyWith_Fragment_SlotValue__PlainSlotValue<
    Fragment_SlotValue__PlainSlotValue
  >
  get copyWith => CopyWith_Fragment_SlotValue__PlainSlotValue(this, (i) => i);
}

abstract class CopyWith_Fragment_SlotValue__PlainSlotValue<TRes> {
  factory CopyWith_Fragment_SlotValue__PlainSlotValue(
    Fragment_SlotValue__PlainSlotValue instance,
    TRes Function(Fragment_SlotValue__PlainSlotValue) then,
  ) = _CopyWithImpl_Fragment_SlotValue__PlainSlotValue;

  factory CopyWith_Fragment_SlotValue__PlainSlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SlotValue__PlainSlotValue;

  TRes call({
    dynamic? plainValue,
    String? $__typename,
    String? id,
    String? slotName,
    bool? istFreigegeben,
  });
}

class _CopyWithImpl_Fragment_SlotValue__PlainSlotValue<TRes>
    implements CopyWith_Fragment_SlotValue__PlainSlotValue<TRes> {
  _CopyWithImpl_Fragment_SlotValue__PlainSlotValue(this._instance, this._then);

  final Fragment_SlotValue__PlainSlotValue _instance;

  final TRes Function(Fragment_SlotValue__PlainSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? plainValue = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? istFreigegeben = _undefined,
  }) => _then(
    Fragment_SlotValue__PlainSlotValue(
      plainValue: plainValue == _undefined || plainValue == null
          ? _instance.plainValue
          : (plainValue as dynamic),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      istFreigegeben: istFreigegeben == _undefined
          ? _instance.istFreigegeben
          : (istFreigegeben as bool?),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SlotValue__PlainSlotValue<TRes>
    implements CopyWith_Fragment_SlotValue__PlainSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_SlotValue__PlainSlotValue(this._res);

  TRes _res;

  call({
    dynamic? plainValue,
    String? $__typename,
    String? id,
    String? slotName,
    bool? istFreigegeben,
  }) => _res;
}

class Fragment_SlotValue__EncryptedSlotValue implements Fragment_SlotValue {
  Fragment_SlotValue__EncryptedSlotValue({
    required this.encryptedValue,
    this.$__typename = 'EncryptedSlotValue',
    required this.id,
    required this.slotName,
    this.istFreigegeben,
  });

  factory Fragment_SlotValue__EncryptedSlotValue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$encryptedValue = json['encryptedValue'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$istFreigegeben = json['istFreigegeben'];
    return Fragment_SlotValue__EncryptedSlotValue(
      encryptedValue: Fragment_EncryptedValue.fromJson(
        (l$encryptedValue as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      slotName: (l$slotName as String),
      istFreigegeben: (l$istFreigegeben as bool?),
    );
  }

  final Fragment_EncryptedValue encryptedValue;

  final String $__typename;

  final String id;

  final String slotName;

  final bool? istFreigegeben;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$encryptedValue = encryptedValue;
    _resultData['encryptedValue'] = l$encryptedValue.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$istFreigegeben = istFreigegeben;
    _resultData['istFreigegeben'] = l$istFreigegeben;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$encryptedValue = encryptedValue;
    final l$$__typename = $__typename;
    final l$id = id;
    final l$slotName = slotName;
    final l$istFreigegeben = istFreigegeben;
    return Object.hashAll([
      l$encryptedValue,
      l$$__typename,
      l$id,
      l$slotName,
      l$istFreigegeben,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SlotValue__EncryptedSlotValue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$encryptedValue = encryptedValue;
    final lOther$encryptedValue = other.encryptedValue;
    if (l$encryptedValue != lOther$encryptedValue) {
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
    final l$istFreigegeben = istFreigegeben;
    final lOther$istFreigegeben = other.istFreigegeben;
    if (l$istFreigegeben != lOther$istFreigegeben) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SlotValue__EncryptedSlotValue
    on Fragment_SlotValue__EncryptedSlotValue {
  CopyWith_Fragment_SlotValue__EncryptedSlotValue<
    Fragment_SlotValue__EncryptedSlotValue
  >
  get copyWith =>
      CopyWith_Fragment_SlotValue__EncryptedSlotValue(this, (i) => i);
}

abstract class CopyWith_Fragment_SlotValue__EncryptedSlotValue<TRes> {
  factory CopyWith_Fragment_SlotValue__EncryptedSlotValue(
    Fragment_SlotValue__EncryptedSlotValue instance,
    TRes Function(Fragment_SlotValue__EncryptedSlotValue) then,
  ) = _CopyWithImpl_Fragment_SlotValue__EncryptedSlotValue;

  factory CopyWith_Fragment_SlotValue__EncryptedSlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SlotValue__EncryptedSlotValue;

  TRes call({
    Fragment_EncryptedValue? encryptedValue,
    String? $__typename,
    String? id,
    String? slotName,
    bool? istFreigegeben,
  });
  CopyWith_Fragment_EncryptedValue<TRes> get encryptedValue;
}

class _CopyWithImpl_Fragment_SlotValue__EncryptedSlotValue<TRes>
    implements CopyWith_Fragment_SlotValue__EncryptedSlotValue<TRes> {
  _CopyWithImpl_Fragment_SlotValue__EncryptedSlotValue(
    this._instance,
    this._then,
  );

  final Fragment_SlotValue__EncryptedSlotValue _instance;

  final TRes Function(Fragment_SlotValue__EncryptedSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? encryptedValue = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? istFreigegeben = _undefined,
  }) => _then(
    Fragment_SlotValue__EncryptedSlotValue(
      encryptedValue: encryptedValue == _undefined || encryptedValue == null
          ? _instance.encryptedValue
          : (encryptedValue as Fragment_EncryptedValue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      istFreigegeben: istFreigegeben == _undefined
          ? _instance.istFreigegeben
          : (istFreigegeben as bool?),
    ),
  );

  CopyWith_Fragment_EncryptedValue<TRes> get encryptedValue {
    final local$encryptedValue = _instance.encryptedValue;
    return CopyWith_Fragment_EncryptedValue(
      local$encryptedValue,
      (e) => call(encryptedValue: e),
    );
  }
}

class _CopyWithStubImpl_Fragment_SlotValue__EncryptedSlotValue<TRes>
    implements CopyWith_Fragment_SlotValue__EncryptedSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_SlotValue__EncryptedSlotValue(this._res);

  TRes _res;

  call({
    Fragment_EncryptedValue? encryptedValue,
    String? $__typename,
    String? id,
    String? slotName,
    bool? istFreigegeben,
  }) => _res;

  CopyWith_Fragment_EncryptedValue<TRes> get encryptedValue =>
      CopyWith_Fragment_EncryptedValue.stub(_res);
}

class Fragment_AktuelleAusfuehrung {
  Fragment_AktuelleAusfuehrung({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    required this.slotValues,
    required this.status,
  });

  factory Fragment_AktuelleAusfuehrung.fromJson(Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$slotValues = json['slotValues'];
    final l$status = json['status'];
    return Fragment_AktuelleAusfuehrung(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      userId: (l$userId as String),
      slotValues: (l$slotValues as List<dynamic>)
          .map((e) => Fragment_SlotValue.fromJson((e as Map<String, dynamic>)))
          .toList(),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
    );
  }

  final String $__typename;

  final String id;

  final String userId;

  final List<Fragment_SlotValue> slotValues;

  final Enum_AusfuehrungStatus status;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$userId = userId;
    _resultData['userId'] = l$userId;
    final l$slotValues = slotValues;
    _resultData['slotValues'] = l$slotValues.map((e) => e.toJson()).toList();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$userId = userId;
    final l$slotValues = slotValues;
    final l$status = status;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$userId,
      Object.hashAll(l$slotValues.map((v) => v)),
      l$status,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_AktuelleAusfuehrung ||
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
    final l$userId = userId;
    final lOther$userId = other.userId;
    if (l$userId != lOther$userId) {
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
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_AktuelleAusfuehrung
    on Fragment_AktuelleAusfuehrung {
  CopyWith_Fragment_AktuelleAusfuehrung<Fragment_AktuelleAusfuehrung>
  get copyWith => CopyWith_Fragment_AktuelleAusfuehrung(this, (i) => i);
}

abstract class CopyWith_Fragment_AktuelleAusfuehrung<TRes> {
  factory CopyWith_Fragment_AktuelleAusfuehrung(
    Fragment_AktuelleAusfuehrung instance,
    TRes Function(Fragment_AktuelleAusfuehrung) then,
  ) = _CopyWithImpl_Fragment_AktuelleAusfuehrung;

  factory CopyWith_Fragment_AktuelleAusfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Fragment_AktuelleAusfuehrung;

  TRes call({
    String? $__typename,
    String? id,
    String? userId,
    List<Fragment_SlotValue>? slotValues,
    Enum_AusfuehrungStatus? status,
  });
  TRes slotValues(
    Iterable<Fragment_SlotValue> Function(
      Iterable<CopyWith_Fragment_SlotValue<Fragment_SlotValue>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_AktuelleAusfuehrung<TRes>
    implements CopyWith_Fragment_AktuelleAusfuehrung<TRes> {
  _CopyWithImpl_Fragment_AktuelleAusfuehrung(this._instance, this._then);

  final Fragment_AktuelleAusfuehrung _instance;

  final TRes Function(Fragment_AktuelleAusfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? slotValues = _undefined,
    Object? status = _undefined,
  }) => _then(
    Fragment_AktuelleAusfuehrung(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      userId: userId == _undefined || userId == null
          ? _instance.userId
          : (userId as String),
      slotValues: slotValues == _undefined || slotValues == null
          ? _instance.slotValues
          : (slotValues as List<Fragment_SlotValue>),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
    ),
  );

  TRes slotValues(
    Iterable<Fragment_SlotValue> Function(
      Iterable<CopyWith_Fragment_SlotValue<Fragment_SlotValue>>,
    )
    _fn,
  ) => call(
    slotValues: _fn(
      _instance.slotValues.map((e) => CopyWith_Fragment_SlotValue(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_AktuelleAusfuehrung<TRes>
    implements CopyWith_Fragment_AktuelleAusfuehrung<TRes> {
  _CopyWithStubImpl_Fragment_AktuelleAusfuehrung(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? userId,
    List<Fragment_SlotValue>? slotValues,
    Enum_AusfuehrungStatus? status,
  }) => _res;

  slotValues(_fn) => _res;
}

const fragmentDefinitionAktuelleAusfuehrung = FragmentDefinitionNode(
  name: NameNode(value: 'AktuelleAusfuehrung'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Ausfuehrung'), isNonNull: false),
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
        name: NameNode(value: 'userId'),
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
            FragmentSpreadNode(
              name: NameNode(value: 'SlotValue'),
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
    ],
  ),
);
const documentNodeFragmentAktuelleAusfuehrung = DocumentNode(
  definitions: [
    fragmentDefinitionAktuelleAusfuehrung,
    fragmentDefinitionSlotValue,
    fragmentDefinitionEncryptedValue,
  ],
);

extension ClientExtension_Fragment_AktuelleAusfuehrung
    on graphql.GraphQLClient {
  void writeFragment_AktuelleAusfuehrung({
    required Fragment_AktuelleAusfuehrung data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'AktuelleAusfuehrung',
        document: documentNodeFragmentAktuelleAusfuehrung,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_AktuelleAusfuehrung? readFragment_AktuelleAusfuehrung({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'AktuelleAusfuehrung',
          document: documentNodeFragmentAktuelleAusfuehrung,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_AktuelleAusfuehrung.fromJson(result);
  }
}

class Fragment_PoiIcon {
  Fragment_PoiIcon({required this.id, this.url, this.$__typename = 'PoiIcon'});

  factory Fragment_PoiIcon.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_PoiIcon(
      id: (l$id as String),
      url: (l$url as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_PoiIcon || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    return true;
  }
}

extension UtilityExtension_Fragment_PoiIcon on Fragment_PoiIcon {
  CopyWith_Fragment_PoiIcon<Fragment_PoiIcon> get copyWith =>
      CopyWith_Fragment_PoiIcon(this, (i) => i);
}

abstract class CopyWith_Fragment_PoiIcon<TRes> {
  factory CopyWith_Fragment_PoiIcon(
    Fragment_PoiIcon instance,
    TRes Function(Fragment_PoiIcon) then,
  ) = _CopyWithImpl_Fragment_PoiIcon;

  factory CopyWith_Fragment_PoiIcon.stub(TRes res) =
      _CopyWithStubImpl_Fragment_PoiIcon;

  TRes call({String? id, String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_PoiIcon<TRes>
    implements CopyWith_Fragment_PoiIcon<TRes> {
  _CopyWithImpl_Fragment_PoiIcon(this._instance, this._then);

  final Fragment_PoiIcon _instance;

  final TRes Function(Fragment_PoiIcon) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_PoiIcon(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_PoiIcon<TRes>
    implements CopyWith_Fragment_PoiIcon<TRes> {
  _CopyWithStubImpl_Fragment_PoiIcon(this._res);

  TRes _res;

  call({String? id, String? url, String? $__typename}) => _res;
}

const fragmentDefinitionPoiIcon = FragmentDefinitionNode(
  name: NameNode(value: 'PoiIcon'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'PoiIcon'), isNonNull: false),
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
);
const documentNodeFragmentPoiIcon = DocumentNode(
  definitions: [fragmentDefinitionPoiIcon],
);

extension ClientExtension_Fragment_PoiIcon on graphql.GraphQLClient {
  void writeFragment_PoiIcon({
    required Fragment_PoiIcon data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'PoiIcon',
        document: documentNodeFragmentPoiIcon,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_PoiIcon? readFragment_PoiIcon({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'PoiIcon',
          document: documentNodeFragmentPoiIcon,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_PoiIcon.fromJson(result);
  }
}

class Fragment_HistorieEintrag {
  Fragment_HistorieEintrag({
    required this.id,
    required this.createdAt,
    this.statusAenderung,
    this.statusAenderungBeschreibung,
    this.$__typename = 'Historie',
  });

  factory Fragment_HistorieEintrag.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$statusAenderung = json['statusAenderung'];
    final l$statusAenderungBeschreibung = json['statusAenderungBeschreibung'];
    final l$$__typename = json['__typename'];
    return Fragment_HistorieEintrag(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      statusAenderung: (l$statusAenderung as String?),
      statusAenderungBeschreibung: (l$statusAenderungBeschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final String? statusAenderung;

  final String? statusAenderungBeschreibung;

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
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$statusAenderung,
      l$statusAenderungBeschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_HistorieEintrag ||
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
    return true;
  }
}

extension UtilityExtension_Fragment_HistorieEintrag
    on Fragment_HistorieEintrag {
  CopyWith_Fragment_HistorieEintrag<Fragment_HistorieEintrag> get copyWith =>
      CopyWith_Fragment_HistorieEintrag(this, (i) => i);
}

abstract class CopyWith_Fragment_HistorieEintrag<TRes> {
  factory CopyWith_Fragment_HistorieEintrag(
    Fragment_HistorieEintrag instance,
    TRes Function(Fragment_HistorieEintrag) then,
  ) = _CopyWithImpl_Fragment_HistorieEintrag;

  factory CopyWith_Fragment_HistorieEintrag.stub(TRes res) =
      _CopyWithStubImpl_Fragment_HistorieEintrag;

  TRes call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_HistorieEintrag<TRes>
    implements CopyWith_Fragment_HistorieEintrag<TRes> {
  _CopyWithImpl_Fragment_HistorieEintrag(this._instance, this._then);

  final Fragment_HistorieEintrag _instance;

  final TRes Function(Fragment_HistorieEintrag) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? statusAenderung = _undefined,
    Object? statusAenderungBeschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_HistorieEintrag(
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
    ),
  );
}

class _CopyWithStubImpl_Fragment_HistorieEintrag<TRes>
    implements CopyWith_Fragment_HistorieEintrag<TRes> {
  _CopyWithStubImpl_Fragment_HistorieEintrag(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? statusAenderungBeschreibung,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionHistorieEintrag = FragmentDefinitionNode(
  name: NameNode(value: 'HistorieEintrag'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Historie'), isNonNull: false),
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
        name: NameNode(value: 'statusAenderungBeschreibung'),
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
const documentNodeFragmentHistorieEintrag = DocumentNode(
  definitions: [fragmentDefinitionHistorieEintrag],
);

extension ClientExtension_Fragment_HistorieEintrag on graphql.GraphQLClient {
  void writeFragment_HistorieEintrag({
    required Fragment_HistorieEintrag data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'HistorieEintrag',
        document: documentNodeFragmentHistorieEintrag,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_HistorieEintrag? readFragment_HistorieEintrag({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'HistorieEintrag',
          document: documentNodeFragmentHistorieEintrag,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_HistorieEintrag.fromJson(result);
  }
}

class Fragment_Adresse {
  Fragment_Adresse({
    this.name,
    this.plz,
    this.ort,
    this.strasse,
    this.telefon,
    this.email,
    this.url,
    this.$__typename = 'Adresse',
  });

  factory Fragment_Adresse.fromJson(Map<String, dynamic> json) {
    final l$name = json['name'];
    final l$plz = json['plz'];
    final l$ort = json['ort'];
    final l$strasse = json['strasse'];
    final l$telefon = json['telefon'];
    final l$email = json['email'];
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_Adresse(
      name: (l$name as String?),
      plz: (l$plz as String?),
      ort: (l$ort as String?),
      strasse: (l$strasse as String?),
      telefon: (l$telefon as String?),
      email: (l$email as String?),
      url: (l$url as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? name;

  final String? plz;

  final String? ort;

  final String? strasse;

  final String? telefon;

  final String? email;

  final String? url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$plz = plz;
    _resultData['plz'] = l$plz;
    final l$ort = ort;
    _resultData['ort'] = l$ort;
    final l$strasse = strasse;
    _resultData['strasse'] = l$strasse;
    final l$telefon = telefon;
    _resultData['telefon'] = l$telefon;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$plz = plz;
    final l$ort = ort;
    final l$strasse = strasse;
    final l$telefon = telefon;
    final l$email = email;
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$plz,
      l$ort,
      l$strasse,
      l$telefon,
      l$email,
      l$url,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Adresse || runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$plz = plz;
    final lOther$plz = other.plz;
    if (l$plz != lOther$plz) {
      return false;
    }
    final l$ort = ort;
    final lOther$ort = other.ort;
    if (l$ort != lOther$ort) {
      return false;
    }
    final l$strasse = strasse;
    final lOther$strasse = other.strasse;
    if (l$strasse != lOther$strasse) {
      return false;
    }
    final l$telefon = telefon;
    final lOther$telefon = other.telefon;
    if (l$telefon != lOther$telefon) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
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
    return true;
  }
}

extension UtilityExtension_Fragment_Adresse on Fragment_Adresse {
  CopyWith_Fragment_Adresse<Fragment_Adresse> get copyWith =>
      CopyWith_Fragment_Adresse(this, (i) => i);
}

abstract class CopyWith_Fragment_Adresse<TRes> {
  factory CopyWith_Fragment_Adresse(
    Fragment_Adresse instance,
    TRes Function(Fragment_Adresse) then,
  ) = _CopyWithImpl_Fragment_Adresse;

  factory CopyWith_Fragment_Adresse.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Adresse;

  TRes call({
    String? name,
    String? plz,
    String? ort,
    String? strasse,
    String? telefon,
    String? email,
    String? url,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_Adresse<TRes>
    implements CopyWith_Fragment_Adresse<TRes> {
  _CopyWithImpl_Fragment_Adresse(this._instance, this._then);

  final Fragment_Adresse _instance;

  final TRes Function(Fragment_Adresse) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? plz = _undefined,
    Object? ort = _undefined,
    Object? strasse = _undefined,
    Object? telefon = _undefined,
    Object? email = _undefined,
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Adresse(
      name: name == _undefined ? _instance.name : (name as String?),
      plz: plz == _undefined ? _instance.plz : (plz as String?),
      ort: ort == _undefined ? _instance.ort : (ort as String?),
      strasse: strasse == _undefined ? _instance.strasse : (strasse as String?),
      telefon: telefon == _undefined ? _instance.telefon : (telefon as String?),
      email: email == _undefined ? _instance.email : (email as String?),
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Adresse<TRes>
    implements CopyWith_Fragment_Adresse<TRes> {
  _CopyWithStubImpl_Fragment_Adresse(this._res);

  TRes _res;

  call({
    String? name,
    String? plz,
    String? ort,
    String? strasse,
    String? telefon,
    String? email,
    String? url,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionAdresse = FragmentDefinitionNode(
  name: NameNode(value: 'Adresse'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Adresse'), isNonNull: false),
  ),
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
        name: NameNode(value: 'plz'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'ort'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'strasse'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'telefon'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'email'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentAdresse = DocumentNode(
  definitions: [fragmentDefinitionAdresse],
);

extension ClientExtension_Fragment_Adresse on graphql.GraphQLClient {
  void writeFragment_Adresse({
    required Fragment_Adresse data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'Adresse',
        document: documentNodeFragmentAdresse,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_Adresse? readFragment_Adresse({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Adresse',
          document: documentNodeFragmentAdresse,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_Adresse.fromJson(result);
  }
}
