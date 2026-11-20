import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_MangelAusfuehrung {
  Fragment_MangelAusfuehrung({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    this.adresse,
    this.beschreibung,
    this.kategorie,
    this.title,
    this.bilder,
    required this.status,
  });

  factory Fragment_MangelAusfuehrung.fromJson(Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$adresse = json['adresse'];
    final l$beschreibung = json['beschreibung'];
    final l$kategorie = json['kategorie'];
    final l$title = json['title'];
    final l$bilder = json['bilder'];
    final l$status = json['status'];
    return Fragment_MangelAusfuehrung(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      userId: (l$userId as String),
      adresse: l$adresse == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$adresse as Map<String, dynamic>),
            ),
      beschreibung: l$beschreibung == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$beschreibung as Map<String, dynamic>),
            ),
      kategorie: l$kategorie == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$kategorie as Map<String, dynamic>),
            ),
      title: l$title == null
          ? null
          : Fragment_PlainSlotValue.fromJson((l$title as Map<String, dynamic>)),
      bilder: l$bilder == null
          ? null
          : Fragment_MangelAusfuehrung_bilder.fromJson(
              (l$bilder as Map<String, dynamic>),
            ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
    );
  }

  final String $__typename;

  final String id;

  final String userId;

  final Fragment_PlainSlotValue? adresse;

  final Fragment_PlainSlotValue? beschreibung;

  final Fragment_PlainSlotValue? kategorie;

  final Fragment_PlainSlotValue? title;

  final Fragment_MangelAusfuehrung_bilder? bilder;

  final Enum_AusfuehrungStatus status;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$userId = userId;
    _resultData['userId'] = l$userId;
    final l$adresse = adresse;
    _resultData['adresse'] = l$adresse?.toJson();
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung?.toJson();
    final l$kategorie = kategorie;
    _resultData['kategorie'] = l$kategorie?.toJson();
    final l$title = title;
    _resultData['title'] = l$title?.toJson();
    final l$bilder = bilder;
    _resultData['bilder'] = l$bilder?.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$userId = userId;
    final l$adresse = adresse;
    final l$beschreibung = beschreibung;
    final l$kategorie = kategorie;
    final l$title = title;
    final l$bilder = bilder;
    final l$status = status;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$userId,
      l$adresse,
      l$beschreibung,
      l$kategorie,
      l$title,
      l$bilder,
      l$status,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_MangelAusfuehrung ||
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
    final l$adresse = adresse;
    final lOther$adresse = other.adresse;
    if (l$adresse != lOther$adresse) {
      return false;
    }
    final l$beschreibung = beschreibung;
    final lOther$beschreibung = other.beschreibung;
    if (l$beschreibung != lOther$beschreibung) {
      return false;
    }
    final l$kategorie = kategorie;
    final lOther$kategorie = other.kategorie;
    if (l$kategorie != lOther$kategorie) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$bilder = bilder;
    final lOther$bilder = other.bilder;
    if (l$bilder != lOther$bilder) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_MangelAusfuehrung
    on Fragment_MangelAusfuehrung {
  CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>
  get copyWith => CopyWith_Fragment_MangelAusfuehrung(this, (i) => i);
}

abstract class CopyWith_Fragment_MangelAusfuehrung<TRes> {
  factory CopyWith_Fragment_MangelAusfuehrung(
    Fragment_MangelAusfuehrung instance,
    TRes Function(Fragment_MangelAusfuehrung) then,
  ) = _CopyWithImpl_Fragment_MangelAusfuehrung;

  factory CopyWith_Fragment_MangelAusfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Fragment_MangelAusfuehrung;

  TRes call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? kategorie,
    Fragment_PlainSlotValue? title,
    Fragment_MangelAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
  });
  CopyWith_Fragment_PlainSlotValue<TRes> get adresse;
  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung;
  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie;
  CopyWith_Fragment_PlainSlotValue<TRes> get title;
  CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> get bilder;
}

class _CopyWithImpl_Fragment_MangelAusfuehrung<TRes>
    implements CopyWith_Fragment_MangelAusfuehrung<TRes> {
  _CopyWithImpl_Fragment_MangelAusfuehrung(this._instance, this._then);

  final Fragment_MangelAusfuehrung _instance;

  final TRes Function(Fragment_MangelAusfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? adresse = _undefined,
    Object? beschreibung = _undefined,
    Object? kategorie = _undefined,
    Object? title = _undefined,
    Object? bilder = _undefined,
    Object? status = _undefined,
  }) => _then(
    Fragment_MangelAusfuehrung(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      userId: userId == _undefined || userId == null
          ? _instance.userId
          : (userId as String),
      adresse: adresse == _undefined
          ? _instance.adresse
          : (adresse as Fragment_PlainSlotValue?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as Fragment_PlainSlotValue?),
      kategorie: kategorie == _undefined
          ? _instance.kategorie
          : (kategorie as Fragment_PlainSlotValue?),
      title: title == _undefined
          ? _instance.title
          : (title as Fragment_PlainSlotValue?),
      bilder: bilder == _undefined
          ? _instance.bilder
          : (bilder as Fragment_MangelAusfuehrung_bilder?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
    ),
  );

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse {
    final local$adresse = _instance.adresse;
    return local$adresse == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$adresse,
            (e) => call(adresse: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung {
    final local$beschreibung = _instance.beschreibung;
    return local$beschreibung == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$beschreibung,
            (e) => call(beschreibung: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie {
    final local$kategorie = _instance.kategorie;
    return local$kategorie == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$kategorie,
            (e) => call(kategorie: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get title {
    final local$title = _instance.title;
    return local$title == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(local$title, (e) => call(title: e));
  }

  CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> get bilder {
    final local$bilder = _instance.bilder;
    return local$bilder == null
        ? CopyWith_Fragment_MangelAusfuehrung_bilder.stub(_then(_instance))
        : CopyWith_Fragment_MangelAusfuehrung_bilder(
            local$bilder,
            (e) => call(bilder: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_MangelAusfuehrung<TRes>
    implements CopyWith_Fragment_MangelAusfuehrung<TRes> {
  _CopyWithStubImpl_Fragment_MangelAusfuehrung(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? kategorie,
    Fragment_PlainSlotValue? title,
    Fragment_MangelAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
  }) => _res;

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get title =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> get bilder =>
      CopyWith_Fragment_MangelAusfuehrung_bilder.stub(_res);
}

const fragmentDefinitionMangelAusfuehrung = FragmentDefinitionNode(
  name: NameNode(value: 'MangelAusfuehrung'),
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
        name: NameNode(value: 'slotValue'),
        alias: NameNode(value: 'adresse'),
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'names'),
            value: StringValueNode(value: 'adresse', isBlock: false),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'PlainSlotValue'),
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
            value: StringValueNode(value: 'beschreibung', isBlock: false),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'PlainSlotValue'),
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
                StringValueNode(value: '_wurzel', isBlock: false),
                StringValueNode(value: 'kategorie', isBlock: false),
              ],
            ),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'PlainSlotValue'),
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
        alias: NameNode(value: 'title'),
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'names'),
            value: StringValueNode(value: 'titel', isBlock: false),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'PlainSlotValue'),
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
            value: StringValueNode(value: 'bilder', isBlock: false),
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
              name: NameNode(value: 'slotName'),
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
const documentNodeFragmentMangelAusfuehrung = DocumentNode(
  definitions: [
    fragmentDefinitionMangelAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);

extension ClientExtension_Fragment_MangelAusfuehrung on graphql.GraphQLClient {
  void writeFragment_MangelAusfuehrung({
    required Fragment_MangelAusfuehrung data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'MangelAusfuehrung',
        document: documentNodeFragmentMangelAusfuehrung,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_MangelAusfuehrung? readFragment_MangelAusfuehrung({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'MangelAusfuehrung',
          document: documentNodeFragmentMangelAusfuehrung,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_MangelAusfuehrung.fromJson(result);
  }
}

class Fragment_MangelAusfuehrung_bilder {
  Fragment_MangelAusfuehrung_bilder({
    required this.id,
    required this.slotName,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
  });

  factory Fragment_MangelAusfuehrung_bilder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    return Fragment_MangelAusfuehrung_bilder(
      id: (l$id as String),
      slotName: (l$slotName as String),
      slotValueCount: (l$slotValueCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slotName;

  final int slotValueCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
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
    final l$slotValueCount = slotValueCount;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$slotName, l$slotValueCount, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_MangelAusfuehrung_bilder ||
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

extension UtilityExtension_Fragment_MangelAusfuehrung_bilder
    on Fragment_MangelAusfuehrung_bilder {
  CopyWith_Fragment_MangelAusfuehrung_bilder<Fragment_MangelAusfuehrung_bilder>
  get copyWith => CopyWith_Fragment_MangelAusfuehrung_bilder(this, (i) => i);
}

abstract class CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> {
  factory CopyWith_Fragment_MangelAusfuehrung_bilder(
    Fragment_MangelAusfuehrung_bilder instance,
    TRes Function(Fragment_MangelAusfuehrung_bilder) then,
  ) = _CopyWithImpl_Fragment_MangelAusfuehrung_bilder;

  factory CopyWith_Fragment_MangelAusfuehrung_bilder.stub(TRes res) =
      _CopyWithStubImpl_Fragment_MangelAusfuehrung_bilder;

  TRes call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_MangelAusfuehrung_bilder<TRes>
    implements CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> {
  _CopyWithImpl_Fragment_MangelAusfuehrung_bilder(this._instance, this._then);

  final Fragment_MangelAusfuehrung_bilder _instance;

  final TRes Function(Fragment_MangelAusfuehrung_bilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_MangelAusfuehrung_bilder(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      slotValueCount: slotValueCount == _undefined || slotValueCount == null
          ? _instance.slotValueCount
          : (slotValueCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_MangelAusfuehrung_bilder<TRes>
    implements CopyWith_Fragment_MangelAusfuehrung_bilder<TRes> {
  _CopyWithStubImpl_Fragment_MangelAusfuehrung_bilder(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  }) => _res;
}

class Fragment_PlainSlotValue {
  Fragment_PlainSlotValue({
    required this.id,
    required this.slotName,
    required this.value,
    this.$__typename = 'PlainSlotValue',
  });

  factory Fragment_PlainSlotValue.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment_PlainSlotValue(
      id: (l$id as String),
      slotName: (l$slotName as String),
      value: (l$value as dynamic),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slotName;

  final dynamic value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$slotName = slotName;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$slotName, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_PlainSlotValue || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_PlainSlotValue on Fragment_PlainSlotValue {
  CopyWith_Fragment_PlainSlotValue<Fragment_PlainSlotValue> get copyWith =>
      CopyWith_Fragment_PlainSlotValue(this, (i) => i);
}

abstract class CopyWith_Fragment_PlainSlotValue<TRes> {
  factory CopyWith_Fragment_PlainSlotValue(
    Fragment_PlainSlotValue instance,
    TRes Function(Fragment_PlainSlotValue) then,
  ) = _CopyWithImpl_Fragment_PlainSlotValue;

  factory CopyWith_Fragment_PlainSlotValue.stub(TRes res) =
      _CopyWithStubImpl_Fragment_PlainSlotValue;

  TRes call({
    String? id,
    String? slotName,
    dynamic? value,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_PlainSlotValue<TRes>
    implements CopyWith_Fragment_PlainSlotValue<TRes> {
  _CopyWithImpl_Fragment_PlainSlotValue(this._instance, this._then);

  final Fragment_PlainSlotValue _instance;

  final TRes Function(Fragment_PlainSlotValue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_PlainSlotValue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as dynamic),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_PlainSlotValue<TRes>
    implements CopyWith_Fragment_PlainSlotValue<TRes> {
  _CopyWithStubImpl_Fragment_PlainSlotValue(this._res);

  TRes _res;

  call({String? id, String? slotName, dynamic? value, String? $__typename}) =>
      _res;
}

const fragmentDefinitionPlainSlotValue = FragmentDefinitionNode(
  name: NameNode(value: 'PlainSlotValue'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'PlainSlotValue'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
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
const documentNodeFragmentPlainSlotValue = DocumentNode(
  definitions: [fragmentDefinitionPlainSlotValue],
);

extension ClientExtension_Fragment_PlainSlotValue on graphql.GraphQLClient {
  void writeFragment_PlainSlotValue({
    required Fragment_PlainSlotValue data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'PlainSlotValue',
        document: documentNodeFragmentPlainSlotValue,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_PlainSlotValue? readFragment_PlainSlotValue({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'PlainSlotValue',
          document: documentNodeFragmentPlainSlotValue,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_PlainSlotValue.fromJson(result);
  }
}

class Variables_Query_Maengel {
  factory Variables_Query_Maengel({required String kommuneId}) =>
      Variables_Query_Maengel._({r'kommuneId': kommuneId});

  Variables_Query_Maengel._(this._$data);

  factory Variables_Query_Maengel.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_Maengel._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Maengel<Variables_Query_Maengel> get copyWith =>
      CopyWith_Variables_Query_Maengel(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Maengel || runtimeType != other.runtimeType) {
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

abstract class CopyWith_Variables_Query_Maengel<TRes> {
  factory CopyWith_Variables_Query_Maengel(
    Variables_Query_Maengel instance,
    TRes Function(Variables_Query_Maengel) then,
  ) = _CopyWithImpl_Variables_Query_Maengel;

  factory CopyWith_Variables_Query_Maengel.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Maengel;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_Maengel<TRes>
    implements CopyWith_Variables_Query_Maengel<TRes> {
  _CopyWithImpl_Variables_Query_Maengel(this._instance, this._then);

  final Variables_Query_Maengel _instance;

  final TRes Function(Variables_Query_Maengel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Maengel._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Maengel<TRes>
    implements CopyWith_Variables_Query_Maengel<TRes> {
  _CopyWithStubImpl_Variables_Query_Maengel(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_Maengel {
  Query_Maengel({required this.kommune, this.$__typename = 'Query'});

  factory Query_Maengel.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Maengel(
      kommune: Query_Maengel_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Maengel_kommune kommune;

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
    if (other is! Query_Maengel || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Maengel on Query_Maengel {
  CopyWith_Query_Maengel<Query_Maengel> get copyWith =>
      CopyWith_Query_Maengel(this, (i) => i);
}

abstract class CopyWith_Query_Maengel<TRes> {
  factory CopyWith_Query_Maengel(
    Query_Maengel instance,
    TRes Function(Query_Maengel) then,
  ) = _CopyWithImpl_Query_Maengel;

  factory CopyWith_Query_Maengel.stub(TRes res) =
      _CopyWithStubImpl_Query_Maengel;

  TRes call({Query_Maengel_kommune? kommune, String? $__typename});
  CopyWith_Query_Maengel_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Maengel<TRes>
    implements CopyWith_Query_Maengel<TRes> {
  _CopyWithImpl_Query_Maengel(this._instance, this._then);

  final Query_Maengel _instance;

  final TRes Function(Query_Maengel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Maengel(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Maengel_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Maengel_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Maengel_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_Maengel<TRes>
    implements CopyWith_Query_Maengel<TRes> {
  _CopyWithStubImpl_Query_Maengel(this._res);

  TRes _res;

  call({Query_Maengel_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_Maengel_kommune<TRes> get kommune =>
      CopyWith_Query_Maengel_kommune.stub(_res);
}

const documentNodeQueryMaengel = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Maengel'),
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
                  name: NameNode(value: 'maengelAusfuehrungen'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MangelAusfuehrung'),
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
    fragmentDefinitionMangelAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Query_Maengel _parserFn_Query_Maengel(Map<String, dynamic> data) =>
    Query_Maengel.fromJson(data);
typedef OnQueryComplete_Query_Maengel =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Maengel?);

class Options_Query_Maengel extends graphql.QueryOptions<Query_Maengel> {
  Options_Query_Maengel({
    String? operationName,
    required Variables_Query_Maengel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Maengel? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Maengel? onComplete,
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
                 data == null ? null : _parserFn_Query_Maengel(data),
               ),
         onError: onError,
         document: documentNodeQueryMaengel,
         parserFn: _parserFn_Query_Maengel,
       );

  final OnQueryComplete_Query_Maengel? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Maengel
    extends graphql.WatchQueryOptions<Query_Maengel> {
  WatchOptions_Query_Maengel({
    String? operationName,
    required Variables_Query_Maengel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Maengel? typedOptimisticResult,
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
         document: documentNodeQueryMaengel,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Maengel,
       );
}

class FetchMoreOptions_Query_Maengel extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Maengel({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Maengel variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMaengel,
       );
}

extension ClientExtension_Query_Maengel on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Maengel>> query_Maengel(
    Options_Query_Maengel options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Maengel> watchQuery_Maengel(
    WatchOptions_Query_Maengel options,
  ) => this.watchQuery(options);

  void writeQuery_Maengel({
    required Query_Maengel data,
    required Variables_Query_Maengel variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMaengel),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Maengel? readQuery_Maengel({
    required Variables_Query_Maengel variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMaengel),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Maengel.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Maengel> useQuery_Maengel(
  Options_Query_Maengel options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Maengel> useWatchQuery_Maengel(
  WatchOptions_Query_Maengel options,
) => graphql_flutter.useWatchQuery(options);

class Query_Maengel_Widget extends graphql_flutter.Query<Query_Maengel> {
  Query_Maengel_Widget({
    widgets.Key? key,
    required Options_Query_Maengel options,
    required graphql_flutter.QueryBuilder<Query_Maengel> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Maengel_kommune {
  Query_Maengel_kommune({
    required this.maengelAusfuehrungen,
    this.$__typename = 'Kommune',
  });

  factory Query_Maengel_kommune.fromJson(Map<String, dynamic> json) {
    final l$maengelAusfuehrungen = json['maengelAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Query_Maengel_kommune(
      maengelAusfuehrungen: (l$maengelAusfuehrungen as List<dynamic>)
          .map(
            (e) => Fragment_MangelAusfuehrung.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_MangelAusfuehrung> maengelAusfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    _resultData['maengelAusfuehrungen'] = l$maengelAusfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$maengelAusfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Maengel_kommune || runtimeType != other.runtimeType) {
      return false;
    }
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final lOther$maengelAusfuehrungen = other.maengelAusfuehrungen;
    if (l$maengelAusfuehrungen.length != lOther$maengelAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$maengelAusfuehrungen.length; i++) {
      final l$maengelAusfuehrungen$entry = l$maengelAusfuehrungen[i];
      final lOther$maengelAusfuehrungen$entry = lOther$maengelAusfuehrungen[i];
      if (l$maengelAusfuehrungen$entry != lOther$maengelAusfuehrungen$entry) {
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

extension UtilityExtension_Query_Maengel_kommune on Query_Maengel_kommune {
  CopyWith_Query_Maengel_kommune<Query_Maengel_kommune> get copyWith =>
      CopyWith_Query_Maengel_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Maengel_kommune<TRes> {
  factory CopyWith_Query_Maengel_kommune(
    Query_Maengel_kommune instance,
    TRes Function(Query_Maengel_kommune) then,
  ) = _CopyWithImpl_Query_Maengel_kommune;

  factory CopyWith_Query_Maengel_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Maengel_kommune;

  TRes call({
    List<Fragment_MangelAusfuehrung>? maengelAusfuehrungen,
    String? $__typename,
  });
  TRes maengelAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Maengel_kommune<TRes>
    implements CopyWith_Query_Maengel_kommune<TRes> {
  _CopyWithImpl_Query_Maengel_kommune(this._instance, this._then);

  final Query_Maengel_kommune _instance;

  final TRes Function(Query_Maengel_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? maengelAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Maengel_kommune(
      maengelAusfuehrungen:
          maengelAusfuehrungen == _undefined || maengelAusfuehrungen == null
          ? _instance.maengelAusfuehrungen
          : (maengelAusfuehrungen as List<Fragment_MangelAusfuehrung>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes maengelAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  ) => call(
    maengelAusfuehrungen: _fn(
      _instance.maengelAusfuehrungen.map(
        (e) => CopyWith_Fragment_MangelAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Maengel_kommune<TRes>
    implements CopyWith_Query_Maengel_kommune<TRes> {
  _CopyWithStubImpl_Query_Maengel_kommune(this._res);

  TRes _res;

  call({
    List<Fragment_MangelAusfuehrung>? maengelAusfuehrungen,
    String? $__typename,
  }) => _res;

  maengelAusfuehrungen(_fn) => _res;
}

class Variables_Query_MaengelKarte {
  factory Variables_Query_MaengelKarte({
    required String kommuneId,
    Input_SlotValueFilterInput? filter,
  }) => Variables_Query_MaengelKarte._({
    r'kommuneId': kommuneId,
    if (filter != null) r'filter': filter,
  });

  Variables_Query_MaengelKarte._(this._$data);

  factory Variables_Query_MaengelKarte.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input_SlotValueFilterInput.fromJson(
              (l$filter as Map<String, dynamic>),
            );
    }
    return Variables_Query_MaengelKarte._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Input_SlotValueFilterInput? get filter =>
      (_$data['filter'] as Input_SlotValueFilterInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    return result$data;
  }

  CopyWith_Variables_Query_MaengelKarte<Variables_Query_MaengelKarte>
  get copyWith => CopyWith_Variables_Query_MaengelKarte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_MaengelKarte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (_$data.containsKey('filter') != other._$data.containsKey('filter')) {
      return false;
    }
    if (l$filter != lOther$filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$filter = filter;
    return Object.hashAll([
      l$kommuneId,
      _$data.containsKey('filter') ? l$filter : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_MaengelKarte<TRes> {
  factory CopyWith_Variables_Query_MaengelKarte(
    Variables_Query_MaengelKarte instance,
    TRes Function(Variables_Query_MaengelKarte) then,
  ) = _CopyWithImpl_Variables_Query_MaengelKarte;

  factory CopyWith_Variables_Query_MaengelKarte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_MaengelKarte;

  TRes call({String? kommuneId, Input_SlotValueFilterInput? filter});
}

class _CopyWithImpl_Variables_Query_MaengelKarte<TRes>
    implements CopyWith_Variables_Query_MaengelKarte<TRes> {
  _CopyWithImpl_Variables_Query_MaengelKarte(this._instance, this._then);

  final Variables_Query_MaengelKarte _instance;

  final TRes Function(Variables_Query_MaengelKarte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? filter = _undefined}) =>
      _then(
        Variables_Query_MaengelKarte._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (filter != _undefined)
            'filter': (filter as Input_SlotValueFilterInput?),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_MaengelKarte<TRes>
    implements CopyWith_Variables_Query_MaengelKarte<TRes> {
  _CopyWithStubImpl_Variables_Query_MaengelKarte(this._res);

  TRes _res;

  call({String? kommuneId, Input_SlotValueFilterInput? filter}) => _res;
}

class Query_MaengelKarte {
  Query_MaengelKarte({required this.kommune, this.$__typename = 'Query'});

  factory Query_MaengelKarte.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_MaengelKarte(
      kommune: Query_MaengelKarte_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MaengelKarte_kommune kommune;

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
    if (other is! Query_MaengelKarte || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MaengelKarte on Query_MaengelKarte {
  CopyWith_Query_MaengelKarte<Query_MaengelKarte> get copyWith =>
      CopyWith_Query_MaengelKarte(this, (i) => i);
}

abstract class CopyWith_Query_MaengelKarte<TRes> {
  factory CopyWith_Query_MaengelKarte(
    Query_MaengelKarte instance,
    TRes Function(Query_MaengelKarte) then,
  ) = _CopyWithImpl_Query_MaengelKarte;

  factory CopyWith_Query_MaengelKarte.stub(TRes res) =
      _CopyWithStubImpl_Query_MaengelKarte;

  TRes call({Query_MaengelKarte_kommune? kommune, String? $__typename});
  CopyWith_Query_MaengelKarte_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_MaengelKarte<TRes>
    implements CopyWith_Query_MaengelKarte<TRes> {
  _CopyWithImpl_Query_MaengelKarte(this._instance, this._then);

  final Query_MaengelKarte _instance;

  final TRes Function(Query_MaengelKarte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MaengelKarte(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_MaengelKarte_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MaengelKarte_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_MaengelKarte_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_MaengelKarte<TRes>
    implements CopyWith_Query_MaengelKarte<TRes> {
  _CopyWithStubImpl_Query_MaengelKarte(this._res);

  TRes _res;

  call({Query_MaengelKarte_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_MaengelKarte_kommune<TRes> get kommune =>
      CopyWith_Query_MaengelKarte_kommune.stub(_res);
}

const documentNodeQueryMaengelKarte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MaengelKarte'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'SlotValueFilterInput'),
            isNonNull: false,
          ),
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
                  name: NameNode(value: 'maengelAusfuehrungen'),
                  alias: null,
                  arguments: [],
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
                        arguments: [
                          ArgumentNode(
                            name: NameNode(value: 'where'),
                            value: VariableNode(
                              name: NameNode(value: 'filter'),
                            ),
                          ),
                        ],
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
    fragmentDefinitionSlotValue,
    fragmentDefinitionEncryptedValue,
  ],
);
Query_MaengelKarte _parserFn_Query_MaengelKarte(Map<String, dynamic> data) =>
    Query_MaengelKarte.fromJson(data);
typedef OnQueryComplete_Query_MaengelKarte =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MaengelKarte?);

class Options_Query_MaengelKarte
    extends graphql.QueryOptions<Query_MaengelKarte> {
  Options_Query_MaengelKarte({
    String? operationName,
    required Variables_Query_MaengelKarte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MaengelKarte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MaengelKarte? onComplete,
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
                 data == null ? null : _parserFn_Query_MaengelKarte(data),
               ),
         onError: onError,
         document: documentNodeQueryMaengelKarte,
         parserFn: _parserFn_Query_MaengelKarte,
       );

  final OnQueryComplete_Query_MaengelKarte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MaengelKarte
    extends graphql.WatchQueryOptions<Query_MaengelKarte> {
  WatchOptions_Query_MaengelKarte({
    String? operationName,
    required Variables_Query_MaengelKarte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MaengelKarte? typedOptimisticResult,
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
         document: documentNodeQueryMaengelKarte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MaengelKarte,
       );
}

class FetchMoreOptions_Query_MaengelKarte extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MaengelKarte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_MaengelKarte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMaengelKarte,
       );
}

extension ClientExtension_Query_MaengelKarte on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MaengelKarte>> query_MaengelKarte(
    Options_Query_MaengelKarte options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_MaengelKarte> watchQuery_MaengelKarte(
    WatchOptions_Query_MaengelKarte options,
  ) => this.watchQuery(options);

  void writeQuery_MaengelKarte({
    required Query_MaengelKarte data,
    required Variables_Query_MaengelKarte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMaengelKarte),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MaengelKarte? readQuery_MaengelKarte({
    required Variables_Query_MaengelKarte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMaengelKarte),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MaengelKarte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MaengelKarte> useQuery_MaengelKarte(
  Options_Query_MaengelKarte options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_MaengelKarte> useWatchQuery_MaengelKarte(
  WatchOptions_Query_MaengelKarte options,
) => graphql_flutter.useWatchQuery(options);

class Query_MaengelKarte_Widget
    extends graphql_flutter.Query<Query_MaengelKarte> {
  Query_MaengelKarte_Widget({
    widgets.Key? key,
    required Options_Query_MaengelKarte options,
    required graphql_flutter.QueryBuilder<Query_MaengelKarte> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_MaengelKarte_kommune {
  Query_MaengelKarte_kommune({
    required this.maengelAusfuehrungen,
    this.$__typename = 'Kommune',
  });

  factory Query_MaengelKarte_kommune.fromJson(Map<String, dynamic> json) {
    final l$maengelAusfuehrungen = json['maengelAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Query_MaengelKarte_kommune(
      maengelAusfuehrungen: (l$maengelAusfuehrungen as List<dynamic>)
          .map(
            (e) => Query_MaengelKarte_kommune_maengelAusfuehrungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_MaengelKarte_kommune_maengelAusfuehrungen>
  maengelAusfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    _resultData['maengelAusfuehrungen'] = l$maengelAusfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$maengelAusfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MaengelKarte_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$maengelAusfuehrungen = maengelAusfuehrungen;
    final lOther$maengelAusfuehrungen = other.maengelAusfuehrungen;
    if (l$maengelAusfuehrungen.length != lOther$maengelAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$maengelAusfuehrungen.length; i++) {
      final l$maengelAusfuehrungen$entry = l$maengelAusfuehrungen[i];
      final lOther$maengelAusfuehrungen$entry = lOther$maengelAusfuehrungen[i];
      if (l$maengelAusfuehrungen$entry != lOther$maengelAusfuehrungen$entry) {
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

extension UtilityExtension_Query_MaengelKarte_kommune
    on Query_MaengelKarte_kommune {
  CopyWith_Query_MaengelKarte_kommune<Query_MaengelKarte_kommune>
  get copyWith => CopyWith_Query_MaengelKarte_kommune(this, (i) => i);
}

abstract class CopyWith_Query_MaengelKarte_kommune<TRes> {
  factory CopyWith_Query_MaengelKarte_kommune(
    Query_MaengelKarte_kommune instance,
    TRes Function(Query_MaengelKarte_kommune) then,
  ) = _CopyWithImpl_Query_MaengelKarte_kommune;

  factory CopyWith_Query_MaengelKarte_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_MaengelKarte_kommune;

  TRes call({
    List<Query_MaengelKarte_kommune_maengelAusfuehrungen>? maengelAusfuehrungen,
    String? $__typename,
  });
  TRes maengelAusfuehrungen(
    Iterable<Query_MaengelKarte_kommune_maengelAusfuehrungen> Function(
      Iterable<
        CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<
          Query_MaengelKarte_kommune_maengelAusfuehrungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MaengelKarte_kommune<TRes>
    implements CopyWith_Query_MaengelKarte_kommune<TRes> {
  _CopyWithImpl_Query_MaengelKarte_kommune(this._instance, this._then);

  final Query_MaengelKarte_kommune _instance;

  final TRes Function(Query_MaengelKarte_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? maengelAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MaengelKarte_kommune(
      maengelAusfuehrungen:
          maengelAusfuehrungen == _undefined || maengelAusfuehrungen == null
          ? _instance.maengelAusfuehrungen
          : (maengelAusfuehrungen
                as List<Query_MaengelKarte_kommune_maengelAusfuehrungen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes maengelAusfuehrungen(
    Iterable<Query_MaengelKarte_kommune_maengelAusfuehrungen> Function(
      Iterable<
        CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<
          Query_MaengelKarte_kommune_maengelAusfuehrungen
        >
      >,
    )
    _fn,
  ) => call(
    maengelAusfuehrungen: _fn(
      _instance.maengelAusfuehrungen.map(
        (e) => CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MaengelKarte_kommune<TRes>
    implements CopyWith_Query_MaengelKarte_kommune<TRes> {
  _CopyWithStubImpl_Query_MaengelKarte_kommune(this._res);

  TRes _res;

  call({
    List<Query_MaengelKarte_kommune_maengelAusfuehrungen>? maengelAusfuehrungen,
    String? $__typename,
  }) => _res;

  maengelAusfuehrungen(_fn) => _res;
}

class Query_MaengelKarte_kommune_maengelAusfuehrungen {
  Query_MaengelKarte_kommune_maengelAusfuehrungen({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    required this.slotValues,
    required this.status,
  });

  factory Query_MaengelKarte_kommune_maengelAusfuehrungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$slotValues = json['slotValues'];
    final l$status = json['status'];
    return Query_MaengelKarte_kommune_maengelAusfuehrungen(
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
    if (other is! Query_MaengelKarte_kommune_maengelAusfuehrungen ||
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

extension UtilityExtension_Query_MaengelKarte_kommune_maengelAusfuehrungen
    on Query_MaengelKarte_kommune_maengelAusfuehrungen {
  CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<
    Query_MaengelKarte_kommune_maengelAusfuehrungen
  >
  get copyWith =>
      CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen(this, (i) => i);
}

abstract class CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<TRes> {
  factory CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen(
    Query_MaengelKarte_kommune_maengelAusfuehrungen instance,
    TRes Function(Query_MaengelKarte_kommune_maengelAusfuehrungen) then,
  ) = _CopyWithImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen;

  factory CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen;

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

class _CopyWithImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen<TRes>
    implements CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<TRes> {
  _CopyWithImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen(
    this._instance,
    this._then,
  );

  final Query_MaengelKarte_kommune_maengelAusfuehrungen _instance;

  final TRes Function(Query_MaengelKarte_kommune_maengelAusfuehrungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? slotValues = _undefined,
    Object? status = _undefined,
  }) => _then(
    Query_MaengelKarte_kommune_maengelAusfuehrungen(
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

class _CopyWithStubImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen<TRes>
    implements CopyWith_Query_MaengelKarte_kommune_maengelAusfuehrungen<TRes> {
  _CopyWithStubImpl_Query_MaengelKarte_kommune_maengelAusfuehrungen(this._res);

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

class Query_MeineMaengel {
  Query_MeineMaengel({required this.my, this.$__typename = 'Query'});

  factory Query_MeineMaengel.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_MeineMaengel(
      my: Query_MeineMaengel_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MeineMaengel_my my;

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
    if (other is! Query_MeineMaengel || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MeineMaengel on Query_MeineMaengel {
  CopyWith_Query_MeineMaengel<Query_MeineMaengel> get copyWith =>
      CopyWith_Query_MeineMaengel(this, (i) => i);
}

abstract class CopyWith_Query_MeineMaengel<TRes> {
  factory CopyWith_Query_MeineMaengel(
    Query_MeineMaengel instance,
    TRes Function(Query_MeineMaengel) then,
  ) = _CopyWithImpl_Query_MeineMaengel;

  factory CopyWith_Query_MeineMaengel.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineMaengel;

  TRes call({Query_MeineMaengel_my? my, String? $__typename});
  CopyWith_Query_MeineMaengel_my<TRes> get my;
}

class _CopyWithImpl_Query_MeineMaengel<TRes>
    implements CopyWith_Query_MeineMaengel<TRes> {
  _CopyWithImpl_Query_MeineMaengel(this._instance, this._then);

  final Query_MeineMaengel _instance;

  final TRes Function(Query_MeineMaengel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineMaengel(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_MeineMaengel_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MeineMaengel_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_MeineMaengel_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_MeineMaengel<TRes>
    implements CopyWith_Query_MeineMaengel<TRes> {
  _CopyWithStubImpl_Query_MeineMaengel(this._res);

  TRes _res;

  call({Query_MeineMaengel_my? my, String? $__typename}) => _res;

  CopyWith_Query_MeineMaengel_my<TRes> get my =>
      CopyWith_Query_MeineMaengel_my.stub(_res);
}

const documentNodeQueryMeineMaengel = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MeineMaengel'),
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
                        name: NameNode(value: 'maengel'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'MangelAusfuehrung'),
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
                        name: NameNode(value: 'gefolgteAusfuehrungen'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'MangelAusfuehrung'),
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
    fragmentDefinitionMangelAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Query_MeineMaengel _parserFn_Query_MeineMaengel(Map<String, dynamic> data) =>
    Query_MeineMaengel.fromJson(data);
typedef OnQueryComplete_Query_MeineMaengel =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MeineMaengel?);

class Options_Query_MeineMaengel
    extends graphql.QueryOptions<Query_MeineMaengel> {
  Options_Query_MeineMaengel({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MeineMaengel? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MeineMaengel? onComplete,
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
                 data == null ? null : _parserFn_Query_MeineMaengel(data),
               ),
         onError: onError,
         document: documentNodeQueryMeineMaengel,
         parserFn: _parserFn_Query_MeineMaengel,
       );

  final OnQueryComplete_Query_MeineMaengel? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MeineMaengel
    extends graphql.WatchQueryOptions<Query_MeineMaengel> {
  WatchOptions_Query_MeineMaengel({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MeineMaengel? typedOptimisticResult,
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
         document: documentNodeQueryMeineMaengel,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MeineMaengel,
       );
}

class FetchMoreOptions_Query_MeineMaengel extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MeineMaengel({
    required graphql.UpdateQuery updateQuery,
  }) : super(updateQuery: updateQuery, document: documentNodeQueryMeineMaengel);
}

extension ClientExtension_Query_MeineMaengel on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MeineMaengel>> query_MeineMaengel([
    Options_Query_MeineMaengel? options,
  ]) async => await this.query(options ?? Options_Query_MeineMaengel());

  graphql.ObservableQuery<Query_MeineMaengel> watchQuery_MeineMaengel([
    WatchOptions_Query_MeineMaengel? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MeineMaengel());

  void writeQuery_MeineMaengel({
    required Query_MeineMaengel data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMeineMaengel),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MeineMaengel? readQuery_MeineMaengel({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMeineMaengel),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MeineMaengel.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MeineMaengel> useQuery_MeineMaengel([
  Options_Query_MeineMaengel? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_MeineMaengel());
graphql.ObservableQuery<Query_MeineMaengel> useWatchQuery_MeineMaengel([
  WatchOptions_Query_MeineMaengel? options,
]) =>
    graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_MeineMaengel());

class Query_MeineMaengel_Widget
    extends graphql_flutter.Query<Query_MeineMaengel> {
  Query_MeineMaengel_Widget({
    widgets.Key? key,
    Options_Query_MeineMaengel? options,
    required graphql_flutter.QueryBuilder<Query_MeineMaengel> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MeineMaengel(),
         builder: builder,
       );
}

class Query_MeineMaengel_my {
  Query_MeineMaengel_my({required this.id, required this.$__typename});

  factory Query_MeineMaengel_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_MeineMaengel_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_MeineMaengel_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_MeineMaengel_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        return Query_MeineMaengel_my(
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
    if (other is! Query_MeineMaengel_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MeineMaengel_my on Query_MeineMaengel_my {
  CopyWith_Query_MeineMaengel_my<Query_MeineMaengel_my> get copyWith =>
      CopyWith_Query_MeineMaengel_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_MeineMaengel_my__Buerger) buerger,
    required _T Function(Query_MeineMaengel_my__BackofficeUser) backofficeUser,
    required _T Function(Query_MeineMaengel_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_MeineMaengel_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_MeineMaengel_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_MeineMaengel_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_MeineMaengel_my__Buerger)? buerger,
    _T Function(Query_MeineMaengel_my__BackofficeUser)? backofficeUser,
    _T Function(Query_MeineMaengel_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_MeineMaengel_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(this as Query_MeineMaengel_my__BackofficeUser);
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_MeineMaengel_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_MeineMaengel_my<TRes> {
  factory CopyWith_Query_MeineMaengel_my(
    Query_MeineMaengel_my instance,
    TRes Function(Query_MeineMaengel_my) then,
  ) = _CopyWithImpl_Query_MeineMaengel_my;

  factory CopyWith_Query_MeineMaengel_my.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineMaengel_my;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineMaengel_my<TRes>
    implements CopyWith_Query_MeineMaengel_my<TRes> {
  _CopyWithImpl_Query_MeineMaengel_my(this._instance, this._then);

  final Query_MeineMaengel_my _instance;

  final TRes Function(Query_MeineMaengel_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineMaengel_my(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineMaengel_my<TRes>
    implements CopyWith_Query_MeineMaengel_my<TRes> {
  _CopyWithStubImpl_Query_MeineMaengel_my(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MeineMaengel_my__Buerger implements Query_MeineMaengel_my {
  Query_MeineMaengel_my__Buerger({
    required this.maengel,
    required this.gefolgteAusfuehrungen,
    this.$__typename = 'Buerger',
    required this.id,
  });

  factory Query_MeineMaengel_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$maengel = json['maengel'];
    final l$gefolgteAusfuehrungen = json['gefolgteAusfuehrungen'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query_MeineMaengel_my__Buerger(
      maengel: (l$maengel as List<dynamic>)
          .map(
            (e) => Fragment_MangelAusfuehrung.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      gefolgteAusfuehrungen: (l$gefolgteAusfuehrungen as List<dynamic>)
          .map(
            (e) => Fragment_MangelAusfuehrung.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final List<Fragment_MangelAusfuehrung> maengel;

  final List<Fragment_MangelAusfuehrung> gefolgteAusfuehrungen;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$maengel = maengel;
    _resultData['maengel'] = l$maengel.map((e) => e.toJson()).toList();
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    _resultData['gefolgteAusfuehrungen'] = l$gefolgteAusfuehrungen
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
    final l$maengel = maengel;
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      Object.hashAll(l$maengel.map((v) => v)),
      Object.hashAll(l$gefolgteAusfuehrungen.map((v) => v)),
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MeineMaengel_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$maengel = maengel;
    final lOther$maengel = other.maengel;
    if (l$maengel.length != lOther$maengel.length) {
      return false;
    }
    for (int i = 0; i < l$maengel.length; i++) {
      final l$maengel$entry = l$maengel[i];
      final lOther$maengel$entry = lOther$maengel[i];
      if (l$maengel$entry != lOther$maengel$entry) {
        return false;
      }
    }
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    final lOther$gefolgteAusfuehrungen = other.gefolgteAusfuehrungen;
    if (l$gefolgteAusfuehrungen.length != lOther$gefolgteAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$gefolgteAusfuehrungen.length; i++) {
      final l$gefolgteAusfuehrungen$entry = l$gefolgteAusfuehrungen[i];
      final lOther$gefolgteAusfuehrungen$entry =
          lOther$gefolgteAusfuehrungen[i];
      if (l$gefolgteAusfuehrungen$entry != lOther$gefolgteAusfuehrungen$entry) {
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

extension UtilityExtension_Query_MeineMaengel_my__Buerger
    on Query_MeineMaengel_my__Buerger {
  CopyWith_Query_MeineMaengel_my__Buerger<Query_MeineMaengel_my__Buerger>
  get copyWith => CopyWith_Query_MeineMaengel_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_MeineMaengel_my__Buerger<TRes> {
  factory CopyWith_Query_MeineMaengel_my__Buerger(
    Query_MeineMaengel_my__Buerger instance,
    TRes Function(Query_MeineMaengel_my__Buerger) then,
  ) = _CopyWithImpl_Query_MeineMaengel_my__Buerger;

  factory CopyWith_Query_MeineMaengel_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineMaengel_my__Buerger;

  TRes call({
    List<Fragment_MangelAusfuehrung>? maengel,
    List<Fragment_MangelAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
    String? id,
  });
  TRes maengel(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  );
  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MeineMaengel_my__Buerger<TRes>
    implements CopyWith_Query_MeineMaengel_my__Buerger<TRes> {
  _CopyWithImpl_Query_MeineMaengel_my__Buerger(this._instance, this._then);

  final Query_MeineMaengel_my__Buerger _instance;

  final TRes Function(Query_MeineMaengel_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? maengel = _undefined,
    Object? gefolgteAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) => _then(
    Query_MeineMaengel_my__Buerger(
      maengel: maengel == _undefined || maengel == null
          ? _instance.maengel
          : (maengel as List<Fragment_MangelAusfuehrung>),
      gefolgteAusfuehrungen:
          gefolgteAusfuehrungen == _undefined || gefolgteAusfuehrungen == null
          ? _instance.gefolgteAusfuehrungen
          : (gefolgteAusfuehrungen as List<Fragment_MangelAusfuehrung>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
    ),
  );

  TRes maengel(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  ) => call(
    maengel: _fn(
      _instance.maengel.map(
        (e) => CopyWith_Fragment_MangelAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );

  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  ) => call(
    gefolgteAusfuehrungen: _fn(
      _instance.gefolgteAusfuehrungen.map(
        (e) => CopyWith_Fragment_MangelAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MeineMaengel_my__Buerger<TRes>
    implements CopyWith_Query_MeineMaengel_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_MeineMaengel_my__Buerger(this._res);

  TRes _res;

  call({
    List<Fragment_MangelAusfuehrung>? maengel,
    List<Fragment_MangelAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
    String? id,
  }) => _res;

  maengel(_fn) => _res;

  gefolgteAusfuehrungen(_fn) => _res;
}

class Query_MeineMaengel_my__BackofficeUser implements Query_MeineMaengel_my {
  Query_MeineMaengel_my__BackofficeUser({
    required this.id,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_MeineMaengel_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MeineMaengel_my__BackofficeUser(
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
    if (other is! Query_MeineMaengel_my__BackofficeUser ||
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

extension UtilityExtension_Query_MeineMaengel_my__BackofficeUser
    on Query_MeineMaengel_my__BackofficeUser {
  CopyWith_Query_MeineMaengel_my__BackofficeUser<
    Query_MeineMaengel_my__BackofficeUser
  >
  get copyWith =>
      CopyWith_Query_MeineMaengel_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_MeineMaengel_my__BackofficeUser<TRes> {
  factory CopyWith_Query_MeineMaengel_my__BackofficeUser(
    Query_MeineMaengel_my__BackofficeUser instance,
    TRes Function(Query_MeineMaengel_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_MeineMaengel_my__BackofficeUser;

  factory CopyWith_Query_MeineMaengel_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineMaengel_my__BackofficeUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineMaengel_my__BackofficeUser<TRes>
    implements CopyWith_Query_MeineMaengel_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_MeineMaengel_my__BackofficeUser(
    this._instance,
    this._then,
  );

  final Query_MeineMaengel_my__BackofficeUser _instance;

  final TRes Function(Query_MeineMaengel_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineMaengel_my__BackofficeUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineMaengel_my__BackofficeUser<TRes>
    implements CopyWith_Query_MeineMaengel_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_MeineMaengel_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MeineMaengel_my__SystemUser implements Query_MeineMaengel_my {
  Query_MeineMaengel_my__SystemUser({
    required this.id,
    this.$__typename = 'SystemUser',
  });

  factory Query_MeineMaengel_my__SystemUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MeineMaengel_my__SystemUser(
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
    if (other is! Query_MeineMaengel_my__SystemUser ||
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

extension UtilityExtension_Query_MeineMaengel_my__SystemUser
    on Query_MeineMaengel_my__SystemUser {
  CopyWith_Query_MeineMaengel_my__SystemUser<Query_MeineMaengel_my__SystemUser>
  get copyWith => CopyWith_Query_MeineMaengel_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_MeineMaengel_my__SystemUser<TRes> {
  factory CopyWith_Query_MeineMaengel_my__SystemUser(
    Query_MeineMaengel_my__SystemUser instance,
    TRes Function(Query_MeineMaengel_my__SystemUser) then,
  ) = _CopyWithImpl_Query_MeineMaengel_my__SystemUser;

  factory CopyWith_Query_MeineMaengel_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineMaengel_my__SystemUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineMaengel_my__SystemUser<TRes>
    implements CopyWith_Query_MeineMaengel_my__SystemUser<TRes> {
  _CopyWithImpl_Query_MeineMaengel_my__SystemUser(this._instance, this._then);

  final Query_MeineMaengel_my__SystemUser _instance;

  final TRes Function(Query_MeineMaengel_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineMaengel_my__SystemUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineMaengel_my__SystemUser<TRes>
    implements CopyWith_Query_MeineMaengel_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_MeineMaengel_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables_Query_Mangel {
  factory Variables_Query_Mangel({
    required String kommuneId,
    required String mangelId,
  }) => Variables_Query_Mangel._({
    r'kommuneId': kommuneId,
    r'mangelId': mangelId,
  });

  Variables_Query_Mangel._(this._$data);

  factory Variables_Query_Mangel.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$mangelId = data['mangelId'];
    result$data['mangelId'] = (l$mangelId as String);
    return Variables_Query_Mangel._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get mangelId => (_$data['mangelId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$mangelId = mangelId;
    result$data['mangelId'] = l$mangelId;
    return result$data;
  }

  CopyWith_Variables_Query_Mangel<Variables_Query_Mangel> get copyWith =>
      CopyWith_Variables_Query_Mangel(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Mangel || runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$mangelId = mangelId;
    final lOther$mangelId = other.mangelId;
    if (l$mangelId != lOther$mangelId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$mangelId = mangelId;
    return Object.hashAll([l$kommuneId, l$mangelId]);
  }
}

abstract class CopyWith_Variables_Query_Mangel<TRes> {
  factory CopyWith_Variables_Query_Mangel(
    Variables_Query_Mangel instance,
    TRes Function(Variables_Query_Mangel) then,
  ) = _CopyWithImpl_Variables_Query_Mangel;

  factory CopyWith_Variables_Query_Mangel.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Mangel;

  TRes call({String? kommuneId, String? mangelId});
}

class _CopyWithImpl_Variables_Query_Mangel<TRes>
    implements CopyWith_Variables_Query_Mangel<TRes> {
  _CopyWithImpl_Variables_Query_Mangel(this._instance, this._then);

  final Variables_Query_Mangel _instance;

  final TRes Function(Variables_Query_Mangel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? mangelId = _undefined}) =>
      _then(
        Variables_Query_Mangel._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (mangelId != _undefined && mangelId != null)
            'mangelId': (mangelId as String),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_Mangel<TRes>
    implements CopyWith_Variables_Query_Mangel<TRes> {
  _CopyWithStubImpl_Variables_Query_Mangel(this._res);

  TRes _res;

  call({String? kommuneId, String? mangelId}) => _res;
}

class Query_Mangel {
  Query_Mangel({required this.kommune, this.$__typename = 'Query'});

  factory Query_Mangel.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Mangel(
      kommune: Query_Mangel_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Mangel_kommune kommune;

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
    if (other is! Query_Mangel || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Mangel on Query_Mangel {
  CopyWith_Query_Mangel<Query_Mangel> get copyWith =>
      CopyWith_Query_Mangel(this, (i) => i);
}

abstract class CopyWith_Query_Mangel<TRes> {
  factory CopyWith_Query_Mangel(
    Query_Mangel instance,
    TRes Function(Query_Mangel) then,
  ) = _CopyWithImpl_Query_Mangel;

  factory CopyWith_Query_Mangel.stub(TRes res) = _CopyWithStubImpl_Query_Mangel;

  TRes call({Query_Mangel_kommune? kommune, String? $__typename});
  CopyWith_Query_Mangel_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Mangel<TRes> implements CopyWith_Query_Mangel<TRes> {
  _CopyWithImpl_Query_Mangel(this._instance, this._then);

  final Query_Mangel _instance;

  final TRes Function(Query_Mangel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Mangel(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Mangel_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Mangel_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Mangel_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_Mangel<TRes>
    implements CopyWith_Query_Mangel<TRes> {
  _CopyWithStubImpl_Query_Mangel(this._res);

  TRes _res;

  call({Query_Mangel_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_Mangel_kommune<TRes> get kommune =>
      CopyWith_Query_Mangel_kommune.stub(_res);
}

const documentNodeQueryMangel = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Mangel'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mangelId')),
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
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'mangelAusfuehrung'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'id'),
                      value: VariableNode(name: NameNode(value: 'mangelId')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MangelAusfuehrung'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'aktuellerNutzerFolgt'),
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
    fragmentDefinitionMangelAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Query_Mangel _parserFn_Query_Mangel(Map<String, dynamic> data) =>
    Query_Mangel.fromJson(data);
typedef OnQueryComplete_Query_Mangel =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Mangel?);

class Options_Query_Mangel extends graphql.QueryOptions<Query_Mangel> {
  Options_Query_Mangel({
    String? operationName,
    required Variables_Query_Mangel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Mangel? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Mangel? onComplete,
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
                 data == null ? null : _parserFn_Query_Mangel(data),
               ),
         onError: onError,
         document: documentNodeQueryMangel,
         parserFn: _parserFn_Query_Mangel,
       );

  final OnQueryComplete_Query_Mangel? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Mangel
    extends graphql.WatchQueryOptions<Query_Mangel> {
  WatchOptions_Query_Mangel({
    String? operationName,
    required Variables_Query_Mangel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Mangel? typedOptimisticResult,
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
         document: documentNodeQueryMangel,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Mangel,
       );
}

class FetchMoreOptions_Query_Mangel extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Mangel({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Mangel variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMangel,
       );
}

extension ClientExtension_Query_Mangel on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Mangel>> query_Mangel(
    Options_Query_Mangel options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Mangel> watchQuery_Mangel(
    WatchOptions_Query_Mangel options,
  ) => this.watchQuery(options);

  void writeQuery_Mangel({
    required Query_Mangel data,
    required Variables_Query_Mangel variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMangel),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Mangel? readQuery_Mangel({
    required Variables_Query_Mangel variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMangel),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Mangel.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Mangel> useQuery_Mangel(
  Options_Query_Mangel options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Mangel> useWatchQuery_Mangel(
  WatchOptions_Query_Mangel options,
) => graphql_flutter.useWatchQuery(options);

class Query_Mangel_Widget extends graphql_flutter.Query<Query_Mangel> {
  Query_Mangel_Widget({
    widgets.Key? key,
    required Options_Query_Mangel options,
    required graphql_flutter.QueryBuilder<Query_Mangel> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Mangel_kommune {
  Query_Mangel_kommune({
    required this.id,
    this.mangelAusfuehrung,
    this.$__typename = 'Kommune',
  });

  factory Query_Mangel_kommune.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$mangelAusfuehrung = json['mangelAusfuehrung'];
    final l$$__typename = json['__typename'];
    return Query_Mangel_kommune(
      id: (l$id as String),
      mangelAusfuehrung: l$mangelAusfuehrung == null
          ? null
          : Query_Mangel_kommune_mangelAusfuehrung.fromJson(
              (l$mangelAusfuehrung as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query_Mangel_kommune_mangelAusfuehrung? mangelAusfuehrung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$mangelAusfuehrung = mangelAusfuehrung;
    _resultData['mangelAusfuehrung'] = l$mangelAusfuehrung?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$mangelAusfuehrung = mangelAusfuehrung;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$mangelAusfuehrung, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Mangel_kommune || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$mangelAusfuehrung = mangelAusfuehrung;
    final lOther$mangelAusfuehrung = other.mangelAusfuehrung;
    if (l$mangelAusfuehrung != lOther$mangelAusfuehrung) {
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

extension UtilityExtension_Query_Mangel_kommune on Query_Mangel_kommune {
  CopyWith_Query_Mangel_kommune<Query_Mangel_kommune> get copyWith =>
      CopyWith_Query_Mangel_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Mangel_kommune<TRes> {
  factory CopyWith_Query_Mangel_kommune(
    Query_Mangel_kommune instance,
    TRes Function(Query_Mangel_kommune) then,
  ) = _CopyWithImpl_Query_Mangel_kommune;

  factory CopyWith_Query_Mangel_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Mangel_kommune;

  TRes call({
    String? id,
    Query_Mangel_kommune_mangelAusfuehrung? mangelAusfuehrung,
    String? $__typename,
  });
  CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> get mangelAusfuehrung;
}

class _CopyWithImpl_Query_Mangel_kommune<TRes>
    implements CopyWith_Query_Mangel_kommune<TRes> {
  _CopyWithImpl_Query_Mangel_kommune(this._instance, this._then);

  final Query_Mangel_kommune _instance;

  final TRes Function(Query_Mangel_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? mangelAusfuehrung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Mangel_kommune(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      mangelAusfuehrung: mangelAusfuehrung == _undefined
          ? _instance.mangelAusfuehrung
          : (mangelAusfuehrung as Query_Mangel_kommune_mangelAusfuehrung?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> get mangelAusfuehrung {
    final local$mangelAusfuehrung = _instance.mangelAusfuehrung;
    return local$mangelAusfuehrung == null
        ? CopyWith_Query_Mangel_kommune_mangelAusfuehrung.stub(_then(_instance))
        : CopyWith_Query_Mangel_kommune_mangelAusfuehrung(
            local$mangelAusfuehrung,
            (e) => call(mangelAusfuehrung: e),
          );
  }
}

class _CopyWithStubImpl_Query_Mangel_kommune<TRes>
    implements CopyWith_Query_Mangel_kommune<TRes> {
  _CopyWithStubImpl_Query_Mangel_kommune(this._res);

  TRes _res;

  call({
    String? id,
    Query_Mangel_kommune_mangelAusfuehrung? mangelAusfuehrung,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> get mangelAusfuehrung =>
      CopyWith_Query_Mangel_kommune_mangelAusfuehrung.stub(_res);
}

class Query_Mangel_kommune_mangelAusfuehrung
    implements Fragment_MangelAusfuehrung {
  Query_Mangel_kommune_mangelAusfuehrung({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    this.adresse,
    this.beschreibung,
    this.kategorie,
    this.title,
    this.bilder,
    required this.status,
    required this.aktuellerNutzerFolgt,
    required this.historie,
  });

  factory Query_Mangel_kommune_mangelAusfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$adresse = json['adresse'];
    final l$beschreibung = json['beschreibung'];
    final l$kategorie = json['kategorie'];
    final l$title = json['title'];
    final l$bilder = json['bilder'];
    final l$status = json['status'];
    final l$aktuellerNutzerFolgt = json['aktuellerNutzerFolgt'];
    final l$historie = json['historie'];
    return Query_Mangel_kommune_mangelAusfuehrung(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      userId: (l$userId as String),
      adresse: l$adresse == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$adresse as Map<String, dynamic>),
            ),
      beschreibung: l$beschreibung == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$beschreibung as Map<String, dynamic>),
            ),
      kategorie: l$kategorie == null
          ? null
          : Fragment_PlainSlotValue.fromJson(
              (l$kategorie as Map<String, dynamic>),
            ),
      title: l$title == null
          ? null
          : Fragment_PlainSlotValue.fromJson((l$title as Map<String, dynamic>)),
      bilder: l$bilder == null
          ? null
          : Query_Mangel_kommune_mangelAusfuehrung_bilder.fromJson(
              (l$bilder as Map<String, dynamic>),
            ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
      aktuellerNutzerFolgt: (l$aktuellerNutzerFolgt as bool),
      historie: (l$historie as List<dynamic>)
          .map(
            (e) => Query_Mangel_kommune_mangelAusfuehrung_historie.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String $__typename;

  final String id;

  final String userId;

  final Fragment_PlainSlotValue? adresse;

  final Fragment_PlainSlotValue? beschreibung;

  final Fragment_PlainSlotValue? kategorie;

  final Fragment_PlainSlotValue? title;

  final Query_Mangel_kommune_mangelAusfuehrung_bilder? bilder;

  final Enum_AusfuehrungStatus status;

  final bool aktuellerNutzerFolgt;

  final List<Query_Mangel_kommune_mangelAusfuehrung_historie> historie;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$userId = userId;
    _resultData['userId'] = l$userId;
    final l$adresse = adresse;
    _resultData['adresse'] = l$adresse?.toJson();
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung?.toJson();
    final l$kategorie = kategorie;
    _resultData['kategorie'] = l$kategorie?.toJson();
    final l$title = title;
    _resultData['title'] = l$title?.toJson();
    final l$bilder = bilder;
    _resultData['bilder'] = l$bilder?.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    final l$aktuellerNutzerFolgt = aktuellerNutzerFolgt;
    _resultData['aktuellerNutzerFolgt'] = l$aktuellerNutzerFolgt;
    final l$historie = historie;
    _resultData['historie'] = l$historie.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$userId = userId;
    final l$adresse = adresse;
    final l$beschreibung = beschreibung;
    final l$kategorie = kategorie;
    final l$title = title;
    final l$bilder = bilder;
    final l$status = status;
    final l$aktuellerNutzerFolgt = aktuellerNutzerFolgt;
    final l$historie = historie;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$userId,
      l$adresse,
      l$beschreibung,
      l$kategorie,
      l$title,
      l$bilder,
      l$status,
      l$aktuellerNutzerFolgt,
      Object.hashAll(l$historie.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Mangel_kommune_mangelAusfuehrung ||
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
    final l$adresse = adresse;
    final lOther$adresse = other.adresse;
    if (l$adresse != lOther$adresse) {
      return false;
    }
    final l$beschreibung = beschreibung;
    final lOther$beschreibung = other.beschreibung;
    if (l$beschreibung != lOther$beschreibung) {
      return false;
    }
    final l$kategorie = kategorie;
    final lOther$kategorie = other.kategorie;
    if (l$kategorie != lOther$kategorie) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$bilder = bilder;
    final lOther$bilder = other.bilder;
    if (l$bilder != lOther$bilder) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$aktuellerNutzerFolgt = aktuellerNutzerFolgt;
    final lOther$aktuellerNutzerFolgt = other.aktuellerNutzerFolgt;
    if (l$aktuellerNutzerFolgt != lOther$aktuellerNutzerFolgt) {
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
    return true;
  }
}

extension UtilityExtension_Query_Mangel_kommune_mangelAusfuehrung
    on Query_Mangel_kommune_mangelAusfuehrung {
  CopyWith_Query_Mangel_kommune_mangelAusfuehrung<
    Query_Mangel_kommune_mangelAusfuehrung
  >
  get copyWith =>
      CopyWith_Query_Mangel_kommune_mangelAusfuehrung(this, (i) => i);
}

abstract class CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> {
  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung(
    Query_Mangel_kommune_mangelAusfuehrung instance,
    TRes Function(Query_Mangel_kommune_mangelAusfuehrung) then,
  ) = _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung;

  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung;

  TRes call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? kategorie,
    Fragment_PlainSlotValue? title,
    Query_Mangel_kommune_mangelAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    bool? aktuellerNutzerFolgt,
    List<Query_Mangel_kommune_mangelAusfuehrung_historie>? historie,
  });
  CopyWith_Fragment_PlainSlotValue<TRes> get adresse;
  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung;
  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie;
  CopyWith_Fragment_PlainSlotValue<TRes> get title;
  CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> get bilder;
  TRes historie(
    Iterable<Query_Mangel_kommune_mangelAusfuehrung_historie> Function(
      Iterable<
        CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<
          Query_Mangel_kommune_mangelAusfuehrung_historie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> {
  _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung(
    this._instance,
    this._then,
  );

  final Query_Mangel_kommune_mangelAusfuehrung _instance;

  final TRes Function(Query_Mangel_kommune_mangelAusfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? adresse = _undefined,
    Object? beschreibung = _undefined,
    Object? kategorie = _undefined,
    Object? title = _undefined,
    Object? bilder = _undefined,
    Object? status = _undefined,
    Object? aktuellerNutzerFolgt = _undefined,
    Object? historie = _undefined,
  }) => _then(
    Query_Mangel_kommune_mangelAusfuehrung(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      userId: userId == _undefined || userId == null
          ? _instance.userId
          : (userId as String),
      adresse: adresse == _undefined
          ? _instance.adresse
          : (adresse as Fragment_PlainSlotValue?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as Fragment_PlainSlotValue?),
      kategorie: kategorie == _undefined
          ? _instance.kategorie
          : (kategorie as Fragment_PlainSlotValue?),
      title: title == _undefined
          ? _instance.title
          : (title as Fragment_PlainSlotValue?),
      bilder: bilder == _undefined
          ? _instance.bilder
          : (bilder as Query_Mangel_kommune_mangelAusfuehrung_bilder?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
      aktuellerNutzerFolgt:
          aktuellerNutzerFolgt == _undefined || aktuellerNutzerFolgt == null
          ? _instance.aktuellerNutzerFolgt
          : (aktuellerNutzerFolgt as bool),
      historie: historie == _undefined || historie == null
          ? _instance.historie
          : (historie as List<Query_Mangel_kommune_mangelAusfuehrung_historie>),
    ),
  );

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse {
    final local$adresse = _instance.adresse;
    return local$adresse == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$adresse,
            (e) => call(adresse: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung {
    final local$beschreibung = _instance.beschreibung;
    return local$beschreibung == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$beschreibung,
            (e) => call(beschreibung: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie {
    final local$kategorie = _instance.kategorie;
    return local$kategorie == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(
            local$kategorie,
            (e) => call(kategorie: e),
          );
  }

  CopyWith_Fragment_PlainSlotValue<TRes> get title {
    final local$title = _instance.title;
    return local$title == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(local$title, (e) => call(title: e));
  }

  CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> get bilder {
    final local$bilder = _instance.bilder;
    return local$bilder == null
        ? CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder.stub(
            _then(_instance),
          )
        : CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder(
            local$bilder,
            (e) => call(bilder: e),
          );
  }

  TRes historie(
    Iterable<Query_Mangel_kommune_mangelAusfuehrung_historie> Function(
      Iterable<
        CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<
          Query_Mangel_kommune_mangelAusfuehrung_historie
        >
      >,
    )
    _fn,
  ) => call(
    historie: _fn(
      _instance.historie.map(
        (e) => CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung<TRes> {
  _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? kategorie,
    Fragment_PlainSlotValue? title,
    Query_Mangel_kommune_mangelAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    bool? aktuellerNutzerFolgt,
    List<Query_Mangel_kommune_mangelAusfuehrung_historie>? historie,
  }) => _res;

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get kategorie =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get title =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> get bilder =>
      CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder.stub(_res);

  historie(_fn) => _res;
}

class Query_Mangel_kommune_mangelAusfuehrung_bilder
    implements Fragment_MangelAusfuehrung_bilder {
  Query_Mangel_kommune_mangelAusfuehrung_bilder({
    required this.id,
    required this.slotName,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
  });

  factory Query_Mangel_kommune_mangelAusfuehrung_bilder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    return Query_Mangel_kommune_mangelAusfuehrung_bilder(
      id: (l$id as String),
      slotName: (l$slotName as String),
      slotValueCount: (l$slotValueCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String slotName;

  final int slotValueCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$slotName = slotName;
    _resultData['slotName'] = l$slotName;
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
    final l$slotValueCount = slotValueCount;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$slotName, l$slotValueCount, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Mangel_kommune_mangelAusfuehrung_bilder ||
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

extension UtilityExtension_Query_Mangel_kommune_mangelAusfuehrung_bilder
    on Query_Mangel_kommune_mangelAusfuehrung_bilder {
  CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<
    Query_Mangel_kommune_mangelAusfuehrung_bilder
  >
  get copyWith =>
      CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder(this, (i) => i);
}

abstract class CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> {
  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder(
    Query_Mangel_kommune_mangelAusfuehrung_bilder instance,
    TRes Function(Query_Mangel_kommune_mangelAusfuehrung_bilder) then,
  ) = _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder;

  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder;

  TRes call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> {
  _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder(
    this._instance,
    this._then,
  );

  final Query_Mangel_kommune_mangelAusfuehrung_bilder _instance;

  final TRes Function(Query_Mangel_kommune_mangelAusfuehrung_bilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Mangel_kommune_mangelAusfuehrung_bilder(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      slotName: slotName == _undefined || slotName == null
          ? _instance.slotName
          : (slotName as String),
      slotValueCount: slotValueCount == _undefined || slotValueCount == null
          ? _instance.slotValueCount
          : (slotValueCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung_bilder<TRes> {
  _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_bilder(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  }) => _res;
}

class Query_Mangel_kommune_mangelAusfuehrung_historie {
  Query_Mangel_kommune_mangelAusfuehrung_historie({
    required this.id,
    required this.createdAt,
    this.statusAenderung,
    this.nachricht,
    this.$__typename = 'Historie',
  });

  factory Query_Mangel_kommune_mangelAusfuehrung_historie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$createdAt = json['createdAt'];
    final l$statusAenderung = json['statusAenderung'];
    final l$nachricht = json['nachricht'];
    final l$$__typename = json['__typename'];
    return Query_Mangel_kommune_mangelAusfuehrung_historie(
      id: (l$id as String),
      createdAt: DateTime.parse((l$createdAt as String)),
      statusAenderung: (l$statusAenderung as String?),
      nachricht: (l$nachricht as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final DateTime createdAt;

  final String? statusAenderung;

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
    final l$nachricht = nachricht;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$createdAt,
      l$statusAenderung,
      l$nachricht,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Mangel_kommune_mangelAusfuehrung_historie ||
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

extension UtilityExtension_Query_Mangel_kommune_mangelAusfuehrung_historie
    on Query_Mangel_kommune_mangelAusfuehrung_historie {
  CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<
    Query_Mangel_kommune_mangelAusfuehrung_historie
  >
  get copyWith =>
      CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie(this, (i) => i);
}

abstract class CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<TRes> {
  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie(
    Query_Mangel_kommune_mangelAusfuehrung_historie instance,
    TRes Function(Query_Mangel_kommune_mangelAusfuehrung_historie) then,
  ) = _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_historie;

  factory CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_historie;

  TRes call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? nachricht,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_historie<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<TRes> {
  _CopyWithImpl_Query_Mangel_kommune_mangelAusfuehrung_historie(
    this._instance,
    this._then,
  );

  final Query_Mangel_kommune_mangelAusfuehrung_historie _instance;

  final TRes Function(Query_Mangel_kommune_mangelAusfuehrung_historie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? createdAt = _undefined,
    Object? statusAenderung = _undefined,
    Object? nachricht = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Mangel_kommune_mangelAusfuehrung_historie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      statusAenderung: statusAenderung == _undefined
          ? _instance.statusAenderung
          : (statusAenderung as String?),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_historie<TRes>
    implements CopyWith_Query_Mangel_kommune_mangelAusfuehrung_historie<TRes> {
  _CopyWithStubImpl_Query_Mangel_kommune_mangelAusfuehrung_historie(this._res);

  TRes _res;

  call({
    String? id,
    DateTime? createdAt,
    String? statusAenderung,
    String? nachricht,
    String? $__typename,
  }) => _res;
}

class Variables_Mutation_MangelFolgen {
  factory Variables_Mutation_MangelFolgen({
    required Input_AusfuehrungFolgenInput input,
  }) => Variables_Mutation_MangelFolgen._({r'input': input});

  Variables_Mutation_MangelFolgen._(this._$data);

  factory Variables_Mutation_MangelFolgen.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_AusfuehrungFolgenInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_MangelFolgen._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_AusfuehrungFolgenInput get input =>
      (_$data['input'] as Input_AusfuehrungFolgenInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_MangelFolgen<Variables_Mutation_MangelFolgen>
  get copyWith => CopyWith_Variables_Mutation_MangelFolgen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_MangelFolgen ||
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

abstract class CopyWith_Variables_Mutation_MangelFolgen<TRes> {
  factory CopyWith_Variables_Mutation_MangelFolgen(
    Variables_Mutation_MangelFolgen instance,
    TRes Function(Variables_Mutation_MangelFolgen) then,
  ) = _CopyWithImpl_Variables_Mutation_MangelFolgen;

  factory CopyWith_Variables_Mutation_MangelFolgen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_MangelFolgen;

  TRes call({Input_AusfuehrungFolgenInput? input});
}

class _CopyWithImpl_Variables_Mutation_MangelFolgen<TRes>
    implements CopyWith_Variables_Mutation_MangelFolgen<TRes> {
  _CopyWithImpl_Variables_Mutation_MangelFolgen(this._instance, this._then);

  final Variables_Mutation_MangelFolgen _instance;

  final TRes Function(Variables_Mutation_MangelFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_MangelFolgen._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_AusfuehrungFolgenInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_MangelFolgen<TRes>
    implements CopyWith_Variables_Mutation_MangelFolgen<TRes> {
  _CopyWithStubImpl_Variables_Mutation_MangelFolgen(this._res);

  TRes _res;

  call({Input_AusfuehrungFolgenInput? input}) => _res;
}

class Mutation_MangelFolgen {
  Mutation_MangelFolgen({
    required this.ausfuehrungFolgen,
    this.$__typename = 'Mutation',
  });

  factory Mutation_MangelFolgen.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrungFolgen = json['ausfuehrungFolgen'];
    final l$$__typename = json['__typename'];
    return Mutation_MangelFolgen(
      ausfuehrungFolgen: Mutation_MangelFolgen_ausfuehrungFolgen.fromJson(
        (l$ausfuehrungFolgen as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_MangelFolgen_ausfuehrungFolgen ausfuehrungFolgen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ausfuehrungFolgen = ausfuehrungFolgen;
    _resultData['ausfuehrungFolgen'] = l$ausfuehrungFolgen.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ausfuehrungFolgen = ausfuehrungFolgen;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ausfuehrungFolgen, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_MangelFolgen || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ausfuehrungFolgen = ausfuehrungFolgen;
    final lOther$ausfuehrungFolgen = other.ausfuehrungFolgen;
    if (l$ausfuehrungFolgen != lOther$ausfuehrungFolgen) {
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

extension UtilityExtension_Mutation_MangelFolgen on Mutation_MangelFolgen {
  CopyWith_Mutation_MangelFolgen<Mutation_MangelFolgen> get copyWith =>
      CopyWith_Mutation_MangelFolgen(this, (i) => i);
}

abstract class CopyWith_Mutation_MangelFolgen<TRes> {
  factory CopyWith_Mutation_MangelFolgen(
    Mutation_MangelFolgen instance,
    TRes Function(Mutation_MangelFolgen) then,
  ) = _CopyWithImpl_Mutation_MangelFolgen;

  factory CopyWith_Mutation_MangelFolgen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_MangelFolgen;

  TRes call({
    Mutation_MangelFolgen_ausfuehrungFolgen? ausfuehrungFolgen,
    String? $__typename,
  });
  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes> get ausfuehrungFolgen;
}

class _CopyWithImpl_Mutation_MangelFolgen<TRes>
    implements CopyWith_Mutation_MangelFolgen<TRes> {
  _CopyWithImpl_Mutation_MangelFolgen(this._instance, this._then);

  final Mutation_MangelFolgen _instance;

  final TRes Function(Mutation_MangelFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungFolgen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_MangelFolgen(
      ausfuehrungFolgen:
          ausfuehrungFolgen == _undefined || ausfuehrungFolgen == null
          ? _instance.ausfuehrungFolgen
          : (ausfuehrungFolgen as Mutation_MangelFolgen_ausfuehrungFolgen),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes> get ausfuehrungFolgen {
    final local$ausfuehrungFolgen = _instance.ausfuehrungFolgen;
    return CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen(
      local$ausfuehrungFolgen,
      (e) => call(ausfuehrungFolgen: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_MangelFolgen<TRes>
    implements CopyWith_Mutation_MangelFolgen<TRes> {
  _CopyWithStubImpl_Mutation_MangelFolgen(this._res);

  TRes _res;

  call({
    Mutation_MangelFolgen_ausfuehrungFolgen? ausfuehrungFolgen,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes>
  get ausfuehrungFolgen =>
      CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen.stub(_res);
}

const documentNodeMutationMangelFolgen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MangelFolgen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'AusfuehrungFolgenInput'),
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
            name: NameNode(value: 'ausfuehrungFolgen'),
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
                        name: NameNode(value: 'gefolgteAusfuehrungen'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'MangelAusfuehrung'),
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
    fragmentDefinitionMangelAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Mutation_MangelFolgen _parserFn_Mutation_MangelFolgen(
  Map<String, dynamic> data,
) => Mutation_MangelFolgen.fromJson(data);
typedef OnMutationCompleted_Mutation_MangelFolgen =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_MangelFolgen?);

class Options_Mutation_MangelFolgen
    extends graphql.MutationOptions<Mutation_MangelFolgen> {
  Options_Mutation_MangelFolgen({
    String? operationName,
    required Variables_Mutation_MangelFolgen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_MangelFolgen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_MangelFolgen? onCompleted,
    graphql.OnMutationUpdate<Mutation_MangelFolgen>? update,
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
                 data == null ? null : _parserFn_Mutation_MangelFolgen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMangelFolgen,
         parserFn: _parserFn_Mutation_MangelFolgen,
       );

  final OnMutationCompleted_Mutation_MangelFolgen? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_MangelFolgen
    extends graphql.WatchQueryOptions<Mutation_MangelFolgen> {
  WatchOptions_Mutation_MangelFolgen({
    String? operationName,
    required Variables_Mutation_MangelFolgen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_MangelFolgen? typedOptimisticResult,
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
         document: documentNodeMutationMangelFolgen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_MangelFolgen,
       );
}

extension ClientExtension_Mutation_MangelFolgen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_MangelFolgen>> mutate_MangelFolgen(
    Options_Mutation_MangelFolgen options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_MangelFolgen> watchMutation_MangelFolgen(
    WatchOptions_Mutation_MangelFolgen options,
  ) => this.watchMutation(options);
}

class Mutation_MangelFolgen_HookResult {
  Mutation_MangelFolgen_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_MangelFolgen runMutation;

  final graphql.QueryResult<Mutation_MangelFolgen> result;
}

Mutation_MangelFolgen_HookResult useMutation_MangelFolgen([
  WidgetOptions_Mutation_MangelFolgen? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_MangelFolgen(),
  );
  return Mutation_MangelFolgen_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_MangelFolgen> useWatchMutation_MangelFolgen(
  WatchOptions_Mutation_MangelFolgen options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_MangelFolgen
    extends graphql.MutationOptions<Mutation_MangelFolgen> {
  WidgetOptions_Mutation_MangelFolgen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_MangelFolgen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_MangelFolgen? onCompleted,
    graphql.OnMutationUpdate<Mutation_MangelFolgen>? update,
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
                 data == null ? null : _parserFn_Mutation_MangelFolgen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMangelFolgen,
         parserFn: _parserFn_Mutation_MangelFolgen,
       );

  final OnMutationCompleted_Mutation_MangelFolgen? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_MangelFolgen =
    graphql.MultiSourceResult<Mutation_MangelFolgen> Function(
      Variables_Mutation_MangelFolgen, {
      Object? optimisticResult,
      Mutation_MangelFolgen? typedOptimisticResult,
    });
typedef Builder_Mutation_MangelFolgen =
    widgets.Widget Function(
      RunMutation_Mutation_MangelFolgen,
      graphql.QueryResult<Mutation_MangelFolgen>?,
    );

class Mutation_MangelFolgen_Widget
    extends graphql_flutter.Mutation<Mutation_MangelFolgen> {
  Mutation_MangelFolgen_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_MangelFolgen? options,
    required Builder_Mutation_MangelFolgen builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_MangelFolgen(),
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

class Mutation_MangelFolgen_ausfuehrungFolgen {
  Mutation_MangelFolgen_ausfuehrungFolgen({
    this.buerger,
    this.$__typename = 'AusfuehrungFolgenPayload',
  });

  factory Mutation_MangelFolgen_ausfuehrungFolgen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$buerger = json['buerger'];
    final l$$__typename = json['__typename'];
    return Mutation_MangelFolgen_ausfuehrungFolgen(
      buerger: l$buerger == null
          ? null
          : Mutation_MangelFolgen_ausfuehrungFolgen_buerger.fromJson(
              (l$buerger as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_MangelFolgen_ausfuehrungFolgen_buerger? buerger;

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
    if (other is! Mutation_MangelFolgen_ausfuehrungFolgen ||
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

extension UtilityExtension_Mutation_MangelFolgen_ausfuehrungFolgen
    on Mutation_MangelFolgen_ausfuehrungFolgen {
  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<
    Mutation_MangelFolgen_ausfuehrungFolgen
  >
  get copyWith =>
      CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen(this, (i) => i);
}

abstract class CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes> {
  factory CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen(
    Mutation_MangelFolgen_ausfuehrungFolgen instance,
    TRes Function(Mutation_MangelFolgen_ausfuehrungFolgen) then,
  ) = _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen;

  factory CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen;

  TRes call({
    Mutation_MangelFolgen_ausfuehrungFolgen_buerger? buerger,
    String? $__typename,
  });
  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> get buerger;
}

class _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen<TRes>
    implements CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes> {
  _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen(
    this._instance,
    this._then,
  );

  final Mutation_MangelFolgen_ausfuehrungFolgen _instance;

  final TRes Function(Mutation_MangelFolgen_ausfuehrungFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? buerger = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_MangelFolgen_ausfuehrungFolgen(
          buerger: buerger == _undefined
              ? _instance.buerger
              : (buerger as Mutation_MangelFolgen_ausfuehrungFolgen_buerger?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> get buerger {
    final local$buerger = _instance.buerger;
    return local$buerger == null
        ? CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger(
            local$buerger,
            (e) => call(buerger: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen<TRes>
    implements CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen<TRes> {
  _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen(this._res);

  TRes _res;

  call({
    Mutation_MangelFolgen_ausfuehrungFolgen_buerger? buerger,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> get buerger =>
      CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger.stub(_res);
}

class Mutation_MangelFolgen_ausfuehrungFolgen_buerger {
  Mutation_MangelFolgen_ausfuehrungFolgen_buerger({
    required this.id,
    required this.gefolgteAusfuehrungen,
    this.$__typename = 'Buerger',
  });

  factory Mutation_MangelFolgen_ausfuehrungFolgen_buerger.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$gefolgteAusfuehrungen = json['gefolgteAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Mutation_MangelFolgen_ausfuehrungFolgen_buerger(
      id: (l$id as String),
      gefolgteAusfuehrungen: (l$gefolgteAusfuehrungen as List<dynamic>)
          .map(
            (e) => Fragment_MangelAusfuehrung.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment_MangelAusfuehrung> gefolgteAusfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    _resultData['gefolgteAusfuehrungen'] = l$gefolgteAusfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$gefolgteAusfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_MangelFolgen_ausfuehrungFolgen_buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$gefolgteAusfuehrungen = gefolgteAusfuehrungen;
    final lOther$gefolgteAusfuehrungen = other.gefolgteAusfuehrungen;
    if (l$gefolgteAusfuehrungen.length != lOther$gefolgteAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$gefolgteAusfuehrungen.length; i++) {
      final l$gefolgteAusfuehrungen$entry = l$gefolgteAusfuehrungen[i];
      final lOther$gefolgteAusfuehrungen$entry =
          lOther$gefolgteAusfuehrungen[i];
      if (l$gefolgteAusfuehrungen$entry != lOther$gefolgteAusfuehrungen$entry) {
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

extension UtilityExtension_Mutation_MangelFolgen_ausfuehrungFolgen_buerger
    on Mutation_MangelFolgen_ausfuehrungFolgen_buerger {
  CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<
    Mutation_MangelFolgen_ausfuehrungFolgen_buerger
  >
  get copyWith =>
      CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger(this, (i) => i);
}

abstract class CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> {
  factory CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger(
    Mutation_MangelFolgen_ausfuehrungFolgen_buerger instance,
    TRes Function(Mutation_MangelFolgen_ausfuehrungFolgen_buerger) then,
  ) = _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger;

  factory CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger;

  TRes call({
    String? id,
    List<Fragment_MangelAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
  });
  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes>
    implements CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> {
  _CopyWithImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger(
    this._instance,
    this._then,
  );

  final Mutation_MangelFolgen_ausfuehrungFolgen_buerger _instance;

  final TRes Function(Mutation_MangelFolgen_ausfuehrungFolgen_buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? gefolgteAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_MangelFolgen_ausfuehrungFolgen_buerger(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      gefolgteAusfuehrungen:
          gefolgteAusfuehrungen == _undefined || gefolgteAusfuehrungen == null
          ? _instance.gefolgteAusfuehrungen
          : (gefolgteAusfuehrungen as List<Fragment_MangelAusfuehrung>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_MangelAusfuehrung> Function(
      Iterable<CopyWith_Fragment_MangelAusfuehrung<Fragment_MangelAusfuehrung>>,
    )
    _fn,
  ) => call(
    gefolgteAusfuehrungen: _fn(
      _instance.gefolgteAusfuehrungen.map(
        (e) => CopyWith_Fragment_MangelAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes>
    implements CopyWith_Mutation_MangelFolgen_ausfuehrungFolgen_buerger<TRes> {
  _CopyWithStubImpl_Mutation_MangelFolgen_ausfuehrungFolgen_buerger(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment_MangelAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
  }) => _res;

  gefolgteAusfuehrungen(_fn) => _res;
}
