import 'dart:async';
import 'fragments.graphql.dart';
import 'maengel.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_IdeeAusfuehrung {
  Fragment_IdeeAusfuehrung({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    this.adresse,
    this.beschreibung,
    this.title,
    this.bilder,
    required this.status,
    required this.prozessVersion,
  });

  factory Fragment_IdeeAusfuehrung.fromJson(Map<String, dynamic> json) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$adresse = json['adresse'];
    final l$beschreibung = json['beschreibung'];
    final l$title = json['title'];
    final l$bilder = json['bilder'];
    final l$status = json['status'];
    final l$prozessVersion = json['prozessVersion'];
    return Fragment_IdeeAusfuehrung(
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
      title: l$title == null
          ? null
          : Fragment_PlainSlotValue.fromJson((l$title as Map<String, dynamic>)),
      bilder: l$bilder == null
          ? null
          : Fragment_IdeeAusfuehrung_bilder.fromJson(
              (l$bilder as Map<String, dynamic>),
            ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
      prozessVersion: Fragment_IdeeAusfuehrung_prozessVersion.fromJson(
        (l$prozessVersion as Map<String, dynamic>),
      ),
    );
  }

  final String $__typename;

  final String id;

  final String userId;

  final Fragment_PlainSlotValue? adresse;

  final Fragment_PlainSlotValue? beschreibung;

  final Fragment_PlainSlotValue? title;

  final Fragment_IdeeAusfuehrung_bilder? bilder;

  final Enum_AusfuehrungStatus status;

  final Fragment_IdeeAusfuehrung_prozessVersion prozessVersion;

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
    final l$title = title;
    _resultData['title'] = l$title?.toJson();
    final l$bilder = bilder;
    _resultData['bilder'] = l$bilder?.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$userId = userId;
    final l$adresse = adresse;
    final l$beschreibung = beschreibung;
    final l$title = title;
    final l$bilder = bilder;
    final l$status = status;
    final l$prozessVersion = prozessVersion;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$userId,
      l$adresse,
      l$beschreibung,
      l$title,
      l$bilder,
      l$status,
      l$prozessVersion,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_IdeeAusfuehrung ||
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
    final l$prozessVersion = prozessVersion;
    final lOther$prozessVersion = other.prozessVersion;
    if (l$prozessVersion != lOther$prozessVersion) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_IdeeAusfuehrung
    on Fragment_IdeeAusfuehrung {
  CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung> get copyWith =>
      CopyWith_Fragment_IdeeAusfuehrung(this, (i) => i);
}

abstract class CopyWith_Fragment_IdeeAusfuehrung<TRes> {
  factory CopyWith_Fragment_IdeeAusfuehrung(
    Fragment_IdeeAusfuehrung instance,
    TRes Function(Fragment_IdeeAusfuehrung) then,
  ) = _CopyWithImpl_Fragment_IdeeAusfuehrung;

  factory CopyWith_Fragment_IdeeAusfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Fragment_IdeeAusfuehrung;

  TRes call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? title,
    Fragment_IdeeAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    Fragment_IdeeAusfuehrung_prozessVersion? prozessVersion,
  });
  CopyWith_Fragment_PlainSlotValue<TRes> get adresse;
  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung;
  CopyWith_Fragment_PlainSlotValue<TRes> get title;
  CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> get bilder;
  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> get prozessVersion;
}

class _CopyWithImpl_Fragment_IdeeAusfuehrung<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung<TRes> {
  _CopyWithImpl_Fragment_IdeeAusfuehrung(this._instance, this._then);

  final Fragment_IdeeAusfuehrung _instance;

  final TRes Function(Fragment_IdeeAusfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? adresse = _undefined,
    Object? beschreibung = _undefined,
    Object? title = _undefined,
    Object? bilder = _undefined,
    Object? status = _undefined,
    Object? prozessVersion = _undefined,
  }) => _then(
    Fragment_IdeeAusfuehrung(
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
      title: title == _undefined
          ? _instance.title
          : (title as Fragment_PlainSlotValue?),
      bilder: bilder == _undefined
          ? _instance.bilder
          : (bilder as Fragment_IdeeAusfuehrung_bilder?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion as Fragment_IdeeAusfuehrung_prozessVersion),
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

  CopyWith_Fragment_PlainSlotValue<TRes> get title {
    final local$title = _instance.title;
    return local$title == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(local$title, (e) => call(title: e));
  }

  CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> get bilder {
    final local$bilder = _instance.bilder;
    return local$bilder == null
        ? CopyWith_Fragment_IdeeAusfuehrung_bilder.stub(_then(_instance))
        : CopyWith_Fragment_IdeeAusfuehrung_bilder(
            local$bilder,
            (e) => call(bilder: e),
          );
  }

  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Fragment_IdeeAusfuehrung_prozessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }
}

class _CopyWithStubImpl_Fragment_IdeeAusfuehrung<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung<TRes> {
  _CopyWithStubImpl_Fragment_IdeeAusfuehrung(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? title,
    Fragment_IdeeAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    Fragment_IdeeAusfuehrung_prozessVersion? prozessVersion,
  }) => _res;

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get title =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> get bilder =>
      CopyWith_Fragment_IdeeAusfuehrung_bilder.stub(_res);

  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> get prozessVersion =>
      CopyWith_Fragment_IdeeAusfuehrung_prozessVersion.stub(_res);
}

const fragmentDefinitionIdeeAusfuehrung = FragmentDefinitionNode(
  name: NameNode(value: 'IdeeAusfuehrung'),
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
      FieldNode(
        name: NameNode(value: 'prozessVersion'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'prozess'),
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
  ),
);
const documentNodeFragmentIdeeAusfuehrung = DocumentNode(
  definitions: [
    fragmentDefinitionIdeeAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);

extension ClientExtension_Fragment_IdeeAusfuehrung on graphql.GraphQLClient {
  void writeFragment_IdeeAusfuehrung({
    required Fragment_IdeeAusfuehrung data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'IdeeAusfuehrung',
        document: documentNodeFragmentIdeeAusfuehrung,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_IdeeAusfuehrung? readFragment_IdeeAusfuehrung({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'IdeeAusfuehrung',
          document: documentNodeFragmentIdeeAusfuehrung,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_IdeeAusfuehrung.fromJson(result);
  }
}

class Fragment_IdeeAusfuehrung_bilder {
  Fragment_IdeeAusfuehrung_bilder({
    required this.id,
    required this.slotName,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
  });

  factory Fragment_IdeeAusfuehrung_bilder.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    return Fragment_IdeeAusfuehrung_bilder(
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
    if (other is! Fragment_IdeeAusfuehrung_bilder ||
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

extension UtilityExtension_Fragment_IdeeAusfuehrung_bilder
    on Fragment_IdeeAusfuehrung_bilder {
  CopyWith_Fragment_IdeeAusfuehrung_bilder<Fragment_IdeeAusfuehrung_bilder>
  get copyWith => CopyWith_Fragment_IdeeAusfuehrung_bilder(this, (i) => i);
}

abstract class CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> {
  factory CopyWith_Fragment_IdeeAusfuehrung_bilder(
    Fragment_IdeeAusfuehrung_bilder instance,
    TRes Function(Fragment_IdeeAusfuehrung_bilder) then,
  ) = _CopyWithImpl_Fragment_IdeeAusfuehrung_bilder;

  factory CopyWith_Fragment_IdeeAusfuehrung_bilder.stub(TRes res) =
      _CopyWithStubImpl_Fragment_IdeeAusfuehrung_bilder;

  TRes call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_IdeeAusfuehrung_bilder<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> {
  _CopyWithImpl_Fragment_IdeeAusfuehrung_bilder(this._instance, this._then);

  final Fragment_IdeeAusfuehrung_bilder _instance;

  final TRes Function(Fragment_IdeeAusfuehrung_bilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_IdeeAusfuehrung_bilder(
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

class _CopyWithStubImpl_Fragment_IdeeAusfuehrung_bilder<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_bilder<TRes> {
  _CopyWithStubImpl_Fragment_IdeeAusfuehrung_bilder(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  }) => _res;
}

class Fragment_IdeeAusfuehrung_prozessVersion {
  Fragment_IdeeAusfuehrung_prozessVersion({
    required this.prozess,
    this.$__typename = 'ProzessVersion',
  });

  factory Fragment_IdeeAusfuehrung_prozessVersion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$prozess = json['prozess'];
    final l$$__typename = json['__typename'];
    return Fragment_IdeeAusfuehrung_prozessVersion(
      prozess: Fragment_IdeeAusfuehrung_prozessVersion_prozess.fromJson(
        (l$prozess as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_IdeeAusfuehrung_prozessVersion_prozess prozess;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$prozess = prozess;
    _resultData['prozess'] = l$prozess.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$prozess = prozess;
    final l$$__typename = $__typename;
    return Object.hashAll([l$prozess, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_IdeeAusfuehrung_prozessVersion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$prozess = prozess;
    final lOther$prozess = other.prozess;
    if (l$prozess != lOther$prozess) {
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

extension UtilityExtension_Fragment_IdeeAusfuehrung_prozessVersion
    on Fragment_IdeeAusfuehrung_prozessVersion {
  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<
    Fragment_IdeeAusfuehrung_prozessVersion
  >
  get copyWith =>
      CopyWith_Fragment_IdeeAusfuehrung_prozessVersion(this, (i) => i);
}

abstract class CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> {
  factory CopyWith_Fragment_IdeeAusfuehrung_prozessVersion(
    Fragment_IdeeAusfuehrung_prozessVersion instance,
    TRes Function(Fragment_IdeeAusfuehrung_prozessVersion) then,
  ) = _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion;

  factory CopyWith_Fragment_IdeeAusfuehrung_prozessVersion.stub(TRes res) =
      _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion;

  TRes call({
    Fragment_IdeeAusfuehrung_prozessVersion_prozess? prozess,
    String? $__typename,
  });
  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> get prozess;
}

class _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> {
  _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion(
    this._instance,
    this._then,
  );

  final Fragment_IdeeAusfuehrung_prozessVersion _instance;

  final TRes Function(Fragment_IdeeAusfuehrung_prozessVersion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? prozess = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_IdeeAusfuehrung_prozessVersion(
          prozess: prozess == _undefined || prozess == null
              ? _instance.prozess
              : (prozess as Fragment_IdeeAusfuehrung_prozessVersion_prozess),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_prozessVersion<TRes> {
  _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion(this._res);

  TRes _res;

  call({
    Fragment_IdeeAusfuehrung_prozessVersion_prozess? prozess,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> get prozess =>
      CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess.stub(_res);
}

class Fragment_IdeeAusfuehrung_prozessVersion_prozess {
  Fragment_IdeeAusfuehrung_prozessVersion_prozess({
    required this.name,
    this.$__typename = 'Prozess',
  });

  factory Fragment_IdeeAusfuehrung_prozessVersion_prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment_IdeeAusfuehrung_prozessVersion_prozess(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_IdeeAusfuehrung_prozessVersion_prozess ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_IdeeAusfuehrung_prozessVersion_prozess
    on Fragment_IdeeAusfuehrung_prozessVersion_prozess {
  CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<
    Fragment_IdeeAusfuehrung_prozessVersion_prozess
  >
  get copyWith =>
      CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess(this, (i) => i);
}

abstract class CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> {
  factory CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess(
    Fragment_IdeeAusfuehrung_prozessVersion_prozess instance,
    TRes Function(Fragment_IdeeAusfuehrung_prozessVersion_prozess) then,
  ) = _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess;

  factory CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess;

  TRes call({String? name, String? $__typename});
}

class _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> {
  _CopyWithImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess(
    this._instance,
    this._then,
  );

  final Fragment_IdeeAusfuehrung_prozessVersion_prozess _instance;

  final TRes Function(Fragment_IdeeAusfuehrung_prozessVersion_prozess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_IdeeAusfuehrung_prozessVersion_prozess(
          name: name == _undefined || name == null
              ? _instance.name
              : (name as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes>
    implements CopyWith_Fragment_IdeeAusfuehrung_prozessVersion_prozess<TRes> {
  _CopyWithStubImpl_Fragment_IdeeAusfuehrung_prozessVersion_prozess(this._res);

  TRes _res;

  call({String? name, String? $__typename}) => _res;
}

class Variables_Query_IdeenKarte {
  factory Variables_Query_IdeenKarte({
    required String kommuneId,
    Input_SlotValueFilterInput? filter,
  }) => Variables_Query_IdeenKarte._({
    r'kommuneId': kommuneId,
    if (filter != null) r'filter': filter,
  });

  Variables_Query_IdeenKarte._(this._$data);

  factory Variables_Query_IdeenKarte.fromJson(Map<String, dynamic> data) {
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
    return Variables_Query_IdeenKarte._(result$data);
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

  CopyWith_Variables_Query_IdeenKarte<Variables_Query_IdeenKarte>
  get copyWith => CopyWith_Variables_Query_IdeenKarte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_IdeenKarte ||
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

abstract class CopyWith_Variables_Query_IdeenKarte<TRes> {
  factory CopyWith_Variables_Query_IdeenKarte(
    Variables_Query_IdeenKarte instance,
    TRes Function(Variables_Query_IdeenKarte) then,
  ) = _CopyWithImpl_Variables_Query_IdeenKarte;

  factory CopyWith_Variables_Query_IdeenKarte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_IdeenKarte;

  TRes call({String? kommuneId, Input_SlotValueFilterInput? filter});
}

class _CopyWithImpl_Variables_Query_IdeenKarte<TRes>
    implements CopyWith_Variables_Query_IdeenKarte<TRes> {
  _CopyWithImpl_Variables_Query_IdeenKarte(this._instance, this._then);

  final Variables_Query_IdeenKarte _instance;

  final TRes Function(Variables_Query_IdeenKarte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? filter = _undefined}) =>
      _then(
        Variables_Query_IdeenKarte._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (filter != _undefined)
            'filter': (filter as Input_SlotValueFilterInput?),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_IdeenKarte<TRes>
    implements CopyWith_Variables_Query_IdeenKarte<TRes> {
  _CopyWithStubImpl_Variables_Query_IdeenKarte(this._res);

  TRes _res;

  call({String? kommuneId, Input_SlotValueFilterInput? filter}) => _res;
}

class Query_IdeenKarte {
  Query_IdeenKarte({required this.kommune, this.$__typename = 'Query'});

  factory Query_IdeenKarte.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_IdeenKarte(
      kommune: Query_IdeenKarte_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_IdeenKarte_kommune kommune;

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
    if (other is! Query_IdeenKarte || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_IdeenKarte on Query_IdeenKarte {
  CopyWith_Query_IdeenKarte<Query_IdeenKarte> get copyWith =>
      CopyWith_Query_IdeenKarte(this, (i) => i);
}

abstract class CopyWith_Query_IdeenKarte<TRes> {
  factory CopyWith_Query_IdeenKarte(
    Query_IdeenKarte instance,
    TRes Function(Query_IdeenKarte) then,
  ) = _CopyWithImpl_Query_IdeenKarte;

  factory CopyWith_Query_IdeenKarte.stub(TRes res) =
      _CopyWithStubImpl_Query_IdeenKarte;

  TRes call({Query_IdeenKarte_kommune? kommune, String? $__typename});
  CopyWith_Query_IdeenKarte_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_IdeenKarte<TRes>
    implements CopyWith_Query_IdeenKarte<TRes> {
  _CopyWithImpl_Query_IdeenKarte(this._instance, this._then);

  final Query_IdeenKarte _instance;

  final TRes Function(Query_IdeenKarte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_IdeenKarte(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_IdeenKarte_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_IdeenKarte_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_IdeenKarte_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_IdeenKarte<TRes>
    implements CopyWith_Query_IdeenKarte<TRes> {
  _CopyWithStubImpl_Query_IdeenKarte(this._res);

  TRes _res;

  call({Query_IdeenKarte_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_IdeenKarte_kommune<TRes> get kommune =>
      CopyWith_Query_IdeenKarte_kommune.stub(_res);
}

const documentNodeQueryIdeenKarte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'IdeenKarte'),
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
                  name: NameNode(value: 'ideenAusfuehrungen'),
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
Query_IdeenKarte _parserFn_Query_IdeenKarte(Map<String, dynamic> data) =>
    Query_IdeenKarte.fromJson(data);
typedef OnQueryComplete_Query_IdeenKarte =
    FutureOr<void> Function(Map<String, dynamic>?, Query_IdeenKarte?);

class Options_Query_IdeenKarte extends graphql.QueryOptions<Query_IdeenKarte> {
  Options_Query_IdeenKarte({
    String? operationName,
    required Variables_Query_IdeenKarte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_IdeenKarte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_IdeenKarte? onComplete,
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
                 data == null ? null : _parserFn_Query_IdeenKarte(data),
               ),
         onError: onError,
         document: documentNodeQueryIdeenKarte,
         parserFn: _parserFn_Query_IdeenKarte,
       );

  final OnQueryComplete_Query_IdeenKarte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_IdeenKarte
    extends graphql.WatchQueryOptions<Query_IdeenKarte> {
  WatchOptions_Query_IdeenKarte({
    String? operationName,
    required Variables_Query_IdeenKarte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_IdeenKarte? typedOptimisticResult,
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
         document: documentNodeQueryIdeenKarte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_IdeenKarte,
       );
}

class FetchMoreOptions_Query_IdeenKarte extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_IdeenKarte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_IdeenKarte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryIdeenKarte,
       );
}

extension ClientExtension_Query_IdeenKarte on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_IdeenKarte>> query_IdeenKarte(
    Options_Query_IdeenKarte options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_IdeenKarte> watchQuery_IdeenKarte(
    WatchOptions_Query_IdeenKarte options,
  ) => this.watchQuery(options);

  void writeQuery_IdeenKarte({
    required Query_IdeenKarte data,
    required Variables_Query_IdeenKarte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryIdeenKarte),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_IdeenKarte? readQuery_IdeenKarte({
    required Variables_Query_IdeenKarte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryIdeenKarte),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_IdeenKarte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_IdeenKarte> useQuery_IdeenKarte(
  Options_Query_IdeenKarte options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_IdeenKarte> useWatchQuery_IdeenKarte(
  WatchOptions_Query_IdeenKarte options,
) => graphql_flutter.useWatchQuery(options);

class Query_IdeenKarte_Widget extends graphql_flutter.Query<Query_IdeenKarte> {
  Query_IdeenKarte_Widget({
    widgets.Key? key,
    required Options_Query_IdeenKarte options,
    required graphql_flutter.QueryBuilder<Query_IdeenKarte> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_IdeenKarte_kommune {
  Query_IdeenKarte_kommune({
    required this.ideenAusfuehrungen,
    this.$__typename = 'Kommune',
  });

  factory Query_IdeenKarte_kommune.fromJson(Map<String, dynamic> json) {
    final l$ideenAusfuehrungen = json['ideenAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Query_IdeenKarte_kommune(
      ideenAusfuehrungen: (l$ideenAusfuehrungen as List<dynamic>)
          .map(
            (e) => Query_IdeenKarte_kommune_ideenAusfuehrungen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_IdeenKarte_kommune_ideenAusfuehrungen> ideenAusfuehrungen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ideenAusfuehrungen = ideenAusfuehrungen;
    _resultData['ideenAusfuehrungen'] = l$ideenAusfuehrungen
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ideenAusfuehrungen = ideenAusfuehrungen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$ideenAusfuehrungen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_IdeenKarte_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ideenAusfuehrungen = ideenAusfuehrungen;
    final lOther$ideenAusfuehrungen = other.ideenAusfuehrungen;
    if (l$ideenAusfuehrungen.length != lOther$ideenAusfuehrungen.length) {
      return false;
    }
    for (int i = 0; i < l$ideenAusfuehrungen.length; i++) {
      final l$ideenAusfuehrungen$entry = l$ideenAusfuehrungen[i];
      final lOther$ideenAusfuehrungen$entry = lOther$ideenAusfuehrungen[i];
      if (l$ideenAusfuehrungen$entry != lOther$ideenAusfuehrungen$entry) {
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

extension UtilityExtension_Query_IdeenKarte_kommune
    on Query_IdeenKarte_kommune {
  CopyWith_Query_IdeenKarte_kommune<Query_IdeenKarte_kommune> get copyWith =>
      CopyWith_Query_IdeenKarte_kommune(this, (i) => i);
}

abstract class CopyWith_Query_IdeenKarte_kommune<TRes> {
  factory CopyWith_Query_IdeenKarte_kommune(
    Query_IdeenKarte_kommune instance,
    TRes Function(Query_IdeenKarte_kommune) then,
  ) = _CopyWithImpl_Query_IdeenKarte_kommune;

  factory CopyWith_Query_IdeenKarte_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_IdeenKarte_kommune;

  TRes call({
    List<Query_IdeenKarte_kommune_ideenAusfuehrungen>? ideenAusfuehrungen,
    String? $__typename,
  });
  TRes ideenAusfuehrungen(
    Iterable<Query_IdeenKarte_kommune_ideenAusfuehrungen> Function(
      Iterable<
        CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<
          Query_IdeenKarte_kommune_ideenAusfuehrungen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_IdeenKarte_kommune<TRes>
    implements CopyWith_Query_IdeenKarte_kommune<TRes> {
  _CopyWithImpl_Query_IdeenKarte_kommune(this._instance, this._then);

  final Query_IdeenKarte_kommune _instance;

  final TRes Function(Query_IdeenKarte_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ideenAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_IdeenKarte_kommune(
      ideenAusfuehrungen:
          ideenAusfuehrungen == _undefined || ideenAusfuehrungen == null
          ? _instance.ideenAusfuehrungen
          : (ideenAusfuehrungen
                as List<Query_IdeenKarte_kommune_ideenAusfuehrungen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes ideenAusfuehrungen(
    Iterable<Query_IdeenKarte_kommune_ideenAusfuehrungen> Function(
      Iterable<
        CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<
          Query_IdeenKarte_kommune_ideenAusfuehrungen
        >
      >,
    )
    _fn,
  ) => call(
    ideenAusfuehrungen: _fn(
      _instance.ideenAusfuehrungen.map(
        (e) =>
            CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_IdeenKarte_kommune<TRes>
    implements CopyWith_Query_IdeenKarte_kommune<TRes> {
  _CopyWithStubImpl_Query_IdeenKarte_kommune(this._res);

  TRes _res;

  call({
    List<Query_IdeenKarte_kommune_ideenAusfuehrungen>? ideenAusfuehrungen,
    String? $__typename,
  }) => _res;

  ideenAusfuehrungen(_fn) => _res;
}

class Query_IdeenKarte_kommune_ideenAusfuehrungen {
  Query_IdeenKarte_kommune_ideenAusfuehrungen({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    required this.slotValues,
    required this.status,
  });

  factory Query_IdeenKarte_kommune_ideenAusfuehrungen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$slotValues = json['slotValues'];
    final l$status = json['status'];
    return Query_IdeenKarte_kommune_ideenAusfuehrungen(
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
    if (other is! Query_IdeenKarte_kommune_ideenAusfuehrungen ||
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

extension UtilityExtension_Query_IdeenKarte_kommune_ideenAusfuehrungen
    on Query_IdeenKarte_kommune_ideenAusfuehrungen {
  CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<
    Query_IdeenKarte_kommune_ideenAusfuehrungen
  >
  get copyWith =>
      CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen(this, (i) => i);
}

abstract class CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<TRes> {
  factory CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen(
    Query_IdeenKarte_kommune_ideenAusfuehrungen instance,
    TRes Function(Query_IdeenKarte_kommune_ideenAusfuehrungen) then,
  ) = _CopyWithImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen;

  factory CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen.stub(TRes res) =
      _CopyWithStubImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen;

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

class _CopyWithImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen<TRes>
    implements CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<TRes> {
  _CopyWithImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen(
    this._instance,
    this._then,
  );

  final Query_IdeenKarte_kommune_ideenAusfuehrungen _instance;

  final TRes Function(Query_IdeenKarte_kommune_ideenAusfuehrungen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? slotValues = _undefined,
    Object? status = _undefined,
  }) => _then(
    Query_IdeenKarte_kommune_ideenAusfuehrungen(
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

class _CopyWithStubImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen<TRes>
    implements CopyWith_Query_IdeenKarte_kommune_ideenAusfuehrungen<TRes> {
  _CopyWithStubImpl_Query_IdeenKarte_kommune_ideenAusfuehrungen(this._res);

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

class Variables_Query_Idee {
  factory Variables_Query_Idee({
    required String kommuneId,
    required String ideeId,
  }) => Variables_Query_Idee._({r'kommuneId': kommuneId, r'ideeId': ideeId});

  Variables_Query_Idee._(this._$data);

  factory Variables_Query_Idee.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$ideeId = data['ideeId'];
    result$data['ideeId'] = (l$ideeId as String);
    return Variables_Query_Idee._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get ideeId => (_$data['ideeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$ideeId = ideeId;
    result$data['ideeId'] = l$ideeId;
    return result$data;
  }

  CopyWith_Variables_Query_Idee<Variables_Query_Idee> get copyWith =>
      CopyWith_Variables_Query_Idee(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Idee || runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$ideeId = ideeId;
    final lOther$ideeId = other.ideeId;
    if (l$ideeId != lOther$ideeId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$ideeId = ideeId;
    return Object.hashAll([l$kommuneId, l$ideeId]);
  }
}

abstract class CopyWith_Variables_Query_Idee<TRes> {
  factory CopyWith_Variables_Query_Idee(
    Variables_Query_Idee instance,
    TRes Function(Variables_Query_Idee) then,
  ) = _CopyWithImpl_Variables_Query_Idee;

  factory CopyWith_Variables_Query_Idee.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Idee;

  TRes call({String? kommuneId, String? ideeId});
}

class _CopyWithImpl_Variables_Query_Idee<TRes>
    implements CopyWith_Variables_Query_Idee<TRes> {
  _CopyWithImpl_Variables_Query_Idee(this._instance, this._then);

  final Variables_Query_Idee _instance;

  final TRes Function(Variables_Query_Idee) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? ideeId = _undefined}) =>
      _then(
        Variables_Query_Idee._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (ideeId != _undefined && ideeId != null)
            'ideeId': (ideeId as String),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_Idee<TRes>
    implements CopyWith_Variables_Query_Idee<TRes> {
  _CopyWithStubImpl_Variables_Query_Idee(this._res);

  TRes _res;

  call({String? kommuneId, String? ideeId}) => _res;
}

class Query_Idee {
  Query_Idee({required this.kommune, this.$__typename = 'Query'});

  factory Query_Idee.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Idee(
      kommune: Query_Idee_kommune.fromJson((l$kommune as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Idee_kommune kommune;

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
    if (other is! Query_Idee || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Idee on Query_Idee {
  CopyWith_Query_Idee<Query_Idee> get copyWith =>
      CopyWith_Query_Idee(this, (i) => i);
}

abstract class CopyWith_Query_Idee<TRes> {
  factory CopyWith_Query_Idee(
    Query_Idee instance,
    TRes Function(Query_Idee) then,
  ) = _CopyWithImpl_Query_Idee;

  factory CopyWith_Query_Idee.stub(TRes res) = _CopyWithStubImpl_Query_Idee;

  TRes call({Query_Idee_kommune? kommune, String? $__typename});
  CopyWith_Query_Idee_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Idee<TRes> implements CopyWith_Query_Idee<TRes> {
  _CopyWithImpl_Query_Idee(this._instance, this._then);

  final Query_Idee _instance;

  final TRes Function(Query_Idee) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Idee(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Idee_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Idee_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Idee_kommune(local$kommune, (e) => call(kommune: e));
  }
}

class _CopyWithStubImpl_Query_Idee<TRes> implements CopyWith_Query_Idee<TRes> {
  _CopyWithStubImpl_Query_Idee(this._res);

  TRes _res;

  call({Query_Idee_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_Idee_kommune<TRes> get kommune =>
      CopyWith_Query_Idee_kommune.stub(_res);
}

const documentNodeQueryIdee = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Idee'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'ideeId')),
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
                  name: NameNode(value: 'ideeAusfuehrung'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'id'),
                      value: VariableNode(name: NameNode(value: 'ideeId')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'IdeeAusfuehrung'),
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
                            FragmentSpreadNode(
                              name: NameNode(value: 'HistorieEintrag'),
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
    fragmentDefinitionIdeeAusfuehrung,
    fragmentDefinitionPlainSlotValue,
    fragmentDefinitionHistorieEintrag,
  ],
);
Query_Idee _parserFn_Query_Idee(Map<String, dynamic> data) =>
    Query_Idee.fromJson(data);
typedef OnQueryComplete_Query_Idee =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Idee?);

class Options_Query_Idee extends graphql.QueryOptions<Query_Idee> {
  Options_Query_Idee({
    String? operationName,
    required Variables_Query_Idee variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Idee? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Idee? onComplete,
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
                 data == null ? null : _parserFn_Query_Idee(data),
               ),
         onError: onError,
         document: documentNodeQueryIdee,
         parserFn: _parserFn_Query_Idee,
       );

  final OnQueryComplete_Query_Idee? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Idee extends graphql.WatchQueryOptions<Query_Idee> {
  WatchOptions_Query_Idee({
    String? operationName,
    required Variables_Query_Idee variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Idee? typedOptimisticResult,
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
         document: documentNodeQueryIdee,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Idee,
       );
}

class FetchMoreOptions_Query_Idee extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Idee({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Idee variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryIdee,
       );
}

extension ClientExtension_Query_Idee on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Idee>> query_Idee(
    Options_Query_Idee options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Idee> watchQuery_Idee(
    WatchOptions_Query_Idee options,
  ) => this.watchQuery(options);

  void writeQuery_Idee({
    required Query_Idee data,
    required Variables_Query_Idee variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryIdee),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Idee? readQuery_Idee({
    required Variables_Query_Idee variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryIdee),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Idee.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Idee> useQuery_Idee(
  Options_Query_Idee options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Idee> useWatchQuery_Idee(
  WatchOptions_Query_Idee options,
) => graphql_flutter.useWatchQuery(options);

class Query_Idee_Widget extends graphql_flutter.Query<Query_Idee> {
  Query_Idee_Widget({
    widgets.Key? key,
    required Options_Query_Idee options,
    required graphql_flutter.QueryBuilder<Query_Idee> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Idee_kommune {
  Query_Idee_kommune({
    required this.id,
    this.ideeAusfuehrung,
    this.$__typename = 'Kommune',
  });

  factory Query_Idee_kommune.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$ideeAusfuehrung = json['ideeAusfuehrung'];
    final l$$__typename = json['__typename'];
    return Query_Idee_kommune(
      id: (l$id as String),
      ideeAusfuehrung: l$ideeAusfuehrung == null
          ? null
          : Query_Idee_kommune_ideeAusfuehrung.fromJson(
              (l$ideeAusfuehrung as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query_Idee_kommune_ideeAusfuehrung? ideeAusfuehrung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$ideeAusfuehrung = ideeAusfuehrung;
    _resultData['ideeAusfuehrung'] = l$ideeAusfuehrung?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$ideeAusfuehrung = ideeAusfuehrung;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$ideeAusfuehrung, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Idee_kommune || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$ideeAusfuehrung = ideeAusfuehrung;
    final lOther$ideeAusfuehrung = other.ideeAusfuehrung;
    if (l$ideeAusfuehrung != lOther$ideeAusfuehrung) {
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

extension UtilityExtension_Query_Idee_kommune on Query_Idee_kommune {
  CopyWith_Query_Idee_kommune<Query_Idee_kommune> get copyWith =>
      CopyWith_Query_Idee_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Idee_kommune<TRes> {
  factory CopyWith_Query_Idee_kommune(
    Query_Idee_kommune instance,
    TRes Function(Query_Idee_kommune) then,
  ) = _CopyWithImpl_Query_Idee_kommune;

  factory CopyWith_Query_Idee_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Idee_kommune;

  TRes call({
    String? id,
    Query_Idee_kommune_ideeAusfuehrung? ideeAusfuehrung,
    String? $__typename,
  });
  CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> get ideeAusfuehrung;
}

class _CopyWithImpl_Query_Idee_kommune<TRes>
    implements CopyWith_Query_Idee_kommune<TRes> {
  _CopyWithImpl_Query_Idee_kommune(this._instance, this._then);

  final Query_Idee_kommune _instance;

  final TRes Function(Query_Idee_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? ideeAusfuehrung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Idee_kommune(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      ideeAusfuehrung: ideeAusfuehrung == _undefined
          ? _instance.ideeAusfuehrung
          : (ideeAusfuehrung as Query_Idee_kommune_ideeAusfuehrung?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> get ideeAusfuehrung {
    final local$ideeAusfuehrung = _instance.ideeAusfuehrung;
    return local$ideeAusfuehrung == null
        ? CopyWith_Query_Idee_kommune_ideeAusfuehrung.stub(_then(_instance))
        : CopyWith_Query_Idee_kommune_ideeAusfuehrung(
            local$ideeAusfuehrung,
            (e) => call(ideeAusfuehrung: e),
          );
  }
}

class _CopyWithStubImpl_Query_Idee_kommune<TRes>
    implements CopyWith_Query_Idee_kommune<TRes> {
  _CopyWithStubImpl_Query_Idee_kommune(this._res);

  TRes _res;

  call({
    String? id,
    Query_Idee_kommune_ideeAusfuehrung? ideeAusfuehrung,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> get ideeAusfuehrung =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung.stub(_res);
}

class Query_Idee_kommune_ideeAusfuehrung implements Fragment_IdeeAusfuehrung {
  Query_Idee_kommune_ideeAusfuehrung({
    this.$__typename = 'Ausfuehrung',
    required this.id,
    required this.userId,
    this.adresse,
    this.beschreibung,
    this.title,
    this.bilder,
    required this.status,
    required this.prozessVersion,
    required this.aktuellerNutzerFolgt,
    required this.historie,
  });

  factory Query_Idee_kommune_ideeAusfuehrung.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$userId = json['userId'];
    final l$adresse = json['adresse'];
    final l$beschreibung = json['beschreibung'];
    final l$title = json['title'];
    final l$bilder = json['bilder'];
    final l$status = json['status'];
    final l$prozessVersion = json['prozessVersion'];
    final l$aktuellerNutzerFolgt = json['aktuellerNutzerFolgt'];
    final l$historie = json['historie'];
    return Query_Idee_kommune_ideeAusfuehrung(
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
      title: l$title == null
          ? null
          : Fragment_PlainSlotValue.fromJson((l$title as Map<String, dynamic>)),
      bilder: l$bilder == null
          ? null
          : Query_Idee_kommune_ideeAusfuehrung_bilder.fromJson(
              (l$bilder as Map<String, dynamic>),
            ),
      status: fromJson_Enum_AusfuehrungStatus((l$status as String)),
      prozessVersion:
          Query_Idee_kommune_ideeAusfuehrung_prozessVersion.fromJson(
            (l$prozessVersion as Map<String, dynamic>),
          ),
      aktuellerNutzerFolgt: (l$aktuellerNutzerFolgt as bool),
      historie: (l$historie as List<dynamic>)
          .map(
            (e) =>
                Fragment_HistorieEintrag.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
    );
  }

  final String $__typename;

  final String id;

  final String userId;

  final Fragment_PlainSlotValue? adresse;

  final Fragment_PlainSlotValue? beschreibung;

  final Fragment_PlainSlotValue? title;

  final Query_Idee_kommune_ideeAusfuehrung_bilder? bilder;

  final Enum_AusfuehrungStatus status;

  final Query_Idee_kommune_ideeAusfuehrung_prozessVersion prozessVersion;

  final bool aktuellerNutzerFolgt;

  final List<Fragment_HistorieEintrag> historie;

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
    final l$title = title;
    _resultData['title'] = l$title?.toJson();
    final l$bilder = bilder;
    _resultData['bilder'] = l$bilder?.toJson();
    final l$status = status;
    _resultData['status'] = toJson_Enum_AusfuehrungStatus(l$status);
    final l$prozessVersion = prozessVersion;
    _resultData['prozessVersion'] = l$prozessVersion.toJson();
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
    final l$title = title;
    final l$bilder = bilder;
    final l$status = status;
    final l$prozessVersion = prozessVersion;
    final l$aktuellerNutzerFolgt = aktuellerNutzerFolgt;
    final l$historie = historie;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$userId,
      l$adresse,
      l$beschreibung,
      l$title,
      l$bilder,
      l$status,
      l$prozessVersion,
      l$aktuellerNutzerFolgt,
      Object.hashAll(l$historie.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Idee_kommune_ideeAusfuehrung ||
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
    final l$prozessVersion = prozessVersion;
    final lOther$prozessVersion = other.prozessVersion;
    if (l$prozessVersion != lOther$prozessVersion) {
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

extension UtilityExtension_Query_Idee_kommune_ideeAusfuehrung
    on Query_Idee_kommune_ideeAusfuehrung {
  CopyWith_Query_Idee_kommune_ideeAusfuehrung<
    Query_Idee_kommune_ideeAusfuehrung
  >
  get copyWith => CopyWith_Query_Idee_kommune_ideeAusfuehrung(this, (i) => i);
}

abstract class CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> {
  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung(
    Query_Idee_kommune_ideeAusfuehrung instance,
    TRes Function(Query_Idee_kommune_ideeAusfuehrung) then,
  ) = _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung;

  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung.stub(TRes res) =
      _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung;

  TRes call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? title,
    Query_Idee_kommune_ideeAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion? prozessVersion,
    bool? aktuellerNutzerFolgt,
    List<Fragment_HistorieEintrag>? historie,
  });
  CopyWith_Fragment_PlainSlotValue<TRes> get adresse;
  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung;
  CopyWith_Fragment_PlainSlotValue<TRes> get title;
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> get bilder;
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes>
  get prozessVersion;
  TRes historie(
    Iterable<Fragment_HistorieEintrag> Function(
      Iterable<CopyWith_Fragment_HistorieEintrag<Fragment_HistorieEintrag>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung<TRes>
    implements CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> {
  _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung(this._instance, this._then);

  final Query_Idee_kommune_ideeAusfuehrung _instance;

  final TRes Function(Query_Idee_kommune_ideeAusfuehrung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $__typename = _undefined,
    Object? id = _undefined,
    Object? userId = _undefined,
    Object? adresse = _undefined,
    Object? beschreibung = _undefined,
    Object? title = _undefined,
    Object? bilder = _undefined,
    Object? status = _undefined,
    Object? prozessVersion = _undefined,
    Object? aktuellerNutzerFolgt = _undefined,
    Object? historie = _undefined,
  }) => _then(
    Query_Idee_kommune_ideeAusfuehrung(
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
      title: title == _undefined
          ? _instance.title
          : (title as Fragment_PlainSlotValue?),
      bilder: bilder == _undefined
          ? _instance.bilder
          : (bilder as Query_Idee_kommune_ideeAusfuehrung_bilder?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_AusfuehrungStatus),
      prozessVersion: prozessVersion == _undefined || prozessVersion == null
          ? _instance.prozessVersion
          : (prozessVersion
                as Query_Idee_kommune_ideeAusfuehrung_prozessVersion),
      aktuellerNutzerFolgt:
          aktuellerNutzerFolgt == _undefined || aktuellerNutzerFolgt == null
          ? _instance.aktuellerNutzerFolgt
          : (aktuellerNutzerFolgt as bool),
      historie: historie == _undefined || historie == null
          ? _instance.historie
          : (historie as List<Fragment_HistorieEintrag>),
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

  CopyWith_Fragment_PlainSlotValue<TRes> get title {
    final local$title = _instance.title;
    return local$title == null
        ? CopyWith_Fragment_PlainSlotValue.stub(_then(_instance))
        : CopyWith_Fragment_PlainSlotValue(local$title, (e) => call(title: e));
  }

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> get bilder {
    final local$bilder = _instance.bilder;
    return local$bilder == null
        ? CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder.stub(
            _then(_instance),
          )
        : CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder(
            local$bilder,
            (e) => call(bilder: e),
          );
  }

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes>
  get prozessVersion {
    final local$prozessVersion = _instance.prozessVersion;
    return CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
      local$prozessVersion,
      (e) => call(prozessVersion: e),
    );
  }

  TRes historie(
    Iterable<Fragment_HistorieEintrag> Function(
      Iterable<CopyWith_Fragment_HistorieEintrag<Fragment_HistorieEintrag>>,
    )
    _fn,
  ) => call(
    historie: _fn(
      _instance.historie.map(
        (e) => CopyWith_Fragment_HistorieEintrag(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung<TRes>
    implements CopyWith_Query_Idee_kommune_ideeAusfuehrung<TRes> {
  _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung(this._res);

  TRes _res;

  call({
    String? $__typename,
    String? id,
    String? userId,
    Fragment_PlainSlotValue? adresse,
    Fragment_PlainSlotValue? beschreibung,
    Fragment_PlainSlotValue? title,
    Query_Idee_kommune_ideeAusfuehrung_bilder? bilder,
    Enum_AusfuehrungStatus? status,
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion? prozessVersion,
    bool? aktuellerNutzerFolgt,
    List<Fragment_HistorieEintrag>? historie,
  }) => _res;

  CopyWith_Fragment_PlainSlotValue<TRes> get adresse =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get beschreibung =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Fragment_PlainSlotValue<TRes> get title =>
      CopyWith_Fragment_PlainSlotValue.stub(_res);

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> get bilder =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder.stub(_res);

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes>
  get prozessVersion =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion.stub(_res);

  historie(_fn) => _res;
}

class Query_Idee_kommune_ideeAusfuehrung_bilder
    implements Fragment_IdeeAusfuehrung_bilder {
  Query_Idee_kommune_ideeAusfuehrung_bilder({
    required this.id,
    required this.slotName,
    required this.slotValueCount,
    this.$__typename = 'PlainSlotValue',
  });

  factory Query_Idee_kommune_ideeAusfuehrung_bilder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$slotName = json['slotName'];
    final l$slotValueCount = json['slotValueCount'];
    final l$$__typename = json['__typename'];
    return Query_Idee_kommune_ideeAusfuehrung_bilder(
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
    if (other is! Query_Idee_kommune_ideeAusfuehrung_bilder ||
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

extension UtilityExtension_Query_Idee_kommune_ideeAusfuehrung_bilder
    on Query_Idee_kommune_ideeAusfuehrung_bilder {
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<
    Query_Idee_kommune_ideeAusfuehrung_bilder
  >
  get copyWith =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder(this, (i) => i);
}

abstract class CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> {
  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder(
    Query_Idee_kommune_ideeAusfuehrung_bilder instance,
    TRes Function(Query_Idee_kommune_ideeAusfuehrung_bilder) then,
  ) = _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_bilder;

  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder.stub(TRes res) =
      _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_bilder;

  TRes call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes>
    implements CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> {
  _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_bilder(
    this._instance,
    this._then,
  );

  final Query_Idee_kommune_ideeAusfuehrung_bilder _instance;

  final TRes Function(Query_Idee_kommune_ideeAusfuehrung_bilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? slotName = _undefined,
    Object? slotValueCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Idee_kommune_ideeAusfuehrung_bilder(
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

class _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes>
    implements CopyWith_Query_Idee_kommune_ideeAusfuehrung_bilder<TRes> {
  _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_bilder(this._res);

  TRes _res;

  call({
    String? id,
    String? slotName,
    int? slotValueCount,
    String? $__typename,
  }) => _res;
}

class Query_Idee_kommune_ideeAusfuehrung_prozessVersion
    implements Fragment_IdeeAusfuehrung_prozessVersion {
  Query_Idee_kommune_ideeAusfuehrung_prozessVersion({
    required this.prozess,
    this.$__typename = 'ProzessVersion',
  });

  factory Query_Idee_kommune_ideeAusfuehrung_prozessVersion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$prozess = json['prozess'];
    final l$$__typename = json['__typename'];
    return Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
      prozess:
          Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess.fromJson(
            (l$prozess as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess prozess;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$prozess = prozess;
    _resultData['prozess'] = l$prozess.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$prozess = prozess;
    final l$$__typename = $__typename;
    return Object.hashAll([l$prozess, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Idee_kommune_ideeAusfuehrung_prozessVersion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$prozess = prozess;
    final lOther$prozess = other.prozess;
    if (l$prozess != lOther$prozess) {
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

extension UtilityExtension_Query_Idee_kommune_ideeAusfuehrung_prozessVersion
    on Query_Idee_kommune_ideeAusfuehrung_prozessVersion {
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion
  >
  get copyWith => CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<
  TRes
> {
  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion instance,
    TRes Function(Query_Idee_kommune_ideeAusfuehrung_prozessVersion) then,
  ) = _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion;

  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion;

  TRes call({
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess? prozess,
    String? $__typename,
  });
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<TRes>
  get prozess;
}

class _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes>
    implements
        CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes> {
  _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
    this._instance,
    this._then,
  );

  final Query_Idee_kommune_ideeAusfuehrung_prozessVersion _instance;

  final TRes Function(Query_Idee_kommune_ideeAusfuehrung_prozessVersion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? prozess = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
      prozess: prozess == _undefined || prozess == null
          ? _instance.prozess
          : (prozess
                as Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<TRes>
  get prozess {
    final local$prozess = _instance.prozess;
    return CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
      local$prozess,
      (e) => call(prozess: e),
    );
  }
}

class _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes>
    implements
        CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion<TRes> {
  _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion(
    this._res,
  );

  TRes _res;

  call({
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess? prozess,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<TRes>
  get prozess =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess.stub(
        _res,
      );
}

class Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess
    implements Fragment_IdeeAusfuehrung_prozessVersion_prozess {
  Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess({
    required this.name,
    this.$__typename = 'Prozess',
  });

  factory Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess
    on Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess {
  CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess
  >
  get copyWith =>
      CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
  TRes
> {
  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
    Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess instance,
    TRes Function(Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess)
    then,
  ) = _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess;

  factory CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess;

  TRes call({String? name, String? $__typename});
}

class _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
    this._instance,
    this._then,
  );

  final Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess _instance;

  final TRes Function(Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
          name: name == _undefined || name == null
              ? _instance.name
              : (name as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
  TRes
>
    implements
        CopyWith_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess<
          TRes
        > {
  _CopyWithStubImpl_Query_Idee_kommune_ideeAusfuehrung_prozessVersion_prozess(
    this._res,
  );

  TRes _res;

  call({String? name, String? $__typename}) => _res;
}

class Query_MeineIdeen {
  Query_MeineIdeen({required this.my, this.$__typename = 'Query'});

  factory Query_MeineIdeen.fromJson(Map<String, dynamic> json) {
    final l$my = json['my'];
    final l$$__typename = json['__typename'];
    return Query_MeineIdeen(
      my: Query_MeineIdeen_my.fromJson((l$my as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MeineIdeen_my my;

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
    if (other is! Query_MeineIdeen || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MeineIdeen on Query_MeineIdeen {
  CopyWith_Query_MeineIdeen<Query_MeineIdeen> get copyWith =>
      CopyWith_Query_MeineIdeen(this, (i) => i);
}

abstract class CopyWith_Query_MeineIdeen<TRes> {
  factory CopyWith_Query_MeineIdeen(
    Query_MeineIdeen instance,
    TRes Function(Query_MeineIdeen) then,
  ) = _CopyWithImpl_Query_MeineIdeen;

  factory CopyWith_Query_MeineIdeen.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineIdeen;

  TRes call({Query_MeineIdeen_my? my, String? $__typename});
  CopyWith_Query_MeineIdeen_my<TRes> get my;
}

class _CopyWithImpl_Query_MeineIdeen<TRes>
    implements CopyWith_Query_MeineIdeen<TRes> {
  _CopyWithImpl_Query_MeineIdeen(this._instance, this._then);

  final Query_MeineIdeen _instance;

  final TRes Function(Query_MeineIdeen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? my = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineIdeen(
          my: my == _undefined || my == null
              ? _instance.my
              : (my as Query_MeineIdeen_my),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_MeineIdeen_my<TRes> get my {
    final local$my = _instance.my;
    return CopyWith_Query_MeineIdeen_my(local$my, (e) => call(my: e));
  }
}

class _CopyWithStubImpl_Query_MeineIdeen<TRes>
    implements CopyWith_Query_MeineIdeen<TRes> {
  _CopyWithStubImpl_Query_MeineIdeen(this._res);

  TRes _res;

  call({Query_MeineIdeen_my? my, String? $__typename}) => _res;

  CopyWith_Query_MeineIdeen_my<TRes> get my =>
      CopyWith_Query_MeineIdeen_my.stub(_res);
}

const documentNodeQueryMeineIdeen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MeineIdeen'),
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
                        name: NameNode(value: 'ideen'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'IdeeAusfuehrung'),
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
                        name: NameNode(value: 'gefolgteIdeen'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'IdeeAusfuehrung'),
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
    fragmentDefinitionIdeeAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Query_MeineIdeen _parserFn_Query_MeineIdeen(Map<String, dynamic> data) =>
    Query_MeineIdeen.fromJson(data);
typedef OnQueryComplete_Query_MeineIdeen =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MeineIdeen?);

class Options_Query_MeineIdeen extends graphql.QueryOptions<Query_MeineIdeen> {
  Options_Query_MeineIdeen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MeineIdeen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MeineIdeen? onComplete,
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
                 data == null ? null : _parserFn_Query_MeineIdeen(data),
               ),
         onError: onError,
         document: documentNodeQueryMeineIdeen,
         parserFn: _parserFn_Query_MeineIdeen,
       );

  final OnQueryComplete_Query_MeineIdeen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MeineIdeen
    extends graphql.WatchQueryOptions<Query_MeineIdeen> {
  WatchOptions_Query_MeineIdeen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MeineIdeen? typedOptimisticResult,
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
         document: documentNodeQueryMeineIdeen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MeineIdeen,
       );
}

class FetchMoreOptions_Query_MeineIdeen extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MeineIdeen({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryMeineIdeen);
}

extension ClientExtension_Query_MeineIdeen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MeineIdeen>> query_MeineIdeen([
    Options_Query_MeineIdeen? options,
  ]) async => await this.query(options ?? Options_Query_MeineIdeen());

  graphql.ObservableQuery<Query_MeineIdeen> watchQuery_MeineIdeen([
    WatchOptions_Query_MeineIdeen? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MeineIdeen());

  void writeQuery_MeineIdeen({
    required Query_MeineIdeen data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMeineIdeen),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MeineIdeen? readQuery_MeineIdeen({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMeineIdeen),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MeineIdeen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MeineIdeen> useQuery_MeineIdeen([
  Options_Query_MeineIdeen? options,
]) => graphql_flutter.useQuery(options ?? Options_Query_MeineIdeen());
graphql.ObservableQuery<Query_MeineIdeen> useWatchQuery_MeineIdeen([
  WatchOptions_Query_MeineIdeen? options,
]) => graphql_flutter.useWatchQuery(options ?? WatchOptions_Query_MeineIdeen());

class Query_MeineIdeen_Widget extends graphql_flutter.Query<Query_MeineIdeen> {
  Query_MeineIdeen_Widget({
    widgets.Key? key,
    Options_Query_MeineIdeen? options,
    required graphql_flutter.QueryBuilder<Query_MeineIdeen> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MeineIdeen(),
         builder: builder,
       );
}

class Query_MeineIdeen_my {
  Query_MeineIdeen_my({required this.id, required this.$__typename});

  factory Query_MeineIdeen_my.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Buerger":
        return Query_MeineIdeen_my__Buerger.fromJson(json);

      case "BackofficeUser":
        return Query_MeineIdeen_my__BackofficeUser.fromJson(json);

      case "SystemUser":
        return Query_MeineIdeen_my__SystemUser.fromJson(json);

      default:
        final l$id = json['id'];
        final l$$__typename = json['__typename'];
        return Query_MeineIdeen_my(
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
    if (other is! Query_MeineIdeen_my || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_MeineIdeen_my on Query_MeineIdeen_my {
  CopyWith_Query_MeineIdeen_my<Query_MeineIdeen_my> get copyWith =>
      CopyWith_Query_MeineIdeen_my(this, (i) => i);

  _T when<_T>({
    required _T Function(Query_MeineIdeen_my__Buerger) buerger,
    required _T Function(Query_MeineIdeen_my__BackofficeUser) backofficeUser,
    required _T Function(Query_MeineIdeen_my__SystemUser) systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        return buerger(this as Query_MeineIdeen_my__Buerger);

      case "BackofficeUser":
        return backofficeUser(this as Query_MeineIdeen_my__BackofficeUser);

      case "SystemUser":
        return systemUser(this as Query_MeineIdeen_my__SystemUser);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query_MeineIdeen_my__Buerger)? buerger,
    _T Function(Query_MeineIdeen_my__BackofficeUser)? backofficeUser,
    _T Function(Query_MeineIdeen_my__SystemUser)? systemUser,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Buerger":
        if (buerger != null) {
          return buerger(this as Query_MeineIdeen_my__Buerger);
        } else {
          return orElse();
        }

      case "BackofficeUser":
        if (backofficeUser != null) {
          return backofficeUser(this as Query_MeineIdeen_my__BackofficeUser);
        } else {
          return orElse();
        }

      case "SystemUser":
        if (systemUser != null) {
          return systemUser(this as Query_MeineIdeen_my__SystemUser);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Query_MeineIdeen_my<TRes> {
  factory CopyWith_Query_MeineIdeen_my(
    Query_MeineIdeen_my instance,
    TRes Function(Query_MeineIdeen_my) then,
  ) = _CopyWithImpl_Query_MeineIdeen_my;

  factory CopyWith_Query_MeineIdeen_my.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineIdeen_my;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineIdeen_my<TRes>
    implements CopyWith_Query_MeineIdeen_my<TRes> {
  _CopyWithImpl_Query_MeineIdeen_my(this._instance, this._then);

  final Query_MeineIdeen_my _instance;

  final TRes Function(Query_MeineIdeen_my) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineIdeen_my(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineIdeen_my<TRes>
    implements CopyWith_Query_MeineIdeen_my<TRes> {
  _CopyWithStubImpl_Query_MeineIdeen_my(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MeineIdeen_my__Buerger implements Query_MeineIdeen_my {
  Query_MeineIdeen_my__Buerger({
    required this.ideen,
    required this.gefolgteIdeen,
    this.$__typename = 'Buerger',
    required this.id,
  });

  factory Query_MeineIdeen_my__Buerger.fromJson(Map<String, dynamic> json) {
    final l$ideen = json['ideen'];
    final l$gefolgteIdeen = json['gefolgteIdeen'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query_MeineIdeen_my__Buerger(
      ideen: (l$ideen as List<dynamic>)
          .map(
            (e) =>
                Fragment_IdeeAusfuehrung.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      gefolgteIdeen: (l$gefolgteIdeen as List<dynamic>)
          .map(
            (e) =>
                Fragment_IdeeAusfuehrung.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final List<Fragment_IdeeAusfuehrung> ideen;

  final List<Fragment_IdeeAusfuehrung> gefolgteIdeen;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ideen = ideen;
    _resultData['ideen'] = l$ideen.map((e) => e.toJson()).toList();
    final l$gefolgteIdeen = gefolgteIdeen;
    _resultData['gefolgteIdeen'] = l$gefolgteIdeen
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
    final l$ideen = ideen;
    final l$gefolgteIdeen = gefolgteIdeen;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      Object.hashAll(l$ideen.map((v) => v)),
      Object.hashAll(l$gefolgteIdeen.map((v) => v)),
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MeineIdeen_my__Buerger ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ideen = ideen;
    final lOther$ideen = other.ideen;
    if (l$ideen.length != lOther$ideen.length) {
      return false;
    }
    for (int i = 0; i < l$ideen.length; i++) {
      final l$ideen$entry = l$ideen[i];
      final lOther$ideen$entry = lOther$ideen[i];
      if (l$ideen$entry != lOther$ideen$entry) {
        return false;
      }
    }
    final l$gefolgteIdeen = gefolgteIdeen;
    final lOther$gefolgteIdeen = other.gefolgteIdeen;
    if (l$gefolgteIdeen.length != lOther$gefolgteIdeen.length) {
      return false;
    }
    for (int i = 0; i < l$gefolgteIdeen.length; i++) {
      final l$gefolgteIdeen$entry = l$gefolgteIdeen[i];
      final lOther$gefolgteIdeen$entry = lOther$gefolgteIdeen[i];
      if (l$gefolgteIdeen$entry != lOther$gefolgteIdeen$entry) {
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

extension UtilityExtension_Query_MeineIdeen_my__Buerger
    on Query_MeineIdeen_my__Buerger {
  CopyWith_Query_MeineIdeen_my__Buerger<Query_MeineIdeen_my__Buerger>
  get copyWith => CopyWith_Query_MeineIdeen_my__Buerger(this, (i) => i);
}

abstract class CopyWith_Query_MeineIdeen_my__Buerger<TRes> {
  factory CopyWith_Query_MeineIdeen_my__Buerger(
    Query_MeineIdeen_my__Buerger instance,
    TRes Function(Query_MeineIdeen_my__Buerger) then,
  ) = _CopyWithImpl_Query_MeineIdeen_my__Buerger;

  factory CopyWith_Query_MeineIdeen_my__Buerger.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineIdeen_my__Buerger;

  TRes call({
    List<Fragment_IdeeAusfuehrung>? ideen,
    List<Fragment_IdeeAusfuehrung>? gefolgteIdeen,
    String? $__typename,
    String? id,
  });
  TRes ideen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  );
  TRes gefolgteIdeen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_MeineIdeen_my__Buerger<TRes>
    implements CopyWith_Query_MeineIdeen_my__Buerger<TRes> {
  _CopyWithImpl_Query_MeineIdeen_my__Buerger(this._instance, this._then);

  final Query_MeineIdeen_my__Buerger _instance;

  final TRes Function(Query_MeineIdeen_my__Buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ideen = _undefined,
    Object? gefolgteIdeen = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) => _then(
    Query_MeineIdeen_my__Buerger(
      ideen: ideen == _undefined || ideen == null
          ? _instance.ideen
          : (ideen as List<Fragment_IdeeAusfuehrung>),
      gefolgteIdeen: gefolgteIdeen == _undefined || gefolgteIdeen == null
          ? _instance.gefolgteIdeen
          : (gefolgteIdeen as List<Fragment_IdeeAusfuehrung>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
    ),
  );

  TRes ideen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  ) => call(
    ideen: _fn(
      _instance.ideen.map(
        (e) => CopyWith_Fragment_IdeeAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );

  TRes gefolgteIdeen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  ) => call(
    gefolgteIdeen: _fn(
      _instance.gefolgteIdeen.map(
        (e) => CopyWith_Fragment_IdeeAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_MeineIdeen_my__Buerger<TRes>
    implements CopyWith_Query_MeineIdeen_my__Buerger<TRes> {
  _CopyWithStubImpl_Query_MeineIdeen_my__Buerger(this._res);

  TRes _res;

  call({
    List<Fragment_IdeeAusfuehrung>? ideen,
    List<Fragment_IdeeAusfuehrung>? gefolgteIdeen,
    String? $__typename,
    String? id,
  }) => _res;

  ideen(_fn) => _res;

  gefolgteIdeen(_fn) => _res;
}

class Query_MeineIdeen_my__BackofficeUser implements Query_MeineIdeen_my {
  Query_MeineIdeen_my__BackofficeUser({
    required this.id,
    this.$__typename = 'BackofficeUser',
  });

  factory Query_MeineIdeen_my__BackofficeUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MeineIdeen_my__BackofficeUser(
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
    if (other is! Query_MeineIdeen_my__BackofficeUser ||
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

extension UtilityExtension_Query_MeineIdeen_my__BackofficeUser
    on Query_MeineIdeen_my__BackofficeUser {
  CopyWith_Query_MeineIdeen_my__BackofficeUser<
    Query_MeineIdeen_my__BackofficeUser
  >
  get copyWith => CopyWith_Query_MeineIdeen_my__BackofficeUser(this, (i) => i);
}

abstract class CopyWith_Query_MeineIdeen_my__BackofficeUser<TRes> {
  factory CopyWith_Query_MeineIdeen_my__BackofficeUser(
    Query_MeineIdeen_my__BackofficeUser instance,
    TRes Function(Query_MeineIdeen_my__BackofficeUser) then,
  ) = _CopyWithImpl_Query_MeineIdeen_my__BackofficeUser;

  factory CopyWith_Query_MeineIdeen_my__BackofficeUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineIdeen_my__BackofficeUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineIdeen_my__BackofficeUser<TRes>
    implements CopyWith_Query_MeineIdeen_my__BackofficeUser<TRes> {
  _CopyWithImpl_Query_MeineIdeen_my__BackofficeUser(this._instance, this._then);

  final Query_MeineIdeen_my__BackofficeUser _instance;

  final TRes Function(Query_MeineIdeen_my__BackofficeUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineIdeen_my__BackofficeUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineIdeen_my__BackofficeUser<TRes>
    implements CopyWith_Query_MeineIdeen_my__BackofficeUser<TRes> {
  _CopyWithStubImpl_Query_MeineIdeen_my__BackofficeUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query_MeineIdeen_my__SystemUser implements Query_MeineIdeen_my {
  Query_MeineIdeen_my__SystemUser({
    required this.id,
    this.$__typename = 'SystemUser',
  });

  factory Query_MeineIdeen_my__SystemUser.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query_MeineIdeen_my__SystemUser(
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
    if (other is! Query_MeineIdeen_my__SystemUser ||
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

extension UtilityExtension_Query_MeineIdeen_my__SystemUser
    on Query_MeineIdeen_my__SystemUser {
  CopyWith_Query_MeineIdeen_my__SystemUser<Query_MeineIdeen_my__SystemUser>
  get copyWith => CopyWith_Query_MeineIdeen_my__SystemUser(this, (i) => i);
}

abstract class CopyWith_Query_MeineIdeen_my__SystemUser<TRes> {
  factory CopyWith_Query_MeineIdeen_my__SystemUser(
    Query_MeineIdeen_my__SystemUser instance,
    TRes Function(Query_MeineIdeen_my__SystemUser) then,
  ) = _CopyWithImpl_Query_MeineIdeen_my__SystemUser;

  factory CopyWith_Query_MeineIdeen_my__SystemUser.stub(TRes res) =
      _CopyWithStubImpl_Query_MeineIdeen_my__SystemUser;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Query_MeineIdeen_my__SystemUser<TRes>
    implements CopyWith_Query_MeineIdeen_my__SystemUser<TRes> {
  _CopyWithImpl_Query_MeineIdeen_my__SystemUser(this._instance, this._then);

  final Query_MeineIdeen_my__SystemUser _instance;

  final TRes Function(Query_MeineIdeen_my__SystemUser) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_MeineIdeen_my__SystemUser(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_MeineIdeen_my__SystemUser<TRes>
    implements CopyWith_Query_MeineIdeen_my__SystemUser<TRes> {
  _CopyWithStubImpl_Query_MeineIdeen_my__SystemUser(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables_Mutation_IdeeFolgen {
  factory Variables_Mutation_IdeeFolgen({
    required Input_AusfuehrungFolgenInput input,
  }) => Variables_Mutation_IdeeFolgen._({r'input': input});

  Variables_Mutation_IdeeFolgen._(this._$data);

  factory Variables_Mutation_IdeeFolgen.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_AusfuehrungFolgenInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_IdeeFolgen._(result$data);
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

  CopyWith_Variables_Mutation_IdeeFolgen<Variables_Mutation_IdeeFolgen>
  get copyWith => CopyWith_Variables_Mutation_IdeeFolgen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_IdeeFolgen ||
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

abstract class CopyWith_Variables_Mutation_IdeeFolgen<TRes> {
  factory CopyWith_Variables_Mutation_IdeeFolgen(
    Variables_Mutation_IdeeFolgen instance,
    TRes Function(Variables_Mutation_IdeeFolgen) then,
  ) = _CopyWithImpl_Variables_Mutation_IdeeFolgen;

  factory CopyWith_Variables_Mutation_IdeeFolgen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_IdeeFolgen;

  TRes call({Input_AusfuehrungFolgenInput? input});
}

class _CopyWithImpl_Variables_Mutation_IdeeFolgen<TRes>
    implements CopyWith_Variables_Mutation_IdeeFolgen<TRes> {
  _CopyWithImpl_Variables_Mutation_IdeeFolgen(this._instance, this._then);

  final Variables_Mutation_IdeeFolgen _instance;

  final TRes Function(Variables_Mutation_IdeeFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_IdeeFolgen._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_AusfuehrungFolgenInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_IdeeFolgen<TRes>
    implements CopyWith_Variables_Mutation_IdeeFolgen<TRes> {
  _CopyWithStubImpl_Variables_Mutation_IdeeFolgen(this._res);

  TRes _res;

  call({Input_AusfuehrungFolgenInput? input}) => _res;
}

class Mutation_IdeeFolgen {
  Mutation_IdeeFolgen({
    required this.ausfuehrungFolgen,
    this.$__typename = 'Mutation',
  });

  factory Mutation_IdeeFolgen.fromJson(Map<String, dynamic> json) {
    final l$ausfuehrungFolgen = json['ausfuehrungFolgen'];
    final l$$__typename = json['__typename'];
    return Mutation_IdeeFolgen(
      ausfuehrungFolgen: Mutation_IdeeFolgen_ausfuehrungFolgen.fromJson(
        (l$ausfuehrungFolgen as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_IdeeFolgen_ausfuehrungFolgen ausfuehrungFolgen;

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
    if (other is! Mutation_IdeeFolgen || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Mutation_IdeeFolgen on Mutation_IdeeFolgen {
  CopyWith_Mutation_IdeeFolgen<Mutation_IdeeFolgen> get copyWith =>
      CopyWith_Mutation_IdeeFolgen(this, (i) => i);
}

abstract class CopyWith_Mutation_IdeeFolgen<TRes> {
  factory CopyWith_Mutation_IdeeFolgen(
    Mutation_IdeeFolgen instance,
    TRes Function(Mutation_IdeeFolgen) then,
  ) = _CopyWithImpl_Mutation_IdeeFolgen;

  factory CopyWith_Mutation_IdeeFolgen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_IdeeFolgen;

  TRes call({
    Mutation_IdeeFolgen_ausfuehrungFolgen? ausfuehrungFolgen,
    String? $__typename,
  });
  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> get ausfuehrungFolgen;
}

class _CopyWithImpl_Mutation_IdeeFolgen<TRes>
    implements CopyWith_Mutation_IdeeFolgen<TRes> {
  _CopyWithImpl_Mutation_IdeeFolgen(this._instance, this._then);

  final Mutation_IdeeFolgen _instance;

  final TRes Function(Mutation_IdeeFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ausfuehrungFolgen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_IdeeFolgen(
      ausfuehrungFolgen:
          ausfuehrungFolgen == _undefined || ausfuehrungFolgen == null
          ? _instance.ausfuehrungFolgen
          : (ausfuehrungFolgen as Mutation_IdeeFolgen_ausfuehrungFolgen),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> get ausfuehrungFolgen {
    final local$ausfuehrungFolgen = _instance.ausfuehrungFolgen;
    return CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen(
      local$ausfuehrungFolgen,
      (e) => call(ausfuehrungFolgen: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_IdeeFolgen<TRes>
    implements CopyWith_Mutation_IdeeFolgen<TRes> {
  _CopyWithStubImpl_Mutation_IdeeFolgen(this._res);

  TRes _res;

  call({
    Mutation_IdeeFolgen_ausfuehrungFolgen? ausfuehrungFolgen,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> get ausfuehrungFolgen =>
      CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen.stub(_res);
}

const documentNodeMutationIdeeFolgen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'IdeeFolgen'),
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
                              name: NameNode(value: 'IdeeAusfuehrung'),
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
    fragmentDefinitionIdeeAusfuehrung,
    fragmentDefinitionPlainSlotValue,
  ],
);
Mutation_IdeeFolgen _parserFn_Mutation_IdeeFolgen(Map<String, dynamic> data) =>
    Mutation_IdeeFolgen.fromJson(data);
typedef OnMutationCompleted_Mutation_IdeeFolgen =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation_IdeeFolgen?);

class Options_Mutation_IdeeFolgen
    extends graphql.MutationOptions<Mutation_IdeeFolgen> {
  Options_Mutation_IdeeFolgen({
    String? operationName,
    required Variables_Mutation_IdeeFolgen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_IdeeFolgen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_IdeeFolgen? onCompleted,
    graphql.OnMutationUpdate<Mutation_IdeeFolgen>? update,
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
                 data == null ? null : _parserFn_Mutation_IdeeFolgen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationIdeeFolgen,
         parserFn: _parserFn_Mutation_IdeeFolgen,
       );

  final OnMutationCompleted_Mutation_IdeeFolgen? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_IdeeFolgen
    extends graphql.WatchQueryOptions<Mutation_IdeeFolgen> {
  WatchOptions_Mutation_IdeeFolgen({
    String? operationName,
    required Variables_Mutation_IdeeFolgen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_IdeeFolgen? typedOptimisticResult,
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
         document: documentNodeMutationIdeeFolgen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_IdeeFolgen,
       );
}

extension ClientExtension_Mutation_IdeeFolgen on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_IdeeFolgen>> mutate_IdeeFolgen(
    Options_Mutation_IdeeFolgen options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_IdeeFolgen> watchMutation_IdeeFolgen(
    WatchOptions_Mutation_IdeeFolgen options,
  ) => this.watchMutation(options);
}

class Mutation_IdeeFolgen_HookResult {
  Mutation_IdeeFolgen_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_IdeeFolgen runMutation;

  final graphql.QueryResult<Mutation_IdeeFolgen> result;
}

Mutation_IdeeFolgen_HookResult useMutation_IdeeFolgen([
  WidgetOptions_Mutation_IdeeFolgen? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_IdeeFolgen(),
  );
  return Mutation_IdeeFolgen_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_IdeeFolgen> useWatchMutation_IdeeFolgen(
  WatchOptions_Mutation_IdeeFolgen options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_IdeeFolgen
    extends graphql.MutationOptions<Mutation_IdeeFolgen> {
  WidgetOptions_Mutation_IdeeFolgen({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_IdeeFolgen? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_IdeeFolgen? onCompleted,
    graphql.OnMutationUpdate<Mutation_IdeeFolgen>? update,
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
                 data == null ? null : _parserFn_Mutation_IdeeFolgen(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationIdeeFolgen,
         parserFn: _parserFn_Mutation_IdeeFolgen,
       );

  final OnMutationCompleted_Mutation_IdeeFolgen? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_IdeeFolgen =
    graphql.MultiSourceResult<Mutation_IdeeFolgen> Function(
      Variables_Mutation_IdeeFolgen, {
      Object? optimisticResult,
      Mutation_IdeeFolgen? typedOptimisticResult,
    });
typedef Builder_Mutation_IdeeFolgen =
    widgets.Widget Function(
      RunMutation_Mutation_IdeeFolgen,
      graphql.QueryResult<Mutation_IdeeFolgen>?,
    );

class Mutation_IdeeFolgen_Widget
    extends graphql_flutter.Mutation<Mutation_IdeeFolgen> {
  Mutation_IdeeFolgen_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_IdeeFolgen? options,
    required Builder_Mutation_IdeeFolgen builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_IdeeFolgen(),
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

class Mutation_IdeeFolgen_ausfuehrungFolgen {
  Mutation_IdeeFolgen_ausfuehrungFolgen({
    this.buerger,
    this.$__typename = 'AusfuehrungFolgenPayload',
  });

  factory Mutation_IdeeFolgen_ausfuehrungFolgen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$buerger = json['buerger'];
    final l$$__typename = json['__typename'];
    return Mutation_IdeeFolgen_ausfuehrungFolgen(
      buerger: l$buerger == null
          ? null
          : Mutation_IdeeFolgen_ausfuehrungFolgen_buerger.fromJson(
              (l$buerger as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_IdeeFolgen_ausfuehrungFolgen_buerger? buerger;

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
    if (other is! Mutation_IdeeFolgen_ausfuehrungFolgen ||
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

extension UtilityExtension_Mutation_IdeeFolgen_ausfuehrungFolgen
    on Mutation_IdeeFolgen_ausfuehrungFolgen {
  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<
    Mutation_IdeeFolgen_ausfuehrungFolgen
  >
  get copyWith =>
      CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen(this, (i) => i);
}

abstract class CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> {
  factory CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen(
    Mutation_IdeeFolgen_ausfuehrungFolgen instance,
    TRes Function(Mutation_IdeeFolgen_ausfuehrungFolgen) then,
  ) = _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen;

  factory CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen.stub(TRes res) =
      _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen;

  TRes call({
    Mutation_IdeeFolgen_ausfuehrungFolgen_buerger? buerger,
    String? $__typename,
  });
  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> get buerger;
}

class _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes>
    implements CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> {
  _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen(
    this._instance,
    this._then,
  );

  final Mutation_IdeeFolgen_ausfuehrungFolgen _instance;

  final TRes Function(Mutation_IdeeFolgen_ausfuehrungFolgen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? buerger = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation_IdeeFolgen_ausfuehrungFolgen(
          buerger: buerger == _undefined
              ? _instance.buerger
              : (buerger as Mutation_IdeeFolgen_ausfuehrungFolgen_buerger?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> get buerger {
    final local$buerger = _instance.buerger;
    return local$buerger == null
        ? CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(
            local$buerger,
            (e) => call(buerger: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes>
    implements CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen<TRes> {
  _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen(this._res);

  TRes _res;

  call({
    Mutation_IdeeFolgen_ausfuehrungFolgen_buerger? buerger,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> get buerger =>
      CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger.stub(_res);
}

class Mutation_IdeeFolgen_ausfuehrungFolgen_buerger {
  Mutation_IdeeFolgen_ausfuehrungFolgen_buerger({
    required this.id,
    required this.gefolgteAusfuehrungen,
    this.$__typename = 'Buerger',
  });

  factory Mutation_IdeeFolgen_ausfuehrungFolgen_buerger.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$gefolgteAusfuehrungen = json['gefolgteAusfuehrungen'];
    final l$$__typename = json['__typename'];
    return Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(
      id: (l$id as String),
      gefolgteAusfuehrungen: (l$gefolgteAusfuehrungen as List<dynamic>)
          .map(
            (e) =>
                Fragment_IdeeAusfuehrung.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment_IdeeAusfuehrung> gefolgteAusfuehrungen;

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
    if (other is! Mutation_IdeeFolgen_ausfuehrungFolgen_buerger ||
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

extension UtilityExtension_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger
    on Mutation_IdeeFolgen_ausfuehrungFolgen_buerger {
  CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<
    Mutation_IdeeFolgen_ausfuehrungFolgen_buerger
  >
  get copyWith =>
      CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(this, (i) => i);
}

abstract class CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> {
  factory CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(
    Mutation_IdeeFolgen_ausfuehrungFolgen_buerger instance,
    TRes Function(Mutation_IdeeFolgen_ausfuehrungFolgen_buerger) then,
  ) = _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger;

  factory CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger;

  TRes call({
    String? id,
    List<Fragment_IdeeAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
  });
  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes>
    implements CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> {
  _CopyWithImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(
    this._instance,
    this._then,
  );

  final Mutation_IdeeFolgen_ausfuehrungFolgen_buerger _instance;

  final TRes Function(Mutation_IdeeFolgen_ausfuehrungFolgen_buerger) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? gefolgteAusfuehrungen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      gefolgteAusfuehrungen:
          gefolgteAusfuehrungen == _undefined || gefolgteAusfuehrungen == null
          ? _instance.gefolgteAusfuehrungen
          : (gefolgteAusfuehrungen as List<Fragment_IdeeAusfuehrung>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes gefolgteAusfuehrungen(
    Iterable<Fragment_IdeeAusfuehrung> Function(
      Iterable<CopyWith_Fragment_IdeeAusfuehrung<Fragment_IdeeAusfuehrung>>,
    )
    _fn,
  ) => call(
    gefolgteAusfuehrungen: _fn(
      _instance.gefolgteAusfuehrungen.map(
        (e) => CopyWith_Fragment_IdeeAusfuehrung(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes>
    implements CopyWith_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger<TRes> {
  _CopyWithStubImpl_Mutation_IdeeFolgen_ausfuehrungFolgen_buerger(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment_IdeeAusfuehrung>? gefolgteAusfuehrungen,
    String? $__typename,
  }) => _res;

  gefolgteAusfuehrungen(_fn) => _res;
}
