import 'blocks.graphql.dart';
import 'dart:async';
import 'fragments.graphql.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_AbfallkalenderTermin {
  Fragment_AbfallkalenderTermin({
    required this.datum,
    required this.fraktionId,
    required this.fraktion,
    this.verschoben,
    required this.turnus,
    this.bemerkung,
    this.$__typename = 'Termin',
  });

  factory Fragment_AbfallkalenderTermin.fromJson(Map<String, dynamic> json) {
    final l$datum = json['datum'];
    final l$fraktionId = json['fraktionId'];
    final l$fraktion = json['fraktion'];
    final l$verschoben = json['verschoben'];
    final l$turnus = json['turnus'];
    final l$bemerkung = json['bemerkung'];
    final l$$__typename = json['__typename'];
    return Fragment_AbfallkalenderTermin(
      datum: (l$datum as String),
      fraktionId: (l$fraktionId as String),
      fraktion: (l$fraktion as String),
      verschoben: (l$verschoben as String?),
      turnus: (l$turnus as String),
      bemerkung: (l$bemerkung as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String datum;

  final String fraktionId;

  final String fraktion;

  final String? verschoben;

  final String turnus;

  final String? bemerkung;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$datum = datum;
    _resultData['datum'] = l$datum;
    final l$fraktionId = fraktionId;
    _resultData['fraktionId'] = l$fraktionId;
    final l$fraktion = fraktion;
    _resultData['fraktion'] = l$fraktion;
    final l$verschoben = verschoben;
    _resultData['verschoben'] = l$verschoben;
    final l$turnus = turnus;
    _resultData['turnus'] = l$turnus;
    final l$bemerkung = bemerkung;
    _resultData['bemerkung'] = l$bemerkung;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$datum = datum;
    final l$fraktionId = fraktionId;
    final l$fraktion = fraktion;
    final l$verschoben = verschoben;
    final l$turnus = turnus;
    final l$bemerkung = bemerkung;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$datum,
      l$fraktionId,
      l$fraktion,
      l$verschoben,
      l$turnus,
      l$bemerkung,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_AbfallkalenderTermin ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$datum = datum;
    final lOther$datum = other.datum;
    if (l$datum != lOther$datum) {
      return false;
    }
    final l$fraktionId = fraktionId;
    final lOther$fraktionId = other.fraktionId;
    if (l$fraktionId != lOther$fraktionId) {
      return false;
    }
    final l$fraktion = fraktion;
    final lOther$fraktion = other.fraktion;
    if (l$fraktion != lOther$fraktion) {
      return false;
    }
    final l$verschoben = verschoben;
    final lOther$verschoben = other.verschoben;
    if (l$verschoben != lOther$verschoben) {
      return false;
    }
    final l$turnus = turnus;
    final lOther$turnus = other.turnus;
    if (l$turnus != lOther$turnus) {
      return false;
    }
    final l$bemerkung = bemerkung;
    final lOther$bemerkung = other.bemerkung;
    if (l$bemerkung != lOther$bemerkung) {
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

extension UtilityExtension_Fragment_AbfallkalenderTermin
    on Fragment_AbfallkalenderTermin {
  CopyWith_Fragment_AbfallkalenderTermin<Fragment_AbfallkalenderTermin>
  get copyWith => CopyWith_Fragment_AbfallkalenderTermin(this, (i) => i);
}

abstract class CopyWith_Fragment_AbfallkalenderTermin<TRes> {
  factory CopyWith_Fragment_AbfallkalenderTermin(
    Fragment_AbfallkalenderTermin instance,
    TRes Function(Fragment_AbfallkalenderTermin) then,
  ) = _CopyWithImpl_Fragment_AbfallkalenderTermin;

  factory CopyWith_Fragment_AbfallkalenderTermin.stub(TRes res) =
      _CopyWithStubImpl_Fragment_AbfallkalenderTermin;

  TRes call({
    String? datum,
    String? fraktionId,
    String? fraktion,
    String? verschoben,
    String? turnus,
    String? bemerkung,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_AbfallkalenderTermin<TRes>
    implements CopyWith_Fragment_AbfallkalenderTermin<TRes> {
  _CopyWithImpl_Fragment_AbfallkalenderTermin(this._instance, this._then);

  final Fragment_AbfallkalenderTermin _instance;

  final TRes Function(Fragment_AbfallkalenderTermin) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? datum = _undefined,
    Object? fraktionId = _undefined,
    Object? fraktion = _undefined,
    Object? verschoben = _undefined,
    Object? turnus = _undefined,
    Object? bemerkung = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_AbfallkalenderTermin(
      datum: datum == _undefined || datum == null
          ? _instance.datum
          : (datum as String),
      fraktionId: fraktionId == _undefined || fraktionId == null
          ? _instance.fraktionId
          : (fraktionId as String),
      fraktion: fraktion == _undefined || fraktion == null
          ? _instance.fraktion
          : (fraktion as String),
      verschoben: verschoben == _undefined
          ? _instance.verschoben
          : (verschoben as String?),
      turnus: turnus == _undefined || turnus == null
          ? _instance.turnus
          : (turnus as String),
      bemerkung: bemerkung == _undefined
          ? _instance.bemerkung
          : (bemerkung as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_AbfallkalenderTermin<TRes>
    implements CopyWith_Fragment_AbfallkalenderTermin<TRes> {
  _CopyWithStubImpl_Fragment_AbfallkalenderTermin(this._res);

  TRes _res;

  call({
    String? datum,
    String? fraktionId,
    String? fraktion,
    String? verschoben,
    String? turnus,
    String? bemerkung,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionAbfallkalenderTermin = FragmentDefinitionNode(
  name: NameNode(value: 'AbfallkalenderTermin'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Termin'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'datum'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'fraktionId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'fraktion'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'verschoben'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'turnus'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'bemerkung'),
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
const documentNodeFragmentAbfallkalenderTermin = DocumentNode(
  definitions: [fragmentDefinitionAbfallkalenderTermin],
);

extension ClientExtension_Fragment_AbfallkalenderTermin
    on graphql.GraphQLClient {
  void writeFragment_AbfallkalenderTermin({
    required Fragment_AbfallkalenderTermin data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'AbfallkalenderTermin',
        document: documentNodeFragmentAbfallkalenderTermin,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_AbfallkalenderTermin? readFragment_AbfallkalenderTermin({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'AbfallkalenderTermin',
          document: documentNodeFragmentAbfallkalenderTermin,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_AbfallkalenderTermin.fromJson(result);
  }
}

class Fragment_VeranstaltungInfo implements Fragment_TimeAndLocation {
  Fragment_VeranstaltungInfo({
    required this.id,
    required this.titel,
    this.subtitle,
    this.teaser,
    this.buchungsUrl,
    this.ticketUrl,
    this.titelbild,
    this.untereinheit,
    this.timeAndLocation,
    this.$__typename = 'Veranstaltungskalender',
    this.category,
    this.source,
  });

  factory Fragment_VeranstaltungInfo.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$subtitle = json['subtitle'];
    final l$teaser = json['teaser'];
    final l$buchungsUrl = json['buchungsUrl'];
    final l$ticketUrl = json['ticketUrl'];
    final l$titelbild = json['titelbild'];
    final l$untereinheit = json['untereinheit'];
    final l$timeAndLocation = json['timeAndLocation'];
    final l$$__typename = json['__typename'];
    final l$category = json['category'];
    final l$source = json['source'];
    return Fragment_VeranstaltungInfo(
      id: (l$id as String),
      titel: (l$titel as String),
      subtitle: (l$subtitle as String?),
      teaser: (l$teaser as String?),
      buchungsUrl: (l$buchungsUrl as String?),
      ticketUrl: (l$ticketUrl as String?),
      titelbild: l$titelbild == null
          ? null
          : Fragment_VeranstaltungInfo_titelbild.fromJson(
              (l$titelbild as Map<String, dynamic>),
            ),
      untereinheit: l$untereinheit == null
          ? null
          : Fragment_VeranstaltungInfo_untereinheit.fromJson(
              (l$untereinheit as Map<String, dynamic>),
            ),
      timeAndLocation: l$timeAndLocation == null
          ? null
          : Fragment_VeranstaltungInfo_timeAndLocation.fromJson(
              (l$timeAndLocation as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
      category: (l$category as List<dynamic>?)
          ?.map(
            (e) => Fragment_VeranstaltungInfo_category.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      source: (l$source as List<dynamic>?)
          ?.map(
            (e) => Fragment_VeranstaltungInfo_source.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String titel;

  final String? subtitle;

  final String? teaser;

  final String? buchungsUrl;

  final String? ticketUrl;

  final Fragment_VeranstaltungInfo_titelbild? titelbild;

  final Fragment_VeranstaltungInfo_untereinheit? untereinheit;

  final Fragment_VeranstaltungInfo_timeAndLocation? timeAndLocation;

  final String $__typename;

  final List<Fragment_VeranstaltungInfo_category>? category;

  final List<Fragment_VeranstaltungInfo_source>? source;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$subtitle = subtitle;
    _resultData['subtitle'] = l$subtitle;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$buchungsUrl = buchungsUrl;
    _resultData['buchungsUrl'] = l$buchungsUrl;
    final l$ticketUrl = ticketUrl;
    _resultData['ticketUrl'] = l$ticketUrl;
    final l$titelbild = titelbild;
    _resultData['titelbild'] = l$titelbild?.toJson();
    final l$untereinheit = untereinheit;
    _resultData['untereinheit'] = l$untereinheit?.toJson();
    final l$timeAndLocation = timeAndLocation;
    _resultData['timeAndLocation'] = l$timeAndLocation?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$category = category;
    _resultData['category'] = l$category?.map((e) => e.toJson()).toList();
    final l$source = source;
    _resultData['source'] = l$source?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$subtitle = subtitle;
    final l$teaser = teaser;
    final l$buchungsUrl = buchungsUrl;
    final l$ticketUrl = ticketUrl;
    final l$titelbild = titelbild;
    final l$untereinheit = untereinheit;
    final l$timeAndLocation = timeAndLocation;
    final l$$__typename = $__typename;
    final l$category = category;
    final l$source = source;
    return Object.hashAll([
      l$id,
      l$titel,
      l$subtitle,
      l$teaser,
      l$buchungsUrl,
      l$ticketUrl,
      l$titelbild,
      l$untereinheit,
      l$timeAndLocation,
      l$$__typename,
      l$category == null ? null : Object.hashAll(l$category.map((v) => v)),
      l$source == null ? null : Object.hashAll(l$source.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungInfo ||
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
    final l$subtitle = subtitle;
    final lOther$subtitle = other.subtitle;
    if (l$subtitle != lOther$subtitle) {
      return false;
    }
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$buchungsUrl = buchungsUrl;
    final lOther$buchungsUrl = other.buchungsUrl;
    if (l$buchungsUrl != lOther$buchungsUrl) {
      return false;
    }
    final l$ticketUrl = ticketUrl;
    final lOther$ticketUrl = other.ticketUrl;
    if (l$ticketUrl != lOther$ticketUrl) {
      return false;
    }
    final l$titelbild = titelbild;
    final lOther$titelbild = other.titelbild;
    if (l$titelbild != lOther$titelbild) {
      return false;
    }
    final l$untereinheit = untereinheit;
    final lOther$untereinheit = other.untereinheit;
    if (l$untereinheit != lOther$untereinheit) {
      return false;
    }
    final l$timeAndLocation = timeAndLocation;
    final lOther$timeAndLocation = other.timeAndLocation;
    if (l$timeAndLocation != lOther$timeAndLocation) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != null && lOther$category != null) {
      if (l$category.length != lOther$category.length) {
        return false;
      }
      for (int i = 0; i < l$category.length; i++) {
        final l$category$entry = l$category[i];
        final lOther$category$entry = lOther$category[i];
        if (l$category$entry != lOther$category$entry) {
          return false;
        }
      }
    } else if (l$category != lOther$category) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != null && lOther$source != null) {
      if (l$source.length != lOther$source.length) {
        return false;
      }
      for (int i = 0; i < l$source.length; i++) {
        final l$source$entry = l$source[i];
        final lOther$source$entry = lOther$source[i];
        if (l$source$entry != lOther$source$entry) {
          return false;
        }
      }
    } else if (l$source != lOther$source) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension_Fragment_VeranstaltungInfo
    on Fragment_VeranstaltungInfo {
  CopyWith_Fragment_VeranstaltungInfo<Fragment_VeranstaltungInfo>
  get copyWith => CopyWith_Fragment_VeranstaltungInfo(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo(
    Fragment_VeranstaltungInfo instance,
    TRes Function(Fragment_VeranstaltungInfo) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo;

  factory CopyWith_Fragment_VeranstaltungInfo.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo;

  TRes call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    Fragment_VeranstaltungInfo_titelbild? titelbild,
    Fragment_VeranstaltungInfo_untereinheit? untereinheit,
    Fragment_VeranstaltungInfo_timeAndLocation? timeAndLocation,
    String? $__typename,
    List<Fragment_VeranstaltungInfo_category>? category,
    List<Fragment_VeranstaltungInfo_source>? source,
  });
  CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> get titelbild;
  CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> get untereinheit;
  CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes> get timeAndLocation;
  TRes category(
    Iterable<Fragment_VeranstaltungInfo_category>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_category<
          Fragment_VeranstaltungInfo_category
        >
      >?,
    )
    _fn,
  );
  TRes source(
    Iterable<Fragment_VeranstaltungInfo_source>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_source<
          Fragment_VeranstaltungInfo_source
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_VeranstaltungInfo<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo(this._instance, this._then);

  final Fragment_VeranstaltungInfo _instance;

  final TRes Function(Fragment_VeranstaltungInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? subtitle = _undefined,
    Object? teaser = _undefined,
    Object? buchungsUrl = _undefined,
    Object? ticketUrl = _undefined,
    Object? titelbild = _undefined,
    Object? untereinheit = _undefined,
    Object? timeAndLocation = _undefined,
    Object? $__typename = _undefined,
    Object? category = _undefined,
    Object? source = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      titel: titel == _undefined || titel == null
          ? _instance.titel
          : (titel as String),
      subtitle: subtitle == _undefined
          ? _instance.subtitle
          : (subtitle as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      buchungsUrl: buchungsUrl == _undefined
          ? _instance.buchungsUrl
          : (buchungsUrl as String?),
      ticketUrl: ticketUrl == _undefined
          ? _instance.ticketUrl
          : (ticketUrl as String?),
      titelbild: titelbild == _undefined
          ? _instance.titelbild
          : (titelbild as Fragment_VeranstaltungInfo_titelbild?),
      untereinheit: untereinheit == _undefined
          ? _instance.untereinheit
          : (untereinheit as Fragment_VeranstaltungInfo_untereinheit?),
      timeAndLocation: timeAndLocation == _undefined
          ? _instance.timeAndLocation
          : (timeAndLocation as Fragment_VeranstaltungInfo_timeAndLocation?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      category: category == _undefined
          ? _instance.category
          : (category as List<Fragment_VeranstaltungInfo_category>?),
      source: source == _undefined
          ? _instance.source
          : (source as List<Fragment_VeranstaltungInfo_source>?),
    ),
  );

  CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> get titelbild {
    final local$titelbild = _instance.titelbild;
    return local$titelbild == null
        ? CopyWith_Fragment_VeranstaltungInfo_titelbild.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungInfo_titelbild(
            local$titelbild,
            (e) => call(titelbild: e),
          );
  }

  CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> get untereinheit {
    final local$untereinheit = _instance.untereinheit;
    return local$untereinheit == null
        ? CopyWith_Fragment_VeranstaltungInfo_untereinheit.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_VeranstaltungInfo_untereinheit(
            local$untereinheit,
            (e) => call(untereinheit: e),
          );
  }

  CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes>
  get timeAndLocation {
    final local$timeAndLocation = _instance.timeAndLocation;
    return local$timeAndLocation == null
        ? CopyWith_Fragment_VeranstaltungInfo_timeAndLocation.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_VeranstaltungInfo_timeAndLocation(
            local$timeAndLocation,
            (e) => call(timeAndLocation: e),
          );
  }

  TRes category(
    Iterable<Fragment_VeranstaltungInfo_category>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_category<
          Fragment_VeranstaltungInfo_category
        >
      >?,
    )
    _fn,
  ) => call(
    category: _fn(
      _instance.category?.map(
        (e) => CopyWith_Fragment_VeranstaltungInfo_category(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes source(
    Iterable<Fragment_VeranstaltungInfo_source>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_source<
          Fragment_VeranstaltungInfo_source
        >
      >?,
    )
    _fn,
  ) => call(
    source: _fn(
      _instance.source?.map(
        (e) => CopyWith_Fragment_VeranstaltungInfo_source(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo(this._res);

  TRes _res;

  call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    Fragment_VeranstaltungInfo_titelbild? titelbild,
    Fragment_VeranstaltungInfo_untereinheit? untereinheit,
    Fragment_VeranstaltungInfo_timeAndLocation? timeAndLocation,
    String? $__typename,
    List<Fragment_VeranstaltungInfo_category>? category,
    List<Fragment_VeranstaltungInfo_source>? source,
  }) => _res;

  CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> get titelbild =>
      CopyWith_Fragment_VeranstaltungInfo_titelbild.stub(_res);

  CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> get untereinheit =>
      CopyWith_Fragment_VeranstaltungInfo_untereinheit.stub(_res);

  CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes>
  get timeAndLocation =>
      CopyWith_Fragment_VeranstaltungInfo_timeAndLocation.stub(_res);

  category(_fn) => _res;

  source(_fn) => _res;
}

const fragmentDefinitionVeranstaltungInfo = FragmentDefinitionNode(
  name: NameNode(value: 'VeranstaltungInfo'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'Veranstaltungskalender'),
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
        name: NameNode(value: 'titel'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'subtitle'),
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
        name: NameNode(value: 'buchungsUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'ticketUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'titelbild'),
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
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FragmentSpreadNode(
        name: NameNode(value: 'TimeAndLocation'),
        directives: [],
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
              name: NameNode(value: 'label'),
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
        name: NameNode(value: 'source'),
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
              name: NameNode(value: 'logo'),
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
const documentNodeFragmentVeranstaltungInfo = DocumentNode(
  definitions: [
    fragmentDefinitionVeranstaltungInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
    fragmentDefinitionTimeAndLocation,
  ],
);

extension ClientExtension_Fragment_VeranstaltungInfo on graphql.GraphQLClient {
  void writeFragment_VeranstaltungInfo({
    required Fragment_VeranstaltungInfo data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'VeranstaltungInfo',
        document: documentNodeFragmentVeranstaltungInfo,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_VeranstaltungInfo? readFragment_VeranstaltungInfo({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'VeranstaltungInfo',
          document: documentNodeFragmentVeranstaltungInfo,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_VeranstaltungInfo.fromJson(result);
  }
}

class Fragment_VeranstaltungInfo_titelbild {
  Fragment_VeranstaltungInfo_titelbild({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'Veranstaltungskalender_Titelbild',
  });

  factory Fragment_VeranstaltungInfo_titelbild.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_titelbild(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Fragment_VeranstaltungsmedienImage? internal;

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
    if (other is! Fragment_VeranstaltungInfo_titelbild ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_titelbild
    on Fragment_VeranstaltungInfo_titelbild {
  CopyWith_Fragment_VeranstaltungInfo_titelbild<
    Fragment_VeranstaltungInfo_titelbild
  >
  get copyWith => CopyWith_Fragment_VeranstaltungInfo_titelbild(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_titelbild(
    Fragment_VeranstaltungInfo_titelbild instance,
    TRes Function(Fragment_VeranstaltungInfo_titelbild) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_titelbild;

  factory CopyWith_Fragment_VeranstaltungInfo_titelbild.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_titelbild;

  TRes call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal;
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_titelbild<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_titelbild(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungInfo_titelbild _instance;

  final TRes Function(Fragment_VeranstaltungInfo_titelbild) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_titelbild(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_titelbild<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_titelbild<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_titelbild(this._res);

  TRes _res;

  call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_VeranstaltungInfo_untereinheit {
  Fragment_VeranstaltungInfo_untereinheit({
    required this.id,
    this.$__typename = 'BereichBUntereinheit',
  });

  factory Fragment_VeranstaltungInfo_untereinheit.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_untereinheit(
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
    if (other is! Fragment_VeranstaltungInfo_untereinheit ||
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

extension UtilityExtension_Fragment_VeranstaltungInfo_untereinheit
    on Fragment_VeranstaltungInfo_untereinheit {
  CopyWith_Fragment_VeranstaltungInfo_untereinheit<
    Fragment_VeranstaltungInfo_untereinheit
  >
  get copyWith =>
      CopyWith_Fragment_VeranstaltungInfo_untereinheit(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_untereinheit(
    Fragment_VeranstaltungInfo_untereinheit instance,
    TRes Function(Fragment_VeranstaltungInfo_untereinheit) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_untereinheit;

  factory CopyWith_Fragment_VeranstaltungInfo_untereinheit.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_untereinheit;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_untereinheit<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_untereinheit(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungInfo_untereinheit _instance;

  final TRes Function(Fragment_VeranstaltungInfo_untereinheit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_VeranstaltungInfo_untereinheit(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_untereinheit<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_untereinheit<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_untereinheit(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Fragment_VeranstaltungInfo_timeAndLocation
    implements Fragment_TimeAndLocation_timeAndLocation {
  Fragment_VeranstaltungInfo_timeAndLocation({
    this.locationName,
    this.address,
    this.coordinates,
    this.dates,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation',
  });

  factory Fragment_VeranstaltungInfo_timeAndLocation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$locationName = json['locationName'];
    final l$address = json['address'];
    final l$coordinates = json['coordinates'];
    final l$dates = json['dates'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_timeAndLocation(
      locationName: (l$locationName as String?),
      address: (l$address as String?),
      coordinates: (l$coordinates as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      dates: (l$dates as List<dynamic>?)
          ?.map(
            (e) => Fragment_VeranstaltungInfo_timeAndLocation_dates.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? locationName;

  final String? address;

  final List<double>? coordinates;

  final List<Fragment_VeranstaltungInfo_timeAndLocation_dates>? dates;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$coordinates = coordinates;
    _resultData['coordinates'] = l$coordinates?.map((e) => e).toList();
    final l$dates = dates;
    _resultData['dates'] = l$dates?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$locationName = locationName;
    final l$address = address;
    final l$coordinates = coordinates;
    final l$dates = dates;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$locationName,
      l$address,
      l$coordinates == null
          ? null
          : Object.hashAll(l$coordinates.map((v) => v)),
      l$dates == null ? null : Object.hashAll(l$dates.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungInfo_timeAndLocation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$coordinates = coordinates;
    final lOther$coordinates = other.coordinates;
    if (l$coordinates != null && lOther$coordinates != null) {
      if (l$coordinates.length != lOther$coordinates.length) {
        return false;
      }
      for (int i = 0; i < l$coordinates.length; i++) {
        final l$coordinates$entry = l$coordinates[i];
        final lOther$coordinates$entry = lOther$coordinates[i];
        if (l$coordinates$entry != lOther$coordinates$entry) {
          return false;
        }
      }
    } else if (l$coordinates != lOther$coordinates) {
      return false;
    }
    final l$dates = dates;
    final lOther$dates = other.dates;
    if (l$dates != null && lOther$dates != null) {
      if (l$dates.length != lOther$dates.length) {
        return false;
      }
      for (int i = 0; i < l$dates.length; i++) {
        final l$dates$entry = l$dates[i];
        final lOther$dates$entry = lOther$dates[i];
        if (l$dates$entry != lOther$dates$entry) {
          return false;
        }
      }
    } else if (l$dates != lOther$dates) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_timeAndLocation
    on Fragment_VeranstaltungInfo_timeAndLocation {
  CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<
    Fragment_VeranstaltungInfo_timeAndLocation
  >
  get copyWith =>
      CopyWith_Fragment_VeranstaltungInfo_timeAndLocation(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_timeAndLocation(
    Fragment_VeranstaltungInfo_timeAndLocation instance,
    TRes Function(Fragment_VeranstaltungInfo_timeAndLocation) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation;

  factory CopyWith_Fragment_VeranstaltungInfo_timeAndLocation.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation;

  TRes call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_VeranstaltungInfo_timeAndLocation_dates>? dates,
    String? $__typename,
  });
  TRes dates(
    Iterable<Fragment_VeranstaltungInfo_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<
          Fragment_VeranstaltungInfo_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungInfo_timeAndLocation _instance;

  final TRes Function(Fragment_VeranstaltungInfo_timeAndLocation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? locationName = _undefined,
    Object? address = _undefined,
    Object? coordinates = _undefined,
    Object? dates = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_timeAndLocation(
      locationName: locationName == _undefined
          ? _instance.locationName
          : (locationName as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      coordinates: coordinates == _undefined
          ? _instance.coordinates
          : (coordinates as List<double>?),
      dates: dates == _undefined
          ? _instance.dates
          : (dates as List<Fragment_VeranstaltungInfo_timeAndLocation_dates>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes dates(
    Iterable<Fragment_VeranstaltungInfo_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<
          Fragment_VeranstaltungInfo_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  ) => call(
    dates: _fn(
      _instance.dates?.map(
        (e) => CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_timeAndLocation<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation(this._res);

  TRes _res;

  call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_VeranstaltungInfo_timeAndLocation_dates>? dates,
    String? $__typename,
  }) => _res;

  dates(_fn) => _res;
}

class Fragment_VeranstaltungInfo_timeAndLocation_dates
    implements Fragment_TimeAndLocation_timeAndLocation_dates {
  Fragment_VeranstaltungInfo_timeAndLocation_dates({
    this.id,
    this.end,
    this.start,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation_Dates',
  });

  factory Fragment_VeranstaltungInfo_timeAndLocation_dates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$end = json['end'];
    final l$start = json['start'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_timeAndLocation_dates(
      id: (l$id as String?),
      end: l$end == null ? null : DateTime.parse((l$end as String)),
      start: l$start == null ? null : DateTime.parse((l$start as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final DateTime? end;

  final DateTime? start;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$end = end;
    _resultData['end'] = l$end?.toIso8601String();
    final l$start = start;
    _resultData['start'] = l$start?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$end = end;
    final l$start = start;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$end, l$start, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungInfo_timeAndLocation_dates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_timeAndLocation_dates
    on Fragment_VeranstaltungInfo_timeAndLocation_dates {
  CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<
    Fragment_VeranstaltungInfo_timeAndLocation_dates
  >
  get copyWith =>
      CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates(
    Fragment_VeranstaltungInfo_timeAndLocation_dates instance,
    TRes Function(Fragment_VeranstaltungInfo_timeAndLocation_dates) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates;

  factory CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates;

  TRes call({String? id, DateTime? end, DateTime? start, String? $__typename});
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungInfo_timeAndLocation_dates _instance;

  final TRes Function(Fragment_VeranstaltungInfo_timeAndLocation_dates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? end = _undefined,
    Object? start = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_timeAndLocation_dates(
      id: id == _undefined ? _instance.id : (id as String?),
      end: end == _undefined ? _instance.end : (end as DateTime?),
      start: start == _undefined ? _instance.start : (start as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_timeAndLocation_dates<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_timeAndLocation_dates(this._res);

  TRes _res;

  call({String? id, DateTime? end, DateTime? start, String? $__typename}) =>
      _res;
}

class Fragment_VeranstaltungInfo_category {
  Fragment_VeranstaltungInfo_category({
    required this.id,
    required this.label,
    this.$__typename = 'VeranstaltungskalenderKategorie',
  });

  factory Fragment_VeranstaltungInfo_category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_category(
      id: (l$id as String),
      label: (l$label as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungInfo_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_category
    on Fragment_VeranstaltungInfo_category {
  CopyWith_Fragment_VeranstaltungInfo_category<
    Fragment_VeranstaltungInfo_category
  >
  get copyWith => CopyWith_Fragment_VeranstaltungInfo_category(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_category<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_category(
    Fragment_VeranstaltungInfo_category instance,
    TRes Function(Fragment_VeranstaltungInfo_category) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_category;

  factory CopyWith_Fragment_VeranstaltungInfo_category.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_category;

  TRes call({String? id, String? label, String? $__typename});
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_category<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_category<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_category(this._instance, this._then);

  final Fragment_VeranstaltungInfo_category _instance;

  final TRes Function(Fragment_VeranstaltungInfo_category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? label = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_category(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_category<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_category<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_category(this._res);

  TRes _res;

  call({String? id, String? label, String? $__typename}) => _res;
}

class Fragment_VeranstaltungInfo_source {
  Fragment_VeranstaltungInfo_source({
    required this.id,
    this.name,
    this.logo,
    this.$__typename = 'VeranstaltungskalenderQuelle',
  });

  factory Fragment_VeranstaltungInfo_source.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$logo = json['logo'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_source(
      id: (l$id as String),
      name: (l$name as String?),
      logo: l$logo == null
          ? null
          : Fragment_VeranstaltungInfo_source_logo.fromJson(
              (l$logo as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final Fragment_VeranstaltungInfo_source_logo? logo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$logo = logo;
    _resultData['logo'] = l$logo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$logo = logo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$logo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungInfo_source ||
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
    final l$logo = logo;
    final lOther$logo = other.logo;
    if (l$logo != lOther$logo) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_source
    on Fragment_VeranstaltungInfo_source {
  CopyWith_Fragment_VeranstaltungInfo_source<Fragment_VeranstaltungInfo_source>
  get copyWith => CopyWith_Fragment_VeranstaltungInfo_source(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_source<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_source(
    Fragment_VeranstaltungInfo_source instance,
    TRes Function(Fragment_VeranstaltungInfo_source) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_source;

  factory CopyWith_Fragment_VeranstaltungInfo_source.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_source;

  TRes call({
    String? id,
    String? name,
    Fragment_VeranstaltungInfo_source_logo? logo,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> get logo;
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_source<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_source<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_source(this._instance, this._then);

  final Fragment_VeranstaltungInfo_source _instance;

  final TRes Function(Fragment_VeranstaltungInfo_source) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? logo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_source(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      logo: logo == _undefined
          ? _instance.logo
          : (logo as Fragment_VeranstaltungInfo_source_logo?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> get logo {
    final local$logo = _instance.logo;
    return local$logo == null
        ? CopyWith_Fragment_VeranstaltungInfo_source_logo.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungInfo_source_logo(
            local$logo,
            (e) => call(logo: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_source<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_source<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_source(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Fragment_VeranstaltungInfo_source_logo? logo,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> get logo =>
      CopyWith_Fragment_VeranstaltungInfo_source_logo.stub(_res);
}

class Fragment_VeranstaltungInfo_source_logo {
  Fragment_VeranstaltungInfo_source_logo({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'VeranstaltungskalenderQuelle_Logo',
  });

  factory Fragment_VeranstaltungInfo_source_logo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungInfo_source_logo(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Fragment_VeranstaltungsmedienImage? internal;

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
    if (other is! Fragment_VeranstaltungInfo_source_logo ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_VeranstaltungInfo_source_logo
    on Fragment_VeranstaltungInfo_source_logo {
  CopyWith_Fragment_VeranstaltungInfo_source_logo<
    Fragment_VeranstaltungInfo_source_logo
  >
  get copyWith =>
      CopyWith_Fragment_VeranstaltungInfo_source_logo(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> {
  factory CopyWith_Fragment_VeranstaltungInfo_source_logo(
    Fragment_VeranstaltungInfo_source_logo instance,
    TRes Function(Fragment_VeranstaltungInfo_source_logo) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungInfo_source_logo;

  factory CopyWith_Fragment_VeranstaltungInfo_source_logo.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungInfo_source_logo;

  TRes call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal;
}

class _CopyWithImpl_Fragment_VeranstaltungInfo_source_logo<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungInfo_source_logo(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungInfo_source_logo _instance;

  final TRes Function(Fragment_VeranstaltungInfo_source_logo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungInfo_source_logo(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VeranstaltungInfo_source_logo<TRes>
    implements CopyWith_Fragment_VeranstaltungInfo_source_logo<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungInfo_source_logo(this._res);

  TRes _res;

  call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_TimeAndLocation {
  Fragment_TimeAndLocation({
    this.timeAndLocation,
    this.$__typename = 'Veranstaltungskalender',
  });

  factory Fragment_TimeAndLocation.fromJson(Map<String, dynamic> json) {
    final l$timeAndLocation = json['timeAndLocation'];
    final l$$__typename = json['__typename'];
    return Fragment_TimeAndLocation(
      timeAndLocation: l$timeAndLocation == null
          ? null
          : Fragment_TimeAndLocation_timeAndLocation.fromJson(
              (l$timeAndLocation as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_TimeAndLocation_timeAndLocation? timeAndLocation;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$timeAndLocation = timeAndLocation;
    _resultData['timeAndLocation'] = l$timeAndLocation?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$timeAndLocation = timeAndLocation;
    final l$$__typename = $__typename;
    return Object.hashAll([l$timeAndLocation, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_TimeAndLocation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$timeAndLocation = timeAndLocation;
    final lOther$timeAndLocation = other.timeAndLocation;
    if (l$timeAndLocation != lOther$timeAndLocation) {
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

extension UtilityExtension_Fragment_TimeAndLocation
    on Fragment_TimeAndLocation {
  CopyWith_Fragment_TimeAndLocation<Fragment_TimeAndLocation> get copyWith =>
      CopyWith_Fragment_TimeAndLocation(this, (i) => i);
}

abstract class CopyWith_Fragment_TimeAndLocation<TRes> {
  factory CopyWith_Fragment_TimeAndLocation(
    Fragment_TimeAndLocation instance,
    TRes Function(Fragment_TimeAndLocation) then,
  ) = _CopyWithImpl_Fragment_TimeAndLocation;

  factory CopyWith_Fragment_TimeAndLocation.stub(TRes res) =
      _CopyWithStubImpl_Fragment_TimeAndLocation;

  TRes call({
    Fragment_TimeAndLocation_timeAndLocation? timeAndLocation,
    String? $__typename,
  });
  CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> get timeAndLocation;
}

class _CopyWithImpl_Fragment_TimeAndLocation<TRes>
    implements CopyWith_Fragment_TimeAndLocation<TRes> {
  _CopyWithImpl_Fragment_TimeAndLocation(this._instance, this._then);

  final Fragment_TimeAndLocation _instance;

  final TRes Function(Fragment_TimeAndLocation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? timeAndLocation = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_TimeAndLocation(
      timeAndLocation: timeAndLocation == _undefined
          ? _instance.timeAndLocation
          : (timeAndLocation as Fragment_TimeAndLocation_timeAndLocation?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> get timeAndLocation {
    final local$timeAndLocation = _instance.timeAndLocation;
    return local$timeAndLocation == null
        ? CopyWith_Fragment_TimeAndLocation_timeAndLocation.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_TimeAndLocation_timeAndLocation(
            local$timeAndLocation,
            (e) => call(timeAndLocation: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_TimeAndLocation<TRes>
    implements CopyWith_Fragment_TimeAndLocation<TRes> {
  _CopyWithStubImpl_Fragment_TimeAndLocation(this._res);

  TRes _res;

  call({
    Fragment_TimeAndLocation_timeAndLocation? timeAndLocation,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> get timeAndLocation =>
      CopyWith_Fragment_TimeAndLocation_timeAndLocation.stub(_res);
}

const fragmentDefinitionTimeAndLocation = FragmentDefinitionNode(
  name: NameNode(value: 'TimeAndLocation'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'Veranstaltungskalender'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'timeAndLocation'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'locationName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'address'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'coordinates'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'dates'),
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
                    name: NameNode(value: 'end'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'start'),
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
);
const documentNodeFragmentTimeAndLocation = DocumentNode(
  definitions: [fragmentDefinitionTimeAndLocation],
);

extension ClientExtension_Fragment_TimeAndLocation on graphql.GraphQLClient {
  void writeFragment_TimeAndLocation({
    required Fragment_TimeAndLocation data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'TimeAndLocation',
        document: documentNodeFragmentTimeAndLocation,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_TimeAndLocation? readFragment_TimeAndLocation({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'TimeAndLocation',
          document: documentNodeFragmentTimeAndLocation,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_TimeAndLocation.fromJson(result);
  }
}

class Fragment_TimeAndLocation_timeAndLocation {
  Fragment_TimeAndLocation_timeAndLocation({
    this.locationName,
    this.address,
    this.coordinates,
    this.dates,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation',
  });

  factory Fragment_TimeAndLocation_timeAndLocation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$locationName = json['locationName'];
    final l$address = json['address'];
    final l$coordinates = json['coordinates'];
    final l$dates = json['dates'];
    final l$$__typename = json['__typename'];
    return Fragment_TimeAndLocation_timeAndLocation(
      locationName: (l$locationName as String?),
      address: (l$address as String?),
      coordinates: (l$coordinates as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      dates: (l$dates as List<dynamic>?)
          ?.map(
            (e) => Fragment_TimeAndLocation_timeAndLocation_dates.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? locationName;

  final String? address;

  final List<double>? coordinates;

  final List<Fragment_TimeAndLocation_timeAndLocation_dates>? dates;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$coordinates = coordinates;
    _resultData['coordinates'] = l$coordinates?.map((e) => e).toList();
    final l$dates = dates;
    _resultData['dates'] = l$dates?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$locationName = locationName;
    final l$address = address;
    final l$coordinates = coordinates;
    final l$dates = dates;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$locationName,
      l$address,
      l$coordinates == null
          ? null
          : Object.hashAll(l$coordinates.map((v) => v)),
      l$dates == null ? null : Object.hashAll(l$dates.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_TimeAndLocation_timeAndLocation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$coordinates = coordinates;
    final lOther$coordinates = other.coordinates;
    if (l$coordinates != null && lOther$coordinates != null) {
      if (l$coordinates.length != lOther$coordinates.length) {
        return false;
      }
      for (int i = 0; i < l$coordinates.length; i++) {
        final l$coordinates$entry = l$coordinates[i];
        final lOther$coordinates$entry = lOther$coordinates[i];
        if (l$coordinates$entry != lOther$coordinates$entry) {
          return false;
        }
      }
    } else if (l$coordinates != lOther$coordinates) {
      return false;
    }
    final l$dates = dates;
    final lOther$dates = other.dates;
    if (l$dates != null && lOther$dates != null) {
      if (l$dates.length != lOther$dates.length) {
        return false;
      }
      for (int i = 0; i < l$dates.length; i++) {
        final l$dates$entry = l$dates[i];
        final lOther$dates$entry = lOther$dates[i];
        if (l$dates$entry != lOther$dates$entry) {
          return false;
        }
      }
    } else if (l$dates != lOther$dates) {
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

extension UtilityExtension_Fragment_TimeAndLocation_timeAndLocation
    on Fragment_TimeAndLocation_timeAndLocation {
  CopyWith_Fragment_TimeAndLocation_timeAndLocation<
    Fragment_TimeAndLocation_timeAndLocation
  >
  get copyWith =>
      CopyWith_Fragment_TimeAndLocation_timeAndLocation(this, (i) => i);
}

abstract class CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> {
  factory CopyWith_Fragment_TimeAndLocation_timeAndLocation(
    Fragment_TimeAndLocation_timeAndLocation instance,
    TRes Function(Fragment_TimeAndLocation_timeAndLocation) then,
  ) = _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation;

  factory CopyWith_Fragment_TimeAndLocation_timeAndLocation.stub(TRes res) =
      _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation;

  TRes call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_TimeAndLocation_timeAndLocation_dates>? dates,
    String? $__typename,
  });
  TRes dates(
    Iterable<Fragment_TimeAndLocation_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<
          Fragment_TimeAndLocation_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation<TRes>
    implements CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> {
  _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation(
    this._instance,
    this._then,
  );

  final Fragment_TimeAndLocation_timeAndLocation _instance;

  final TRes Function(Fragment_TimeAndLocation_timeAndLocation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? locationName = _undefined,
    Object? address = _undefined,
    Object? coordinates = _undefined,
    Object? dates = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_TimeAndLocation_timeAndLocation(
      locationName: locationName == _undefined
          ? _instance.locationName
          : (locationName as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      coordinates: coordinates == _undefined
          ? _instance.coordinates
          : (coordinates as List<double>?),
      dates: dates == _undefined
          ? _instance.dates
          : (dates as List<Fragment_TimeAndLocation_timeAndLocation_dates>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes dates(
    Iterable<Fragment_TimeAndLocation_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<
          Fragment_TimeAndLocation_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  ) => call(
    dates: _fn(
      _instance.dates?.map(
        (e) => CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation<TRes>
    implements CopyWith_Fragment_TimeAndLocation_timeAndLocation<TRes> {
  _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation(this._res);

  TRes _res;

  call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_TimeAndLocation_timeAndLocation_dates>? dates,
    String? $__typename,
  }) => _res;

  dates(_fn) => _res;
}

class Fragment_TimeAndLocation_timeAndLocation_dates {
  Fragment_TimeAndLocation_timeAndLocation_dates({
    this.id,
    this.end,
    this.start,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation_Dates',
  });

  factory Fragment_TimeAndLocation_timeAndLocation_dates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$end = json['end'];
    final l$start = json['start'];
    final l$$__typename = json['__typename'];
    return Fragment_TimeAndLocation_timeAndLocation_dates(
      id: (l$id as String?),
      end: l$end == null ? null : DateTime.parse((l$end as String)),
      start: l$start == null ? null : DateTime.parse((l$start as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final DateTime? end;

  final DateTime? start;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$end = end;
    _resultData['end'] = l$end?.toIso8601String();
    final l$start = start;
    _resultData['start'] = l$start?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$end = end;
    final l$start = start;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$end, l$start, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_TimeAndLocation_timeAndLocation_dates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
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

extension UtilityExtension_Fragment_TimeAndLocation_timeAndLocation_dates
    on Fragment_TimeAndLocation_timeAndLocation_dates {
  CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<
    Fragment_TimeAndLocation_timeAndLocation_dates
  >
  get copyWith =>
      CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates(this, (i) => i);
}

abstract class CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<TRes> {
  factory CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates(
    Fragment_TimeAndLocation_timeAndLocation_dates instance,
    TRes Function(Fragment_TimeAndLocation_timeAndLocation_dates) then,
  ) = _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation_dates;

  factory CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation_dates;

  TRes call({String? id, DateTime? end, DateTime? start, String? $__typename});
}

class _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<TRes> {
  _CopyWithImpl_Fragment_TimeAndLocation_timeAndLocation_dates(
    this._instance,
    this._then,
  );

  final Fragment_TimeAndLocation_timeAndLocation_dates _instance;

  final TRes Function(Fragment_TimeAndLocation_timeAndLocation_dates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? end = _undefined,
    Object? start = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_TimeAndLocation_timeAndLocation_dates(
      id: id == _undefined ? _instance.id : (id as String?),
      end: end == _undefined ? _instance.end : (end as DateTime?),
      start: start == _undefined ? _instance.start : (start as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_TimeAndLocation_timeAndLocation_dates<TRes> {
  _CopyWithStubImpl_Fragment_TimeAndLocation_timeAndLocation_dates(this._res);

  TRes _res;

  call({String? id, DateTime? end, DateTime? start, String? $__typename}) =>
      _res;
}

class Fragment_Veranstaltung
    implements Fragment_VeranstaltungInfo, Fragment_TimeAndLocation {
  Fragment_Veranstaltung({
    required this.id,
    required this.titel,
    this.subtitle,
    this.teaser,
    this.buchungsUrl,
    this.ticketUrl,
    this.titelbild,
    this.untereinheit,
    this.timeAndLocation,
    this.$__typename = 'Veranstaltungskalender',
    this.category,
    this.source,
    this.veranstalterAdresse,
    this.anbieterUrl,
    this.inhalte,
  });

  factory Fragment_Veranstaltung.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$subtitle = json['subtitle'];
    final l$teaser = json['teaser'];
    final l$buchungsUrl = json['buchungsUrl'];
    final l$ticketUrl = json['ticketUrl'];
    final l$titelbild = json['titelbild'];
    final l$untereinheit = json['untereinheit'];
    final l$timeAndLocation = json['timeAndLocation'];
    final l$$__typename = json['__typename'];
    final l$category = json['category'];
    final l$source = json['source'];
    final l$veranstalterAdresse = json['veranstalterAdresse'];
    final l$anbieterUrl = json['anbieterUrl'];
    final l$inhalte = json['inhalte'];
    return Fragment_Veranstaltung(
      id: (l$id as String),
      titel: (l$titel as String),
      subtitle: (l$subtitle as String?),
      teaser: (l$teaser as String?),
      buchungsUrl: (l$buchungsUrl as String?),
      ticketUrl: (l$ticketUrl as String?),
      titelbild: l$titelbild == null
          ? null
          : Fragment_Veranstaltung_titelbild.fromJson(
              (l$titelbild as Map<String, dynamic>),
            ),
      untereinheit: l$untereinheit == null
          ? null
          : Fragment_Veranstaltung_untereinheit.fromJson(
              (l$untereinheit as Map<String, dynamic>),
            ),
      timeAndLocation: l$timeAndLocation == null
          ? null
          : Fragment_Veranstaltung_timeAndLocation.fromJson(
              (l$timeAndLocation as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
      category: (l$category as List<dynamic>?)
          ?.map(
            (e) => Fragment_Veranstaltung_category.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      source: (l$source as List<dynamic>?)
          ?.map(
            (e) => Fragment_Veranstaltung_source.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      veranstalterAdresse: l$veranstalterAdresse == null
          ? null
          : Fragment_Adresse.fromJson(
              (l$veranstalterAdresse as Map<String, dynamic>),
            ),
      anbieterUrl: (l$anbieterUrl as String?),
      inhalte: (l$inhalte as List<dynamic>?)
          ?.map(
            (e) => Fragment_Veranstaltung_inhalte.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String titel;

  final String? subtitle;

  final String? teaser;

  final String? buchungsUrl;

  final String? ticketUrl;

  final Fragment_Veranstaltung_titelbild? titelbild;

  final Fragment_Veranstaltung_untereinheit? untereinheit;

  final Fragment_Veranstaltung_timeAndLocation? timeAndLocation;

  final String $__typename;

  final List<Fragment_Veranstaltung_category>? category;

  final List<Fragment_Veranstaltung_source>? source;

  final Fragment_Adresse? veranstalterAdresse;

  final String? anbieterUrl;

  final List<Fragment_Veranstaltung_inhalte>? inhalte;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$subtitle = subtitle;
    _resultData['subtitle'] = l$subtitle;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$buchungsUrl = buchungsUrl;
    _resultData['buchungsUrl'] = l$buchungsUrl;
    final l$ticketUrl = ticketUrl;
    _resultData['ticketUrl'] = l$ticketUrl;
    final l$titelbild = titelbild;
    _resultData['titelbild'] = l$titelbild?.toJson();
    final l$untereinheit = untereinheit;
    _resultData['untereinheit'] = l$untereinheit?.toJson();
    final l$timeAndLocation = timeAndLocation;
    _resultData['timeAndLocation'] = l$timeAndLocation?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$category = category;
    _resultData['category'] = l$category?.map((e) => e.toJson()).toList();
    final l$source = source;
    _resultData['source'] = l$source?.map((e) => e.toJson()).toList();
    final l$veranstalterAdresse = veranstalterAdresse;
    _resultData['veranstalterAdresse'] = l$veranstalterAdresse?.toJson();
    final l$anbieterUrl = anbieterUrl;
    _resultData['anbieterUrl'] = l$anbieterUrl;
    final l$inhalte = inhalte;
    _resultData['inhalte'] = l$inhalte?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$subtitle = subtitle;
    final l$teaser = teaser;
    final l$buchungsUrl = buchungsUrl;
    final l$ticketUrl = ticketUrl;
    final l$titelbild = titelbild;
    final l$untereinheit = untereinheit;
    final l$timeAndLocation = timeAndLocation;
    final l$$__typename = $__typename;
    final l$category = category;
    final l$source = source;
    final l$veranstalterAdresse = veranstalterAdresse;
    final l$anbieterUrl = anbieterUrl;
    final l$inhalte = inhalte;
    return Object.hashAll([
      l$id,
      l$titel,
      l$subtitle,
      l$teaser,
      l$buchungsUrl,
      l$ticketUrl,
      l$titelbild,
      l$untereinheit,
      l$timeAndLocation,
      l$$__typename,
      l$category == null ? null : Object.hashAll(l$category.map((v) => v)),
      l$source == null ? null : Object.hashAll(l$source.map((v) => v)),
      l$veranstalterAdresse,
      l$anbieterUrl,
      l$inhalte == null ? null : Object.hashAll(l$inhalte.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Veranstaltung || runtimeType != other.runtimeType) {
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
    final l$subtitle = subtitle;
    final lOther$subtitle = other.subtitle;
    if (l$subtitle != lOther$subtitle) {
      return false;
    }
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$buchungsUrl = buchungsUrl;
    final lOther$buchungsUrl = other.buchungsUrl;
    if (l$buchungsUrl != lOther$buchungsUrl) {
      return false;
    }
    final l$ticketUrl = ticketUrl;
    final lOther$ticketUrl = other.ticketUrl;
    if (l$ticketUrl != lOther$ticketUrl) {
      return false;
    }
    final l$titelbild = titelbild;
    final lOther$titelbild = other.titelbild;
    if (l$titelbild != lOther$titelbild) {
      return false;
    }
    final l$untereinheit = untereinheit;
    final lOther$untereinheit = other.untereinheit;
    if (l$untereinheit != lOther$untereinheit) {
      return false;
    }
    final l$timeAndLocation = timeAndLocation;
    final lOther$timeAndLocation = other.timeAndLocation;
    if (l$timeAndLocation != lOther$timeAndLocation) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != null && lOther$category != null) {
      if (l$category.length != lOther$category.length) {
        return false;
      }
      for (int i = 0; i < l$category.length; i++) {
        final l$category$entry = l$category[i];
        final lOther$category$entry = lOther$category[i];
        if (l$category$entry != lOther$category$entry) {
          return false;
        }
      }
    } else if (l$category != lOther$category) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != null && lOther$source != null) {
      if (l$source.length != lOther$source.length) {
        return false;
      }
      for (int i = 0; i < l$source.length; i++) {
        final l$source$entry = l$source[i];
        final lOther$source$entry = lOther$source[i];
        if (l$source$entry != lOther$source$entry) {
          return false;
        }
      }
    } else if (l$source != lOther$source) {
      return false;
    }
    final l$veranstalterAdresse = veranstalterAdresse;
    final lOther$veranstalterAdresse = other.veranstalterAdresse;
    if (l$veranstalterAdresse != lOther$veranstalterAdresse) {
      return false;
    }
    final l$anbieterUrl = anbieterUrl;
    final lOther$anbieterUrl = other.anbieterUrl;
    if (l$anbieterUrl != lOther$anbieterUrl) {
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

extension UtilityExtension_Fragment_Veranstaltung on Fragment_Veranstaltung {
  CopyWith_Fragment_Veranstaltung<Fragment_Veranstaltung> get copyWith =>
      CopyWith_Fragment_Veranstaltung(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung<TRes> {
  factory CopyWith_Fragment_Veranstaltung(
    Fragment_Veranstaltung instance,
    TRes Function(Fragment_Veranstaltung) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung;

  factory CopyWith_Fragment_Veranstaltung.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung;

  TRes call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    Fragment_Veranstaltung_titelbild? titelbild,
    Fragment_Veranstaltung_untereinheit? untereinheit,
    Fragment_Veranstaltung_timeAndLocation? timeAndLocation,
    String? $__typename,
    List<Fragment_Veranstaltung_category>? category,
    List<Fragment_Veranstaltung_source>? source,
    Fragment_Adresse? veranstalterAdresse,
    String? anbieterUrl,
    List<Fragment_Veranstaltung_inhalte>? inhalte,
  });
  CopyWith_Fragment_Veranstaltung_titelbild<TRes> get titelbild;
  CopyWith_Fragment_Veranstaltung_untereinheit<TRes> get untereinheit;
  CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> get timeAndLocation;
  TRes category(
    Iterable<Fragment_Veranstaltung_category>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_category<
          Fragment_Veranstaltung_category
        >
      >?,
    )
    _fn,
  );
  TRes source(
    Iterable<Fragment_Veranstaltung_source>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_source<Fragment_Veranstaltung_source>
      >?,
    )
    _fn,
  );
  CopyWith_Fragment_Adresse<TRes> get veranstalterAdresse;
  TRes inhalte(
    Iterable<Fragment_Veranstaltung_inhalte>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_inhalte<Fragment_Veranstaltung_inhalte>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Veranstaltung<TRes>
    implements CopyWith_Fragment_Veranstaltung<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung(this._instance, this._then);

  final Fragment_Veranstaltung _instance;

  final TRes Function(Fragment_Veranstaltung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? subtitle = _undefined,
    Object? teaser = _undefined,
    Object? buchungsUrl = _undefined,
    Object? ticketUrl = _undefined,
    Object? titelbild = _undefined,
    Object? untereinheit = _undefined,
    Object? timeAndLocation = _undefined,
    Object? $__typename = _undefined,
    Object? category = _undefined,
    Object? source = _undefined,
    Object? veranstalterAdresse = _undefined,
    Object? anbieterUrl = _undefined,
    Object? inhalte = _undefined,
  }) => _then(
    Fragment_Veranstaltung(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      titel: titel == _undefined || titel == null
          ? _instance.titel
          : (titel as String),
      subtitle: subtitle == _undefined
          ? _instance.subtitle
          : (subtitle as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      buchungsUrl: buchungsUrl == _undefined
          ? _instance.buchungsUrl
          : (buchungsUrl as String?),
      ticketUrl: ticketUrl == _undefined
          ? _instance.ticketUrl
          : (ticketUrl as String?),
      titelbild: titelbild == _undefined
          ? _instance.titelbild
          : (titelbild as Fragment_Veranstaltung_titelbild?),
      untereinheit: untereinheit == _undefined
          ? _instance.untereinheit
          : (untereinheit as Fragment_Veranstaltung_untereinheit?),
      timeAndLocation: timeAndLocation == _undefined
          ? _instance.timeAndLocation
          : (timeAndLocation as Fragment_Veranstaltung_timeAndLocation?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      category: category == _undefined
          ? _instance.category
          : (category as List<Fragment_Veranstaltung_category>?),
      source: source == _undefined
          ? _instance.source
          : (source as List<Fragment_Veranstaltung_source>?),
      veranstalterAdresse: veranstalterAdresse == _undefined
          ? _instance.veranstalterAdresse
          : (veranstalterAdresse as Fragment_Adresse?),
      anbieterUrl: anbieterUrl == _undefined
          ? _instance.anbieterUrl
          : (anbieterUrl as String?),
      inhalte: inhalte == _undefined
          ? _instance.inhalte
          : (inhalte as List<Fragment_Veranstaltung_inhalte>?),
    ),
  );

  CopyWith_Fragment_Veranstaltung_titelbild<TRes> get titelbild {
    final local$titelbild = _instance.titelbild;
    return local$titelbild == null
        ? CopyWith_Fragment_Veranstaltung_titelbild.stub(_then(_instance))
        : CopyWith_Fragment_Veranstaltung_titelbild(
            local$titelbild,
            (e) => call(titelbild: e),
          );
  }

  CopyWith_Fragment_Veranstaltung_untereinheit<TRes> get untereinheit {
    final local$untereinheit = _instance.untereinheit;
    return local$untereinheit == null
        ? CopyWith_Fragment_Veranstaltung_untereinheit.stub(_then(_instance))
        : CopyWith_Fragment_Veranstaltung_untereinheit(
            local$untereinheit,
            (e) => call(untereinheit: e),
          );
  }

  CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> get timeAndLocation {
    final local$timeAndLocation = _instance.timeAndLocation;
    return local$timeAndLocation == null
        ? CopyWith_Fragment_Veranstaltung_timeAndLocation.stub(_then(_instance))
        : CopyWith_Fragment_Veranstaltung_timeAndLocation(
            local$timeAndLocation,
            (e) => call(timeAndLocation: e),
          );
  }

  TRes category(
    Iterable<Fragment_Veranstaltung_category>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_category<
          Fragment_Veranstaltung_category
        >
      >?,
    )
    _fn,
  ) => call(
    category: _fn(
      _instance.category?.map(
        (e) => CopyWith_Fragment_Veranstaltung_category(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes source(
    Iterable<Fragment_Veranstaltung_source>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_source<Fragment_Veranstaltung_source>
      >?,
    )
    _fn,
  ) => call(
    source: _fn(
      _instance.source?.map(
        (e) => CopyWith_Fragment_Veranstaltung_source(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith_Fragment_Adresse<TRes> get veranstalterAdresse {
    final local$veranstalterAdresse = _instance.veranstalterAdresse;
    return local$veranstalterAdresse == null
        ? CopyWith_Fragment_Adresse.stub(_then(_instance))
        : CopyWith_Fragment_Adresse(
            local$veranstalterAdresse,
            (e) => call(veranstalterAdresse: e),
          );
  }

  TRes inhalte(
    Iterable<Fragment_Veranstaltung_inhalte>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_inhalte<Fragment_Veranstaltung_inhalte>
      >?,
    )
    _fn,
  ) => call(
    inhalte: _fn(
      _instance.inhalte?.map(
        (e) => CopyWith_Fragment_Veranstaltung_inhalte(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung<TRes>
    implements CopyWith_Fragment_Veranstaltung<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung(this._res);

  TRes _res;

  call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    Fragment_Veranstaltung_titelbild? titelbild,
    Fragment_Veranstaltung_untereinheit? untereinheit,
    Fragment_Veranstaltung_timeAndLocation? timeAndLocation,
    String? $__typename,
    List<Fragment_Veranstaltung_category>? category,
    List<Fragment_Veranstaltung_source>? source,
    Fragment_Adresse? veranstalterAdresse,
    String? anbieterUrl,
    List<Fragment_Veranstaltung_inhalte>? inhalte,
  }) => _res;

  CopyWith_Fragment_Veranstaltung_titelbild<TRes> get titelbild =>
      CopyWith_Fragment_Veranstaltung_titelbild.stub(_res);

  CopyWith_Fragment_Veranstaltung_untereinheit<TRes> get untereinheit =>
      CopyWith_Fragment_Veranstaltung_untereinheit.stub(_res);

  CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> get timeAndLocation =>
      CopyWith_Fragment_Veranstaltung_timeAndLocation.stub(_res);

  category(_fn) => _res;

  source(_fn) => _res;

  CopyWith_Fragment_Adresse<TRes> get veranstalterAdresse =>
      CopyWith_Fragment_Adresse.stub(_res);

  inhalte(_fn) => _res;
}

const fragmentDefinitionVeranstaltung = FragmentDefinitionNode(
  name: NameNode(value: 'Veranstaltung'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'Veranstaltungskalender'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FragmentSpreadNode(
        name: NameNode(value: 'VeranstaltungInfo'),
        directives: [],
      ),
      FieldNode(
        name: NameNode(value: 'veranstalterAdresse'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'Adresse'),
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
        name: NameNode(value: 'buchungsUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'anbieterUrl'),
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
const documentNodeFragmentVeranstaltung = DocumentNode(
  definitions: [
    fragmentDefinitionVeranstaltung,
    fragmentDefinitionVeranstaltungInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
    fragmentDefinitionTimeAndLocation,
    fragmentDefinitionAdresse,
    fragmentDefinitionRichTextBlock,
    fragmentDefinitionImageBlockVeranstaltungsmedien,
  ],
);

extension ClientExtension_Fragment_Veranstaltung on graphql.GraphQLClient {
  void writeFragment_Veranstaltung({
    required Fragment_Veranstaltung data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'Veranstaltung',
        document: documentNodeFragmentVeranstaltung,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_Veranstaltung? readFragment_Veranstaltung({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Veranstaltung',
          document: documentNodeFragmentVeranstaltung,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_Veranstaltung.fromJson(result);
  }
}

class Fragment_Veranstaltung_titelbild
    implements Fragment_VeranstaltungInfo_titelbild {
  Fragment_Veranstaltung_titelbild({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'Veranstaltungskalender_Titelbild',
  });

  factory Fragment_Veranstaltung_titelbild.fromJson(Map<String, dynamic> json) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_titelbild(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Fragment_VeranstaltungsmedienImage? internal;

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
    if (other is! Fragment_Veranstaltung_titelbild ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_Veranstaltung_titelbild
    on Fragment_Veranstaltung_titelbild {
  CopyWith_Fragment_Veranstaltung_titelbild<Fragment_Veranstaltung_titelbild>
  get copyWith => CopyWith_Fragment_Veranstaltung_titelbild(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_titelbild<TRes> {
  factory CopyWith_Fragment_Veranstaltung_titelbild(
    Fragment_Veranstaltung_titelbild instance,
    TRes Function(Fragment_Veranstaltung_titelbild) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_titelbild;

  factory CopyWith_Fragment_Veranstaltung_titelbild.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_titelbild;

  TRes call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal;
}

class _CopyWithImpl_Fragment_Veranstaltung_titelbild<TRes>
    implements CopyWith_Fragment_Veranstaltung_titelbild<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_titelbild(this._instance, this._then);

  final Fragment_Veranstaltung_titelbild _instance;

  final TRes Function(Fragment_Veranstaltung_titelbild) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_titelbild(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_Veranstaltung_titelbild<TRes>
    implements CopyWith_Fragment_Veranstaltung_titelbild<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_titelbild(this._res);

  TRes _res;

  call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_Veranstaltung_untereinheit
    implements Fragment_VeranstaltungInfo_untereinheit {
  Fragment_Veranstaltung_untereinheit({
    required this.id,
    this.$__typename = 'BereichBUntereinheit',
  });

  factory Fragment_Veranstaltung_untereinheit.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_untereinheit(
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
    if (other is! Fragment_Veranstaltung_untereinheit ||
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

extension UtilityExtension_Fragment_Veranstaltung_untereinheit
    on Fragment_Veranstaltung_untereinheit {
  CopyWith_Fragment_Veranstaltung_untereinheit<
    Fragment_Veranstaltung_untereinheit
  >
  get copyWith => CopyWith_Fragment_Veranstaltung_untereinheit(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_untereinheit<TRes> {
  factory CopyWith_Fragment_Veranstaltung_untereinheit(
    Fragment_Veranstaltung_untereinheit instance,
    TRes Function(Fragment_Veranstaltung_untereinheit) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_untereinheit;

  factory CopyWith_Fragment_Veranstaltung_untereinheit.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_untereinheit;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl_Fragment_Veranstaltung_untereinheit<TRes>
    implements CopyWith_Fragment_Veranstaltung_untereinheit<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_untereinheit(this._instance, this._then);

  final Fragment_Veranstaltung_untereinheit _instance;

  final TRes Function(Fragment_Veranstaltung_untereinheit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_Veranstaltung_untereinheit(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_untereinheit<TRes>
    implements CopyWith_Fragment_Veranstaltung_untereinheit<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_untereinheit(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Fragment_Veranstaltung_timeAndLocation
    implements
        Fragment_VeranstaltungInfo_timeAndLocation,
        Fragment_TimeAndLocation_timeAndLocation {
  Fragment_Veranstaltung_timeAndLocation({
    this.locationName,
    this.address,
    this.coordinates,
    this.dates,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation',
  });

  factory Fragment_Veranstaltung_timeAndLocation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$locationName = json['locationName'];
    final l$address = json['address'];
    final l$coordinates = json['coordinates'];
    final l$dates = json['dates'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_timeAndLocation(
      locationName: (l$locationName as String?),
      address: (l$address as String?),
      coordinates: (l$coordinates as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      dates: (l$dates as List<dynamic>?)
          ?.map(
            (e) => Fragment_Veranstaltung_timeAndLocation_dates.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? locationName;

  final String? address;

  final List<double>? coordinates;

  final List<Fragment_Veranstaltung_timeAndLocation_dates>? dates;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$coordinates = coordinates;
    _resultData['coordinates'] = l$coordinates?.map((e) => e).toList();
    final l$dates = dates;
    _resultData['dates'] = l$dates?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$locationName = locationName;
    final l$address = address;
    final l$coordinates = coordinates;
    final l$dates = dates;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$locationName,
      l$address,
      l$coordinates == null
          ? null
          : Object.hashAll(l$coordinates.map((v) => v)),
      l$dates == null ? null : Object.hashAll(l$dates.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Veranstaltung_timeAndLocation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$coordinates = coordinates;
    final lOther$coordinates = other.coordinates;
    if (l$coordinates != null && lOther$coordinates != null) {
      if (l$coordinates.length != lOther$coordinates.length) {
        return false;
      }
      for (int i = 0; i < l$coordinates.length; i++) {
        final l$coordinates$entry = l$coordinates[i];
        final lOther$coordinates$entry = lOther$coordinates[i];
        if (l$coordinates$entry != lOther$coordinates$entry) {
          return false;
        }
      }
    } else if (l$coordinates != lOther$coordinates) {
      return false;
    }
    final l$dates = dates;
    final lOther$dates = other.dates;
    if (l$dates != null && lOther$dates != null) {
      if (l$dates.length != lOther$dates.length) {
        return false;
      }
      for (int i = 0; i < l$dates.length; i++) {
        final l$dates$entry = l$dates[i];
        final lOther$dates$entry = lOther$dates[i];
        if (l$dates$entry != lOther$dates$entry) {
          return false;
        }
      }
    } else if (l$dates != lOther$dates) {
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

extension UtilityExtension_Fragment_Veranstaltung_timeAndLocation
    on Fragment_Veranstaltung_timeAndLocation {
  CopyWith_Fragment_Veranstaltung_timeAndLocation<
    Fragment_Veranstaltung_timeAndLocation
  >
  get copyWith =>
      CopyWith_Fragment_Veranstaltung_timeAndLocation(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> {
  factory CopyWith_Fragment_Veranstaltung_timeAndLocation(
    Fragment_Veranstaltung_timeAndLocation instance,
    TRes Function(Fragment_Veranstaltung_timeAndLocation) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation;

  factory CopyWith_Fragment_Veranstaltung_timeAndLocation.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation;

  TRes call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_Veranstaltung_timeAndLocation_dates>? dates,
    String? $__typename,
  });
  TRes dates(
    Iterable<Fragment_Veranstaltung_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<
          Fragment_Veranstaltung_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation<TRes>
    implements CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation(
    this._instance,
    this._then,
  );

  final Fragment_Veranstaltung_timeAndLocation _instance;

  final TRes Function(Fragment_Veranstaltung_timeAndLocation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? locationName = _undefined,
    Object? address = _undefined,
    Object? coordinates = _undefined,
    Object? dates = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_timeAndLocation(
      locationName: locationName == _undefined
          ? _instance.locationName
          : (locationName as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      coordinates: coordinates == _undefined
          ? _instance.coordinates
          : (coordinates as List<double>?),
      dates: dates == _undefined
          ? _instance.dates
          : (dates as List<Fragment_Veranstaltung_timeAndLocation_dates>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes dates(
    Iterable<Fragment_Veranstaltung_timeAndLocation_dates>? Function(
      Iterable<
        CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<
          Fragment_Veranstaltung_timeAndLocation_dates
        >
      >?,
    )
    _fn,
  ) => call(
    dates: _fn(
      _instance.dates?.map(
        (e) =>
            CopyWith_Fragment_Veranstaltung_timeAndLocation_dates(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation<TRes>
    implements CopyWith_Fragment_Veranstaltung_timeAndLocation<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation(this._res);

  TRes _res;

  call({
    String? locationName,
    String? address,
    List<double>? coordinates,
    List<Fragment_Veranstaltung_timeAndLocation_dates>? dates,
    String? $__typename,
  }) => _res;

  dates(_fn) => _res;
}

class Fragment_Veranstaltung_timeAndLocation_dates
    implements
        Fragment_VeranstaltungInfo_timeAndLocation_dates,
        Fragment_TimeAndLocation_timeAndLocation_dates {
  Fragment_Veranstaltung_timeAndLocation_dates({
    this.id,
    this.end,
    this.start,
    this.$__typename = 'Veranstaltungskalender_TimeAndLocation_Dates',
  });

  factory Fragment_Veranstaltung_timeAndLocation_dates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$end = json['end'];
    final l$start = json['start'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_timeAndLocation_dates(
      id: (l$id as String?),
      end: l$end == null ? null : DateTime.parse((l$end as String)),
      start: l$start == null ? null : DateTime.parse((l$start as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final DateTime? end;

  final DateTime? start;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$end = end;
    _resultData['end'] = l$end?.toIso8601String();
    final l$start = start;
    _resultData['start'] = l$start?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$end = end;
    final l$start = start;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$end, l$start, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Veranstaltung_timeAndLocation_dates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
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

extension UtilityExtension_Fragment_Veranstaltung_timeAndLocation_dates
    on Fragment_Veranstaltung_timeAndLocation_dates {
  CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<
    Fragment_Veranstaltung_timeAndLocation_dates
  >
  get copyWith =>
      CopyWith_Fragment_Veranstaltung_timeAndLocation_dates(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<TRes> {
  factory CopyWith_Fragment_Veranstaltung_timeAndLocation_dates(
    Fragment_Veranstaltung_timeAndLocation_dates instance,
    TRes Function(Fragment_Veranstaltung_timeAndLocation_dates) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation_dates;

  factory CopyWith_Fragment_Veranstaltung_timeAndLocation_dates.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation_dates;

  TRes call({String? id, DateTime? end, DateTime? start, String? $__typename});
}

class _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_timeAndLocation_dates(
    this._instance,
    this._then,
  );

  final Fragment_Veranstaltung_timeAndLocation_dates _instance;

  final TRes Function(Fragment_Veranstaltung_timeAndLocation_dates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? end = _undefined,
    Object? start = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_timeAndLocation_dates(
      id: id == _undefined ? _instance.id : (id as String?),
      end: end == _undefined ? _instance.end : (end as DateTime?),
      start: start == _undefined ? _instance.start : (start as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation_dates<TRes>
    implements CopyWith_Fragment_Veranstaltung_timeAndLocation_dates<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_timeAndLocation_dates(this._res);

  TRes _res;

  call({String? id, DateTime? end, DateTime? start, String? $__typename}) =>
      _res;
}

class Fragment_Veranstaltung_category
    implements Fragment_VeranstaltungInfo_category {
  Fragment_Veranstaltung_category({
    required this.id,
    required this.label,
    this.$__typename = 'VeranstaltungskalenderKategorie',
  });

  factory Fragment_Veranstaltung_category.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_category(
      id: (l$id as String),
      label: (l$label as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Veranstaltung_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

extension UtilityExtension_Fragment_Veranstaltung_category
    on Fragment_Veranstaltung_category {
  CopyWith_Fragment_Veranstaltung_category<Fragment_Veranstaltung_category>
  get copyWith => CopyWith_Fragment_Veranstaltung_category(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_category<TRes> {
  factory CopyWith_Fragment_Veranstaltung_category(
    Fragment_Veranstaltung_category instance,
    TRes Function(Fragment_Veranstaltung_category) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_category;

  factory CopyWith_Fragment_Veranstaltung_category.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_category;

  TRes call({String? id, String? label, String? $__typename});
}

class _CopyWithImpl_Fragment_Veranstaltung_category<TRes>
    implements CopyWith_Fragment_Veranstaltung_category<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_category(this._instance, this._then);

  final Fragment_Veranstaltung_category _instance;

  final TRes Function(Fragment_Veranstaltung_category) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? label = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_category(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      label: label == _undefined || label == null
          ? _instance.label
          : (label as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_category<TRes>
    implements CopyWith_Fragment_Veranstaltung_category<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_category(this._res);

  TRes _res;

  call({String? id, String? label, String? $__typename}) => _res;
}

class Fragment_Veranstaltung_source
    implements Fragment_VeranstaltungInfo_source {
  Fragment_Veranstaltung_source({
    required this.id,
    this.name,
    this.logo,
    this.$__typename = 'VeranstaltungskalenderQuelle',
  });

  factory Fragment_Veranstaltung_source.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$logo = json['logo'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_source(
      id: (l$id as String),
      name: (l$name as String?),
      logo: l$logo == null
          ? null
          : Fragment_Veranstaltung_source_logo.fromJson(
              (l$logo as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final Fragment_Veranstaltung_source_logo? logo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$logo = logo;
    _resultData['logo'] = l$logo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$logo = logo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$logo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Veranstaltung_source ||
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
    final l$logo = logo;
    final lOther$logo = other.logo;
    if (l$logo != lOther$logo) {
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

extension UtilityExtension_Fragment_Veranstaltung_source
    on Fragment_Veranstaltung_source {
  CopyWith_Fragment_Veranstaltung_source<Fragment_Veranstaltung_source>
  get copyWith => CopyWith_Fragment_Veranstaltung_source(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_source<TRes> {
  factory CopyWith_Fragment_Veranstaltung_source(
    Fragment_Veranstaltung_source instance,
    TRes Function(Fragment_Veranstaltung_source) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_source;

  factory CopyWith_Fragment_Veranstaltung_source.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_source;

  TRes call({
    String? id,
    String? name,
    Fragment_Veranstaltung_source_logo? logo,
    String? $__typename,
  });
  CopyWith_Fragment_Veranstaltung_source_logo<TRes> get logo;
}

class _CopyWithImpl_Fragment_Veranstaltung_source<TRes>
    implements CopyWith_Fragment_Veranstaltung_source<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_source(this._instance, this._then);

  final Fragment_Veranstaltung_source _instance;

  final TRes Function(Fragment_Veranstaltung_source) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? logo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_source(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      logo: logo == _undefined
          ? _instance.logo
          : (logo as Fragment_Veranstaltung_source_logo?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_Veranstaltung_source_logo<TRes> get logo {
    final local$logo = _instance.logo;
    return local$logo == null
        ? CopyWith_Fragment_Veranstaltung_source_logo.stub(_then(_instance))
        : CopyWith_Fragment_Veranstaltung_source_logo(
            local$logo,
            (e) => call(logo: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_Veranstaltung_source<TRes>
    implements CopyWith_Fragment_Veranstaltung_source<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_source(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Fragment_Veranstaltung_source_logo? logo,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_Veranstaltung_source_logo<TRes> get logo =>
      CopyWith_Fragment_Veranstaltung_source_logo.stub(_res);
}

class Fragment_Veranstaltung_source_logo
    implements Fragment_VeranstaltungInfo_source_logo {
  Fragment_Veranstaltung_source_logo({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'VeranstaltungskalenderQuelle_Logo',
  });

  factory Fragment_Veranstaltung_source_logo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_source_logo(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Fragment_VeranstaltungsmedienImage.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Fragment_VeranstaltungsmedienImage? internal;

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
    if (other is! Fragment_Veranstaltung_source_logo ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_Veranstaltung_source_logo
    on Fragment_Veranstaltung_source_logo {
  CopyWith_Fragment_Veranstaltung_source_logo<
    Fragment_Veranstaltung_source_logo
  >
  get copyWith => CopyWith_Fragment_Veranstaltung_source_logo(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_source_logo<TRes> {
  factory CopyWith_Fragment_Veranstaltung_source_logo(
    Fragment_Veranstaltung_source_logo instance,
    TRes Function(Fragment_Veranstaltung_source_logo) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_source_logo;

  factory CopyWith_Fragment_Veranstaltung_source_logo.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_source_logo;

  TRes call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal;
}

class _CopyWithImpl_Fragment_Veranstaltung_source_logo<TRes>
    implements CopyWith_Fragment_Veranstaltung_source_logo<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_source_logo(this._instance, this._then);

  final Fragment_Veranstaltung_source_logo _instance;

  final TRes Function(Fragment_Veranstaltung_source_logo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_source_logo(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal as Fragment_VeranstaltungsmedienImage?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage.stub(_then(_instance))
        : CopyWith_Fragment_VeranstaltungsmedienImage(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_Veranstaltung_source_logo<TRes>
    implements CopyWith_Fragment_Veranstaltung_source_logo<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_source_logo(this._res);

  TRes _res;

  call({
    bool? $external,
    String? url,
    Fragment_VeranstaltungsmedienImage? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get internal =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Fragment_Veranstaltung_inhalte {
  Fragment_Veranstaltung_inhalte({required this.$__typename});

  factory Fragment_Veranstaltung_inhalte.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "RichTextBlock":
        return Fragment_Veranstaltung_inhalte__RichTextBlock.fromJson(json);

      case "ImageBlockVeranstaltungsmedien":
        return Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Fragment_Veranstaltung_inhalte(
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
    if (other is! Fragment_Veranstaltung_inhalte ||
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

extension UtilityExtension_Fragment_Veranstaltung_inhalte
    on Fragment_Veranstaltung_inhalte {
  CopyWith_Fragment_Veranstaltung_inhalte<Fragment_Veranstaltung_inhalte>
  get copyWith => CopyWith_Fragment_Veranstaltung_inhalte(this, (i) => i);

  _T when<_T>({
    required _T Function(Fragment_Veranstaltung_inhalte__RichTextBlock)
    richTextBlock,
    required _T Function(
      Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien,
    )
    imageBlockVeranstaltungsmedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        return richTextBlock(
          this as Fragment_Veranstaltung_inhalte__RichTextBlock,
        );

      case "ImageBlockVeranstaltungsmedien":
        return imageBlockVeranstaltungsmedien(
          this
              as Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Fragment_Veranstaltung_inhalte__RichTextBlock)? richTextBlock,
    _T Function(Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien)?
    imageBlockVeranstaltungsmedien,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "RichTextBlock":
        if (richTextBlock != null) {
          return richTextBlock(
            this as Fragment_Veranstaltung_inhalte__RichTextBlock,
          );
        } else {
          return orElse();
        }

      case "ImageBlockVeranstaltungsmedien":
        if (imageBlockVeranstaltungsmedien != null) {
          return imageBlockVeranstaltungsmedien(
            this
                as Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Fragment_Veranstaltung_inhalte<TRes> {
  factory CopyWith_Fragment_Veranstaltung_inhalte(
    Fragment_Veranstaltung_inhalte instance,
    TRes Function(Fragment_Veranstaltung_inhalte) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_inhalte;

  factory CopyWith_Fragment_Veranstaltung_inhalte.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Veranstaltung_inhalte;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Fragment_Veranstaltung_inhalte<TRes>
    implements CopyWith_Fragment_Veranstaltung_inhalte<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_inhalte(this._instance, this._then);

  final Fragment_Veranstaltung_inhalte _instance;

  final TRes Function(Fragment_Veranstaltung_inhalte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Fragment_Veranstaltung_inhalte(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_inhalte<TRes>
    implements CopyWith_Fragment_Veranstaltung_inhalte<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_inhalte(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Fragment_Veranstaltung_inhalte__RichTextBlock
    implements Fragment_RichTextBlock, Fragment_Veranstaltung_inhalte {
  Fragment_Veranstaltung_inhalte__RichTextBlock({
    this.contentHtml,
    this.$__typename = 'RichTextBlock',
  });

  factory Fragment_Veranstaltung_inhalte__RichTextBlock.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$contentHtml = json['contentHtml'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_inhalte__RichTextBlock(
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
    if (other is! Fragment_Veranstaltung_inhalte__RichTextBlock ||
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

extension UtilityExtension_Fragment_Veranstaltung_inhalte__RichTextBlock
    on Fragment_Veranstaltung_inhalte__RichTextBlock {
  CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock<
    Fragment_Veranstaltung_inhalte__RichTextBlock
  >
  get copyWith =>
      CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock(this, (i) => i);
}

abstract class CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock<TRes> {
  factory CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock(
    Fragment_Veranstaltung_inhalte__RichTextBlock instance,
    TRes Function(Fragment_Veranstaltung_inhalte__RichTextBlock) then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_inhalte__RichTextBlock;

  factory CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__RichTextBlock;

  TRes call({String? contentHtml, String? $__typename});
}

class _CopyWithImpl_Fragment_Veranstaltung_inhalte__RichTextBlock<TRes>
    implements CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock<TRes> {
  _CopyWithImpl_Fragment_Veranstaltung_inhalte__RichTextBlock(
    this._instance,
    this._then,
  );

  final Fragment_Veranstaltung_inhalte__RichTextBlock _instance;

  final TRes Function(Fragment_Veranstaltung_inhalte__RichTextBlock) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentHtml = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Veranstaltung_inhalte__RichTextBlock(
      contentHtml: contentHtml == _undefined
          ? _instance.contentHtml
          : (contentHtml as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__RichTextBlock<TRes>
    implements CopyWith_Fragment_Veranstaltung_inhalte__RichTextBlock<TRes> {
  _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__RichTextBlock(this._res);

  TRes _res;

  call({String? contentHtml, String? $__typename}) => _res;
}

class Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien
    implements
        Fragment_ImageBlockVeranstaltungsmedien,
        Fragment_Veranstaltung_inhalte {
  Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien({
    this.image,
    this.$__typename = 'ImageBlockVeranstaltungsmedien',
  });

  factory Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
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
            is! Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien ||
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

extension UtilityExtension_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien
    on Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien {
  CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
    Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien
  >
  get copyWith =>
      CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
> {
  factory CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
    Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien instance,
    TRes Function(
      Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien,
    )
    then,
  ) = _CopyWithImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien;

  factory CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien;

  TRes call({Fragment_VeranstaltungsmedienImage? image, String? $__typename});
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image;
}

class _CopyWithImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
>
    implements
        CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
          TRes
        > {
  _CopyWithImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
    this._instance,
    this._then,
  );

  final Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien
  _instance;

  final TRes Function(
    Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? image = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
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

class _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
  TRes
>
    implements
        CopyWith_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien<
          TRes
        > {
  _CopyWithStubImpl_Fragment_Veranstaltung_inhalte__ImageBlockVeranstaltungsmedien(
    this._res,
  );

  TRes _res;

  call({Fragment_VeranstaltungsmedienImage? image, String? $__typename}) =>
      _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

class Variables_Query_TermineList {
  factory Variables_Query_TermineList({
    required String kommuneIdBereichA,
    required String standortId,
    required DateTime von,
    required DateTime bis,
    required bool includeVeranstaltungen,
    required bool includeAbfallkalender,
    int? page,
    int? limit,
    String? search,
    List<String?>? categoryIds,
    List<String?>? untereinheiten,
    Input_TerminFilterInput? abfallkalenderFilter,
    String? vonString,
    String? bisString,
    String? kommuneString,
  }) => Variables_Query_TermineList._({
    r'kommuneIdBereichA': kommuneIdBereichA,
    r'standortId': standortId,
    r'von': von,
    r'bis': bis,
    r'includeVeranstaltungen': includeVeranstaltungen,
    r'includeAbfallkalender': includeAbfallkalender,
    if (page != null) r'page': page,
    if (limit != null) r'limit': limit,
    if (search != null) r'search': search,
    if (categoryIds != null) r'categoryIds': categoryIds,
    if (untereinheiten != null) r'untereinheiten': untereinheiten,
    if (abfallkalenderFilter != null)
      r'abfallkalenderFilter': abfallkalenderFilter,
    if (vonString != null) r'vonString': vonString,
    if (bisString != null) r'bisString': bisString,
    if (kommuneString != null) r'kommuneString': kommuneString,
  });

  Variables_Query_TermineList._(this._$data);

  factory Variables_Query_TermineList.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichA = data['kommuneIdBereichA'];
    result$data['kommuneIdBereichA'] = (l$kommuneIdBereichA as String);
    final l$standortId = data['standortId'];
    result$data['standortId'] = (l$standortId as String);
    final l$von = data['von'];
    result$data['von'] = DateTime.parse((l$von as String));
    final l$bis = data['bis'];
    result$data['bis'] = DateTime.parse((l$bis as String));
    final l$includeVeranstaltungen = data['includeVeranstaltungen'];
    result$data['includeVeranstaltungen'] = (l$includeVeranstaltungen as bool);
    final l$includeAbfallkalender = data['includeAbfallkalender'];
    result$data['includeAbfallkalender'] = (l$includeAbfallkalender as bool);
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    if (data.containsKey('search')) {
      final l$search = data['search'];
      result$data['search'] = (l$search as String?);
    }
    if (data.containsKey('categoryIds')) {
      final l$categoryIds = data['categoryIds'];
      result$data['categoryIds'] = (l$categoryIds as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList();
    }
    if (data.containsKey('untereinheiten')) {
      final l$untereinheiten = data['untereinheiten'];
      result$data['untereinheiten'] = (l$untereinheiten as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList();
    }
    if (data.containsKey('abfallkalenderFilter')) {
      final l$abfallkalenderFilter = data['abfallkalenderFilter'];
      result$data['abfallkalenderFilter'] = l$abfallkalenderFilter == null
          ? null
          : Input_TerminFilterInput.fromJson(
              (l$abfallkalenderFilter as Map<String, dynamic>),
            );
    }
    if (data.containsKey('vonString')) {
      final l$vonString = data['vonString'];
      result$data['vonString'] = (l$vonString as String?);
    }
    if (data.containsKey('bisString')) {
      final l$bisString = data['bisString'];
      result$data['bisString'] = (l$bisString as String?);
    }
    if (data.containsKey('kommuneString')) {
      final l$kommuneString = data['kommuneString'];
      result$data['kommuneString'] = (l$kommuneString as String?);
    }
    return Variables_Query_TermineList._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneIdBereichA => (_$data['kommuneIdBereichA'] as String);

  String get standortId => (_$data['standortId'] as String);

  DateTime get von => (_$data['von'] as DateTime);

  DateTime get bis => (_$data['bis'] as DateTime);

  bool get includeVeranstaltungen => (_$data['includeVeranstaltungen'] as bool);

  bool get includeAbfallkalender => (_$data['includeAbfallkalender'] as bool);

  int? get page => (_$data['page'] as int?);

  int? get limit => (_$data['limit'] as int?);

  String? get search => (_$data['search'] as String?);

  List<String?>? get categoryIds => (_$data['categoryIds'] as List<String?>?);

  List<String?>? get untereinheiten =>
      (_$data['untereinheiten'] as List<String?>?);

  Input_TerminFilterInput? get abfallkalenderFilter =>
      (_$data['abfallkalenderFilter'] as Input_TerminFilterInput?);

  String? get vonString => (_$data['vonString'] as String?);

  String? get bisString => (_$data['bisString'] as String?);

  String? get kommuneString => (_$data['kommuneString'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichA = kommuneIdBereichA;
    result$data['kommuneIdBereichA'] = l$kommuneIdBereichA;
    final l$standortId = standortId;
    result$data['standortId'] = l$standortId;
    final l$von = von;
    result$data['von'] = l$von.toIso8601String();
    final l$bis = bis;
    result$data['bis'] = l$bis.toIso8601String();
    final l$includeVeranstaltungen = includeVeranstaltungen;
    result$data['includeVeranstaltungen'] = l$includeVeranstaltungen;
    final l$includeAbfallkalender = includeAbfallkalender;
    result$data['includeAbfallkalender'] = l$includeAbfallkalender;
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    if (_$data.containsKey('search')) {
      final l$search = search;
      result$data['search'] = l$search;
    }
    if (_$data.containsKey('categoryIds')) {
      final l$categoryIds = categoryIds;
      result$data['categoryIds'] = l$categoryIds?.map((e) => e).toList();
    }
    if (_$data.containsKey('untereinheiten')) {
      final l$untereinheiten = untereinheiten;
      result$data['untereinheiten'] = l$untereinheiten?.map((e) => e).toList();
    }
    if (_$data.containsKey('abfallkalenderFilter')) {
      final l$abfallkalenderFilter = abfallkalenderFilter;
      result$data['abfallkalenderFilter'] = l$abfallkalenderFilter?.toJson();
    }
    if (_$data.containsKey('vonString')) {
      final l$vonString = vonString;
      result$data['vonString'] = l$vonString;
    }
    if (_$data.containsKey('bisString')) {
      final l$bisString = bisString;
      result$data['bisString'] = l$bisString;
    }
    if (_$data.containsKey('kommuneString')) {
      final l$kommuneString = kommuneString;
      result$data['kommuneString'] = l$kommuneString;
    }
    return result$data;
  }

  CopyWith_Variables_Query_TermineList<Variables_Query_TermineList>
  get copyWith => CopyWith_Variables_Query_TermineList(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_TermineList ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneIdBereichA = kommuneIdBereichA;
    final lOther$kommuneIdBereichA = other.kommuneIdBereichA;
    if (l$kommuneIdBereichA != lOther$kommuneIdBereichA) {
      return false;
    }
    final l$standortId = standortId;
    final lOther$standortId = other.standortId;
    if (l$standortId != lOther$standortId) {
      return false;
    }
    final l$von = von;
    final lOther$von = other.von;
    if (l$von != lOther$von) {
      return false;
    }
    final l$bis = bis;
    final lOther$bis = other.bis;
    if (l$bis != lOther$bis) {
      return false;
    }
    final l$includeVeranstaltungen = includeVeranstaltungen;
    final lOther$includeVeranstaltungen = other.includeVeranstaltungen;
    if (l$includeVeranstaltungen != lOther$includeVeranstaltungen) {
      return false;
    }
    final l$includeAbfallkalender = includeAbfallkalender;
    final lOther$includeAbfallkalender = other.includeAbfallkalender;
    if (l$includeAbfallkalender != lOther$includeAbfallkalender) {
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
    final l$search = search;
    final lOther$search = other.search;
    if (_$data.containsKey('search') != other._$data.containsKey('search')) {
      return false;
    }
    if (l$search != lOther$search) {
      return false;
    }
    final l$categoryIds = categoryIds;
    final lOther$categoryIds = other.categoryIds;
    if (_$data.containsKey('categoryIds') !=
        other._$data.containsKey('categoryIds')) {
      return false;
    }
    if (l$categoryIds != null && lOther$categoryIds != null) {
      if (l$categoryIds.length != lOther$categoryIds.length) {
        return false;
      }
      for (int i = 0; i < l$categoryIds.length; i++) {
        final l$categoryIds$entry = l$categoryIds[i];
        final lOther$categoryIds$entry = lOther$categoryIds[i];
        if (l$categoryIds$entry != lOther$categoryIds$entry) {
          return false;
        }
      }
    } else if (l$categoryIds != lOther$categoryIds) {
      return false;
    }
    final l$untereinheiten = untereinheiten;
    final lOther$untereinheiten = other.untereinheiten;
    if (_$data.containsKey('untereinheiten') !=
        other._$data.containsKey('untereinheiten')) {
      return false;
    }
    if (l$untereinheiten != null && lOther$untereinheiten != null) {
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
    } else if (l$untereinheiten != lOther$untereinheiten) {
      return false;
    }
    final l$abfallkalenderFilter = abfallkalenderFilter;
    final lOther$abfallkalenderFilter = other.abfallkalenderFilter;
    if (_$data.containsKey('abfallkalenderFilter') !=
        other._$data.containsKey('abfallkalenderFilter')) {
      return false;
    }
    if (l$abfallkalenderFilter != lOther$abfallkalenderFilter) {
      return false;
    }
    final l$vonString = vonString;
    final lOther$vonString = other.vonString;
    if (_$data.containsKey('vonString') !=
        other._$data.containsKey('vonString')) {
      return false;
    }
    if (l$vonString != lOther$vonString) {
      return false;
    }
    final l$bisString = bisString;
    final lOther$bisString = other.bisString;
    if (_$data.containsKey('bisString') !=
        other._$data.containsKey('bisString')) {
      return false;
    }
    if (l$bisString != lOther$bisString) {
      return false;
    }
    final l$kommuneString = kommuneString;
    final lOther$kommuneString = other.kommuneString;
    if (_$data.containsKey('kommuneString') !=
        other._$data.containsKey('kommuneString')) {
      return false;
    }
    if (l$kommuneString != lOther$kommuneString) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneIdBereichA = kommuneIdBereichA;
    final l$standortId = standortId;
    final l$von = von;
    final l$bis = bis;
    final l$includeVeranstaltungen = includeVeranstaltungen;
    final l$includeAbfallkalender = includeAbfallkalender;
    final l$page = page;
    final l$limit = limit;
    final l$search = search;
    final l$categoryIds = categoryIds;
    final l$untereinheiten = untereinheiten;
    final l$abfallkalenderFilter = abfallkalenderFilter;
    final l$vonString = vonString;
    final l$bisString = bisString;
    final l$kommuneString = kommuneString;
    return Object.hashAll([
      l$kommuneIdBereichA,
      l$standortId,
      l$von,
      l$bis,
      l$includeVeranstaltungen,
      l$includeAbfallkalender,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('limit') ? l$limit : const {},
      _$data.containsKey('search') ? l$search : const {},
      _$data.containsKey('categoryIds')
          ? l$categoryIds == null
                ? null
                : Object.hashAll(l$categoryIds.map((v) => v))
          : const {},
      _$data.containsKey('untereinheiten')
          ? l$untereinheiten == null
                ? null
                : Object.hashAll(l$untereinheiten.map((v) => v))
          : const {},
      _$data.containsKey('abfallkalenderFilter')
          ? l$abfallkalenderFilter
          : const {},
      _$data.containsKey('vonString') ? l$vonString : const {},
      _$data.containsKey('bisString') ? l$bisString : const {},
      _$data.containsKey('kommuneString') ? l$kommuneString : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_TermineList<TRes> {
  factory CopyWith_Variables_Query_TermineList(
    Variables_Query_TermineList instance,
    TRes Function(Variables_Query_TermineList) then,
  ) = _CopyWithImpl_Variables_Query_TermineList;

  factory CopyWith_Variables_Query_TermineList.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_TermineList;

  TRes call({
    String? kommuneIdBereichA,
    String? standortId,
    DateTime? von,
    DateTime? bis,
    bool? includeVeranstaltungen,
    bool? includeAbfallkalender,
    int? page,
    int? limit,
    String? search,
    List<String?>? categoryIds,
    List<String?>? untereinheiten,
    Input_TerminFilterInput? abfallkalenderFilter,
    String? vonString,
    String? bisString,
    String? kommuneString,
  });
}

class _CopyWithImpl_Variables_Query_TermineList<TRes>
    implements CopyWith_Variables_Query_TermineList<TRes> {
  _CopyWithImpl_Variables_Query_TermineList(this._instance, this._then);

  final Variables_Query_TermineList _instance;

  final TRes Function(Variables_Query_TermineList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneIdBereichA = _undefined,
    Object? standortId = _undefined,
    Object? von = _undefined,
    Object? bis = _undefined,
    Object? includeVeranstaltungen = _undefined,
    Object? includeAbfallkalender = _undefined,
    Object? page = _undefined,
    Object? limit = _undefined,
    Object? search = _undefined,
    Object? categoryIds = _undefined,
    Object? untereinheiten = _undefined,
    Object? abfallkalenderFilter = _undefined,
    Object? vonString = _undefined,
    Object? bisString = _undefined,
    Object? kommuneString = _undefined,
  }) => _then(
    Variables_Query_TermineList._({
      ..._instance._$data,
      if (kommuneIdBereichA != _undefined && kommuneIdBereichA != null)
        'kommuneIdBereichA': (kommuneIdBereichA as String),
      if (standortId != _undefined && standortId != null)
        'standortId': (standortId as String),
      if (von != _undefined && von != null) 'von': (von as DateTime),
      if (bis != _undefined && bis != null) 'bis': (bis as DateTime),
      if (includeVeranstaltungen != _undefined &&
          includeVeranstaltungen != null)
        'includeVeranstaltungen': (includeVeranstaltungen as bool),
      if (includeAbfallkalender != _undefined && includeAbfallkalender != null)
        'includeAbfallkalender': (includeAbfallkalender as bool),
      if (page != _undefined) 'page': (page as int?),
      if (limit != _undefined) 'limit': (limit as int?),
      if (search != _undefined) 'search': (search as String?),
      if (categoryIds != _undefined)
        'categoryIds': (categoryIds as List<String?>?),
      if (untereinheiten != _undefined)
        'untereinheiten': (untereinheiten as List<String?>?),
      if (abfallkalenderFilter != _undefined)
        'abfallkalenderFilter':
            (abfallkalenderFilter as Input_TerminFilterInput?),
      if (vonString != _undefined) 'vonString': (vonString as String?),
      if (bisString != _undefined) 'bisString': (bisString as String?),
      if (kommuneString != _undefined)
        'kommuneString': (kommuneString as String?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_TermineList<TRes>
    implements CopyWith_Variables_Query_TermineList<TRes> {
  _CopyWithStubImpl_Variables_Query_TermineList(this._res);

  TRes _res;

  call({
    String? kommuneIdBereichA,
    String? standortId,
    DateTime? von,
    DateTime? bis,
    bool? includeVeranstaltungen,
    bool? includeAbfallkalender,
    int? page,
    int? limit,
    String? search,
    List<String?>? categoryIds,
    List<String?>? untereinheiten,
    Input_TerminFilterInput? abfallkalenderFilter,
    String? vonString,
    String? bisString,
    String? kommuneString,
  }) => _res;
}

class Query_TermineList {
  Query_TermineList({
    this.veranstaltungsTermine,
    this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_TermineList.fromJson(Map<String, dynamic> json) {
    final l$veranstaltungsTermine = json['veranstaltungsTermine'];
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_TermineList(
      veranstaltungsTermine: l$veranstaltungsTermine == null
          ? null
          : Query_TermineList_veranstaltungsTermine.fromJson(
              (l$veranstaltungsTermine as Map<String, dynamic>),
            ),
      kommune: l$kommune == null
          ? null
          : Query_TermineList_kommune.fromJson(
              (l$kommune as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_TermineList_veranstaltungsTermine? veranstaltungsTermine;

  final Query_TermineList_kommune? kommune;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$veranstaltungsTermine = veranstaltungsTermine;
    _resultData['veranstaltungsTermine'] = l$veranstaltungsTermine?.toJson();
    final l$kommune = kommune;
    _resultData['kommune'] = l$kommune?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$veranstaltungsTermine = veranstaltungsTermine;
    final l$kommune = kommune;
    final l$$__typename = $__typename;
    return Object.hashAll([l$veranstaltungsTermine, l$kommune, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList || runtimeType != other.runtimeType) {
      return false;
    }
    final l$veranstaltungsTermine = veranstaltungsTermine;
    final lOther$veranstaltungsTermine = other.veranstaltungsTermine;
    if (l$veranstaltungsTermine != lOther$veranstaltungsTermine) {
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

extension UtilityExtension_Query_TermineList on Query_TermineList {
  CopyWith_Query_TermineList<Query_TermineList> get copyWith =>
      CopyWith_Query_TermineList(this, (i) => i);
}

abstract class CopyWith_Query_TermineList<TRes> {
  factory CopyWith_Query_TermineList(
    Query_TermineList instance,
    TRes Function(Query_TermineList) then,
  ) = _CopyWithImpl_Query_TermineList;

  factory CopyWith_Query_TermineList.stub(TRes res) =
      _CopyWithStubImpl_Query_TermineList;

  TRes call({
    Query_TermineList_veranstaltungsTermine? veranstaltungsTermine,
    Query_TermineList_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_TermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine;
  CopyWith_Query_TermineList_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_TermineList<TRes>
    implements CopyWith_Query_TermineList<TRes> {
  _CopyWithImpl_Query_TermineList(this._instance, this._then);

  final Query_TermineList _instance;

  final TRes Function(Query_TermineList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? veranstaltungsTermine = _undefined,
    Object? kommune = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList(
      veranstaltungsTermine: veranstaltungsTermine == _undefined
          ? _instance.veranstaltungsTermine
          : (veranstaltungsTermine as Query_TermineList_veranstaltungsTermine?),
      kommune: kommune == _undefined
          ? _instance.kommune
          : (kommune as Query_TermineList_kommune?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_TermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine {
    final local$veranstaltungsTermine = _instance.veranstaltungsTermine;
    return local$veranstaltungsTermine == null
        ? CopyWith_Query_TermineList_veranstaltungsTermine.stub(
            _then(_instance),
          )
        : CopyWith_Query_TermineList_veranstaltungsTermine(
            local$veranstaltungsTermine,
            (e) => call(veranstaltungsTermine: e),
          );
  }

  CopyWith_Query_TermineList_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return local$kommune == null
        ? CopyWith_Query_TermineList_kommune.stub(_then(_instance))
        : CopyWith_Query_TermineList_kommune(
            local$kommune,
            (e) => call(kommune: e),
          );
  }
}

class _CopyWithStubImpl_Query_TermineList<TRes>
    implements CopyWith_Query_TermineList<TRes> {
  _CopyWithStubImpl_Query_TermineList(this._res);

  TRes _res;

  call({
    Query_TermineList_veranstaltungsTermine? veranstaltungsTermine,
    Query_TermineList_kommune? kommune,
    String? $__typename,
  }) => _res;

  CopyWith_Query_TermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine =>
      CopyWith_Query_TermineList_veranstaltungsTermine.stub(_res);

  CopyWith_Query_TermineList_kommune<TRes> get kommune =>
      CopyWith_Query_TermineList_kommune.stub(_res);
}

const documentNodeQueryTermineList = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'TermineList'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneIdBereichA')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'standortId')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'von')),
          type: NamedTypeNode(
            name: NameNode(value: 'DateTime'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bis')),
          type: NamedTypeNode(
            name: NameNode(value: 'DateTime'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(
            name: NameNode(value: 'includeVeranstaltungen'),
          ),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(
            name: NameNode(value: 'includeAbfallkalender'),
          ),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'search')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'categoryIds')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: false,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'untereinheiten')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: false,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'abfallkalenderFilter')),
          type: NamedTypeNode(
            name: NameNode(value: 'TerminFilterInput'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'vonString')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bisString')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneString')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
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
            name: NameNode(value: 'veranstaltungsTermine'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommune'),
                value: VariableNode(name: NameNode(value: 'kommuneString')),
              ),
              ArgumentNode(
                name: NameNode(value: 'untereinheiten'),
                value: VariableNode(name: NameNode(value: 'untereinheiten')),
              ),
              ArgumentNode(
                name: NameNode(value: 'von'),
                value: VariableNode(name: NameNode(value: 'vonString')),
              ),
              ArgumentNode(
                name: NameNode(value: 'bis'),
                value: VariableNode(name: NameNode(value: 'bisString')),
              ),
              ArgumentNode(
                name: NameNode(value: 'categoryIds'),
                value: VariableNode(name: NameNode(value: 'categoryIds')),
              ),
              ArgumentNode(
                name: NameNode(value: 'search'),
                value: VariableNode(name: NameNode(value: 'search')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'visible'),
                value: BooleanValueNode(value: true),
              ),
            ],
            directives: [
              DirectiveNode(
                name: NameNode(value: 'include'),
                arguments: [
                  ArgumentNode(
                    name: NameNode(value: 'if'),
                    value: VariableNode(
                      name: NameNode(value: 'includeVeranstaltungen'),
                    ),
                  ),
                ],
              ),
            ],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'totalDocs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'totalPages'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
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
                  name: NameNode(value: 'limit'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
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
                        name: NameNode(value: 'titel'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'subtitle'),
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
                        name: NameNode(value: 'buchungsUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'ticketUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'anbieterUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'locationName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'address'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'coordinates'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'start'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'end'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'dates'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'start'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'end'),
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
                        name: NameNode(value: 'titelbild'),
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
                              name: NameNode(value: 'label'),
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
            name: NameNode(value: 'kommune'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommuneId'),
                value: VariableNode(name: NameNode(value: 'kommuneIdBereichA')),
              ),
            ],
            directives: [
              DirectiveNode(
                name: NameNode(value: 'include'),
                arguments: [
                  ArgumentNode(
                    name: NameNode(value: 'if'),
                    value: VariableNode(
                      name: NameNode(value: 'includeAbfallkalender'),
                    ),
                  ),
                ],
              ),
            ],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'abfallkalender'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'standortId'),
                      value: VariableNode(name: NameNode(value: 'standortId')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'von'),
                      value: VariableNode(name: NameNode(value: 'von')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'bis'),
                      value: VariableNode(name: NameNode(value: 'bis')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'where'),
                      value: VariableNode(
                        name: NameNode(value: 'abfallkalenderFilter'),
                      ),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'AbfallkalenderTermin'),
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
    fragmentDefinitionAbfallkalenderTermin,
  ],
);
Query_TermineList _parserFn_Query_TermineList(Map<String, dynamic> data) =>
    Query_TermineList.fromJson(data);
typedef OnQueryComplete_Query_TermineList =
    FutureOr<void> Function(Map<String, dynamic>?, Query_TermineList?);

class Options_Query_TermineList
    extends graphql.QueryOptions<Query_TermineList> {
  Options_Query_TermineList({
    String? operationName,
    required Variables_Query_TermineList variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_TermineList? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_TermineList? onComplete,
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
                 data == null ? null : _parserFn_Query_TermineList(data),
               ),
         onError: onError,
         document: documentNodeQueryTermineList,
         parserFn: _parserFn_Query_TermineList,
       );

  final OnQueryComplete_Query_TermineList? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_TermineList
    extends graphql.WatchQueryOptions<Query_TermineList> {
  WatchOptions_Query_TermineList({
    String? operationName,
    required Variables_Query_TermineList variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_TermineList? typedOptimisticResult,
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
         document: documentNodeQueryTermineList,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_TermineList,
       );
}

class FetchMoreOptions_Query_TermineList extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_TermineList({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_TermineList variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryTermineList,
       );
}

extension ClientExtension_Query_TermineList on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_TermineList>> query_TermineList(
    Options_Query_TermineList options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_TermineList> watchQuery_TermineList(
    WatchOptions_Query_TermineList options,
  ) => this.watchQuery(options);

  void writeQuery_TermineList({
    required Query_TermineList data,
    required Variables_Query_TermineList variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryTermineList),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_TermineList? readQuery_TermineList({
    required Variables_Query_TermineList variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryTermineList),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_TermineList.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_TermineList> useQuery_TermineList(
  Options_Query_TermineList options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_TermineList> useWatchQuery_TermineList(
  WatchOptions_Query_TermineList options,
) => graphql_flutter.useWatchQuery(options);

class Query_TermineList_Widget
    extends graphql_flutter.Query<Query_TermineList> {
  Query_TermineList_Widget({
    widgets.Key? key,
    required Options_Query_TermineList options,
    required graphql_flutter.QueryBuilder<Query_TermineList> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_TermineList_veranstaltungsTermine {
  Query_TermineList_veranstaltungsTermine({
    this.totalDocs,
    this.totalPages,
    this.hasNextPage,
    this.page,
    this.limit,
    this.docs,
    this.$__typename = 'VeranstaltungsTermineResult',
  });

  factory Query_TermineList_veranstaltungsTermine.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$totalDocs = json['totalDocs'];
    final l$totalPages = json['totalPages'];
    final l$hasNextPage = json['hasNextPage'];
    final l$page = json['page'];
    final l$limit = json['limit'];
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine(
      totalDocs: (l$totalDocs as int?),
      totalPages: (l$totalPages as int?),
      hasNextPage: (l$hasNextPage as bool?),
      page: (l$page as int?),
      limit: (l$limit as int?),
      docs: (l$docs as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_TermineList_veranstaltungsTermine_docs.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int? totalDocs;

  final int? totalPages;

  final bool? hasNextPage;

  final int? page;

  final int? limit;

  final List<Query_TermineList_veranstaltungsTermine_docs?>? docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalDocs = totalDocs;
    _resultData['totalDocs'] = l$totalDocs;
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$page = page;
    _resultData['page'] = l$page;
    final l$limit = limit;
    _resultData['limit'] = l$limit;
    final l$docs = docs;
    _resultData['docs'] = l$docs?.map((e) => e?.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalDocs = totalDocs;
    final l$totalPages = totalPages;
    final l$hasNextPage = hasNextPage;
    final l$page = page;
    final l$limit = limit;
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalDocs,
      l$totalPages,
      l$hasNextPage,
      l$page,
      l$limit,
      l$docs == null ? null : Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList_veranstaltungsTermine ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalDocs = totalDocs;
    final lOther$totalDocs = other.totalDocs;
    if (l$totalDocs != lOther$totalDocs) {
      return false;
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
      return false;
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
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (l$limit != lOther$limit) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs != null && lOther$docs != null) {
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
    } else if (l$docs != lOther$docs) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine
    on Query_TermineList_veranstaltungsTermine {
  CopyWith_Query_TermineList_veranstaltungsTermine<
    Query_TermineList_veranstaltungsTermine
  >
  get copyWith =>
      CopyWith_Query_TermineList_veranstaltungsTermine(this, (i) => i);
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine<TRes> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine(
    Query_TermineList_veranstaltungsTermine instance,
    TRes Function(Query_TermineList_veranstaltungsTermine) then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine;

  factory CopyWith_Query_TermineList_veranstaltungsTermine.stub(TRes res) =
      _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine;

  TRes call({
    int? totalDocs,
    int? totalPages,
    bool? hasNextPage,
    int? page,
    int? limit,
    List<Query_TermineList_veranstaltungsTermine_docs?>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_TermineList_veranstaltungsTermine_docs?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs<
          Query_TermineList_veranstaltungsTermine_docs
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine<TRes>
    implements CopyWith_Query_TermineList_veranstaltungsTermine<TRes> {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine _instance;

  final TRes Function(Query_TermineList_veranstaltungsTermine) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalDocs = _undefined,
    Object? totalPages = _undefined,
    Object? hasNextPage = _undefined,
    Object? page = _undefined,
    Object? limit = _undefined,
    Object? docs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_veranstaltungsTermine(
      totalDocs: totalDocs == _undefined
          ? _instance.totalDocs
          : (totalDocs as int?),
      totalPages: totalPages == _undefined
          ? _instance.totalPages
          : (totalPages as int?),
      hasNextPage: hasNextPage == _undefined
          ? _instance.hasNextPage
          : (hasNextPage as bool?),
      page: page == _undefined ? _instance.page : (page as int?),
      limit: limit == _undefined ? _instance.limit : (limit as int?),
      docs: docs == _undefined
          ? _instance.docs
          : (docs as List<Query_TermineList_veranstaltungsTermine_docs?>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<Query_TermineList_veranstaltungsTermine_docs?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs<
          Query_TermineList_veranstaltungsTermine_docs
        >?
      >?,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_TermineList_veranstaltungsTermine_docs(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine<TRes>
    implements CopyWith_Query_TermineList_veranstaltungsTermine<TRes> {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine(this._res);

  TRes _res;

  call({
    int? totalDocs,
    int? totalPages,
    bool? hasNextPage,
    int? page,
    int? limit,
    List<Query_TermineList_veranstaltungsTermine_docs?>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_TermineList_veranstaltungsTermine_docs {
  Query_TermineList_veranstaltungsTermine_docs({
    this.id,
    this.titel,
    this.subtitle,
    this.teaser,
    this.buchungsUrl,
    this.ticketUrl,
    this.anbieterUrl,
    this.locationName,
    this.address,
    this.coordinates,
    this.start,
    this.end,
    this.dates,
    this.titelbild,
    this.category,
    this.$__typename = 'VeranstaltungsTermin',
  });

  factory Query_TermineList_veranstaltungsTermine_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$subtitle = json['subtitle'];
    final l$teaser = json['teaser'];
    final l$buchungsUrl = json['buchungsUrl'];
    final l$ticketUrl = json['ticketUrl'];
    final l$anbieterUrl = json['anbieterUrl'];
    final l$locationName = json['locationName'];
    final l$address = json['address'];
    final l$coordinates = json['coordinates'];
    final l$start = json['start'];
    final l$end = json['end'];
    final l$dates = json['dates'];
    final l$titelbild = json['titelbild'];
    final l$category = json['category'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine_docs(
      id: (l$id as String?),
      titel: (l$titel as String?),
      subtitle: (l$subtitle as String?),
      teaser: (l$teaser as String?),
      buchungsUrl: (l$buchungsUrl as String?),
      ticketUrl: (l$ticketUrl as String?),
      anbieterUrl: (l$anbieterUrl as String?),
      locationName: (l$locationName as String?),
      address: (l$address as String?),
      coordinates: (l$coordinates as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList(),
      start: (l$start as String?),
      end: (l$end as String?),
      dates: (l$dates as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_TermineList_veranstaltungsTermine_docs_dates.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      titelbild: l$titelbild == null
          ? null
          : Query_TermineList_veranstaltungsTermine_docs_titelbild.fromJson(
              (l$titelbild as Map<String, dynamic>),
            ),
      category: (l$category as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_TermineList_veranstaltungsTermine_docs_category.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? titel;

  final String? subtitle;

  final String? teaser;

  final String? buchungsUrl;

  final String? ticketUrl;

  final String? anbieterUrl;

  final String? locationName;

  final String? address;

  final List<String?>? coordinates;

  final String? start;

  final String? end;

  final List<Query_TermineList_veranstaltungsTermine_docs_dates?>? dates;

  final Query_TermineList_veranstaltungsTermine_docs_titelbild? titelbild;

  final List<Query_TermineList_veranstaltungsTermine_docs_category?>? category;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$subtitle = subtitle;
    _resultData['subtitle'] = l$subtitle;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$buchungsUrl = buchungsUrl;
    _resultData['buchungsUrl'] = l$buchungsUrl;
    final l$ticketUrl = ticketUrl;
    _resultData['ticketUrl'] = l$ticketUrl;
    final l$anbieterUrl = anbieterUrl;
    _resultData['anbieterUrl'] = l$anbieterUrl;
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$coordinates = coordinates;
    _resultData['coordinates'] = l$coordinates?.map((e) => e).toList();
    final l$start = start;
    _resultData['start'] = l$start;
    final l$end = end;
    _resultData['end'] = l$end;
    final l$dates = dates;
    _resultData['dates'] = l$dates?.map((e) => e?.toJson()).toList();
    final l$titelbild = titelbild;
    _resultData['titelbild'] = l$titelbild?.toJson();
    final l$category = category;
    _resultData['category'] = l$category?.map((e) => e?.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$subtitle = subtitle;
    final l$teaser = teaser;
    final l$buchungsUrl = buchungsUrl;
    final l$ticketUrl = ticketUrl;
    final l$anbieterUrl = anbieterUrl;
    final l$locationName = locationName;
    final l$address = address;
    final l$coordinates = coordinates;
    final l$start = start;
    final l$end = end;
    final l$dates = dates;
    final l$titelbild = titelbild;
    final l$category = category;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$titel,
      l$subtitle,
      l$teaser,
      l$buchungsUrl,
      l$ticketUrl,
      l$anbieterUrl,
      l$locationName,
      l$address,
      l$coordinates == null
          ? null
          : Object.hashAll(l$coordinates.map((v) => v)),
      l$start,
      l$end,
      l$dates == null ? null : Object.hashAll(l$dates.map((v) => v)),
      l$titelbild,
      l$category == null ? null : Object.hashAll(l$category.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList_veranstaltungsTermine_docs ||
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
    final l$subtitle = subtitle;
    final lOther$subtitle = other.subtitle;
    if (l$subtitle != lOther$subtitle) {
      return false;
    }
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$buchungsUrl = buchungsUrl;
    final lOther$buchungsUrl = other.buchungsUrl;
    if (l$buchungsUrl != lOther$buchungsUrl) {
      return false;
    }
    final l$ticketUrl = ticketUrl;
    final lOther$ticketUrl = other.ticketUrl;
    if (l$ticketUrl != lOther$ticketUrl) {
      return false;
    }
    final l$anbieterUrl = anbieterUrl;
    final lOther$anbieterUrl = other.anbieterUrl;
    if (l$anbieterUrl != lOther$anbieterUrl) {
      return false;
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$coordinates = coordinates;
    final lOther$coordinates = other.coordinates;
    if (l$coordinates != null && lOther$coordinates != null) {
      if (l$coordinates.length != lOther$coordinates.length) {
        return false;
      }
      for (int i = 0; i < l$coordinates.length; i++) {
        final l$coordinates$entry = l$coordinates[i];
        final lOther$coordinates$entry = lOther$coordinates[i];
        if (l$coordinates$entry != lOther$coordinates$entry) {
          return false;
        }
      }
    } else if (l$coordinates != lOther$coordinates) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
      return false;
    }
    final l$dates = dates;
    final lOther$dates = other.dates;
    if (l$dates != null && lOther$dates != null) {
      if (l$dates.length != lOther$dates.length) {
        return false;
      }
      for (int i = 0; i < l$dates.length; i++) {
        final l$dates$entry = l$dates[i];
        final lOther$dates$entry = lOther$dates[i];
        if (l$dates$entry != lOther$dates$entry) {
          return false;
        }
      }
    } else if (l$dates != lOther$dates) {
      return false;
    }
    final l$titelbild = titelbild;
    final lOther$titelbild = other.titelbild;
    if (l$titelbild != lOther$titelbild) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != null && lOther$category != null) {
      if (l$category.length != lOther$category.length) {
        return false;
      }
      for (int i = 0; i < l$category.length; i++) {
        final l$category$entry = l$category[i];
        final lOther$category$entry = lOther$category[i];
        if (l$category$entry != lOther$category$entry) {
          return false;
        }
      }
    } else if (l$category != lOther$category) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine_docs
    on Query_TermineList_veranstaltungsTermine_docs {
  CopyWith_Query_TermineList_veranstaltungsTermine_docs<
    Query_TermineList_veranstaltungsTermine_docs
  >
  get copyWith =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs(this, (i) => i);
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine_docs<TRes> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs(
    Query_TermineList_veranstaltungsTermine_docs instance,
    TRes Function(Query_TermineList_veranstaltungsTermine_docs) then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs;

  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs.stub(TRes res) =
      _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs;

  TRes call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    String? anbieterUrl,
    String? locationName,
    String? address,
    List<String?>? coordinates,
    String? start,
    String? end,
    List<Query_TermineList_veranstaltungsTermine_docs_dates?>? dates,
    Query_TermineList_veranstaltungsTermine_docs_titelbild? titelbild,
    List<Query_TermineList_veranstaltungsTermine_docs_category?>? category,
    String? $__typename,
  });
  TRes dates(
    Iterable<Query_TermineList_veranstaltungsTermine_docs_dates?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<
          Query_TermineList_veranstaltungsTermine_docs_dates
        >?
      >?,
    )
    _fn,
  );
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes>
  get titelbild;
  TRes category(
    Iterable<Query_TermineList_veranstaltungsTermine_docs_category?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<
          Query_TermineList_veranstaltungsTermine_docs_category
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs<TRes>
    implements CopyWith_Query_TermineList_veranstaltungsTermine_docs<TRes> {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine_docs _instance;

  final TRes Function(Query_TermineList_veranstaltungsTermine_docs) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? subtitle = _undefined,
    Object? teaser = _undefined,
    Object? buchungsUrl = _undefined,
    Object? ticketUrl = _undefined,
    Object? anbieterUrl = _undefined,
    Object? locationName = _undefined,
    Object? address = _undefined,
    Object? coordinates = _undefined,
    Object? start = _undefined,
    Object? end = _undefined,
    Object? dates = _undefined,
    Object? titelbild = _undefined,
    Object? category = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_veranstaltungsTermine_docs(
      id: id == _undefined ? _instance.id : (id as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      subtitle: subtitle == _undefined
          ? _instance.subtitle
          : (subtitle as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      buchungsUrl: buchungsUrl == _undefined
          ? _instance.buchungsUrl
          : (buchungsUrl as String?),
      ticketUrl: ticketUrl == _undefined
          ? _instance.ticketUrl
          : (ticketUrl as String?),
      anbieterUrl: anbieterUrl == _undefined
          ? _instance.anbieterUrl
          : (anbieterUrl as String?),
      locationName: locationName == _undefined
          ? _instance.locationName
          : (locationName as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      coordinates: coordinates == _undefined
          ? _instance.coordinates
          : (coordinates as List<String?>?),
      start: start == _undefined ? _instance.start : (start as String?),
      end: end == _undefined ? _instance.end : (end as String?),
      dates: dates == _undefined
          ? _instance.dates
          : (dates
                as List<Query_TermineList_veranstaltungsTermine_docs_dates?>?),
      titelbild: titelbild == _undefined
          ? _instance.titelbild
          : (titelbild
                as Query_TermineList_veranstaltungsTermine_docs_titelbild?),
      category: category == _undefined
          ? _instance.category
          : (category
                as List<
                  Query_TermineList_veranstaltungsTermine_docs_category?
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes dates(
    Iterable<Query_TermineList_veranstaltungsTermine_docs_dates?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<
          Query_TermineList_veranstaltungsTermine_docs_dates
        >?
      >?,
    )
    _fn,
  ) => call(
    dates: _fn(
      _instance.dates?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );

  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes>
  get titelbild {
    final local$titelbild = _instance.titelbild;
    return local$titelbild == null
        ? CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild.stub(
            _then(_instance),
          )
        : CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild(
            local$titelbild,
            (e) => call(titelbild: e),
          );
  }

  TRes category(
    Iterable<Query_TermineList_veranstaltungsTermine_docs_category?>? Function(
      Iterable<
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<
          Query_TermineList_veranstaltungsTermine_docs_category
        >?
      >?,
    )
    _fn,
  ) => call(
    category: _fn(
      _instance.category?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_TermineList_veranstaltungsTermine_docs_category(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs<TRes>
    implements CopyWith_Query_TermineList_veranstaltungsTermine_docs<TRes> {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs(this._res);

  TRes _res;

  call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    String? anbieterUrl,
    String? locationName,
    String? address,
    List<String?>? coordinates,
    String? start,
    String? end,
    List<Query_TermineList_veranstaltungsTermine_docs_dates?>? dates,
    Query_TermineList_veranstaltungsTermine_docs_titelbild? titelbild,
    List<Query_TermineList_veranstaltungsTermine_docs_category?>? category,
    String? $__typename,
  }) => _res;

  dates(_fn) => _res;

  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes>
  get titelbild =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild.stub(
        _res,
      );

  category(_fn) => _res;
}

class Query_TermineList_veranstaltungsTermine_docs_dates {
  Query_TermineList_veranstaltungsTermine_docs_dates({
    this.start,
    this.end,
    this.$__typename = 'VeranstaltungsTerminDate',
  });

  factory Query_TermineList_veranstaltungsTermine_docs_dates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$start = json['start'];
    final l$end = json['end'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine_docs_dates(
      start: (l$start as String?),
      end: (l$end as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? start;

  final String? end;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$start = start;
    _resultData['start'] = l$start;
    final l$end = end;
    _resultData['end'] = l$end;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$start = start;
    final l$end = end;
    final l$$__typename = $__typename;
    return Object.hashAll([l$start, l$end, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList_veranstaltungsTermine_docs_dates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine_docs_dates
    on Query_TermineList_veranstaltungsTermine_docs_dates {
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<
    Query_TermineList_veranstaltungsTermine_docs_dates
  >
  get copyWith => CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<
  TRes
> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates(
    Query_TermineList_veranstaltungsTermine_docs_dates instance,
    TRes Function(Query_TermineList_veranstaltungsTermine_docs_dates) then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_dates;

  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_dates;

  TRes call({String? start, String? end, String? $__typename});
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_dates<TRes>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<TRes> {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_dates(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine_docs_dates _instance;

  final TRes Function(Query_TermineList_veranstaltungsTermine_docs_dates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? start = _undefined,
    Object? end = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_veranstaltungsTermine_docs_dates(
      start: start == _undefined ? _instance.start : (start as String?),
      end: end == _undefined ? _instance.end : (end as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_dates<TRes>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_dates<TRes> {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_dates(
    this._res,
  );

  TRes _res;

  call({String? start, String? end, String? $__typename}) => _res;
}

class Query_TermineList_veranstaltungsTermine_docs_titelbild {
  Query_TermineList_veranstaltungsTermine_docs_titelbild({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'VeranstaltungsTerminTitelbild',
  });

  factory Query_TermineList_veranstaltungsTermine_docs_titelbild.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine_docs_titelbild(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Query_TermineList_veranstaltungsTermine_docs_titelbild_internal.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Query_TermineList_veranstaltungsTermine_docs_titelbild_internal?
  internal;

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
    if (other is! Query_TermineList_veranstaltungsTermine_docs_titelbild ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine_docs_titelbild
    on Query_TermineList_veranstaltungsTermine_docs_titelbild {
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<
    Query_TermineList_veranstaltungsTermine_docs_titelbild
  >
  get copyWith =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<
  TRes
> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild(
    Query_TermineList_veranstaltungsTermine_docs_titelbild instance,
    TRes Function(Query_TermineList_veranstaltungsTermine_docs_titelbild) then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild;

  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild;

  TRes call({
    bool? $external,
    String? url,
    Query_TermineList_veranstaltungsTermine_docs_titelbild_internal? internal,
    String? $__typename,
  });
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<TRes>
  get internal;
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes> {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine_docs_titelbild _instance;

  final TRes Function(Query_TermineList_veranstaltungsTermine_docs_titelbild)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_veranstaltungsTermine_docs_titelbild(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal
                as Query_TermineList_veranstaltungsTermine_docs_titelbild_internal?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<TRes>
  get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
            _then(_instance),
          )
        : CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild<
  TRes
>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild<TRes> {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild(
    this._res,
  );

  TRes _res;

  call({
    bool? $external,
    String? url,
    Query_TermineList_veranstaltungsTermine_docs_titelbild_internal? internal,
    String? $__typename,
  }) => _res;

  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<TRes>
  get internal =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
        _res,
      );
}

class Query_TermineList_veranstaltungsTermine_docs_titelbild_internal {
  Query_TermineList_veranstaltungsTermine_docs_titelbild_internal({
    this.url,
    this.$__typename = 'VeranstaltungsTerminTitelbildInternal',
  });

  factory Query_TermineList_veranstaltungsTermine_docs_titelbild_internal.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
      url: (l$url as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_TermineList_veranstaltungsTermine_docs_titelbild_internal ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal
    on Query_TermineList_veranstaltungsTermine_docs_titelbild_internal {
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
    Query_TermineList_veranstaltungsTermine_docs_titelbild_internal
  >
  get copyWith =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
    Query_TermineList_veranstaltungsTermine_docs_titelbild_internal instance,
    TRes Function(
      Query_TermineList_veranstaltungsTermine_docs_titelbild_internal,
    )
    then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal;

  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
          TRes
        > {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine_docs_titelbild_internal
  _instance;

  final TRes Function(
    Query_TermineList_veranstaltungsTermine_docs_titelbild_internal,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
          url: url == _undefined ? _instance.url : (url as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal<
          TRes
        > {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_titelbild_internal(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Query_TermineList_veranstaltungsTermine_docs_category {
  Query_TermineList_veranstaltungsTermine_docs_category({
    this.id,
    this.label,
    this.$__typename = 'VeranstaltungsTerminKategorie',
  });

  factory Query_TermineList_veranstaltungsTermine_docs_category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_veranstaltungsTermine_docs_category(
      id: (l$id as String?),
      label: (l$label as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList_veranstaltungsTermine_docs_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

extension UtilityExtension_Query_TermineList_veranstaltungsTermine_docs_category
    on Query_TermineList_veranstaltungsTermine_docs_category {
  CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<
    Query_TermineList_veranstaltungsTermine_docs_category
  >
  get copyWith =>
      CopyWith_Query_TermineList_veranstaltungsTermine_docs_category(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<
  TRes
> {
  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_category(
    Query_TermineList_veranstaltungsTermine_docs_category instance,
    TRes Function(Query_TermineList_veranstaltungsTermine_docs_category) then,
  ) = _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_category;

  factory CopyWith_Query_TermineList_veranstaltungsTermine_docs_category.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_category;

  TRes call({String? id, String? label, String? $__typename});
}

class _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_category<TRes>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<TRes> {
  _CopyWithImpl_Query_TermineList_veranstaltungsTermine_docs_category(
    this._instance,
    this._then,
  );

  final Query_TermineList_veranstaltungsTermine_docs_category _instance;

  final TRes Function(Query_TermineList_veranstaltungsTermine_docs_category)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? label = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_veranstaltungsTermine_docs_category(
      id: id == _undefined ? _instance.id : (id as String?),
      label: label == _undefined ? _instance.label : (label as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_category<
  TRes
>
    implements
        CopyWith_Query_TermineList_veranstaltungsTermine_docs_category<TRes> {
  _CopyWithStubImpl_Query_TermineList_veranstaltungsTermine_docs_category(
    this._res,
  );

  TRes _res;

  call({String? id, String? label, String? $__typename}) => _res;
}

class Query_TermineList_kommune {
  Query_TermineList_kommune({
    required this.abfallkalender,
    this.$__typename = 'Kommune',
  });

  factory Query_TermineList_kommune.fromJson(Map<String, dynamic> json) {
    final l$abfallkalender = json['abfallkalender'];
    final l$$__typename = json['__typename'];
    return Query_TermineList_kommune(
      abfallkalender: (l$abfallkalender as List<dynamic>)
          .map(
            (e) => Fragment_AbfallkalenderTermin.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_AbfallkalenderTermin> abfallkalender;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$abfallkalender = abfallkalender;
    _resultData['abfallkalender'] = l$abfallkalender
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$abfallkalender = abfallkalender;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$abfallkalender.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_TermineList_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$abfallkalender = abfallkalender;
    final lOther$abfallkalender = other.abfallkalender;
    if (l$abfallkalender.length != lOther$abfallkalender.length) {
      return false;
    }
    for (int i = 0; i < l$abfallkalender.length; i++) {
      final l$abfallkalender$entry = l$abfallkalender[i];
      final lOther$abfallkalender$entry = lOther$abfallkalender[i];
      if (l$abfallkalender$entry != lOther$abfallkalender$entry) {
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

extension UtilityExtension_Query_TermineList_kommune
    on Query_TermineList_kommune {
  CopyWith_Query_TermineList_kommune<Query_TermineList_kommune> get copyWith =>
      CopyWith_Query_TermineList_kommune(this, (i) => i);
}

abstract class CopyWith_Query_TermineList_kommune<TRes> {
  factory CopyWith_Query_TermineList_kommune(
    Query_TermineList_kommune instance,
    TRes Function(Query_TermineList_kommune) then,
  ) = _CopyWithImpl_Query_TermineList_kommune;

  factory CopyWith_Query_TermineList_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_TermineList_kommune;

  TRes call({
    List<Fragment_AbfallkalenderTermin>? abfallkalender,
    String? $__typename,
  });
  TRes abfallkalender(
    Iterable<Fragment_AbfallkalenderTermin> Function(
      Iterable<
        CopyWith_Fragment_AbfallkalenderTermin<Fragment_AbfallkalenderTermin>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_TermineList_kommune<TRes>
    implements CopyWith_Query_TermineList_kommune<TRes> {
  _CopyWithImpl_Query_TermineList_kommune(this._instance, this._then);

  final Query_TermineList_kommune _instance;

  final TRes Function(Query_TermineList_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? abfallkalender = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_TermineList_kommune(
      abfallkalender: abfallkalender == _undefined || abfallkalender == null
          ? _instance.abfallkalender
          : (abfallkalender as List<Fragment_AbfallkalenderTermin>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes abfallkalender(
    Iterable<Fragment_AbfallkalenderTermin> Function(
      Iterable<
        CopyWith_Fragment_AbfallkalenderTermin<Fragment_AbfallkalenderTermin>
      >,
    )
    _fn,
  ) => call(
    abfallkalender: _fn(
      _instance.abfallkalender.map(
        (e) => CopyWith_Fragment_AbfallkalenderTermin(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_TermineList_kommune<TRes>
    implements CopyWith_Query_TermineList_kommune<TRes> {
  _CopyWithStubImpl_Query_TermineList_kommune(this._res);

  TRes _res;

  call({
    List<Fragment_AbfallkalenderTermin>? abfallkalender,
    String? $__typename,
  }) => _res;

  abfallkalender(_fn) => _res;
}

class Variables_Query_Abfalltermine {
  factory Variables_Query_Abfalltermine({
    required String kommuneIdBereichA,
    required String standortId,
    required DateTime von,
    required DateTime bis,
    List<String?>? fraktionen,
  }) => Variables_Query_Abfalltermine._({
    r'kommuneIdBereichA': kommuneIdBereichA,
    r'standortId': standortId,
    r'von': von,
    r'bis': bis,
    if (fraktionen != null) r'fraktionen': fraktionen,
  });

  Variables_Query_Abfalltermine._(this._$data);

  factory Variables_Query_Abfalltermine.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichA = data['kommuneIdBereichA'];
    result$data['kommuneIdBereichA'] = (l$kommuneIdBereichA as String);
    final l$standortId = data['standortId'];
    result$data['standortId'] = (l$standortId as String);
    final l$von = data['von'];
    result$data['von'] = DateTime.parse((l$von as String));
    final l$bis = data['bis'];
    result$data['bis'] = DateTime.parse((l$bis as String));
    if (data.containsKey('fraktionen')) {
      final l$fraktionen = data['fraktionen'];
      result$data['fraktionen'] = (l$fraktionen as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList();
    }
    return Variables_Query_Abfalltermine._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneIdBereichA => (_$data['kommuneIdBereichA'] as String);

  String get standortId => (_$data['standortId'] as String);

  DateTime get von => (_$data['von'] as DateTime);

  DateTime get bis => (_$data['bis'] as DateTime);

  List<String?>? get fraktionen => (_$data['fraktionen'] as List<String?>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneIdBereichA = kommuneIdBereichA;
    result$data['kommuneIdBereichA'] = l$kommuneIdBereichA;
    final l$standortId = standortId;
    result$data['standortId'] = l$standortId;
    final l$von = von;
    result$data['von'] = l$von.toIso8601String();
    final l$bis = bis;
    result$data['bis'] = l$bis.toIso8601String();
    if (_$data.containsKey('fraktionen')) {
      final l$fraktionen = fraktionen;
      result$data['fraktionen'] = l$fraktionen?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith_Variables_Query_Abfalltermine<Variables_Query_Abfalltermine>
  get copyWith => CopyWith_Variables_Query_Abfalltermine(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Abfalltermine ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneIdBereichA = kommuneIdBereichA;
    final lOther$kommuneIdBereichA = other.kommuneIdBereichA;
    if (l$kommuneIdBereichA != lOther$kommuneIdBereichA) {
      return false;
    }
    final l$standortId = standortId;
    final lOther$standortId = other.standortId;
    if (l$standortId != lOther$standortId) {
      return false;
    }
    final l$von = von;
    final lOther$von = other.von;
    if (l$von != lOther$von) {
      return false;
    }
    final l$bis = bis;
    final lOther$bis = other.bis;
    if (l$bis != lOther$bis) {
      return false;
    }
    final l$fraktionen = fraktionen;
    final lOther$fraktionen = other.fraktionen;
    if (_$data.containsKey('fraktionen') !=
        other._$data.containsKey('fraktionen')) {
      return false;
    }
    if (l$fraktionen != null && lOther$fraktionen != null) {
      if (l$fraktionen.length != lOther$fraktionen.length) {
        return false;
      }
      for (int i = 0; i < l$fraktionen.length; i++) {
        final l$fraktionen$entry = l$fraktionen[i];
        final lOther$fraktionen$entry = lOther$fraktionen[i];
        if (l$fraktionen$entry != lOther$fraktionen$entry) {
          return false;
        }
      }
    } else if (l$fraktionen != lOther$fraktionen) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneIdBereichA = kommuneIdBereichA;
    final l$standortId = standortId;
    final l$von = von;
    final l$bis = bis;
    final l$fraktionen = fraktionen;
    return Object.hashAll([
      l$kommuneIdBereichA,
      l$standortId,
      l$von,
      l$bis,
      _$data.containsKey('fraktionen')
          ? l$fraktionen == null
                ? null
                : Object.hashAll(l$fraktionen.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_Abfalltermine<TRes> {
  factory CopyWith_Variables_Query_Abfalltermine(
    Variables_Query_Abfalltermine instance,
    TRes Function(Variables_Query_Abfalltermine) then,
  ) = _CopyWithImpl_Variables_Query_Abfalltermine;

  factory CopyWith_Variables_Query_Abfalltermine.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Abfalltermine;

  TRes call({
    String? kommuneIdBereichA,
    String? standortId,
    DateTime? von,
    DateTime? bis,
    List<String?>? fraktionen,
  });
}

class _CopyWithImpl_Variables_Query_Abfalltermine<TRes>
    implements CopyWith_Variables_Query_Abfalltermine<TRes> {
  _CopyWithImpl_Variables_Query_Abfalltermine(this._instance, this._then);

  final Variables_Query_Abfalltermine _instance;

  final TRes Function(Variables_Query_Abfalltermine) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneIdBereichA = _undefined,
    Object? standortId = _undefined,
    Object? von = _undefined,
    Object? bis = _undefined,
    Object? fraktionen = _undefined,
  }) => _then(
    Variables_Query_Abfalltermine._({
      ..._instance._$data,
      if (kommuneIdBereichA != _undefined && kommuneIdBereichA != null)
        'kommuneIdBereichA': (kommuneIdBereichA as String),
      if (standortId != _undefined && standortId != null)
        'standortId': (standortId as String),
      if (von != _undefined && von != null) 'von': (von as DateTime),
      if (bis != _undefined && bis != null) 'bis': (bis as DateTime),
      if (fraktionen != _undefined)
        'fraktionen': (fraktionen as List<String?>?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Abfalltermine<TRes>
    implements CopyWith_Variables_Query_Abfalltermine<TRes> {
  _CopyWithStubImpl_Variables_Query_Abfalltermine(this._res);

  TRes _res;

  call({
    String? kommuneIdBereichA,
    String? standortId,
    DateTime? von,
    DateTime? bis,
    List<String?>? fraktionen,
  }) => _res;
}

class Query_Abfalltermine {
  Query_Abfalltermine({required this.kommune, this.$__typename = 'Query'});

  factory Query_Abfalltermine.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Abfalltermine(
      kommune: Query_Abfalltermine_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_Abfalltermine_kommune kommune;

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
    if (other is! Query_Abfalltermine || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Abfalltermine on Query_Abfalltermine {
  CopyWith_Query_Abfalltermine<Query_Abfalltermine> get copyWith =>
      CopyWith_Query_Abfalltermine(this, (i) => i);
}

abstract class CopyWith_Query_Abfalltermine<TRes> {
  factory CopyWith_Query_Abfalltermine(
    Query_Abfalltermine instance,
    TRes Function(Query_Abfalltermine) then,
  ) = _CopyWithImpl_Query_Abfalltermine;

  factory CopyWith_Query_Abfalltermine.stub(TRes res) =
      _CopyWithStubImpl_Query_Abfalltermine;

  TRes call({Query_Abfalltermine_kommune? kommune, String? $__typename});
  CopyWith_Query_Abfalltermine_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Abfalltermine<TRes>
    implements CopyWith_Query_Abfalltermine<TRes> {
  _CopyWithImpl_Query_Abfalltermine(this._instance, this._then);

  final Query_Abfalltermine _instance;

  final TRes Function(Query_Abfalltermine) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Abfalltermine(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_Abfalltermine_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_Abfalltermine_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_Abfalltermine_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_Abfalltermine<TRes>
    implements CopyWith_Query_Abfalltermine<TRes> {
  _CopyWithStubImpl_Query_Abfalltermine(this._res);

  TRes _res;

  call({Query_Abfalltermine_kommune? kommune, String? $__typename}) => _res;

  CopyWith_Query_Abfalltermine_kommune<TRes> get kommune =>
      CopyWith_Query_Abfalltermine_kommune.stub(_res);
}

const documentNodeQueryAbfalltermine = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Abfalltermine'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneIdBereichA')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'standortId')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'von')),
          type: NamedTypeNode(
            name: NameNode(value: 'DateTime'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bis')),
          type: NamedTypeNode(
            name: NameNode(value: 'DateTime'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'fraktionen')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: false,
            ),
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
                value: VariableNode(name: NameNode(value: 'kommuneIdBereichA')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'abfallkalender'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'standortId'),
                      value: VariableNode(name: NameNode(value: 'standortId')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'von'),
                      value: VariableNode(name: NameNode(value: 'von')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'bis'),
                      value: VariableNode(name: NameNode(value: 'bis')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'where'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'fraktionId'),
                            value: ObjectValueNode(
                              fields: [
                                ObjectFieldNode(
                                  name: NameNode(value: 'in'),
                                  value: VariableNode(
                                    name: NameNode(value: 'fraktionen'),
                                  ),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'AbfallkalenderTermin'),
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
    fragmentDefinitionAbfallkalenderTermin,
  ],
);
Query_Abfalltermine _parserFn_Query_Abfalltermine(Map<String, dynamic> data) =>
    Query_Abfalltermine.fromJson(data);
typedef OnQueryComplete_Query_Abfalltermine =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Abfalltermine?);

class Options_Query_Abfalltermine
    extends graphql.QueryOptions<Query_Abfalltermine> {
  Options_Query_Abfalltermine({
    String? operationName,
    required Variables_Query_Abfalltermine variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Abfalltermine? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Abfalltermine? onComplete,
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
                 data == null ? null : _parserFn_Query_Abfalltermine(data),
               ),
         onError: onError,
         document: documentNodeQueryAbfalltermine,
         parserFn: _parserFn_Query_Abfalltermine,
       );

  final OnQueryComplete_Query_Abfalltermine? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Abfalltermine
    extends graphql.WatchQueryOptions<Query_Abfalltermine> {
  WatchOptions_Query_Abfalltermine({
    String? operationName,
    required Variables_Query_Abfalltermine variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Abfalltermine? typedOptimisticResult,
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
         document: documentNodeQueryAbfalltermine,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Abfalltermine,
       );
}

class FetchMoreOptions_Query_Abfalltermine extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Abfalltermine({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Abfalltermine variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAbfalltermine,
       );
}

extension ClientExtension_Query_Abfalltermine on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Abfalltermine>> query_Abfalltermine(
    Options_Query_Abfalltermine options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Abfalltermine> watchQuery_Abfalltermine(
    WatchOptions_Query_Abfalltermine options,
  ) => this.watchQuery(options);

  void writeQuery_Abfalltermine({
    required Query_Abfalltermine data,
    required Variables_Query_Abfalltermine variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryAbfalltermine),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Abfalltermine? readQuery_Abfalltermine({
    required Variables_Query_Abfalltermine variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryAbfalltermine),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Abfalltermine.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Abfalltermine> useQuery_Abfalltermine(
  Options_Query_Abfalltermine options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Abfalltermine> useWatchQuery_Abfalltermine(
  WatchOptions_Query_Abfalltermine options,
) => graphql_flutter.useWatchQuery(options);

class Query_Abfalltermine_Widget
    extends graphql_flutter.Query<Query_Abfalltermine> {
  Query_Abfalltermine_Widget({
    widgets.Key? key,
    required Options_Query_Abfalltermine options,
    required graphql_flutter.QueryBuilder<Query_Abfalltermine> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_Abfalltermine_kommune {
  Query_Abfalltermine_kommune({
    required this.abfallkalender,
    this.$__typename = 'Kommune',
  });

  factory Query_Abfalltermine_kommune.fromJson(Map<String, dynamic> json) {
    final l$abfallkalender = json['abfallkalender'];
    final l$$__typename = json['__typename'];
    return Query_Abfalltermine_kommune(
      abfallkalender: (l$abfallkalender as List<dynamic>)
          .map(
            (e) => Fragment_AbfallkalenderTermin.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_AbfallkalenderTermin> abfallkalender;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$abfallkalender = abfallkalender;
    _resultData['abfallkalender'] = l$abfallkalender
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$abfallkalender = abfallkalender;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$abfallkalender.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Abfalltermine_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$abfallkalender = abfallkalender;
    final lOther$abfallkalender = other.abfallkalender;
    if (l$abfallkalender.length != lOther$abfallkalender.length) {
      return false;
    }
    for (int i = 0; i < l$abfallkalender.length; i++) {
      final l$abfallkalender$entry = l$abfallkalender[i];
      final lOther$abfallkalender$entry = lOther$abfallkalender[i];
      if (l$abfallkalender$entry != lOther$abfallkalender$entry) {
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

extension UtilityExtension_Query_Abfalltermine_kommune
    on Query_Abfalltermine_kommune {
  CopyWith_Query_Abfalltermine_kommune<Query_Abfalltermine_kommune>
  get copyWith => CopyWith_Query_Abfalltermine_kommune(this, (i) => i);
}

abstract class CopyWith_Query_Abfalltermine_kommune<TRes> {
  factory CopyWith_Query_Abfalltermine_kommune(
    Query_Abfalltermine_kommune instance,
    TRes Function(Query_Abfalltermine_kommune) then,
  ) = _CopyWithImpl_Query_Abfalltermine_kommune;

  factory CopyWith_Query_Abfalltermine_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Abfalltermine_kommune;

  TRes call({
    List<Fragment_AbfallkalenderTermin>? abfallkalender,
    String? $__typename,
  });
  TRes abfallkalender(
    Iterable<Fragment_AbfallkalenderTermin> Function(
      Iterable<
        CopyWith_Fragment_AbfallkalenderTermin<Fragment_AbfallkalenderTermin>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_Abfalltermine_kommune<TRes>
    implements CopyWith_Query_Abfalltermine_kommune<TRes> {
  _CopyWithImpl_Query_Abfalltermine_kommune(this._instance, this._then);

  final Query_Abfalltermine_kommune _instance;

  final TRes Function(Query_Abfalltermine_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? abfallkalender = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Abfalltermine_kommune(
      abfallkalender: abfallkalender == _undefined || abfallkalender == null
          ? _instance.abfallkalender
          : (abfallkalender as List<Fragment_AbfallkalenderTermin>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes abfallkalender(
    Iterable<Fragment_AbfallkalenderTermin> Function(
      Iterable<
        CopyWith_Fragment_AbfallkalenderTermin<Fragment_AbfallkalenderTermin>
      >,
    )
    _fn,
  ) => call(
    abfallkalender: _fn(
      _instance.abfallkalender.map(
        (e) => CopyWith_Fragment_AbfallkalenderTermin(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_Abfalltermine_kommune<TRes>
    implements CopyWith_Query_Abfalltermine_kommune<TRes> {
  _CopyWithStubImpl_Query_Abfalltermine_kommune(this._res);

  TRes _res;

  call({
    List<Fragment_AbfallkalenderTermin>? abfallkalender,
    String? $__typename,
  }) => _res;

  abfallkalender(_fn) => _res;
}

class Variables_Query_AbfallkalenderOrte {
  factory Variables_Query_AbfallkalenderOrte({required String kommuneId}) =>
      Variables_Query_AbfallkalenderOrte._({r'kommuneId': kommuneId});

  Variables_Query_AbfallkalenderOrte._(this._$data);

  factory Variables_Query_AbfallkalenderOrte.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_AbfallkalenderOrte._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_AbfallkalenderOrte<
    Variables_Query_AbfallkalenderOrte
  >
  get copyWith => CopyWith_Variables_Query_AbfallkalenderOrte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AbfallkalenderOrte ||
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

abstract class CopyWith_Variables_Query_AbfallkalenderOrte<TRes> {
  factory CopyWith_Variables_Query_AbfallkalenderOrte(
    Variables_Query_AbfallkalenderOrte instance,
    TRes Function(Variables_Query_AbfallkalenderOrte) then,
  ) = _CopyWithImpl_Variables_Query_AbfallkalenderOrte;

  factory CopyWith_Variables_Query_AbfallkalenderOrte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AbfallkalenderOrte;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_AbfallkalenderOrte<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderOrte<TRes> {
  _CopyWithImpl_Variables_Query_AbfallkalenderOrte(this._instance, this._then);

  final Variables_Query_AbfallkalenderOrte _instance;

  final TRes Function(Variables_Query_AbfallkalenderOrte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_AbfallkalenderOrte._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_AbfallkalenderOrte<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderOrte<TRes> {
  _CopyWithStubImpl_Variables_Query_AbfallkalenderOrte(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_AbfallkalenderOrte {
  Query_AbfallkalenderOrte({required this.kommune, this.$__typename = 'Query'});

  factory Query_AbfallkalenderOrte.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderOrte(
      kommune: Query_AbfallkalenderOrte_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AbfallkalenderOrte_kommune kommune;

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
    if (other is! Query_AbfallkalenderOrte ||
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

extension UtilityExtension_Query_AbfallkalenderOrte
    on Query_AbfallkalenderOrte {
  CopyWith_Query_AbfallkalenderOrte<Query_AbfallkalenderOrte> get copyWith =>
      CopyWith_Query_AbfallkalenderOrte(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderOrte<TRes> {
  factory CopyWith_Query_AbfallkalenderOrte(
    Query_AbfallkalenderOrte instance,
    TRes Function(Query_AbfallkalenderOrte) then,
  ) = _CopyWithImpl_Query_AbfallkalenderOrte;

  factory CopyWith_Query_AbfallkalenderOrte.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderOrte;

  TRes call({Query_AbfallkalenderOrte_kommune? kommune, String? $__typename});
  CopyWith_Query_AbfallkalenderOrte_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_AbfallkalenderOrte<TRes>
    implements CopyWith_Query_AbfallkalenderOrte<TRes> {
  _CopyWithImpl_Query_AbfallkalenderOrte(this._instance, this._then);

  final Query_AbfallkalenderOrte _instance;

  final TRes Function(Query_AbfallkalenderOrte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_AbfallkalenderOrte(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_AbfallkalenderOrte_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_AbfallkalenderOrte_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_AbfallkalenderOrte_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_AbfallkalenderOrte<TRes>
    implements CopyWith_Query_AbfallkalenderOrte<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderOrte(this._res);

  TRes _res;

  call({Query_AbfallkalenderOrte_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_AbfallkalenderOrte_kommune<TRes> get kommune =>
      CopyWith_Query_AbfallkalenderOrte_kommune.stub(_res);
}

const documentNodeQueryAbfallkalenderOrte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AbfallkalenderOrte'),
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
                  name: NameNode(value: 'orte'),
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
Query_AbfallkalenderOrte _parserFn_Query_AbfallkalenderOrte(
  Map<String, dynamic> data,
) => Query_AbfallkalenderOrte.fromJson(data);
typedef OnQueryComplete_Query_AbfallkalenderOrte =
    FutureOr<void> Function(Map<String, dynamic>?, Query_AbfallkalenderOrte?);

class Options_Query_AbfallkalenderOrte
    extends graphql.QueryOptions<Query_AbfallkalenderOrte> {
  Options_Query_AbfallkalenderOrte({
    String? operationName,
    required Variables_Query_AbfallkalenderOrte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderOrte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AbfallkalenderOrte? onComplete,
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
                 data == null ? null : _parserFn_Query_AbfallkalenderOrte(data),
               ),
         onError: onError,
         document: documentNodeQueryAbfallkalenderOrte,
         parserFn: _parserFn_Query_AbfallkalenderOrte,
       );

  final OnQueryComplete_Query_AbfallkalenderOrte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AbfallkalenderOrte
    extends graphql.WatchQueryOptions<Query_AbfallkalenderOrte> {
  WatchOptions_Query_AbfallkalenderOrte({
    String? operationName,
    required Variables_Query_AbfallkalenderOrte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderOrte? typedOptimisticResult,
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
         document: documentNodeQueryAbfallkalenderOrte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AbfallkalenderOrte,
       );
}

class FetchMoreOptions_Query_AbfallkalenderOrte
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AbfallkalenderOrte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AbfallkalenderOrte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAbfallkalenderOrte,
       );
}

extension ClientExtension_Query_AbfallkalenderOrte on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AbfallkalenderOrte>>
  query_AbfallkalenderOrte(Options_Query_AbfallkalenderOrte options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query_AbfallkalenderOrte>
  watchQuery_AbfallkalenderOrte(
    WatchOptions_Query_AbfallkalenderOrte options,
  ) => this.watchQuery(options);

  void writeQuery_AbfallkalenderOrte({
    required Query_AbfallkalenderOrte data,
    required Variables_Query_AbfallkalenderOrte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAbfallkalenderOrte,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AbfallkalenderOrte? readQuery_AbfallkalenderOrte({
    required Variables_Query_AbfallkalenderOrte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAbfallkalenderOrte,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_AbfallkalenderOrte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AbfallkalenderOrte>
useQuery_AbfallkalenderOrte(Options_Query_AbfallkalenderOrte options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AbfallkalenderOrte>
useWatchQuery_AbfallkalenderOrte(
  WatchOptions_Query_AbfallkalenderOrte options,
) => graphql_flutter.useWatchQuery(options);

class Query_AbfallkalenderOrte_Widget
    extends graphql_flutter.Query<Query_AbfallkalenderOrte> {
  Query_AbfallkalenderOrte_Widget({
    widgets.Key? key,
    required Options_Query_AbfallkalenderOrte options,
    required graphql_flutter.QueryBuilder<Query_AbfallkalenderOrte> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AbfallkalenderOrte_kommune {
  Query_AbfallkalenderOrte_kommune({
    required this.orte,
    this.$__typename = 'Kommune',
  });

  factory Query_AbfallkalenderOrte_kommune.fromJson(Map<String, dynamic> json) {
    final l$orte = json['orte'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderOrte_kommune(
      orte: (l$orte as List<dynamic>)
          .map(
            (e) => Query_AbfallkalenderOrte_kommune_orte.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_AbfallkalenderOrte_kommune_orte> orte;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orte = orte;
    _resultData['orte'] = l$orte.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orte = orte;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$orte.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderOrte_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orte = orte;
    final lOther$orte = other.orte;
    if (l$orte.length != lOther$orte.length) {
      return false;
    }
    for (int i = 0; i < l$orte.length; i++) {
      final l$orte$entry = l$orte[i];
      final lOther$orte$entry = lOther$orte[i];
      if (l$orte$entry != lOther$orte$entry) {
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

extension UtilityExtension_Query_AbfallkalenderOrte_kommune
    on Query_AbfallkalenderOrte_kommune {
  CopyWith_Query_AbfallkalenderOrte_kommune<Query_AbfallkalenderOrte_kommune>
  get copyWith => CopyWith_Query_AbfallkalenderOrte_kommune(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderOrte_kommune<TRes> {
  factory CopyWith_Query_AbfallkalenderOrte_kommune(
    Query_AbfallkalenderOrte_kommune instance,
    TRes Function(Query_AbfallkalenderOrte_kommune) then,
  ) = _CopyWithImpl_Query_AbfallkalenderOrte_kommune;

  factory CopyWith_Query_AbfallkalenderOrte_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune;

  TRes call({
    List<Query_AbfallkalenderOrte_kommune_orte>? orte,
    String? $__typename,
  });
  TRes orte(
    Iterable<Query_AbfallkalenderOrte_kommune_orte> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderOrte_kommune_orte<
          Query_AbfallkalenderOrte_kommune_orte
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_AbfallkalenderOrte_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderOrte_kommune<TRes> {
  _CopyWithImpl_Query_AbfallkalenderOrte_kommune(this._instance, this._then);

  final Query_AbfallkalenderOrte_kommune _instance;

  final TRes Function(Query_AbfallkalenderOrte_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? orte = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_AbfallkalenderOrte_kommune(
          orte: orte == _undefined || orte == null
              ? _instance.orte
              : (orte as List<Query_AbfallkalenderOrte_kommune_orte>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes orte(
    Iterable<Query_AbfallkalenderOrte_kommune_orte> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderOrte_kommune_orte<
          Query_AbfallkalenderOrte_kommune_orte
        >
      >,
    )
    _fn,
  ) => call(
    orte: _fn(
      _instance.orte.map(
        (e) => CopyWith_Query_AbfallkalenderOrte_kommune_orte(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderOrte_kommune<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune(this._res);

  TRes _res;

  call({
    List<Query_AbfallkalenderOrte_kommune_orte>? orte,
    String? $__typename,
  }) => _res;

  orte(_fn) => _res;
}

class Query_AbfallkalenderOrte_kommune_orte {
  Query_AbfallkalenderOrte_kommune_orte({
    required this.id,
    required this.name,
    this.$__typename = 'Ort',
  });

  factory Query_AbfallkalenderOrte_kommune_orte.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderOrte_kommune_orte(
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
    if (other is! Query_AbfallkalenderOrte_kommune_orte ||
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

extension UtilityExtension_Query_AbfallkalenderOrte_kommune_orte
    on Query_AbfallkalenderOrte_kommune_orte {
  CopyWith_Query_AbfallkalenderOrte_kommune_orte<
    Query_AbfallkalenderOrte_kommune_orte
  >
  get copyWith =>
      CopyWith_Query_AbfallkalenderOrte_kommune_orte(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderOrte_kommune_orte<TRes> {
  factory CopyWith_Query_AbfallkalenderOrte_kommune_orte(
    Query_AbfallkalenderOrte_kommune_orte instance,
    TRes Function(Query_AbfallkalenderOrte_kommune_orte) then,
  ) = _CopyWithImpl_Query_AbfallkalenderOrte_kommune_orte;

  factory CopyWith_Query_AbfallkalenderOrte_kommune_orte.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune_orte;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_AbfallkalenderOrte_kommune_orte<TRes>
    implements CopyWith_Query_AbfallkalenderOrte_kommune_orte<TRes> {
  _CopyWithImpl_Query_AbfallkalenderOrte_kommune_orte(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderOrte_kommune_orte _instance;

  final TRes Function(Query_AbfallkalenderOrte_kommune_orte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderOrte_kommune_orte(
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

class _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune_orte<TRes>
    implements CopyWith_Query_AbfallkalenderOrte_kommune_orte<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderOrte_kommune_orte(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Variables_Query_AbfallkalenderStrassen {
  factory Variables_Query_AbfallkalenderStrassen({
    required String kommuneId,
    required String ortId,
  }) => Variables_Query_AbfallkalenderStrassen._({
    r'kommuneId': kommuneId,
    r'ortId': ortId,
  });

  Variables_Query_AbfallkalenderStrassen._(this._$data);

  factory Variables_Query_AbfallkalenderStrassen.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$ortId = data['ortId'];
    result$data['ortId'] = (l$ortId as String);
    return Variables_Query_AbfallkalenderStrassen._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get ortId => (_$data['ortId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$ortId = ortId;
    result$data['ortId'] = l$ortId;
    return result$data;
  }

  CopyWith_Variables_Query_AbfallkalenderStrassen<
    Variables_Query_AbfallkalenderStrassen
  >
  get copyWith =>
      CopyWith_Variables_Query_AbfallkalenderStrassen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AbfallkalenderStrassen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$ortId = ortId;
    final lOther$ortId = other.ortId;
    if (l$ortId != lOther$ortId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$ortId = ortId;
    return Object.hashAll([l$kommuneId, l$ortId]);
  }
}

abstract class CopyWith_Variables_Query_AbfallkalenderStrassen<TRes> {
  factory CopyWith_Variables_Query_AbfallkalenderStrassen(
    Variables_Query_AbfallkalenderStrassen instance,
    TRes Function(Variables_Query_AbfallkalenderStrassen) then,
  ) = _CopyWithImpl_Variables_Query_AbfallkalenderStrassen;

  factory CopyWith_Variables_Query_AbfallkalenderStrassen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AbfallkalenderStrassen;

  TRes call({String? kommuneId, String? ortId});
}

class _CopyWithImpl_Variables_Query_AbfallkalenderStrassen<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderStrassen<TRes> {
  _CopyWithImpl_Variables_Query_AbfallkalenderStrassen(
    this._instance,
    this._then,
  );

  final Variables_Query_AbfallkalenderStrassen _instance;

  final TRes Function(Variables_Query_AbfallkalenderStrassen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined, Object? ortId = _undefined}) =>
      _then(
        Variables_Query_AbfallkalenderStrassen._({
          ..._instance._$data,
          if (kommuneId != _undefined && kommuneId != null)
            'kommuneId': (kommuneId as String),
          if (ortId != _undefined && ortId != null) 'ortId': (ortId as String),
        }),
      );
}

class _CopyWithStubImpl_Variables_Query_AbfallkalenderStrassen<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderStrassen<TRes> {
  _CopyWithStubImpl_Variables_Query_AbfallkalenderStrassen(this._res);

  TRes _res;

  call({String? kommuneId, String? ortId}) => _res;
}

class Query_AbfallkalenderStrassen {
  Query_AbfallkalenderStrassen({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_AbfallkalenderStrassen.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStrassen(
      kommune: Query_AbfallkalenderStrassen_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AbfallkalenderStrassen_kommune kommune;

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
    if (other is! Query_AbfallkalenderStrassen ||
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

extension UtilityExtension_Query_AbfallkalenderStrassen
    on Query_AbfallkalenderStrassen {
  CopyWith_Query_AbfallkalenderStrassen<Query_AbfallkalenderStrassen>
  get copyWith => CopyWith_Query_AbfallkalenderStrassen(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStrassen<TRes> {
  factory CopyWith_Query_AbfallkalenderStrassen(
    Query_AbfallkalenderStrassen instance,
    TRes Function(Query_AbfallkalenderStrassen) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStrassen;

  factory CopyWith_Query_AbfallkalenderStrassen.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderStrassen;

  TRes call({
    Query_AbfallkalenderStrassen_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_AbfallkalenderStrassen<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStrassen(this._instance, this._then);

  final Query_AbfallkalenderStrassen _instance;

  final TRes Function(Query_AbfallkalenderStrassen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_AbfallkalenderStrassen(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_AbfallkalenderStrassen_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_AbfallkalenderStrassen_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_AbfallkalenderStrassen<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStrassen(this._res);

  TRes _res;

  call({Query_AbfallkalenderStrassen_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> get kommune =>
      CopyWith_Query_AbfallkalenderStrassen_kommune.stub(_res);
}

const documentNodeQueryAbfallkalenderStrassen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AbfallkalenderStrassen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'ortId')),
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
                  name: NameNode(value: 'strassen'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'ortId'),
                      value: VariableNode(name: NameNode(value: 'ortId')),
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
Query_AbfallkalenderStrassen _parserFn_Query_AbfallkalenderStrassen(
  Map<String, dynamic> data,
) => Query_AbfallkalenderStrassen.fromJson(data);
typedef OnQueryComplete_Query_AbfallkalenderStrassen =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_AbfallkalenderStrassen?,
    );

class Options_Query_AbfallkalenderStrassen
    extends graphql.QueryOptions<Query_AbfallkalenderStrassen> {
  Options_Query_AbfallkalenderStrassen({
    String? operationName,
    required Variables_Query_AbfallkalenderStrassen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderStrassen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AbfallkalenderStrassen? onComplete,
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
                     : _parserFn_Query_AbfallkalenderStrassen(data),
               ),
         onError: onError,
         document: documentNodeQueryAbfallkalenderStrassen,
         parserFn: _parserFn_Query_AbfallkalenderStrassen,
       );

  final OnQueryComplete_Query_AbfallkalenderStrassen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AbfallkalenderStrassen
    extends graphql.WatchQueryOptions<Query_AbfallkalenderStrassen> {
  WatchOptions_Query_AbfallkalenderStrassen({
    String? operationName,
    required Variables_Query_AbfallkalenderStrassen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderStrassen? typedOptimisticResult,
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
         document: documentNodeQueryAbfallkalenderStrassen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AbfallkalenderStrassen,
       );
}

class FetchMoreOptions_Query_AbfallkalenderStrassen
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AbfallkalenderStrassen({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AbfallkalenderStrassen variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAbfallkalenderStrassen,
       );
}

extension ClientExtension_Query_AbfallkalenderStrassen
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AbfallkalenderStrassen>>
  query_AbfallkalenderStrassen(
    Options_Query_AbfallkalenderStrassen options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_AbfallkalenderStrassen>
  watchQuery_AbfallkalenderStrassen(
    WatchOptions_Query_AbfallkalenderStrassen options,
  ) => this.watchQuery(options);

  void writeQuery_AbfallkalenderStrassen({
    required Query_AbfallkalenderStrassen data,
    required Variables_Query_AbfallkalenderStrassen variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAbfallkalenderStrassen,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AbfallkalenderStrassen? readQuery_AbfallkalenderStrassen({
    required Variables_Query_AbfallkalenderStrassen variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAbfallkalenderStrassen,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_AbfallkalenderStrassen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AbfallkalenderStrassen>
useQuery_AbfallkalenderStrassen(Options_Query_AbfallkalenderStrassen options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AbfallkalenderStrassen>
useWatchQuery_AbfallkalenderStrassen(
  WatchOptions_Query_AbfallkalenderStrassen options,
) => graphql_flutter.useWatchQuery(options);

class Query_AbfallkalenderStrassen_Widget
    extends graphql_flutter.Query<Query_AbfallkalenderStrassen> {
  Query_AbfallkalenderStrassen_Widget({
    widgets.Key? key,
    required Options_Query_AbfallkalenderStrassen options,
    required graphql_flutter.QueryBuilder<Query_AbfallkalenderStrassen> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AbfallkalenderStrassen_kommune {
  Query_AbfallkalenderStrassen_kommune({
    required this.strassen,
    this.$__typename = 'Kommune',
  });

  factory Query_AbfallkalenderStrassen_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$strassen = json['strassen'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStrassen_kommune(
      strassen: (l$strassen as List<dynamic>)
          .map(
            (e) => Query_AbfallkalenderStrassen_kommune_strassen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_AbfallkalenderStrassen_kommune_strassen> strassen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$strassen = strassen;
    _resultData['strassen'] = l$strassen.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$strassen = strassen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$strassen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderStrassen_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$strassen = strassen;
    final lOther$strassen = other.strassen;
    if (l$strassen.length != lOther$strassen.length) {
      return false;
    }
    for (int i = 0; i < l$strassen.length; i++) {
      final l$strassen$entry = l$strassen[i];
      final lOther$strassen$entry = lOther$strassen[i];
      if (l$strassen$entry != lOther$strassen$entry) {
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

extension UtilityExtension_Query_AbfallkalenderStrassen_kommune
    on Query_AbfallkalenderStrassen_kommune {
  CopyWith_Query_AbfallkalenderStrassen_kommune<
    Query_AbfallkalenderStrassen_kommune
  >
  get copyWith => CopyWith_Query_AbfallkalenderStrassen_kommune(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> {
  factory CopyWith_Query_AbfallkalenderStrassen_kommune(
    Query_AbfallkalenderStrassen_kommune instance,
    TRes Function(Query_AbfallkalenderStrassen_kommune) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStrassen_kommune;

  factory CopyWith_Query_AbfallkalenderStrassen_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune;

  TRes call({
    List<Query_AbfallkalenderStrassen_kommune_strassen>? strassen,
    String? $__typename,
  });
  TRes strassen(
    Iterable<Query_AbfallkalenderStrassen_kommune_strassen> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<
          Query_AbfallkalenderStrassen_kommune_strassen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_AbfallkalenderStrassen_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStrassen_kommune(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderStrassen_kommune _instance;

  final TRes Function(Query_AbfallkalenderStrassen_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? strassen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderStrassen_kommune(
      strassen: strassen == _undefined || strassen == null
          ? _instance.strassen
          : (strassen as List<Query_AbfallkalenderStrassen_kommune_strassen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes strassen(
    Iterable<Query_AbfallkalenderStrassen_kommune_strassen> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<
          Query_AbfallkalenderStrassen_kommune_strassen
        >
      >,
    )
    _fn,
  ) => call(
    strassen: _fn(
      _instance.strassen.map(
        (e) =>
            CopyWith_Query_AbfallkalenderStrassen_kommune_strassen(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen_kommune<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune(this._res);

  TRes _res;

  call({
    List<Query_AbfallkalenderStrassen_kommune_strassen>? strassen,
    String? $__typename,
  }) => _res;

  strassen(_fn) => _res;
}

class Query_AbfallkalenderStrassen_kommune_strassen {
  Query_AbfallkalenderStrassen_kommune_strassen({
    required this.id,
    required this.name,
    this.$__typename = 'Strasse',
  });

  factory Query_AbfallkalenderStrassen_kommune_strassen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStrassen_kommune_strassen(
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
    if (other is! Query_AbfallkalenderStrassen_kommune_strassen ||
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

extension UtilityExtension_Query_AbfallkalenderStrassen_kommune_strassen
    on Query_AbfallkalenderStrassen_kommune_strassen {
  CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<
    Query_AbfallkalenderStrassen_kommune_strassen
  >
  get copyWith =>
      CopyWith_Query_AbfallkalenderStrassen_kommune_strassen(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<TRes> {
  factory CopyWith_Query_AbfallkalenderStrassen_kommune_strassen(
    Query_AbfallkalenderStrassen_kommune_strassen instance,
    TRes Function(Query_AbfallkalenderStrassen_kommune_strassen) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStrassen_kommune_strassen;

  factory CopyWith_Query_AbfallkalenderStrassen_kommune_strassen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune_strassen;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl_Query_AbfallkalenderStrassen_kommune_strassen<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStrassen_kommune_strassen(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderStrassen_kommune_strassen _instance;

  final TRes Function(Query_AbfallkalenderStrassen_kommune_strassen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderStrassen_kommune_strassen(
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

class _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune_strassen<TRes>
    implements CopyWith_Query_AbfallkalenderStrassen_kommune_strassen<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStrassen_kommune_strassen(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Variables_Query_AbfallkalenderStandorte {
  factory Variables_Query_AbfallkalenderStandorte({
    required String kommuneId,
    required String strassenId,
  }) => Variables_Query_AbfallkalenderStandorte._({
    r'kommuneId': kommuneId,
    r'strassenId': strassenId,
  });

  Variables_Query_AbfallkalenderStandorte._(this._$data);

  factory Variables_Query_AbfallkalenderStandorte.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$strassenId = data['strassenId'];
    result$data['strassenId'] = (l$strassenId as String);
    return Variables_Query_AbfallkalenderStandorte._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get strassenId => (_$data['strassenId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$strassenId = strassenId;
    result$data['strassenId'] = l$strassenId;
    return result$data;
  }

  CopyWith_Variables_Query_AbfallkalenderStandorte<
    Variables_Query_AbfallkalenderStandorte
  >
  get copyWith =>
      CopyWith_Variables_Query_AbfallkalenderStandorte(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AbfallkalenderStandorte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$strassenId = strassenId;
    final lOther$strassenId = other.strassenId;
    if (l$strassenId != lOther$strassenId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$strassenId = strassenId;
    return Object.hashAll([l$kommuneId, l$strassenId]);
  }
}

abstract class CopyWith_Variables_Query_AbfallkalenderStandorte<TRes> {
  factory CopyWith_Variables_Query_AbfallkalenderStandorte(
    Variables_Query_AbfallkalenderStandorte instance,
    TRes Function(Variables_Query_AbfallkalenderStandorte) then,
  ) = _CopyWithImpl_Variables_Query_AbfallkalenderStandorte;

  factory CopyWith_Variables_Query_AbfallkalenderStandorte.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AbfallkalenderStandorte;

  TRes call({String? kommuneId, String? strassenId});
}

class _CopyWithImpl_Variables_Query_AbfallkalenderStandorte<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderStandorte<TRes> {
  _CopyWithImpl_Variables_Query_AbfallkalenderStandorte(
    this._instance,
    this._then,
  );

  final Variables_Query_AbfallkalenderStandorte _instance;

  final TRes Function(Variables_Query_AbfallkalenderStandorte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? strassenId = _undefined,
  }) => _then(
    Variables_Query_AbfallkalenderStandorte._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
      if (strassenId != _undefined && strassenId != null)
        'strassenId': (strassenId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_AbfallkalenderStandorte<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderStandorte<TRes> {
  _CopyWithStubImpl_Variables_Query_AbfallkalenderStandorte(this._res);

  TRes _res;

  call({String? kommuneId, String? strassenId}) => _res;
}

class Query_AbfallkalenderStandorte {
  Query_AbfallkalenderStandorte({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_AbfallkalenderStandorte.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStandorte(
      kommune: Query_AbfallkalenderStandorte_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AbfallkalenderStandorte_kommune kommune;

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
    if (other is! Query_AbfallkalenderStandorte ||
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

extension UtilityExtension_Query_AbfallkalenderStandorte
    on Query_AbfallkalenderStandorte {
  CopyWith_Query_AbfallkalenderStandorte<Query_AbfallkalenderStandorte>
  get copyWith => CopyWith_Query_AbfallkalenderStandorte(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStandorte<TRes> {
  factory CopyWith_Query_AbfallkalenderStandorte(
    Query_AbfallkalenderStandorte instance,
    TRes Function(Query_AbfallkalenderStandorte) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStandorte;

  factory CopyWith_Query_AbfallkalenderStandorte.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderStandorte;

  TRes call({
    Query_AbfallkalenderStandorte_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_AbfallkalenderStandorte<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStandorte(this._instance, this._then);

  final Query_AbfallkalenderStandorte _instance;

  final TRes Function(Query_AbfallkalenderStandorte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_AbfallkalenderStandorte(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_AbfallkalenderStandorte_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_AbfallkalenderStandorte_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_AbfallkalenderStandorte<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStandorte(this._res);

  TRes _res;

  call({Query_AbfallkalenderStandorte_kommune? kommune, String? $__typename}) =>
      _res;

  CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> get kommune =>
      CopyWith_Query_AbfallkalenderStandorte_kommune.stub(_res);
}

const documentNodeQueryAbfallkalenderStandorte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AbfallkalenderStandorte'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'strassenId')),
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
                  name: NameNode(value: 'standorte'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'strassenId'),
                      value: VariableNode(name: NameNode(value: 'strassenId')),
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
                        name: NameNode(value: 'nr'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'zusatz'),
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
Query_AbfallkalenderStandorte _parserFn_Query_AbfallkalenderStandorte(
  Map<String, dynamic> data,
) => Query_AbfallkalenderStandorte.fromJson(data);
typedef OnQueryComplete_Query_AbfallkalenderStandorte =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_AbfallkalenderStandorte?,
    );

class Options_Query_AbfallkalenderStandorte
    extends graphql.QueryOptions<Query_AbfallkalenderStandorte> {
  Options_Query_AbfallkalenderStandorte({
    String? operationName,
    required Variables_Query_AbfallkalenderStandorte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderStandorte? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AbfallkalenderStandorte? onComplete,
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
                     : _parserFn_Query_AbfallkalenderStandorte(data),
               ),
         onError: onError,
         document: documentNodeQueryAbfallkalenderStandorte,
         parserFn: _parserFn_Query_AbfallkalenderStandorte,
       );

  final OnQueryComplete_Query_AbfallkalenderStandorte? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AbfallkalenderStandorte
    extends graphql.WatchQueryOptions<Query_AbfallkalenderStandorte> {
  WatchOptions_Query_AbfallkalenderStandorte({
    String? operationName,
    required Variables_Query_AbfallkalenderStandorte variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderStandorte? typedOptimisticResult,
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
         document: documentNodeQueryAbfallkalenderStandorte,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AbfallkalenderStandorte,
       );
}

class FetchMoreOptions_Query_AbfallkalenderStandorte
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AbfallkalenderStandorte({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AbfallkalenderStandorte variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAbfallkalenderStandorte,
       );
}

extension ClientExtension_Query_AbfallkalenderStandorte
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AbfallkalenderStandorte>>
  query_AbfallkalenderStandorte(
    Options_Query_AbfallkalenderStandorte options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_AbfallkalenderStandorte>
  watchQuery_AbfallkalenderStandorte(
    WatchOptions_Query_AbfallkalenderStandorte options,
  ) => this.watchQuery(options);

  void writeQuery_AbfallkalenderStandorte({
    required Query_AbfallkalenderStandorte data,
    required Variables_Query_AbfallkalenderStandorte variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAbfallkalenderStandorte,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AbfallkalenderStandorte? readQuery_AbfallkalenderStandorte({
    required Variables_Query_AbfallkalenderStandorte variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAbfallkalenderStandorte,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_AbfallkalenderStandorte.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AbfallkalenderStandorte>
useQuery_AbfallkalenderStandorte(
  Options_Query_AbfallkalenderStandorte options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AbfallkalenderStandorte>
useWatchQuery_AbfallkalenderStandorte(
  WatchOptions_Query_AbfallkalenderStandorte options,
) => graphql_flutter.useWatchQuery(options);

class Query_AbfallkalenderStandorte_Widget
    extends graphql_flutter.Query<Query_AbfallkalenderStandorte> {
  Query_AbfallkalenderStandorte_Widget({
    widgets.Key? key,
    required Options_Query_AbfallkalenderStandorte options,
    required graphql_flutter.QueryBuilder<Query_AbfallkalenderStandorte>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AbfallkalenderStandorte_kommune {
  Query_AbfallkalenderStandorte_kommune({
    required this.standorte,
    this.$__typename = 'Kommune',
  });

  factory Query_AbfallkalenderStandorte_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$standorte = json['standorte'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStandorte_kommune(
      standorte: (l$standorte as List<dynamic>)
          .map(
            (e) => Query_AbfallkalenderStandorte_kommune_standorte.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_AbfallkalenderStandorte_kommune_standorte> standorte;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$standorte = standorte;
    _resultData['standorte'] = l$standorte.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$standorte = standorte;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$standorte.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderStandorte_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$standorte = standorte;
    final lOther$standorte = other.standorte;
    if (l$standorte.length != lOther$standorte.length) {
      return false;
    }
    for (int i = 0; i < l$standorte.length; i++) {
      final l$standorte$entry = l$standorte[i];
      final lOther$standorte$entry = lOther$standorte[i];
      if (l$standorte$entry != lOther$standorte$entry) {
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

extension UtilityExtension_Query_AbfallkalenderStandorte_kommune
    on Query_AbfallkalenderStandorte_kommune {
  CopyWith_Query_AbfallkalenderStandorte_kommune<
    Query_AbfallkalenderStandorte_kommune
  >
  get copyWith =>
      CopyWith_Query_AbfallkalenderStandorte_kommune(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> {
  factory CopyWith_Query_AbfallkalenderStandorte_kommune(
    Query_AbfallkalenderStandorte_kommune instance,
    TRes Function(Query_AbfallkalenderStandorte_kommune) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStandorte_kommune;

  factory CopyWith_Query_AbfallkalenderStandorte_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune;

  TRes call({
    List<Query_AbfallkalenderStandorte_kommune_standorte>? standorte,
    String? $__typename,
  });
  TRes standorte(
    Iterable<Query_AbfallkalenderStandorte_kommune_standorte> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<
          Query_AbfallkalenderStandorte_kommune_standorte
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_AbfallkalenderStandorte_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStandorte_kommune(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderStandorte_kommune _instance;

  final TRes Function(Query_AbfallkalenderStandorte_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? standorte = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderStandorte_kommune(
      standorte: standorte == _undefined || standorte == null
          ? _instance.standorte
          : (standorte
                as List<Query_AbfallkalenderStandorte_kommune_standorte>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes standorte(
    Iterable<Query_AbfallkalenderStandorte_kommune_standorte> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<
          Query_AbfallkalenderStandorte_kommune_standorte
        >
      >,
    )
    _fn,
  ) => call(
    standorte: _fn(
      _instance.standorte.map(
        (e) => CopyWith_Query_AbfallkalenderStandorte_kommune_standorte(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte_kommune<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune(this._res);

  TRes _res;

  call({
    List<Query_AbfallkalenderStandorte_kommune_standorte>? standorte,
    String? $__typename,
  }) => _res;

  standorte(_fn) => _res;
}

class Query_AbfallkalenderStandorte_kommune_standorte {
  Query_AbfallkalenderStandorte_kommune_standorte({
    required this.id,
    required this.nr,
    required this.zusatz,
    this.$__typename = 'Standort',
  });

  factory Query_AbfallkalenderStandorte_kommune_standorte.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nr = json['nr'];
    final l$zusatz = json['zusatz'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderStandorte_kommune_standorte(
      id: (l$id as String),
      nr: (l$nr as String),
      zusatz: (l$zusatz as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String nr;

  final String zusatz;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nr = nr;
    _resultData['nr'] = l$nr;
    final l$zusatz = zusatz;
    _resultData['zusatz'] = l$zusatz;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nr = nr;
    final l$zusatz = zusatz;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$nr, l$zusatz, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderStandorte_kommune_standorte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nr = nr;
    final lOther$nr = other.nr;
    if (l$nr != lOther$nr) {
      return false;
    }
    final l$zusatz = zusatz;
    final lOther$zusatz = other.zusatz;
    if (l$zusatz != lOther$zusatz) {
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

extension UtilityExtension_Query_AbfallkalenderStandorte_kommune_standorte
    on Query_AbfallkalenderStandorte_kommune_standorte {
  CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<
    Query_AbfallkalenderStandorte_kommune_standorte
  >
  get copyWith =>
      CopyWith_Query_AbfallkalenderStandorte_kommune_standorte(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<TRes> {
  factory CopyWith_Query_AbfallkalenderStandorte_kommune_standorte(
    Query_AbfallkalenderStandorte_kommune_standorte instance,
    TRes Function(Query_AbfallkalenderStandorte_kommune_standorte) then,
  ) = _CopyWithImpl_Query_AbfallkalenderStandorte_kommune_standorte;

  factory CopyWith_Query_AbfallkalenderStandorte_kommune_standorte.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune_standorte;

  TRes call({String? id, String? nr, String? zusatz, String? $__typename});
}

class _CopyWithImpl_Query_AbfallkalenderStandorte_kommune_standorte<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<TRes> {
  _CopyWithImpl_Query_AbfallkalenderStandorte_kommune_standorte(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderStandorte_kommune_standorte _instance;

  final TRes Function(Query_AbfallkalenderStandorte_kommune_standorte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? nr = _undefined,
    Object? zusatz = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderStandorte_kommune_standorte(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      nr: nr == _undefined || nr == null ? _instance.nr : (nr as String),
      zusatz: zusatz == _undefined || zusatz == null
          ? _instance.zusatz
          : (zusatz as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune_standorte<TRes>
    implements CopyWith_Query_AbfallkalenderStandorte_kommune_standorte<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderStandorte_kommune_standorte(this._res);

  TRes _res;

  call({String? id, String? nr, String? zusatz, String? $__typename}) => _res;
}

class Variables_Query_AbfallkalenderFraktionen {
  factory Variables_Query_AbfallkalenderFraktionen({
    required String kommuneId,
    required String standortId,
  }) => Variables_Query_AbfallkalenderFraktionen._({
    r'kommuneId': kommuneId,
    r'standortId': standortId,
  });

  Variables_Query_AbfallkalenderFraktionen._(this._$data);

  factory Variables_Query_AbfallkalenderFraktionen.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    final l$standortId = data['standortId'];
    result$data['standortId'] = (l$standortId as String);
    return Variables_Query_AbfallkalenderFraktionen._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  String get standortId => (_$data['standortId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    final l$standortId = standortId;
    result$data['standortId'] = l$standortId;
    return result$data;
  }

  CopyWith_Variables_Query_AbfallkalenderFraktionen<
    Variables_Query_AbfallkalenderFraktionen
  >
  get copyWith =>
      CopyWith_Variables_Query_AbfallkalenderFraktionen(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_AbfallkalenderFraktionen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommuneId = kommuneId;
    final lOther$kommuneId = other.kommuneId;
    if (l$kommuneId != lOther$kommuneId) {
      return false;
    }
    final l$standortId = standortId;
    final lOther$standortId = other.standortId;
    if (l$standortId != lOther$standortId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommuneId = kommuneId;
    final l$standortId = standortId;
    return Object.hashAll([l$kommuneId, l$standortId]);
  }
}

abstract class CopyWith_Variables_Query_AbfallkalenderFraktionen<TRes> {
  factory CopyWith_Variables_Query_AbfallkalenderFraktionen(
    Variables_Query_AbfallkalenderFraktionen instance,
    TRes Function(Variables_Query_AbfallkalenderFraktionen) then,
  ) = _CopyWithImpl_Variables_Query_AbfallkalenderFraktionen;

  factory CopyWith_Variables_Query_AbfallkalenderFraktionen.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_AbfallkalenderFraktionen;

  TRes call({String? kommuneId, String? standortId});
}

class _CopyWithImpl_Variables_Query_AbfallkalenderFraktionen<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderFraktionen<TRes> {
  _CopyWithImpl_Variables_Query_AbfallkalenderFraktionen(
    this._instance,
    this._then,
  );

  final Variables_Query_AbfallkalenderFraktionen _instance;

  final TRes Function(Variables_Query_AbfallkalenderFraktionen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommuneId = _undefined,
    Object? standortId = _undefined,
  }) => _then(
    Variables_Query_AbfallkalenderFraktionen._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
      if (standortId != _undefined && standortId != null)
        'standortId': (standortId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_AbfallkalenderFraktionen<TRes>
    implements CopyWith_Variables_Query_AbfallkalenderFraktionen<TRes> {
  _CopyWithStubImpl_Variables_Query_AbfallkalenderFraktionen(this._res);

  TRes _res;

  call({String? kommuneId, String? standortId}) => _res;
}

class Query_AbfallkalenderFraktionen {
  Query_AbfallkalenderFraktionen({
    required this.kommune,
    this.$__typename = 'Query',
  });

  factory Query_AbfallkalenderFraktionen.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderFraktionen(
      kommune: Query_AbfallkalenderFraktionen_kommune.fromJson(
        (l$kommune as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_AbfallkalenderFraktionen_kommune kommune;

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
    if (other is! Query_AbfallkalenderFraktionen ||
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

extension UtilityExtension_Query_AbfallkalenderFraktionen
    on Query_AbfallkalenderFraktionen {
  CopyWith_Query_AbfallkalenderFraktionen<Query_AbfallkalenderFraktionen>
  get copyWith => CopyWith_Query_AbfallkalenderFraktionen(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderFraktionen<TRes> {
  factory CopyWith_Query_AbfallkalenderFraktionen(
    Query_AbfallkalenderFraktionen instance,
    TRes Function(Query_AbfallkalenderFraktionen) then,
  ) = _CopyWithImpl_Query_AbfallkalenderFraktionen;

  factory CopyWith_Query_AbfallkalenderFraktionen.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderFraktionen;

  TRes call({
    Query_AbfallkalenderFraktionen_kommune? kommune,
    String? $__typename,
  });
  CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_AbfallkalenderFraktionen<TRes>
    implements CopyWith_Query_AbfallkalenderFraktionen<TRes> {
  _CopyWithImpl_Query_AbfallkalenderFraktionen(this._instance, this._then);

  final Query_AbfallkalenderFraktionen _instance;

  final TRes Function(Query_AbfallkalenderFraktionen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_AbfallkalenderFraktionen(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Query_AbfallkalenderFraktionen_kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Query_AbfallkalenderFraktionen_kommune(
      local$kommune,
      (e) => call(kommune: e),
    );
  }
}

class _CopyWithStubImpl_Query_AbfallkalenderFraktionen<TRes>
    implements CopyWith_Query_AbfallkalenderFraktionen<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderFraktionen(this._res);

  TRes _res;

  call({
    Query_AbfallkalenderFraktionen_kommune? kommune,
    String? $__typename,
  }) => _res;

  CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> get kommune =>
      CopyWith_Query_AbfallkalenderFraktionen_kommune.stub(_res);
}

const documentNodeQueryAbfallkalenderFraktionen = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AbfallkalenderFraktionen'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommuneId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'standortId')),
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
                  name: NameNode(value: 'fraktionen'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'standortId'),
                      value: VariableNode(name: NameNode(value: 'standortId')),
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
                        name: NameNode(value: 'col'),
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
Query_AbfallkalenderFraktionen _parserFn_Query_AbfallkalenderFraktionen(
  Map<String, dynamic> data,
) => Query_AbfallkalenderFraktionen.fromJson(data);
typedef OnQueryComplete_Query_AbfallkalenderFraktionen =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_AbfallkalenderFraktionen?,
    );

class Options_Query_AbfallkalenderFraktionen
    extends graphql.QueryOptions<Query_AbfallkalenderFraktionen> {
  Options_Query_AbfallkalenderFraktionen({
    String? operationName,
    required Variables_Query_AbfallkalenderFraktionen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderFraktionen? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_AbfallkalenderFraktionen? onComplete,
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
                     : _parserFn_Query_AbfallkalenderFraktionen(data),
               ),
         onError: onError,
         document: documentNodeQueryAbfallkalenderFraktionen,
         parserFn: _parserFn_Query_AbfallkalenderFraktionen,
       );

  final OnQueryComplete_Query_AbfallkalenderFraktionen? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_AbfallkalenderFraktionen
    extends graphql.WatchQueryOptions<Query_AbfallkalenderFraktionen> {
  WatchOptions_Query_AbfallkalenderFraktionen({
    String? operationName,
    required Variables_Query_AbfallkalenderFraktionen variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_AbfallkalenderFraktionen? typedOptimisticResult,
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
         document: documentNodeQueryAbfallkalenderFraktionen,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_AbfallkalenderFraktionen,
       );
}

class FetchMoreOptions_Query_AbfallkalenderFraktionen
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_AbfallkalenderFraktionen({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_AbfallkalenderFraktionen variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryAbfallkalenderFraktionen,
       );
}

extension ClientExtension_Query_AbfallkalenderFraktionen
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_AbfallkalenderFraktionen>>
  query_AbfallkalenderFraktionen(
    Options_Query_AbfallkalenderFraktionen options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_AbfallkalenderFraktionen>
  watchQuery_AbfallkalenderFraktionen(
    WatchOptions_Query_AbfallkalenderFraktionen options,
  ) => this.watchQuery(options);

  void writeQuery_AbfallkalenderFraktionen({
    required Query_AbfallkalenderFraktionen data,
    required Variables_Query_AbfallkalenderFraktionen variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryAbfallkalenderFraktionen,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_AbfallkalenderFraktionen? readQuery_AbfallkalenderFraktionen({
    required Variables_Query_AbfallkalenderFraktionen variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryAbfallkalenderFraktionen,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_AbfallkalenderFraktionen.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_AbfallkalenderFraktionen>
useQuery_AbfallkalenderFraktionen(
  Options_Query_AbfallkalenderFraktionen options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_AbfallkalenderFraktionen>
useWatchQuery_AbfallkalenderFraktionen(
  WatchOptions_Query_AbfallkalenderFraktionen options,
) => graphql_flutter.useWatchQuery(options);

class Query_AbfallkalenderFraktionen_Widget
    extends graphql_flutter.Query<Query_AbfallkalenderFraktionen> {
  Query_AbfallkalenderFraktionen_Widget({
    widgets.Key? key,
    required Options_Query_AbfallkalenderFraktionen options,
    required graphql_flutter.QueryBuilder<Query_AbfallkalenderFraktionen>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_AbfallkalenderFraktionen_kommune {
  Query_AbfallkalenderFraktionen_kommune({
    required this.fraktionen,
    this.$__typename = 'Kommune',
  });

  factory Query_AbfallkalenderFraktionen_kommune.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$fraktionen = json['fraktionen'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderFraktionen_kommune(
      fraktionen: (l$fraktionen as List<dynamic>)
          .map(
            (e) => Query_AbfallkalenderFraktionen_kommune_fraktionen.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_AbfallkalenderFraktionen_kommune_fraktionen> fraktionen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$fraktionen = fraktionen;
    _resultData['fraktionen'] = l$fraktionen.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$fraktionen = fraktionen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$fraktionen.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderFraktionen_kommune ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$fraktionen = fraktionen;
    final lOther$fraktionen = other.fraktionen;
    if (l$fraktionen.length != lOther$fraktionen.length) {
      return false;
    }
    for (int i = 0; i < l$fraktionen.length; i++) {
      final l$fraktionen$entry = l$fraktionen[i];
      final lOther$fraktionen$entry = lOther$fraktionen[i];
      if (l$fraktionen$entry != lOther$fraktionen$entry) {
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

extension UtilityExtension_Query_AbfallkalenderFraktionen_kommune
    on Query_AbfallkalenderFraktionen_kommune {
  CopyWith_Query_AbfallkalenderFraktionen_kommune<
    Query_AbfallkalenderFraktionen_kommune
  >
  get copyWith =>
      CopyWith_Query_AbfallkalenderFraktionen_kommune(this, (i) => i);
}

abstract class CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> {
  factory CopyWith_Query_AbfallkalenderFraktionen_kommune(
    Query_AbfallkalenderFraktionen_kommune instance,
    TRes Function(Query_AbfallkalenderFraktionen_kommune) then,
  ) = _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune;

  factory CopyWith_Query_AbfallkalenderFraktionen_kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune;

  TRes call({
    List<Query_AbfallkalenderFraktionen_kommune_fraktionen>? fraktionen,
    String? $__typename,
  });
  TRes fraktionen(
    Iterable<Query_AbfallkalenderFraktionen_kommune_fraktionen> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<
          Query_AbfallkalenderFraktionen_kommune_fraktionen
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> {
  _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderFraktionen_kommune _instance;

  final TRes Function(Query_AbfallkalenderFraktionen_kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? fraktionen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderFraktionen_kommune(
      fraktionen: fraktionen == _undefined || fraktionen == null
          ? _instance.fraktionen
          : (fraktionen
                as List<Query_AbfallkalenderFraktionen_kommune_fraktionen>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes fraktionen(
    Iterable<Query_AbfallkalenderFraktionen_kommune_fraktionen> Function(
      Iterable<
        CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<
          Query_AbfallkalenderFraktionen_kommune_fraktionen
        >
      >,
    )
    _fn,
  ) => call(
    fraktionen: _fn(
      _instance.fraktionen.map(
        (e) => CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune<TRes>
    implements CopyWith_Query_AbfallkalenderFraktionen_kommune<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune(this._res);

  TRes _res;

  call({
    List<Query_AbfallkalenderFraktionen_kommune_fraktionen>? fraktionen,
    String? $__typename,
  }) => _res;

  fraktionen(_fn) => _res;
}

class Query_AbfallkalenderFraktionen_kommune_fraktionen {
  Query_AbfallkalenderFraktionen_kommune_fraktionen({
    required this.id,
    required this.name,
    this.col,
    this.$__typename = 'Fraktion',
  });

  factory Query_AbfallkalenderFraktionen_kommune_fraktionen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$col = json['col'];
    final l$$__typename = json['__typename'];
    return Query_AbfallkalenderFraktionen_kommune_fraktionen(
      id: (l$id as String),
      name: (l$name as String),
      col: (l$col as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String? col;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$col = col;
    _resultData['col'] = l$col;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$col = col;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$col, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_AbfallkalenderFraktionen_kommune_fraktionen ||
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
    final l$col = col;
    final lOther$col = other.col;
    if (l$col != lOther$col) {
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

extension UtilityExtension_Query_AbfallkalenderFraktionen_kommune_fraktionen
    on Query_AbfallkalenderFraktionen_kommune_fraktionen {
  CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<
    Query_AbfallkalenderFraktionen_kommune_fraktionen
  >
  get copyWith => CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<
  TRes
> {
  factory CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen(
    Query_AbfallkalenderFraktionen_kommune_fraktionen instance,
    TRes Function(Query_AbfallkalenderFraktionen_kommune_fraktionen) then,
  ) = _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen;

  factory CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen;

  TRes call({String? id, String? name, String? col, String? $__typename});
}

class _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen<TRes>
    implements
        CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<TRes> {
  _CopyWithImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen(
    this._instance,
    this._then,
  );

  final Query_AbfallkalenderFraktionen_kommune_fraktionen _instance;

  final TRes Function(Query_AbfallkalenderFraktionen_kommune_fraktionen) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? col = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_AbfallkalenderFraktionen_kommune_fraktionen(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      col: col == _undefined ? _instance.col : (col as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen<TRes>
    implements
        CopyWith_Query_AbfallkalenderFraktionen_kommune_fraktionen<TRes> {
  _CopyWithStubImpl_Query_AbfallkalenderFraktionen_kommune_fraktionen(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? col, String? $__typename}) => _res;
}

class Variables_Query_VeranstaltungsTermineList {
  factory Variables_Query_VeranstaltungsTermineList({
    String? kommune,
    List<String?>? untereinheiten,
    String? von,
    String? bis,
    List<String?>? categoryIds,
    String? search,
    bool? visible,
    int? limit,
    int? page,
    String? sortDirection,
  }) => Variables_Query_VeranstaltungsTermineList._({
    if (kommune != null) r'kommune': kommune,
    if (untereinheiten != null) r'untereinheiten': untereinheiten,
    if (von != null) r'von': von,
    if (bis != null) r'bis': bis,
    if (categoryIds != null) r'categoryIds': categoryIds,
    if (search != null) r'search': search,
    if (visible != null) r'visible': visible,
    if (limit != null) r'limit': limit,
    if (page != null) r'page': page,
    if (sortDirection != null) r'sortDirection': sortDirection,
  });

  Variables_Query_VeranstaltungsTermineList._(this._$data);

  factory Variables_Query_VeranstaltungsTermineList.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('kommune')) {
      final l$kommune = data['kommune'];
      result$data['kommune'] = (l$kommune as String?);
    }
    if (data.containsKey('untereinheiten')) {
      final l$untereinheiten = data['untereinheiten'];
      result$data['untereinheiten'] = (l$untereinheiten as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList();
    }
    if (data.containsKey('von')) {
      final l$von = data['von'];
      result$data['von'] = (l$von as String?);
    }
    if (data.containsKey('bis')) {
      final l$bis = data['bis'];
      result$data['bis'] = (l$bis as String?);
    }
    if (data.containsKey('categoryIds')) {
      final l$categoryIds = data['categoryIds'];
      result$data['categoryIds'] = (l$categoryIds as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList();
    }
    if (data.containsKey('search')) {
      final l$search = data['search'];
      result$data['search'] = (l$search as String?);
    }
    if (data.containsKey('visible')) {
      final l$visible = data['visible'];
      result$data['visible'] = (l$visible as bool?);
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('sortDirection')) {
      final l$sortDirection = data['sortDirection'];
      result$data['sortDirection'] = (l$sortDirection as String?);
    }
    return Variables_Query_VeranstaltungsTermineList._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get kommune => (_$data['kommune'] as String?);

  List<String?>? get untereinheiten =>
      (_$data['untereinheiten'] as List<String?>?);

  String? get von => (_$data['von'] as String?);

  String? get bis => (_$data['bis'] as String?);

  List<String?>? get categoryIds => (_$data['categoryIds'] as List<String?>?);

  String? get search => (_$data['search'] as String?);

  bool? get visible => (_$data['visible'] as bool?);

  int? get limit => (_$data['limit'] as int?);

  int? get page => (_$data['page'] as int?);

  String? get sortDirection => (_$data['sortDirection'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('kommune')) {
      final l$kommune = kommune;
      result$data['kommune'] = l$kommune;
    }
    if (_$data.containsKey('untereinheiten')) {
      final l$untereinheiten = untereinheiten;
      result$data['untereinheiten'] = l$untereinheiten?.map((e) => e).toList();
    }
    if (_$data.containsKey('von')) {
      final l$von = von;
      result$data['von'] = l$von;
    }
    if (_$data.containsKey('bis')) {
      final l$bis = bis;
      result$data['bis'] = l$bis;
    }
    if (_$data.containsKey('categoryIds')) {
      final l$categoryIds = categoryIds;
      result$data['categoryIds'] = l$categoryIds?.map((e) => e).toList();
    }
    if (_$data.containsKey('search')) {
      final l$search = search;
      result$data['search'] = l$search;
    }
    if (_$data.containsKey('visible')) {
      final l$visible = visible;
      result$data['visible'] = l$visible;
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('sortDirection')) {
      final l$sortDirection = sortDirection;
      result$data['sortDirection'] = l$sortDirection;
    }
    return result$data;
  }

  CopyWith_Variables_Query_VeranstaltungsTermineList<
    Variables_Query_VeranstaltungsTermineList
  >
  get copyWith =>
      CopyWith_Variables_Query_VeranstaltungsTermineList(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_VeranstaltungsTermineList ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kommune = kommune;
    final lOther$kommune = other.kommune;
    if (_$data.containsKey('kommune') != other._$data.containsKey('kommune')) {
      return false;
    }
    if (l$kommune != lOther$kommune) {
      return false;
    }
    final l$untereinheiten = untereinheiten;
    final lOther$untereinheiten = other.untereinheiten;
    if (_$data.containsKey('untereinheiten') !=
        other._$data.containsKey('untereinheiten')) {
      return false;
    }
    if (l$untereinheiten != null && lOther$untereinheiten != null) {
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
    } else if (l$untereinheiten != lOther$untereinheiten) {
      return false;
    }
    final l$von = von;
    final lOther$von = other.von;
    if (_$data.containsKey('von') != other._$data.containsKey('von')) {
      return false;
    }
    if (l$von != lOther$von) {
      return false;
    }
    final l$bis = bis;
    final lOther$bis = other.bis;
    if (_$data.containsKey('bis') != other._$data.containsKey('bis')) {
      return false;
    }
    if (l$bis != lOther$bis) {
      return false;
    }
    final l$categoryIds = categoryIds;
    final lOther$categoryIds = other.categoryIds;
    if (_$data.containsKey('categoryIds') !=
        other._$data.containsKey('categoryIds')) {
      return false;
    }
    if (l$categoryIds != null && lOther$categoryIds != null) {
      if (l$categoryIds.length != lOther$categoryIds.length) {
        return false;
      }
      for (int i = 0; i < l$categoryIds.length; i++) {
        final l$categoryIds$entry = l$categoryIds[i];
        final lOther$categoryIds$entry = lOther$categoryIds[i];
        if (l$categoryIds$entry != lOther$categoryIds$entry) {
          return false;
        }
      }
    } else if (l$categoryIds != lOther$categoryIds) {
      return false;
    }
    final l$search = search;
    final lOther$search = other.search;
    if (_$data.containsKey('search') != other._$data.containsKey('search')) {
      return false;
    }
    if (l$search != lOther$search) {
      return false;
    }
    final l$visible = visible;
    final lOther$visible = other.visible;
    if (_$data.containsKey('visible') != other._$data.containsKey('visible')) {
      return false;
    }
    if (l$visible != lOther$visible) {
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
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
      return false;
    }
    final l$sortDirection = sortDirection;
    final lOther$sortDirection = other.sortDirection;
    if (_$data.containsKey('sortDirection') !=
        other._$data.containsKey('sortDirection')) {
      return false;
    }
    if (l$sortDirection != lOther$sortDirection) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$kommune = kommune;
    final l$untereinheiten = untereinheiten;
    final l$von = von;
    final l$bis = bis;
    final l$categoryIds = categoryIds;
    final l$search = search;
    final l$visible = visible;
    final l$limit = limit;
    final l$page = page;
    final l$sortDirection = sortDirection;
    return Object.hashAll([
      _$data.containsKey('kommune') ? l$kommune : const {},
      _$data.containsKey('untereinheiten')
          ? l$untereinheiten == null
                ? null
                : Object.hashAll(l$untereinheiten.map((v) => v))
          : const {},
      _$data.containsKey('von') ? l$von : const {},
      _$data.containsKey('bis') ? l$bis : const {},
      _$data.containsKey('categoryIds')
          ? l$categoryIds == null
                ? null
                : Object.hashAll(l$categoryIds.map((v) => v))
          : const {},
      _$data.containsKey('search') ? l$search : const {},
      _$data.containsKey('visible') ? l$visible : const {},
      _$data.containsKey('limit') ? l$limit : const {},
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('sortDirection') ? l$sortDirection : const {},
    ]);
  }
}

abstract class CopyWith_Variables_Query_VeranstaltungsTermineList<TRes> {
  factory CopyWith_Variables_Query_VeranstaltungsTermineList(
    Variables_Query_VeranstaltungsTermineList instance,
    TRes Function(Variables_Query_VeranstaltungsTermineList) then,
  ) = _CopyWithImpl_Variables_Query_VeranstaltungsTermineList;

  factory CopyWith_Variables_Query_VeranstaltungsTermineList.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_VeranstaltungsTermineList;

  TRes call({
    String? kommune,
    List<String?>? untereinheiten,
    String? von,
    String? bis,
    List<String?>? categoryIds,
    String? search,
    bool? visible,
    int? limit,
    int? page,
    String? sortDirection,
  });
}

class _CopyWithImpl_Variables_Query_VeranstaltungsTermineList<TRes>
    implements CopyWith_Variables_Query_VeranstaltungsTermineList<TRes> {
  _CopyWithImpl_Variables_Query_VeranstaltungsTermineList(
    this._instance,
    this._then,
  );

  final Variables_Query_VeranstaltungsTermineList _instance;

  final TRes Function(Variables_Query_VeranstaltungsTermineList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kommune = _undefined,
    Object? untereinheiten = _undefined,
    Object? von = _undefined,
    Object? bis = _undefined,
    Object? categoryIds = _undefined,
    Object? search = _undefined,
    Object? visible = _undefined,
    Object? limit = _undefined,
    Object? page = _undefined,
    Object? sortDirection = _undefined,
  }) => _then(
    Variables_Query_VeranstaltungsTermineList._({
      ..._instance._$data,
      if (kommune != _undefined) 'kommune': (kommune as String?),
      if (untereinheiten != _undefined)
        'untereinheiten': (untereinheiten as List<String?>?),
      if (von != _undefined) 'von': (von as String?),
      if (bis != _undefined) 'bis': (bis as String?),
      if (categoryIds != _undefined)
        'categoryIds': (categoryIds as List<String?>?),
      if (search != _undefined) 'search': (search as String?),
      if (visible != _undefined) 'visible': (visible as bool?),
      if (limit != _undefined) 'limit': (limit as int?),
      if (page != _undefined) 'page': (page as int?),
      if (sortDirection != _undefined)
        'sortDirection': (sortDirection as String?),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_VeranstaltungsTermineList<TRes>
    implements CopyWith_Variables_Query_VeranstaltungsTermineList<TRes> {
  _CopyWithStubImpl_Variables_Query_VeranstaltungsTermineList(this._res);

  TRes _res;

  call({
    String? kommune,
    List<String?>? untereinheiten,
    String? von,
    String? bis,
    List<String?>? categoryIds,
    String? search,
    bool? visible,
    int? limit,
    int? page,
    String? sortDirection,
  }) => _res;
}

class Query_VeranstaltungsTermineList {
  Query_VeranstaltungsTermineList({
    this.veranstaltungsTermine,
    this.$__typename = 'Query',
  });

  factory Query_VeranstaltungsTermineList.fromJson(Map<String, dynamic> json) {
    final l$veranstaltungsTermine = json['veranstaltungsTermine'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList(
      veranstaltungsTermine: l$veranstaltungsTermine == null
          ? null
          : Query_VeranstaltungsTermineList_veranstaltungsTermine.fromJson(
              (l$veranstaltungsTermine as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_VeranstaltungsTermineList_veranstaltungsTermine?
  veranstaltungsTermine;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$veranstaltungsTermine = veranstaltungsTermine;
    _resultData['veranstaltungsTermine'] = l$veranstaltungsTermine?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$veranstaltungsTermine = veranstaltungsTermine;
    final l$$__typename = $__typename;
    return Object.hashAll([l$veranstaltungsTermine, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungsTermineList ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$veranstaltungsTermine = veranstaltungsTermine;
    final lOther$veranstaltungsTermine = other.veranstaltungsTermine;
    if (l$veranstaltungsTermine != lOther$veranstaltungsTermine) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList
    on Query_VeranstaltungsTermineList {
  CopyWith_Query_VeranstaltungsTermineList<Query_VeranstaltungsTermineList>
  get copyWith => CopyWith_Query_VeranstaltungsTermineList(this, (i) => i);
}

abstract class CopyWith_Query_VeranstaltungsTermineList<TRes> {
  factory CopyWith_Query_VeranstaltungsTermineList(
    Query_VeranstaltungsTermineList instance,
    TRes Function(Query_VeranstaltungsTermineList) then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList;

  factory CopyWith_Query_VeranstaltungsTermineList.stub(TRes res) =
      _CopyWithStubImpl_Query_VeranstaltungsTermineList;

  TRes call({
    Query_VeranstaltungsTermineList_veranstaltungsTermine?
    veranstaltungsTermine,
    String? $__typename,
  });
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine;
}

class _CopyWithImpl_Query_VeranstaltungsTermineList<TRes>
    implements CopyWith_Query_VeranstaltungsTermineList<TRes> {
  _CopyWithImpl_Query_VeranstaltungsTermineList(this._instance, this._then);

  final Query_VeranstaltungsTermineList _instance;

  final TRes Function(Query_VeranstaltungsTermineList) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? veranstaltungsTermine = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList(
      veranstaltungsTermine: veranstaltungsTermine == _undefined
          ? _instance.veranstaltungsTermine
          : (veranstaltungsTermine
                as Query_VeranstaltungsTermineList_veranstaltungsTermine?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine {
    final local$veranstaltungsTermine = _instance.veranstaltungsTermine;
    return local$veranstaltungsTermine == null
        ? CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine.stub(
            _then(_instance),
          )
        : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine(
            local$veranstaltungsTermine,
            (e) => call(veranstaltungsTermine: e),
          );
  }
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList<TRes>
    implements CopyWith_Query_VeranstaltungsTermineList<TRes> {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList(this._res);

  TRes _res;

  call({
    Query_VeranstaltungsTermineList_veranstaltungsTermine?
    veranstaltungsTermine,
    String? $__typename,
  }) => _res;

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes>
  get veranstaltungsTermine =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine.stub(_res);
}

const documentNodeQueryVeranstaltungsTermineList = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VeranstaltungsTermineList'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kommune')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'untereinheiten')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: false,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'von')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bis')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'categoryIds')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: false,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'search')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'visible')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sortDirection')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
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
            name: NameNode(value: 'veranstaltungsTermine'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommune'),
                value: VariableNode(name: NameNode(value: 'kommune')),
              ),
              ArgumentNode(
                name: NameNode(value: 'untereinheiten'),
                value: VariableNode(name: NameNode(value: 'untereinheiten')),
              ),
              ArgumentNode(
                name: NameNode(value: 'von'),
                value: VariableNode(name: NameNode(value: 'von')),
              ),
              ArgumentNode(
                name: NameNode(value: 'bis'),
                value: VariableNode(name: NameNode(value: 'bis')),
              ),
              ArgumentNode(
                name: NameNode(value: 'categoryIds'),
                value: VariableNode(name: NameNode(value: 'categoryIds')),
              ),
              ArgumentNode(
                name: NameNode(value: 'search'),
                value: VariableNode(name: NameNode(value: 'search')),
              ),
              ArgumentNode(
                name: NameNode(value: 'visible'),
                value: VariableNode(name: NameNode(value: 'visible')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sortDirection'),
                value: VariableNode(name: NameNode(value: 'sortDirection')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'totalDocs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'totalPages'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
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
                  name: NameNode(value: 'limit'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
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
                        name: NameNode(value: 'titel'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'subtitle'),
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
                        name: NameNode(value: 'buchungsUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'ticketUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'anbieterUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'locationName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'address'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'coordinates'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'start'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'end'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'dates'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'start'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'end'),
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
                        name: NameNode(value: 'titelbild'),
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
                              name: NameNode(value: 'label'),
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
  ],
);
Query_VeranstaltungsTermineList _parserFn_Query_VeranstaltungsTermineList(
  Map<String, dynamic> data,
) => Query_VeranstaltungsTermineList.fromJson(data);
typedef OnQueryComplete_Query_VeranstaltungsTermineList =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_VeranstaltungsTermineList?,
    );

class Options_Query_VeranstaltungsTermineList
    extends graphql.QueryOptions<Query_VeranstaltungsTermineList> {
  Options_Query_VeranstaltungsTermineList({
    String? operationName,
    Variables_Query_VeranstaltungsTermineList? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VeranstaltungsTermineList? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VeranstaltungsTermineList? onComplete,
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
                 data == null
                     ? null
                     : _parserFn_Query_VeranstaltungsTermineList(data),
               ),
         onError: onError,
         document: documentNodeQueryVeranstaltungsTermineList,
         parserFn: _parserFn_Query_VeranstaltungsTermineList,
       );

  final OnQueryComplete_Query_VeranstaltungsTermineList? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VeranstaltungsTermineList
    extends graphql.WatchQueryOptions<Query_VeranstaltungsTermineList> {
  WatchOptions_Query_VeranstaltungsTermineList({
    String? operationName,
    Variables_Query_VeranstaltungsTermineList? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VeranstaltungsTermineList? typedOptimisticResult,
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
         document: documentNodeQueryVeranstaltungsTermineList,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VeranstaltungsTermineList,
       );
}

class FetchMoreOptions_Query_VeranstaltungsTermineList
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VeranstaltungsTermineList({
    required graphql.UpdateQuery updateQuery,
    Variables_Query_VeranstaltungsTermineList? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryVeranstaltungsTermineList,
       );
}

extension ClientExtension_Query_VeranstaltungsTermineList
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VeranstaltungsTermineList>>
  query_VeranstaltungsTermineList([
    Options_Query_VeranstaltungsTermineList? options,
  ]) async =>
      await this.query(options ?? Options_Query_VeranstaltungsTermineList());

  graphql.ObservableQuery<Query_VeranstaltungsTermineList>
  watchQuery_VeranstaltungsTermineList([
    WatchOptions_Query_VeranstaltungsTermineList? options,
  ]) => this.watchQuery(
    options ?? WatchOptions_Query_VeranstaltungsTermineList(),
  );

  void writeQuery_VeranstaltungsTermineList({
    required Query_VeranstaltungsTermineList data,
    Variables_Query_VeranstaltungsTermineList? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryVeranstaltungsTermineList,
      ),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VeranstaltungsTermineList? readQuery_VeranstaltungsTermineList({
    Variables_Query_VeranstaltungsTermineList? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryVeranstaltungsTermineList,
        ),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_VeranstaltungsTermineList.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VeranstaltungsTermineList>
useQuery_VeranstaltungsTermineList([
  Options_Query_VeranstaltungsTermineList? options,
]) => graphql_flutter.useQuery(
  options ?? Options_Query_VeranstaltungsTermineList(),
);
graphql.ObservableQuery<Query_VeranstaltungsTermineList>
useWatchQuery_VeranstaltungsTermineList([
  WatchOptions_Query_VeranstaltungsTermineList? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_VeranstaltungsTermineList(),
);

class Query_VeranstaltungsTermineList_Widget
    extends graphql_flutter.Query<Query_VeranstaltungsTermineList> {
  Query_VeranstaltungsTermineList_Widget({
    widgets.Key? key,
    Options_Query_VeranstaltungsTermineList? options,
    required graphql_flutter.QueryBuilder<Query_VeranstaltungsTermineList>
    builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_VeranstaltungsTermineList(),
         builder: builder,
       );
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine {
  Query_VeranstaltungsTermineList_veranstaltungsTermine({
    this.totalDocs,
    this.totalPages,
    this.hasNextPage,
    this.page,
    this.limit,
    this.docs,
    this.$__typename = 'VeranstaltungsTermineResult',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$totalDocs = json['totalDocs'];
    final l$totalPages = json['totalPages'];
    final l$hasNextPage = json['hasNextPage'];
    final l$page = json['page'];
    final l$limit = json['limit'];
    final l$docs = json['docs'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine(
      totalDocs: (l$totalDocs as int?),
      totalPages: (l$totalPages as int?),
      hasNextPage: (l$hasNextPage as bool?),
      page: (l$page as int?),
      limit: (l$limit as int?),
      docs: (l$docs as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_VeranstaltungsTermineList_veranstaltungsTermine_docs.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int? totalDocs;

  final int? totalPages;

  final bool? hasNextPage;

  final int? page;

  final int? limit;

  final List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?>? docs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$totalDocs = totalDocs;
    _resultData['totalDocs'] = l$totalDocs;
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$page = page;
    _resultData['page'] = l$page;
    final l$limit = limit;
    _resultData['limit'] = l$limit;
    final l$docs = docs;
    _resultData['docs'] = l$docs?.map((e) => e?.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$totalDocs = totalDocs;
    final l$totalPages = totalPages;
    final l$hasNextPage = hasNextPage;
    final l$page = page;
    final l$limit = limit;
    final l$docs = docs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$totalDocs,
      l$totalPages,
      l$hasNextPage,
      l$page,
      l$limit,
      l$docs == null ? null : Object.hashAll(l$docs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungsTermineList_veranstaltungsTermine ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$totalDocs = totalDocs;
    final lOther$totalDocs = other.totalDocs;
    if (l$totalDocs != lOther$totalDocs) {
      return false;
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
      return false;
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
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (l$limit != lOther$limit) {
      return false;
    }
    final l$docs = docs;
    final lOther$docs = other.docs;
    if (l$docs != null && lOther$docs != null) {
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
    } else if (l$docs != lOther$docs) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine
    on Query_VeranstaltungsTermineList_veranstaltungsTermine {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<
    Query_VeranstaltungsTermineList_veranstaltungsTermine
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine(
    Query_VeranstaltungsTermineList_veranstaltungsTermine instance,
    TRes Function(Query_VeranstaltungsTermineList_veranstaltungsTermine) then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine;

  TRes call({
    int? totalDocs,
    int? totalPages,
    bool? hasNextPage,
    int? page,
    int? limit,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?>? docs,
    String? $__typename,
  });
  TRes docs(
    Iterable<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?>?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes> {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine _instance;

  final TRes Function(Query_VeranstaltungsTermineList_veranstaltungsTermine)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? totalDocs = _undefined,
    Object? totalPages = _undefined,
    Object? hasNextPage = _undefined,
    Object? page = _undefined,
    Object? limit = _undefined,
    Object? docs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine(
      totalDocs: totalDocs == _undefined
          ? _instance.totalDocs
          : (totalDocs as int?),
      totalPages: totalPages == _undefined
          ? _instance.totalPages
          : (totalPages as int?),
      hasNextPage: hasNextPage == _undefined
          ? _instance.hasNextPage
          : (hasNextPage as bool?),
      page: page == _undefined ? _instance.page : (page as int?),
      limit: limit == _undefined ? _instance.limit : (limit as int?),
      docs: docs == _undefined
          ? _instance.docs
          : (docs
                as List<
                  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes docs(
    Iterable<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?>?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs
        >?
      >?,
    )
    _fn,
  ) => call(
    docs: _fn(
      _instance.docs?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine<TRes> {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine(
    this._res,
  );

  TRes _res;

  call({
    int? totalDocs,
    int? totalPages,
    bool? hasNextPage,
    int? page,
    int? limit,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs?>? docs,
    String? $__typename,
  }) => _res;

  docs(_fn) => _res;
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine_docs {
  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs({
    this.id,
    this.titel,
    this.subtitle,
    this.teaser,
    this.buchungsUrl,
    this.ticketUrl,
    this.anbieterUrl,
    this.locationName,
    this.address,
    this.coordinates,
    this.start,
    this.end,
    this.dates,
    this.titelbild,
    this.category,
    this.$__typename = 'VeranstaltungsTermin',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine_docs.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$titel = json['titel'];
    final l$subtitle = json['subtitle'];
    final l$teaser = json['teaser'];
    final l$buchungsUrl = json['buchungsUrl'];
    final l$ticketUrl = json['ticketUrl'];
    final l$anbieterUrl = json['anbieterUrl'];
    final l$locationName = json['locationName'];
    final l$address = json['address'];
    final l$coordinates = json['coordinates'];
    final l$start = json['start'];
    final l$end = json['end'];
    final l$dates = json['dates'];
    final l$titelbild = json['titelbild'];
    final l$category = json['category'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
      id: (l$id as String?),
      titel: (l$titel as String?),
      subtitle: (l$subtitle as String?),
      teaser: (l$teaser as String?),
      buchungsUrl: (l$buchungsUrl as String?),
      ticketUrl: (l$ticketUrl as String?),
      anbieterUrl: (l$anbieterUrl as String?),
      locationName: (l$locationName as String?),
      address: (l$address as String?),
      coordinates: (l$coordinates as List<dynamic>?)
          ?.map((e) => (e as String?))
          .toList(),
      start: (l$start as String?),
      end: (l$end as String?),
      dates: (l$dates as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      titelbild: l$titelbild == null
          ? null
          : Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild.fromJson(
              (l$titelbild as Map<String, dynamic>),
            ),
      category: (l$category as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? titel;

  final String? subtitle;

  final String? teaser;

  final String? buchungsUrl;

  final String? ticketUrl;

  final String? anbieterUrl;

  final String? locationName;

  final String? address;

  final List<String?>? coordinates;

  final String? start;

  final String? end;

  final List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?>?
  dates;

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild?
  titelbild;

  final List<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?
  >?
  category;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$titel = titel;
    _resultData['titel'] = l$titel;
    final l$subtitle = subtitle;
    _resultData['subtitle'] = l$subtitle;
    final l$teaser = teaser;
    _resultData['teaser'] = l$teaser;
    final l$buchungsUrl = buchungsUrl;
    _resultData['buchungsUrl'] = l$buchungsUrl;
    final l$ticketUrl = ticketUrl;
    _resultData['ticketUrl'] = l$ticketUrl;
    final l$anbieterUrl = anbieterUrl;
    _resultData['anbieterUrl'] = l$anbieterUrl;
    final l$locationName = locationName;
    _resultData['locationName'] = l$locationName;
    final l$address = address;
    _resultData['address'] = l$address;
    final l$coordinates = coordinates;
    _resultData['coordinates'] = l$coordinates?.map((e) => e).toList();
    final l$start = start;
    _resultData['start'] = l$start;
    final l$end = end;
    _resultData['end'] = l$end;
    final l$dates = dates;
    _resultData['dates'] = l$dates?.map((e) => e?.toJson()).toList();
    final l$titelbild = titelbild;
    _resultData['titelbild'] = l$titelbild?.toJson();
    final l$category = category;
    _resultData['category'] = l$category?.map((e) => e?.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$titel = titel;
    final l$subtitle = subtitle;
    final l$teaser = teaser;
    final l$buchungsUrl = buchungsUrl;
    final l$ticketUrl = ticketUrl;
    final l$anbieterUrl = anbieterUrl;
    final l$locationName = locationName;
    final l$address = address;
    final l$coordinates = coordinates;
    final l$start = start;
    final l$end = end;
    final l$dates = dates;
    final l$titelbild = titelbild;
    final l$category = category;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$titel,
      l$subtitle,
      l$teaser,
      l$buchungsUrl,
      l$ticketUrl,
      l$anbieterUrl,
      l$locationName,
      l$address,
      l$coordinates == null
          ? null
          : Object.hashAll(l$coordinates.map((v) => v)),
      l$start,
      l$end,
      l$dates == null ? null : Object.hashAll(l$dates.map((v) => v)),
      l$titelbild,
      l$category == null ? null : Object.hashAll(l$category.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VeranstaltungsTermineList_veranstaltungsTermine_docs ||
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
    final l$subtitle = subtitle;
    final lOther$subtitle = other.subtitle;
    if (l$subtitle != lOther$subtitle) {
      return false;
    }
    final l$teaser = teaser;
    final lOther$teaser = other.teaser;
    if (l$teaser != lOther$teaser) {
      return false;
    }
    final l$buchungsUrl = buchungsUrl;
    final lOther$buchungsUrl = other.buchungsUrl;
    if (l$buchungsUrl != lOther$buchungsUrl) {
      return false;
    }
    final l$ticketUrl = ticketUrl;
    final lOther$ticketUrl = other.ticketUrl;
    if (l$ticketUrl != lOther$ticketUrl) {
      return false;
    }
    final l$anbieterUrl = anbieterUrl;
    final lOther$anbieterUrl = other.anbieterUrl;
    if (l$anbieterUrl != lOther$anbieterUrl) {
      return false;
    }
    final l$locationName = locationName;
    final lOther$locationName = other.locationName;
    if (l$locationName != lOther$locationName) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    final l$coordinates = coordinates;
    final lOther$coordinates = other.coordinates;
    if (l$coordinates != null && lOther$coordinates != null) {
      if (l$coordinates.length != lOther$coordinates.length) {
        return false;
      }
      for (int i = 0; i < l$coordinates.length; i++) {
        final l$coordinates$entry = l$coordinates[i];
        final lOther$coordinates$entry = lOther$coordinates[i];
        if (l$coordinates$entry != lOther$coordinates$entry) {
          return false;
        }
      }
    } else if (l$coordinates != lOther$coordinates) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
      return false;
    }
    final l$dates = dates;
    final lOther$dates = other.dates;
    if (l$dates != null && lOther$dates != null) {
      if (l$dates.length != lOther$dates.length) {
        return false;
      }
      for (int i = 0; i < l$dates.length; i++) {
        final l$dates$entry = l$dates[i];
        final lOther$dates$entry = lOther$dates[i];
        if (l$dates$entry != lOther$dates$entry) {
          return false;
        }
      }
    } else if (l$dates != lOther$dates) {
      return false;
    }
    final l$titelbild = titelbild;
    final lOther$titelbild = other.titelbild;
    if (l$titelbild != lOther$titelbild) {
      return false;
    }
    final l$category = category;
    final lOther$category = other.category;
    if (l$category != null && lOther$category != null) {
      if (l$category.length != lOther$category.length) {
        return false;
      }
      for (int i = 0; i < l$category.length; i++) {
        final l$category$entry = l$category[i];
        final lOther$category$entry = lOther$category[i];
        if (l$category$entry != lOther$category$entry) {
          return false;
        }
      }
    } else if (l$category != lOther$category) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs
    on Query_VeranstaltungsTermineList_veranstaltungsTermine_docs {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs instance,
    TRes Function(Query_VeranstaltungsTermineList_veranstaltungsTermine_docs)
    then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs;

  TRes call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    String? anbieterUrl,
    String? locationName,
    String? address,
    List<String?>? coordinates,
    String? start,
    String? end,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?>?
    dates,
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild?
    titelbild,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?>?
    category,
    String? $__typename,
  });
  TRes dates(
    Iterable<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?>?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates
        >?
      >?,
    )
    _fn,
  );
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
    TRes
  >
  get titelbild;
  TRes category(
    Iterable<
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?
    >?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs _instance;

  final TRes Function(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? titel = _undefined,
    Object? subtitle = _undefined,
    Object? teaser = _undefined,
    Object? buchungsUrl = _undefined,
    Object? ticketUrl = _undefined,
    Object? anbieterUrl = _undefined,
    Object? locationName = _undefined,
    Object? address = _undefined,
    Object? coordinates = _undefined,
    Object? start = _undefined,
    Object? end = _undefined,
    Object? dates = _undefined,
    Object? titelbild = _undefined,
    Object? category = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
      id: id == _undefined ? _instance.id : (id as String?),
      titel: titel == _undefined ? _instance.titel : (titel as String?),
      subtitle: subtitle == _undefined
          ? _instance.subtitle
          : (subtitle as String?),
      teaser: teaser == _undefined ? _instance.teaser : (teaser as String?),
      buchungsUrl: buchungsUrl == _undefined
          ? _instance.buchungsUrl
          : (buchungsUrl as String?),
      ticketUrl: ticketUrl == _undefined
          ? _instance.ticketUrl
          : (ticketUrl as String?),
      anbieterUrl: anbieterUrl == _undefined
          ? _instance.anbieterUrl
          : (anbieterUrl as String?),
      locationName: locationName == _undefined
          ? _instance.locationName
          : (locationName as String?),
      address: address == _undefined ? _instance.address : (address as String?),
      coordinates: coordinates == _undefined
          ? _instance.coordinates
          : (coordinates as List<String?>?),
      start: start == _undefined ? _instance.start : (start as String?),
      end: end == _undefined ? _instance.end : (end as String?),
      dates: dates == _undefined
          ? _instance.dates
          : (dates
                as List<
                  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?
                >?),
      titelbild: titelbild == _undefined
          ? _instance.titelbild
          : (titelbild
                as Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild?),
      category: category == _undefined
          ? _instance.category
          : (category
                as List<
                  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes dates(
    Iterable<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?>?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates
        >?
      >?,
    )
    _fn,
  ) => call(
    dates: _fn(
      _instance.dates?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
    TRes
  >
  get titelbild {
    final local$titelbild = _instance.titelbild;
    return local$titelbild == null
        ? CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild.stub(
            _then(_instance),
          )
        : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
            local$titelbild,
            (e) => call(titelbild: e),
          );
  }

  TRes category(
    Iterable<
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?
    >?
    Function(
      Iterable<
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
          Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
        >?
      >?,
    )
    _fn,
  ) => call(
    category: _fn(
      _instance.category?.map(
        (e) => e == null
            ? null
            : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? titel,
    String? subtitle,
    String? teaser,
    String? buchungsUrl,
    String? ticketUrl,
    String? anbieterUrl,
    String? locationName,
    String? address,
    List<String?>? coordinates,
    String? start,
    String? end,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates?>?
    dates,
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild?
    titelbild,
    List<Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category?>?
    category,
    String? $__typename,
  }) => _res;

  dates(_fn) => _res;

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
    TRes
  >
  get titelbild =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild.stub(
        _res,
      );

  category(_fn) => _res;
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates {
  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates({
    this.start,
    this.end,
    this.$__typename = 'VeranstaltungsTerminDate',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$start = json['start'];
    final l$end = json['end'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
      start: (l$start as String?),
      end: (l$end as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? start;

  final String? end;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$start = start;
    _resultData['start'] = l$start;
    final l$end = end;
    _resultData['end'] = l$end;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$start = start;
    final l$end = end;
    final l$$__typename = $__typename;
    return Object.hashAll([l$start, l$end, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$start = start;
    final lOther$start = other.start;
    if (l$start != lOther$start) {
      return false;
    }
    final l$end = end;
    final lOther$end = other.end;
    if (l$end != lOther$end) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates
    on Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates instance,
    TRes Function(
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates;

  TRes call({String? start, String? end, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates
  _instance;

  final TRes Function(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? start = _undefined,
    Object? end = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
      start: start == _undefined ? _instance.start : (start as String?),
      end: end == _undefined ? _instance.end : (end as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_dates(
    this._res,
  );

  TRes _res;

  call({String? start, String? end, String? $__typename}) => _res;
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild {
  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild({
    this.$external,
    this.url,
    this.internal,
    this.$__typename = 'VeranstaltungsTerminTitelbild',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$external = json['external'];
    final l$url = json['url'];
    final l$internal = json['internal'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
      $external: (l$$external as bool?),
      url: (l$url as String?),
      internal: l$internal == null
          ? null
          : Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal.fromJson(
              (l$internal as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? $external;

  final String? url;

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal?
  internal;

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
    if (other
            is! Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild
    on Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild
    instance,
    TRes Function(
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild;

  TRes call({
    bool? $external,
    String? url,
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal?
    internal,
    String? $__typename,
  });
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
    TRes
  >
  get internal;
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild
  _instance;

  final TRes Function(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? $external = _undefined,
    Object? url = _undefined,
    Object? internal = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
      $external: $external == _undefined
          ? _instance.$external
          : ($external as bool?),
      url: url == _undefined ? _instance.url : (url as String?),
      internal: internal == _undefined
          ? _instance.internal
          : (internal
                as Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
    TRes
  >
  get internal {
    final local$internal = _instance.internal;
    return local$internal == null
        ? CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
            _then(_instance),
          )
        : CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
            local$internal,
            (e) => call(internal: e),
          );
  }
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild(
    this._res,
  );

  TRes _res;

  call({
    bool? $external,
    String? url,
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal?
    internal,
    String? $__typename,
  }) => _res;

  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
    TRes
  >
  get internal =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
        _res,
      );
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal {
  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal({
    this.url,
    this.$__typename = 'VeranstaltungsTerminTitelbildInternal',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
      url: (l$url as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal
    on Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal
    instance,
    TRes Function(
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal
  _instance;

  final TRes Function(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_titelbild_internal(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category {
  Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category({
    this.id,
    this.label,
    this.$__typename = 'VeranstaltungsTerminKategorie',
  });

  factory Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
      id: (l$id as String?),
      label: (l$label as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? id;

  final String? label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

extension UtilityExtension_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
    on Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category {
  CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
  >
  get copyWith =>
      CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
  TRes
> {
  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
    instance,
    TRes Function(
      Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category,
    )
    then,
  ) = _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category;

  factory CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category;

  TRes call({String? id, String? label, String? $__typename});
}

class _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
          TRes
        > {
  _CopyWithImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
    this._instance,
    this._then,
  );

  final Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category
  _instance;

  final TRes Function(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? label = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
      id: id == _undefined ? _instance.id : (id as String?),
      label: label == _undefined ? _instance.label : (label as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
  TRes
>
    implements
        CopyWith_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category<
          TRes
        > {
  _CopyWithStubImpl_Query_VeranstaltungsTermineList_veranstaltungsTermine_docs_category(
    this._res,
  );

  TRes _res;

  call({String? id, String? label, String? $__typename}) => _res;
}

class Variables_Query_Veranstaltung {
  factory Variables_Query_Veranstaltung({required String id}) =>
      Variables_Query_Veranstaltung._({r'id': id});

  Variables_Query_Veranstaltung._(this._$data);

  factory Variables_Query_Veranstaltung.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_Veranstaltung._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_Veranstaltung<Variables_Query_Veranstaltung>
  get copyWith => CopyWith_Variables_Query_Veranstaltung(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Veranstaltung ||
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

abstract class CopyWith_Variables_Query_Veranstaltung<TRes> {
  factory CopyWith_Variables_Query_Veranstaltung(
    Variables_Query_Veranstaltung instance,
    TRes Function(Variables_Query_Veranstaltung) then,
  ) = _CopyWithImpl_Variables_Query_Veranstaltung;

  factory CopyWith_Variables_Query_Veranstaltung.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Veranstaltung;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_Veranstaltung<TRes>
    implements CopyWith_Variables_Query_Veranstaltung<TRes> {
  _CopyWithImpl_Variables_Query_Veranstaltung(this._instance, this._then);

  final Variables_Query_Veranstaltung _instance;

  final TRes Function(Variables_Query_Veranstaltung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_Veranstaltung._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Veranstaltung<TRes>
    implements CopyWith_Variables_Query_Veranstaltung<TRes> {
  _CopyWithStubImpl_Variables_Query_Veranstaltung(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_Veranstaltung {
  Query_Veranstaltung({
    this.veranstaltungskalender,
    this.$__typename = 'Query',
  });

  factory Query_Veranstaltung.fromJson(Map<String, dynamic> json) {
    final l$veranstaltungskalender = json['veranstaltungskalender'];
    final l$$__typename = json['__typename'];
    return Query_Veranstaltung(
      veranstaltungskalender: l$veranstaltungskalender == null
          ? null
          : Fragment_Veranstaltung.fromJson(
              (l$veranstaltungskalender as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_Veranstaltung? veranstaltungskalender;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$veranstaltungskalender = veranstaltungskalender;
    _resultData['veranstaltungskalender'] = l$veranstaltungskalender?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$veranstaltungskalender = veranstaltungskalender;
    final l$$__typename = $__typename;
    return Object.hashAll([l$veranstaltungskalender, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_Veranstaltung || runtimeType != other.runtimeType) {
      return false;
    }
    final l$veranstaltungskalender = veranstaltungskalender;
    final lOther$veranstaltungskalender = other.veranstaltungskalender;
    if (l$veranstaltungskalender != lOther$veranstaltungskalender) {
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

extension UtilityExtension_Query_Veranstaltung on Query_Veranstaltung {
  CopyWith_Query_Veranstaltung<Query_Veranstaltung> get copyWith =>
      CopyWith_Query_Veranstaltung(this, (i) => i);
}

abstract class CopyWith_Query_Veranstaltung<TRes> {
  factory CopyWith_Query_Veranstaltung(
    Query_Veranstaltung instance,
    TRes Function(Query_Veranstaltung) then,
  ) = _CopyWithImpl_Query_Veranstaltung;

  factory CopyWith_Query_Veranstaltung.stub(TRes res) =
      _CopyWithStubImpl_Query_Veranstaltung;

  TRes call({
    Fragment_Veranstaltung? veranstaltungskalender,
    String? $__typename,
  });
  CopyWith_Fragment_Veranstaltung<TRes> get veranstaltungskalender;
}

class _CopyWithImpl_Query_Veranstaltung<TRes>
    implements CopyWith_Query_Veranstaltung<TRes> {
  _CopyWithImpl_Query_Veranstaltung(this._instance, this._then);

  final Query_Veranstaltung _instance;

  final TRes Function(Query_Veranstaltung) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? veranstaltungskalender = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_Veranstaltung(
      veranstaltungskalender: veranstaltungskalender == _undefined
          ? _instance.veranstaltungskalender
          : (veranstaltungskalender as Fragment_Veranstaltung?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_Veranstaltung<TRes> get veranstaltungskalender {
    final local$veranstaltungskalender = _instance.veranstaltungskalender;
    return local$veranstaltungskalender == null
        ? CopyWith_Fragment_Veranstaltung.stub(_then(_instance))
        : CopyWith_Fragment_Veranstaltung(
            local$veranstaltungskalender,
            (e) => call(veranstaltungskalender: e),
          );
  }
}

class _CopyWithStubImpl_Query_Veranstaltung<TRes>
    implements CopyWith_Query_Veranstaltung<TRes> {
  _CopyWithStubImpl_Query_Veranstaltung(this._res);

  TRes _res;

  call({Fragment_Veranstaltung? veranstaltungskalender, String? $__typename}) =>
      _res;

  CopyWith_Fragment_Veranstaltung<TRes> get veranstaltungskalender =>
      CopyWith_Fragment_Veranstaltung.stub(_res);
}

const documentNodeQueryVeranstaltung = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Veranstaltung'),
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
            name: NameNode(value: 'veranstaltungskalender'),
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
                  name: NameNode(value: 'Veranstaltung'),
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
    fragmentDefinitionVeranstaltung,
    fragmentDefinitionVeranstaltungInfo,
    fragmentDefinitionVeranstaltungsmedienImage,
    fragmentDefinitionTimeAndLocation,
    fragmentDefinitionAdresse,
    fragmentDefinitionRichTextBlock,
    fragmentDefinitionImageBlockVeranstaltungsmedien,
  ],
);
Query_Veranstaltung _parserFn_Query_Veranstaltung(Map<String, dynamic> data) =>
    Query_Veranstaltung.fromJson(data);
typedef OnQueryComplete_Query_Veranstaltung =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Veranstaltung?);

class Options_Query_Veranstaltung
    extends graphql.QueryOptions<Query_Veranstaltung> {
  Options_Query_Veranstaltung({
    String? operationName,
    required Variables_Query_Veranstaltung variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Veranstaltung? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Veranstaltung? onComplete,
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
                 data == null ? null : _parserFn_Query_Veranstaltung(data),
               ),
         onError: onError,
         document: documentNodeQueryVeranstaltung,
         parserFn: _parserFn_Query_Veranstaltung,
       );

  final OnQueryComplete_Query_Veranstaltung? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Veranstaltung
    extends graphql.WatchQueryOptions<Query_Veranstaltung> {
  WatchOptions_Query_Veranstaltung({
    String? operationName,
    required Variables_Query_Veranstaltung variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Veranstaltung? typedOptimisticResult,
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
         document: documentNodeQueryVeranstaltung,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Veranstaltung,
       );
}

class FetchMoreOptions_Query_Veranstaltung extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Veranstaltung({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Veranstaltung variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryVeranstaltung,
       );
}

extension ClientExtension_Query_Veranstaltung on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Veranstaltung>> query_Veranstaltung(
    Options_Query_Veranstaltung options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Veranstaltung> watchQuery_Veranstaltung(
    WatchOptions_Query_Veranstaltung options,
  ) => this.watchQuery(options);

  void writeQuery_Veranstaltung({
    required Query_Veranstaltung data,
    required Variables_Query_Veranstaltung variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryVeranstaltung),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Veranstaltung? readQuery_Veranstaltung({
    required Variables_Query_Veranstaltung variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryVeranstaltung),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Veranstaltung.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Veranstaltung> useQuery_Veranstaltung(
  Options_Query_Veranstaltung options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Veranstaltung> useWatchQuery_Veranstaltung(
  WatchOptions_Query_Veranstaltung options,
) => graphql_flutter.useWatchQuery(options);

class Query_Veranstaltung_Widget
    extends graphql_flutter.Query<Query_Veranstaltung> {
  Query_Veranstaltung_Widget({
    widgets.Key? key,
    required Options_Query_Veranstaltung options,
    required graphql_flutter.QueryBuilder<Query_Veranstaltung> builder,
  }) : super(key: key, options: options, builder: builder);
}
