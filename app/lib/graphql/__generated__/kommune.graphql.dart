import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_KommuneCrypto {
  Fragment_KommuneCrypto({this.publicKey, this.$__typename = 'Kommune'});

  factory Fragment_KommuneCrypto.fromJson(Map<String, dynamic> json) {
    final l$publicKey = json['publicKey'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneCrypto(
      publicKey: (l$publicKey as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? publicKey;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$publicKey = publicKey;
    _resultData['publicKey'] = l$publicKey;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$publicKey = publicKey;
    final l$$__typename = $__typename;
    return Object.hashAll([l$publicKey, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneCrypto || runtimeType != other.runtimeType) {
      return false;
    }
    final l$publicKey = publicKey;
    final lOther$publicKey = other.publicKey;
    if (l$publicKey != lOther$publicKey) {
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

extension UtilityExtension_Fragment_KommuneCrypto on Fragment_KommuneCrypto {
  CopyWith_Fragment_KommuneCrypto<Fragment_KommuneCrypto> get copyWith =>
      CopyWith_Fragment_KommuneCrypto(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneCrypto<TRes> {
  factory CopyWith_Fragment_KommuneCrypto(
    Fragment_KommuneCrypto instance,
    TRes Function(Fragment_KommuneCrypto) then,
  ) = _CopyWithImpl_Fragment_KommuneCrypto;

  factory CopyWith_Fragment_KommuneCrypto.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneCrypto;

  TRes call({String? publicKey, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneCrypto<TRes>
    implements CopyWith_Fragment_KommuneCrypto<TRes> {
  _CopyWithImpl_Fragment_KommuneCrypto(this._instance, this._then);

  final Fragment_KommuneCrypto _instance;

  final TRes Function(Fragment_KommuneCrypto) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? publicKey = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneCrypto(
      publicKey: publicKey == _undefined
          ? _instance.publicKey
          : (publicKey as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneCrypto<TRes>
    implements CopyWith_Fragment_KommuneCrypto<TRes> {
  _CopyWithStubImpl_Fragment_KommuneCrypto(this._res);

  TRes _res;

  call({String? publicKey, String? $__typename}) => _res;
}

const fragmentDefinitionKommuneCrypto = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneCrypto'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Kommune'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'publicKey'),
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
const documentNodeFragmentKommuneCrypto = DocumentNode(
  definitions: [fragmentDefinitionKommuneCrypto],
);

extension ClientExtension_Fragment_KommuneCrypto on graphql.GraphQLClient {
  void writeFragment_KommuneCrypto({
    required Fragment_KommuneCrypto data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneCrypto',
        document: documentNodeFragmentKommuneCrypto,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneCrypto? readFragment_KommuneCrypto({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneCrypto',
          document: documentNodeFragmentKommuneCrypto,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_KommuneCrypto.fromJson(result);
  }
}

class Fragment_Kommune {
  Fragment_Kommune({
    required this.bereichAId,
    required this.bereichBId,
    required this.name,
    this.design,
    required this.analytics,
    required this.rechtsTexte,
    required this.defaultPosition,
    required this.abfallkalenderEnabled,
    this.$__typename = 'Kommune',
  });

  factory Fragment_Kommune.fromJson(Map<String, dynamic> json) {
    final l$bereichAId = json['bereichAId'];
    final l$bereichBId = json['bereichBId'];
    final l$name = json['name'];
    final l$design = json['design'];
    final l$analytics = json['analytics'];
    final l$rechtsTexte = json['rechtsTexte'];
    final l$defaultPosition = json['defaultPosition'];
    final l$abfallkalenderEnabled = json['abfallkalenderEnabled'];
    final l$$__typename = json['__typename'];
    return Fragment_Kommune(
      bereichAId: (l$bereichAId as String),
      bereichBId: (l$bereichBId as String),
      name: (l$name as String),
      design: l$design == null
          ? null
          : Fragment_KommuneDesign.fromJson((l$design as Map<String, dynamic>)),
      analytics: Fragment_KommuneAnalytics.fromJson(
        (l$analytics as Map<String, dynamic>),
      ),
      rechtsTexte: Fragment_KommuneRechtstexte.fromJson(
        (l$rechtsTexte as Map<String, dynamic>),
      ),
      defaultPosition: (l$defaultPosition as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
      abfallkalenderEnabled: (l$abfallkalenderEnabled as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String bereichAId;

  final String bereichBId;

  final String name;

  final Fragment_KommuneDesign? design;

  final Fragment_KommuneAnalytics analytics;

  final Fragment_KommuneRechtstexte rechtsTexte;

  final List<double?> defaultPosition;

  final bool abfallkalenderEnabled;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$bereichAId = bereichAId;
    _resultData['bereichAId'] = l$bereichAId;
    final l$bereichBId = bereichBId;
    _resultData['bereichBId'] = l$bereichBId;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$design = design;
    _resultData['design'] = l$design?.toJson();
    final l$analytics = analytics;
    _resultData['analytics'] = l$analytics.toJson();
    final l$rechtsTexte = rechtsTexte;
    _resultData['rechtsTexte'] = l$rechtsTexte.toJson();
    final l$defaultPosition = defaultPosition;
    _resultData['defaultPosition'] = l$defaultPosition.map((e) => e).toList();
    final l$abfallkalenderEnabled = abfallkalenderEnabled;
    _resultData['abfallkalenderEnabled'] = l$abfallkalenderEnabled;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$bereichAId = bereichAId;
    final l$bereichBId = bereichBId;
    final l$name = name;
    final l$design = design;
    final l$analytics = analytics;
    final l$rechtsTexte = rechtsTexte;
    final l$defaultPosition = defaultPosition;
    final l$abfallkalenderEnabled = abfallkalenderEnabled;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$bereichAId,
      l$bereichBId,
      l$name,
      l$design,
      l$analytics,
      l$rechtsTexte,
      Object.hashAll(l$defaultPosition.map((v) => v)),
      l$abfallkalenderEnabled,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_Kommune || runtimeType != other.runtimeType) {
      return false;
    }
    final l$bereichAId = bereichAId;
    final lOther$bereichAId = other.bereichAId;
    if (l$bereichAId != lOther$bereichAId) {
      return false;
    }
    final l$bereichBId = bereichBId;
    final lOther$bereichBId = other.bereichBId;
    if (l$bereichBId != lOther$bereichBId) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$design = design;
    final lOther$design = other.design;
    if (l$design != lOther$design) {
      return false;
    }
    final l$analytics = analytics;
    final lOther$analytics = other.analytics;
    if (l$analytics != lOther$analytics) {
      return false;
    }
    final l$rechtsTexte = rechtsTexte;
    final lOther$rechtsTexte = other.rechtsTexte;
    if (l$rechtsTexte != lOther$rechtsTexte) {
      return false;
    }
    final l$defaultPosition = defaultPosition;
    final lOther$defaultPosition = other.defaultPosition;
    if (l$defaultPosition.length != lOther$defaultPosition.length) {
      return false;
    }
    for (int i = 0; i < l$defaultPosition.length; i++) {
      final l$defaultPosition$entry = l$defaultPosition[i];
      final lOther$defaultPosition$entry = lOther$defaultPosition[i];
      if (l$defaultPosition$entry != lOther$defaultPosition$entry) {
        return false;
      }
    }
    final l$abfallkalenderEnabled = abfallkalenderEnabled;
    final lOther$abfallkalenderEnabled = other.abfallkalenderEnabled;
    if (l$abfallkalenderEnabled != lOther$abfallkalenderEnabled) {
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

extension UtilityExtension_Fragment_Kommune on Fragment_Kommune {
  CopyWith_Fragment_Kommune<Fragment_Kommune> get copyWith =>
      CopyWith_Fragment_Kommune(this, (i) => i);
}

abstract class CopyWith_Fragment_Kommune<TRes> {
  factory CopyWith_Fragment_Kommune(
    Fragment_Kommune instance,
    TRes Function(Fragment_Kommune) then,
  ) = _CopyWithImpl_Fragment_Kommune;

  factory CopyWith_Fragment_Kommune.stub(TRes res) =
      _CopyWithStubImpl_Fragment_Kommune;

  TRes call({
    String? bereichAId,
    String? bereichBId,
    String? name,
    Fragment_KommuneDesign? design,
    Fragment_KommuneAnalytics? analytics,
    Fragment_KommuneRechtstexte? rechtsTexte,
    List<double?>? defaultPosition,
    bool? abfallkalenderEnabled,
    String? $__typename,
  });
  CopyWith_Fragment_KommuneDesign<TRes> get design;
  CopyWith_Fragment_KommuneAnalytics<TRes> get analytics;
  CopyWith_Fragment_KommuneRechtstexte<TRes> get rechtsTexte;
}

class _CopyWithImpl_Fragment_Kommune<TRes>
    implements CopyWith_Fragment_Kommune<TRes> {
  _CopyWithImpl_Fragment_Kommune(this._instance, this._then);

  final Fragment_Kommune _instance;

  final TRes Function(Fragment_Kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? bereichAId = _undefined,
    Object? bereichBId = _undefined,
    Object? name = _undefined,
    Object? design = _undefined,
    Object? analytics = _undefined,
    Object? rechtsTexte = _undefined,
    Object? defaultPosition = _undefined,
    Object? abfallkalenderEnabled = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_Kommune(
      bereichAId: bereichAId == _undefined || bereichAId == null
          ? _instance.bereichAId
          : (bereichAId as String),
      bereichBId: bereichBId == _undefined || bereichBId == null
          ? _instance.bereichBId
          : (bereichBId as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      design: design == _undefined
          ? _instance.design
          : (design as Fragment_KommuneDesign?),
      analytics: analytics == _undefined || analytics == null
          ? _instance.analytics
          : (analytics as Fragment_KommuneAnalytics),
      rechtsTexte: rechtsTexte == _undefined || rechtsTexte == null
          ? _instance.rechtsTexte
          : (rechtsTexte as Fragment_KommuneRechtstexte),
      defaultPosition: defaultPosition == _undefined || defaultPosition == null
          ? _instance.defaultPosition
          : (defaultPosition as List<double?>),
      abfallkalenderEnabled:
          abfallkalenderEnabled == _undefined || abfallkalenderEnabled == null
          ? _instance.abfallkalenderEnabled
          : (abfallkalenderEnabled as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_KommuneDesign<TRes> get design {
    final local$design = _instance.design;
    return local$design == null
        ? CopyWith_Fragment_KommuneDesign.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesign(local$design, (e) => call(design: e));
  }

  CopyWith_Fragment_KommuneAnalytics<TRes> get analytics {
    final local$analytics = _instance.analytics;
    return CopyWith_Fragment_KommuneAnalytics(
      local$analytics,
      (e) => call(analytics: e),
    );
  }

  CopyWith_Fragment_KommuneRechtstexte<TRes> get rechtsTexte {
    final local$rechtsTexte = _instance.rechtsTexte;
    return CopyWith_Fragment_KommuneRechtstexte(
      local$rechtsTexte,
      (e) => call(rechtsTexte: e),
    );
  }
}

class _CopyWithStubImpl_Fragment_Kommune<TRes>
    implements CopyWith_Fragment_Kommune<TRes> {
  _CopyWithStubImpl_Fragment_Kommune(this._res);

  TRes _res;

  call({
    String? bereichAId,
    String? bereichBId,
    String? name,
    Fragment_KommuneDesign? design,
    Fragment_KommuneAnalytics? analytics,
    Fragment_KommuneRechtstexte? rechtsTexte,
    List<double?>? defaultPosition,
    bool? abfallkalenderEnabled,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_KommuneDesign<TRes> get design =>
      CopyWith_Fragment_KommuneDesign.stub(_res);

  CopyWith_Fragment_KommuneAnalytics<TRes> get analytics =>
      CopyWith_Fragment_KommuneAnalytics.stub(_res);

  CopyWith_Fragment_KommuneRechtstexte<TRes> get rechtsTexte =>
      CopyWith_Fragment_KommuneRechtstexte.stub(_res);
}

const fragmentDefinitionKommune = FragmentDefinitionNode(
  name: NameNode(value: 'Kommune'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Kommune'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'id'),
        alias: NameNode(value: 'bereichAId'),
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'bereichBId'),
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
        name: NameNode(value: 'design'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'KommuneDesign'),
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
        name: NameNode(value: 'analytics'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'KommuneAnalytics'),
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
        name: NameNode(value: 'rechtsTexte'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'KommuneRechtstexte'),
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
        name: NameNode(value: 'defaultPosition'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'abfallkalenderEnabled'),
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
const documentNodeFragmentKommune = DocumentNode(
  definitions: [
    fragmentDefinitionKommune,
    fragmentDefinitionKommuneDesign,
    fragmentDefinitionKommuneDesignColors,
    fragmentDefinitionKommuneDesignFonts,
    fragmentDefinitionKommuneAnalytics,
    fragmentDefinitionKommuneRechtstexte,
  ],
);

extension ClientExtension_Fragment_Kommune on graphql.GraphQLClient {
  void writeFragment_Kommune({
    required Fragment_Kommune data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'Kommune',
        document: documentNodeFragmentKommune,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_Kommune? readFragment_Kommune({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'Kommune',
          document: documentNodeFragmentKommune,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_Kommune.fromJson(result);
  }
}

class Fragment_KommuneDesign {
  Fragment_KommuneDesign({
    this.logo,
    this.mangelIcon,
    this.ideenIcon,
    this.fallbackImage,
    this.colors,
    this.fonts,
    this.$__typename = 'KommuneDesign',
  });

  factory Fragment_KommuneDesign.fromJson(Map<String, dynamic> json) {
    final l$logo = json['logo'];
    final l$mangelIcon = json['mangelIcon'];
    final l$ideenIcon = json['ideenIcon'];
    final l$fallbackImage = json['fallbackImage'];
    final l$colors = json['colors'];
    final l$fonts = json['fonts'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesign(
      logo: l$logo == null
          ? null
          : Fragment_KommuneDesign_logo.fromJson(
              (l$logo as Map<String, dynamic>),
            ),
      mangelIcon: l$mangelIcon == null
          ? null
          : Fragment_KommuneDesign_mangelIcon.fromJson(
              (l$mangelIcon as Map<String, dynamic>),
            ),
      ideenIcon: l$ideenIcon == null
          ? null
          : Fragment_KommuneDesign_ideenIcon.fromJson(
              (l$ideenIcon as Map<String, dynamic>),
            ),
      fallbackImage: l$fallbackImage == null
          ? null
          : Fragment_KommuneDesign_fallbackImage.fromJson(
              (l$fallbackImage as Map<String, dynamic>),
            ),
      colors: l$colors == null
          ? null
          : Fragment_KommuneDesignColors.fromJson(
              (l$colors as Map<String, dynamic>),
            ),
      fonts: l$fonts == null
          ? null
          : Fragment_KommuneDesignFonts.fromJson(
              (l$fonts as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_KommuneDesign_logo? logo;

  final Fragment_KommuneDesign_mangelIcon? mangelIcon;

  final Fragment_KommuneDesign_ideenIcon? ideenIcon;

  final Fragment_KommuneDesign_fallbackImage? fallbackImage;

  final Fragment_KommuneDesignColors? colors;

  final Fragment_KommuneDesignFonts? fonts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$logo = logo;
    _resultData['logo'] = l$logo?.toJson();
    final l$mangelIcon = mangelIcon;
    _resultData['mangelIcon'] = l$mangelIcon?.toJson();
    final l$ideenIcon = ideenIcon;
    _resultData['ideenIcon'] = l$ideenIcon?.toJson();
    final l$fallbackImage = fallbackImage;
    _resultData['fallbackImage'] = l$fallbackImage?.toJson();
    final l$colors = colors;
    _resultData['colors'] = l$colors?.toJson();
    final l$fonts = fonts;
    _resultData['fonts'] = l$fonts?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$logo = logo;
    final l$mangelIcon = mangelIcon;
    final l$ideenIcon = ideenIcon;
    final l$fallbackImage = fallbackImage;
    final l$colors = colors;
    final l$fonts = fonts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$logo,
      l$mangelIcon,
      l$ideenIcon,
      l$fallbackImage,
      l$colors,
      l$fonts,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneDesign || runtimeType != other.runtimeType) {
      return false;
    }
    final l$logo = logo;
    final lOther$logo = other.logo;
    if (l$logo != lOther$logo) {
      return false;
    }
    final l$mangelIcon = mangelIcon;
    final lOther$mangelIcon = other.mangelIcon;
    if (l$mangelIcon != lOther$mangelIcon) {
      return false;
    }
    final l$ideenIcon = ideenIcon;
    final lOther$ideenIcon = other.ideenIcon;
    if (l$ideenIcon != lOther$ideenIcon) {
      return false;
    }
    final l$fallbackImage = fallbackImage;
    final lOther$fallbackImage = other.fallbackImage;
    if (l$fallbackImage != lOther$fallbackImage) {
      return false;
    }
    final l$colors = colors;
    final lOther$colors = other.colors;
    if (l$colors != lOther$colors) {
      return false;
    }
    final l$fonts = fonts;
    final lOther$fonts = other.fonts;
    if (l$fonts != lOther$fonts) {
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

extension UtilityExtension_Fragment_KommuneDesign on Fragment_KommuneDesign {
  CopyWith_Fragment_KommuneDesign<Fragment_KommuneDesign> get copyWith =>
      CopyWith_Fragment_KommuneDesign(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesign<TRes> {
  factory CopyWith_Fragment_KommuneDesign(
    Fragment_KommuneDesign instance,
    TRes Function(Fragment_KommuneDesign) then,
  ) = _CopyWithImpl_Fragment_KommuneDesign;

  factory CopyWith_Fragment_KommuneDesign.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesign;

  TRes call({
    Fragment_KommuneDesign_logo? logo,
    Fragment_KommuneDesign_mangelIcon? mangelIcon,
    Fragment_KommuneDesign_ideenIcon? ideenIcon,
    Fragment_KommuneDesign_fallbackImage? fallbackImage,
    Fragment_KommuneDesignColors? colors,
    Fragment_KommuneDesignFonts? fonts,
    String? $__typename,
  });
  CopyWith_Fragment_KommuneDesign_logo<TRes> get logo;
  CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> get mangelIcon;
  CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> get ideenIcon;
  CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> get fallbackImage;
  CopyWith_Fragment_KommuneDesignColors<TRes> get colors;
  CopyWith_Fragment_KommuneDesignFonts<TRes> get fonts;
}

class _CopyWithImpl_Fragment_KommuneDesign<TRes>
    implements CopyWith_Fragment_KommuneDesign<TRes> {
  _CopyWithImpl_Fragment_KommuneDesign(this._instance, this._then);

  final Fragment_KommuneDesign _instance;

  final TRes Function(Fragment_KommuneDesign) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? logo = _undefined,
    Object? mangelIcon = _undefined,
    Object? ideenIcon = _undefined,
    Object? fallbackImage = _undefined,
    Object? colors = _undefined,
    Object? fonts = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneDesign(
      logo: logo == _undefined
          ? _instance.logo
          : (logo as Fragment_KommuneDesign_logo?),
      mangelIcon: mangelIcon == _undefined
          ? _instance.mangelIcon
          : (mangelIcon as Fragment_KommuneDesign_mangelIcon?),
      ideenIcon: ideenIcon == _undefined
          ? _instance.ideenIcon
          : (ideenIcon as Fragment_KommuneDesign_ideenIcon?),
      fallbackImage: fallbackImage == _undefined
          ? _instance.fallbackImage
          : (fallbackImage as Fragment_KommuneDesign_fallbackImage?),
      colors: colors == _undefined
          ? _instance.colors
          : (colors as Fragment_KommuneDesignColors?),
      fonts: fonts == _undefined
          ? _instance.fonts
          : (fonts as Fragment_KommuneDesignFonts?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_KommuneDesign_logo<TRes> get logo {
    final local$logo = _instance.logo;
    return local$logo == null
        ? CopyWith_Fragment_KommuneDesign_logo.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesign_logo(
            local$logo,
            (e) => call(logo: e),
          );
  }

  CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> get mangelIcon {
    final local$mangelIcon = _instance.mangelIcon;
    return local$mangelIcon == null
        ? CopyWith_Fragment_KommuneDesign_mangelIcon.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesign_mangelIcon(
            local$mangelIcon,
            (e) => call(mangelIcon: e),
          );
  }

  CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> get ideenIcon {
    final local$ideenIcon = _instance.ideenIcon;
    return local$ideenIcon == null
        ? CopyWith_Fragment_KommuneDesign_ideenIcon.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesign_ideenIcon(
            local$ideenIcon,
            (e) => call(ideenIcon: e),
          );
  }

  CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> get fallbackImage {
    final local$fallbackImage = _instance.fallbackImage;
    return local$fallbackImage == null
        ? CopyWith_Fragment_KommuneDesign_fallbackImage.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesign_fallbackImage(
            local$fallbackImage,
            (e) => call(fallbackImage: e),
          );
  }

  CopyWith_Fragment_KommuneDesignColors<TRes> get colors {
    final local$colors = _instance.colors;
    return local$colors == null
        ? CopyWith_Fragment_KommuneDesignColors.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesignColors(
            local$colors,
            (e) => call(colors: e),
          );
  }

  CopyWith_Fragment_KommuneDesignFonts<TRes> get fonts {
    final local$fonts = _instance.fonts;
    return local$fonts == null
        ? CopyWith_Fragment_KommuneDesignFonts.stub(_then(_instance))
        : CopyWith_Fragment_KommuneDesignFonts(
            local$fonts,
            (e) => call(fonts: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_KommuneDesign<TRes>
    implements CopyWith_Fragment_KommuneDesign<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesign(this._res);

  TRes _res;

  call({
    Fragment_KommuneDesign_logo? logo,
    Fragment_KommuneDesign_mangelIcon? mangelIcon,
    Fragment_KommuneDesign_ideenIcon? ideenIcon,
    Fragment_KommuneDesign_fallbackImage? fallbackImage,
    Fragment_KommuneDesignColors? colors,
    Fragment_KommuneDesignFonts? fonts,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_KommuneDesign_logo<TRes> get logo =>
      CopyWith_Fragment_KommuneDesign_logo.stub(_res);

  CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> get mangelIcon =>
      CopyWith_Fragment_KommuneDesign_mangelIcon.stub(_res);

  CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> get ideenIcon =>
      CopyWith_Fragment_KommuneDesign_ideenIcon.stub(_res);

  CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> get fallbackImage =>
      CopyWith_Fragment_KommuneDesign_fallbackImage.stub(_res);

  CopyWith_Fragment_KommuneDesignColors<TRes> get colors =>
      CopyWith_Fragment_KommuneDesignColors.stub(_res);

  CopyWith_Fragment_KommuneDesignFonts<TRes> get fonts =>
      CopyWith_Fragment_KommuneDesignFonts.stub(_res);
}

const fragmentDefinitionKommuneDesign = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneDesign'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'KommuneDesign'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'logo'),
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
        name: NameNode(value: 'mangelIcon'),
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
        name: NameNode(value: 'ideenIcon'),
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
        name: NameNode(value: 'fallbackImage'),
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
        name: NameNode(value: 'colors'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'KommuneDesignColors'),
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
        name: NameNode(value: 'fonts'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'KommuneDesignFonts'),
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
const documentNodeFragmentKommuneDesign = DocumentNode(
  definitions: [
    fragmentDefinitionKommuneDesign,
    fragmentDefinitionKommuneDesignColors,
    fragmentDefinitionKommuneDesignFonts,
  ],
);

extension ClientExtension_Fragment_KommuneDesign on graphql.GraphQLClient {
  void writeFragment_KommuneDesign({
    required Fragment_KommuneDesign data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneDesign',
        document: documentNodeFragmentKommuneDesign,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneDesign? readFragment_KommuneDesign({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneDesign',
          document: documentNodeFragmentKommuneDesign,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_KommuneDesign.fromJson(result);
  }
}

class Fragment_KommuneDesign_logo {
  Fragment_KommuneDesign_logo({this.url, this.$__typename = 'Medien'});

  factory Fragment_KommuneDesign_logo.fromJson(Map<String, dynamic> json) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesign_logo(
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
    if (other is! Fragment_KommuneDesign_logo ||
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

extension UtilityExtension_Fragment_KommuneDesign_logo
    on Fragment_KommuneDesign_logo {
  CopyWith_Fragment_KommuneDesign_logo<Fragment_KommuneDesign_logo>
  get copyWith => CopyWith_Fragment_KommuneDesign_logo(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesign_logo<TRes> {
  factory CopyWith_Fragment_KommuneDesign_logo(
    Fragment_KommuneDesign_logo instance,
    TRes Function(Fragment_KommuneDesign_logo) then,
  ) = _CopyWithImpl_Fragment_KommuneDesign_logo;

  factory CopyWith_Fragment_KommuneDesign_logo.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesign_logo;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneDesign_logo<TRes>
    implements CopyWith_Fragment_KommuneDesign_logo<TRes> {
  _CopyWithImpl_Fragment_KommuneDesign_logo(this._instance, this._then);

  final Fragment_KommuneDesign_logo _instance;

  final TRes Function(Fragment_KommuneDesign_logo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_KommuneDesign_logo(
          url: url == _undefined ? _instance.url : (url as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_KommuneDesign_logo<TRes>
    implements CopyWith_Fragment_KommuneDesign_logo<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesign_logo(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Fragment_KommuneDesign_mangelIcon {
  Fragment_KommuneDesign_mangelIcon({
    required this.id,
    this.url,
    this.$__typename = 'Medien',
  });

  factory Fragment_KommuneDesign_mangelIcon.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesign_mangelIcon(
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
    if (other is! Fragment_KommuneDesign_mangelIcon ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_KommuneDesign_mangelIcon
    on Fragment_KommuneDesign_mangelIcon {
  CopyWith_Fragment_KommuneDesign_mangelIcon<Fragment_KommuneDesign_mangelIcon>
  get copyWith => CopyWith_Fragment_KommuneDesign_mangelIcon(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> {
  factory CopyWith_Fragment_KommuneDesign_mangelIcon(
    Fragment_KommuneDesign_mangelIcon instance,
    TRes Function(Fragment_KommuneDesign_mangelIcon) then,
  ) = _CopyWithImpl_Fragment_KommuneDesign_mangelIcon;

  factory CopyWith_Fragment_KommuneDesign_mangelIcon.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesign_mangelIcon;

  TRes call({String? id, String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneDesign_mangelIcon<TRes>
    implements CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> {
  _CopyWithImpl_Fragment_KommuneDesign_mangelIcon(this._instance, this._then);

  final Fragment_KommuneDesign_mangelIcon _instance;

  final TRes Function(Fragment_KommuneDesign_mangelIcon) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneDesign_mangelIcon(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneDesign_mangelIcon<TRes>
    implements CopyWith_Fragment_KommuneDesign_mangelIcon<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesign_mangelIcon(this._res);

  TRes _res;

  call({String? id, String? url, String? $__typename}) => _res;
}

class Fragment_KommuneDesign_ideenIcon {
  Fragment_KommuneDesign_ideenIcon({
    required this.id,
    this.url,
    this.$__typename = 'Medien',
  });

  factory Fragment_KommuneDesign_ideenIcon.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesign_ideenIcon(
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
    if (other is! Fragment_KommuneDesign_ideenIcon ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_KommuneDesign_ideenIcon
    on Fragment_KommuneDesign_ideenIcon {
  CopyWith_Fragment_KommuneDesign_ideenIcon<Fragment_KommuneDesign_ideenIcon>
  get copyWith => CopyWith_Fragment_KommuneDesign_ideenIcon(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> {
  factory CopyWith_Fragment_KommuneDesign_ideenIcon(
    Fragment_KommuneDesign_ideenIcon instance,
    TRes Function(Fragment_KommuneDesign_ideenIcon) then,
  ) = _CopyWithImpl_Fragment_KommuneDesign_ideenIcon;

  factory CopyWith_Fragment_KommuneDesign_ideenIcon.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesign_ideenIcon;

  TRes call({String? id, String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneDesign_ideenIcon<TRes>
    implements CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> {
  _CopyWithImpl_Fragment_KommuneDesign_ideenIcon(this._instance, this._then);

  final Fragment_KommuneDesign_ideenIcon _instance;

  final TRes Function(Fragment_KommuneDesign_ideenIcon) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneDesign_ideenIcon(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneDesign_ideenIcon<TRes>
    implements CopyWith_Fragment_KommuneDesign_ideenIcon<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesign_ideenIcon(this._res);

  TRes _res;

  call({String? id, String? url, String? $__typename}) => _res;
}

class Fragment_KommuneDesign_fallbackImage {
  Fragment_KommuneDesign_fallbackImage({this.url, this.$__typename = 'Medien'});

  factory Fragment_KommuneDesign_fallbackImage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesign_fallbackImage(
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
    if (other is! Fragment_KommuneDesign_fallbackImage ||
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

extension UtilityExtension_Fragment_KommuneDesign_fallbackImage
    on Fragment_KommuneDesign_fallbackImage {
  CopyWith_Fragment_KommuneDesign_fallbackImage<
    Fragment_KommuneDesign_fallbackImage
  >
  get copyWith => CopyWith_Fragment_KommuneDesign_fallbackImage(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> {
  factory CopyWith_Fragment_KommuneDesign_fallbackImage(
    Fragment_KommuneDesign_fallbackImage instance,
    TRes Function(Fragment_KommuneDesign_fallbackImage) then,
  ) = _CopyWithImpl_Fragment_KommuneDesign_fallbackImage;

  factory CopyWith_Fragment_KommuneDesign_fallbackImage.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesign_fallbackImage;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneDesign_fallbackImage<TRes>
    implements CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> {
  _CopyWithImpl_Fragment_KommuneDesign_fallbackImage(
    this._instance,
    this._then,
  );

  final Fragment_KommuneDesign_fallbackImage _instance;

  final TRes Function(Fragment_KommuneDesign_fallbackImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_KommuneDesign_fallbackImage(
          url: url == _undefined ? _instance.url : (url as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_KommuneDesign_fallbackImage<TRes>
    implements CopyWith_Fragment_KommuneDesign_fallbackImage<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesign_fallbackImage(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Fragment_KommuneDesignColors {
  Fragment_KommuneDesignColors({
    this.primary,
    this.primaryLight,
    this.$__typename = 'KommuneDesignColors',
  });

  factory Fragment_KommuneDesignColors.fromJson(Map<String, dynamic> json) {
    final l$primary = json['primary'];
    final l$primaryLight = json['primaryLight'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesignColors(
      primary: (l$primary as String?),
      primaryLight: (l$primaryLight as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? primary;

  final String? primaryLight;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$primary = primary;
    _resultData['primary'] = l$primary;
    final l$primaryLight = primaryLight;
    _resultData['primaryLight'] = l$primaryLight;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$primary = primary;
    final l$primaryLight = primaryLight;
    final l$$__typename = $__typename;
    return Object.hashAll([l$primary, l$primaryLight, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneDesignColors ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$primary = primary;
    final lOther$primary = other.primary;
    if (l$primary != lOther$primary) {
      return false;
    }
    final l$primaryLight = primaryLight;
    final lOther$primaryLight = other.primaryLight;
    if (l$primaryLight != lOther$primaryLight) {
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

extension UtilityExtension_Fragment_KommuneDesignColors
    on Fragment_KommuneDesignColors {
  CopyWith_Fragment_KommuneDesignColors<Fragment_KommuneDesignColors>
  get copyWith => CopyWith_Fragment_KommuneDesignColors(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesignColors<TRes> {
  factory CopyWith_Fragment_KommuneDesignColors(
    Fragment_KommuneDesignColors instance,
    TRes Function(Fragment_KommuneDesignColors) then,
  ) = _CopyWithImpl_Fragment_KommuneDesignColors;

  factory CopyWith_Fragment_KommuneDesignColors.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesignColors;

  TRes call({String? primary, String? primaryLight, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneDesignColors<TRes>
    implements CopyWith_Fragment_KommuneDesignColors<TRes> {
  _CopyWithImpl_Fragment_KommuneDesignColors(this._instance, this._then);

  final Fragment_KommuneDesignColors _instance;

  final TRes Function(Fragment_KommuneDesignColors) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? primary = _undefined,
    Object? primaryLight = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneDesignColors(
      primary: primary == _undefined ? _instance.primary : (primary as String?),
      primaryLight: primaryLight == _undefined
          ? _instance.primaryLight
          : (primaryLight as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneDesignColors<TRes>
    implements CopyWith_Fragment_KommuneDesignColors<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesignColors(this._res);

  TRes _res;

  call({String? primary, String? primaryLight, String? $__typename}) => _res;
}

const fragmentDefinitionKommuneDesignColors = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneDesignColors'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'KommuneDesignColors'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'primary'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'primaryLight'),
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
const documentNodeFragmentKommuneDesignColors = DocumentNode(
  definitions: [fragmentDefinitionKommuneDesignColors],
);

extension ClientExtension_Fragment_KommuneDesignColors
    on graphql.GraphQLClient {
  void writeFragment_KommuneDesignColors({
    required Fragment_KommuneDesignColors data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneDesignColors',
        document: documentNodeFragmentKommuneDesignColors,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneDesignColors? readFragment_KommuneDesignColors({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneDesignColors',
          document: documentNodeFragmentKommuneDesignColors,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_KommuneDesignColors.fromJson(result);
  }
}

class Fragment_KommuneDesignFonts {
  Fragment_KommuneDesignFonts({
    this.body,
    this.headings,
    this.$__typename = 'KommuneDesignFonts',
  });

  factory Fragment_KommuneDesignFonts.fromJson(Map<String, dynamic> json) {
    final l$body = json['body'];
    final l$headings = json['headings'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneDesignFonts(
      body: l$body == null
          ? null
          : fromJson_Enum_KommuneDesignFonts_body((l$body as String)),
      headings: l$headings == null
          ? null
          : fromJson_Enum_KommuneDesignFonts_headings((l$headings as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum_KommuneDesignFonts_body? body;

  final Enum_KommuneDesignFonts_headings? headings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$body = body;
    _resultData['body'] = l$body == null
        ? null
        : toJson_Enum_KommuneDesignFonts_body(l$body);
    final l$headings = headings;
    _resultData['headings'] = l$headings == null
        ? null
        : toJson_Enum_KommuneDesignFonts_headings(l$headings);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$body = body;
    final l$headings = headings;
    final l$$__typename = $__typename;
    return Object.hashAll([l$body, l$headings, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneDesignFonts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$body = body;
    final lOther$body = other.body;
    if (l$body != lOther$body) {
      return false;
    }
    final l$headings = headings;
    final lOther$headings = other.headings;
    if (l$headings != lOther$headings) {
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

extension UtilityExtension_Fragment_KommuneDesignFonts
    on Fragment_KommuneDesignFonts {
  CopyWith_Fragment_KommuneDesignFonts<Fragment_KommuneDesignFonts>
  get copyWith => CopyWith_Fragment_KommuneDesignFonts(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneDesignFonts<TRes> {
  factory CopyWith_Fragment_KommuneDesignFonts(
    Fragment_KommuneDesignFonts instance,
    TRes Function(Fragment_KommuneDesignFonts) then,
  ) = _CopyWithImpl_Fragment_KommuneDesignFonts;

  factory CopyWith_Fragment_KommuneDesignFonts.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneDesignFonts;

  TRes call({
    Enum_KommuneDesignFonts_body? body,
    Enum_KommuneDesignFonts_headings? headings,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_KommuneDesignFonts<TRes>
    implements CopyWith_Fragment_KommuneDesignFonts<TRes> {
  _CopyWithImpl_Fragment_KommuneDesignFonts(this._instance, this._then);

  final Fragment_KommuneDesignFonts _instance;

  final TRes Function(Fragment_KommuneDesignFonts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? body = _undefined,
    Object? headings = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneDesignFonts(
      body: body == _undefined
          ? _instance.body
          : (body as Enum_KommuneDesignFonts_body?),
      headings: headings == _undefined
          ? _instance.headings
          : (headings as Enum_KommuneDesignFonts_headings?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneDesignFonts<TRes>
    implements CopyWith_Fragment_KommuneDesignFonts<TRes> {
  _CopyWithStubImpl_Fragment_KommuneDesignFonts(this._res);

  TRes _res;

  call({
    Enum_KommuneDesignFonts_body? body,
    Enum_KommuneDesignFonts_headings? headings,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionKommuneDesignFonts = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneDesignFonts'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'KommuneDesignFonts'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'body'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'headings'),
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
const documentNodeFragmentKommuneDesignFonts = DocumentNode(
  definitions: [fragmentDefinitionKommuneDesignFonts],
);

extension ClientExtension_Fragment_KommuneDesignFonts on graphql.GraphQLClient {
  void writeFragment_KommuneDesignFonts({
    required Fragment_KommuneDesignFonts data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneDesignFonts',
        document: documentNodeFragmentKommuneDesignFonts,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneDesignFonts? readFragment_KommuneDesignFonts({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneDesignFonts',
          document: documentNodeFragmentKommuneDesignFonts,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_KommuneDesignFonts.fromJson(result);
  }
}

class Fragment_KommuneAnalytics {
  Fragment_KommuneAnalytics({
    this.siteId,
    this.url,
    this.$__typename = 'BereichBKommune_Analytics',
  });

  factory Fragment_KommuneAnalytics.fromJson(Map<String, dynamic> json) {
    final l$siteId = json['siteId'];
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneAnalytics(
      siteId: (l$siteId as String?),
      url: (l$url as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? siteId;

  final String? url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$siteId = siteId;
    _resultData['siteId'] = l$siteId;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$siteId = siteId;
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$siteId, l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneAnalytics ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$siteId = siteId;
    final lOther$siteId = other.siteId;
    if (l$siteId != lOther$siteId) {
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

extension UtilityExtension_Fragment_KommuneAnalytics
    on Fragment_KommuneAnalytics {
  CopyWith_Fragment_KommuneAnalytics<Fragment_KommuneAnalytics> get copyWith =>
      CopyWith_Fragment_KommuneAnalytics(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneAnalytics<TRes> {
  factory CopyWith_Fragment_KommuneAnalytics(
    Fragment_KommuneAnalytics instance,
    TRes Function(Fragment_KommuneAnalytics) then,
  ) = _CopyWithImpl_Fragment_KommuneAnalytics;

  factory CopyWith_Fragment_KommuneAnalytics.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneAnalytics;

  TRes call({String? siteId, String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneAnalytics<TRes>
    implements CopyWith_Fragment_KommuneAnalytics<TRes> {
  _CopyWithImpl_Fragment_KommuneAnalytics(this._instance, this._then);

  final Fragment_KommuneAnalytics _instance;

  final TRes Function(Fragment_KommuneAnalytics) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? siteId = _undefined,
    Object? url = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneAnalytics(
      siteId: siteId == _undefined ? _instance.siteId : (siteId as String?),
      url: url == _undefined ? _instance.url : (url as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneAnalytics<TRes>
    implements CopyWith_Fragment_KommuneAnalytics<TRes> {
  _CopyWithStubImpl_Fragment_KommuneAnalytics(this._res);

  TRes _res;

  call({String? siteId, String? url, String? $__typename}) => _res;
}

const fragmentDefinitionKommuneAnalytics = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneAnalytics'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'BereichBKommune_Analytics'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'siteId'),
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
const documentNodeFragmentKommuneAnalytics = DocumentNode(
  definitions: [fragmentDefinitionKommuneAnalytics],
);

extension ClientExtension_Fragment_KommuneAnalytics on graphql.GraphQLClient {
  void writeFragment_KommuneAnalytics({
    required Fragment_KommuneAnalytics data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneAnalytics',
        document: documentNodeFragmentKommuneAnalytics,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneAnalytics? readFragment_KommuneAnalytics({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneAnalytics',
          document: documentNodeFragmentKommuneAnalytics,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_KommuneAnalytics.fromJson(result);
  }
}

class Fragment_KommuneRechtstexte {
  Fragment_KommuneRechtstexte({
    this.impressum,
    this.privacy,
    this.$__typename = 'BereichBKommune_Legal',
  });

  factory Fragment_KommuneRechtstexte.fromJson(Map<String, dynamic> json) {
    final l$impressum = json['impressum'];
    final l$privacy = json['privacy'];
    final l$$__typename = json['__typename'];
    return Fragment_KommuneRechtstexte(
      impressum: (l$impressum as String?),
      privacy: (l$privacy as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? impressum;

  final String? privacy;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$impressum = impressum;
    _resultData['impressum'] = l$impressum;
    final l$privacy = privacy;
    _resultData['privacy'] = l$privacy;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$impressum = impressum;
    final l$privacy = privacy;
    final l$$__typename = $__typename;
    return Object.hashAll([l$impressum, l$privacy, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_KommuneRechtstexte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$impressum = impressum;
    final lOther$impressum = other.impressum;
    if (l$impressum != lOther$impressum) {
      return false;
    }
    final l$privacy = privacy;
    final lOther$privacy = other.privacy;
    if (l$privacy != lOther$privacy) {
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

extension UtilityExtension_Fragment_KommuneRechtstexte
    on Fragment_KommuneRechtstexte {
  CopyWith_Fragment_KommuneRechtstexte<Fragment_KommuneRechtstexte>
  get copyWith => CopyWith_Fragment_KommuneRechtstexte(this, (i) => i);
}

abstract class CopyWith_Fragment_KommuneRechtstexte<TRes> {
  factory CopyWith_Fragment_KommuneRechtstexte(
    Fragment_KommuneRechtstexte instance,
    TRes Function(Fragment_KommuneRechtstexte) then,
  ) = _CopyWithImpl_Fragment_KommuneRechtstexte;

  factory CopyWith_Fragment_KommuneRechtstexte.stub(TRes res) =
      _CopyWithStubImpl_Fragment_KommuneRechtstexte;

  TRes call({String? impressum, String? privacy, String? $__typename});
}

class _CopyWithImpl_Fragment_KommuneRechtstexte<TRes>
    implements CopyWith_Fragment_KommuneRechtstexte<TRes> {
  _CopyWithImpl_Fragment_KommuneRechtstexte(this._instance, this._then);

  final Fragment_KommuneRechtstexte _instance;

  final TRes Function(Fragment_KommuneRechtstexte) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? impressum = _undefined,
    Object? privacy = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_KommuneRechtstexte(
      impressum: impressum == _undefined
          ? _instance.impressum
          : (impressum as String?),
      privacy: privacy == _undefined ? _instance.privacy : (privacy as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_KommuneRechtstexte<TRes>
    implements CopyWith_Fragment_KommuneRechtstexte<TRes> {
  _CopyWithStubImpl_Fragment_KommuneRechtstexte(this._res);

  TRes _res;

  call({String? impressum, String? privacy, String? $__typename}) => _res;
}

const fragmentDefinitionKommuneRechtstexte = FragmentDefinitionNode(
  name: NameNode(value: 'KommuneRechtstexte'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'BereichBKommune_Legal'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'impressum'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'privacy'),
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
const documentNodeFragmentKommuneRechtstexte = DocumentNode(
  definitions: [fragmentDefinitionKommuneRechtstexte],
);

extension ClientExtension_Fragment_KommuneRechtstexte on graphql.GraphQLClient {
  void writeFragment_KommuneRechtstexte({
    required Fragment_KommuneRechtstexte data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'KommuneRechtstexte',
        document: documentNodeFragmentKommuneRechtstexte,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_KommuneRechtstexte? readFragment_KommuneRechtstexte({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'KommuneRechtstexte',
          document: documentNodeFragmentKommuneRechtstexte,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_KommuneRechtstexte.fromJson(result);
  }
}

class Variables_Query_Kommune {
  factory Variables_Query_Kommune({required String kommuneId}) =>
      Variables_Query_Kommune._({r'kommuneId': kommuneId});

  Variables_Query_Kommune._(this._$data);

  factory Variables_Query_Kommune.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$kommuneId = data['kommuneId'];
    result$data['kommuneId'] = (l$kommuneId as String);
    return Variables_Query_Kommune._(result$data);
  }

  Map<String, dynamic> _$data;

  String get kommuneId => (_$data['kommuneId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$kommuneId = kommuneId;
    result$data['kommuneId'] = l$kommuneId;
    return result$data;
  }

  CopyWith_Variables_Query_Kommune<Variables_Query_Kommune> get copyWith =>
      CopyWith_Variables_Query_Kommune(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_Kommune || runtimeType != other.runtimeType) {
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

abstract class CopyWith_Variables_Query_Kommune<TRes> {
  factory CopyWith_Variables_Query_Kommune(
    Variables_Query_Kommune instance,
    TRes Function(Variables_Query_Kommune) then,
  ) = _CopyWithImpl_Variables_Query_Kommune;

  factory CopyWith_Variables_Query_Kommune.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_Kommune;

  TRes call({String? kommuneId});
}

class _CopyWithImpl_Variables_Query_Kommune<TRes>
    implements CopyWith_Variables_Query_Kommune<TRes> {
  _CopyWithImpl_Variables_Query_Kommune(this._instance, this._then);

  final Variables_Query_Kommune _instance;

  final TRes Function(Variables_Query_Kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommuneId = _undefined}) => _then(
    Variables_Query_Kommune._({
      ..._instance._$data,
      if (kommuneId != _undefined && kommuneId != null)
        'kommuneId': (kommuneId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_Kommune<TRes>
    implements CopyWith_Variables_Query_Kommune<TRes> {
  _CopyWithStubImpl_Variables_Query_Kommune(this._res);

  TRes _res;

  call({String? kommuneId}) => _res;
}

class Query_Kommune {
  Query_Kommune({required this.kommune, this.$__typename = 'Query'});

  factory Query_Kommune.fromJson(Map<String, dynamic> json) {
    final l$kommune = json['kommune'];
    final l$$__typename = json['__typename'];
    return Query_Kommune(
      kommune: Fragment_Kommune.fromJson((l$kommune as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_Kommune kommune;

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
    if (other is! Query_Kommune || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Query_Kommune on Query_Kommune {
  CopyWith_Query_Kommune<Query_Kommune> get copyWith =>
      CopyWith_Query_Kommune(this, (i) => i);
}

abstract class CopyWith_Query_Kommune<TRes> {
  factory CopyWith_Query_Kommune(
    Query_Kommune instance,
    TRes Function(Query_Kommune) then,
  ) = _CopyWithImpl_Query_Kommune;

  factory CopyWith_Query_Kommune.stub(TRes res) =
      _CopyWithStubImpl_Query_Kommune;

  TRes call({Fragment_Kommune? kommune, String? $__typename});
  CopyWith_Fragment_Kommune<TRes> get kommune;
}

class _CopyWithImpl_Query_Kommune<TRes>
    implements CopyWith_Query_Kommune<TRes> {
  _CopyWithImpl_Query_Kommune(this._instance, this._then);

  final Query_Kommune _instance;

  final TRes Function(Query_Kommune) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? kommune = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query_Kommune(
          kommune: kommune == _undefined || kommune == null
              ? _instance.kommune
              : (kommune as Fragment_Kommune),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Fragment_Kommune<TRes> get kommune {
    final local$kommune = _instance.kommune;
    return CopyWith_Fragment_Kommune(local$kommune, (e) => call(kommune: e));
  }
}

class _CopyWithStubImpl_Query_Kommune<TRes>
    implements CopyWith_Query_Kommune<TRes> {
  _CopyWithStubImpl_Query_Kommune(this._res);

  TRes _res;

  call({Fragment_Kommune? kommune, String? $__typename}) => _res;

  CopyWith_Fragment_Kommune<TRes> get kommune =>
      CopyWith_Fragment_Kommune.stub(_res);
}

const documentNodeQueryKommune = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Kommune'),
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
            alias: NameNode(value: 'kommune'),
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'kommuneId'),
                value: VariableNode(name: NameNode(value: 'kommuneId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'Kommune'),
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
    fragmentDefinitionKommune,
    fragmentDefinitionKommuneDesign,
    fragmentDefinitionKommuneDesignColors,
    fragmentDefinitionKommuneDesignFonts,
    fragmentDefinitionKommuneAnalytics,
    fragmentDefinitionKommuneRechtstexte,
  ],
);
Query_Kommune _parserFn_Query_Kommune(Map<String, dynamic> data) =>
    Query_Kommune.fromJson(data);
typedef OnQueryComplete_Query_Kommune =
    FutureOr<void> Function(Map<String, dynamic>?, Query_Kommune?);

class Options_Query_Kommune extends graphql.QueryOptions<Query_Kommune> {
  Options_Query_Kommune({
    String? operationName,
    required Variables_Query_Kommune variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Kommune? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_Kommune? onComplete,
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
                 data == null ? null : _parserFn_Query_Kommune(data),
               ),
         onError: onError,
         document: documentNodeQueryKommune,
         parserFn: _parserFn_Query_Kommune,
       );

  final OnQueryComplete_Query_Kommune? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_Kommune
    extends graphql.WatchQueryOptions<Query_Kommune> {
  WatchOptions_Query_Kommune({
    String? operationName,
    required Variables_Query_Kommune variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_Kommune? typedOptimisticResult,
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
         document: documentNodeQueryKommune,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_Kommune,
       );
}

class FetchMoreOptions_Query_Kommune extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_Kommune({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_Kommune variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryKommune,
       );
}

extension ClientExtension_Query_Kommune on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_Kommune>> query_Kommune(
    Options_Query_Kommune options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_Kommune> watchQuery_Kommune(
    WatchOptions_Query_Kommune options,
  ) => this.watchQuery(options);

  void writeQuery_Kommune({
    required Query_Kommune data,
    required Variables_Query_Kommune variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryKommune),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_Kommune? readQuery_Kommune({
    required Variables_Query_Kommune variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryKommune),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_Kommune.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_Kommune> useQuery_Kommune(
  Options_Query_Kommune options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_Kommune> useWatchQuery_Kommune(
  WatchOptions_Query_Kommune options,
) => graphql_flutter.useWatchQuery(options);

class Query_Kommune_Widget extends graphql_flutter.Query<Query_Kommune> {
  Query_Kommune_Widget({
    widgets.Key? key,
    required Options_Query_Kommune options,
    required graphql_flutter.QueryBuilder<Query_Kommune> builder,
  }) : super(key: key, options: options, builder: builder);
}
