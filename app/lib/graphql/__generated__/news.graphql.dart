import 'blocks.graphql.dart';
import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_NewsArtikelInfo {
  Fragment_NewsArtikelInfo({
    required this.id,
    this.titel,
    this.teaser,
    this.datum,
    this.ordinal,
    this.untereinheit,
    this.titelbilder,
    this.$__typename = 'NewsArtikel',
  });

  factory Fragment_NewsArtikelInfo.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$teaser = json['teaser'];
    final l$datum = json['datum'];
    final l$ordinal = json['ordinal'];
    final l$untereinheit = json['untereinheit'];
    final l$titelbilder = json['titelbilder'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikelInfo(
      id: (l$id as String),
      titel: (l$titel as String?),
      teaser: (l$teaser as String?),
      datum: l$datum == null ? null : DateTime.parse((l$datum as String)),
      ordinal: (l$ordinal as num?)?.toDouble(),
      untereinheit: l$untereinheit == null
          ? null
          : Fragment_NewsArtikelInfo_untereinheit.fromJson(
              (l$untereinheit as Map<String, dynamic>),
            ),
      titelbilder: (l$titelbilder as List<dynamic>?)
          ?.map(
            (e) => Fragment_NewsArtikelInfo_titelbilder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? titel;

  final String? teaser;

  final DateTime? datum;

  final double? ordinal;

  final Fragment_NewsArtikelInfo_untereinheit? untereinheit;

  final List<Fragment_NewsArtikelInfo_titelbilder>? titelbilder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$datum = datum;
    _resultData['datum'] = l$datum?.toIso8601String();
    final l$ordinal = ordinal;
    _resultData['ordinal'] = l$ordinal;
    final l$untereinheit = untereinheit;
    _resultData['untereinheit'] = l$untereinheit?.toJson();
    final l$titelbilder = titelbilder;
    _resultData['titelbilder'] = l$titelbilder?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$teaser = teaser;
    final l$datum = datum;
    final l$ordinal = ordinal;
    final l$untereinheit = untereinheit;
    final l$titelbilder = titelbilder;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$titel,
      l$teaser,
      l$datum,
      l$ordinal,
      l$untereinheit,
      l$titelbilder == null
          ? null
          : Object.hashAll(l$titelbilder.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_NewsArtikelInfo ||
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
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$datum = datum;
    final lOther$datum = other.datum;
    if (l$datum != lOther$datum) {
      return false;
    }
    final l$ordinal = ordinal;
    final lOther$ordinal = other.ordinal;
    if (l$ordinal != lOther$ordinal) {
      return false;
    }
    final l$untereinheit = untereinheit;
    final lOther$untereinheit = other.untereinheit;
    if (l$untereinheit != lOther$untereinheit) {
      return false;
    }
    final l$titelbilder = titelbilder;
    final lOther$titelbilder = other.titelbilder;
    if (l$titelbilder != null && lOther$titelbilder != null) {
      if (l$titelbilder.length != lOther$titelbilder.length) {
        return false;
      }
      for (int i = 0; i < l$titelbilder.length; i++) {
        final l$titelbilder$entry = l$titelbilder[i];
        final lOther$titelbilder$entry = lOther$titelbilder[i];
        if (l$titelbilder$entry != lOther$titelbilder$entry) {
          return false;
        }
      }
    } else if (l$titelbilder != lOther$titelbilder) {
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

extension UtilityExtension_Fragment_NewsArtikelInfo
    on Fragment_NewsArtikelInfo {
  CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo> get copyWith =>
      CopyWith_Fragment_NewsArtikelInfo(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikelInfo<TRes> {
  factory CopyWith_Fragment_NewsArtikelInfo(
    Fragment_NewsArtikelInfo instance,
    TRes Function(Fragment_NewsArtikelInfo) then,
  ) = _CopyWithImpl_Fragment_NewsArtikelInfo;

  factory CopyWith_Fragment_NewsArtikelInfo.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikelInfo;

  TRes call({
    String? id,
    String? titel,
    String? teaser,
    DateTime? datum,
    double? ordinal,
    Fragment_NewsArtikelInfo_untereinheit? untereinheit,
    List<Fragment_NewsArtikelInfo_titelbilder>? titelbilder,
    String? $__typename,
  });
  CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> get untereinheit;
  TRes titelbilder(
    Iterable<Fragment_NewsArtikelInfo_titelbilder>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikelInfo_titelbilder<
          Fragment_NewsArtikelInfo_titelbilder
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_NewsArtikelInfo<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo<TRes> {
  _CopyWithImpl_Fragment_NewsArtikelInfo(this._instance, this._then);

  final Fragment_NewsArtikelInfo _instance;

  final TRes Function(Fragment_NewsArtikelInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? teaser = _undefined,
    Object? datum = _undefined,
    Object? ordinal = _undefined,
    Object? untereinheit = _undefined,
    Object? titelbilder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikelInfo(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      datum: datum == _undefined ? _instance.datum : (datum as DateTime?),
      ordinal: ordinal == _undefined ? _instance.ordinal : (ordinal as double?),
      untereinheit: untereinheit == _undefined
          ? _instance.untereinheit
          : (untereinheit as Fragment_NewsArtikelInfo_untereinheit?),
      titelbilder: titelbilder == _undefined
          ? _instance.titelbilder
          : (titelbilder as List<Fragment_NewsArtikelInfo_titelbilder>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> get untereinheit {
    final local$untereinheit = _instance.untereinheit;
    return local$untereinheit == null
        ? CopyWith_Fragment_NewsArtikelInfo_untereinheit.stub(_then(_instance))
        : CopyWith_Fragment_NewsArtikelInfo_untereinheit(
            local$untereinheit,
            (e) => call(untereinheit: e),
          );
  }

  TRes titelbilder(
    Iterable<Fragment_NewsArtikelInfo_titelbilder>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikelInfo_titelbilder<
          Fragment_NewsArtikelInfo_titelbilder
        >
      >?,
    )
    _fn,
  ) => call(
    titelbilder: _fn(
      _instance.titelbilder?.map(
        (e) => CopyWith_Fragment_NewsArtikelInfo_titelbilder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_NewsArtikelInfo<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikelInfo(this._res);

  TRes _res;

  call({
    String? id,
    String? titel,
    String? teaser,
    DateTime? datum,
    double? ordinal,
    Fragment_NewsArtikelInfo_untereinheit? untereinheit,
    List<Fragment_NewsArtikelInfo_titelbilder>? titelbilder,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> get untereinheit =>
      CopyWith_Fragment_NewsArtikelInfo_untereinheit.stub(_res);

  titelbilder(_fn) => _res;
}

const fragmentDefinitionNewsArtikelInfo = FragmentDefinitionNode(
  name: NameNode(value: 'NewsArtikelInfo'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'NewsArtikel'), isNonNull: false),
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
        name: NameNode(value: 'titel'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'teaser'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'datum'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'ordinal'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'untereinheit'),
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
        name: NameNode(value: 'titelbilder'),
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
              name: NameNode(value: 'bildunterschrift'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'bild'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'VeranstaltungsmedienImage'),
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
const documentNodeFragmentNewsArtikelInfo = DocumentNode(
  definitions: [
    fragmentDefinitionNewsArtikelInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
  ],
);

extension ClientExtension_Fragment_NewsArtikelInfo on graphql.GraphQLClient {
  void writeFragment_NewsArtikelInfo({
    required Fragment_NewsArtikelInfo data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'NewsArtikelInfo',
        document: documentNodeFragmentNewsArtikelInfo,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_NewsArtikelInfo? readFragment_NewsArtikelInfo({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'NewsArtikelInfo',
          document: documentNodeFragmentNewsArtikelInfo,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_NewsArtikelInfo.fromJson(result);
  }
}

class Fragment_NewsArtikelInfo_untereinheit {
  Fragment_NewsArtikelInfo_untereinheit({
    required this.id,
    required this.name,
    this.$__typename = 'BereichBUntereinheit',
  });

  factory Fragment_NewsArtikelInfo_untereinheit.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikelInfo_untereinheit(
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
    if (other is! Fragment_NewsArtikelInfo_untereinheit ||
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

extension UtilityExtension_Fragment_NewsArtikelInfo_untereinheit
    on Fragment_NewsArtikelInfo_untereinheit {
  CopyWith_Fragment_NewsArtikelInfo_untereinheit<
    Fragment_NewsArtikelInfo_untereinheit
  >
  get copyWith =>
      CopyWith_Fragment_NewsArtikelInfo_untereinheit(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> {
  factory CopyWith_Fragment_NewsArtikelInfo_untereinheit(
    Fragment_NewsArtikelInfo_untereinheit instance,
    TRes Function(Fragment_NewsArtikelInfo_untereinheit) then,
  ) = _CopyWithImpl_Fragment_NewsArtikelInfo_untereinheit;

  factory CopyWith_Fragment_NewsArtikelInfo_untereinheit.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikelInfo_untereinheit;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Fragment_NewsArtikelInfo_untereinheit<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> {
  _CopyWithImpl_Fragment_NewsArtikelInfo_untereinheit(
    this._instance,
    this._then,
  );

  final Fragment_NewsArtikelInfo_untereinheit _instance;

  final TRes Function(Fragment_NewsArtikelInfo_untereinheit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikelInfo_untereinheit(
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

class _CopyWithStubImpl_Fragment_NewsArtikelInfo_untereinheit<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo_untereinheit<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikelInfo_untereinheit(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment_NewsArtikelInfo_titelbilder {
  Fragment_NewsArtikelInfo_titelbilder({
    this.id,
    this.bildunterschrift,
    this.bild,
    this.$__typename = 'NewsArtikel_Titelbilder',
  });

  factory Fragment_NewsArtikelInfo_titelbilder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$bildunterschrift = json['bildunterschrift'];
    final l$bild = json['bild'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikelInfo_titelbilder(
      id: (l$id as String?),
      bildunterschrift: (l$bildunterschrift as String?),
      bild: l$bild == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$bild as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? bildunterschrift;

  final Fragment_VeranstaltungsmedienImage? bild;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$bildunterschrift = bildunterschrift;
    _resultData['bildunterschrift'] = l$bildunterschrift;
    final l$bild = bild;
    _resultData['bild'] = l$bild?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$bildunterschrift = bildunterschrift;
    final l$bild = bild;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$bildunterschrift, l$bild, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_NewsArtikelInfo_titelbilder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$bildunterschrift = bildunterschrift;
    final lOther$bildunterschrift = other.bildunterschrift;
    if (l$bildunterschrift != lOther$bildunterschrift) {
      return false;
    }
    final l$bild = bild;
    final lOther$bild = other.bild;
    if (l$bild != lOther$bild) {
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

extension UtilityExtension_Fragment_NewsArtikelInfo_titelbilder
    on Fragment_NewsArtikelInfo_titelbilder {
  CopyWith_Fragment_NewsArtikelInfo_titelbilder<
    Fragment_NewsArtikelInfo_titelbilder
  >
  get copyWith => CopyWith_Fragment_NewsArtikelInfo_titelbilder(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikelInfo_titelbilder<TRes> {
  factory CopyWith_Fragment_NewsArtikelInfo_titelbilder(
    Fragment_NewsArtikelInfo_titelbilder instance,
    TRes Function(Fragment_NewsArtikelInfo_titelbilder) then,
  ) = _CopyWithImpl_Fragment_NewsArtikelInfo_titelbilder;

  factory CopyWith_Fragment_NewsArtikelInfo_titelbilder.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikelInfo_titelbilder;

  TRes call({
    String? id,
    String? bildunterschrift,
    Fragment_VeranstaltungsmedienImage? bild,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild;
}

class _CopyWithImpl_Fragment_NewsArtikelInfo_titelbilder<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo_titelbilder<TRes> {
  _CopyWithImpl_Fragment_NewsArtikelInfo_titelbilder(
    this._instance,
    this._then,
  );

  final Fragment_NewsArtikelInfo_titelbilder _instance;

  final TRes Function(Fragment_NewsArtikelInfo_titelbilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? bildunterschrift = _undefined,
    Object? bild = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikelInfo_titelbilder(
      id: id == _undefined ? _instance.id : (id as String?),
      bildunterschrift: bildunterschrift == _undefined
          ? _instance.bildunterschrift
          : (bildunterschrift as String?),
      bild: bild == _undefined
          ? _instance.bild
          : (bild as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild {
    final local$bild = _instance.bild;
    return local$bild == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$bild,
            (e) => call(bild: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_NewsArtikelInfo_titelbilder<TRes>
    implements CopyWith_Fragment_NewsArtikelInfo_titelbilder<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikelInfo_titelbilder(this._res);

  TRes _res;

  call({
    String? id,
    String? bildunterschrift,
    Fragment_VeranstaltungsmedienImage? bild,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_NewsArtikel implements Fragment_NewsArtikelInfo {
  Fragment_NewsArtikel({
    required this.id,
    this.titel,
    this.teaser,
    this.datum,
    this.ordinal,
    this.untereinheit,
    this.titelbilder,
    this.$__typename = 'NewsArtikel',
    this.originalUrl,
    this.inhalte,
  });

  factory Fragment_NewsArtikel.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$teaser = json['teaser'];
    final l$datum = json['datum'];
    final l$ordinal = json['ordinal'];
    final l$untereinheit = json['untereinheit'];
    final l$titelbilder = json['titelbilder'];
    final l$$__typename = json['__typename'];
    final l$originalUrl = json['originalUrl'];
    final l$inhalte = json['inhalte'];
    return Fragment_NewsArtikel(
      id: (l$id as String),
      titel: (l$titel as String?),
      teaser: (l$teaser as String?),
      datum: l$datum == null ? null : DateTime.parse((l$datum as String)),
      ordinal: (l$ordinal as num?)?.toDouble(),
      untereinheit: l$untereinheit == null
          ? null
          : Fragment_NewsArtikel_untereinheit.fromJson(
              (l$untereinheit as Map<String, dynamic>),
            ),
      titelbilder: (l$titelbilder as List<dynamic>?)
          ?.map(
            (e) => Fragment_NewsArtikel_titelbilder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      originalUrl: (l$originalUrl as String?),
      inhalte: (l$inhalte as List<dynamic>?)
          ?.map(
            (e) => Fragment_NewsArtikel_inhalte.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String? titel;

  final String? teaser;

  final DateTime? datum;

  final double? ordinal;

  final Fragment_NewsArtikel_untereinheit? untereinheit;

  final List<Fragment_NewsArtikel_titelbilder>? titelbilder;

  final String $__typename;

  final String? originalUrl;

  final List<Fragment_NewsArtikel_inhalte>? inhalte;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$datum = datum;
    _resultData['datum'] = l$datum?.toIso8601String();
    final l$ordinal = ordinal;
    _resultData['ordinal'] = l$ordinal;
    final l$untereinheit = untereinheit;
    _resultData['untereinheit'] = l$untereinheit?.toJson();
    final l$titelbilder = titelbilder;
    _resultData['titelbilder'] = l$titelbilder?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$originalUrl = originalUrl;
    _resultData['originalUrl'] = l$originalUrl;
    final l$inhalte = inhalte;
    _resultData['inhalte'] = l$inhalte?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$teaser = teaser;
    final l$datum = datum;
    final l$ordinal = ordinal;
    final l$untereinheit = untereinheit;
    final l$titelbilder = titelbilder;
    final l$$__typename = $__typename;
    final l$originalUrl = originalUrl;
    final l$inhalte = inhalte;
    return Object.hashAll([
      l$id,
      l$titel,
      l$teaser,
      l$datum,
      l$ordinal,
      l$untereinheit,
      l$titelbilder == null
          ? null
          : Object.hashAll(l$titelbilder.map((v) => v)),
      l$$__typename,
      l$originalUrl,
      l$inhalte == null ? null : Object.hashAll(l$inhalte.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_NewsArtikel || runtimeType != other.runtimeType) {
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
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$datum = datum;
    final lOther$datum = other.datum;
    if (l$datum != lOther$datum) {
      return false;
    }
    final l$ordinal = ordinal;
    final lOther$ordinal = other.ordinal;
    if (l$ordinal != lOther$ordinal) {
      return false;
    }
    final l$untereinheit = untereinheit;
    final lOther$untereinheit = other.untereinheit;
    if (l$untereinheit != lOther$untereinheit) {
      return false;
    }
    final l$titelbilder = titelbilder;
    final lOther$titelbilder = other.titelbilder;
    if (l$titelbilder != null && lOther$titelbilder != null) {
      if (l$titelbilder.length != lOther$titelbilder.length) {
        return false;
      }
      for (int i = 0; i < l$titelbilder.length; i++) {
        final l$titelbilder$entry = l$titelbilder[i];
        final lOther$titelbilder$entry = lOther$titelbilder[i];
        if (l$titelbilder$entry != lOther$titelbilder$entry) {
          return false;
        }
      }
    } else if (l$titelbilder != lOther$titelbilder) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$originalUrl = originalUrl;
    final lOther$originalUrl = other.originalUrl;
    if (l$originalUrl != lOther$originalUrl) {
      return false;
    }
    final l$inhalte = inhalte;
    final lOther$inhalte = other.inhalte;
    if (l$inhalte != null && lOther$inhalte != null) {
      if (l$inhalte.length != lOther$inhalte.length) {
        return false;
      }
      for (int i = 0; i < l$inhalte.length; i++) {
        final l$inhalte$entry = l$inhalte[i];
        final lOther$inhalte$entry = lOther$inhalte[i];
        if (l$inhalte$entry != lOther$inhalte$entry) {
          return false;
        }
      }
    } else if (l$inhalte != lOther$inhalte) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_NewsArtikel on Fragment_NewsArtikel {
  CopyWith_Fragment_NewsArtikel<Fragment_NewsArtikel> get copyWith =>
      CopyWith_Fragment_NewsArtikel(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikel<TRes> {
  factory CopyWith_Fragment_NewsArtikel(
    Fragment_NewsArtikel instance,
    TRes Function(Fragment_NewsArtikel) then,
  ) = _CopyWithImpl_Fragment_NewsArtikel;

  factory CopyWith_Fragment_NewsArtikel.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikel;

  TRes call({
    String? id,
    String? titel,
    String? teaser,
    DateTime? datum,
    double? ordinal,
    Fragment_NewsArtikel_untereinheit? untereinheit,
    List<Fragment_NewsArtikel_titelbilder>? titelbilder,
    String? $__typename,
    String? originalUrl,
    List<Fragment_NewsArtikel_inhalte>? inhalte,
  });
  CopyWith_Fragment_NewsArtikel_untereinheit<TRes> get untereinheit;
  TRes titelbilder(
    Iterable<Fragment_NewsArtikel_titelbilder>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikel_titelbilder<
          Fragment_NewsArtikel_titelbilder
        >
      >?,
    )
    _fn,
  );
  TRes inhalte(
    Iterable<Fragment_NewsArtikel_inhalte>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikel_inhalte<Fragment_NewsArtikel_inhalte>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_NewsArtikel<TRes>
    implements CopyWith_Fragment_NewsArtikel<TRes> {
  _CopyWithImpl_Fragment_NewsArtikel(this._instance, this._then);

  final Fragment_NewsArtikel _instance;

  final TRes Function(Fragment_NewsArtikel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? teaser = _undefined,
    Object? datum = _undefined,
    Object? ordinal = _undefined,
    Object? untereinheit = _undefined,
    Object? titelbilder = _undefined,
    Object? $__typename = _undefined,
    Object? originalUrl = _undefined,
    Object? inhalte = _undefined,
  }) => _then(
    Fragment_NewsArtikel(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      datum: datum == _undefined ? _instance.datum : (datum as DateTime?),
      ordinal: ordinal == _undefined ? _instance.ordinal : (ordinal as double?),
      untereinheit: untereinheit == _undefined
          ? _instance.untereinheit
          : (untereinheit as Fragment_NewsArtikel_untereinheit?),
      titelbilder: titelbilder == _undefined
          ? _instance.titelbilder
          : (titelbilder as List<Fragment_NewsArtikel_titelbilder>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      originalUrl: originalUrl == _undefined
          ? _instance.originalUrl
          : (originalUrl as String?),
      inhalte: inhalte == _undefined
          ? _instance.inhalte
          : (inhalte as List<Fragment_NewsArtikel_inhalte>?),
    ),
  );

  CopyWith_Fragment_NewsArtikel_untereinheit<TRes> get untereinheit {
    final local$untereinheit = _instance.untereinheit;
    return local$untereinheit == null
        ? CopyWith_Fragment_NewsArtikel_untereinheit.stub(_then(_instance))
        : CopyWith_Fragment_NewsArtikel_untereinheit(
            local$untereinheit,
            (e) => call(untereinheit: e),
          );
  }

  TRes titelbilder(
    Iterable<Fragment_NewsArtikel_titelbilder>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikel_titelbilder<
          Fragment_NewsArtikel_titelbilder
        >
      >?,
    )
    _fn,
  ) => call(
    titelbilder: _fn(
      _instance.titelbilder?.map(
        (e) => CopyWith_Fragment_NewsArtikel_titelbilder(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes inhalte(
    Iterable<Fragment_NewsArtikel_inhalte>? Function(
      Iterable<
        CopyWith_Fragment_NewsArtikel_inhalte<Fragment_NewsArtikel_inhalte>
      >?,
    )
    _fn,
  ) => call(
    inhalte: _fn(
      _instance.inhalte?.map(
        (e) => CopyWith_Fragment_NewsArtikel_inhalte(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_NewsArtikel<TRes>
    implements CopyWith_Fragment_NewsArtikel<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikel(this._res);

  TRes _res;

  call({
    String? id,
    String? titel,
    String? teaser,
    DateTime? datum,
    double? ordinal,
    Fragment_NewsArtikel_untereinheit? untereinheit,
    List<Fragment_NewsArtikel_titelbilder>? titelbilder,
    String? $__typename,
    String? originalUrl,
    List<Fragment_NewsArtikel_inhalte>? inhalte,
  }) => _res;

  CopyWith_Fragment_NewsArtikel_untereinheit<TRes> get untereinheit =>
      CopyWith_Fragment_NewsArtikel_untereinheit.stub(_res);

  titelbilder(_fn) => _res;

  inhalte(_fn) => _res;
}

const fragmentDefinitionNewsArtikel = FragmentDefinitionNode(
  name: NameNode(value: 'NewsArtikel'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'NewsArtikel'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FragmentSpreadNode(
        name: NameNode(value: 'NewsArtikelInfo'),
        directives: [],
      ),
      FieldNode(
        name: NameNode(value: 'originalUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'inhalte'),
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
              name: NameNode(value: 'ImageBlockVeranstaltungsmedien'),
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
const documentNodeFragmentNewsArtikel = DocumentNode(
  definitions: [
    fragmentDefinitionNewsArtikel,
    fragmentDefinitionNewsArtikelInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
    fragmentDefinitionRichTextBlock,
    fragmentDefinitionImageBlockVeranstaltungsmedien,
  ],
);

extension ClientExtension_Fragment_NewsArtikel on graphql.GraphQLClient {
  void writeFragment_NewsArtikel({
    required Fragment_NewsArtikel data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'NewsArtikel',
        document: documentNodeFragmentNewsArtikel,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_NewsArtikel? readFragment_NewsArtikel({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'NewsArtikel',
          document: documentNodeFragmentNewsArtikel,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_NewsArtikel.fromJson(result);
  }
}

class Fragment_NewsArtikel_untereinheit
    implements Fragment_NewsArtikelInfo_untereinheit {
  Fragment_NewsArtikel_untereinheit({
    required this.id,
    required this.name,
    this.$__typename = 'BereichBUntereinheit',
  });

  factory Fragment_NewsArtikel_untereinheit.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikel_untereinheit(
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
    if (other is! Fragment_NewsArtikel_untereinheit ||
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

extension UtilityExtension_Fragment_NewsArtikel_untereinheit
    on Fragment_NewsArtikel_untereinheit {
  CopyWith_Fragment_NewsArtikel_untereinheit<Fragment_NewsArtikel_untereinheit>
  get copyWith => CopyWith_Fragment_NewsArtikel_untereinheit(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikel_untereinheit<TRes> {
  factory CopyWith_Fragment_NewsArtikel_untereinheit(
    Fragment_NewsArtikel_untereinheit instance,
    TRes Function(Fragment_NewsArtikel_untereinheit) then,
  ) = _CopyWithImpl_Fragment_NewsArtikel_untereinheit;

  factory CopyWith_Fragment_NewsArtikel_untereinheit.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikel_untereinheit;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Fragment_NewsArtikel_untereinheit<TRes>
    implements CopyWith_Fragment_NewsArtikel_untereinheit<TRes> {
  _CopyWithImpl_Fragment_NewsArtikel_untereinheit(this._instance, this._then);

  final Fragment_NewsArtikel_untereinheit _instance;

  final TRes Function(Fragment_NewsArtikel_untereinheit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikel_untereinheit(
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

class _CopyWithStubImpl_Fragment_NewsArtikel_untereinheit<TRes>
    implements CopyWith_Fragment_NewsArtikel_untereinheit<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikel_untereinheit(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment_NewsArtikel_titelbilder
    implements Fragment_NewsArtikelInfo_titelbilder {
  Fragment_NewsArtikel_titelbilder({
    this.id,
    this.bildunterschrift,
    this.bild,
    this.$__typename = 'NewsArtikel_Titelbilder',
  });

  factory Fragment_NewsArtikel_titelbilder.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$bildunterschrift = json['bildunterschrift'];
    final l$bild = json['bild'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikel_titelbilder(
      id: (l$id as String?),
      bildunterschrift: (l$bildunterschrift as String?),
      bild: l$bild == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$bild as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? bildunterschrift;

  final Fragment_VeranstaltungsmedienImage? bild;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$bildunterschrift = bildunterschrift;
    _resultData['bildunterschrift'] = l$bildunterschrift;
    final l$bild = bild;
    _resultData['bild'] = l$bild?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$bildunterschrift = bildunterschrift;
    final l$bild = bild;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$bildunterschrift, l$bild, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_NewsArtikel_titelbilder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$bildunterschrift = bildunterschrift;
    final lOther$bildunterschrift = other.bildunterschrift;
    if (l$bildunterschrift != lOther$bildunterschrift) {
      return false;
    }
    final l$bild = bild;
    final lOther$bild = other.bild;
    if (l$bild != lOther$bild) {
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

extension UtilityExtension_Fragment_NewsArtikel_titelbilder
    on Fragment_NewsArtikel_titelbilder {
  CopyWith_Fragment_NewsArtikel_titelbilder<Fragment_NewsArtikel_titelbilder>
  get copyWith => CopyWith_Fragment_NewsArtikel_titelbilder(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikel_titelbilder<TRes> {
  factory CopyWith_Fragment_NewsArtikel_titelbilder(
    Fragment_NewsArtikel_titelbilder instance,
    TRes Function(Fragment_NewsArtikel_titelbilder) then,
  ) = _CopyWithImpl_Fragment_NewsArtikel_titelbilder;

  factory CopyWith_Fragment_NewsArtikel_titelbilder.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikel_titelbilder;

  TRes call({
    String? id,
    String? bildunterschrift,
    Fragment_VeranstaltungsmedienImage? bild,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild;
}

class _CopyWithImpl_Fragment_NewsArtikel_titelbilder<TRes>
    implements CopyWith_Fragment_NewsArtikel_titelbilder<TRes> {
  _CopyWithImpl_Fragment_NewsArtikel_titelbilder(this._instance, this._then);

  final Fragment_NewsArtikel_titelbilder _instance;

  final TRes Function(Fragment_NewsArtikel_titelbilder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? bildunterschrift = _undefined,
    Object? bild = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikel_titelbilder(
      id: id == _undefined ? _instance.id : (id as String?),
      bildunterschrift: bildunterschrift == _undefined
          ? _instance.bildunterschrift
          : (bildunterschrift as String?),
      bild: bild == _undefined
          ? _instance.bild
          : (bild as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild {
    final local$bild = _instance.bild;
    return local$bild == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$bild,
            (e) => call(bild: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_NewsArtikel_titelbilder<TRes>
    implements CopyWith_Fragment_NewsArtikel_titelbilder<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikel_titelbilder(this._res);

  TRes _res;

  call({
    String? id,
    String? bildunterschrift,
    Fragment_VeranstaltungsmedienImage? bild,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get bild =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_NewsArtikel_inhalte {
  Fragment_NewsArtikel_inhalte({required this.$__typename});

  factory Fragment_NewsArtikel_inhalte.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "RichTextBlock":
        return Fragment_NewsArtikel_inhalte__RichTextBlock.fromJson(json);

      case "ImageBlockVeranstaltungsmedien":
        return Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Fragment_NewsArtikel_inhalte(
          $__typename: (l$$__typename as String),
        );
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
    if (other is! Fragment_NewsArtikel_inhalte ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_NewsArtikel_inhalte
    on Fragment_NewsArtikel_inhalte {
  CopyWith_Fragment_NewsArtikel_inhalte<Fragment_NewsArtikel_inhalte>
  get copyWith => CopyWith_Fragment_NewsArtikel_inhalte(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_NewsArtikel_inhalte__RichTextBlock)
    richTextBlock,
    required _T Function(
      Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien,
    )
    imageBlockVeranstaltungsmedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        return richTextBlock(
          this as Fragment_NewsArtikel_inhalte__RichTextBlock,
        );

      case "ImageBlockVeranstaltungsmedien":
        return imageBlockVeranstaltungsmedien(
          this as Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_NewsArtikel_inhalte__RichTextBlock)? richTextBlock,
    _T Function(Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien)?
    imageBlockVeranstaltungsmedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        if (richTextBlock != null) {
          return richTextBlock(
            this as Fragment_NewsArtikel_inhalte__RichTextBlock,
          );
        } else {
          return orElse();
        }

      case "ImageBlockVeranstaltungsmedien":
        if (imageBlockVeranstaltungsmedien != null) {
          return imageBlockVeranstaltungsmedien(
            this
                as Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_NewsArtikel_inhalte<TRes> {
  factory CopyWith_Fragment_NewsArtikel_inhalte(
    Fragment_NewsArtikel_inhalte instance,
    TRes Function(Fragment_NewsArtikel_inhalte) then,
  ) = _CopyWithImpl_Fragment_NewsArtikel_inhalte;

  factory CopyWith_Fragment_NewsArtikel_inhalte.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikel_inhalte;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Fragment_NewsArtikel_inhalte<TRes>
    implements CopyWith_Fragment_NewsArtikel_inhalte<TRes> {
  _CopyWithImpl_Fragment_NewsArtikel_inhalte(this._instance, this._then);

  final Fragment_NewsArtikel_inhalte _instance;

  final TRes Function(Fragment_NewsArtikel_inhalte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Fragment_NewsArtikel_inhalte(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_NewsArtikel_inhalte<TRes>
    implements CopyWith_Fragment_NewsArtikel_inhalte<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikel_inhalte(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Fragment_NewsArtikel_inhalte__RichTextBlock
    implements Fragment_RichTextBlock, Fragment_NewsArtikel_inhalte {
  Fragment_NewsArtikel_inhalte__RichTextBlock({
    this.contentHtml,
    this.$__typename = 'RichTextBlock',
  });

  factory Fragment_NewsArtikel_inhalte__RichTextBlock.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$contentHtml = json['contentHtml'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikel_inhalte__RichTextBlock(
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
    if (other is! Fragment_NewsArtikel_inhalte__RichTextBlock ||
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

extension UtilityExtension_Fragment_NewsArtikel_inhalte__RichTextBlock
    on Fragment_NewsArtikel_inhalte__RichTextBlock {
  CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock<
    Fragment_NewsArtikel_inhalte__RichTextBlock
  >
  get copyWith =>
      CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock(this, (i) => i);
}

abstract class CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock<TRes> {
  factory CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock(
    Fragment_NewsArtikel_inhalte__RichTextBlock instance,
    TRes Function(Fragment_NewsArtikel_inhalte__RichTextBlock) then,
  ) = _CopyWithImpl_Fragment_NewsArtikel_inhalte__RichTextBlock;

  factory CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock.stub(TRes res) =
      _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__RichTextBlock;

  TRes call({String? contentHtml, String? $__typename});
}

class _CopyWithImpl_Fragment_NewsArtikel_inhalte__RichTextBlock<TRes>
    implements CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock<TRes> {
  _CopyWithImpl_Fragment_NewsArtikel_inhalte__RichTextBlock(
    this._instance,
    this._then,
  );

  final Fragment_NewsArtikel_inhalte__RichTextBlock _instance;

  final TRes Function(Fragment_NewsArtikel_inhalte__RichTextBlock) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentHtml = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_NewsArtikel_inhalte__RichTextBlock(
      contentHtml: contentHtml == _undefined
          ? _instance.contentHtml
          : (contentHtml as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__RichTextBlock<TRes>
    implements CopyWith_Fragment_NewsArtikel_inhalte__RichTextBlock<TRes> {
  _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__RichTextBlock(this._res);

  TRes _res;

  call({String? contentHtml, String? $__typename}) => _res;
}

class Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien
    implements
        Fragment_ImageBlockVeranstaltungsmedien,
        Fragment_NewsArtikel_inhalte {
  Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien({
    this.image,
    this.$__typename = 'ImageBlockVeranstaltungsmedien',
  });

  factory Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
      image: l$image == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$image as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_VeranstaltungsmedienImage? image;

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
    if (other
            is! Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien ||
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

extension UtilityExtension_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien
    on Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien {
  CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
    Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien
  >
  get copyWith =>
      CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
> {
  factory CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
    Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien instance,
    TRes Function(Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien)
    then,
  ) = _CopyWithImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien;

  factory CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien;

  TRes call({Fragment_VeranstaltungsmedienImage? image, String? $__typename});
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image;
}

class _CopyWithImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
>
    implements
        CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
          TRes
        > {
  _CopyWithImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
    this._instance,
    this._then,
  );

  final Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien _instance;

  final TRes Function(
    Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? image = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
          image: image == _undefined
              ? _instance.image
              : (image as Fragment_VeranstaltungsmedienImage?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image {
    final local$image = _instance.image;
    return local$image == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$image,
            (e) => call(image: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
>
    implements
        CopyWith_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien<
          TRes
        > {
  _CopyWithStubImpl_Fragment_NewsArtikel_inhalte__ImageBlockVeranstaltungsmedien(
    this._res,
  );

  TRes _res;

  call({Fragment_VeranstaltungsmedienImage? image, String? $__typename}) =>
      _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Variables_Query_NewsArtikelList {
  factory Variables_Query_NewsArtikelList({
    required Input_NewsArtikel_where filter,
    int? page,
    int? limit,
  }) => Variables_Query_NewsArtikelList._({
    r'filter': filter,
    if (page != null) r'page': page,
    if (limit != null) r'limit': limit,
  });

  Variables_Query_NewsArtikelList._(this._$data);

  factory Variables_Query_NewsArtikelList.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$filter = data['filter'];
    result$data['filter'] = Input_NewsArtikel_where.fromJson(
      (l$filter as Map<String, dynamic>),
    );
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables_Query_NewsArtikelList._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_NewsArtikel_where get filter =>
      (_$data['filter'] as Input_NewsArtikel_where);

  int? get page => (_$data['page'] as int?);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$filter = filter;
    result$data['filter'] = l$filter.toJson();
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith_Variables_Query_NewsArtikelList<Variables_Query_NewsArtikelList>
  get copyWith => CopyWith_Variables_Query_NewsArtikelList(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_NewsArtikelList ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (l$filter != lOther$filter) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
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
    final l$filter = filter;
    final l$page = page;
    final l$limit = limit;
    return Object.hashAll([
      l$filter,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_NewsArtikelList<TRes> {
  factory CopyWith_Variables_Query_NewsArtikelList(
    Variables_Query_NewsArtikelList instance,
    TRes Function(Variables_Query_NewsArtikelList) then,
  ) = _CopyWithImpl_Variables_Query_NewsArtikelList;

  factory CopyWith_Variables_Query_NewsArtikelList.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_NewsArtikelList;

  TRes call({Input_NewsArtikel_where? filter, int? page, int? limit});
}

class _CopyWithImpl_Variables_Query_NewsArtikelList<TRes>
    implements CopyWith_Variables_Query_NewsArtikelList<TRes> {
  _CopyWithImpl_Variables_Query_NewsArtikelList(this._instance, this._then);

  final Variables_Query_NewsArtikelList _instance;

  final TRes Function(Variables_Query_NewsArtikelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? filter = _undefined,
    Object? page = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Variables_Query_NewsArtikelList._({
      ..._instance._$data,
      if (filter != _undefined && filter != null)
        'filter': (filter as Input_NewsArtikel_where),
      if (page != _undefined) 'page': (page as int?),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_NewsArtikelList<TRes>
    implements CopyWith_Variables_Query_NewsArtikelList<TRes> {
  _CopyWithStubImpl_Variables_Query_NewsArtikelList(this._res);

  TRes _res;

  call({Input_NewsArtikel_where? filter, int? page, int? limit}) => _res;
}

class Query_NewsArtikelList {
  Query_NewsArtikelList({this.newsArtikelList, this.$__typename = 'Query'});

  factory Query_NewsArtikelList.fromJson(Map<String, dynamic> json) {
    final l$newsArtikelList = json['newsArtikelList'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikelList(
      newsArtikelList: l$newsArtikelList == null
          ? null
          : Query_NewsArtikelList_newsArtikelList.fromJson(
              (l$newsArtikelList as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_NewsArtikelList_newsArtikelList? newsArtikelList;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$newsArtikelList = newsArtikelList;
    _resultData['newsArtikelList'] = l$newsArtikelList?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$newsArtikelList = newsArtikelList;
    final l$$__typename = $__typename;
    return Object.hashAll([l$newsArtikelList, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikelList || runtimeType != other.runtimeType) {
      return false;
    }
    final l$newsArtikelList = newsArtikelList;
    final lOther$newsArtikelList = other.newsArtikelList;
    if (l$newsArtikelList != lOther$newsArtikelList) {
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

extension UtilityExtension_Query_NewsArtikelList on Query_NewsArtikelList {
  CopyWith_Query_NewsArtikelList<Query_NewsArtikelList> get copyWith =>
      CopyWith_Query_NewsArtikelList(this, (i) => i);
}

abstract class CopyWith_Query_NewsArtikelList<TRes> {
  factory CopyWith_Query_NewsArtikelList(
    Query_NewsArtikelList instance,
    TRes Function(Query_NewsArtikelList) then,
  ) = _CopyWithImpl_Query_NewsArtikelList;

  factory CopyWith_Query_NewsArtikelList.stub(TRes res) =
      _CopyWithStubImpl_Query_NewsArtikelList;

  TRes call({
    Query_NewsArtikelList_newsArtikelList? newsArtikelList,
    String? $__typename,
  });
  CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> get newsArtikelList;
}

class _CopyWithImpl_Query_NewsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelList<TRes> {
  _CopyWithImpl_Query_NewsArtikelList(this._instance, this._then);

  final Query_NewsArtikelList _instance;

  final TRes Function(Query_NewsArtikelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? newsArtikelList = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikelList(
      newsArtikelList: newsArtikelList == _undefined
          ? _instance.newsArtikelList
          : (newsArtikelList as Query_NewsArtikelList_newsArtikelList?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> get newsArtikelList {
    final local$newsArtikelList = _instance.newsArtikelList;
    return local$newsArtikelList == null
        ? CopyWith_Query_NewsArtikelList_newsArtikelList.stub(_then(_instance))
        : CopyWith_Query_NewsArtikelList_newsArtikelList(
            local$newsArtikelList,
            (e) => call(newsArtikelList: e),
          );
  }
}

class _CopyWithStubImpl_Query_NewsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelList<TRes> {
  _CopyWithStubImpl_Query_NewsArtikelList(this._res);

  TRes _res;

  call({
    Query_NewsArtikelList_newsArtikelList? newsArtikelList,
    String? $__typename,
  }) => _res;

  CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> get newsArtikelList =>
      CopyWith_Query_NewsArtikelList_newsArtikelList.stub(_res);
}

const documentNodeQueryNewsArtikelList = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NewsArtikelList'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'NewsArtikel_where'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
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
            name: NameNode(value: 'newsArtikelList'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sort'),
                value: StringValueNode(value: '-datum', isBlock: false),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'NewsArtikelInfo'),
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
                  name: NameNode(value: 'hasNextPage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'page'),
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
    fragmentDefinitionNewsArtikelInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
  ],
);
Query_NewsArtikelList _parserFn_Query_NewsArtikelList(
  Map<String, dynamic> data,
) => Query_NewsArtikelList.fromJson(data);
typedef OnQueryComplete_Query_NewsArtikelList =
    FutureOr<void> Function(Map<String, dynamic>?, Query_NewsArtikelList?);

class Options_Query_NewsArtikelList
    extends graphql.QueryOptions<Query_NewsArtikelList> {
  Options_Query_NewsArtikelList({
    String? operationName,
    required Variables_Query_NewsArtikelList variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikelList? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_NewsArtikelList? onComplete,
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
                 data == null ? null : _parserFn_Query_NewsArtikelList(data),
               ),
         onError: onError,
         document: documentNodeQueryNewsArtikelList,
         parserFn: _parserFn_Query_NewsArtikelList,
       );

  final OnQueryComplete_Query_NewsArtikelList? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_NewsArtikelList
    extends graphql.WatchQueryOptions<Query_NewsArtikelList> {
  WatchOptions_Query_NewsArtikelList({
    String? operationName,
    required Variables_Query_NewsArtikelList variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikelList? typedOptimisticResult,
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
         document: documentNodeQueryNewsArtikelList,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_NewsArtikelList,
       );
}

class FetchMoreOptions_Query_NewsArtikelList extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_NewsArtikelList({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_NewsArtikelList variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryNewsArtikelList,
       );
}

extension ClientExtension_Query_NewsArtikelList on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_NewsArtikelList>> query_NewsArtikelList(
    Options_Query_NewsArtikelList options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_NewsArtikelList> watchQuery_NewsArtikelList(
    WatchOptions_Query_NewsArtikelList options,
  ) => this.watchQuery(options);

  void writeQuery_NewsArtikelList({
    required Query_NewsArtikelList data,
    required Variables_Query_NewsArtikelList variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryNewsArtikelList),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_NewsArtikelList? readQuery_NewsArtikelList({
    required Variables_Query_NewsArtikelList variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryNewsArtikelList,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_NewsArtikelList.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_NewsArtikelList> useQuery_NewsArtikelList(
  Options_Query_NewsArtikelList options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_NewsArtikelList> useWatchQuery_NewsArtikelList(
  WatchOptions_Query_NewsArtikelList options,
) => graphql_flutter.useWatchQuery(options);

class Query_NewsArtikelList_Widget
    extends graphql_flutter.Query<Query_NewsArtikelList> {
  Query_NewsArtikelList_Widget({
    widgets.Key? key,
    required Options_Query_NewsArtikelList options,
    required graphql_flutter.QueryBuilder<Query_NewsArtikelList> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_NewsArtikelList_newsArtikelList {
  Query_NewsArtikelList_newsArtikelList({
    required this.docs,
    required this.hasNextPage,
    required this.page,
    this.$__typename = 'NewsArtikels',
  });

  factory Query_NewsArtikelList_newsArtikelList.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$hasNextPage = json['hasNextPage'];
    final l$page = json['page'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikelList_newsArtikelList(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Fragment_NewsArtikelInfo.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      hasNextPage: (l$hasNextPage as bool),
      page: (l$page as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_NewsArtikelInfo> docs;

  final bool hasNextPage;

  final int page;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$page = page;
    _resultData['page'] = l$page;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$hasNextPage = hasNextPage;
    final l$page = page;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$hasNextPage,
      l$page,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikelList_newsArtikelList ||
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
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
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

extension UtilityExtension_Query_NewsArtikelList_newsArtikelList
    on Query_NewsArtikelList_newsArtikelList {
  CopyWith_Query_NewsArtikelList_newsArtikelList<
    Query_NewsArtikelList_newsArtikelList
  >
  get copyWith =>
      CopyWith_Query_NewsArtikelList_newsArtikelList(this, (i) => i);
}

abstract class CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> {
  factory CopyWith_Query_NewsArtikelList_newsArtikelList(
    Query_NewsArtikelList_newsArtikelList instance,
    TRes Function(Query_NewsArtikelList_newsArtikelList) then,
  ) = _CopyWithImpl_Query_NewsArtikelList_newsArtikelList;

  factory CopyWith_Query_NewsArtikelList_newsArtikelList.stub(TRes res) =
      _CopyWithStubImpl_Query_NewsArtikelList_newsArtikelList;

  TRes call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  });
  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_NewsArtikelList_newsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> {
  _CopyWithImpl_Query_NewsArtikelList_newsArtikelList(
    this._instance,
    this._then,
  );

  final Query_NewsArtikelList_newsArtikelList _instance;

  final TRes Function(Query_NewsArtikelList_newsArtikelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? docs = _undefined,
    Object? hasNextPage = _undefined,
    Object? page = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikelList_newsArtikelList(
      docs: docs == _undefined || docs == null
          ? _instance.docs
          : (docs as List<Fragment_NewsArtikelInfo>),
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      page: page == _undefined || page == null ? _instance.page : (page as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map((e) => CopyWith_Fragment_NewsArtikelInfo(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_NewsArtikelList_newsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelList_newsArtikelList<TRes> {
  _CopyWithStubImpl_Query_NewsArtikelList_newsArtikelList(this._res);

  TRes _res;

  call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Variables_Query_NewsArtikelFrontpage {
  factory Variables_Query_NewsArtikelFrontpage({
    List<dynamic?>? untereinheitenIds,
    required dynamic kommuneId,
    required double ordinal,
    int? page,
    int? limit,
  }) => Variables_Query_NewsArtikelFrontpage._({
    if (untereinheitenIds != null) r'untereinheitenIds': untereinheitenIds,
    r'kommuneId': kommuneId,
    r'ordinal': ordinal,
    if (page != null) r'page': page,
    if (limit != null) r'limit': limit,
  });

  Variables_Query_NewsArtikelFrontpage._(this._$data);

  factory Variables_Query_NewsArtikelFrontpage.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('untereinheitenIds')) {
      final l$untereinheitenIds = data['untereinheitenIds'];
      result$data['untereinheitenIds'] = (l$untereinheitenIds as List<dynamic>?)
          ?.map((e) => (e as dynamic?))
          .toList();
    }
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as dynamic);
    final l$ordinal = data['ordinal'];
    result$data['ordinal'] = (l$ordinal as num).toDouble();
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables_Query_NewsArtikelFrontpage._(result$data);
  }

  Map<String, dynamic> _$data;

  List<dynamic?>? get untereinheitenIds =>
      (_$data['untereinheitenIds'] as List<dynamic?>?);

  dynamic get kommuneId => (_$data['kommuneId'] as dynamic);

  double get ordinal => (_$data['ordinal'] as double);

  int? get page => (_$data['page'] as int?);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('untereinheitenIds')) {
      final l$untereinheitenIds = untereinheitenIds;
      result$data['untereinheitenIds'] = l$untereinheitenIds
          ?.map((e) => e)
          .toList();
    }
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$ordinal = ordinal;
    result$data['ordinal'] = l$ordinal;
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith_Variables_Query_NewsArtikelFrontpage<
    Variables_Query_NewsArtikelFrontpage
  >
  get copyWith => CopyWith_Variables_Query_NewsArtikelFrontpage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_NewsArtikelFrontpage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$untereinheitenIds = untereinheitenIds;
    final lOther$untereinheitenIds = other.untereinheitenIds;
    if (_$data.containsKey('untereinheitenIds') !=
        other._$data.containsKey('untereinheitenIds')) {
      return false;
    }
    if (l$untereinheitenIds != null && lOther$untereinheitenIds != null) {
      if (l$untereinheitenIds.length != lOther$untereinheitenIds.length) {
        return false;
      }
      for (int i = 0; i < l$untereinheitenIds.length; i++) {
        final l$untereinheitenIds$entry = l$untereinheitenIds[i];
        final lOther$untereinheitenIds$entry = lOther$untereinheitenIds[i];
        if (l$untereinheitenIds$entry != lOther$untereinheitenIds$entry) {
          return false;
        }
      }
    } else if (l$untereinheitenIds != lOther$untereinheitenIds) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$ordinal = ordinal;
    final lOther$ordinal = other.ordinal;
    if (l$ordinal != lOther$ordinal) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
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
    final l$untereinheitenIds = untereinheitenIds;
    final l$kommuneId = kommuneId;
    final l$ordinal = ordinal;
    final l$page = page;
    final l$limit = limit;
    return Object.hashAll([
      _$data.containsKey('untereinheitenIds')
          ? l$untereinheitenIds == null
                ? null
                : Object.hashAll(l$untereinheitenIds.map((v) => v))
          : const {},
      l$kommuneId,
      l$ordinal,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_NewsArtikelFrontpage<TRes> {
  factory CopyWith_Variables_Query_NewsArtikelFrontpage(
    Variables_Query_NewsArtikelFrontpage instance,
    TRes Function(Variables_Query_NewsArtikelFrontpage) then,
  ) = _CopyWithImpl_Variables_Query_NewsArtikelFrontpage;

  factory CopyWith_Variables_Query_NewsArtikelFrontpage.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_NewsArtikelFrontpage;

  TRes call({
    List<dynamic?>? untereinheitenIds,
    dynamic? kommuneId,
    double? ordinal,
    int? page,
    int? limit,
  });
}

class _CopyWithImpl_Variables_Query_NewsArtikelFrontpage<TRes>
    implements CopyWith_Variables_Query_NewsArtikelFrontpage<TRes> {
  _CopyWithImpl_Variables_Query_NewsArtikelFrontpage(
    this._instance,
    this._then,
  );

  final Variables_Query_NewsArtikelFrontpage _instance;

  final TRes Function(Variables_Query_NewsArtikelFrontpage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? untereinheitenIds = _undefined,
    Object? kommuneId = _undefined,
    Object? ordinal = _undefined,
    Object? page = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Variables_Query_NewsArtikelFrontpage._({
      ..._instance._$data,
      if (untereinheitenIds != _undefined)
        'untereinheitenIds': (untereinheitenIds as List<dynamic?>?),
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as dynamic),
      if (ordinal != _undefined && ordinal != null)
        'ordinal': (ordinal as double),
      if (page != _undefined) 'page': (page as int?),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_NewsArtikelFrontpage<TRes>
    implements CopyWith_Variables_Query_NewsArtikelFrontpage<TRes> {
  _CopyWithStubImpl_Variables_Query_NewsArtikelFrontpage(this._res);

  TRes _res;

  call({
    List<dynamic?>? untereinheitenIds,
    dynamic? kommuneId,
    double? ordinal,
    int? page,
    int? limit,
  }) => _res;
}

class Query_NewsArtikelFrontpage {
  Query_NewsArtikelFrontpage({
    this.topThemaNewsArtikelList,
    this.newsArtikelList,
    this.$__typename = 'Query',
  });

  factory Query_NewsArtikelFrontpage.fromJson(Map<String, dynamic> json) {
    final l$topThemaNewsArtikelList = json['topThemaNewsArtikelList'];
    final l$newsArtikelList = json['newsArtikelList'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikelFrontpage(
      topThemaNewsArtikelList: l$topThemaNewsArtikelList == null
          ? null
          : Query_NewsArtikelFrontpage_topThemaNewsArtikelList.fromJson(
              (l$topThemaNewsArtikelList as Map<String, dynamic>),
            ),
      newsArtikelList: l$newsArtikelList == null
          ? null
          : Query_NewsArtikelFrontpage_newsArtikelList.fromJson(
              (l$newsArtikelList as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_NewsArtikelFrontpage_topThemaNewsArtikelList?
  topThemaNewsArtikelList;

  final Query_NewsArtikelFrontpage_newsArtikelList? newsArtikelList;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$topThemaNewsArtikelList = topThemaNewsArtikelList;
    _resultData['topThemaNewsArtikelList'] = l$topThemaNewsArtikelList
        ?.toJson();
    final l$newsArtikelList = newsArtikelList;
    _resultData['newsArtikelList'] = l$newsArtikelList?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$topThemaNewsArtikelList = topThemaNewsArtikelList;
    final l$newsArtikelList = newsArtikelList;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$topThemaNewsArtikelList,
      l$newsArtikelList,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikelFrontpage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$topThemaNewsArtikelList = topThemaNewsArtikelList;
    final lOther$topThemaNewsArtikelList = other.topThemaNewsArtikelList;
    if (l$topThemaNewsArtikelList != lOther$topThemaNewsArtikelList) {
      return false;
    }
    final l$newsArtikelList = newsArtikelList;
    final lOther$newsArtikelList = other.newsArtikelList;
    if (l$newsArtikelList != lOther$newsArtikelList) {
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

extension UtilityExtension_Query_NewsArtikelFrontpage
    on Query_NewsArtikelFrontpage {
  CopyWith_Query_NewsArtikelFrontpage<Query_NewsArtikelFrontpage>
  get copyWith => CopyWith_Query_NewsArtikelFrontpage(this, (i) => i);
}

abstract class CopyWith_Query_NewsArtikelFrontpage<TRes> {
  factory CopyWith_Query_NewsArtikelFrontpage(
    Query_NewsArtikelFrontpage instance,
    TRes Function(Query_NewsArtikelFrontpage) then,
  ) = _CopyWithImpl_Query_NewsArtikelFrontpage;

  factory CopyWith_Query_NewsArtikelFrontpage.stub(TRes res) =
      _CopyWithStubImpl_Query_NewsArtikelFrontpage;

  TRes call({
    Query_NewsArtikelFrontpage_topThemaNewsArtikelList? topThemaNewsArtikelList,
    Query_NewsArtikelFrontpage_newsArtikelList? newsArtikelList,
    String? $__typename,
  });
  CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes>
  get topThemaNewsArtikelList;
  CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes> get newsArtikelList;
}

class _CopyWithImpl_Query_NewsArtikelFrontpage<TRes>
    implements CopyWith_Query_NewsArtikelFrontpage<TRes> {
  _CopyWithImpl_Query_NewsArtikelFrontpage(this._instance, this._then);

  final Query_NewsArtikelFrontpage _instance;

  final TRes Function(Query_NewsArtikelFrontpage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? topThemaNewsArtikelList = _undefined,
    Object? newsArtikelList = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikelFrontpage(
      topThemaNewsArtikelList: topThemaNewsArtikelList == _undefined
          ? _instance.topThemaNewsArtikelList
          : (topThemaNewsArtikelList
                as Query_NewsArtikelFrontpage_topThemaNewsArtikelList?),
      newsArtikelList: newsArtikelList == _undefined
          ? _instance.newsArtikelList
          : (newsArtikelList as Query_NewsArtikelFrontpage_newsArtikelList?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes>
  get topThemaNewsArtikelList {
    final local$topThemaNewsArtikelList = _instance.topThemaNewsArtikelList;
    return local$topThemaNewsArtikelList == null
        ? CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList.stub(
            _then(_instance),
          )
        : CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
            local$topThemaNewsArtikelList,
            (e) => call(topThemaNewsArtikelList: e),
          );
  }

  CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes>
  get newsArtikelList {
    final local$newsArtikelList = _instance.newsArtikelList;
    return local$newsArtikelList == null
        ? CopyWith_Query_NewsArtikelFrontpage_newsArtikelList.stub(
            _then(_instance),
          )
        : CopyWith_Query_NewsArtikelFrontpage_newsArtikelList(
            local$newsArtikelList,
            (e) => call(newsArtikelList: e),
          );
  }
}

class _CopyWithStubImpl_Query_NewsArtikelFrontpage<TRes>
    implements CopyWith_Query_NewsArtikelFrontpage<TRes> {
  _CopyWithStubImpl_Query_NewsArtikelFrontpage(this._res);

  TRes _res;

  call({
    Query_NewsArtikelFrontpage_topThemaNewsArtikelList? topThemaNewsArtikelList,
    Query_NewsArtikelFrontpage_newsArtikelList? newsArtikelList,
    String? $__typename,
  }) => _res;

  CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes>
  get topThemaNewsArtikelList =>
      CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList.stub(_res);

  CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes>
  get newsArtikelList =>
      CopyWith_Query_NewsArtikelFrontpage_newsArtikelList.stub(_res);
}

const documentNodeQueryNewsArtikelFrontpage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NewsArtikelFrontpage'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'untereinheitenIds')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'JSON'),
              isNonNull: false,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'JSON'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'ordinal')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
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
            name: NameNode(value: 'newsArtikelList'),
            alias: NameNode(value: 'topThemaNewsArtikelList'),
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
                    ObjectFieldNode(
                      name: NameNode(value: 'ordinal'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'equals'),
                            value: VariableNode(
                              name: NameNode(value: 'ordinal'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'OR'),
                      value: ListValueNode(
                        values: [
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'untereinheit'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'in'),
                                      value: VariableNode(
                                        name: NameNode(
                                          value: 'untereinheitenIds',
                                        ),
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
                                name: NameNode(value: 'untereinheit'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'exists'),
                                      value: BooleanValueNode(value: false),
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
                name: NameNode(value: 'sort'),
                value: StringValueNode(value: '-datum', isBlock: false),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '1'),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'NewsArtikelInfo'),
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
                  name: NameNode(value: 'hasNextPage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'page'),
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
            name: NameNode(value: 'newsArtikelList'),
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
                    ObjectFieldNode(
                      name: NameNode(value: 'ordinal'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'not_equals'),
                            value: VariableNode(
                              name: NameNode(value: 'ordinal'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'OR'),
                      value: ListValueNode(
                        values: [
                          ObjectValueNode(
                            fields: [
                              ObjectFieldNode(
                                name: NameNode(value: 'untereinheit'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'in'),
                                      value: VariableNode(
                                        name: NameNode(
                                          value: 'untereinheitenIds',
                                        ),
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
                                name: NameNode(value: 'untereinheit'),
                                value: ObjectValueNode(
                                  fields: [
                                    ObjectFieldNode(
                                      name: NameNode(value: 'exists'),
                                      value: BooleanValueNode(value: false),
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
                name: NameNode(value: 'sort'),
                value: StringValueNode(value: '-datum', isBlock: false),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'NewsArtikelInfo'),
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
                  name: NameNode(value: 'hasNextPage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'page'),
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
    fragmentDefinitionNewsArtikelInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
  ],
);
Query_NewsArtikelFrontpage _parserFn_Query_NewsArtikelFrontpage(
  Map<String, dynamic> data,
) => Query_NewsArtikelFrontpage.fromJson(data);
typedef OnQueryComplete_Query_NewsArtikelFrontpage =
    FutureOr<void> Function(Map<String, dynamic>?, Query_NewsArtikelFrontpage?);

class Options_Query_NewsArtikelFrontpage
    extends graphql.QueryOptions<Query_NewsArtikelFrontpage> {
  Options_Query_NewsArtikelFrontpage({
    String? operationName,
    required Variables_Query_NewsArtikelFrontpage variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikelFrontpage? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_NewsArtikelFrontpage? onComplete,
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
                     : _parserFn_Query_NewsArtikelFrontpage(data),
               ),
         onError: onError,
         document: documentNodeQueryNewsArtikelFrontpage,
         parserFn: _parserFn_Query_NewsArtikelFrontpage,
       );

  final OnQueryComplete_Query_NewsArtikelFrontpage? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_NewsArtikelFrontpage
    extends graphql.WatchQueryOptions<Query_NewsArtikelFrontpage> {
  WatchOptions_Query_NewsArtikelFrontpage({
    String? operationName,
    required Variables_Query_NewsArtikelFrontpage variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikelFrontpage? typedOptimisticResult,
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
         document: documentNodeQueryNewsArtikelFrontpage,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_NewsArtikelFrontpage,
       );
}

class FetchMoreOptions_Query_NewsArtikelFrontpage
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_NewsArtikelFrontpage({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_NewsArtikelFrontpage variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryNewsArtikelFrontpage,
       );
}

extension ClientExtension_Query_NewsArtikelFrontpage on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_NewsArtikelFrontpage>>
  query_NewsArtikelFrontpage(
    Options_Query_NewsArtikelFrontpage options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_NewsArtikelFrontpage>
  watchQuery_NewsArtikelFrontpage(
    WatchOptions_Query_NewsArtikelFrontpage options,
  ) => this.watchQuery(options);

  void writeQuery_NewsArtikelFrontpage({
    required Query_NewsArtikelFrontpage data,
    required Variables_Query_NewsArtikelFrontpage variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryNewsArtikelFrontpage,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_NewsArtikelFrontpage? readQuery_NewsArtikelFrontpage({
    required Variables_Query_NewsArtikelFrontpage variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryNewsArtikelFrontpage,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_NewsArtikelFrontpage.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_NewsArtikelFrontpage>
useQuery_NewsArtikelFrontpage(Options_Query_NewsArtikelFrontpage options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_NewsArtikelFrontpage>
useWatchQuery_NewsArtikelFrontpage(
  WatchOptions_Query_NewsArtikelFrontpage options,
) => graphql_flutter.useWatchQuery(options);

class Query_NewsArtikelFrontpage_Widget
    extends graphql_flutter.Query<Query_NewsArtikelFrontpage> {
  Query_NewsArtikelFrontpage_Widget({
    widgets.Key? key,
    required Options_Query_NewsArtikelFrontpage options,
    required graphql_flutter.QueryBuilder<Query_NewsArtikelFrontpage> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_NewsArtikelFrontpage_topThemaNewsArtikelList {
  Query_NewsArtikelFrontpage_topThemaNewsArtikelList({
    required this.docs,
    required this.hasNextPage,
    required this.page,
    this.$__typename = 'NewsArtikels',
  });

  factory Query_NewsArtikelFrontpage_topThemaNewsArtikelList.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$hasNextPage = json['hasNextPage'];
    final l$page = json['page'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Fragment_NewsArtikelInfo.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      hasNextPage: (l$hasNextPage as bool),
      page: (l$page as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_NewsArtikelInfo> docs;

  final bool hasNextPage;

  final int page;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$page = page;
    _resultData['page'] = l$page;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$hasNextPage = hasNextPage;
    final l$page = page;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$hasNextPage,
      l$page,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikelFrontpage_topThemaNewsArtikelList ||
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
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
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

extension UtilityExtension_Query_NewsArtikelFrontpage_topThemaNewsArtikelList
    on Query_NewsArtikelFrontpage_topThemaNewsArtikelList {
  CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<
    Query_NewsArtikelFrontpage_topThemaNewsArtikelList
  >
  get copyWith => CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<
  TRes
> {
  factory CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
    Query_NewsArtikelFrontpage_topThemaNewsArtikelList instance,
    TRes Function(Query_NewsArtikelFrontpage_topThemaNewsArtikelList) then,
  ) = _CopyWithImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList;

  factory CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList;

  TRes call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  });
  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes>
    implements
        CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes> {
  _CopyWithImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
    this._instance,
    this._then,
  );

  final Query_NewsArtikelFrontpage_topThemaNewsArtikelList _instance;

  final TRes Function(Query_NewsArtikelFrontpage_topThemaNewsArtikelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? docs = _undefined,
    Object? hasNextPage = _undefined,
    Object? page = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
      docs: docs == _undefined || docs == null
          ? _instance.docs
          : (docs as List<Fragment_NewsArtikelInfo>),
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      page: page == _undefined || page == null ? _instance.page : (page as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map((e) => CopyWith_Fragment_NewsArtikelInfo(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes>
    implements
        CopyWith_Query_NewsArtikelFrontpage_topThemaNewsArtikelList<TRes> {
  _CopyWithStubImpl_Query_NewsArtikelFrontpage_topThemaNewsArtikelList(
    this._res,
  );

  TRes _res;

  call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_NewsArtikelFrontpage_newsArtikelList {
  Query_NewsArtikelFrontpage_newsArtikelList({
    required this.docs,
    required this.hasNextPage,
    required this.page,
    this.$__typename = 'NewsArtikels',
  });

  factory Query_NewsArtikelFrontpage_newsArtikelList.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$docs = json['docs'];
    final l$hasNextPage = json['hasNextPage'];
    final l$page = json['page'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikelFrontpage_newsArtikelList(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) =>
                Fragment_NewsArtikelInfo.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      hasNextPage: (l$hasNextPage as bool),
      page: (l$page as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_NewsArtikelInfo> docs;

  final bool hasNextPage;

  final int page;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$docs = docs;
    _resultData['docs'] = l$docs.map((e) => e.toJson()).toList();
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$page = page;
    _resultData['page'] = l$page;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$docs = docs;
    final l$hasNextPage = hasNextPage;
    final l$page = page;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$docs.map((v) => v)),
      l$hasNextPage,
      l$page,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikelFrontpage_newsArtikelList ||
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
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (l$page != lOther$page) {
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

extension UtilityExtension_Query_NewsArtikelFrontpage_newsArtikelList
    on Query_NewsArtikelFrontpage_newsArtikelList {
  CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<
    Query_NewsArtikelFrontpage_newsArtikelList
  >
  get copyWith =>
      CopyWith_Query_NewsArtikelFrontpage_newsArtikelList(this, (i) => i);
}

abstract class CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes> {
  factory CopyWith_Query_NewsArtikelFrontpage_newsArtikelList(
    Query_NewsArtikelFrontpage_newsArtikelList instance,
    TRes Function(Query_NewsArtikelFrontpage_newsArtikelList) then,
  ) = _CopyWithImpl_Query_NewsArtikelFrontpage_newsArtikelList;

  factory CopyWith_Query_NewsArtikelFrontpage_newsArtikelList.stub(TRes res) =
      _CopyWithStubImpl_Query_NewsArtikelFrontpage_newsArtikelList;

  TRes call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  });
  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_NewsArtikelFrontpage_newsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes> {
  _CopyWithImpl_Query_NewsArtikelFrontpage_newsArtikelList(
    this._instance,
    this._then,
  );

  final Query_NewsArtikelFrontpage_newsArtikelList _instance;

  final TRes Function(Query_NewsArtikelFrontpage_newsArtikelList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? docs = _undefined,
    Object? hasNextPage = _undefined,
    Object? page = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikelFrontpage_newsArtikelList(
      docs: docs == _undefined || docs == null
          ? _instance.docs
          : (docs as List<Fragment_NewsArtikelInfo>),
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      page: page == _undefined || page == null ? _instance.page : (page as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<Fragment_NewsArtikelInfo> Function(
      Iterable<CopyWith_Fragment_NewsArtikelInfo<Fragment_NewsArtikelInfo>>,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map((e) => CopyWith_Fragment_NewsArtikelInfo(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_NewsArtikelFrontpage_newsArtikelList<TRes>
    implements CopyWith_Query_NewsArtikelFrontpage_newsArtikelList<TRes> {
  _CopyWithStubImpl_Query_NewsArtikelFrontpage_newsArtikelList(this._res);

  TRes _res;

  call({
    List<Fragment_NewsArtikelInfo>? docs,
    bool? hasNextPage,
    int? page,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Variables_Query_NewsArtikel {
  factory Variables_Query_NewsArtikel({required String id}) =>
      Variables_Query_NewsArtikel._({r'id': id});

  Variables_Query_NewsArtikel._(this._$data);

  factory Variables_Query_NewsArtikel.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_NewsArtikel._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_NewsArtikel<Variables_Query_NewsArtikel>
  get copyWith => CopyWith_Variables_Query_NewsArtikel(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_NewsArtikel ||
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

abstract class CopyWith_Variables_Query_NewsArtikel<TRes> {
  factory CopyWith_Variables_Query_NewsArtikel(
    Variables_Query_NewsArtikel instance,
    TRes Function(Variables_Query_NewsArtikel) then,
  ) = _CopyWithImpl_Variables_Query_NewsArtikel;

  factory CopyWith_Variables_Query_NewsArtikel.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_NewsArtikel;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_NewsArtikel<TRes>
    implements CopyWith_Variables_Query_NewsArtikel<TRes> {
  _CopyWithImpl_Variables_Query_NewsArtikel(this._instance, this._then);

  final Variables_Query_NewsArtikel _instance;

  final TRes Function(Variables_Query_NewsArtikel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_NewsArtikel._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_NewsArtikel<TRes>
    implements CopyWith_Variables_Query_NewsArtikel<TRes> {
  _CopyWithStubImpl_Variables_Query_NewsArtikel(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_NewsArtikel {
  Query_NewsArtikel({this.newsArtikel, this.$__typename = 'Query'});

  factory Query_NewsArtikel.fromJson(Map<String, dynamic> json) {
    final l$newsArtikel = json['newsArtikel'];
    final l$$__typename = json['__typename'];
    return Query_NewsArtikel(
      newsArtikel: l$newsArtikel == null
          ? null
          : Fragment_NewsArtikel.fromJson(
              (l$newsArtikel as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_NewsArtikel? newsArtikel;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$newsArtikel = newsArtikel;
    _resultData['newsArtikel'] = l$newsArtikel?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$newsArtikel = newsArtikel;
    final l$$__typename = $__typename;
    return Object.hashAll([l$newsArtikel, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_NewsArtikel || runtimeType != other.runtimeType) {
      return false;
    }
    final l$newsArtikel = newsArtikel;
    final lOther$newsArtikel = other.newsArtikel;
    if (l$newsArtikel != lOther$newsArtikel) {
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

extension UtilityExtension_Query_NewsArtikel on Query_NewsArtikel {
  CopyWith_Query_NewsArtikel<Query_NewsArtikel> get copyWith =>
      CopyWith_Query_NewsArtikel(this, (i) => i);
}

abstract class CopyWith_Query_NewsArtikel<TRes> {
  factory CopyWith_Query_NewsArtikel(
    Query_NewsArtikel instance,
    TRes Function(Query_NewsArtikel) then,
  ) = _CopyWithImpl_Query_NewsArtikel;

  factory CopyWith_Query_NewsArtikel.stub(TRes res) =
      _CopyWithStubImpl_Query_NewsArtikel;

  TRes call({Fragment_NewsArtikel? newsArtikel, String? $__typename});
  CopyWith_Fragment_NewsArtikel<TRes> get newsArtikel;
}

class _CopyWithImpl_Query_NewsArtikel<TRes>
    implements CopyWith_Query_NewsArtikel<TRes> {
  _CopyWithImpl_Query_NewsArtikel(this._instance, this._then);

  final Query_NewsArtikel _instance;

  final TRes Function(Query_NewsArtikel) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? newsArtikel = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_NewsArtikel(
      newsArtikel: newsArtikel == _undefined
          ? _instance.newsArtikel
          : (newsArtikel as Fragment_NewsArtikel?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_NewsArtikel<TRes> get newsArtikel {
    final local$newsArtikel = _instance.newsArtikel;
    return local$newsArtikel == null
        ? CopyWith_Fragment_NewsArtikel.stub(_then(_instance))
        : CopyWith_Fragment_NewsArtikel(
            local$newsArtikel,
            (e) => call(newsArtikel: e),
          );
  }
}

class _CopyWithStubImpl_Query_NewsArtikel<TRes>
    implements CopyWith_Query_NewsArtikel<TRes> {
  _CopyWithStubImpl_Query_NewsArtikel(this._res);

  TRes _res;

  call({Fragment_NewsArtikel? newsArtikel, String? $__typename}) => _res;

  CopyWith_Fragment_NewsArtikel<TRes> get newsArtikel =>
      CopyWith_Fragment_NewsArtikel.stub(_res);
}

const documentNodeQueryNewsArtikel = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'NewsArtikel'),
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
            name: NameNode(value: 'newsArtikel'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'NewsArtikel'),
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
    fragmentDefinitionNewsArtikel,
    fragmentDefinitionNewsArtikelInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
    fragmentDefinitionRichTextBlock,
    fragmentDefinitionImageBlockVeranstaltungsmedien,
  ],
);
Query_NewsArtikel _parserFn_Query_NewsArtikel(Map<String, dynamic> data) =>
    Query_NewsArtikel.fromJson(data);
typedef OnQueryComplete_Query_NewsArtikel =
    FutureOr<void> Function(Map<String, dynamic>?, Query_NewsArtikel?);

class Options_Query_NewsArtikel
    extends graphql.QueryOptions<Query_NewsArtikel> {
  Options_Query_NewsArtikel({
    String? operationName,
    required Variables_Query_NewsArtikel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikel? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_NewsArtikel? onComplete,
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
                 data == null ? null : _parserFn_Query_NewsArtikel(data),
               ),
         onError: onError,
         document: documentNodeQueryNewsArtikel,
         parserFn: _parserFn_Query_NewsArtikel,
       );

  final OnQueryComplete_Query_NewsArtikel? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_NewsArtikel
    extends graphql.WatchQueryOptions<Query_NewsArtikel> {
  WatchOptions_Query_NewsArtikel({
    String? operationName,
    required Variables_Query_NewsArtikel variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_NewsArtikel? typedOptimisticResult,
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
         document: documentNodeQueryNewsArtikel,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_NewsArtikel,
       );
}

class FetchMoreOptions_Query_NewsArtikel extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_NewsArtikel({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_NewsArtikel variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryNewsArtikel,
       );
}

extension ClientExtension_Query_NewsArtikel on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_NewsArtikel>> query_NewsArtikel(
    Options_Query_NewsArtikel options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_NewsArtikel> watchQuery_NewsArtikel(
    WatchOptions_Query_NewsArtikel options,
  ) => this.watchQuery(options);

  void writeQuery_NewsArtikel({
    required Query_NewsArtikel data,
    required Variables_Query_NewsArtikel variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryNewsArtikel),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_NewsArtikel? readQuery_NewsArtikel({
    required Variables_Query_NewsArtikel variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryNewsArtikel),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_NewsArtikel.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_NewsArtikel> useQuery_NewsArtikel(
  Options_Query_NewsArtikel options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_NewsArtikel> useWatchQuery_NewsArtikel(
  WatchOptions_Query_NewsArtikel options,
) => graphql_flutter.useWatchQuery(options);

class Query_NewsArtikel_Widget
    extends graphql_flutter.Query<Query_NewsArtikel> {
  Query_NewsArtikel_Widget({
    widgets.Key? key,
    required Options_Query_NewsArtikel options,
    required graphql_flutter.QueryBuilder<Query_NewsArtikel> builder,
  }) : super(key: key, options: options, builder: builder);
}
