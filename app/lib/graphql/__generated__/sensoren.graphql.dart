import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_SensorWithIcon {
  Fragment_SensorWithIcon({
    this.icon,
    this.felder,
    this.$__typename = 'Sensoren',
  });

  factory Fragment_SensorWithIcon.fromJson(Map<String, dynamic> json) {
    final l$icon = json['icon'];
    final l$felder = json['felder'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorWithIcon(
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      felder: (l$felder as List<dynamic>?)
          ?.map(
            (e) => Fragment_SensorWithIcon_felder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_PoiIcon? icon;

  final List<Fragment_SensorWithIcon_felder>? felder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
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
    final l$icon = icon;
    final l$felder = felder;
    final l$$__typename = $__typename;
    return Object.hashAll([
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
    if (other is! Fragment_SensorWithIcon || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_SensorWithIcon on Fragment_SensorWithIcon {
  CopyWith_Fragment_SensorWithIcon<Fragment_SensorWithIcon> get copyWith =>
      CopyWith_Fragment_SensorWithIcon(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorWithIcon<TRes> {
  factory CopyWith_Fragment_SensorWithIcon(
    Fragment_SensorWithIcon instance,
    TRes Function(Fragment_SensorWithIcon) then,
  ) = _CopyWithImpl_Fragment_SensorWithIcon;

  factory CopyWith_Fragment_SensorWithIcon.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorWithIcon;

  TRes call({
    Fragment_PoiIcon? icon,
    List<Fragment_SensorWithIcon_felder>? felder,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  TRes felder(
    Iterable<Fragment_SensorWithIcon_felder>? Function(
      Iterable<
        CopyWith_Fragment_SensorWithIcon_felder<Fragment_SensorWithIcon_felder>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_SensorWithIcon<TRes>
    implements CopyWith_Fragment_SensorWithIcon<TRes> {
  _CopyWithImpl_Fragment_SensorWithIcon(this._instance, this._then);

  final Fragment_SensorWithIcon _instance;

  final TRes Function(Fragment_SensorWithIcon) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? icon = _undefined,
    Object? felder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorWithIcon(
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      felder: felder == _undefined
          ? _instance.felder
          : (felder as List<Fragment_SensorWithIcon_felder>?),
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
    Iterable<Fragment_SensorWithIcon_felder>? Function(
      Iterable<
        CopyWith_Fragment_SensorWithIcon_felder<Fragment_SensorWithIcon_felder>
      >?,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder?.map(
        (e) => CopyWith_Fragment_SensorWithIcon_felder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_SensorWithIcon<TRes>
    implements CopyWith_Fragment_SensorWithIcon<TRes> {
  _CopyWithStubImpl_Fragment_SensorWithIcon(this._res);

  TRes _res;

  call({
    Fragment_PoiIcon? icon,
    List<Fragment_SensorWithIcon_felder>? felder,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  felder(_fn) => _res;
}

const fragmentDefinitionSensorWithIcon = FragmentDefinitionNode(
  name: NameNode(value: 'SensorWithIcon'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Sensoren'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
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
);
const documentNodeFragmentSensorWithIcon = DocumentNode(
  definitions: [fragmentDefinitionSensorWithIcon, fragmentDefinitionPoiIcon],
);

extension ClientExtension_Fragment_SensorWithIcon on graphql.GraphQLClient {
  void writeFragment_SensorWithIcon({
    required Fragment_SensorWithIcon data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SensorWithIcon',
        document: documentNodeFragmentSensorWithIcon,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_SensorWithIcon? readFragment_SensorWithIcon({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SensorWithIcon',
          document: documentNodeFragmentSensorWithIcon,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_SensorWithIcon.fromJson(result);
  }
}

class Fragment_SensorWithIcon_felder {
  Fragment_SensorWithIcon_felder({
    this.id,
    this.werteart,
    this.$__typename = 'Sensoren_Felder',
  });

  factory Fragment_SensorWithIcon_felder.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$werteart = json['werteart'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorWithIcon_felder(
      id: (l$id as String?),
      werteart: l$werteart == null
          ? null
          : Fragment_SensorWithIcon_felder_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final Fragment_SensorWithIcon_felder_werteart? werteart;

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
    if (other is! Fragment_SensorWithIcon_felder ||
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

extension UtilityExtension_Fragment_SensorWithIcon_felder
    on Fragment_SensorWithIcon_felder {
  CopyWith_Fragment_SensorWithIcon_felder<Fragment_SensorWithIcon_felder>
  get copyWith => CopyWith_Fragment_SensorWithIcon_felder(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorWithIcon_felder<TRes> {
  factory CopyWith_Fragment_SensorWithIcon_felder(
    Fragment_SensorWithIcon_felder instance,
    TRes Function(Fragment_SensorWithIcon_felder) then,
  ) = _CopyWithImpl_Fragment_SensorWithIcon_felder;

  factory CopyWith_Fragment_SensorWithIcon_felder.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorWithIcon_felder;

  TRes call({
    String? id,
    Fragment_SensorWithIcon_felder_werteart? werteart,
    String? $__typename,
  });
  CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> get werteart;
}

class _CopyWithImpl_Fragment_SensorWithIcon_felder<TRes>
    implements CopyWith_Fragment_SensorWithIcon_felder<TRes> {
  _CopyWithImpl_Fragment_SensorWithIcon_felder(this._instance, this._then);

  final Fragment_SensorWithIcon_felder _instance;

  final TRes Function(Fragment_SensorWithIcon_felder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? werteart = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorWithIcon_felder(
      id: id == _undefined ? _instance.id : (id as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Fragment_SensorWithIcon_felder_werteart?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Fragment_SensorWithIcon_felder_werteart.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_SensorWithIcon_felder_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_SensorWithIcon_felder<TRes>
    implements CopyWith_Fragment_SensorWithIcon_felder<TRes> {
  _CopyWithStubImpl_Fragment_SensorWithIcon_felder(this._res);

  TRes _res;

  call({
    String? id,
    Fragment_SensorWithIcon_felder_werteart? werteart,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> get werteart =>
      CopyWith_Fragment_SensorWithIcon_felder_werteart.stub(_res);
}

class Fragment_SensorWithIcon_felder_werteart {
  Fragment_SensorWithIcon_felder_werteart({
    required this.id,
    this.icon,
    this.$__typename = 'SensorArt',
  });

  factory Fragment_SensorWithIcon_felder_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorWithIcon_felder_werteart(
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
    if (other is! Fragment_SensorWithIcon_felder_werteart ||
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

extension UtilityExtension_Fragment_SensorWithIcon_felder_werteart
    on Fragment_SensorWithIcon_felder_werteart {
  CopyWith_Fragment_SensorWithIcon_felder_werteart<
    Fragment_SensorWithIcon_felder_werteart
  >
  get copyWith =>
      CopyWith_Fragment_SensorWithIcon_felder_werteart(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> {
  factory CopyWith_Fragment_SensorWithIcon_felder_werteart(
    Fragment_SensorWithIcon_felder_werteart instance,
    TRes Function(Fragment_SensorWithIcon_felder_werteart) then,
  ) = _CopyWithImpl_Fragment_SensorWithIcon_felder_werteart;

  factory CopyWith_Fragment_SensorWithIcon_felder_werteart.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorWithIcon_felder_werteart;

  TRes call({String? id, Fragment_PoiIcon? icon, String? $__typename});
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Fragment_SensorWithIcon_felder_werteart<TRes>
    implements CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> {
  _CopyWithImpl_Fragment_SensorWithIcon_felder_werteart(
    this._instance,
    this._then,
  );

  final Fragment_SensorWithIcon_felder_werteart _instance;

  final TRes Function(Fragment_SensorWithIcon_felder_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorWithIcon_felder_werteart(
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

class _CopyWithStubImpl_Fragment_SensorWithIcon_felder_werteart<TRes>
    implements CopyWith_Fragment_SensorWithIcon_felder_werteart<TRes> {
  _CopyWithStubImpl_Fragment_SensorWithIcon_felder_werteart(this._res);

  TRes _res;

  call({String? id, Fragment_PoiIcon? icon, String? $__typename}) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}

class Fragment_SensorDangerLevels {
  Fragment_SensorDangerLevels({
    this.grenzwertInfo1,
    this.grenzwertInfo2,
    this.grenzwertInfo3,
    this.grenzwertInfo4,
    this.pegelGefahrenstufe,
    this.glaetteAlarmLevel,
    this.$__typename = 'Sensoren',
  });

  factory Fragment_SensorDangerLevels.fromJson(Map<String, dynamic> json) {
    final l$grenzwertInfo1 = json['grenzwertInfo1'];
    final l$grenzwertInfo2 = json['grenzwertInfo2'];
    final l$grenzwertInfo3 = json['grenzwertInfo3'];
    final l$grenzwertInfo4 = json['grenzwertInfo4'];
    final l$pegelGefahrenstufe = json['pegelGefahrenstufe'];
    final l$glaetteAlarmLevel = json['glaetteAlarmLevel'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorDangerLevels(
      grenzwertInfo1: (l$grenzwertInfo1 as num?)?.toDouble(),
      grenzwertInfo2: (l$grenzwertInfo2 as num?)?.toDouble(),
      grenzwertInfo3: (l$grenzwertInfo3 as num?)?.toDouble(),
      grenzwertInfo4: (l$grenzwertInfo4 as num?)?.toDouble(),
      pegelGefahrenstufe: (l$pegelGefahrenstufe as String?),
      glaetteAlarmLevel: (l$glaetteAlarmLevel as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final double? grenzwertInfo1;

  final double? grenzwertInfo2;

  final double? grenzwertInfo3;

  final double? grenzwertInfo4;

  final String? pegelGefahrenstufe;

  final String? glaetteAlarmLevel;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$grenzwertInfo1 = grenzwertInfo1;
    _resultData['grenzwertInfo1'] = l$grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    _resultData['grenzwertInfo2'] = l$grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    _resultData['grenzwertInfo3'] = l$grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    _resultData['grenzwertInfo4'] = l$grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    _resultData['pegelGefahrenstufe'] = l$pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    _resultData['glaetteAlarmLevel'] = l$glaetteAlarmLevel;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$grenzwertInfo1 = grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$grenzwertInfo1,
      l$grenzwertInfo2,
      l$grenzwertInfo3,
      l$grenzwertInfo4,
      l$pegelGefahrenstufe,
      l$glaetteAlarmLevel,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorDangerLevels ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$grenzwertInfo1 = grenzwertInfo1;
    final lOther$grenzwertInfo1 = other.grenzwertInfo1;
    if (l$grenzwertInfo1 != lOther$grenzwertInfo1) {
      return false;
    }
    final l$grenzwertInfo2 = grenzwertInfo2;
    final lOther$grenzwertInfo2 = other.grenzwertInfo2;
    if (l$grenzwertInfo2 != lOther$grenzwertInfo2) {
      return false;
    }
    final l$grenzwertInfo3 = grenzwertInfo3;
    final lOther$grenzwertInfo3 = other.grenzwertInfo3;
    if (l$grenzwertInfo3 != lOther$grenzwertInfo3) {
      return false;
    }
    final l$grenzwertInfo4 = grenzwertInfo4;
    final lOther$grenzwertInfo4 = other.grenzwertInfo4;
    if (l$grenzwertInfo4 != lOther$grenzwertInfo4) {
      return false;
    }
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final lOther$pegelGefahrenstufe = other.pegelGefahrenstufe;
    if (l$pegelGefahrenstufe != lOther$pegelGefahrenstufe) {
      return false;
    }
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    final lOther$glaetteAlarmLevel = other.glaetteAlarmLevel;
    if (l$glaetteAlarmLevel != lOther$glaetteAlarmLevel) {
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

extension UtilityExtension_Fragment_SensorDangerLevels
    on Fragment_SensorDangerLevels {
  CopyWith_Fragment_SensorDangerLevels<Fragment_SensorDangerLevels>
  get copyWith => CopyWith_Fragment_SensorDangerLevels(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorDangerLevels<TRes> {
  factory CopyWith_Fragment_SensorDangerLevels(
    Fragment_SensorDangerLevels instance,
    TRes Function(Fragment_SensorDangerLevels) then,
  ) = _CopyWithImpl_Fragment_SensorDangerLevels;

  factory CopyWith_Fragment_SensorDangerLevels.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorDangerLevels;

  TRes call({
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SensorDangerLevels<TRes>
    implements CopyWith_Fragment_SensorDangerLevels<TRes> {
  _CopyWithImpl_Fragment_SensorDangerLevels(this._instance, this._then);

  final Fragment_SensorDangerLevels _instance;

  final TRes Function(Fragment_SensorDangerLevels) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? grenzwertInfo1 = _undefined,
    Object? grenzwertInfo2 = _undefined,
    Object? grenzwertInfo3 = _undefined,
    Object? grenzwertInfo4 = _undefined,
    Object? pegelGefahrenstufe = _undefined,
    Object? glaetteAlarmLevel = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorDangerLevels(
      grenzwertInfo1: grenzwertInfo1 == _undefined
          ? _instance.grenzwertInfo1
          : (grenzwertInfo1 as double?),
      grenzwertInfo2: grenzwertInfo2 == _undefined
          ? _instance.grenzwertInfo2
          : (grenzwertInfo2 as double?),
      grenzwertInfo3: grenzwertInfo3 == _undefined
          ? _instance.grenzwertInfo3
          : (grenzwertInfo3 as double?),
      grenzwertInfo4: grenzwertInfo4 == _undefined
          ? _instance.grenzwertInfo4
          : (grenzwertInfo4 as double?),
      pegelGefahrenstufe: pegelGefahrenstufe == _undefined
          ? _instance.pegelGefahrenstufe
          : (pegelGefahrenstufe as String?),
      glaetteAlarmLevel: glaetteAlarmLevel == _undefined
          ? _instance.glaetteAlarmLevel
          : (glaetteAlarmLevel as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorDangerLevels<TRes>
    implements CopyWith_Fragment_SensorDangerLevels<TRes> {
  _CopyWithStubImpl_Fragment_SensorDangerLevels(this._res);

  TRes _res;

  call({
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionSensorDangerLevels = FragmentDefinitionNode(
  name: NameNode(value: 'SensorDangerLevels'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Sensoren'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'grenzwertInfo1'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'grenzwertInfo2'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'grenzwertInfo3'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'grenzwertInfo4'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'pegelGefahrenstufe'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'glaetteAlarmLevel'),
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
const documentNodeFragmentSensorDangerLevels = DocumentNode(
  definitions: [fragmentDefinitionSensorDangerLevels],
);

extension ClientExtension_Fragment_SensorDangerLevels on graphql.GraphQLClient {
  void writeFragment_SensorDangerLevels({
    required Fragment_SensorDangerLevels data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SensorDangerLevels',
        document: documentNodeFragmentSensorDangerLevels,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_SensorDangerLevels? readFragment_SensorDangerLevels({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SensorDangerLevels',
          document: documentNodeFragmentSensorDangerLevels,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_SensorDangerLevels.fromJson(result);
  }
}

class Fragment_SensorFieldReading {
  Fragment_SensorFieldReading({
    this.id,
    this.currentValue,
    this.werteart,
    required this.trendHistorie,
    this.$__typename = 'Sensoren_Felder',
  });

  factory Fragment_SensorFieldReading.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$currentValue = json['currentValue'];
    final l$werteart = json['werteart'];
    final l$trendHistorie = json['trendHistorie'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading(
      id: (l$id as String?),
      currentValue: (l$currentValue as String?),
      werteart: l$werteart == null
          ? null
          : Fragment_SensorFieldReading_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      trendHistorie: (l$trendHistorie as List<dynamic>)
          .map(
            (e) => Fragment_SensorFieldReading_trendHistorie.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? currentValue;

  final Fragment_SensorFieldReading_werteart? werteart;

  final List<Fragment_SensorFieldReading_trendHistorie> trendHistorie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currentValue = currentValue;
    _resultData['currentValue'] = l$currentValue;
    final l$werteart = werteart;
    _resultData['werteart'] = l$werteart?.toJson();
    final l$trendHistorie = trendHistorie;
    _resultData['trendHistorie'] = l$trendHistorie
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$currentValue = currentValue;
    final l$werteart = werteart;
    final l$trendHistorie = trendHistorie;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$currentValue,
      l$werteart,
      Object.hashAll(l$trendHistorie.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$currentValue = currentValue;
    final lOther$currentValue = other.currentValue;
    if (l$currentValue != lOther$currentValue) {
      return false;
    }
    final l$werteart = werteart;
    final lOther$werteart = other.werteart;
    if (l$werteart != lOther$werteart) {
      return false;
    }
    final l$trendHistorie = trendHistorie;
    final lOther$trendHistorie = other.trendHistorie;
    if (l$trendHistorie.length != lOther$trendHistorie.length) {
      return false;
    }
    for (int i = 0; i < l$trendHistorie.length; i++) {
      final l$trendHistorie$entry = l$trendHistorie[i];
      final lOther$trendHistorie$entry = lOther$trendHistorie[i];
      if (l$trendHistorie$entry != lOther$trendHistorie$entry) {
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

extension UtilityExtension_Fragment_SensorFieldReading
    on Fragment_SensorFieldReading {
  CopyWith_Fragment_SensorFieldReading<Fragment_SensorFieldReading>
  get copyWith => CopyWith_Fragment_SensorFieldReading(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorFieldReading<TRes> {
  factory CopyWith_Fragment_SensorFieldReading(
    Fragment_SensorFieldReading instance,
    TRes Function(Fragment_SensorFieldReading) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading;

  factory CopyWith_Fragment_SensorFieldReading.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorFieldReading;

  TRes call({
    String? id,
    String? currentValue,
    Fragment_SensorFieldReading_werteart? werteart,
    List<Fragment_SensorFieldReading_trendHistorie>? trendHistorie,
    String? $__typename,
  });
  CopyWith_Fragment_SensorFieldReading_werteart<TRes> get werteart;
  TRes trendHistorie(
    Iterable<Fragment_SensorFieldReading_trendHistorie> Function(
      Iterable<
        CopyWith_Fragment_SensorFieldReading_trendHistorie<
          Fragment_SensorFieldReading_trendHistorie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_SensorFieldReading<TRes>
    implements CopyWith_Fragment_SensorFieldReading<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading(this._instance, this._then);

  final Fragment_SensorFieldReading _instance;

  final TRes Function(Fragment_SensorFieldReading) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? currentValue = _undefined,
    Object? werteart = _undefined,
    Object? trendHistorie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading(
      id: id == _undefined ? _instance.id : (id as String?),
      currentValue: currentValue == _undefined
          ? _instance.currentValue
          : (currentValue as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Fragment_SensorFieldReading_werteart?),
      trendHistorie: trendHistorie == _undefined || trendHistorie == null
          ? _instance.trendHistorie
          : (trendHistorie as List<Fragment_SensorFieldReading_trendHistorie>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_SensorFieldReading_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Fragment_SensorFieldReading_werteart.stub(_then(_instance))
        : CopyWith_Fragment_SensorFieldReading_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }

  TRes trendHistorie(
    Iterable<Fragment_SensorFieldReading_trendHistorie> Function(
      Iterable<
        CopyWith_Fragment_SensorFieldReading_trendHistorie<
          Fragment_SensorFieldReading_trendHistorie
        >
      >,
    )
    _fn,
  ) => call(
    trendHistorie: _fn(
      _instance.trendHistorie.map(
        (e) => CopyWith_Fragment_SensorFieldReading_trendHistorie(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading<TRes>
    implements CopyWith_Fragment_SensorFieldReading<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading(this._res);

  TRes _res;

  call({
    String? id,
    String? currentValue,
    Fragment_SensorFieldReading_werteart? werteart,
    List<Fragment_SensorFieldReading_trendHistorie>? trendHistorie,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_SensorFieldReading_werteart<TRes> get werteart =>
      CopyWith_Fragment_SensorFieldReading_werteart.stub(_res);

  trendHistorie(_fn) => _res;
}

const fragmentDefinitionSensorFieldReading = FragmentDefinitionNode(
  name: NameNode(value: 'SensorFieldReading'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'Sensoren_Felder'),
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
        name: NameNode(value: 'currentValue'),
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
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'einheit'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'warnstufeText1'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'kurzlabel'),
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
                    name: NameNode(value: 'beschreibung'),
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
              name: NameNode(value: 'warnstufeText2'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'kurzlabel'),
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
                    name: NameNode(value: 'beschreibung'),
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
              name: NameNode(value: 'warnstufeText3'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'kurzlabel'),
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
                    name: NameNode(value: 'beschreibung'),
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
              name: NameNode(value: 'warnstufeText4'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'kurzlabel'),
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
                    name: NameNode(value: 'beschreibung'),
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
        name: NameNode(value: 'historie'),
        alias: NameNode(value: 'trendHistorie'),
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'duration'),
            value: EnumValueNode(name: NameNode(value: 'LAST_DAY')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'time'),
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
const documentNodeFragmentSensorFieldReading = DocumentNode(
  definitions: [fragmentDefinitionSensorFieldReading],
);

extension ClientExtension_Fragment_SensorFieldReading on graphql.GraphQLClient {
  void writeFragment_SensorFieldReading({
    required Fragment_SensorFieldReading data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SensorFieldReading',
        document: documentNodeFragmentSensorFieldReading,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_SensorFieldReading? readFragment_SensorFieldReading({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SensorFieldReading',
          document: documentNodeFragmentSensorFieldReading,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_SensorFieldReading.fromJson(result);
  }
}

class Fragment_SensorFieldReading_werteart {
  Fragment_SensorFieldReading_werteart({
    required this.id,
    required this.name,
    this.einheit,
    this.warnstufeText1,
    this.warnstufeText2,
    this.warnstufeText3,
    this.warnstufeText4,
    this.$__typename = 'SensorArt',
  });

  factory Fragment_SensorFieldReading_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$einheit = json['einheit'];
    final l$warnstufeText1 = json['warnstufeText1'];
    final l$warnstufeText2 = json['warnstufeText2'];
    final l$warnstufeText3 = json['warnstufeText3'];
    final l$warnstufeText4 = json['warnstufeText4'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_werteart(
      id: (l$id as String),
      name: (l$name as String),
      einheit: (l$einheit as String?),
      warnstufeText1: l$warnstufeText1 == null
          ? null
          : Fragment_SensorFieldReading_werteart_warnstufeText1.fromJson(
              (l$warnstufeText1 as Map<String, dynamic>),
            ),
      warnstufeText2: l$warnstufeText2 == null
          ? null
          : Fragment_SensorFieldReading_werteart_warnstufeText2.fromJson(
              (l$warnstufeText2 as Map<String, dynamic>),
            ),
      warnstufeText3: l$warnstufeText3 == null
          ? null
          : Fragment_SensorFieldReading_werteart_warnstufeText3.fromJson(
              (l$warnstufeText3 as Map<String, dynamic>),
            ),
      warnstufeText4: l$warnstufeText4 == null
          ? null
          : Fragment_SensorFieldReading_werteart_warnstufeText4.fromJson(
              (l$warnstufeText4 as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String? einheit;

  final Fragment_SensorFieldReading_werteart_warnstufeText1? warnstufeText1;

  final Fragment_SensorFieldReading_werteart_warnstufeText2? warnstufeText2;

  final Fragment_SensorFieldReading_werteart_warnstufeText3? warnstufeText3;

  final Fragment_SensorFieldReading_werteart_warnstufeText4? warnstufeText4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$einheit = einheit;
    _resultData['einheit'] = l$einheit;
    final l$warnstufeText1 = warnstufeText1;
    _resultData['warnstufeText1'] = l$warnstufeText1?.toJson();
    final l$warnstufeText2 = warnstufeText2;
    _resultData['warnstufeText2'] = l$warnstufeText2?.toJson();
    final l$warnstufeText3 = warnstufeText3;
    _resultData['warnstufeText3'] = l$warnstufeText3?.toJson();
    final l$warnstufeText4 = warnstufeText4;
    _resultData['warnstufeText4'] = l$warnstufeText4?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$einheit = einheit;
    final l$warnstufeText1 = warnstufeText1;
    final l$warnstufeText2 = warnstufeText2;
    final l$warnstufeText3 = warnstufeText3;
    final l$warnstufeText4 = warnstufeText4;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$einheit,
      l$warnstufeText1,
      l$warnstufeText2,
      l$warnstufeText3,
      l$warnstufeText4,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_werteart ||
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
    final l$einheit = einheit;
    final lOther$einheit = other.einheit;
    if (l$einheit != lOther$einheit) {
      return false;
    }
    final l$warnstufeText1 = warnstufeText1;
    final lOther$warnstufeText1 = other.warnstufeText1;
    if (l$warnstufeText1 != lOther$warnstufeText1) {
      return false;
    }
    final l$warnstufeText2 = warnstufeText2;
    final lOther$warnstufeText2 = other.warnstufeText2;
    if (l$warnstufeText2 != lOther$warnstufeText2) {
      return false;
    }
    final l$warnstufeText3 = warnstufeText3;
    final lOther$warnstufeText3 = other.warnstufeText3;
    if (l$warnstufeText3 != lOther$warnstufeText3) {
      return false;
    }
    final l$warnstufeText4 = warnstufeText4;
    final lOther$warnstufeText4 = other.warnstufeText4;
    if (l$warnstufeText4 != lOther$warnstufeText4) {
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

extension UtilityExtension_Fragment_SensorFieldReading_werteart
    on Fragment_SensorFieldReading_werteart {
  CopyWith_Fragment_SensorFieldReading_werteart<
    Fragment_SensorFieldReading_werteart
  >
  get copyWith => CopyWith_Fragment_SensorFieldReading_werteart(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorFieldReading_werteart<TRes> {
  factory CopyWith_Fragment_SensorFieldReading_werteart(
    Fragment_SensorFieldReading_werteart instance,
    TRes Function(Fragment_SensorFieldReading_werteart) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_werteart;

  factory CopyWith_Fragment_SensorFieldReading_werteart.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorFieldReading_werteart;

  TRes call({
    String? id,
    String? name,
    String? einheit,
    Fragment_SensorFieldReading_werteart_warnstufeText1? warnstufeText1,
    Fragment_SensorFieldReading_werteart_warnstufeText2? warnstufeText2,
    Fragment_SensorFieldReading_werteart_warnstufeText3? warnstufeText3,
    Fragment_SensorFieldReading_werteart_warnstufeText4? warnstufeText4,
    String? $__typename,
  });
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes>
  get warnstufeText1;
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes>
  get warnstufeText2;
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes>
  get warnstufeText3;
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes>
  get warnstufeText4;
}

class _CopyWithImpl_Fragment_SensorFieldReading_werteart<TRes>
    implements CopyWith_Fragment_SensorFieldReading_werteart<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_werteart(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_werteart _instance;

  final TRes Function(Fragment_SensorFieldReading_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? einheit = _undefined,
    Object? warnstufeText1 = _undefined,
    Object? warnstufeText2 = _undefined,
    Object? warnstufeText3 = _undefined,
    Object? warnstufeText4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_werteart(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      einheit: einheit == _undefined ? _instance.einheit : (einheit as String?),
      warnstufeText1: warnstufeText1 == _undefined
          ? _instance.warnstufeText1
          : (warnstufeText1
                as Fragment_SensorFieldReading_werteart_warnstufeText1?),
      warnstufeText2: warnstufeText2 == _undefined
          ? _instance.warnstufeText2
          : (warnstufeText2
                as Fragment_SensorFieldReading_werteart_warnstufeText2?),
      warnstufeText3: warnstufeText3 == _undefined
          ? _instance.warnstufeText3
          : (warnstufeText3
                as Fragment_SensorFieldReading_werteart_warnstufeText3?),
      warnstufeText4: warnstufeText4 == _undefined
          ? _instance.warnstufeText4
          : (warnstufeText4
                as Fragment_SensorFieldReading_werteart_warnstufeText4?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes>
  get warnstufeText1 {
    final local$warnstufeText1 = _instance.warnstufeText1;
    return local$warnstufeText1 == null
        ? CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1(
            local$warnstufeText1,
            (e) => call(warnstufeText1: e),
          );
  }

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes>
  get warnstufeText2 {
    final local$warnstufeText2 = _instance.warnstufeText2;
    return local$warnstufeText2 == null
        ? CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2(
            local$warnstufeText2,
            (e) => call(warnstufeText2: e),
          );
  }

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes>
  get warnstufeText3 {
    final local$warnstufeText3 = _instance.warnstufeText3;
    return local$warnstufeText3 == null
        ? CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3(
            local$warnstufeText3,
            (e) => call(warnstufeText3: e),
          );
  }

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes>
  get warnstufeText4 {
    final local$warnstufeText4 = _instance.warnstufeText4;
    return local$warnstufeText4 == null
        ? CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4(
            local$warnstufeText4,
            (e) => call(warnstufeText4: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_werteart<TRes>
    implements CopyWith_Fragment_SensorFieldReading_werteart<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_werteart(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? einheit,
    Fragment_SensorFieldReading_werteart_warnstufeText1? warnstufeText1,
    Fragment_SensorFieldReading_werteart_warnstufeText2? warnstufeText2,
    Fragment_SensorFieldReading_werteart_warnstufeText3? warnstufeText3,
    Fragment_SensorFieldReading_werteart_warnstufeText4? warnstufeText4,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes>
  get warnstufeText1 =>
      CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1.stub(_res);

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes>
  get warnstufeText2 =>
      CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2.stub(_res);

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes>
  get warnstufeText3 =>
      CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3.stub(_res);

  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes>
  get warnstufeText4 =>
      CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4.stub(_res);
}

class Fragment_SensorFieldReading_werteart_warnstufeText1 {
  Fragment_SensorFieldReading_werteart_warnstufeText1({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Fragment_SensorFieldReading_werteart_warnstufeText1.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_werteart_warnstufeText1(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_werteart_warnstufeText1 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SensorFieldReading_werteart_warnstufeText1
    on Fragment_SensorFieldReading_werteart_warnstufeText1 {
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<
    Fragment_SensorFieldReading_werteart_warnstufeText1
  >
  get copyWith => CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<
  TRes
> {
  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1(
    Fragment_SensorFieldReading_werteart_warnstufeText1 instance,
    TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText1) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText1;

  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText1;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText1(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_werteart_warnstufeText1 _instance;

  final TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText1)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_werteart_warnstufeText1(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText1<
  TRes
>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText1<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText1(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Fragment_SensorFieldReading_werteart_warnstufeText2 {
  Fragment_SensorFieldReading_werteart_warnstufeText2({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Fragment_SensorFieldReading_werteart_warnstufeText2.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_werteart_warnstufeText2(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_werteart_warnstufeText2 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SensorFieldReading_werteart_warnstufeText2
    on Fragment_SensorFieldReading_werteart_warnstufeText2 {
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<
    Fragment_SensorFieldReading_werteart_warnstufeText2
  >
  get copyWith => CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<
  TRes
> {
  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2(
    Fragment_SensorFieldReading_werteart_warnstufeText2 instance,
    TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText2) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText2;

  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText2;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText2(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_werteart_warnstufeText2 _instance;

  final TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText2)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_werteart_warnstufeText2(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText2<
  TRes
>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText2<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText2(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Fragment_SensorFieldReading_werteart_warnstufeText3 {
  Fragment_SensorFieldReading_werteart_warnstufeText3({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Fragment_SensorFieldReading_werteart_warnstufeText3.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_werteart_warnstufeText3(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_werteart_warnstufeText3 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SensorFieldReading_werteart_warnstufeText3
    on Fragment_SensorFieldReading_werteart_warnstufeText3 {
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<
    Fragment_SensorFieldReading_werteart_warnstufeText3
  >
  get copyWith => CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<
  TRes
> {
  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3(
    Fragment_SensorFieldReading_werteart_warnstufeText3 instance,
    TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText3) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText3;

  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText3;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText3(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_werteart_warnstufeText3 _instance;

  final TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText3)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_werteart_warnstufeText3(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText3<
  TRes
>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText3<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText3(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Fragment_SensorFieldReading_werteart_warnstufeText4 {
  Fragment_SensorFieldReading_werteart_warnstufeText4({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Fragment_SensorFieldReading_werteart_warnstufeText4.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_werteart_warnstufeText4(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_werteart_warnstufeText4 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_SensorFieldReading_werteart_warnstufeText4
    on Fragment_SensorFieldReading_werteart_warnstufeText4 {
  CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<
    Fragment_SensorFieldReading_werteart_warnstufeText4
  >
  get copyWith => CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<
  TRes
> {
  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4(
    Fragment_SensorFieldReading_werteart_warnstufeText4 instance,
    TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText4) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText4;

  factory CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText4;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_werteart_warnstufeText4(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_werteart_warnstufeText4 _instance;

  final TRes Function(Fragment_SensorFieldReading_werteart_warnstufeText4)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_werteart_warnstufeText4(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText4<
  TRes
>
    implements
        CopyWith_Fragment_SensorFieldReading_werteart_warnstufeText4<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_werteart_warnstufeText4(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Fragment_SensorFieldReading_trendHistorie {
  Fragment_SensorFieldReading_trendHistorie({
    required this.time,
    required this.value,
    this.$__typename = 'SensorHistorieEintrag',
  });

  factory Fragment_SensorFieldReading_trendHistorie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$time = json['time'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment_SensorFieldReading_trendHistorie(
      time: DateTime.parse((l$time as String)),
      value: (l$value as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final DateTime time;

  final double value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$time = time;
    _resultData['time'] = l$time.toIso8601String();
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$time = time;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$time, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_SensorFieldReading_trendHistorie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$time = time;
    final lOther$time = other.time;
    if (l$time != lOther$time) {
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

extension UtilityExtension_Fragment_SensorFieldReading_trendHistorie
    on Fragment_SensorFieldReading_trendHistorie {
  CopyWith_Fragment_SensorFieldReading_trendHistorie<
    Fragment_SensorFieldReading_trendHistorie
  >
  get copyWith =>
      CopyWith_Fragment_SensorFieldReading_trendHistorie(this, (i) => i);
}

abstract class CopyWith_Fragment_SensorFieldReading_trendHistorie<TRes> {
  factory CopyWith_Fragment_SensorFieldReading_trendHistorie(
    Fragment_SensorFieldReading_trendHistorie instance,
    TRes Function(Fragment_SensorFieldReading_trendHistorie) then,
  ) = _CopyWithImpl_Fragment_SensorFieldReading_trendHistorie;

  factory CopyWith_Fragment_SensorFieldReading_trendHistorie.stub(TRes res) =
      _CopyWithStubImpl_Fragment_SensorFieldReading_trendHistorie;

  TRes call({DateTime? time, double? value, String? $__typename});
}

class _CopyWithImpl_Fragment_SensorFieldReading_trendHistorie<TRes>
    implements CopyWith_Fragment_SensorFieldReading_trendHistorie<TRes> {
  _CopyWithImpl_Fragment_SensorFieldReading_trendHistorie(
    this._instance,
    this._then,
  );

  final Fragment_SensorFieldReading_trendHistorie _instance;

  final TRes Function(Fragment_SensorFieldReading_trendHistorie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? time = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_SensorFieldReading_trendHistorie(
      time: time == _undefined || time == null
          ? _instance.time
          : (time as DateTime),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_SensorFieldReading_trendHistorie<TRes>
    implements CopyWith_Fragment_SensorFieldReading_trendHistorie<TRes> {
  _CopyWithStubImpl_Fragment_SensorFieldReading_trendHistorie(this._res);

  TRes _res;

  call({DateTime? time, double? value, String? $__typename}) => _res;
}

class Variables_Query_Sensoren {
  factory Variables_Query_Sensoren({required dynamic kommuneId}) =>
      Variables_Query_Sensoren._({r'kommuneId': kommuneId});

  Variables_Query_Sensoren._(this._$data);

  factory Variables_Query_Sensoren.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as dynamic);
    return Variables_Query_Sensoren._(result$data);
  }

  Map<String, dynamic> _$data;

  dynamic get kommuneId => (_$data['kommuneId'] as dynamic);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Sensoren<Variables_Query_Sensoren> get copyWith =>
      CopyWith_Variables_Query_Sensoren(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Sensoren ||
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

abstract class CopyWith_Variables_Query_Sensoren<TRes> {
  factory CopyWith_Variables_Query_Sensoren(
    Variables_Query_Sensoren instance,
    TRes Function(Variables_Query_Sensoren) then,
  ) = _CopyWithImpl_Variables_Query_Sensoren;

  factory CopyWith_Variables_Query_Sensoren.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Sensoren;

  TRes call({dynamic? kommuneId});
}

class _CopyWithImpl_Variables_Query_Sensoren<TRes>
    implements CopyWith_Variables_Query_Sensoren<TRes> {
  _CopyWithImpl_Variables_Query_Sensoren(this._instance, this._then);

  final Variables_Query_Sensoren _instance;

  final TRes Function(Variables_Query_Sensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Sensoren._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as dynamic),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Sensoren<TRes>
    implements CopyWith_Variables_Query_Sensoren<TRes> {
  _CopyWithStubImpl_Variables_Query_Sensoren(this._res);

  TRes _res;

  call({dynamic? kommuneId}) => _res;
}

class Query_Sensoren {
  Query_Sensoren({required this.sensoren, this.$__typename = 'Query'});

  factory Query_Sensoren.fromJson(Map<String, dynamic> json) {
    final l$sensoren = json['sensoren'];
    final l$$__typename = json['__typename'];
    return Query_Sensoren(
      sensoren: Query_Sensoren_sensoren.fromJson(
        (l$sensoren as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Sensoren_sensoren sensoren;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sensoren = sensoren;
    _resultData['sensoren'] = l$sensoren.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sensoren = sensoren;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sensoren, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensoren || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Sensoren on Query_Sensoren {
  CopyWith_Query_Sensoren<Query_Sensoren> get copyWith =>
      CopyWith_Query_Sensoren(this, (i) => i);
}

abstract class CopyWith_Query_Sensoren<TRes> {
  factory CopyWith_Query_Sensoren(
    Query_Sensoren instance,
    TRes Function(Query_Sensoren) then,
  ) = _CopyWithImpl_Query_Sensoren;

  factory CopyWith_Query_Sensoren.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensoren;

  TRes call({Query_Sensoren_sensoren? sensoren, String? $__typename});
  CopyWith_Query_Sensoren_sensoren<TRes> get sensoren;
}

class _CopyWithImpl_Query_Sensoren<TRes>
    implements CopyWith_Query_Sensoren<TRes> {
  _CopyWithImpl_Query_Sensoren(this._instance, this._then);

  final Query_Sensoren _instance;

  final TRes Function(Query_Sensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sensoren = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensoren(
      sensoren: sensoren == _undefined || sensoren == null
          ? _instance.sensoren
          : (sensoren as Query_Sensoren_sensoren),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Sensoren_sensoren<TRes> get sensoren {
    final local$sensoren = _instance.sensoren;
    return CopyWith_Query_Sensoren_sensoren(
      local$sensoren,
      (e) => call(sensoren: e),
    );
  }
}

class _CopyWithStubImpl_Query_Sensoren<TRes>
    implements CopyWith_Query_Sensoren<TRes> {
  _CopyWithStubImpl_Query_Sensoren(this._res);

  TRes _res;

  call({Query_Sensoren_sensoren? sensoren, String? $__typename}) => _res;

  CopyWith_Query_Sensoren_sensoren<TRes> get sensoren =>
      CopyWith_Query_Sensoren_sensoren.stub(_res);
}

const documentNodeQuerySensoren = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Sensoren'),
      variableDefinitions: [
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
            name: NameNode(value: 'sensoren'),
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
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: IntValueNode(value: '200'),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'SensorWithIcon'),
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
    fragmentDefinitionSensorWithIcon,
    fragmentDefinitionPoiIcon,
  ],
);
Query_Sensoren _parserFn_Query_Sensoren(Map<String, dynamic> data) =>
    Query_Sensoren.fromJson(data);
typedef OnQueryComplete_Query_Sensoren =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Sensoren?);

class Options_Query_Sensoren extends graphql.QueryOptions<Query_Sensoren> {
  Options_Query_Sensoren({
    String? operationName,
    required Variables_Query_Sensoren variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Sensoren? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Sensoren? onComplete,
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
                 data == null ? null : _parserFn_Query_Sensoren(data),
               ),
         onError: onError,
         document: documentNodeQuerySensoren,
         parserFn: _parserFn_Query_Sensoren,
       );

  final OnQueryComplete_Query_Sensoren? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Sensoren
    extends graphql.WatchQueryOptions<Query_Sensoren> {
  WatchOptions_Query_Sensoren({
    String? operationName,
    required Variables_Query_Sensoren variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Sensoren? typedOptimisticResult,
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
         document: documentNodeQuerySensoren,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Sensoren,
       );
}

class FetchMoreOptions_Query_Sensoren extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Sensoren({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Sensoren variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySensoren,
       );
}

extension ClientExtension_Query_Sensoren on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Sensoren>> query_Sensoren(
    Options_Query_Sensoren options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Sensoren> watchQuery_Sensoren(
    WatchOptions_Query_Sensoren options,
  ) => this.watchQuery(options);

  void writeQuery_Sensoren({
    required Query_Sensoren data,
    required Variables_Query_Sensoren variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySensoren),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Sensoren? readQuery_Sensoren({
    required Variables_Query_Sensoren variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySensoren),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Sensoren.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Sensoren> useQuery_Sensoren(
  Options_Query_Sensoren options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Sensoren> useWatchQuery_Sensoren(
  WatchOptions_Query_Sensoren options,
) => graphql_flutter.useWatchQuery(options);

class Query_Sensoren_Widget extends graphql_flutter.Query<Query_Sensoren> {
  Query_Sensoren_Widget({
    widgets.Key? key,
    required Options_Query_Sensoren options,
    required graphql_flutter.QueryBuilder<Query_Sensoren> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Sensoren_sensoren {
  Query_Sensoren_sensoren({required this.docs, this.$__typename = 'Sensorens'});

  factory Query_Sensoren_sensoren.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_Sensoren_sensoren(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_Sensoren_sensoren_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_Sensoren_sensoren_docs> docs;

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
    if (other is! Query_Sensoren_sensoren || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Sensoren_sensoren on Query_Sensoren_sensoren {
  CopyWith_Query_Sensoren_sensoren<Query_Sensoren_sensoren> get copyWith =>
      CopyWith_Query_Sensoren_sensoren(this, (i) => i);
}

abstract class CopyWith_Query_Sensoren_sensoren<TRes> {
  factory CopyWith_Query_Sensoren_sensoren(
    Query_Sensoren_sensoren instance,
    TRes Function(Query_Sensoren_sensoren) then,
  ) = _CopyWithImpl_Query_Sensoren_sensoren;

  factory CopyWith_Query_Sensoren_sensoren.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensoren_sensoren;

  TRes call({List<Query_Sensoren_sensoren_docs>? docs, String? $__typename});
  TRes docs(
    Iterable<Query_Sensoren_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_Sensoren_sensoren_docs<Query_Sensoren_sensoren_docs>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Sensoren_sensoren<TRes>
    implements CopyWith_Query_Sensoren_sensoren<TRes> {
  _CopyWithImpl_Query_Sensoren_sensoren(this._instance, this._then);

  final Query_Sensoren_sensoren _instance;

  final TRes Function(Query_Sensoren_sensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Sensoren_sensoren(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_Sensoren_sensoren_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_Sensoren_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_Sensoren_sensoren_docs<Query_Sensoren_sensoren_docs>
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_Sensoren_sensoren_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Sensoren_sensoren<TRes>
    implements CopyWith_Query_Sensoren_sensoren<TRes> {
  _CopyWithStubImpl_Query_Sensoren_sensoren(this._res);

  TRes _res;

  call({List<Query_Sensoren_sensoren_docs>? docs, String? $__typename}) => _res;

  docs(_fn) => _res;
}

class Query_Sensoren_sensoren_docs implements Fragment_SensorWithIcon {
  Query_Sensoren_sensoren_docs({
    required this.id,
    required this.position,
    this.icon,
    this.felder,
    this.$__typename = 'Sensoren',
  });

  factory Query_Sensoren_sensoren_docs.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$position = json['position'];
    final l$icon = json['icon'];
    final l$felder = json['felder'];
    final l$$__typename = json['__typename'];
    return Query_Sensoren_sensoren_docs(
      id: (l$id as String),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      felder: (l$felder as List<dynamic>?)
          ?.map(
            (e) => Query_Sensoren_sensoren_docs_felder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<double> position;

  final Fragment_PoiIcon? icon;

  final List<Query_Sensoren_sensoren_docs_felder>? felder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
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
    final l$icon = icon;
    final l$felder = felder;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$position.map((v) => v)),
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
    if (other is! Query_Sensoren_sensoren_docs ||
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

extension UtilityExtension_Query_Sensoren_sensoren_docs
    on Query_Sensoren_sensoren_docs {
  CopyWith_Query_Sensoren_sensoren_docs<Query_Sensoren_sensoren_docs>
  get copyWith => CopyWith_Query_Sensoren_sensoren_docs(this, (i) => i);
}

abstract class CopyWith_Query_Sensoren_sensoren_docs<TRes> {
  factory CopyWith_Query_Sensoren_sensoren_docs(
    Query_Sensoren_sensoren_docs instance,
    TRes Function(Query_Sensoren_sensoren_docs) then,
  ) = _CopyWithImpl_Query_Sensoren_sensoren_docs;

  factory CopyWith_Query_Sensoren_sensoren_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensoren_sensoren_docs;

  TRes call({
    String? id,
    List<double>? position,
    Fragment_PoiIcon? icon,
    List<Query_Sensoren_sensoren_docs_felder>? felder,
    String? $__typename,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  TRes felder(
    Iterable<Query_Sensoren_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_Sensoren_sensoren_docs_felder<
          Query_Sensoren_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Sensoren_sensoren_docs<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs<TRes> {
  _CopyWithImpl_Query_Sensoren_sensoren_docs(this._instance, this._then);

  final Query_Sensoren_sensoren_docs _instance;

  final TRes Function(Query_Sensoren_sensoren_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? position = _undefined,
    Object? icon = _undefined,
    Object? felder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensoren_sensoren_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      felder: felder == _undefined
          ? _instance.felder
          : (felder as List<Query_Sensoren_sensoren_docs_felder>?),
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
    Iterable<Query_Sensoren_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_Sensoren_sensoren_docs_felder<
          Query_Sensoren_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder?.map(
        (e) => CopyWith_Query_Sensoren_sensoren_docs_felder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_Sensoren_sensoren_docs<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs<TRes> {
  _CopyWithStubImpl_Query_Sensoren_sensoren_docs(this._res);

  TRes _res;

  call({
    String? id,
    List<double>? position,
    Fragment_PoiIcon? icon,
    List<Query_Sensoren_sensoren_docs_felder>? felder,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  felder(_fn) => _res;
}

class Query_Sensoren_sensoren_docs_felder
    implements Fragment_SensorWithIcon_felder {
  Query_Sensoren_sensoren_docs_felder({
    this.id,
    this.werteart,
    this.$__typename = 'Sensoren_Felder',
  });

  factory Query_Sensoren_sensoren_docs_felder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$werteart = json['werteart'];
    final l$$__typename = json['__typename'];
    return Query_Sensoren_sensoren_docs_felder(
      id: (l$id as String?),
      werteart: l$werteart == null
          ? null
          : Query_Sensoren_sensoren_docs_felder_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final Query_Sensoren_sensoren_docs_felder_werteart? werteart;

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
    if (other is! Query_Sensoren_sensoren_docs_felder ||
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

extension UtilityExtension_Query_Sensoren_sensoren_docs_felder
    on Query_Sensoren_sensoren_docs_felder {
  CopyWith_Query_Sensoren_sensoren_docs_felder<
    Query_Sensoren_sensoren_docs_felder
  >
  get copyWith => CopyWith_Query_Sensoren_sensoren_docs_felder(this, (i) => i);
}

abstract class CopyWith_Query_Sensoren_sensoren_docs_felder<TRes> {
  factory CopyWith_Query_Sensoren_sensoren_docs_felder(
    Query_Sensoren_sensoren_docs_felder instance,
    TRes Function(Query_Sensoren_sensoren_docs_felder) then,
  ) = _CopyWithImpl_Query_Sensoren_sensoren_docs_felder;

  factory CopyWith_Query_Sensoren_sensoren_docs_felder.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder;

  TRes call({
    String? id,
    Query_Sensoren_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
  });
  CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> get werteart;
}

class _CopyWithImpl_Query_Sensoren_sensoren_docs_felder<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs_felder<TRes> {
  _CopyWithImpl_Query_Sensoren_sensoren_docs_felder(this._instance, this._then);

  final Query_Sensoren_sensoren_docs_felder _instance;

  final TRes Function(Query_Sensoren_sensoren_docs_felder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? werteart = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensoren_sensoren_docs_felder(
      id: id == _undefined ? _instance.id : (id as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Query_Sensoren_sensoren_docs_felder_werteart?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Query_Sensoren_sensoren_docs_felder_werteart.stub(
            _then(_instance),
          )
        : CopyWith_Query_Sensoren_sensoren_docs_felder_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }
}

class _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs_felder<TRes> {
  _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder(this._res);

  TRes _res;

  call({
    String? id,
    Query_Sensoren_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> get werteart =>
      CopyWith_Query_Sensoren_sensoren_docs_felder_werteart.stub(_res);
}

class Query_Sensoren_sensoren_docs_felder_werteart
    implements Fragment_SensorWithIcon_felder_werteart {
  Query_Sensoren_sensoren_docs_felder_werteart({
    required this.id,
    this.icon,
    this.$__typename = 'SensorArt',
  });

  factory Query_Sensoren_sensoren_docs_felder_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query_Sensoren_sensoren_docs_felder_werteart(
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
    if (other is! Query_Sensoren_sensoren_docs_felder_werteart ||
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

extension UtilityExtension_Query_Sensoren_sensoren_docs_felder_werteart
    on Query_Sensoren_sensoren_docs_felder_werteart {
  CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<
    Query_Sensoren_sensoren_docs_felder_werteart
  >
  get copyWith =>
      CopyWith_Query_Sensoren_sensoren_docs_felder_werteart(this, (i) => i);
}

abstract class CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> {
  factory CopyWith_Query_Sensoren_sensoren_docs_felder_werteart(
    Query_Sensoren_sensoren_docs_felder_werteart instance,
    TRes Function(Query_Sensoren_sensoren_docs_felder_werteart) then,
  ) = _CopyWithImpl_Query_Sensoren_sensoren_docs_felder_werteart;

  factory CopyWith_Query_Sensoren_sensoren_docs_felder_werteart.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder_werteart;

  TRes call({String? id, Fragment_PoiIcon? icon, String? $__typename});
  CopyWith_Fragment_PoiIcon<TRes> get icon;
}

class _CopyWithImpl_Query_Sensoren_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> {
  _CopyWithImpl_Query_Sensoren_sensoren_docs_felder_werteart(
    this._instance,
    this._then,
  );

  final Query_Sensoren_sensoren_docs_felder_werteart _instance;

  final TRes Function(Query_Sensoren_sensoren_docs_felder_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensoren_sensoren_docs_felder_werteart(
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

class _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_Sensoren_sensoren_docs_felder_werteart<TRes> {
  _CopyWithStubImpl_Query_Sensoren_sensoren_docs_felder_werteart(this._res);

  TRes _res;

  call({String? id, Fragment_PoiIcon? icon, String? $__typename}) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);
}

class Variables_Query_Sensor {
  factory Variables_Query_Sensor({
    required String sensorId,
    required Enum_HistoryMode duration,
  }) =>
      Variables_Query_Sensor._({r'sensorId': sensorId, r'duration': duration});

  Variables_Query_Sensor._(this._$data);

  factory Variables_Query_Sensor.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sensorId = data['sensorId'];
    result$data['sensorId'] = (l$sensorId as String);
    final l$duration = data['duration'];
    result$data['duration'] = fromJson_Enum_HistoryMode((l$duration as String));
    return Variables_Query_Sensor._(result$data);
  }

  Map<String, dynamic> _$data;

  String get sensorId => (_$data['sensorId'] as String);

  Enum_HistoryMode get duration => (_$data['duration'] as Enum_HistoryMode);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sensorId = sensorId;
    result$data['sensorId'] = l$sensorId;
    final l$duration = duration;
    result$data['duration'] = toJson_Enum_HistoryMode(l$duration);
    return result$data;
  }

  CopyWith_Variables_Query_Sensor<Variables_Query_Sensor> get copyWith =>
      CopyWith_Variables_Query_Sensor(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Sensor || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sensorId = sensorId;
    final lOther$sensorId = other.sensorId;
    if (l$sensorId != lOther$sensorId) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (l$duration != lOther$duration) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sensorId = sensorId;
    final l$duration = duration;
    return Object.hashAll([l$sensorId, l$duration]);
  }
}

abstract class CopyWith_Variables_Query_Sensor<TRes> {
  factory CopyWith_Variables_Query_Sensor(
    Variables_Query_Sensor instance,
    TRes Function(Variables_Query_Sensor) then,
  ) = _CopyWithImpl_Variables_Query_Sensor;

  factory CopyWith_Variables_Query_Sensor.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Sensor;

  TRes call({String? sensorId, Enum_HistoryMode? duration});
}

class _CopyWithImpl_Variables_Query_Sensor<TRes>
    implements CopyWith_Variables_Query_Sensor<TRes> {
  _CopyWithImpl_Variables_Query_Sensor(this._instance, this._then);

  final Variables_Query_Sensor _instance;

  final TRes Function(Variables_Query_Sensor) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sensorId = _undefined, Object? duration = _undefined}) =>
      _then(
        Variables_Query_Sensor._({
          ..._instance._$data,
          if (sensorId != _undefined && sensorId != null)
            'sensorId': (sensorId as String),
          if (duration != _undefined && duration != null)
            'duration': (duration as Enum_HistoryMode),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_Sensor<TRes>
    implements CopyWith_Variables_Query_Sensor<TRes> {
  _CopyWithStubImpl_Variables_Query_Sensor(this._res);

  TRes _res;

  call({String? sensorId, Enum_HistoryMode? duration}) => _res;
}

class Query_Sensor {
  Query_Sensor({this.sensor, this.$__typename = 'Query'});

  factory Query_Sensor.fromJson(Map<String, dynamic> json) {
    final l$sensor = json['sensor'];
    final l$$__typename = json['__typename'];
    return Query_Sensor(
      sensor: l$sensor == null
          ? null
          : Query_Sensor_sensor.fromJson((l$sensor as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Sensor_sensor? sensor;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sensor = sensor;
    _resultData['sensor'] = l$sensor?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sensor = sensor;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sensor, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sensor = sensor;
    final lOther$sensor = other.sensor;
    if (l$sensor != lOther$sensor) {
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

extension UtilityExtension_Query_Sensor on Query_Sensor {
  CopyWith_Query_Sensor<Query_Sensor> get copyWith =>
      CopyWith_Query_Sensor(this, (i) => i);
}

abstract class CopyWith_Query_Sensor<TRes> {
  factory CopyWith_Query_Sensor(
    Query_Sensor instance,
    TRes Function(Query_Sensor) then,
  ) = _CopyWithImpl_Query_Sensor;

  factory CopyWith_Query_Sensor.stub(TRes res) = _CopyWithStubImpl_Query_Sensor;

  TRes call({Query_Sensor_sensor? sensor, String? $__typename});
  CopyWith_Query_Sensor_sensor<TRes> get sensor;
}

class _CopyWithImpl_Query_Sensor<TRes> implements CopyWith_Query_Sensor<TRes> {
  _CopyWithImpl_Query_Sensor(this._instance, this._then);

  final Query_Sensor _instance;

  final TRes Function(Query_Sensor) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sensor = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Sensor(
          sensor: sensor == _undefined
              ? _instance.sensor
              : (sensor as Query_Sensor_sensor?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Sensor_sensor<TRes> get sensor {
    final local$sensor = _instance.sensor;
    return local$sensor == null
        ? CopyWith_Query_Sensor_sensor.stub(_then(_instance))
        : CopyWith_Query_Sensor_sensor(local$sensor, (e) => call(sensor: e));
  }
}

class _CopyWithStubImpl_Query_Sensor<TRes>
    implements CopyWith_Query_Sensor<TRes> {
  _CopyWithStubImpl_Query_Sensor(this._res);

  TRes _res;

  call({Query_Sensor_sensor? sensor, String? $__typename}) => _res;

  CopyWith_Query_Sensor_sensor<TRes> get sensor =>
      CopyWith_Query_Sensor_sensor.stub(_res);
}

const documentNodeQuerySensor = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Sensor'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sensorId')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'duration')),
          type: NamedTypeNode(
            name: NameNode(value: 'HistoryMode'),
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
            name: NameNode(value: 'sensor'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'sensorId')),
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
                  name: NameNode(value: 'titel'),
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
                  name: NameNode(value: 'letzteMessungZeitpunkt'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FragmentSpreadNode(
                  name: NameNode(value: 'SensorDangerLevels'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'felder'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SensorFieldReading'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'historie'),
                        alias: null,
                        arguments: [
                          ArgumentNode(
                            name: NameNode(value: 'duration'),
                            value: VariableNode(
                              name: NameNode(value: 'duration'),
                            ),
                          ),
                        ],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'time'),
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
    fragmentDefinitionSensorDangerLevels,
    fragmentDefinitionSensorFieldReading,
  ],
);
Query_Sensor _parserFn_Query_Sensor(Map<String, dynamic> data) =>
    Query_Sensor.fromJson(data);
typedef OnQueryComplete_Query_Sensor =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Sensor?);

class Options_Query_Sensor extends graphql.QueryOptions<Query_Sensor> {
  Options_Query_Sensor({
    String? operationName,
    required Variables_Query_Sensor variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Sensor? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Sensor? onComplete,
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
                 data == null ? null : _parserFn_Query_Sensor(data),
               ),
         onError: onError,
         document: documentNodeQuerySensor,
         parserFn: _parserFn_Query_Sensor,
       );

  final OnQueryComplete_Query_Sensor? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Sensor
    extends graphql.WatchQueryOptions<Query_Sensor> {
  WatchOptions_Query_Sensor({
    String? operationName,
    required Variables_Query_Sensor variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Sensor? typedOptimisticResult,
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
         document: documentNodeQuerySensor,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Sensor,
       );
}

class FetchMoreOptions_Query_Sensor extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Sensor({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Sensor variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySensor,
       );
}

extension ClientExtension_Query_Sensor on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Sensor>> query_Sensor(
    Options_Query_Sensor options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Sensor> watchQuery_Sensor(
    WatchOptions_Query_Sensor options,
  ) => this.watchQuery(options);

  void writeQuery_Sensor({
    required Query_Sensor data,
    required Variables_Query_Sensor variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySensor),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Sensor? readQuery_Sensor({
    required Variables_Query_Sensor variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySensor),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Sensor.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Sensor> useQuery_Sensor(
  Options_Query_Sensor options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Sensor> useWatchQuery_Sensor(
  WatchOptions_Query_Sensor options,
) => graphql_flutter.useWatchQuery(options);

class Query_Sensor_Widget extends graphql_flutter.Query<Query_Sensor> {
  Query_Sensor_Widget({
    widgets.Key? key,
    required Options_Query_Sensor options,
    required graphql_flutter.QueryBuilder<Query_Sensor> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Sensor_sensor implements Fragment_SensorDangerLevels {
  Query_Sensor_sensor({
    required this.id,
    required this.name,
    this.titel,
    required this.position,
    this.letzteMessungZeitpunkt,
    this.grenzwertInfo1,
    this.grenzwertInfo2,
    this.grenzwertInfo3,
    this.grenzwertInfo4,
    this.pegelGefahrenstufe,
    this.glaetteAlarmLevel,
    this.$__typename = 'Sensoren',
    this.felder,
  });

  factory Query_Sensor_sensor.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$titel = json['titel'];
    final l$position = json['position'];
    final l$letzteMessungZeitpunkt = json['letzteMessungZeitpunkt'];
    final l$grenzwertInfo1 = json['grenzwertInfo1'];
    final l$grenzwertInfo2 = json['grenzwertInfo2'];
    final l$grenzwertInfo3 = json['grenzwertInfo3'];
    final l$grenzwertInfo4 = json['grenzwertInfo4'];
    final l$pegelGefahrenstufe = json['pegelGefahrenstufe'];
    final l$glaetteAlarmLevel = json['glaetteAlarmLevel'];
    final l$$__typename = json['__typename'];
    final l$felder = json['felder'];
    return Query_Sensor_sensor(
      id: (l$id as String),
      name: (l$name as String),
      titel: (l$titel as String?),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      letzteMessungZeitpunkt: (l$letzteMessungZeitpunkt as String?),
      grenzwertInfo1: (l$grenzwertInfo1 as num?)?.toDouble(),
      grenzwertInfo2: (l$grenzwertInfo2 as num?)?.toDouble(),
      grenzwertInfo3: (l$grenzwertInfo3 as num?)?.toDouble(),
      grenzwertInfo4: (l$grenzwertInfo4 as num?)?.toDouble(),
      pegelGefahrenstufe: (l$pegelGefahrenstufe as String?),
      glaetteAlarmLevel: (l$glaetteAlarmLevel as String?),
      $__typename: (l$$__typename as String),
      felder: (l$felder as List<dynamic>?)
          ?.map(
            (e) => Query_Sensor_sensor_felder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final String? titel;

  final List<double> position;

  final String? letzteMessungZeitpunkt;

  final double? grenzwertInfo1;

  final double? grenzwertInfo2;

  final double? grenzwertInfo3;

  final double? grenzwertInfo4;

  final String? pegelGefahrenstufe;

  final String? glaetteAlarmLevel;

  final String $__typename;

  final List<Query_Sensor_sensor_felder>? felder;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$letzteMessungZeitpunkt = letzteMessungZeitpunkt;
    _resultData['letzteMessungZeitpunkt'] = l$letzteMessungZeitpunkt;
    final l$grenzwertInfo1 = grenzwertInfo1;
    _resultData['grenzwertInfo1'] = l$grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    _resultData['grenzwertInfo2'] = l$grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    _resultData['grenzwertInfo3'] = l$grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    _resultData['grenzwertInfo4'] = l$grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    _resultData['pegelGefahrenstufe'] = l$pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    _resultData['glaetteAlarmLevel'] = l$glaetteAlarmLevel;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$felder = felder;
    _resultData['felder'] = l$felder?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$titel = titel;
    final l$position = position;
    final l$letzteMessungZeitpunkt = letzteMessungZeitpunkt;
    final l$grenzwertInfo1 = grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    final l$$__typename = $__typename;
    final l$felder = felder;
    return Object.hashAll([
      l$id,
      l$name,
      l$titel,
      Object.hashAll(l$position.map((v) => v)),
      l$letzteMessungZeitpunkt,
      l$grenzwertInfo1,
      l$grenzwertInfo2,
      l$grenzwertInfo3,
      l$grenzwertInfo4,
      l$pegelGefahrenstufe,
      l$glaetteAlarmLevel,
      l$$__typename,
      l$felder == null ? null : Object.hashAll(l$felder.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor || runtimeType != other.runtimeType) {
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
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
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
    final l$letzteMessungZeitpunkt = letzteMessungZeitpunkt;
    final lOther$letzteMessungZeitpunkt = other.letzteMessungZeitpunkt;
    if (l$letzteMessungZeitpunkt != lOther$letzteMessungZeitpunkt) {
      return false;
    }
    final l$grenzwertInfo1 = grenzwertInfo1;
    final lOther$grenzwertInfo1 = other.grenzwertInfo1;
    if (l$grenzwertInfo1 != lOther$grenzwertInfo1) {
      return false;
    }
    final l$grenzwertInfo2 = grenzwertInfo2;
    final lOther$grenzwertInfo2 = other.grenzwertInfo2;
    if (l$grenzwertInfo2 != lOther$grenzwertInfo2) {
      return false;
    }
    final l$grenzwertInfo3 = grenzwertInfo3;
    final lOther$grenzwertInfo3 = other.grenzwertInfo3;
    if (l$grenzwertInfo3 != lOther$grenzwertInfo3) {
      return false;
    }
    final l$grenzwertInfo4 = grenzwertInfo4;
    final lOther$grenzwertInfo4 = other.grenzwertInfo4;
    if (l$grenzwertInfo4 != lOther$grenzwertInfo4) {
      return false;
    }
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final lOther$pegelGefahrenstufe = other.pegelGefahrenstufe;
    if (l$pegelGefahrenstufe != lOther$pegelGefahrenstufe) {
      return false;
    }
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    final lOther$glaetteAlarmLevel = other.glaetteAlarmLevel;
    if (l$glaetteAlarmLevel != lOther$glaetteAlarmLevel) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    return true;
  }
}

extension UtilityExtension_Query_Sensor_sensor on Query_Sensor_sensor {
  CopyWith_Query_Sensor_sensor<Query_Sensor_sensor> get copyWith =>
      CopyWith_Query_Sensor_sensor(this, (i) => i);
}

abstract class CopyWith_Query_Sensor_sensor<TRes> {
  factory CopyWith_Query_Sensor_sensor(
    Query_Sensor_sensor instance,
    TRes Function(Query_Sensor_sensor) then,
  ) = _CopyWithImpl_Query_Sensor_sensor;

  factory CopyWith_Query_Sensor_sensor.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensor_sensor;

  TRes call({
    String? id,
    String? name,
    String? titel,
    List<double>? position,
    String? letzteMessungZeitpunkt,
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
    String? $__typename,
    List<Query_Sensor_sensor_felder>? felder,
  });
  TRes felder(
    Iterable<Query_Sensor_sensor_felder>? Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder<Query_Sensor_sensor_felder>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Sensor_sensor<TRes>
    implements CopyWith_Query_Sensor_sensor<TRes> {
  _CopyWithImpl_Query_Sensor_sensor(this._instance, this._then);

  final Query_Sensor_sensor _instance;

  final TRes Function(Query_Sensor_sensor) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? titel = _undefined,
    Object? position = _undefined,
    Object? letzteMessungZeitpunkt = _undefined,
    Object? grenzwertInfo1 = _undefined,
    Object? grenzwertInfo2 = _undefined,
    Object? grenzwertInfo3 = _undefined,
    Object? grenzwertInfo4 = _undefined,
    Object? pegelGefahrenstufe = _undefined,
    Object? glaetteAlarmLevel = _undefined,
    Object? $__typename = _undefined,
    Object? felder = _undefined,
  }) => _then(
    Query_Sensor_sensor(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      letzteMessungZeitpunkt: letzteMessungZeitpunkt == _undefined
          ? _instance.letzteMessungZeitpunkt
          : (letzteMessungZeitpunkt as String?),
      grenzwertInfo1: grenzwertInfo1 == _undefined
          ? _instance.grenzwertInfo1
          : (grenzwertInfo1 as double?),
      grenzwertInfo2: grenzwertInfo2 == _undefined
          ? _instance.grenzwertInfo2
          : (grenzwertInfo2 as double?),
      grenzwertInfo3: grenzwertInfo3 == _undefined
          ? _instance.grenzwertInfo3
          : (grenzwertInfo3 as double?),
      grenzwertInfo4: grenzwertInfo4 == _undefined
          ? _instance.grenzwertInfo4
          : (grenzwertInfo4 as double?),
      pegelGefahrenstufe: pegelGefahrenstufe == _undefined
          ? _instance.pegelGefahrenstufe
          : (pegelGefahrenstufe as String?),
      glaetteAlarmLevel: glaetteAlarmLevel == _undefined
          ? _instance.glaetteAlarmLevel
          : (glaetteAlarmLevel as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      felder: felder == _undefined
          ? _instance.felder
          : (felder as List<Query_Sensor_sensor_felder>?),
    ),
  );

  TRes felder(
    Iterable<Query_Sensor_sensor_felder>? Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder<Query_Sensor_sensor_felder>
      >?,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder?.map(
        (e) => CopyWith_Query_Sensor_sensor_felder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor<TRes>
    implements CopyWith_Query_Sensor_sensor<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? titel,
    List<double>? position,
    String? letzteMessungZeitpunkt,
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
    String? $__typename,
    List<Query_Sensor_sensor_felder>? felder,
  }) => _res;

  felder(_fn) => _res;
}

class Query_Sensor_sensor_felder implements Fragment_SensorFieldReading {
  Query_Sensor_sensor_felder({
    this.id,
    this.currentValue,
    this.werteart,
    required this.trendHistorie,
    this.$__typename = 'Sensoren_Felder',
    required this.historie,
  });

  factory Query_Sensor_sensor_felder.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$currentValue = json['currentValue'];
    final l$werteart = json['werteart'];
    final l$trendHistorie = json['trendHistorie'];
    final l$$__typename = json['__typename'];
    final l$historie = json['historie'];
    return Query_Sensor_sensor_felder(
      id: (l$id as String?),
      currentValue: (l$currentValue as String?),
      werteart: l$werteart == null
          ? null
          : Query_Sensor_sensor_felder_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      trendHistorie: (l$trendHistorie as List<dynamic>)
          .map(
            (e) => Query_Sensor_sensor_felder_trendHistorie.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      historie: (l$historie as List<dynamic>)
          .map(
            (e) => Query_Sensor_sensor_felder_historie.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String? id;

  final String? currentValue;

  final Query_Sensor_sensor_felder_werteart? werteart;

  final List<Query_Sensor_sensor_felder_trendHistorie> trendHistorie;

  final String $__typename;

  final List<Query_Sensor_sensor_felder_historie> historie;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currentValue = currentValue;
    _resultData['currentValue'] = l$currentValue;
    final l$werteart = werteart;
    _resultData['werteart'] = l$werteart?.toJson();
    final l$trendHistorie = trendHistorie;
    _resultData['trendHistorie'] = l$trendHistorie
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$historie = historie;
    _resultData['historie'] = l$historie.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$currentValue = currentValue;
    final l$werteart = werteart;
    final l$trendHistorie = trendHistorie;
    final l$$__typename = $__typename;
    final l$historie = historie;
    return Object.hashAll([
      l$id,
      l$currentValue,
      l$werteart,
      Object.hashAll(l$trendHistorie.map((v) => v)),
      l$$__typename,
      Object.hashAll(l$historie.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$currentValue = currentValue;
    final lOther$currentValue = other.currentValue;
    if (l$currentValue != lOther$currentValue) {
      return false;
    }
    final l$werteart = werteart;
    final lOther$werteart = other.werteart;
    if (l$werteart != lOther$werteart) {
      return false;
    }
    final l$trendHistorie = trendHistorie;
    final lOther$trendHistorie = other.trendHistorie;
    if (l$trendHistorie.length != lOther$trendHistorie.length) {
      return false;
    }
    for (int i = 0; i < l$trendHistorie.length; i++) {
      final l$trendHistorie$entry = l$trendHistorie[i];
      final lOther$trendHistorie$entry = lOther$trendHistorie[i];
      if (l$trendHistorie$entry != lOther$trendHistorie$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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

extension UtilityExtension_Query_Sensor_sensor_felder
    on Query_Sensor_sensor_felder {
  CopyWith_Query_Sensor_sensor_felder<Query_Sensor_sensor_felder>
  get copyWith => CopyWith_Query_Sensor_sensor_felder(this, (i) => i);
}

abstract class CopyWith_Query_Sensor_sensor_felder<TRes> {
  factory CopyWith_Query_Sensor_sensor_felder(
    Query_Sensor_sensor_felder instance,
    TRes Function(Query_Sensor_sensor_felder) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder;

  factory CopyWith_Query_Sensor_sensor_felder.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensor_sensor_felder;

  TRes call({
    String? id,
    String? currentValue,
    Query_Sensor_sensor_felder_werteart? werteart,
    List<Query_Sensor_sensor_felder_trendHistorie>? trendHistorie,
    String? $__typename,
    List<Query_Sensor_sensor_felder_historie>? historie,
  });
  CopyWith_Query_Sensor_sensor_felder_werteart<TRes> get werteart;
  TRes trendHistorie(
    Iterable<Query_Sensor_sensor_felder_trendHistorie> Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder_trendHistorie<
          Query_Sensor_sensor_felder_trendHistorie
        >
      >,
    )
    _fn,
  );
  TRes historie(
    Iterable<Query_Sensor_sensor_felder_historie> Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder_historie<
          Query_Sensor_sensor_felder_historie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Sensor_sensor_felder<TRes>
    implements CopyWith_Query_Sensor_sensor_felder<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder(this._instance, this._then);

  final Query_Sensor_sensor_felder _instance;

  final TRes Function(Query_Sensor_sensor_felder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? currentValue = _undefined,
    Object? werteart = _undefined,
    Object? trendHistorie = _undefined,
    Object? $__typename = _undefined,
    Object? historie = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder(
      id: id == _undefined ? _instance.id : (id as String?),
      currentValue: currentValue == _undefined
          ? _instance.currentValue
          : (currentValue as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Query_Sensor_sensor_felder_werteart?),
      trendHistorie: trendHistorie == _undefined || trendHistorie == null
          ? _instance.trendHistorie
          : (trendHistorie as List<Query_Sensor_sensor_felder_trendHistorie>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      historie: historie == _undefined || historie == null
          ? _instance.historie
          : (historie as List<Query_Sensor_sensor_felder_historie>),
    ),
  );

  CopyWith_Query_Sensor_sensor_felder_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Query_Sensor_sensor_felder_werteart.stub(_then(_instance))
        : CopyWith_Query_Sensor_sensor_felder_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }

  TRes trendHistorie(
    Iterable<Query_Sensor_sensor_felder_trendHistorie> Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder_trendHistorie<
          Query_Sensor_sensor_felder_trendHistorie
        >
      >,
    )
    _fn,
  ) => call(
    trendHistorie: _fn(
      _instance.trendHistorie.map(
        (e) => CopyWith_Query_Sensor_sensor_felder_trendHistorie(e, (i) => i),
      ),
    ).toList(),
  );

  TRes historie(
    Iterable<Query_Sensor_sensor_felder_historie> Function(
      Iterable<
        CopyWith_Query_Sensor_sensor_felder_historie<
          Query_Sensor_sensor_felder_historie
        >
      >,
    )
    _fn,
  ) => call(
    historie: _fn(
      _instance.historie.map(
        (e) => CopyWith_Query_Sensor_sensor_felder_historie(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder<TRes>
    implements CopyWith_Query_Sensor_sensor_felder<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder(this._res);

  TRes _res;

  call({
    String? id,
    String? currentValue,
    Query_Sensor_sensor_felder_werteart? werteart,
    List<Query_Sensor_sensor_felder_trendHistorie>? trendHistorie,
    String? $__typename,
    List<Query_Sensor_sensor_felder_historie>? historie,
  }) => _res;

  CopyWith_Query_Sensor_sensor_felder_werteart<TRes> get werteart =>
      CopyWith_Query_Sensor_sensor_felder_werteart.stub(_res);

  trendHistorie(_fn) => _res;

  historie(_fn) => _res;
}

class Query_Sensor_sensor_felder_werteart
    implements Fragment_SensorFieldReading_werteart {
  Query_Sensor_sensor_felder_werteart({
    required this.id,
    required this.name,
    this.einheit,
    this.warnstufeText1,
    this.warnstufeText2,
    this.warnstufeText3,
    this.warnstufeText4,
    this.$__typename = 'SensorArt',
  });

  factory Query_Sensor_sensor_felder_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$einheit = json['einheit'];
    final l$warnstufeText1 = json['warnstufeText1'];
    final l$warnstufeText2 = json['warnstufeText2'];
    final l$warnstufeText3 = json['warnstufeText3'];
    final l$warnstufeText4 = json['warnstufeText4'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_werteart(
      id: (l$id as String),
      name: (l$name as String),
      einheit: (l$einheit as String?),
      warnstufeText1: l$warnstufeText1 == null
          ? null
          : Query_Sensor_sensor_felder_werteart_warnstufeText1.fromJson(
              (l$warnstufeText1 as Map<String, dynamic>),
            ),
      warnstufeText2: l$warnstufeText2 == null
          ? null
          : Query_Sensor_sensor_felder_werteart_warnstufeText2.fromJson(
              (l$warnstufeText2 as Map<String, dynamic>),
            ),
      warnstufeText3: l$warnstufeText3 == null
          ? null
          : Query_Sensor_sensor_felder_werteart_warnstufeText3.fromJson(
              (l$warnstufeText3 as Map<String, dynamic>),
            ),
      warnstufeText4: l$warnstufeText4 == null
          ? null
          : Query_Sensor_sensor_felder_werteart_warnstufeText4.fromJson(
              (l$warnstufeText4 as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String? einheit;

  final Query_Sensor_sensor_felder_werteart_warnstufeText1? warnstufeText1;

  final Query_Sensor_sensor_felder_werteart_warnstufeText2? warnstufeText2;

  final Query_Sensor_sensor_felder_werteart_warnstufeText3? warnstufeText3;

  final Query_Sensor_sensor_felder_werteart_warnstufeText4? warnstufeText4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$einheit = einheit;
    _resultData['einheit'] = l$einheit;
    final l$warnstufeText1 = warnstufeText1;
    _resultData['warnstufeText1'] = l$warnstufeText1?.toJson();
    final l$warnstufeText2 = warnstufeText2;
    _resultData['warnstufeText2'] = l$warnstufeText2?.toJson();
    final l$warnstufeText3 = warnstufeText3;
    _resultData['warnstufeText3'] = l$warnstufeText3?.toJson();
    final l$warnstufeText4 = warnstufeText4;
    _resultData['warnstufeText4'] = l$warnstufeText4?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$einheit = einheit;
    final l$warnstufeText1 = warnstufeText1;
    final l$warnstufeText2 = warnstufeText2;
    final l$warnstufeText3 = warnstufeText3;
    final l$warnstufeText4 = warnstufeText4;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$einheit,
      l$warnstufeText1,
      l$warnstufeText2,
      l$warnstufeText3,
      l$warnstufeText4,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_werteart ||
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
    final l$einheit = einheit;
    final lOther$einheit = other.einheit;
    if (l$einheit != lOther$einheit) {
      return false;
    }
    final l$warnstufeText1 = warnstufeText1;
    final lOther$warnstufeText1 = other.warnstufeText1;
    if (l$warnstufeText1 != lOther$warnstufeText1) {
      return false;
    }
    final l$warnstufeText2 = warnstufeText2;
    final lOther$warnstufeText2 = other.warnstufeText2;
    if (l$warnstufeText2 != lOther$warnstufeText2) {
      return false;
    }
    final l$warnstufeText3 = warnstufeText3;
    final lOther$warnstufeText3 = other.warnstufeText3;
    if (l$warnstufeText3 != lOther$warnstufeText3) {
      return false;
    }
    final l$warnstufeText4 = warnstufeText4;
    final lOther$warnstufeText4 = other.warnstufeText4;
    if (l$warnstufeText4 != lOther$warnstufeText4) {
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

extension UtilityExtension_Query_Sensor_sensor_felder_werteart
    on Query_Sensor_sensor_felder_werteart {
  CopyWith_Query_Sensor_sensor_felder_werteart<
    Query_Sensor_sensor_felder_werteart
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_werteart(this, (i) => i);
}

abstract class CopyWith_Query_Sensor_sensor_felder_werteart<TRes> {
  factory CopyWith_Query_Sensor_sensor_felder_werteart(
    Query_Sensor_sensor_felder_werteart instance,
    TRes Function(Query_Sensor_sensor_felder_werteart) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_werteart;

  factory CopyWith_Query_Sensor_sensor_felder_werteart.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart;

  TRes call({
    String? id,
    String? name,
    String? einheit,
    Query_Sensor_sensor_felder_werteart_warnstufeText1? warnstufeText1,
    Query_Sensor_sensor_felder_werteart_warnstufeText2? warnstufeText2,
    Query_Sensor_sensor_felder_werteart_warnstufeText3? warnstufeText3,
    Query_Sensor_sensor_felder_werteart_warnstufeText4? warnstufeText4,
    String? $__typename,
  });
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1;
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2;
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3;
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4;
}

class _CopyWithImpl_Query_Sensor_sensor_felder_werteart<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_werteart<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_werteart(this._instance, this._then);

  final Query_Sensor_sensor_felder_werteart _instance;

  final TRes Function(Query_Sensor_sensor_felder_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? einheit = _undefined,
    Object? warnstufeText1 = _undefined,
    Object? warnstufeText2 = _undefined,
    Object? warnstufeText3 = _undefined,
    Object? warnstufeText4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_werteart(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      einheit: einheit == _undefined ? _instance.einheit : (einheit as String?),
      warnstufeText1: warnstufeText1 == _undefined
          ? _instance.warnstufeText1
          : (warnstufeText1
                as Query_Sensor_sensor_felder_werteart_warnstufeText1?),
      warnstufeText2: warnstufeText2 == _undefined
          ? _instance.warnstufeText2
          : (warnstufeText2
                as Query_Sensor_sensor_felder_werteart_warnstufeText2?),
      warnstufeText3: warnstufeText3 == _undefined
          ? _instance.warnstufeText3
          : (warnstufeText3
                as Query_Sensor_sensor_felder_werteart_warnstufeText3?),
      warnstufeText4: warnstufeText4 == _undefined
          ? _instance.warnstufeText4
          : (warnstufeText4
                as Query_Sensor_sensor_felder_werteart_warnstufeText4?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1 {
    final local$warnstufeText1 = _instance.warnstufeText1;
    return local$warnstufeText1 == null
        ? CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1.stub(
            _then(_instance),
          )
        : CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1(
            local$warnstufeText1,
            (e) => call(warnstufeText1: e),
          );
  }

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2 {
    final local$warnstufeText2 = _instance.warnstufeText2;
    return local$warnstufeText2 == null
        ? CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2.stub(
            _then(_instance),
          )
        : CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2(
            local$warnstufeText2,
            (e) => call(warnstufeText2: e),
          );
  }

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3 {
    final local$warnstufeText3 = _instance.warnstufeText3;
    return local$warnstufeText3 == null
        ? CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3.stub(
            _then(_instance),
          )
        : CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3(
            local$warnstufeText3,
            (e) => call(warnstufeText3: e),
          );
  }

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4 {
    final local$warnstufeText4 = _instance.warnstufeText4;
    return local$warnstufeText4 == null
        ? CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4.stub(
            _then(_instance),
          )
        : CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4(
            local$warnstufeText4,
            (e) => call(warnstufeText4: e),
          );
  }
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_werteart<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? einheit,
    Query_Sensor_sensor_felder_werteart_warnstufeText1? warnstufeText1,
    Query_Sensor_sensor_felder_werteart_warnstufeText2? warnstufeText2,
    Query_Sensor_sensor_felder_werteart_warnstufeText3? warnstufeText3,
    Query_Sensor_sensor_felder_werteart_warnstufeText4? warnstufeText4,
    String? $__typename,
  }) => _res;

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1 =>
      CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1.stub(_res);

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2 =>
      CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2.stub(_res);

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3 =>
      CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3.stub(_res);

  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4 =>
      CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4.stub(_res);
}

class Query_Sensor_sensor_felder_werteart_warnstufeText1
    implements Fragment_SensorFieldReading_werteart_warnstufeText1 {
  Query_Sensor_sensor_felder_werteart_warnstufeText1({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_Sensor_sensor_felder_werteart_warnstufeText1.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_werteart_warnstufeText1(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_werteart_warnstufeText1 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Sensor_sensor_felder_werteart_warnstufeText1
    on Query_Sensor_sensor_felder_werteart_warnstufeText1 {
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<
    Query_Sensor_sensor_felder_werteart_warnstufeText1
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<
  TRes
> {
  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1(
    Query_Sensor_sensor_felder_werteart_warnstufeText1 instance,
    TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText1) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1;

  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1(
    this._instance,
    this._then,
  );

  final Query_Sensor_sensor_felder_werteart_warnstufeText1 _instance;

  final TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText1) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_werteart_warnstufeText1(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText1<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText1(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_Sensor_sensor_felder_werteart_warnstufeText2
    implements Fragment_SensorFieldReading_werteart_warnstufeText2 {
  Query_Sensor_sensor_felder_werteart_warnstufeText2({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_Sensor_sensor_felder_werteart_warnstufeText2.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_werteart_warnstufeText2(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_werteart_warnstufeText2 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Sensor_sensor_felder_werteart_warnstufeText2
    on Query_Sensor_sensor_felder_werteart_warnstufeText2 {
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<
    Query_Sensor_sensor_felder_werteart_warnstufeText2
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<
  TRes
> {
  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2(
    Query_Sensor_sensor_felder_werteart_warnstufeText2 instance,
    TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText2) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2;

  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2(
    this._instance,
    this._then,
  );

  final Query_Sensor_sensor_felder_werteart_warnstufeText2 _instance;

  final TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText2) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_werteart_warnstufeText2(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText2<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText2(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_Sensor_sensor_felder_werteart_warnstufeText3
    implements Fragment_SensorFieldReading_werteart_warnstufeText3 {
  Query_Sensor_sensor_felder_werteart_warnstufeText3({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_Sensor_sensor_felder_werteart_warnstufeText3.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_werteart_warnstufeText3(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_werteart_warnstufeText3 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Sensor_sensor_felder_werteart_warnstufeText3
    on Query_Sensor_sensor_felder_werteart_warnstufeText3 {
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<
    Query_Sensor_sensor_felder_werteart_warnstufeText3
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<
  TRes
> {
  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3(
    Query_Sensor_sensor_felder_werteart_warnstufeText3 instance,
    TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText3) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3;

  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3(
    this._instance,
    this._then,
  );

  final Query_Sensor_sensor_felder_werteart_warnstufeText3 _instance;

  final TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText3) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_werteart_warnstufeText3(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText3<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText3(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_Sensor_sensor_felder_werteart_warnstufeText4
    implements Fragment_SensorFieldReading_werteart_warnstufeText4 {
  Query_Sensor_sensor_felder_werteart_warnstufeText4({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_Sensor_sensor_felder_werteart_warnstufeText4.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_werteart_warnstufeText4(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_werteart_warnstufeText4 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_Sensor_sensor_felder_werteart_warnstufeText4
    on Query_Sensor_sensor_felder_werteart_warnstufeText4 {
  CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<
    Query_Sensor_sensor_felder_werteart_warnstufeText4
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<
  TRes
> {
  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4(
    Query_Sensor_sensor_felder_werteart_warnstufeText4 instance,
    TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText4) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4;

  factory CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4(
    this._instance,
    this._then,
  );

  final Query_Sensor_sensor_felder_werteart_warnstufeText4 _instance;

  final TRes Function(Query_Sensor_sensor_felder_werteart_warnstufeText4) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_werteart_warnstufeText4(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes>
    implements
        CopyWith_Query_Sensor_sensor_felder_werteart_warnstufeText4<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_werteart_warnstufeText4(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_Sensor_sensor_felder_trendHistorie
    implements Fragment_SensorFieldReading_trendHistorie {
  Query_Sensor_sensor_felder_trendHistorie({
    required this.time,
    required this.value,
    this.$__typename = 'SensorHistorieEintrag',
  });

  factory Query_Sensor_sensor_felder_trendHistorie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$time = json['time'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_trendHistorie(
      time: DateTime.parse((l$time as String)),
      value: (l$value as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final DateTime time;

  final double value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$time = time;
    _resultData['time'] = l$time.toIso8601String();
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$time = time;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$time, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_trendHistorie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$time = time;
    final lOther$time = other.time;
    if (l$time != lOther$time) {
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

extension UtilityExtension_Query_Sensor_sensor_felder_trendHistorie
    on Query_Sensor_sensor_felder_trendHistorie {
  CopyWith_Query_Sensor_sensor_felder_trendHistorie<
    Query_Sensor_sensor_felder_trendHistorie
  >
  get copyWith =>
      CopyWith_Query_Sensor_sensor_felder_trendHistorie(this, (i) => i);
}

abstract class CopyWith_Query_Sensor_sensor_felder_trendHistorie<TRes> {
  factory CopyWith_Query_Sensor_sensor_felder_trendHistorie(
    Query_Sensor_sensor_felder_trendHistorie instance,
    TRes Function(Query_Sensor_sensor_felder_trendHistorie) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_trendHistorie;

  factory CopyWith_Query_Sensor_sensor_felder_trendHistorie.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensor_sensor_felder_trendHistorie;

  TRes call({DateTime? time, double? value, String? $__typename});
}

class _CopyWithImpl_Query_Sensor_sensor_felder_trendHistorie<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_trendHistorie<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_trendHistorie(
    this._instance,
    this._then,
  );

  final Query_Sensor_sensor_felder_trendHistorie _instance;

  final TRes Function(Query_Sensor_sensor_felder_trendHistorie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? time = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_trendHistorie(
      time: time == _undefined || time == null
          ? _instance.time
          : (time as DateTime),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_trendHistorie<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_trendHistorie<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_trendHistorie(this._res);

  TRes _res;

  call({DateTime? time, double? value, String? $__typename}) => _res;
}

class Query_Sensor_sensor_felder_historie {
  Query_Sensor_sensor_felder_historie({
    required this.time,
    required this.value,
    this.$__typename = 'SensorHistorieEintrag',
  });

  factory Query_Sensor_sensor_felder_historie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$time = json['time'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query_Sensor_sensor_felder_historie(
      time: DateTime.parse((l$time as String)),
      value: (l$value as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final DateTime time;

  final double value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$time = time;
    _resultData['time'] = l$time.toIso8601String();
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$time = time;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$time, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Sensor_sensor_felder_historie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$time = time;
    final lOther$time = other.time;
    if (l$time != lOther$time) {
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

extension UtilityExtension_Query_Sensor_sensor_felder_historie
    on Query_Sensor_sensor_felder_historie {
  CopyWith_Query_Sensor_sensor_felder_historie<
    Query_Sensor_sensor_felder_historie
  >
  get copyWith => CopyWith_Query_Sensor_sensor_felder_historie(this, (i) => i);
}

abstract class CopyWith_Query_Sensor_sensor_felder_historie<TRes> {
  factory CopyWith_Query_Sensor_sensor_felder_historie(
    Query_Sensor_sensor_felder_historie instance,
    TRes Function(Query_Sensor_sensor_felder_historie) then,
  ) = _CopyWithImpl_Query_Sensor_sensor_felder_historie;

  factory CopyWith_Query_Sensor_sensor_felder_historie.stub(TRes res) =
      _CopyWithStubImpl_Query_Sensor_sensor_felder_historie;

  TRes call({DateTime? time, double? value, String? $__typename});
}

class _CopyWithImpl_Query_Sensor_sensor_felder_historie<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_historie<TRes> {
  _CopyWithImpl_Query_Sensor_sensor_felder_historie(this._instance, this._then);

  final Query_Sensor_sensor_felder_historie _instance;

  final TRes Function(Query_Sensor_sensor_felder_historie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? time = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Sensor_sensor_felder_historie(
      time: time == _undefined || time == null
          ? _instance.time
          : (time as DateTime),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_Sensor_sensor_felder_historie<TRes>
    implements CopyWith_Query_Sensor_sensor_felder_historie<TRes> {
  _CopyWithStubImpl_Query_Sensor_sensor_felder_historie(this._res);

  TRes _res;

  call({DateTime? time, double? value, String? $__typename}) => _res;
}

class Variables_Query_ListSensoren {
  factory Variables_Query_ListSensoren({required List<String> sensorIds}) =>
      Variables_Query_ListSensoren._({r'sensorIds': sensorIds});

  Variables_Query_ListSensoren._(this._$data);

  factory Variables_Query_ListSensoren.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sensorIds = data['sensorIds'];
    result$data['sensorIds'] = (l$sensorIds as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables_Query_ListSensoren._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get sensorIds => (_$data['sensorIds'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sensorIds = sensorIds;
    result$data['sensorIds'] = l$sensorIds.map((e) => e).toList();
    return result$data;
  }

  CopyWith_Variables_Query_ListSensoren<Variables_Query_ListSensoren>
  get copyWith => CopyWith_Variables_Query_ListSensoren(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_ListSensoren ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sensorIds = sensorIds;
    final lOther$sensorIds = other.sensorIds;
    if (l$sensorIds.length != lOther$sensorIds.length) {
      return false;
    }
    for (int i = 0; i < l$sensorIds.length; i++) {
      final l$sensorIds$entry = l$sensorIds[i];
      final lOther$sensorIds$entry = lOther$sensorIds[i];
      if (l$sensorIds$entry != lOther$sensorIds$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sensorIds = sensorIds;
    return Object.hashAll([Object.hashAll(l$sensorIds.map((v) => v))]);
  }
}

abstract class CopyWith_Variables_Query_ListSensoren<TRes> {
  factory CopyWith_Variables_Query_ListSensoren(
    Variables_Query_ListSensoren instance,
    TRes Function(Variables_Query_ListSensoren) then,
  ) = _CopyWithImpl_Variables_Query_ListSensoren;

  factory CopyWith_Variables_Query_ListSensoren.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_ListSensoren;

  TRes call({List<String>? sensorIds});
}

class _CopyWithImpl_Variables_Query_ListSensoren<TRes>
    implements CopyWith_Variables_Query_ListSensoren<TRes> {
  _CopyWithImpl_Variables_Query_ListSensoren(this._instance, this._then);

  final Variables_Query_ListSensoren _instance;

  final TRes Function(Variables_Query_ListSensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sensorIds = _undefined}) => _then(
    Variables_Query_ListSensoren._({
      ..._instance._$data,
      if (sensorIds != _undefined && sensorIds != null)
        'sensorIds': (sensorIds as List<String>),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_ListSensoren<TRes>
    implements CopyWith_Variables_Query_ListSensoren<TRes> {
  _CopyWithStubImpl_Variables_Query_ListSensoren(this._res);

  TRes _res;

  call({List<String>? sensorIds}) => _res;
}

class Query_ListSensoren {
  Query_ListSensoren({required this.sensoren, this.$__typename = 'Query'});

  factory Query_ListSensoren.fromJson(Map<String, dynamic> json) {
    final l$sensoren = json['sensoren'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren(
      sensoren: Query_ListSensoren_sensoren.fromJson(
        (l$sensoren as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_ListSensoren_sensoren sensoren;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sensoren = sensoren;
    _resultData['sensoren'] = l$sensoren.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sensoren = sensoren;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sensoren, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ListSensoren || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_ListSensoren on Query_ListSensoren {
  CopyWith_Query_ListSensoren<Query_ListSensoren> get copyWith =>
      CopyWith_Query_ListSensoren(this, (i) => i);
}

abstract class CopyWith_Query_ListSensoren<TRes> {
  factory CopyWith_Query_ListSensoren(
    Query_ListSensoren instance,
    TRes Function(Query_ListSensoren) then,
  ) = _CopyWithImpl_Query_ListSensoren;

  factory CopyWith_Query_ListSensoren.stub(TRes res) =
      _CopyWithStubImpl_Query_ListSensoren;

  TRes call({Query_ListSensoren_sensoren? sensoren, String? $__typename});
  CopyWith_Query_ListSensoren_sensoren<TRes> get sensoren;
}

class _CopyWithImpl_Query_ListSensoren<TRes>
    implements CopyWith_Query_ListSensoren<TRes> {
  _CopyWithImpl_Query_ListSensoren(this._instance, this._then);

  final Query_ListSensoren _instance;

  final TRes Function(Query_ListSensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sensoren = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren(
      sensoren: sensoren == _undefined || sensoren == null
          ? _instance.sensoren
          : (sensoren as Query_ListSensoren_sensoren),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_ListSensoren_sensoren<TRes> get sensoren {
    final local$sensoren = _instance.sensoren;
    return CopyWith_Query_ListSensoren_sensoren(
      local$sensoren,
      (e) => call(sensoren: e),
    );
  }
}

class _CopyWithStubImpl_Query_ListSensoren<TRes>
    implements CopyWith_Query_ListSensoren<TRes> {
  _CopyWithStubImpl_Query_ListSensoren(this._res);

  TRes _res;

  call({Query_ListSensoren_sensoren? sensoren, String? $__typename}) => _res;

  CopyWith_Query_ListSensoren_sensoren<TRes> get sensoren =>
      CopyWith_Query_ListSensoren_sensoren.stub(_res);
}

const documentNodeQueryListSensoren = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ListSensoren'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sensorIds')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: true,
            ),
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
            name: NameNode(value: 'sensoren'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'where'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'id'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'in'),
                            value: VariableNode(
                              name: NameNode(value: 'sensorIds'),
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
                value: StringValueNode(value: 'titel', isBlock: false),
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
                        name: NameNode(value: 'name'),
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
                        name: NameNode(value: 'position'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FragmentSpreadNode(
                        name: NameNode(value: 'SensorWithIcon'),
                        directives: [],
                      ),
                      FragmentSpreadNode(
                        name: NameNode(value: 'SensorDangerLevels'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'felder'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'SensorFieldReading'),
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
    fragmentDefinitionSensorWithIcon,
    fragmentDefinitionPoiIcon,
    fragmentDefinitionSensorDangerLevels,
    fragmentDefinitionSensorFieldReading,
  ],
);
Query_ListSensoren _parserFn_Query_ListSensoren(Map<String, dynamic> data) =>
    Query_ListSensoren.fromJson(data);
typedef OnQueryComplete_Query_ListSensoren =
    FutureOr<void> Function(Map<String, dynamic>?, Query_ListSensoren?);

class Options_Query_ListSensoren
    extends graphql.QueryOptions<Query_ListSensoren> {
  Options_Query_ListSensoren({
    String? operationName,
    required Variables_Query_ListSensoren variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_ListSensoren? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_ListSensoren? onComplete,
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
                 data == null ? null : _parserFn_Query_ListSensoren(data),
               ),
         onError: onError,
         document: documentNodeQueryListSensoren,
         parserFn: _parserFn_Query_ListSensoren,
       );

  final OnQueryComplete_Query_ListSensoren? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_ListSensoren
    extends graphql.WatchQueryOptions<Query_ListSensoren> {
  WatchOptions_Query_ListSensoren({
    String? operationName,
    required Variables_Query_ListSensoren variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_ListSensoren? typedOptimisticResult,
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
         document: documentNodeQueryListSensoren,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_ListSensoren,
       );
}

class FetchMoreOptions_Query_ListSensoren extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_ListSensoren({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_ListSensoren variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryListSensoren,
       );
}

extension ClientExtension_Query_ListSensoren on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_ListSensoren>> query_ListSensoren(
    Options_Query_ListSensoren options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_ListSensoren> watchQuery_ListSensoren(
    WatchOptions_Query_ListSensoren options,
  ) => this.watchQuery(options);

  void writeQuery_ListSensoren({
    required Query_ListSensoren data,
    required Variables_Query_ListSensoren variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryListSensoren),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_ListSensoren? readQuery_ListSensoren({
    required Variables_Query_ListSensoren variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryListSensoren),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_ListSensoren.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_ListSensoren> useQuery_ListSensoren(
  Options_Query_ListSensoren options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_ListSensoren> useWatchQuery_ListSensoren(
  WatchOptions_Query_ListSensoren options,
) => graphql_flutter.useWatchQuery(options);

class Query_ListSensoren_Widget
    extends graphql_flutter.Query<Query_ListSensoren> {
  Query_ListSensoren_Widget({
    widgets.Key? key,
    required Options_Query_ListSensoren options,
    required graphql_flutter.QueryBuilder<Query_ListSensoren> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_ListSensoren_sensoren {
  Query_ListSensoren_sensoren({
    required this.docs,
    this.$__typename = 'Sensorens',
  });

  factory Query_ListSensoren_sensoren.fromJson(Map<String, dynamic> json) {
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren(
      docs: (l$docs as List<dynamic>)
          .map(
            (e) => Query_ListSensoren_sensoren_docs.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_ListSensoren_sensoren_docs> docs;

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
    if (other is! Query_ListSensoren_sensoren ||
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

extension UtilityExtension_Query_ListSensoren_sensoren
    on Query_ListSensoren_sensoren {
  CopyWith_Query_ListSensoren_sensoren<Query_ListSensoren_sensoren>
  get copyWith => CopyWith_Query_ListSensoren_sensoren(this, (i) => i);
}

abstract class CopyWith_Query_ListSensoren_sensoren<TRes> {
  factory CopyWith_Query_ListSensoren_sensoren(
    Query_ListSensoren_sensoren instance,
    TRes Function(Query_ListSensoren_sensoren) then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren;

  factory CopyWith_Query_ListSensoren_sensoren.stub(TRes res) =
      _CopyWithStubImpl_Query_ListSensoren_sensoren;

  TRes call({
    List<Query_ListSensoren_sensoren_docs>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_ListSensoren_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs<
          Query_ListSensoren_sensoren_docs
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_ListSensoren_sensoren<TRes>
    implements CopyWith_Query_ListSensoren_sensoren<TRes> {
  _CopyWithImpl_Query_ListSensoren_sensoren(this._instance, this._then);

  final Query_ListSensoren_sensoren _instance;

  final TRes Function(Query_ListSensoren_sensoren) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? docs = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_ListSensoren_sensoren(
          docs: docs == _undefined || docs == null
              ? _instance.docs
              : (docs as List<Query_ListSensoren_sensoren_docs>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes docs(
    Iterable<Query_ListSensoren_sensoren_docs> Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs<
          Query_ListSensoren_sensoren_docs
        >
      >,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs.map(
        (e) => CopyWith_Query_ListSensoren_sensoren_docs(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren<TRes>
    implements CopyWith_Query_ListSensoren_sensoren<TRes> {
  _CopyWithStubImpl_Query_ListSensoren_sensoren(this._res);

  TRes _res;

  call({List<Query_ListSensoren_sensoren_docs>? docs, String? $__typename}) =>
      _res;

  docs(_fn) => _res;
}

class Query_ListSensoren_sensoren_docs
    implements Fragment_SensorWithIcon, Fragment_SensorDangerLevels {
  Query_ListSensoren_sensoren_docs({
    required this.id,
    required this.name,
    this.titel,
    required this.position,
    this.icon,
    this.felder,
    this.$__typename = 'Sensoren',
    this.grenzwertInfo1,
    this.grenzwertInfo2,
    this.grenzwertInfo3,
    this.grenzwertInfo4,
    this.pegelGefahrenstufe,
    this.glaetteAlarmLevel,
  });

  factory Query_ListSensoren_sensoren_docs.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$titel = json['titel'];
    final l$position = json['position'];
    final l$icon = json['icon'];
    final l$felder = json['felder'];
    final l$$__typename = json['__typename'];
    final l$grenzwertInfo1 = json['grenzwertInfo1'];
    final l$grenzwertInfo2 = json['grenzwertInfo2'];
    final l$grenzwertInfo3 = json['grenzwertInfo3'];
    final l$grenzwertInfo4 = json['grenzwertInfo4'];
    final l$pegelGefahrenstufe = json['pegelGefahrenstufe'];
    final l$glaetteAlarmLevel = json['glaetteAlarmLevel'];
    return Query_ListSensoren_sensoren_docs(
      id: (l$id as String),
      name: (l$name as String),
      titel: (l$titel as String?),
      position: (l$position as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      felder: (l$felder as List<dynamic>?)
          ?.map(
            (e) => Query_ListSensoren_sensoren_docs_felder.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      grenzwertInfo1: (l$grenzwertInfo1 as num?)?.toDouble(),
      grenzwertInfo2: (l$grenzwertInfo2 as num?)?.toDouble(),
      grenzwertInfo3: (l$grenzwertInfo3 as num?)?.toDouble(),
      grenzwertInfo4: (l$grenzwertInfo4 as num?)?.toDouble(),
      pegelGefahrenstufe: (l$pegelGefahrenstufe as String?),
      glaetteAlarmLevel: (l$glaetteAlarmLevel as String?),
    );
  }

  final String id;

  final String name;

  final String? titel;

  final List<double> position;

  final Fragment_PoiIcon? icon;

  final List<Query_ListSensoren_sensoren_docs_felder>? felder;

  final String $__typename;

  final double? grenzwertInfo1;

  final double? grenzwertInfo2;

  final double? grenzwertInfo3;

  final double? grenzwertInfo4;

  final String? pegelGefahrenstufe;

  final String? glaetteAlarmLevel;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$position = position;
    _resultData['position'] = l$position.map((e) => e).toList();
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$felder = felder;
    _resultData['felder'] = l$felder?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$grenzwertInfo1 = grenzwertInfo1;
    _resultData['grenzwertInfo1'] = l$grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    _resultData['grenzwertInfo2'] = l$grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    _resultData['grenzwertInfo3'] = l$grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    _resultData['grenzwertInfo4'] = l$grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    _resultData['pegelGefahrenstufe'] = l$pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    _resultData['glaetteAlarmLevel'] = l$glaetteAlarmLevel;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$titel = titel;
    final l$position = position;
    final l$icon = icon;
    final l$felder = felder;
    final l$$__typename = $__typename;
    final l$grenzwertInfo1 = grenzwertInfo1;
    final l$grenzwertInfo2 = grenzwertInfo2;
    final l$grenzwertInfo3 = grenzwertInfo3;
    final l$grenzwertInfo4 = grenzwertInfo4;
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    return Object.hashAll([
      l$id,
      l$name,
      l$titel,
      Object.hashAll(l$position.map((v) => v)),
      l$icon,
      l$felder == null ? null : Object.hashAll(l$felder.map((v) => v)),
      l$$__typename,
      l$grenzwertInfo1,
      l$grenzwertInfo2,
      l$grenzwertInfo3,
      l$grenzwertInfo4,
      l$pegelGefahrenstufe,
      l$glaetteAlarmLevel,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ListSensoren_sensoren_docs ||
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
    final l$titel = titel;
    final lOther$titel = other.titel;
    if (l$titel != lOther$titel) {
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
    final l$grenzwertInfo1 = grenzwertInfo1;
    final lOther$grenzwertInfo1 = other.grenzwertInfo1;
    if (l$grenzwertInfo1 != lOther$grenzwertInfo1) {
      return false;
    }
    final l$grenzwertInfo2 = grenzwertInfo2;
    final lOther$grenzwertInfo2 = other.grenzwertInfo2;
    if (l$grenzwertInfo2 != lOther$grenzwertInfo2) {
      return false;
    }
    final l$grenzwertInfo3 = grenzwertInfo3;
    final lOther$grenzwertInfo3 = other.grenzwertInfo3;
    if (l$grenzwertInfo3 != lOther$grenzwertInfo3) {
      return false;
    }
    final l$grenzwertInfo4 = grenzwertInfo4;
    final lOther$grenzwertInfo4 = other.grenzwertInfo4;
    if (l$grenzwertInfo4 != lOther$grenzwertInfo4) {
      return false;
    }
    final l$pegelGefahrenstufe = pegelGefahrenstufe;
    final lOther$pegelGefahrenstufe = other.pegelGefahrenstufe;
    if (l$pegelGefahrenstufe != lOther$pegelGefahrenstufe) {
      return false;
    }
    final l$glaetteAlarmLevel = glaetteAlarmLevel;
    final lOther$glaetteAlarmLevel = other.glaetteAlarmLevel;
    if (l$glaetteAlarmLevel != lOther$glaetteAlarmLevel) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs
    on Query_ListSensoren_sensoren_docs {
  CopyWith_Query_ListSensoren_sensoren_docs<Query_ListSensoren_sensoren_docs>
  get copyWith => CopyWith_Query_ListSensoren_sensoren_docs(this, (i) => i);
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs<TRes> {
  factory CopyWith_Query_ListSensoren_sensoren_docs(
    Query_ListSensoren_sensoren_docs instance,
    TRes Function(Query_ListSensoren_sensoren_docs) then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs;

  factory CopyWith_Query_ListSensoren_sensoren_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_ListSensoren_sensoren_docs;

  TRes call({
    String? id,
    String? name,
    String? titel,
    List<double>? position,
    Fragment_PoiIcon? icon,
    List<Query_ListSensoren_sensoren_docs_felder>? felder,
    String? $__typename,
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  TRes felder(
    Iterable<Query_ListSensoren_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs_felder<
          Query_ListSensoren_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs<TRes> {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs(this._instance, this._then);

  final Query_ListSensoren_sensoren_docs _instance;

  final TRes Function(Query_ListSensoren_sensoren_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? titel = _undefined,
    Object? position = _undefined,
    Object? icon = _undefined,
    Object? felder = _undefined,
    Object? $__typename = _undefined,
    Object? grenzwertInfo1 = _undefined,
    Object? grenzwertInfo2 = _undefined,
    Object? grenzwertInfo3 = _undefined,
    Object? grenzwertInfo4 = _undefined,
    Object? pegelGefahrenstufe = _undefined,
    Object? glaetteAlarmLevel = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as List<double>),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      felder: felder == _undefined
          ? _instance.felder
          : (felder as List<Query_ListSensoren_sensoren_docs_felder>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      grenzwertInfo1: grenzwertInfo1 == _undefined
          ? _instance.grenzwertInfo1
          : (grenzwertInfo1 as double?),
      grenzwertInfo2: grenzwertInfo2 == _undefined
          ? _instance.grenzwertInfo2
          : (grenzwertInfo2 as double?),
      grenzwertInfo3: grenzwertInfo3 == _undefined
          ? _instance.grenzwertInfo3
          : (grenzwertInfo3 as double?),
      grenzwertInfo4: grenzwertInfo4 == _undefined
          ? _instance.grenzwertInfo4
          : (grenzwertInfo4 as double?),
      pegelGefahrenstufe: pegelGefahrenstufe == _undefined
          ? _instance.pegelGefahrenstufe
          : (pegelGefahrenstufe as String?),
      glaetteAlarmLevel: glaetteAlarmLevel == _undefined
          ? _instance.glaetteAlarmLevel
          : (glaetteAlarmLevel as String?),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }

  TRes felder(
    Iterable<Query_ListSensoren_sensoren_docs_felder>? Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs_felder<
          Query_ListSensoren_sensoren_docs_felder
        >
      >?,
    )
    _fn,
  ) => call(
    felder: _fn(
      _instance.felder?.map(
        (e) => CopyWith_Query_ListSensoren_sensoren_docs_felder(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs<TRes> {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? titel,
    List<double>? position,
    Fragment_PoiIcon? icon,
    List<Query_ListSensoren_sensoren_docs_felder>? felder,
    String? $__typename,
    double? grenzwertInfo1,
    double? grenzwertInfo2,
    double? grenzwertInfo3,
    double? grenzwertInfo4,
    String? pegelGefahrenstufe,
    String? glaetteAlarmLevel,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  felder(_fn) => _res;
}

class Query_ListSensoren_sensoren_docs_felder
    implements Fragment_SensorWithIcon_felder, Fragment_SensorFieldReading {
  Query_ListSensoren_sensoren_docs_felder({
    this.id,
    this.werteart,
    this.$__typename = 'Sensoren_Felder',
    this.currentValue,
    required this.trendHistorie,
  });

  factory Query_ListSensoren_sensoren_docs_felder.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$werteart = json['werteart'];
    final l$$__typename = json['__typename'];
    final l$currentValue = json['currentValue'];
    final l$trendHistorie = json['trendHistorie'];
    return Query_ListSensoren_sensoren_docs_felder(
      id: (l$id as String?),
      werteart: l$werteart == null
          ? null
          : Query_ListSensoren_sensoren_docs_felder_werteart.fromJson(
              (l$werteart as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
      currentValue: (l$currentValue as String?),
      trendHistorie: (l$trendHistorie as List<dynamic>)
          .map(
            (e) =>
                Query_ListSensoren_sensoren_docs_felder_trendHistorie.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
    );
  }

  final String? id;

  final Query_ListSensoren_sensoren_docs_felder_werteart? werteart;

  final String $__typename;

  final String? currentValue;

  final List<Query_ListSensoren_sensoren_docs_felder_trendHistorie>
  trendHistorie;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$werteart = werteart;
    _resultData['werteart'] = l$werteart?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$currentValue = currentValue;
    _resultData['currentValue'] = l$currentValue;
    final l$trendHistorie = trendHistorie;
    _resultData['trendHistorie'] = l$trendHistorie
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$werteart = werteart;
    final l$$__typename = $__typename;
    final l$currentValue = currentValue;
    final l$trendHistorie = trendHistorie;
    return Object.hashAll([
      l$id,
      l$werteart,
      l$$__typename,
      l$currentValue,
      Object.hashAll(l$trendHistorie.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ListSensoren_sensoren_docs_felder ||
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
    final l$currentValue = currentValue;
    final lOther$currentValue = other.currentValue;
    if (l$currentValue != lOther$currentValue) {
      return false;
    }
    final l$trendHistorie = trendHistorie;
    final lOther$trendHistorie = other.trendHistorie;
    if (l$trendHistorie.length != lOther$trendHistorie.length) {
      return false;
    }
    for (int i = 0; i < l$trendHistorie.length; i++) {
      final l$trendHistorie$entry = l$trendHistorie[i];
      final lOther$trendHistorie$entry = lOther$trendHistorie[i];
      if (l$trendHistorie$entry != lOther$trendHistorie$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder
    on Query_ListSensoren_sensoren_docs_felder {
  CopyWith_Query_ListSensoren_sensoren_docs_felder<
    Query_ListSensoren_sensoren_docs_felder
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder(this, (i) => i);
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder<TRes> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder(
    Query_ListSensoren_sensoren_docs_felder instance,
    TRes Function(Query_ListSensoren_sensoren_docs_felder) then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder.stub(TRes res) =
      _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder;

  TRes call({
    String? id,
    Query_ListSensoren_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
    String? currentValue,
    List<Query_ListSensoren_sensoren_docs_felder_trendHistorie>? trendHistorie,
  });
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes> get werteart;
  TRes trendHistorie(
    Iterable<Query_ListSensoren_sensoren_docs_felder_trendHistorie> Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<
          Query_ListSensoren_sensoren_docs_felder_trendHistorie
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs_felder<TRes> {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder _instance;

  final TRes Function(Query_ListSensoren_sensoren_docs_felder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? werteart = _undefined,
    Object? $__typename = _undefined,
    Object? currentValue = _undefined,
    Object? trendHistorie = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder(
      id: id == _undefined ? _instance.id : (id as String?),
      werteart: werteart == _undefined
          ? _instance.werteart
          : (werteart as Query_ListSensoren_sensoren_docs_felder_werteart?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      currentValue: currentValue == _undefined
          ? _instance.currentValue
          : (currentValue as String?),
      trendHistorie: trendHistorie == _undefined || trendHistorie == null
          ? _instance.trendHistorie
          : (trendHistorie
                as List<Query_ListSensoren_sensoren_docs_felder_trendHistorie>),
    ),
  );

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes> get werteart {
    final local$werteart = _instance.werteart;
    return local$werteart == null
        ? CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart.stub(
            _then(_instance),
          )
        : CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart(
            local$werteart,
            (e) => call(werteart: e),
          );
  }

  TRes trendHistorie(
    Iterable<Query_ListSensoren_sensoren_docs_felder_trendHistorie> Function(
      Iterable<
        CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<
          Query_ListSensoren_sensoren_docs_felder_trendHistorie
        >
      >,
    )
    _fn,
  ) => call(
    trendHistorie: _fn(
      _instance.trendHistorie.map(
        (e) => CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs_felder<TRes> {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder(this._res);

  TRes _res;

  call({
    String? id,
    Query_ListSensoren_sensoren_docs_felder_werteart? werteart,
    String? $__typename,
    String? currentValue,
    List<Query_ListSensoren_sensoren_docs_felder_trendHistorie>? trendHistorie,
  }) => _res;

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes>
  get werteart =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart.stub(_res);

  trendHistorie(_fn) => _res;
}

class Query_ListSensoren_sensoren_docs_felder_werteart
    implements
        Fragment_SensorWithIcon_felder_werteart,
        Fragment_SensorFieldReading_werteart {
  Query_ListSensoren_sensoren_docs_felder_werteart({
    required this.id,
    this.icon,
    this.$__typename = 'SensorArt',
    required this.name,
    this.einheit,
    this.warnstufeText1,
    this.warnstufeText2,
    this.warnstufeText3,
    this.warnstufeText4,
  });

  factory Query_ListSensoren_sensoren_docs_felder_werteart.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    final l$name = json['name'];
    final l$einheit = json['einheit'];
    final l$warnstufeText1 = json['warnstufeText1'];
    final l$warnstufeText2 = json['warnstufeText2'];
    final l$warnstufeText3 = json['warnstufeText3'];
    final l$warnstufeText4 = json['warnstufeText4'];
    return Query_ListSensoren_sensoren_docs_felder_werteart(
      id: (l$id as String),
      icon: l$icon == null
          ? null
          : Fragment_PoiIcon.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
      name: (l$name as String),
      einheit: (l$einheit as String?),
      warnstufeText1: l$warnstufeText1 == null
          ? null
          : Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1.fromJson(
              (l$warnstufeText1 as Map<String, dynamic>),
            ),
      warnstufeText2: l$warnstufeText2 == null
          ? null
          : Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2.fromJson(
              (l$warnstufeText2 as Map<String, dynamic>),
            ),
      warnstufeText3: l$warnstufeText3 == null
          ? null
          : Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3.fromJson(
              (l$warnstufeText3 as Map<String, dynamic>),
            ),
      warnstufeText4: l$warnstufeText4 == null
          ? null
          : Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4.fromJson(
              (l$warnstufeText4 as Map<String, dynamic>),
            ),
    );
  }

  final String id;

  final Fragment_PoiIcon? icon;

  final String $__typename;

  final String name;

  final String? einheit;

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1?
  warnstufeText1;

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2?
  warnstufeText2;

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3?
  warnstufeText3;

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4?
  warnstufeText4;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$einheit = einheit;
    _resultData['einheit'] = l$einheit;
    final l$warnstufeText1 = warnstufeText1;
    _resultData['warnstufeText1'] = l$warnstufeText1?.toJson();
    final l$warnstufeText2 = warnstufeText2;
    _resultData['warnstufeText2'] = l$warnstufeText2?.toJson();
    final l$warnstufeText3 = warnstufeText3;
    _resultData['warnstufeText3'] = l$warnstufeText3?.toJson();
    final l$warnstufeText4 = warnstufeText4;
    _resultData['warnstufeText4'] = l$warnstufeText4?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$icon = icon;
    final l$$__typename = $__typename;
    final l$name = name;
    final l$einheit = einheit;
    final l$warnstufeText1 = warnstufeText1;
    final l$warnstufeText2 = warnstufeText2;
    final l$warnstufeText3 = warnstufeText3;
    final l$warnstufeText4 = warnstufeText4;
    return Object.hashAll([
      l$id,
      l$icon,
      l$$__typename,
      l$name,
      l$einheit,
      l$warnstufeText1,
      l$warnstufeText2,
      l$warnstufeText3,
      l$warnstufeText4,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ListSensoren_sensoren_docs_felder_werteart ||
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
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$einheit = einheit;
    final lOther$einheit = other.einheit;
    if (l$einheit != lOther$einheit) {
      return false;
    }
    final l$warnstufeText1 = warnstufeText1;
    final lOther$warnstufeText1 = other.warnstufeText1;
    if (l$warnstufeText1 != lOther$warnstufeText1) {
      return false;
    }
    final l$warnstufeText2 = warnstufeText2;
    final lOther$warnstufeText2 = other.warnstufeText2;
    if (l$warnstufeText2 != lOther$warnstufeText2) {
      return false;
    }
    final l$warnstufeText3 = warnstufeText3;
    final lOther$warnstufeText3 = other.warnstufeText3;
    if (l$warnstufeText3 != lOther$warnstufeText3) {
      return false;
    }
    final l$warnstufeText4 = warnstufeText4;
    final lOther$warnstufeText4 = other.warnstufeText4;
    if (l$warnstufeText4 != lOther$warnstufeText4) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_werteart
    on Query_ListSensoren_sensoren_docs_felder_werteart {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<
    Query_ListSensoren_sensoren_docs_felder_werteart
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart(this, (i) => i);
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart(
    Query_ListSensoren_sensoren_docs_felder_werteart instance,
    TRes Function(Query_ListSensoren_sensoren_docs_felder_werteart) then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart;

  TRes call({
    String? id,
    Fragment_PoiIcon? icon,
    String? $__typename,
    String? name,
    String? einheit,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1?
    warnstufeText1,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2?
    warnstufeText2,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3?
    warnstufeText3,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4?
    warnstufeText4,
  });
  CopyWith_Fragment_PoiIcon<TRes> get icon;
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1;
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2;
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3;
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4;
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes> {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_werteart _instance;

  final TRes Function(Query_ListSensoren_sensoren_docs_felder_werteart) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
    Object? name = _undefined,
    Object? einheit = _undefined,
    Object? warnstufeText1 = _undefined,
    Object? warnstufeText2 = _undefined,
    Object? warnstufeText3 = _undefined,
    Object? warnstufeText4 = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_werteart(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      icon: icon == _undefined ? _instance.icon : (icon as Fragment_PoiIcon?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      einheit: einheit == _undefined ? _instance.einheit : (einheit as String?),
      warnstufeText1: warnstufeText1 == _undefined
          ? _instance.warnstufeText1
          : (warnstufeText1
                as Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1?),
      warnstufeText2: warnstufeText2 == _undefined
          ? _instance.warnstufeText2
          : (warnstufeText2
                as Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2?),
      warnstufeText3: warnstufeText3 == _undefined
          ? _instance.warnstufeText3
          : (warnstufeText3
                as Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3?),
      warnstufeText4: warnstufeText4 == _undefined
          ? _instance.warnstufeText4
          : (warnstufeText4
                as Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4?),
    ),
  );

  CopyWith_Fragment_PoiIcon<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith_Fragment_PoiIcon.stub(_then(_instance))
        : CopyWith_Fragment_PoiIcon(local$icon, (e) => call(icon: e));
  }

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1 {
    final local$warnstufeText1 = _instance.warnstufeText1;
    return local$warnstufeText1 == null
        ? CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1.stub(
            _then(_instance),
          )
        : CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
            local$warnstufeText1,
            (e) => call(warnstufeText1: e),
          );
  }

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2 {
    final local$warnstufeText2 = _instance.warnstufeText2;
    return local$warnstufeText2 == null
        ? CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2.stub(
            _then(_instance),
          )
        : CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
            local$warnstufeText2,
            (e) => call(warnstufeText2: e),
          );
  }

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3 {
    final local$warnstufeText3 = _instance.warnstufeText3;
    return local$warnstufeText3 == null
        ? CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3.stub(
            _then(_instance),
          )
        : CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
            local$warnstufeText3,
            (e) => call(warnstufeText3: e),
          );
  }

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4 {
    final local$warnstufeText4 = _instance.warnstufeText4;
    return local$warnstufeText4 == null
        ? CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4.stub(
            _then(_instance),
          )
        : CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
            local$warnstufeText4,
            (e) => call(warnstufeText4: e),
          );
  }
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart<TRes>
    implements CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart<TRes> {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart(this._res);

  TRes _res;

  call({
    String? id,
    Fragment_PoiIcon? icon,
    String? $__typename,
    String? name,
    String? einheit,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1?
    warnstufeText1,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2?
    warnstufeText2,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3?
    warnstufeText3,
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4?
    warnstufeText4,
  }) => _res;

  CopyWith_Fragment_PoiIcon<TRes> get icon =>
      CopyWith_Fragment_PoiIcon.stub(_res);

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<TRes>
  get warnstufeText1 =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1.stub(
        _res,
      );

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<TRes>
  get warnstufeText2 =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2.stub(
        _res,
      );

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<TRes>
  get warnstufeText3 =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3.stub(
        _res,
      );

  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<TRes>
  get warnstufeText4 =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4.stub(
        _res,
      );
}

class Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1
    implements Fragment_SensorFieldReading_werteart_warnstufeText1 {
  Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1
    on Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1 {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
  TRes
> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1 instance,
    TRes Function(
      Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1,
    )
    then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
          TRes
        > {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1
  _instance;

  final TRes Function(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1<
          TRes
        > {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText1(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2
    implements Fragment_SensorFieldReading_werteart_warnstufeText2 {
  Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2
    on Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2 {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
  TRes
> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2 instance,
    TRes Function(
      Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2,
    )
    then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
          TRes
        > {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2
  _instance;

  final TRes Function(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2<
          TRes
        > {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText2(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3
    implements Fragment_SensorFieldReading_werteart_warnstufeText3 {
  Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3
    on Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3 {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
  TRes
> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3 instance,
    TRes Function(
      Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3,
    )
    then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
          TRes
        > {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3
  _instance;

  final TRes Function(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3<
          TRes
        > {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText3(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4
    implements Fragment_SensorFieldReading_werteart_warnstufeText4 {
  Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4({
    this.kurzlabel,
    this.titel,
    this.beschreibung,
    this.$__typename = 'SensorArtWarnstufeText',
  });

  factory Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kurzlabel = json['kurzlabel'];
    final l$titel = json['titel'];
    final l$beschreibung = json['beschreibung'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
      kurzlabel: (l$kurzlabel as String?),
      titel: (l$titel as String?),
      beschreibung: (l$beschreibung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? kurzlabel;

  final String? titel;

  final String? beschreibung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kurzlabel = kurzlabel;
    _resultData['kurzlabel'] = l$kurzlabel;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$beschreibung = beschreibung;
    _resultData['beschreibung'] = l$beschreibung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kurzlabel = kurzlabel;
    final l$titel = titel;
    final l$beschreibung = beschreibung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$kurzlabel,
      l$titel,
      l$beschreibung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4 ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kurzlabel = kurzlabel;
    final lOther$kurzlabel = other.kurzlabel;
    if (l$kurzlabel != lOther$kurzlabel) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4
    on Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4 {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
  TRes
> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4 instance,
    TRes Function(
      Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4,
    )
    then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4;

  TRes call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
          TRes
        > {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4
  _instance;

  final TRes Function(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kurzlabel = _undefined,
    Object? titel = _undefined,
    Object? beschreibung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
      kurzlabel: kurzlabel == _undefined
          ? _instance.kurzlabel
          : (kurzlabel as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      beschreibung: beschreibung == _undefined
          ? _instance.beschreibung
          : (beschreibung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4<
          TRes
        > {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_werteart_warnstufeText4(
    this._res,
  );

  TRes _res;

  call({
    String? kurzlabel,
    String? titel,
    String? beschreibung,
    String? $__typename,
  }) => _res;
}

class Query_ListSensoren_sensoren_docs_felder_trendHistorie
    implements Fragment_SensorFieldReading_trendHistorie {
  Query_ListSensoren_sensoren_docs_felder_trendHistorie({
    required this.time,
    required this.value,
    this.$__typename = 'SensorHistorieEintrag',
  });

  factory Query_ListSensoren_sensoren_docs_felder_trendHistorie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$time = json['time'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query_ListSensoren_sensoren_docs_felder_trendHistorie(
      time: DateTime.parse((l$time as String)),
      value: (l$value as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final DateTime time;

  final double value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$time = time;
    _resultData['time'] = l$time.toIso8601String();
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$time = time;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$time, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_ListSensoren_sensoren_docs_felder_trendHistorie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$time = time;
    final lOther$time = other.time;
    if (l$time != lOther$time) {
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

extension UtilityExtension_Query_ListSensoren_sensoren_docs_felder_trendHistorie
    on Query_ListSensoren_sensoren_docs_felder_trendHistorie {
  CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<
    Query_ListSensoren_sensoren_docs_felder_trendHistorie
  >
  get copyWith =>
      CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<
  TRes
> {
  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie(
    Query_ListSensoren_sensoren_docs_felder_trendHistorie instance,
    TRes Function(Query_ListSensoren_sensoren_docs_felder_trendHistorie) then,
  ) = _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie;

  factory CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie;

  TRes call({DateTime? time, double? value, String? $__typename});
}

class _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie<TRes>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<TRes> {
  _CopyWithImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie(
    this._instance,
    this._then,
  );

  final Query_ListSensoren_sensoren_docs_felder_trendHistorie _instance;

  final TRes Function(Query_ListSensoren_sensoren_docs_felder_trendHistorie)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? time = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_ListSensoren_sensoren_docs_felder_trendHistorie(
      time: time == _undefined || time == null
          ? _instance.time
          : (time as DateTime),
      value: value == _undefined || value == null
          ? _instance.value
          : (value as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie<
  TRes
>
    implements
        CopyWith_Query_ListSensoren_sensoren_docs_felder_trendHistorie<TRes> {
  _CopyWithStubImpl_Query_ListSensoren_sensoren_docs_felder_trendHistorie(
    this._res,
  );

  TRes _res;

  call({DateTime? time, double? value, String? $__typename}) => _res;
}
