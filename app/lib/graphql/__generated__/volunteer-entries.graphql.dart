import 'dart:async';
import 'package:app/common/util/local_date.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'schema.graphql.dart';

class Fragment_VolunteerEntryData {
  Fragment_VolunteerEntryData({
    required this.id,
    required this.typ,
    required this.title,
    required this.description,
    required this.kategorieId,
    this.estimatedDurationMinutes,
    this.availability,
    required this.tags,
    required this.createdAt,
    required this.status,
    this.imageKey,
    this.owner,
    this.untereinheit,
    this.$__typename = 'EhrenamtsbankEintrag',
  });

  factory Fragment_VolunteerEntryData.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$typ = json['typ'];
    final l$title = json['title'];
    final l$description = json['description'];
    final l$kategorieId = json['kategorieId'];
    final l$estimatedDurationMinutes = json['estimatedDurationMinutes'];
    final l$availability = json['availability'];
    final l$tags = json['tags'];
    final l$createdAt = json['createdAt'];
    final l$status = json['status'];
    final l$imageKey = json['imageKey'];
    final l$owner = json['owner'];
    final l$untereinheit = json['untereinheit'];
    final l$$__typename = json['__typename'];
    return Fragment_VolunteerEntryData(
      id: (l$id as String),
      typ: fromJson_Enum_EhrenamtsbankEintragTyp((l$typ as String)),
      title: (l$title as String),
      description: (l$description as String),
      kategorieId: (l$kategorieId as String),
      estimatedDurationMinutes: (l$estimatedDurationMinutes as int?),
      availability: (l$availability as String?),
      tags: (l$tags as List<dynamic>).map((e) => (e as String)).toList(),
      createdAt: DateTime.parse((l$createdAt as String)),
      status: fromJson_Enum_EhrenamtsbankEintragStatus((l$status as String)),
      imageKey: (l$imageKey as String?),
      owner: l$owner == null
          ? null
          : Fragment_VolunteerEntryData_owner.fromJson(
              (l$owner as Map<String, dynamic>),
            ),
      untereinheit: l$untereinheit == null
          ? null
          : Fragment_VolunteerEntryData_untereinheit.fromJson(
              (l$untereinheit as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankEintragTyp typ;

  final String title;

  final String description;

  final String kategorieId;

  final int? estimatedDurationMinutes;

  final String? availability;

  final List<String> tags;

  final DateTime createdAt;

  final Enum_EhrenamtsbankEintragStatus status;

  final String? imageKey;

  final Fragment_VolunteerEntryData_owner? owner;

  final Fragment_VolunteerEntryData_untereinheit? untereinheit;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$typ = typ;
    _resultData['typ'] = toJson_Enum_EhrenamtsbankEintragTyp(l$typ);
    final l$title = title;
    _resultData['title'] = l$title;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$kategorieId = kategorieId;
    _resultData['kategorieId'] = l$kategorieId;
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    _resultData['estimatedDurationMinutes'] = l$estimatedDurationMinutes;
    final l$availability = availability;
    _resultData['availability'] = l$availability;
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e).toList();
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankEintragStatus(l$status);
    final l$imageKey = imageKey;
    _resultData['imageKey'] = l$imageKey;
    final l$owner = owner;
    _resultData['owner'] = l$owner?.toJson();
    final l$untereinheit = untereinheit;
    _resultData['untereinheit'] = l$untereinheit?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$typ = typ;
    final l$title = title;
    final l$description = description;
    final l$kategorieId = kategorieId;
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    final l$availability = availability;
    final l$tags = tags;
    final l$createdAt = createdAt;
    final l$status = status;
    final l$imageKey = imageKey;
    final l$owner = owner;
    final l$untereinheit = untereinheit;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$typ,
      l$title,
      l$description,
      l$kategorieId,
      l$estimatedDurationMinutes,
      l$availability,
      Object.hashAll(l$tags.map((v) => v)),
      l$createdAt,
      l$status,
      l$imageKey,
      l$owner,
      l$untereinheit,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VolunteerEntryData ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$typ = typ;
    final lOther$typ = other.typ;
    if (l$typ != lOther$typ) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$kategorieId = kategorieId;
    final lOther$kategorieId = other.kategorieId;
    if (l$kategorieId != lOther$kategorieId) {
      return false;
    }
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    final lOther$estimatedDurationMinutes = other.estimatedDurationMinutes;
    if (l$estimatedDurationMinutes != lOther$estimatedDurationMinutes) {
      return false;
    }
    final l$availability = availability;
    final lOther$availability = other.availability;
    if (l$availability != lOther$availability) {
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
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$imageKey = imageKey;
    final lOther$imageKey = other.imageKey;
    if (l$imageKey != lOther$imageKey) {
      return false;
    }
    final l$owner = owner;
    final lOther$owner = other.owner;
    if (l$owner != lOther$owner) {
      return false;
    }
    final l$untereinheit = untereinheit;
    final lOther$untereinheit = other.untereinheit;
    if (l$untereinheit != lOther$untereinheit) {
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

extension UtilityExtension_Fragment_VolunteerEntryData
    on Fragment_VolunteerEntryData {
  CopyWith_Fragment_VolunteerEntryData<Fragment_VolunteerEntryData>
  get copyWith => CopyWith_Fragment_VolunteerEntryData(this, (i) => i);
}

abstract class CopyWith_Fragment_VolunteerEntryData<TRes> {
  factory CopyWith_Fragment_VolunteerEntryData(
    Fragment_VolunteerEntryData instance,
    TRes Function(Fragment_VolunteerEntryData) then,
  ) = _CopyWithImpl_Fragment_VolunteerEntryData;

  factory CopyWith_Fragment_VolunteerEntryData.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VolunteerEntryData;

  TRes call({
    String? id,
    Enum_EhrenamtsbankEintragTyp? typ,
    String? title,
    String? description,
    String? kategorieId,
    int? estimatedDurationMinutes,
    String? availability,
    List<String>? tags,
    DateTime? createdAt,
    Enum_EhrenamtsbankEintragStatus? status,
    String? imageKey,
    Fragment_VolunteerEntryData_owner? owner,
    Fragment_VolunteerEntryData_untereinheit? untereinheit,
    String? $__typename,
  });
  CopyWith_Fragment_VolunteerEntryData_owner<TRes> get owner;
  CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> get untereinheit;
}

class _CopyWithImpl_Fragment_VolunteerEntryData<TRes>
    implements CopyWith_Fragment_VolunteerEntryData<TRes> {
  _CopyWithImpl_Fragment_VolunteerEntryData(this._instance, this._then);

  final Fragment_VolunteerEntryData _instance;

  final TRes Function(Fragment_VolunteerEntryData) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? typ = _undefined,
    Object? title = _undefined,
    Object? description = _undefined,
    Object? kategorieId = _undefined,
    Object? estimatedDurationMinutes = _undefined,
    Object? availability = _undefined,
    Object? tags = _undefined,
    Object? createdAt = _undefined,
    Object? status = _undefined,
    Object? imageKey = _undefined,
    Object? owner = _undefined,
    Object? untereinheit = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VolunteerEntryData(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      typ: typ == _undefined || typ == null
          ? _instance.typ
          : (typ as Enum_EhrenamtsbankEintragTyp),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      description: description == _undefined || description == null
          ? _instance.description
          : (description as String),
      kategorieId: kategorieId == _undefined || kategorieId == null
          ? _instance.kategorieId
          : (kategorieId as String),
      estimatedDurationMinutes: estimatedDurationMinutes == _undefined
          ? _instance.estimatedDurationMinutes
          : (estimatedDurationMinutes as int?),
      availability: availability == _undefined
          ? _instance.availability
          : (availability as String?),
      tags: tags == _undefined || tags == null
          ? _instance.tags
          : (tags as List<String>),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankEintragStatus),
      imageKey: imageKey == _undefined
          ? _instance.imageKey
          : (imageKey as String?),
      owner: owner == _undefined
          ? _instance.owner
          : (owner as Fragment_VolunteerEntryData_owner?),
      untereinheit: untereinheit == _undefined
          ? _instance.untereinheit
          : (untereinheit as Fragment_VolunteerEntryData_untereinheit?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VolunteerEntryData_owner<TRes> get owner {
    final local$owner = _instance.owner;
    return local$owner == null
        ? CopyWith_Fragment_VolunteerEntryData_owner.stub(_then(_instance))
        : CopyWith_Fragment_VolunteerEntryData_owner(
            local$owner,
            (e) => call(owner: e),
          );
  }

  CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> get untereinheit {
    final local$untereinheit = _instance.untereinheit;
    return local$untereinheit == null
        ? CopyWith_Fragment_VolunteerEntryData_untereinheit.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_VolunteerEntryData_untereinheit(
            local$untereinheit,
            (e) => call(untereinheit: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VolunteerEntryData<TRes>
    implements CopyWith_Fragment_VolunteerEntryData<TRes> {
  _CopyWithStubImpl_Fragment_VolunteerEntryData(this._res);

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankEintragTyp? typ,
    String? title,
    String? description,
    String? kategorieId,
    int? estimatedDurationMinutes,
    String? availability,
    List<String>? tags,
    DateTime? createdAt,
    Enum_EhrenamtsbankEintragStatus? status,
    String? imageKey,
    Fragment_VolunteerEntryData_owner? owner,
    Fragment_VolunteerEntryData_untereinheit? untereinheit,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VolunteerEntryData_owner<TRes> get owner =>
      CopyWith_Fragment_VolunteerEntryData_owner.stub(_res);

  CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> get untereinheit =>
      CopyWith_Fragment_VolunteerEntryData_untereinheit.stub(_res);
}

const fragmentDefinitionVolunteerEntryData = FragmentDefinitionNode(
  name: NameNode(value: 'VolunteerEntryData'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'EhrenamtsbankEintrag'),
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
        name: NameNode(value: 'typ'),
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
        name: NameNode(value: 'description'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'kategorieId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'estimatedDurationMinutes'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'availability'),
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
        name: NameNode(value: 'status'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'imageKey'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'owner'),
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
              name: NameNode(value: 'vorname'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'nachname'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'phoneVerified'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'clearanceVerified'),
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
        name: NameNode(value: 'untereinheit'),
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
);
const documentNodeFragmentVolunteerEntryData = DocumentNode(
  definitions: [fragmentDefinitionVolunteerEntryData],
);

extension ClientExtension_Fragment_VolunteerEntryData on graphql.GraphQLClient {
  void writeFragment_VolunteerEntryData({
    required Fragment_VolunteerEntryData data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'VolunteerEntryData',
        document: documentNodeFragmentVolunteerEntryData,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_VolunteerEntryData? readFragment_VolunteerEntryData({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'VolunteerEntryData',
          document: documentNodeFragmentVolunteerEntryData,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_VolunteerEntryData.fromJson(result);
  }
}

class Fragment_VolunteerEntryData_owner {
  Fragment_VolunteerEntryData_owner({
    required this.id,
    this.vorname,
    this.nachname,
    required this.phoneVerified,
    required this.clearanceVerified,
    this.$__typename = 'EhrenamtsbankProfil',
  });

  factory Fragment_VolunteerEntryData_owner.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$vorname = json['vorname'];
    final l$nachname = json['nachname'];
    final l$phoneVerified = json['phoneVerified'];
    final l$clearanceVerified = json['clearanceVerified'];
    final l$$__typename = json['__typename'];
    return Fragment_VolunteerEntryData_owner(
      id: (l$id as String),
      vorname: (l$vorname as String?),
      nachname: (l$nachname as String?),
      phoneVerified: (l$phoneVerified as bool),
      clearanceVerified: (l$clearanceVerified as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? vorname;

  final String? nachname;

  final bool phoneVerified;

  final bool clearanceVerified;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$vorname = vorname;
    _resultData['vorname'] = l$vorname;
    final l$nachname = nachname;
    _resultData['nachname'] = l$nachname;
    final l$phoneVerified = phoneVerified;
    _resultData['phoneVerified'] = l$phoneVerified;
    final l$clearanceVerified = clearanceVerified;
    _resultData['clearanceVerified'] = l$clearanceVerified;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$vorname = vorname;
    final l$nachname = nachname;
    final l$phoneVerified = phoneVerified;
    final l$clearanceVerified = clearanceVerified;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$vorname,
      l$nachname,
      l$phoneVerified,
      l$clearanceVerified,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VolunteerEntryData_owner ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$vorname = vorname;
    final lOther$vorname = other.vorname;
    if (l$vorname != lOther$vorname) {
      return false;
    }
    final l$nachname = nachname;
    final lOther$nachname = other.nachname;
    if (l$nachname != lOther$nachname) {
      return false;
    }
    final l$phoneVerified = phoneVerified;
    final lOther$phoneVerified = other.phoneVerified;
    if (l$phoneVerified != lOther$phoneVerified) {
      return false;
    }
    final l$clearanceVerified = clearanceVerified;
    final lOther$clearanceVerified = other.clearanceVerified;
    if (l$clearanceVerified != lOther$clearanceVerified) {
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

extension UtilityExtension_Fragment_VolunteerEntryData_owner
    on Fragment_VolunteerEntryData_owner {
  CopyWith_Fragment_VolunteerEntryData_owner<Fragment_VolunteerEntryData_owner>
  get copyWith => CopyWith_Fragment_VolunteerEntryData_owner(this, (i) => i);
}

abstract class CopyWith_Fragment_VolunteerEntryData_owner<TRes> {
  factory CopyWith_Fragment_VolunteerEntryData_owner(
    Fragment_VolunteerEntryData_owner instance,
    TRes Function(Fragment_VolunteerEntryData_owner) then,
  ) = _CopyWithImpl_Fragment_VolunteerEntryData_owner;

  factory CopyWith_Fragment_VolunteerEntryData_owner.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VolunteerEntryData_owner;

  TRes call({
    String? id,
    String? vorname,
    String? nachname,
    bool? phoneVerified,
    bool? clearanceVerified,
    String? $__typename,
  });
}

class _CopyWithImpl_Fragment_VolunteerEntryData_owner<TRes>
    implements CopyWith_Fragment_VolunteerEntryData_owner<TRes> {
  _CopyWithImpl_Fragment_VolunteerEntryData_owner(this._instance, this._then);

  final Fragment_VolunteerEntryData_owner _instance;

  final TRes Function(Fragment_VolunteerEntryData_owner) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? vorname = _undefined,
    Object? nachname = _undefined,
    Object? phoneVerified = _undefined,
    Object? clearanceVerified = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VolunteerEntryData_owner(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      vorname: vorname == _undefined ? _instance.vorname : (vorname as String?),
      nachname: nachname == _undefined
          ? _instance.nachname
          : (nachname as String?),
      phoneVerified: phoneVerified == _undefined || phoneVerified == null
          ? _instance.phoneVerified
          : (phoneVerified as bool),
      clearanceVerified:
          clearanceVerified == _undefined || clearanceVerified == null
          ? _instance.clearanceVerified
          : (clearanceVerified as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_VolunteerEntryData_owner<TRes>
    implements CopyWith_Fragment_VolunteerEntryData_owner<TRes> {
  _CopyWithStubImpl_Fragment_VolunteerEntryData_owner(this._res);

  TRes _res;

  call({
    String? id,
    String? vorname,
    String? nachname,
    bool? phoneVerified,
    bool? clearanceVerified,
    String? $__typename,
  }) => _res;
}

class Fragment_VolunteerEntryData_untereinheit {
  Fragment_VolunteerEntryData_untereinheit({
    required this.name,
    this.$__typename = 'Untereinheit',
  });

  factory Fragment_VolunteerEntryData_untereinheit.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment_VolunteerEntryData_untereinheit(
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
    if (other is! Fragment_VolunteerEntryData_untereinheit ||
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

extension UtilityExtension_Fragment_VolunteerEntryData_untereinheit
    on Fragment_VolunteerEntryData_untereinheit {
  CopyWith_Fragment_VolunteerEntryData_untereinheit<
    Fragment_VolunteerEntryData_untereinheit
  >
  get copyWith =>
      CopyWith_Fragment_VolunteerEntryData_untereinheit(this, (i) => i);
}

abstract class CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> {
  factory CopyWith_Fragment_VolunteerEntryData_untereinheit(
    Fragment_VolunteerEntryData_untereinheit instance,
    TRes Function(Fragment_VolunteerEntryData_untereinheit) then,
  ) = _CopyWithImpl_Fragment_VolunteerEntryData_untereinheit;

  factory CopyWith_Fragment_VolunteerEntryData_untereinheit.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VolunteerEntryData_untereinheit;

  TRes call({String? name, String? $__typename});
}

class _CopyWithImpl_Fragment_VolunteerEntryData_untereinheit<TRes>
    implements CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> {
  _CopyWithImpl_Fragment_VolunteerEntryData_untereinheit(
    this._instance,
    this._then,
  );

  final Fragment_VolunteerEntryData_untereinheit _instance;

  final TRes Function(Fragment_VolunteerEntryData_untereinheit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_VolunteerEntryData_untereinheit(
          name: name == _undefined || name == null
              ? _instance.name
              : (name as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_VolunteerEntryData_untereinheit<TRes>
    implements CopyWith_Fragment_VolunteerEntryData_untereinheit<TRes> {
  _CopyWithStubImpl_Fragment_VolunteerEntryData_untereinheit(this._res);

  TRes _res;

  call({String? name, String? $__typename}) => _res;
}

class Variables_Query_VolunteerEntries {
  factory Variables_Query_VolunteerEntries({
    required Enum_EhrenamtsbankEintragTyp typ,
    List<String>? kategorieIds,
    required int skip,
    required int take,
  }) => Variables_Query_VolunteerEntries._({
    r'typ': typ,
    if (kategorieIds != null) r'kategorieIds': kategorieIds,
    r'skip': skip,
    r'take': take,
  });

  Variables_Query_VolunteerEntries._(this._$data);

  factory Variables_Query_VolunteerEntries.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$typ = data['typ'];
    result$data['typ'] = fromJson_Enum_EhrenamtsbankEintragTyp(
      (l$typ as String),
    );
    if (data.containsKey('kategorieIds')) {
      final l$kategorieIds = data['kategorieIds'];
      result$data['kategorieIds'] = (l$kategorieIds as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    final l$skip = data['skip'];
    result$data['skip'] = (l$skip as int);
    final l$take = data['take'];
    result$data['take'] = (l$take as int);
    return Variables_Query_VolunteerEntries._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum_EhrenamtsbankEintragTyp get typ =>
      (_$data['typ'] as Enum_EhrenamtsbankEintragTyp);

  List<String>? get kategorieIds => (_$data['kategorieIds'] as List<String>?);

  int get skip => (_$data['skip'] as int);

  int get take => (_$data['take'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$typ = typ;
    result$data['typ'] = toJson_Enum_EhrenamtsbankEintragTyp(l$typ);
    if (_$data.containsKey('kategorieIds')) {
      final l$kategorieIds = kategorieIds;
      result$data['kategorieIds'] = l$kategorieIds?.map((e) => e).toList();
    }
    final l$skip = skip;
    result$data['skip'] = l$skip;
    final l$take = take;
    result$data['take'] = l$take;
    return result$data;
  }

  CopyWith_Variables_Query_VolunteerEntries<Variables_Query_VolunteerEntries>
  get copyWith => CopyWith_Variables_Query_VolunteerEntries(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_VolunteerEntries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$typ = typ;
    final lOther$typ = other.typ;
    if (l$typ != lOther$typ) {
      return false;
    }
    final l$kategorieIds = kategorieIds;
    final lOther$kategorieIds = other.kategorieIds;
    if (_$data.containsKey('kategorieIds') !=
        other._$data.containsKey('kategorieIds')) {
      return false;
    }
    if (l$kategorieIds != null && lOther$kategorieIds != null) {
      if (l$kategorieIds.length != lOther$kategorieIds.length) {
        return false;
      }
      for (int i = 0; i < l$kategorieIds.length; i++) {
        final l$kategorieIds$entry = l$kategorieIds[i];
        final lOther$kategorieIds$entry = lOther$kategorieIds[i];
        if (l$kategorieIds$entry != lOther$kategorieIds$entry) {
          return false;
        }
      }
    } else if (l$kategorieIds != lOther$kategorieIds) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (l$take != lOther$take) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$typ = typ;
    final l$kategorieIds = kategorieIds;
    final l$skip = skip;
    final l$take = take;
    return Object.hashAll([
      l$typ,
      _$data.containsKey('kategorieIds')
          ? l$kategorieIds == null
                ? null
                : Object.hashAll(l$kategorieIds.map((v) => v))
          : const {},
      l$skip,
      l$take,
    ]);
  }
}

abstract class CopyWith_Variables_Query_VolunteerEntries<TRes> {
  factory CopyWith_Variables_Query_VolunteerEntries(
    Variables_Query_VolunteerEntries instance,
    TRes Function(Variables_Query_VolunteerEntries) then,
  ) = _CopyWithImpl_Variables_Query_VolunteerEntries;

  factory CopyWith_Variables_Query_VolunteerEntries.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_VolunteerEntries;

  TRes call({
    Enum_EhrenamtsbankEintragTyp? typ,
    List<String>? kategorieIds,
    int? skip,
    int? take,
  });
}

class _CopyWithImpl_Variables_Query_VolunteerEntries<TRes>
    implements CopyWith_Variables_Query_VolunteerEntries<TRes> {
  _CopyWithImpl_Variables_Query_VolunteerEntries(this._instance, this._then);

  final Variables_Query_VolunteerEntries _instance;

  final TRes Function(Variables_Query_VolunteerEntries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? typ = _undefined,
    Object? kategorieIds = _undefined,
    Object? skip = _undefined,
    Object? take = _undefined,
  }) => _then(
    Variables_Query_VolunteerEntries._({
      ..._instance._$data,
      if (typ != _undefined && typ != null)
        'typ': (typ as Enum_EhrenamtsbankEintragTyp),
      if (kategorieIds != _undefined)
        'kategorieIds': (kategorieIds as List<String>?),
      if (skip != _undefined && skip != null) 'skip': (skip as int),
      if (take != _undefined && take != null) 'take': (take as int),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_VolunteerEntries<TRes>
    implements CopyWith_Variables_Query_VolunteerEntries<TRes> {
  _CopyWithStubImpl_Variables_Query_VolunteerEntries(this._res);

  TRes _res;

  call({
    Enum_EhrenamtsbankEintragTyp? typ,
    List<String>? kategorieIds,
    int? skip,
    int? take,
  }) => _res;
}

class Query_VolunteerEntries {
  Query_VolunteerEntries({
    this.ehrenamtsbankEintraege,
    this.$__typename = 'Query',
  });

  factory Query_VolunteerEntries.fromJson(Map<String, dynamic> json) {
    final l$ehrenamtsbankEintraege = json['ehrenamtsbankEintraege'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerEntries(
      ehrenamtsbankEintraege: l$ehrenamtsbankEintraege == null
          ? null
          : Query_VolunteerEntries_ehrenamtsbankEintraege.fromJson(
              (l$ehrenamtsbankEintraege as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_VolunteerEntries_ehrenamtsbankEintraege? ehrenamtsbankEintraege;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankEintraege = ehrenamtsbankEintraege;
    _resultData['ehrenamtsbankEintraege'] = l$ehrenamtsbankEintraege?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankEintraege = ehrenamtsbankEintraege;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ehrenamtsbankEintraege, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VolunteerEntries || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankEintraege = ehrenamtsbankEintraege;
    final lOther$ehrenamtsbankEintraege = other.ehrenamtsbankEintraege;
    if (l$ehrenamtsbankEintraege != lOther$ehrenamtsbankEintraege) {
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

extension UtilityExtension_Query_VolunteerEntries on Query_VolunteerEntries {
  CopyWith_Query_VolunteerEntries<Query_VolunteerEntries> get copyWith =>
      CopyWith_Query_VolunteerEntries(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerEntries<TRes> {
  factory CopyWith_Query_VolunteerEntries(
    Query_VolunteerEntries instance,
    TRes Function(Query_VolunteerEntries) then,
  ) = _CopyWithImpl_Query_VolunteerEntries;

  factory CopyWith_Query_VolunteerEntries.stub(TRes res) =
      _CopyWithStubImpl_Query_VolunteerEntries;

  TRes call({
    Query_VolunteerEntries_ehrenamtsbankEintraege? ehrenamtsbankEintraege,
    String? $__typename,
  });
  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes>
  get ehrenamtsbankEintraege;
}

class _CopyWithImpl_Query_VolunteerEntries<TRes>
    implements CopyWith_Query_VolunteerEntries<TRes> {
  _CopyWithImpl_Query_VolunteerEntries(this._instance, this._then);

  final Query_VolunteerEntries _instance;

  final TRes Function(Query_VolunteerEntries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankEintraege = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerEntries(
      ehrenamtsbankEintraege: ehrenamtsbankEintraege == _undefined
          ? _instance.ehrenamtsbankEintraege
          : (ehrenamtsbankEintraege
                as Query_VolunteerEntries_ehrenamtsbankEintraege?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes>
  get ehrenamtsbankEintraege {
    final local$ehrenamtsbankEintraege = _instance.ehrenamtsbankEintraege;
    return local$ehrenamtsbankEintraege == null
        ? CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege.stub(
            _then(_instance),
          )
        : CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege(
            local$ehrenamtsbankEintraege,
            (e) => call(ehrenamtsbankEintraege: e),
          );
  }
}

class _CopyWithStubImpl_Query_VolunteerEntries<TRes>
    implements CopyWith_Query_VolunteerEntries<TRes> {
  _CopyWithStubImpl_Query_VolunteerEntries(this._res);

  TRes _res;

  call({
    Query_VolunteerEntries_ehrenamtsbankEintraege? ehrenamtsbankEintraege,
    String? $__typename,
  }) => _res;

  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes>
  get ehrenamtsbankEintraege =>
      CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege.stub(_res);
}

const documentNodeQueryVolunteerEntries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VolunteerEntries'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'typ')),
          type: NamedTypeNode(
            name: NameNode(value: 'EhrenamtsbankEintragTyp'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kategorieIds')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'skip')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'take')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'ehrenamtsbankEintraege'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'skip'),
                value: VariableNode(name: NameNode(value: 'skip')),
              ),
              ArgumentNode(
                name: NameNode(value: 'take'),
                value: VariableNode(name: NameNode(value: 'take')),
              ),
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'typ'),
                      value: VariableNode(name: NameNode(value: 'typ')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'kategorieIds'),
                      value: VariableNode(
                        name: NameNode(value: 'kategorieIds'),
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'status'),
                      value: EnumValueNode(name: NameNode(value: 'ACTIVE')),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'VolunteerEntryData'),
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
                  name: NameNode(value: 'pageInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'hasNextPage'),
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
    fragmentDefinitionVolunteerEntryData,
  ],
);
Query_VolunteerEntries _parserFn_Query_VolunteerEntries(
  Map<String, dynamic> data,
) => Query_VolunteerEntries.fromJson(data);
typedef OnQueryComplete_Query_VolunteerEntries =
    FutureOr<void> Function(Map<String, dynamic>?, Query_VolunteerEntries?);

class Options_Query_VolunteerEntries
    extends graphql.QueryOptions<Query_VolunteerEntries> {
  Options_Query_VolunteerEntries({
    String? operationName,
    required Variables_Query_VolunteerEntries variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerEntries? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VolunteerEntries? onComplete,
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
                 data == null ? null : _parserFn_Query_VolunteerEntries(data),
               ),
         onError: onError,
         document: documentNodeQueryVolunteerEntries,
         parserFn: _parserFn_Query_VolunteerEntries,
       );

  final OnQueryComplete_Query_VolunteerEntries? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VolunteerEntries
    extends graphql.WatchQueryOptions<Query_VolunteerEntries> {
  WatchOptions_Query_VolunteerEntries({
    String? operationName,
    required Variables_Query_VolunteerEntries variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerEntries? typedOptimisticResult,
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
         document: documentNodeQueryVolunteerEntries,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VolunteerEntries,
       );
}

class FetchMoreOptions_Query_VolunteerEntries extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VolunteerEntries({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_VolunteerEntries variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryVolunteerEntries,
       );
}

extension ClientExtension_Query_VolunteerEntries on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VolunteerEntries>> query_VolunteerEntries(
    Options_Query_VolunteerEntries options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_VolunteerEntries> watchQuery_VolunteerEntries(
    WatchOptions_Query_VolunteerEntries options,
  ) => this.watchQuery(options);

  void writeQuery_VolunteerEntries({
    required Query_VolunteerEntries data,
    required Variables_Query_VolunteerEntries variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryVolunteerEntries),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VolunteerEntries? readQuery_VolunteerEntries({
    required Variables_Query_VolunteerEntries variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryVolunteerEntries,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_VolunteerEntries.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VolunteerEntries>
useQuery_VolunteerEntries(Options_Query_VolunteerEntries options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_VolunteerEntries> useWatchQuery_VolunteerEntries(
  WatchOptions_Query_VolunteerEntries options,
) => graphql_flutter.useWatchQuery(options);

class Query_VolunteerEntries_Widget
    extends graphql_flutter.Query<Query_VolunteerEntries> {
  Query_VolunteerEntries_Widget({
    widgets.Key? key,
    required Options_Query_VolunteerEntries options,
    required graphql_flutter.QueryBuilder<Query_VolunteerEntries> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_VolunteerEntries_ehrenamtsbankEintraege {
  Query_VolunteerEntries_ehrenamtsbankEintraege({
    this.items,
    required this.pageInfo,
    this.$__typename = 'EhrenamtsbankEintraegeCollectionSegment',
  });

  factory Query_VolunteerEntries_ehrenamtsbankEintraege.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$pageInfo = json['pageInfo'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerEntries_ehrenamtsbankEintraege(
      items: (l$items as List<dynamic>?)
          ?.map(
            (e) => Fragment_VolunteerEntryData.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo: Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo.fromJson(
        (l$pageInfo as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_VolunteerEntryData>? items;

  final Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo pageInfo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items?.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$pageInfo = pageInfo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$items == null ? null : Object.hashAll(l$items.map((v) => v)),
      l$pageInfo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VolunteerEntries_ehrenamtsbankEintraege ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items != null && lOther$items != null) {
      if (l$items.length != lOther$items.length) {
        return false;
      }
      for (int i = 0; i < l$items.length; i++) {
        final l$items$entry = l$items[i];
        final lOther$items$entry = lOther$items[i];
        if (l$items$entry != lOther$items$entry) {
          return false;
        }
      }
    } else if (l$items != lOther$items) {
      return false;
    }
    final l$pageInfo = pageInfo;
    final lOther$pageInfo = other.pageInfo;
    if (l$pageInfo != lOther$pageInfo) {
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

extension UtilityExtension_Query_VolunteerEntries_ehrenamtsbankEintraege
    on Query_VolunteerEntries_ehrenamtsbankEintraege {
  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<
    Query_VolunteerEntries_ehrenamtsbankEintraege
  >
  get copyWith =>
      CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes> {
  factory CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege(
    Query_VolunteerEntries_ehrenamtsbankEintraege instance,
    TRes Function(Query_VolunteerEntries_ehrenamtsbankEintraege) then,
  ) = _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege;

  factory CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege;

  TRes call({
    List<Fragment_VolunteerEntryData>? items,
    Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo? pageInfo,
    String? $__typename,
  });
  TRes items(
    Iterable<Fragment_VolunteerEntryData>? Function(
      Iterable<
        CopyWith_Fragment_VolunteerEntryData<Fragment_VolunteerEntryData>
      >?,
    )
    _fn,
  );
  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo;
}

class _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes>
    implements CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes> {
  _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege(
    this._instance,
    this._then,
  );

  final Query_VolunteerEntries_ehrenamtsbankEintraege _instance;

  final TRes Function(Query_VolunteerEntries_ehrenamtsbankEintraege) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? pageInfo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerEntries_ehrenamtsbankEintraege(
      items: items == _undefined
          ? _instance.items
          : (items as List<Fragment_VolunteerEntryData>?),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo
                as Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Fragment_VolunteerEntryData>? Function(
      Iterable<
        CopyWith_Fragment_VolunteerEntryData<Fragment_VolunteerEntryData>
      >?,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items?.map(
        (e) => CopyWith_Fragment_VolunteerEntryData(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes>
    implements CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege<TRes> {
  _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege(this._res);

  TRes _res;

  call({
    List<Fragment_VolunteerEntryData>? items,
    Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo? pageInfo,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;

  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo =>
      CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo.stub(
        _res,
      );
}

class Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo {
  Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo({
    required this.hasNextPage,
    this.$__typename = 'CollectionSegmentInfo',
  });

  factory Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
      hasNextPage: (l$hasNextPage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool hasNextPage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasNextPage = hasNextPage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$hasNextPage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
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

extension UtilityExtension_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo
    on Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo {
  CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<
    Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo
  >
  get copyWith =>
      CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<
  TRes
> {
  factory CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
    Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo instance,
    TRes Function(Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo) then,
  ) = _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo;

  factory CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo;

  TRes call({bool? hasNextPage, String? $__typename});
}

class _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes>
    implements
        CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes> {
  _CopyWithImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
    this._instance,
    this._then,
  );

  final Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo _instance;

  final TRes Function(Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<
  TRes
>
    implements
        CopyWith_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo<TRes> {
  _CopyWithStubImpl_Query_VolunteerEntries_ehrenamtsbankEintraege_pageInfo(
    this._res,
  );

  TRes _res;

  call({bool? hasNextPage, String? $__typename}) => _res;
}

class Variables_Query_VolunteerEntry {
  factory Variables_Query_VolunteerEntry({required String id}) =>
      Variables_Query_VolunteerEntry._({r'id': id});

  Variables_Query_VolunteerEntry._(this._$data);

  factory Variables_Query_VolunteerEntry.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables_Query_VolunteerEntry._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith_Variables_Query_VolunteerEntry<Variables_Query_VolunteerEntry>
  get copyWith => CopyWith_Variables_Query_VolunteerEntry(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_VolunteerEntry ||
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

abstract class CopyWith_Variables_Query_VolunteerEntry<TRes> {
  factory CopyWith_Variables_Query_VolunteerEntry(
    Variables_Query_VolunteerEntry instance,
    TRes Function(Variables_Query_VolunteerEntry) then,
  ) = _CopyWithImpl_Variables_Query_VolunteerEntry;

  factory CopyWith_Variables_Query_VolunteerEntry.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_VolunteerEntry;

  TRes call({String? id});
}

class _CopyWithImpl_Variables_Query_VolunteerEntry<TRes>
    implements CopyWith_Variables_Query_VolunteerEntry<TRes> {
  _CopyWithImpl_Variables_Query_VolunteerEntry(this._instance, this._then);

  final Variables_Query_VolunteerEntry _instance;

  final TRes Function(Variables_Query_VolunteerEntry) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables_Query_VolunteerEntry._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_VolunteerEntry<TRes>
    implements CopyWith_Variables_Query_VolunteerEntry<TRes> {
  _CopyWithStubImpl_Variables_Query_VolunteerEntry(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query_VolunteerEntry {
  Query_VolunteerEntry({
    required this.ehrenamtsbankEintrag,
    this.$__typename = 'Query',
  });

  factory Query_VolunteerEntry.fromJson(Map<String, dynamic> json) {
    final l$ehrenamtsbankEintrag = json['ehrenamtsbankEintrag'];
    final l$$__typename = json['__typename'];
    return Query_VolunteerEntry(
      ehrenamtsbankEintrag: Fragment_VolunteerEntryData.fromJson(
        (l$ehrenamtsbankEintrag as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_VolunteerEntryData ehrenamtsbankEintrag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    _resultData['ehrenamtsbankEintrag'] = l$ehrenamtsbankEintrag.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ehrenamtsbankEintrag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_VolunteerEntry || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final lOther$ehrenamtsbankEintrag = other.ehrenamtsbankEintrag;
    if (l$ehrenamtsbankEintrag != lOther$ehrenamtsbankEintrag) {
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

extension UtilityExtension_Query_VolunteerEntry on Query_VolunteerEntry {
  CopyWith_Query_VolunteerEntry<Query_VolunteerEntry> get copyWith =>
      CopyWith_Query_VolunteerEntry(this, (i) => i);
}

abstract class CopyWith_Query_VolunteerEntry<TRes> {
  factory CopyWith_Query_VolunteerEntry(
    Query_VolunteerEntry instance,
    TRes Function(Query_VolunteerEntry) then,
  ) = _CopyWithImpl_Query_VolunteerEntry;

  factory CopyWith_Query_VolunteerEntry.stub(TRes res) =
      _CopyWithStubImpl_Query_VolunteerEntry;

  TRes call({
    Fragment_VolunteerEntryData? ehrenamtsbankEintrag,
    String? $__typename,
  });
  CopyWith_Fragment_VolunteerEntryData<TRes> get ehrenamtsbankEintrag;
}

class _CopyWithImpl_Query_VolunteerEntry<TRes>
    implements CopyWith_Query_VolunteerEntry<TRes> {
  _CopyWithImpl_Query_VolunteerEntry(this._instance, this._then);

  final Query_VolunteerEntry _instance;

  final TRes Function(Query_VolunteerEntry) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankEintrag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_VolunteerEntry(
      ehrenamtsbankEintrag:
          ehrenamtsbankEintrag == _undefined || ehrenamtsbankEintrag == null
          ? _instance.ehrenamtsbankEintrag
          : (ehrenamtsbankEintrag as Fragment_VolunteerEntryData),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VolunteerEntryData<TRes> get ehrenamtsbankEintrag {
    final local$ehrenamtsbankEintrag = _instance.ehrenamtsbankEintrag;
    return CopyWith_Fragment_VolunteerEntryData(
      local$ehrenamtsbankEintrag,
      (e) => call(ehrenamtsbankEintrag: e),
    );
  }
}

class _CopyWithStubImpl_Query_VolunteerEntry<TRes>
    implements CopyWith_Query_VolunteerEntry<TRes> {
  _CopyWithStubImpl_Query_VolunteerEntry(this._res);

  TRes _res;

  call({
    Fragment_VolunteerEntryData? ehrenamtsbankEintrag,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VolunteerEntryData<TRes> get ehrenamtsbankEintrag =>
      CopyWith_Fragment_VolunteerEntryData.stub(_res);
}

const documentNodeQueryVolunteerEntry = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'VolunteerEntry'),
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
            name: NameNode(value: 'ehrenamtsbankEintrag'),
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
                  name: NameNode(value: 'VolunteerEntryData'),
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
    fragmentDefinitionVolunteerEntryData,
  ],
);
Query_VolunteerEntry _parserFn_Query_VolunteerEntry(
  Map<String, dynamic> data,
) => Query_VolunteerEntry.fromJson(data);
typedef OnQueryComplete_Query_VolunteerEntry =
    FutureOr<void> Function(Map<String, dynamic>?, Query_VolunteerEntry?);

class Options_Query_VolunteerEntry
    extends graphql.QueryOptions<Query_VolunteerEntry> {
  Options_Query_VolunteerEntry({
    String? operationName,
    required Variables_Query_VolunteerEntry variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerEntry? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_VolunteerEntry? onComplete,
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
                 data == null ? null : _parserFn_Query_VolunteerEntry(data),
               ),
         onError: onError,
         document: documentNodeQueryVolunteerEntry,
         parserFn: _parserFn_Query_VolunteerEntry,
       );

  final OnQueryComplete_Query_VolunteerEntry? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_VolunteerEntry
    extends graphql.WatchQueryOptions<Query_VolunteerEntry> {
  WatchOptions_Query_VolunteerEntry({
    String? operationName,
    required Variables_Query_VolunteerEntry variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_VolunteerEntry? typedOptimisticResult,
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
         document: documentNodeQueryVolunteerEntry,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_VolunteerEntry,
       );
}

class FetchMoreOptions_Query_VolunteerEntry extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_VolunteerEntry({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_VolunteerEntry variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryVolunteerEntry,
       );
}

extension ClientExtension_Query_VolunteerEntry on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_VolunteerEntry>> query_VolunteerEntry(
    Options_Query_VolunteerEntry options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_VolunteerEntry> watchQuery_VolunteerEntry(
    WatchOptions_Query_VolunteerEntry options,
  ) => this.watchQuery(options);

  void writeQuery_VolunteerEntry({
    required Query_VolunteerEntry data,
    required Variables_Query_VolunteerEntry variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryVolunteerEntry),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_VolunteerEntry? readQuery_VolunteerEntry({
    required Variables_Query_VolunteerEntry variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryVolunteerEntry),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_VolunteerEntry.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_VolunteerEntry> useQuery_VolunteerEntry(
  Options_Query_VolunteerEntry options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_VolunteerEntry> useWatchQuery_VolunteerEntry(
  WatchOptions_Query_VolunteerEntry options,
) => graphql_flutter.useWatchQuery(options);

class Query_VolunteerEntry_Widget
    extends graphql_flutter.Query<Query_VolunteerEntry> {
  Query_VolunteerEntry_Widget({
    widgets.Key? key,
    required Options_Query_VolunteerEntry options,
    required graphql_flutter.QueryBuilder<Query_VolunteerEntry> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Variables_Query_MyVolunteerEntries {
  factory Variables_Query_MyVolunteerEntries({
    required int skip,
    required int take,
  }) => Variables_Query_MyVolunteerEntries._({r'skip': skip, r'take': take});

  Variables_Query_MyVolunteerEntries._(this._$data);

  factory Variables_Query_MyVolunteerEntries.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$skip = data['skip'];
    result$data['skip'] = (l$skip as int);
    final l$take = data['take'];
    result$data['take'] = (l$take as int);
    return Variables_Query_MyVolunteerEntries._(result$data);
  }

  Map<String, dynamic> _$data;

  int get skip => (_$data['skip'] as int);

  int get take => (_$data['take'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$skip = skip;
    result$data['skip'] = l$skip;
    final l$take = take;
    result$data['take'] = l$take;
    return result$data;
  }

  CopyWith_Variables_Query_MyVolunteerEntries<
    Variables_Query_MyVolunteerEntries
  >
  get copyWith => CopyWith_Variables_Query_MyVolunteerEntries(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_MyVolunteerEntries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (l$take != lOther$take) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$skip = skip;
    final l$take = take;
    return Object.hashAll([l$skip, l$take]);
  }
}

abstract class CopyWith_Variables_Query_MyVolunteerEntries<TRes> {
  factory CopyWith_Variables_Query_MyVolunteerEntries(
    Variables_Query_MyVolunteerEntries instance,
    TRes Function(Variables_Query_MyVolunteerEntries) then,
  ) = _CopyWithImpl_Variables_Query_MyVolunteerEntries;

  factory CopyWith_Variables_Query_MyVolunteerEntries.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_MyVolunteerEntries;

  TRes call({int? skip, int? take});
}

class _CopyWithImpl_Variables_Query_MyVolunteerEntries<TRes>
    implements CopyWith_Variables_Query_MyVolunteerEntries<TRes> {
  _CopyWithImpl_Variables_Query_MyVolunteerEntries(this._instance, this._then);

  final Variables_Query_MyVolunteerEntries _instance;

  final TRes Function(Variables_Query_MyVolunteerEntries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? skip = _undefined, Object? take = _undefined}) => _then(
    Variables_Query_MyVolunteerEntries._({
      ..._instance._$data,
      if (skip != _undefined && skip != null) 'skip': (skip as int),
      if (take != _undefined && take != null) 'take': (take as int),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_MyVolunteerEntries<TRes>
    implements CopyWith_Variables_Query_MyVolunteerEntries<TRes> {
  _CopyWithStubImpl_Variables_Query_MyVolunteerEntries(this._res);

  TRes _res;

  call({int? skip, int? take}) => _res;
}

class Query_MyVolunteerEntries {
  Query_MyVolunteerEntries({
    this.meineEhrenamtsbankEintraege,
    this.$__typename = 'Query',
  });

  factory Query_MyVolunteerEntries.fromJson(Map<String, dynamic> json) {
    final l$meineEhrenamtsbankEintraege = json['meineEhrenamtsbankEintraege'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerEntries(
      meineEhrenamtsbankEintraege: l$meineEhrenamtsbankEintraege == null
          ? null
          : Query_MyVolunteerEntries_meineEhrenamtsbankEintraege.fromJson(
              (l$meineEhrenamtsbankEintraege as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyVolunteerEntries_meineEhrenamtsbankEintraege?
  meineEhrenamtsbankEintraege;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$meineEhrenamtsbankEintraege = meineEhrenamtsbankEintraege;
    _resultData['meineEhrenamtsbankEintraege'] = l$meineEhrenamtsbankEintraege
        ?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$meineEhrenamtsbankEintraege = meineEhrenamtsbankEintraege;
    final l$$__typename = $__typename;
    return Object.hashAll([l$meineEhrenamtsbankEintraege, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerEntries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$meineEhrenamtsbankEintraege = meineEhrenamtsbankEintraege;
    final lOther$meineEhrenamtsbankEintraege =
        other.meineEhrenamtsbankEintraege;
    if (l$meineEhrenamtsbankEintraege != lOther$meineEhrenamtsbankEintraege) {
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

extension UtilityExtension_Query_MyVolunteerEntries
    on Query_MyVolunteerEntries {
  CopyWith_Query_MyVolunteerEntries<Query_MyVolunteerEntries> get copyWith =>
      CopyWith_Query_MyVolunteerEntries(this, (i) => i);
}

abstract class CopyWith_Query_MyVolunteerEntries<TRes> {
  factory CopyWith_Query_MyVolunteerEntries(
    Query_MyVolunteerEntries instance,
    TRes Function(Query_MyVolunteerEntries) then,
  ) = _CopyWithImpl_Query_MyVolunteerEntries;

  factory CopyWith_Query_MyVolunteerEntries.stub(TRes res) =
      _CopyWithStubImpl_Query_MyVolunteerEntries;

  TRes call({
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege?
    meineEhrenamtsbankEintraege,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes>
  get meineEhrenamtsbankEintraege;
}

class _CopyWithImpl_Query_MyVolunteerEntries<TRes>
    implements CopyWith_Query_MyVolunteerEntries<TRes> {
  _CopyWithImpl_Query_MyVolunteerEntries(this._instance, this._then);

  final Query_MyVolunteerEntries _instance;

  final TRes Function(Query_MyVolunteerEntries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? meineEhrenamtsbankEintraege = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerEntries(
      meineEhrenamtsbankEintraege: meineEhrenamtsbankEintraege == _undefined
          ? _instance.meineEhrenamtsbankEintraege
          : (meineEhrenamtsbankEintraege
                as Query_MyVolunteerEntries_meineEhrenamtsbankEintraege?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes>
  get meineEhrenamtsbankEintraege {
    final local$meineEhrenamtsbankEintraege =
        _instance.meineEhrenamtsbankEintraege;
    return local$meineEhrenamtsbankEintraege == null
        ? CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
            local$meineEhrenamtsbankEintraege,
            (e) => call(meineEhrenamtsbankEintraege: e),
          );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerEntries<TRes>
    implements CopyWith_Query_MyVolunteerEntries<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerEntries(this._res);

  TRes _res;

  call({
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege?
    meineEhrenamtsbankEintraege,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes>
  get meineEhrenamtsbankEintraege =>
      CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege.stub(_res);
}

const documentNodeQueryMyVolunteerEntries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyVolunteerEntries'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'skip')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'take')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'meineEhrenamtsbankEintraege'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'skip'),
                value: VariableNode(name: NameNode(value: 'skip')),
              ),
              ArgumentNode(
                name: NameNode(value: 'take'),
                value: VariableNode(name: NameNode(value: 'take')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'VolunteerEntryData'),
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
                  name: NameNode(value: 'pageInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'hasNextPage'),
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
                  name: NameNode(value: 'totalCount'),
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
    fragmentDefinitionVolunteerEntryData,
  ],
);
Query_MyVolunteerEntries _parserFn_Query_MyVolunteerEntries(
  Map<String, dynamic> data,
) => Query_MyVolunteerEntries.fromJson(data);
typedef OnQueryComplete_Query_MyVolunteerEntries =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MyVolunteerEntries?);

class Options_Query_MyVolunteerEntries
    extends graphql.QueryOptions<Query_MyVolunteerEntries> {
  Options_Query_MyVolunteerEntries({
    String? operationName,
    required Variables_Query_MyVolunteerEntries variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerEntries? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyVolunteerEntries? onComplete,
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
                 data == null ? null : _parserFn_Query_MyVolunteerEntries(data),
               ),
         onError: onError,
         document: documentNodeQueryMyVolunteerEntries,
         parserFn: _parserFn_Query_MyVolunteerEntries,
       );

  final OnQueryComplete_Query_MyVolunteerEntries? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyVolunteerEntries
    extends graphql.WatchQueryOptions<Query_MyVolunteerEntries> {
  WatchOptions_Query_MyVolunteerEntries({
    String? operationName,
    required Variables_Query_MyVolunteerEntries variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerEntries? typedOptimisticResult,
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
         document: documentNodeQueryMyVolunteerEntries,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyVolunteerEntries,
       );
}

class FetchMoreOptions_Query_MyVolunteerEntries
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyVolunteerEntries({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_MyVolunteerEntries variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMyVolunteerEntries,
       );
}

extension ClientExtension_Query_MyVolunteerEntries on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyVolunteerEntries>>
  query_MyVolunteerEntries(Options_Query_MyVolunteerEntries options) async =>
      await this.query(options);

  graphql.ObservableQuery<Query_MyVolunteerEntries>
  watchQuery_MyVolunteerEntries(
    WatchOptions_Query_MyVolunteerEntries options,
  ) => this.watchQuery(options);

  void writeQuery_MyVolunteerEntries({
    required Query_MyVolunteerEntries data,
    required Variables_Query_MyVolunteerEntries variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryMyVolunteerEntries,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyVolunteerEntries? readQuery_MyVolunteerEntries({
    required Variables_Query_MyVolunteerEntries variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryMyVolunteerEntries,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyVolunteerEntries.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyVolunteerEntries>
useQuery_MyVolunteerEntries(Options_Query_MyVolunteerEntries options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_MyVolunteerEntries>
useWatchQuery_MyVolunteerEntries(
  WatchOptions_Query_MyVolunteerEntries options,
) => graphql_flutter.useWatchQuery(options);

class Query_MyVolunteerEntries_Widget
    extends graphql_flutter.Query<Query_MyVolunteerEntries> {
  Query_MyVolunteerEntries_Widget({
    widgets.Key? key,
    required Options_Query_MyVolunteerEntries options,
    required graphql_flutter.QueryBuilder<Query_MyVolunteerEntries> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_MyVolunteerEntries_meineEhrenamtsbankEintraege {
  Query_MyVolunteerEntries_meineEhrenamtsbankEintraege({
    this.items,
    required this.pageInfo,
    required this.totalCount,
    this.$__typename = 'MeineEhrenamtsbankEintraegeCollectionSegment',
  });

  factory Query_MyVolunteerEntries_meineEhrenamtsbankEintraege.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$pageInfo = json['pageInfo'];
    final l$totalCount = json['totalCount'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
      items: (l$items as List<dynamic>?)
          ?.map(
            (e) => Fragment_VolunteerEntryData.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      pageInfo:
          Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo.fromJson(
            (l$pageInfo as Map<String, dynamic>),
          ),
      totalCount: (l$totalCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment_VolunteerEntryData>? items;

  final Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo pageInfo;

  final int totalCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items?.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    final l$totalCount = totalCount;
    _resultData['totalCount'] = l$totalCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$pageInfo = pageInfo;
    final l$totalCount = totalCount;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$items == null ? null : Object.hashAll(l$items.map((v) => v)),
      l$pageInfo,
      l$totalCount,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerEntries_meineEhrenamtsbankEintraege ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items != null && lOther$items != null) {
      if (l$items.length != lOther$items.length) {
        return false;
      }
      for (int i = 0; i < l$items.length; i++) {
        final l$items$entry = l$items[i];
        final lOther$items$entry = lOther$items[i];
        if (l$items$entry != lOther$items$entry) {
          return false;
        }
      }
    } else if (l$items != lOther$items) {
      return false;
    }
    final l$pageInfo = pageInfo;
    final lOther$pageInfo = other.pageInfo;
    if (l$pageInfo != lOther$pageInfo) {
      return false;
    }
    final l$totalCount = totalCount;
    final lOther$totalCount = other.totalCount;
    if (l$totalCount != lOther$totalCount) {
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

extension UtilityExtension_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege
    on Query_MyVolunteerEntries_meineEhrenamtsbankEintraege {
  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege
  >
  get copyWith => CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<
  TRes
> {
  factory CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege instance,
    TRes Function(Query_MyVolunteerEntries_meineEhrenamtsbankEintraege) then,
  ) = _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege;

  factory CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege;

  TRes call({
    List<Fragment_VolunteerEntryData>? items,
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo? pageInfo,
    int? totalCount,
    String? $__typename,
  });
  TRes items(
    Iterable<Fragment_VolunteerEntryData>? Function(
      Iterable<
        CopyWith_Fragment_VolunteerEntryData<Fragment_VolunteerEntryData>
      >?,
    )
    _fn,
  );
  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo;
}

class _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes>
    implements
        CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes> {
  _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerEntries_meineEhrenamtsbankEintraege _instance;

  final TRes Function(Query_MyVolunteerEntries_meineEhrenamtsbankEintraege)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? pageInfo = _undefined,
    Object? totalCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
      items: items == _undefined
          ? _instance.items
          : (items as List<Fragment_VolunteerEntryData>?),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo
                as Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo),
      totalCount: totalCount == _undefined || totalCount == null
          ? _instance.totalCount
          : (totalCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Fragment_VolunteerEntryData>? Function(
      Iterable<
        CopyWith_Fragment_VolunteerEntryData<Fragment_VolunteerEntryData>
      >?,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items?.map(
        (e) => CopyWith_Fragment_VolunteerEntryData(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege(
    this._res,
  );

  TRes _res;

  call({
    List<Fragment_VolunteerEntryData>? items,
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo? pageInfo,
    int? totalCount,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;

  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<TRes>
  get pageInfo =>
      CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo.stub(
        _res,
      );
}

class Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo {
  Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo({
    required this.hasNextPage,
    this.$__typename = 'CollectionSegmentInfo',
  });

  factory Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
      hasNextPage: (l$hasNextPage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool hasNextPage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasNextPage = hasNextPage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$hasNextPage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
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

extension UtilityExtension_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo
    on Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo {
  CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
  TRes
> {
  factory CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo instance,
    TRes Function(Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo)
    then,
  ) = _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo;

  factory CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo;

  TRes call({bool? hasNextPage, String? $__typename});
}

class _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo _instance;

  final TRes Function(
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerEntries_meineEhrenamtsbankEintraege_pageInfo(
    this._res,
  );

  TRes _res;

  call({bool? hasNextPage, String? $__typename}) => _res;
}

class Variables_Mutation_CreateVolunteerRequest {
  factory Variables_Mutation_CreateVolunteerRequest({
    required Input_CreateEhrenamtsbankEintragInput input,
  }) => Variables_Mutation_CreateVolunteerRequest._({r'input': input});

  Variables_Mutation_CreateVolunteerRequest._(this._$data);

  factory Variables_Mutation_CreateVolunteerRequest.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_CreateEhrenamtsbankEintragInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_CreateVolunteerRequest._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_CreateEhrenamtsbankEintragInput get input =>
      (_$data['input'] as Input_CreateEhrenamtsbankEintragInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_CreateVolunteerRequest<
    Variables_Mutation_CreateVolunteerRequest
  >
  get copyWith =>
      CopyWith_Variables_Mutation_CreateVolunteerRequest(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_CreateVolunteerRequest ||
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

abstract class CopyWith_Variables_Mutation_CreateVolunteerRequest<TRes> {
  factory CopyWith_Variables_Mutation_CreateVolunteerRequest(
    Variables_Mutation_CreateVolunteerRequest instance,
    TRes Function(Variables_Mutation_CreateVolunteerRequest) then,
  ) = _CopyWithImpl_Variables_Mutation_CreateVolunteerRequest;

  factory CopyWith_Variables_Mutation_CreateVolunteerRequest.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_CreateVolunteerRequest;

  TRes call({Input_CreateEhrenamtsbankEintragInput? input});
}

class _CopyWithImpl_Variables_Mutation_CreateVolunteerRequest<TRes>
    implements CopyWith_Variables_Mutation_CreateVolunteerRequest<TRes> {
  _CopyWithImpl_Variables_Mutation_CreateVolunteerRequest(
    this._instance,
    this._then,
  );

  final Variables_Mutation_CreateVolunteerRequest _instance;

  final TRes Function(Variables_Mutation_CreateVolunteerRequest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_CreateVolunteerRequest._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_CreateEhrenamtsbankEintragInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_CreateVolunteerRequest<TRes>
    implements CopyWith_Variables_Mutation_CreateVolunteerRequest<TRes> {
  _CopyWithStubImpl_Variables_Mutation_CreateVolunteerRequest(this._res);

  TRes _res;

  call({Input_CreateEhrenamtsbankEintragInput? input}) => _res;
}

class Mutation_CreateVolunteerRequest {
  Mutation_CreateVolunteerRequest({
    required this.createEhrenamtsbankEintrag,
    this.$__typename = 'Mutation',
  });

  factory Mutation_CreateVolunteerRequest.fromJson(Map<String, dynamic> json) {
    final l$createEhrenamtsbankEintrag = json['createEhrenamtsbankEintrag'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerRequest(
      createEhrenamtsbankEintrag:
          Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag.fromJson(
            (l$createEhrenamtsbankEintrag as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag
  createEhrenamtsbankEintrag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createEhrenamtsbankEintrag = createEhrenamtsbankEintrag;
    _resultData['createEhrenamtsbankEintrag'] = l$createEhrenamtsbankEintrag
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createEhrenamtsbankEintrag = createEhrenamtsbankEintrag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createEhrenamtsbankEintrag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_CreateVolunteerRequest ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createEhrenamtsbankEintrag = createEhrenamtsbankEintrag;
    final lOther$createEhrenamtsbankEintrag = other.createEhrenamtsbankEintrag;
    if (l$createEhrenamtsbankEintrag != lOther$createEhrenamtsbankEintrag) {
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

extension UtilityExtension_Mutation_CreateVolunteerRequest
    on Mutation_CreateVolunteerRequest {
  CopyWith_Mutation_CreateVolunteerRequest<Mutation_CreateVolunteerRequest>
  get copyWith => CopyWith_Mutation_CreateVolunteerRequest(this, (i) => i);
}

abstract class CopyWith_Mutation_CreateVolunteerRequest<TRes> {
  factory CopyWith_Mutation_CreateVolunteerRequest(
    Mutation_CreateVolunteerRequest instance,
    TRes Function(Mutation_CreateVolunteerRequest) then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest;

  factory CopyWith_Mutation_CreateVolunteerRequest.stub(TRes res) =
      _CopyWithStubImpl_Mutation_CreateVolunteerRequest;

  TRes call({
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag?
    createEhrenamtsbankEintrag,
    String? $__typename,
  });
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<TRes>
  get createEhrenamtsbankEintrag;
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest<TRes>
    implements CopyWith_Mutation_CreateVolunteerRequest<TRes> {
  _CopyWithImpl_Mutation_CreateVolunteerRequest(this._instance, this._then);

  final Mutation_CreateVolunteerRequest _instance;

  final TRes Function(Mutation_CreateVolunteerRequest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createEhrenamtsbankEintrag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerRequest(
      createEhrenamtsbankEintrag:
          createEhrenamtsbankEintrag == _undefined ||
              createEhrenamtsbankEintrag == null
          ? _instance.createEhrenamtsbankEintrag
          : (createEhrenamtsbankEintrag
                as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<TRes>
  get createEhrenamtsbankEintrag {
    final local$createEhrenamtsbankEintrag =
        _instance.createEhrenamtsbankEintrag;
    return CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
      local$createEhrenamtsbankEintrag,
      (e) => call(createEhrenamtsbankEintrag: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest<TRes>
    implements CopyWith_Mutation_CreateVolunteerRequest<TRes> {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest(this._res);

  TRes _res;

  call({
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag?
    createEhrenamtsbankEintrag,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<TRes>
  get createEhrenamtsbankEintrag =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag.stub(
        _res,
      );
}

const documentNodeMutationCreateVolunteerRequest = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateVolunteerRequest'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CreateEhrenamtsbankEintragInput'),
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
            name: NameNode(value: 'createEhrenamtsbankEintrag'),
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
                  name: NameNode(value: 'ehrenamtsbankEintrag'),
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
                        name: NameNode(value: 'status'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_CreateVolunteerRequest _parserFn_Mutation_CreateVolunteerRequest(
  Map<String, dynamic> data,
) => Mutation_CreateVolunteerRequest.fromJson(data);
typedef OnMutationCompleted_Mutation_CreateVolunteerRequest =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_CreateVolunteerRequest?,
    );

class Options_Mutation_CreateVolunteerRequest
    extends graphql.MutationOptions<Mutation_CreateVolunteerRequest> {
  Options_Mutation_CreateVolunteerRequest({
    String? operationName,
    required Variables_Mutation_CreateVolunteerRequest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerRequest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_CreateVolunteerRequest? onCompleted,
    graphql.OnMutationUpdate<Mutation_CreateVolunteerRequest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_CreateVolunteerRequest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationCreateVolunteerRequest,
         parserFn: _parserFn_Mutation_CreateVolunteerRequest,
       );

  final OnMutationCompleted_Mutation_CreateVolunteerRequest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_CreateVolunteerRequest
    extends graphql.WatchQueryOptions<Mutation_CreateVolunteerRequest> {
  WatchOptions_Mutation_CreateVolunteerRequest({
    String? operationName,
    required Variables_Mutation_CreateVolunteerRequest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerRequest? typedOptimisticResult,
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
         document: documentNodeMutationCreateVolunteerRequest,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_CreateVolunteerRequest,
       );
}

extension ClientExtension_Mutation_CreateVolunteerRequest
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_CreateVolunteerRequest>>
  mutate_CreateVolunteerRequest(
    Options_Mutation_CreateVolunteerRequest options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_CreateVolunteerRequest>
  watchMutation_CreateVolunteerRequest(
    WatchOptions_Mutation_CreateVolunteerRequest options,
  ) => this.watchMutation(options);
}

class Mutation_CreateVolunteerRequest_HookResult {
  Mutation_CreateVolunteerRequest_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_CreateVolunteerRequest runMutation;

  final graphql.QueryResult<Mutation_CreateVolunteerRequest> result;
}

Mutation_CreateVolunteerRequest_HookResult useMutation_CreateVolunteerRequest([
  WidgetOptions_Mutation_CreateVolunteerRequest? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_CreateVolunteerRequest(),
  );
  return Mutation_CreateVolunteerRequest_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_CreateVolunteerRequest>
useWatchMutation_CreateVolunteerRequest(
  WatchOptions_Mutation_CreateVolunteerRequest options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_CreateVolunteerRequest
    extends graphql.MutationOptions<Mutation_CreateVolunteerRequest> {
  WidgetOptions_Mutation_CreateVolunteerRequest({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerRequest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_CreateVolunteerRequest? onCompleted,
    graphql.OnMutationUpdate<Mutation_CreateVolunteerRequest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_CreateVolunteerRequest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationCreateVolunteerRequest,
         parserFn: _parserFn_Mutation_CreateVolunteerRequest,
       );

  final OnMutationCompleted_Mutation_CreateVolunteerRequest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_CreateVolunteerRequest =
    graphql.MultiSourceResult<Mutation_CreateVolunteerRequest> Function(
      Variables_Mutation_CreateVolunteerRequest, {
      Object? optimisticResult,
      Mutation_CreateVolunteerRequest? typedOptimisticResult,
    });
typedef Builder_Mutation_CreateVolunteerRequest =
    widgets.Widget Function(
      RunMutation_Mutation_CreateVolunteerRequest,
      graphql.QueryResult<Mutation_CreateVolunteerRequest>?,
    );

class Mutation_CreateVolunteerRequest_Widget
    extends graphql_flutter.Mutation<Mutation_CreateVolunteerRequest> {
  Mutation_CreateVolunteerRequest_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_CreateVolunteerRequest? options,
    required Builder_Mutation_CreateVolunteerRequest builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_CreateVolunteerRequest(),
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

class Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag {
  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag({
    this.ehrenamtsbankEintrag,
    this.errors,
    this.$__typename = 'CreateEhrenamtsbankEintragPayload',
  });

  factory Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankEintrag = json['ehrenamtsbankEintrag'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
      ehrenamtsbankEintrag: l$ehrenamtsbankEintrag == null
          ? null
          : Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag.fromJson(
              (l$ehrenamtsbankEintrag as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag?
  ehrenamtsbankEintrag;

  final List<Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors>?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    _resultData['ehrenamtsbankEintrag'] = l$ehrenamtsbankEintrag?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankEintrag,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final lOther$ehrenamtsbankEintrag = other.ehrenamtsbankEintrag;
    if (l$ehrenamtsbankEintrag != lOther$ehrenamtsbankEintrag) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag
    on Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag {
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag instance,
    TRes Function(Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag)
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag;

  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag;

  TRes call({
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag?
    ehrenamtsbankEintrag,
    List<Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors>?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag;
  TRes errors(
    Iterable<Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors>?
    Function(
      Iterable<
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
          Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag _instance;

  final TRes Function(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankEintrag = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
      ehrenamtsbankEintrag: ehrenamtsbankEintrag == _undefined
          ? _instance.ehrenamtsbankEintrag
          : (ehrenamtsbankEintrag
                as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag {
    final local$ehrenamtsbankEintrag = _instance.ehrenamtsbankEintrag;
    return local$ehrenamtsbankEintrag == null
        ? CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
            local$ehrenamtsbankEintrag,
            (e) => call(ehrenamtsbankEintrag: e),
          );
  }

  TRes errors(
    Iterable<Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors>?
    Function(
      Iterable<
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
          Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag(
    this._res,
  );

  TRes _res;

  call({
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag?
    ehrenamtsbankEintrag,
    List<Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors>?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag {
  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag({
    required this.id,
    required this.status,
    this.$__typename = 'EhrenamtsbankEintrag',
  });

  factory Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankEintragStatus((l$status as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankEintragStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankEintragStatus(l$status);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$status, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
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

extension UtilityExtension_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag
    on
        Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag {
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag
    instance,
    TRes Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag;

  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag;

  TRes call({
    String? id,
    Enum_EhrenamtsbankEintragStatus? status,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankEintragStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_ehrenamtsbankEintrag(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankEintragStatus? status,
    String? $__typename,
  }) => _res;
}

class Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors {
  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors({
    required this.$__typename,
  });

  factory Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "EintragValidationError":
        return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
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
    if (other
            is! Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors ||
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

extension UtilityExtension_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
    on Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors {
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
    )
    eintragValidationError,
    required _T Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "EintragValidationError":
        return eintragValidationError(
          this
              as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
    )?
    eintragValidationError,
    _T Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
    )?
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "EintragValidationError":
        if (eintragValidationError != null) {
          return eintragValidationError(
            this
                as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors instance,
    TRes Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors;

  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError
    implements
        Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors {
  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError({
    required this.message,
    this.$__typename = 'EintragValidationError',
  });

  factory Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError
    on
        Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError {
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError
    instance,
    TRes Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError;

  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__EintragValidationError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError
    implements
        Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors {
  Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError
    on
        Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError {
  CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError;

  factory CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerRequest_createEhrenamtsbankEintrag_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Variables_Mutation_SubmitVolunteerRequest {
  factory Variables_Mutation_SubmitVolunteerRequest({
    required Input_UpdateEhrenamtsbankEintragStatusInput input,
  }) => Variables_Mutation_SubmitVolunteerRequest._({r'input': input});

  Variables_Mutation_SubmitVolunteerRequest._(this._$data);

  factory Variables_Mutation_SubmitVolunteerRequest.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_UpdateEhrenamtsbankEintragStatusInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_SubmitVolunteerRequest._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_UpdateEhrenamtsbankEintragStatusInput get input =>
      (_$data['input'] as Input_UpdateEhrenamtsbankEintragStatusInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_SubmitVolunteerRequest<
    Variables_Mutation_SubmitVolunteerRequest
  >
  get copyWith =>
      CopyWith_Variables_Mutation_SubmitVolunteerRequest(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_SubmitVolunteerRequest ||
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

abstract class CopyWith_Variables_Mutation_SubmitVolunteerRequest<TRes> {
  factory CopyWith_Variables_Mutation_SubmitVolunteerRequest(
    Variables_Mutation_SubmitVolunteerRequest instance,
    TRes Function(Variables_Mutation_SubmitVolunteerRequest) then,
  ) = _CopyWithImpl_Variables_Mutation_SubmitVolunteerRequest;

  factory CopyWith_Variables_Mutation_SubmitVolunteerRequest.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_SubmitVolunteerRequest;

  TRes call({Input_UpdateEhrenamtsbankEintragStatusInput? input});
}

class _CopyWithImpl_Variables_Mutation_SubmitVolunteerRequest<TRes>
    implements CopyWith_Variables_Mutation_SubmitVolunteerRequest<TRes> {
  _CopyWithImpl_Variables_Mutation_SubmitVolunteerRequest(
    this._instance,
    this._then,
  );

  final Variables_Mutation_SubmitVolunteerRequest _instance;

  final TRes Function(Variables_Mutation_SubmitVolunteerRequest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_SubmitVolunteerRequest._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_UpdateEhrenamtsbankEintragStatusInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_SubmitVolunteerRequest<TRes>
    implements CopyWith_Variables_Mutation_SubmitVolunteerRequest<TRes> {
  _CopyWithStubImpl_Variables_Mutation_SubmitVolunteerRequest(this._res);

  TRes _res;

  call({Input_UpdateEhrenamtsbankEintragStatusInput? input}) => _res;
}

class Mutation_SubmitVolunteerRequest {
  Mutation_SubmitVolunteerRequest({
    required this.updateEhrenamtsbankEintragStatus,
    this.$__typename = 'Mutation',
  });

  factory Mutation_SubmitVolunteerRequest.fromJson(Map<String, dynamic> json) {
    final l$updateEhrenamtsbankEintragStatus =
        json['updateEhrenamtsbankEintragStatus'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest(
      updateEhrenamtsbankEintragStatus:
          Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus.fromJson(
            (l$updateEhrenamtsbankEintragStatus as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus
  updateEhrenamtsbankEintragStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateEhrenamtsbankEintragStatus = updateEhrenamtsbankEintragStatus;
    _resultData['updateEhrenamtsbankEintragStatus'] =
        l$updateEhrenamtsbankEintragStatus.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateEhrenamtsbankEintragStatus = updateEhrenamtsbankEintragStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateEhrenamtsbankEintragStatus, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_SubmitVolunteerRequest ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateEhrenamtsbankEintragStatus = updateEhrenamtsbankEintragStatus;
    final lOther$updateEhrenamtsbankEintragStatus =
        other.updateEhrenamtsbankEintragStatus;
    if (l$updateEhrenamtsbankEintragStatus !=
        lOther$updateEhrenamtsbankEintragStatus) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest
    on Mutation_SubmitVolunteerRequest {
  CopyWith_Mutation_SubmitVolunteerRequest<Mutation_SubmitVolunteerRequest>
  get copyWith => CopyWith_Mutation_SubmitVolunteerRequest(this, (i) => i);
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest<TRes> {
  factory CopyWith_Mutation_SubmitVolunteerRequest(
    Mutation_SubmitVolunteerRequest instance,
    TRes Function(Mutation_SubmitVolunteerRequest) then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest;

  factory CopyWith_Mutation_SubmitVolunteerRequest.stub(TRes res) =
      _CopyWithStubImpl_Mutation_SubmitVolunteerRequest;

  TRes call({
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus?
    updateEhrenamtsbankEintragStatus,
    String? $__typename,
  });
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
    TRes
  >
  get updateEhrenamtsbankEintragStatus;
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest<TRes>
    implements CopyWith_Mutation_SubmitVolunteerRequest<TRes> {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest(this._instance, this._then);

  final Mutation_SubmitVolunteerRequest _instance;

  final TRes Function(Mutation_SubmitVolunteerRequest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateEhrenamtsbankEintragStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest(
      updateEhrenamtsbankEintragStatus:
          updateEhrenamtsbankEintragStatus == _undefined ||
              updateEhrenamtsbankEintragStatus == null
          ? _instance.updateEhrenamtsbankEintragStatus
          : (updateEhrenamtsbankEintragStatus
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
    TRes
  >
  get updateEhrenamtsbankEintragStatus {
    final local$updateEhrenamtsbankEintragStatus =
        _instance.updateEhrenamtsbankEintragStatus;
    return CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
      local$updateEhrenamtsbankEintragStatus,
      (e) => call(updateEhrenamtsbankEintragStatus: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest<TRes>
    implements CopyWith_Mutation_SubmitVolunteerRequest<TRes> {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest(this._res);

  TRes _res;

  call({
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus?
    updateEhrenamtsbankEintragStatus,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
    TRes
  >
  get updateEhrenamtsbankEintragStatus =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus.stub(
        _res,
      );
}

const documentNodeMutationSubmitVolunteerRequest = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SubmitVolunteerRequest'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateEhrenamtsbankEintragStatusInput'),
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
            name: NameNode(value: 'updateEhrenamtsbankEintragStatus'),
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
                  name: NameNode(value: 'ehrenamtsbankEintrag'),
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
                        name: NameNode(value: 'status'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_SubmitVolunteerRequest _parserFn_Mutation_SubmitVolunteerRequest(
  Map<String, dynamic> data,
) => Mutation_SubmitVolunteerRequest.fromJson(data);
typedef OnMutationCompleted_Mutation_SubmitVolunteerRequest =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_SubmitVolunteerRequest?,
    );

class Options_Mutation_SubmitVolunteerRequest
    extends graphql.MutationOptions<Mutation_SubmitVolunteerRequest> {
  Options_Mutation_SubmitVolunteerRequest({
    String? operationName,
    required Variables_Mutation_SubmitVolunteerRequest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_SubmitVolunteerRequest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_SubmitVolunteerRequest? onCompleted,
    graphql.OnMutationUpdate<Mutation_SubmitVolunteerRequest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_SubmitVolunteerRequest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSubmitVolunteerRequest,
         parserFn: _parserFn_Mutation_SubmitVolunteerRequest,
       );

  final OnMutationCompleted_Mutation_SubmitVolunteerRequest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_SubmitVolunteerRequest
    extends graphql.WatchQueryOptions<Mutation_SubmitVolunteerRequest> {
  WatchOptions_Mutation_SubmitVolunteerRequest({
    String? operationName,
    required Variables_Mutation_SubmitVolunteerRequest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_SubmitVolunteerRequest? typedOptimisticResult,
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
         document: documentNodeMutationSubmitVolunteerRequest,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_SubmitVolunteerRequest,
       );
}

extension ClientExtension_Mutation_SubmitVolunteerRequest
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_SubmitVolunteerRequest>>
  mutate_SubmitVolunteerRequest(
    Options_Mutation_SubmitVolunteerRequest options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_SubmitVolunteerRequest>
  watchMutation_SubmitVolunteerRequest(
    WatchOptions_Mutation_SubmitVolunteerRequest options,
  ) => this.watchMutation(options);
}

class Mutation_SubmitVolunteerRequest_HookResult {
  Mutation_SubmitVolunteerRequest_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_SubmitVolunteerRequest runMutation;

  final graphql.QueryResult<Mutation_SubmitVolunteerRequest> result;
}

Mutation_SubmitVolunteerRequest_HookResult useMutation_SubmitVolunteerRequest([
  WidgetOptions_Mutation_SubmitVolunteerRequest? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_SubmitVolunteerRequest(),
  );
  return Mutation_SubmitVolunteerRequest_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_SubmitVolunteerRequest>
useWatchMutation_SubmitVolunteerRequest(
  WatchOptions_Mutation_SubmitVolunteerRequest options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_SubmitVolunteerRequest
    extends graphql.MutationOptions<Mutation_SubmitVolunteerRequest> {
  WidgetOptions_Mutation_SubmitVolunteerRequest({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_SubmitVolunteerRequest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_SubmitVolunteerRequest? onCompleted,
    graphql.OnMutationUpdate<Mutation_SubmitVolunteerRequest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_SubmitVolunteerRequest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSubmitVolunteerRequest,
         parserFn: _parserFn_Mutation_SubmitVolunteerRequest,
       );

  final OnMutationCompleted_Mutation_SubmitVolunteerRequest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_SubmitVolunteerRequest =
    graphql.MultiSourceResult<Mutation_SubmitVolunteerRequest> Function(
      Variables_Mutation_SubmitVolunteerRequest, {
      Object? optimisticResult,
      Mutation_SubmitVolunteerRequest? typedOptimisticResult,
    });
typedef Builder_Mutation_SubmitVolunteerRequest =
    widgets.Widget Function(
      RunMutation_Mutation_SubmitVolunteerRequest,
      graphql.QueryResult<Mutation_SubmitVolunteerRequest>?,
    );

class Mutation_SubmitVolunteerRequest_Widget
    extends graphql_flutter.Mutation<Mutation_SubmitVolunteerRequest> {
  Mutation_SubmitVolunteerRequest_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_SubmitVolunteerRequest? options,
    required Builder_Mutation_SubmitVolunteerRequest builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_SubmitVolunteerRequest(),
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

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus({
    this.ehrenamtsbankEintrag,
    this.errors,
    this.$__typename = 'UpdateEhrenamtsbankEintragStatusPayload',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankEintrag = json['ehrenamtsbankEintrag'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
      ehrenamtsbankEintrag: l$ehrenamtsbankEintrag == null
          ? null
          : Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag.fromJson(
              (l$ehrenamtsbankEintrag as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag?
  ehrenamtsbankEintrag;

  final List<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    _resultData['ehrenamtsbankEintrag'] = l$ehrenamtsbankEintrag?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankEintrag,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankEintrag = ehrenamtsbankEintrag;
    final lOther$ehrenamtsbankEintrag = other.ehrenamtsbankEintrag;
    if (l$ehrenamtsbankEintrag != lOther$ehrenamtsbankEintrag) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus
    on Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus;

  TRes call({
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag?
    ehrenamtsbankEintrag,
    List<
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    >?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag;
  TRes errors(
    Iterable<
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
          Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankEintrag = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
      ehrenamtsbankEintrag: ehrenamtsbankEintrag == _undefined
          ? _instance.ehrenamtsbankEintrag
          : (ehrenamtsbankEintrag
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag {
    final local$ehrenamtsbankEintrag = _instance.ehrenamtsbankEintrag;
    return local$ehrenamtsbankEintrag == null
        ? CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
            local$ehrenamtsbankEintrag,
            (e) => call(ehrenamtsbankEintrag: e),
          );
  }

  TRes errors(
    Iterable<
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
          Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus(
    this._res,
  );

  TRes _res;

  call({
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag?
    ehrenamtsbankEintrag,
    List<
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    >?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
    TRes
  >
  get ehrenamtsbankEintrag =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag({
    required this.id,
    required this.status,
    this.$__typename = 'EhrenamtsbankEintrag',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankEintragStatus((l$status as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankEintragStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankEintragStatus(l$status);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$status, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag
    on
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag;

  TRes call({
    String? id,
    Enum_EhrenamtsbankEintragStatus? status,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankEintragStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_ehrenamtsbankEintrag(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankEintragStatus? status,
    String? $__typename,
  }) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors({
    required this.$__typename,
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "EintragConflictError":
        return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError.fromJson(
          json,
        );

      case "EintragNotFoundError":
        return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError.fromJson(
          json,
        );

      case "EintragStatusTransitionError":
        return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
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
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors ||
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    on Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
    )
    eintragConflictError,
    required _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
    )
    eintragNotFoundError,
    required _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
    )
    eintragStatusTransitionError,
    required _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "EintragConflictError":
        return eintragConflictError(
          this
              as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
        );

      case "EintragNotFoundError":
        return eintragNotFoundError(
          this
              as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
        );

      case "EintragStatusTransitionError":
        return eintragStatusTransitionError(
          this
              as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
    )?
    eintragConflictError,
    _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
    )?
    eintragNotFoundError,
    _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
    )?
    eintragStatusTransitionError,
    _T Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
    )?
    notAllowedError,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "EintragConflictError":
        if (eintragConflictError != null) {
          return eintragConflictError(
            this
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
          );
        } else {
          return orElse();
        }

      case "EintragNotFoundError":
        if (eintragNotFoundError != null) {
          return eintragNotFoundError(
            this
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
          );
        } else {
          return orElse();
        }

      case "EintragStatusTransitionError":
        if (eintragStatusTransitionError != null) {
          return eintragStatusTransitionError(
            this
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError
    implements
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError({
    required this.message,
    this.$__typename = 'EintragConflictError',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError
    on
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragConflictError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError
    implements
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError({
    required this.message,
    this.$__typename = 'EintragNotFoundError',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError
    on
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError
    implements
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError({
    required this.message,
    this.$__typename = 'EintragStatusTransitionError',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError
    on
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__EintragStatusTransitionError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError
    implements
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors {
  Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError
    on
        Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError {
  CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError;

  factory CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_SubmitVolunteerRequest_updateEhrenamtsbankEintragStatus_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Variables_Mutation_CreateVolunteerInterest {
  factory Variables_Mutation_CreateVolunteerInterest({
    required Input_CreateEhrenamtsbankAnfrageInput input,
  }) => Variables_Mutation_CreateVolunteerInterest._({r'input': input});

  Variables_Mutation_CreateVolunteerInterest._(this._$data);

  factory Variables_Mutation_CreateVolunteerInterest.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_CreateEhrenamtsbankAnfrageInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_CreateVolunteerInterest._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_CreateEhrenamtsbankAnfrageInput get input =>
      (_$data['input'] as Input_CreateEhrenamtsbankAnfrageInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_CreateVolunteerInterest<
    Variables_Mutation_CreateVolunteerInterest
  >
  get copyWith =>
      CopyWith_Variables_Mutation_CreateVolunteerInterest(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_CreateVolunteerInterest ||
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

abstract class CopyWith_Variables_Mutation_CreateVolunteerInterest<TRes> {
  factory CopyWith_Variables_Mutation_CreateVolunteerInterest(
    Variables_Mutation_CreateVolunteerInterest instance,
    TRes Function(Variables_Mutation_CreateVolunteerInterest) then,
  ) = _CopyWithImpl_Variables_Mutation_CreateVolunteerInterest;

  factory CopyWith_Variables_Mutation_CreateVolunteerInterest.stub(TRes res) =
      _CopyWithStubImpl_Variables_Mutation_CreateVolunteerInterest;

  TRes call({Input_CreateEhrenamtsbankAnfrageInput? input});
}

class _CopyWithImpl_Variables_Mutation_CreateVolunteerInterest<TRes>
    implements CopyWith_Variables_Mutation_CreateVolunteerInterest<TRes> {
  _CopyWithImpl_Variables_Mutation_CreateVolunteerInterest(
    this._instance,
    this._then,
  );

  final Variables_Mutation_CreateVolunteerInterest _instance;

  final TRes Function(Variables_Mutation_CreateVolunteerInterest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_CreateVolunteerInterest._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_CreateEhrenamtsbankAnfrageInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_CreateVolunteerInterest<TRes>
    implements CopyWith_Variables_Mutation_CreateVolunteerInterest<TRes> {
  _CopyWithStubImpl_Variables_Mutation_CreateVolunteerInterest(this._res);

  TRes _res;

  call({Input_CreateEhrenamtsbankAnfrageInput? input}) => _res;
}

class Mutation_CreateVolunteerInterest {
  Mutation_CreateVolunteerInterest({
    required this.createEhrenamtsbankAnfrage,
    this.$__typename = 'Mutation',
  });

  factory Mutation_CreateVolunteerInterest.fromJson(Map<String, dynamic> json) {
    final l$createEhrenamtsbankAnfrage = json['createEhrenamtsbankAnfrage'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest(
      createEhrenamtsbankAnfrage:
          Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage.fromJson(
            (l$createEhrenamtsbankAnfrage as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage
  createEhrenamtsbankAnfrage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createEhrenamtsbankAnfrage = createEhrenamtsbankAnfrage;
    _resultData['createEhrenamtsbankAnfrage'] = l$createEhrenamtsbankAnfrage
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createEhrenamtsbankAnfrage = createEhrenamtsbankAnfrage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createEhrenamtsbankAnfrage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_CreateVolunteerInterest ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createEhrenamtsbankAnfrage = createEhrenamtsbankAnfrage;
    final lOther$createEhrenamtsbankAnfrage = other.createEhrenamtsbankAnfrage;
    if (l$createEhrenamtsbankAnfrage != lOther$createEhrenamtsbankAnfrage) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest
    on Mutation_CreateVolunteerInterest {
  CopyWith_Mutation_CreateVolunteerInterest<Mutation_CreateVolunteerInterest>
  get copyWith => CopyWith_Mutation_CreateVolunteerInterest(this, (i) => i);
}

abstract class CopyWith_Mutation_CreateVolunteerInterest<TRes> {
  factory CopyWith_Mutation_CreateVolunteerInterest(
    Mutation_CreateVolunteerInterest instance,
    TRes Function(Mutation_CreateVolunteerInterest) then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest;

  factory CopyWith_Mutation_CreateVolunteerInterest.stub(TRes res) =
      _CopyWithStubImpl_Mutation_CreateVolunteerInterest;

  TRes call({
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage?
    createEhrenamtsbankAnfrage,
    String? $__typename,
  });
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<TRes>
  get createEhrenamtsbankAnfrage;
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest<TRes>
    implements CopyWith_Mutation_CreateVolunteerInterest<TRes> {
  _CopyWithImpl_Mutation_CreateVolunteerInterest(this._instance, this._then);

  final Mutation_CreateVolunteerInterest _instance;

  final TRes Function(Mutation_CreateVolunteerInterest) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createEhrenamtsbankAnfrage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest(
      createEhrenamtsbankAnfrage:
          createEhrenamtsbankAnfrage == _undefined ||
              createEhrenamtsbankAnfrage == null
          ? _instance.createEhrenamtsbankAnfrage
          : (createEhrenamtsbankAnfrage
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<TRes>
  get createEhrenamtsbankAnfrage {
    final local$createEhrenamtsbankAnfrage =
        _instance.createEhrenamtsbankAnfrage;
    return CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
      local$createEhrenamtsbankAnfrage,
      (e) => call(createEhrenamtsbankAnfrage: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest<TRes>
    implements CopyWith_Mutation_CreateVolunteerInterest<TRes> {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest(this._res);

  TRes _res;

  call({
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage?
    createEhrenamtsbankAnfrage,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<TRes>
  get createEhrenamtsbankAnfrage =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage.stub(
        _res,
      );
}

const documentNodeMutationCreateVolunteerInterest = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateVolunteerInterest'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CreateEhrenamtsbankAnfrageInput'),
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
            name: NameNode(value: 'createEhrenamtsbankAnfrage'),
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
                  name: NameNode(value: 'ehrenamtsbankAnfrage'),
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
                        name: NameNode(value: 'status'),
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
                        name: NameNode(value: 'createdAt'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_CreateVolunteerInterest _parserFn_Mutation_CreateVolunteerInterest(
  Map<String, dynamic> data,
) => Mutation_CreateVolunteerInterest.fromJson(data);
typedef OnMutationCompleted_Mutation_CreateVolunteerInterest =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_CreateVolunteerInterest?,
    );

class Options_Mutation_CreateVolunteerInterest
    extends graphql.MutationOptions<Mutation_CreateVolunteerInterest> {
  Options_Mutation_CreateVolunteerInterest({
    String? operationName,
    required Variables_Mutation_CreateVolunteerInterest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerInterest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_CreateVolunteerInterest? onCompleted,
    graphql.OnMutationUpdate<Mutation_CreateVolunteerInterest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_CreateVolunteerInterest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationCreateVolunteerInterest,
         parserFn: _parserFn_Mutation_CreateVolunteerInterest,
       );

  final OnMutationCompleted_Mutation_CreateVolunteerInterest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_CreateVolunteerInterest
    extends graphql.WatchQueryOptions<Mutation_CreateVolunteerInterest> {
  WatchOptions_Mutation_CreateVolunteerInterest({
    String? operationName,
    required Variables_Mutation_CreateVolunteerInterest variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerInterest? typedOptimisticResult,
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
         document: documentNodeMutationCreateVolunteerInterest,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_CreateVolunteerInterest,
       );
}

extension ClientExtension_Mutation_CreateVolunteerInterest
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_CreateVolunteerInterest>>
  mutate_CreateVolunteerInterest(
    Options_Mutation_CreateVolunteerInterest options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_CreateVolunteerInterest>
  watchMutation_CreateVolunteerInterest(
    WatchOptions_Mutation_CreateVolunteerInterest options,
  ) => this.watchMutation(options);
}

class Mutation_CreateVolunteerInterest_HookResult {
  Mutation_CreateVolunteerInterest_HookResult(this.runMutation, this.result);

  final RunMutation_Mutation_CreateVolunteerInterest runMutation;

  final graphql.QueryResult<Mutation_CreateVolunteerInterest> result;
}

Mutation_CreateVolunteerInterest_HookResult
useMutation_CreateVolunteerInterest([
  WidgetOptions_Mutation_CreateVolunteerInterest? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_CreateVolunteerInterest(),
  );
  return Mutation_CreateVolunteerInterest_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_CreateVolunteerInterest>
useWatchMutation_CreateVolunteerInterest(
  WatchOptions_Mutation_CreateVolunteerInterest options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_CreateVolunteerInterest
    extends graphql.MutationOptions<Mutation_CreateVolunteerInterest> {
  WidgetOptions_Mutation_CreateVolunteerInterest({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_CreateVolunteerInterest? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_CreateVolunteerInterest? onCompleted,
    graphql.OnMutationUpdate<Mutation_CreateVolunteerInterest>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_CreateVolunteerInterest(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationCreateVolunteerInterest,
         parserFn: _parserFn_Mutation_CreateVolunteerInterest,
       );

  final OnMutationCompleted_Mutation_CreateVolunteerInterest?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_CreateVolunteerInterest =
    graphql.MultiSourceResult<Mutation_CreateVolunteerInterest> Function(
      Variables_Mutation_CreateVolunteerInterest, {
      Object? optimisticResult,
      Mutation_CreateVolunteerInterest? typedOptimisticResult,
    });
typedef Builder_Mutation_CreateVolunteerInterest =
    widgets.Widget Function(
      RunMutation_Mutation_CreateVolunteerInterest,
      graphql.QueryResult<Mutation_CreateVolunteerInterest>?,
    );

class Mutation_CreateVolunteerInterest_Widget
    extends graphql_flutter.Mutation<Mutation_CreateVolunteerInterest> {
  Mutation_CreateVolunteerInterest_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_CreateVolunteerInterest? options,
    required Builder_Mutation_CreateVolunteerInterest builder,
  }) : super(
         key: key,
         options: options ?? WidgetOptions_Mutation_CreateVolunteerInterest(),
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

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage({
    this.ehrenamtsbankAnfrage,
    this.errors,
    this.$__typename = 'CreateEhrenamtsbankAnfragePayload',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankAnfrage = json['ehrenamtsbankAnfrage'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
      ehrenamtsbankAnfrage: l$ehrenamtsbankAnfrage == null
          ? null
          : Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage.fromJson(
              (l$ehrenamtsbankAnfrage as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage?
  ehrenamtsbankAnfrage;

  final List<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    _resultData['ehrenamtsbankAnfrage'] = l$ehrenamtsbankAnfrage?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankAnfrage,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final lOther$ehrenamtsbankAnfrage = other.ehrenamtsbankAnfrage;
    if (l$ehrenamtsbankAnfrage != lOther$ehrenamtsbankAnfrage) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage
    on Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage instance,
    TRes Function(Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage)
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage;

  TRes call({
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors>?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage;
  TRes errors(
    Iterable<
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
          Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankAnfrage = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
      ehrenamtsbankAnfrage: ehrenamtsbankAnfrage == _undefined
          ? _instance.ehrenamtsbankAnfrage
          : (ehrenamtsbankAnfrage
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage {
    final local$ehrenamtsbankAnfrage = _instance.ehrenamtsbankAnfrage;
    return local$ehrenamtsbankAnfrage == null
        ? CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
            local$ehrenamtsbankAnfrage,
            (e) => call(ehrenamtsbankAnfrage: e),
          );
  }

  TRes errors(
    Iterable<
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
          Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage(
    this._res,
  );

  TRes _res;

  call({
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors>?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage({
    required this.id,
    required this.status,
    this.nachricht,
    required this.createdAt,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$nachricht = json['nachricht'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      nachricht: (l$nachricht as String?),
      createdAt: DateTime.parse((l$createdAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final String? nachricht;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$nachricht = nachricht;
    _resultData['nachricht'] = l$nachricht;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$nachricht = nachricht;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$nachricht,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$nachricht = nachricht;
    final lOther$nachricht = other.nachricht;
    if (l$nachricht != lOther$nachricht) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage;

  TRes call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    String? nachricht,
    DateTime? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? nachricht = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_ehrenamtsbankAnfrage(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    String? nachricht,
    DateTime? createdAt,
    String? $__typename,
  }) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors({
    required this.$__typename,
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "AnfrageForItselfError":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError.fromJson(
          json,
        );

      case "EintragNotActiveError":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError.fromJson(
          json,
        );

      case "EintragNotFoundError":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError.fromJson(
          json,
        );

      case "MultipleAnfrageError":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError.fromJson(
          json,
        );

      case "Unauthenticated":
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
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
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors ||
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
    on Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
    )
    anfrageForItselfError,
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
    )
    eintragNotActiveError,
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
    )
    eintragNotFoundError,
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
    )
    multipleAnfrageError,
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
    )
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AnfrageForItselfError":
        return anfrageForItselfError(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
        );

      case "EintragNotActiveError":
        return eintragNotActiveError(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
        );

      case "EintragNotFoundError":
        return eintragNotFoundError(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
        );

      case "MultipleAnfrageError":
        return multipleAnfrageError(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
        );

      case "Unauthenticated":
        return unauthenticated(
          this
              as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
    )?
    anfrageForItselfError,
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
    )?
    eintragNotActiveError,
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
    )?
    eintragNotFoundError,
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
    )?
    multipleAnfrageError,
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
    )?
    notAllowedError,
    _T Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
    )?
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AnfrageForItselfError":
        if (anfrageForItselfError != null) {
          return anfrageForItselfError(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
          );
        } else {
          return orElse();
        }

      case "EintragNotActiveError":
        if (eintragNotActiveError != null) {
          return eintragNotActiveError(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
          );
        } else {
          return orElse();
        }

      case "EintragNotFoundError":
        if (eintragNotFoundError != null) {
          return eintragNotFoundError(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
          );
        } else {
          return orElse();
        }

      case "MultipleAnfrageError":
        if (multipleAnfrageError != null) {
          return multipleAnfrageError(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      case "Unauthenticated":
        if (unauthenticated != null) {
          return unauthenticated(
            this
                as Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError({
    required this.message,
    this.$__typename = 'AnfrageForItselfError',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__AnfrageForItselfError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError({
    required this.message,
    this.$__typename = 'EintragNotActiveError',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotActiveError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError({
    required this.message,
    this.$__typename = 'EintragNotFoundError',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__EintragNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError({
    required this.message,
    this.$__typename = 'MultipleAnfrageError',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__MultipleAnfrageError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated
    implements
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors {
  Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated({
    required this.message,
    this.$__typename = 'Unauthenticated',
  });

  factory Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated
    on
        Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated {
  CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated
  >
  get copyWith =>
      CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
  TRes
> {
  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated
    instance,
    TRes Function(
      Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
    )
    then,
  ) = _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated;

  factory CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
          TRes
        > {
  _CopyWithImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
    this._instance,
    this._then,
  );

  final Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated
  _instance;

  final TRes Function(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated<
          TRes
        > {
  _CopyWithStubImpl_Mutation_CreateVolunteerInterest_createEhrenamtsbankAnfrage_errors__Unauthenticated(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Variables_Mutation_UpdateVolunteerInterestStatus {
  factory Variables_Mutation_UpdateVolunteerInterestStatus({
    required Input_UpdateEhrenamtsbankAnfrageStatusInput input,
  }) => Variables_Mutation_UpdateVolunteerInterestStatus._({r'input': input});

  Variables_Mutation_UpdateVolunteerInterestStatus._(this._$data);

  factory Variables_Mutation_UpdateVolunteerInterestStatus.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_UpdateEhrenamtsbankAnfrageStatusInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_UpdateVolunteerInterestStatus._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_UpdateEhrenamtsbankAnfrageStatusInput get input =>
      (_$data['input'] as Input_UpdateEhrenamtsbankAnfrageStatusInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus<
    Variables_Mutation_UpdateVolunteerInterestStatus
  >
  get copyWith =>
      CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_UpdateVolunteerInterestStatus ||
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

abstract class CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus<TRes> {
  factory CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus(
    Variables_Mutation_UpdateVolunteerInterestStatus instance,
    TRes Function(Variables_Mutation_UpdateVolunteerInterestStatus) then,
  ) = _CopyWithImpl_Variables_Mutation_UpdateVolunteerInterestStatus;

  factory CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl_Variables_Mutation_UpdateVolunteerInterestStatus;

  TRes call({Input_UpdateEhrenamtsbankAnfrageStatusInput? input});
}

class _CopyWithImpl_Variables_Mutation_UpdateVolunteerInterestStatus<TRes>
    implements CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus<TRes> {
  _CopyWithImpl_Variables_Mutation_UpdateVolunteerInterestStatus(
    this._instance,
    this._then,
  );

  final Variables_Mutation_UpdateVolunteerInterestStatus _instance;

  final TRes Function(Variables_Mutation_UpdateVolunteerInterestStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_UpdateVolunteerInterestStatus._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_UpdateEhrenamtsbankAnfrageStatusInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_UpdateVolunteerInterestStatus<TRes>
    implements CopyWith_Variables_Mutation_UpdateVolunteerInterestStatus<TRes> {
  _CopyWithStubImpl_Variables_Mutation_UpdateVolunteerInterestStatus(this._res);

  TRes _res;

  call({Input_UpdateEhrenamtsbankAnfrageStatusInput? input}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus {
  Mutation_UpdateVolunteerInterestStatus({
    required this.updateEhrenamtsbankAnfrageStatus,
    this.$__typename = 'Mutation',
  });

  factory Mutation_UpdateVolunteerInterestStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$updateEhrenamtsbankAnfrageStatus =
        json['updateEhrenamtsbankAnfrageStatus'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus(
      updateEhrenamtsbankAnfrageStatus:
          Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus.fromJson(
            (l$updateEhrenamtsbankAnfrageStatus as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus
  updateEhrenamtsbankAnfrageStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateEhrenamtsbankAnfrageStatus = updateEhrenamtsbankAnfrageStatus;
    _resultData['updateEhrenamtsbankAnfrageStatus'] =
        l$updateEhrenamtsbankAnfrageStatus.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateEhrenamtsbankAnfrageStatus = updateEhrenamtsbankAnfrageStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateEhrenamtsbankAnfrageStatus, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_UpdateVolunteerInterestStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateEhrenamtsbankAnfrageStatus = updateEhrenamtsbankAnfrageStatus;
    final lOther$updateEhrenamtsbankAnfrageStatus =
        other.updateEhrenamtsbankAnfrageStatus;
    if (l$updateEhrenamtsbankAnfrageStatus !=
        lOther$updateEhrenamtsbankAnfrageStatus) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus
    on Mutation_UpdateVolunteerInterestStatus {
  CopyWith_Mutation_UpdateVolunteerInterestStatus<
    Mutation_UpdateVolunteerInterestStatus
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus(this, (i) => i);
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus<TRes> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus(
    Mutation_UpdateVolunteerInterestStatus instance,
    TRes Function(Mutation_UpdateVolunteerInterestStatus) then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus.stub(TRes res) =
      _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus;

  TRes call({
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus?
    updateEhrenamtsbankAnfrageStatus,
    String? $__typename,
  });
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
    TRes
  >
  get updateEhrenamtsbankAnfrageStatus;
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus<TRes>
    implements CopyWith_Mutation_UpdateVolunteerInterestStatus<TRes> {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus _instance;

  final TRes Function(Mutation_UpdateVolunteerInterestStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateEhrenamtsbankAnfrageStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus(
      updateEhrenamtsbankAnfrageStatus:
          updateEhrenamtsbankAnfrageStatus == _undefined ||
              updateEhrenamtsbankAnfrageStatus == null
          ? _instance.updateEhrenamtsbankAnfrageStatus
          : (updateEhrenamtsbankAnfrageStatus
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
    TRes
  >
  get updateEhrenamtsbankAnfrageStatus {
    final local$updateEhrenamtsbankAnfrageStatus =
        _instance.updateEhrenamtsbankAnfrageStatus;
    return CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
      local$updateEhrenamtsbankAnfrageStatus,
      (e) => call(updateEhrenamtsbankAnfrageStatus: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus<TRes>
    implements CopyWith_Mutation_UpdateVolunteerInterestStatus<TRes> {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus(this._res);

  TRes _res;

  call({
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus?
    updateEhrenamtsbankAnfrageStatus,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
    TRes
  >
  get updateEhrenamtsbankAnfrageStatus =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus.stub(
        _res,
      );
}

const documentNodeMutationUpdateVolunteerInterestStatus = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'UpdateVolunteerInterestStatus'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UpdateEhrenamtsbankAnfrageStatusInput'),
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
            name: NameNode(value: 'updateEhrenamtsbankAnfrageStatus'),
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
                  name: NameNode(value: 'ehrenamtsbankAnfrage'),
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
                        name: NameNode(value: 'status'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'vereinbartAt'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_UpdateVolunteerInterestStatus
_parserFn_Mutation_UpdateVolunteerInterestStatus(Map<String, dynamic> data) =>
    Mutation_UpdateVolunteerInterestStatus.fromJson(data);
typedef OnMutationCompleted_Mutation_UpdateVolunteerInterestStatus =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_UpdateVolunteerInterestStatus?,
    );

class Options_Mutation_UpdateVolunteerInterestStatus
    extends graphql.MutationOptions<Mutation_UpdateVolunteerInterestStatus> {
  Options_Mutation_UpdateVolunteerInterestStatus({
    String? operationName,
    required Variables_Mutation_UpdateVolunteerInterestStatus variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateVolunteerInterestStatus? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateVolunteerInterestStatus? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateVolunteerInterestStatus>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_UpdateVolunteerInterestStatus(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateVolunteerInterestStatus,
         parserFn: _parserFn_Mutation_UpdateVolunteerInterestStatus,
       );

  final OnMutationCompleted_Mutation_UpdateVolunteerInterestStatus?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_UpdateVolunteerInterestStatus
    extends graphql.WatchQueryOptions<Mutation_UpdateVolunteerInterestStatus> {
  WatchOptions_Mutation_UpdateVolunteerInterestStatus({
    String? operationName,
    required Variables_Mutation_UpdateVolunteerInterestStatus variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateVolunteerInterestStatus? typedOptimisticResult,
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
         document: documentNodeMutationUpdateVolunteerInterestStatus,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_UpdateVolunteerInterestStatus,
       );
}

extension ClientExtension_Mutation_UpdateVolunteerInterestStatus
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_UpdateVolunteerInterestStatus>>
  mutate_UpdateVolunteerInterestStatus(
    Options_Mutation_UpdateVolunteerInterestStatus options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_UpdateVolunteerInterestStatus>
  watchMutation_UpdateVolunteerInterestStatus(
    WatchOptions_Mutation_UpdateVolunteerInterestStatus options,
  ) => this.watchMutation(options);
}

class Mutation_UpdateVolunteerInterestStatus_HookResult {
  Mutation_UpdateVolunteerInterestStatus_HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation_Mutation_UpdateVolunteerInterestStatus runMutation;

  final graphql.QueryResult<Mutation_UpdateVolunteerInterestStatus> result;
}

Mutation_UpdateVolunteerInterestStatus_HookResult
useMutation_UpdateVolunteerInterestStatus([
  WidgetOptions_Mutation_UpdateVolunteerInterestStatus? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_UpdateVolunteerInterestStatus(),
  );
  return Mutation_UpdateVolunteerInterestStatus_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_UpdateVolunteerInterestStatus>
useWatchMutation_UpdateVolunteerInterestStatus(
  WatchOptions_Mutation_UpdateVolunteerInterestStatus options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_UpdateVolunteerInterestStatus
    extends graphql.MutationOptions<Mutation_UpdateVolunteerInterestStatus> {
  WidgetOptions_Mutation_UpdateVolunteerInterestStatus({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_UpdateVolunteerInterestStatus? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_UpdateVolunteerInterestStatus? onCompleted,
    graphql.OnMutationUpdate<Mutation_UpdateVolunteerInterestStatus>? update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_UpdateVolunteerInterestStatus(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationUpdateVolunteerInterestStatus,
         parserFn: _parserFn_Mutation_UpdateVolunteerInterestStatus,
       );

  final OnMutationCompleted_Mutation_UpdateVolunteerInterestStatus?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_UpdateVolunteerInterestStatus =
    graphql.MultiSourceResult<Mutation_UpdateVolunteerInterestStatus> Function(
      Variables_Mutation_UpdateVolunteerInterestStatus, {
      Object? optimisticResult,
      Mutation_UpdateVolunteerInterestStatus? typedOptimisticResult,
    });
typedef Builder_Mutation_UpdateVolunteerInterestStatus =
    widgets.Widget Function(
      RunMutation_Mutation_UpdateVolunteerInterestStatus,
      graphql.QueryResult<Mutation_UpdateVolunteerInterestStatus>?,
    );

class Mutation_UpdateVolunteerInterestStatus_Widget
    extends graphql_flutter.Mutation<Mutation_UpdateVolunteerInterestStatus> {
  Mutation_UpdateVolunteerInterestStatus_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_UpdateVolunteerInterestStatus? options,
    required Builder_Mutation_UpdateVolunteerInterestStatus builder,
  }) : super(
         key: key,
         options:
             options ?? WidgetOptions_Mutation_UpdateVolunteerInterestStatus(),
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

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus({
    this.ehrenamtsbankAnfrage,
    this.errors,
    this.$__typename = 'UpdateEhrenamtsbankAnfrageStatusPayload',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankAnfrage = json['ehrenamtsbankAnfrage'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
      ehrenamtsbankAnfrage: l$ehrenamtsbankAnfrage == null
          ? null
          : Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage.fromJson(
              (l$ehrenamtsbankAnfrage as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage?
  ehrenamtsbankAnfrage;

  final List<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    _resultData['ehrenamtsbankAnfrage'] = l$ehrenamtsbankAnfrage?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankAnfrage,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final lOther$ehrenamtsbankAnfrage = other.ehrenamtsbankAnfrage;
    if (l$ehrenamtsbankAnfrage != lOther$ehrenamtsbankAnfrage) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus
    on Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus;

  TRes call({
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    >?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage;
  TRes errors(
    Iterable<
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
          Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankAnfrage = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
      ehrenamtsbankAnfrage: ehrenamtsbankAnfrage == _undefined
          ? _instance.ehrenamtsbankAnfrage
          : (ehrenamtsbankAnfrage
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage {
    final local$ehrenamtsbankAnfrage = _instance.ehrenamtsbankAnfrage;
    return local$ehrenamtsbankAnfrage == null
        ? CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
            local$ehrenamtsbankAnfrage,
            (e) => call(ehrenamtsbankAnfrage: e),
          );
  }

  TRes errors(
    Iterable<
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
          Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus(
    this._res,
  );

  TRes _res;

  call({
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    >?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage({
    required this.id,
    required this.status,
    this.vereinbartAt,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$vereinbartAt = json['vereinbartAt'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      vereinbartAt: l$vereinbartAt == null
          ? null
          : DateTime.parse((l$vereinbartAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final DateTime? vereinbartAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$vereinbartAt = vereinbartAt;
    _resultData['vereinbartAt'] = l$vereinbartAt?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$vereinbartAt = vereinbartAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$status, l$vereinbartAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$vereinbartAt = vereinbartAt;
    final lOther$vereinbartAt = other.vereinbartAt;
    if (l$vereinbartAt != lOther$vereinbartAt) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage;

  TRes call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    DateTime? vereinbartAt,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? vereinbartAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      vereinbartAt: vereinbartAt == _undefined
          ? _instance.vereinbartAt
          : (vereinbartAt as DateTime?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_ehrenamtsbankAnfrage(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    DateTime? vereinbartAt,
    String? $__typename,
  }) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors({
    required this.$__typename,
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "AnfrageNotFoundError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError.fromJson(
          json,
        );

      case "AnfrageStatusTransitionError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError.fromJson(
          json,
        );

      case "EintragConflictError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError.fromJson(
          json,
        );

      case "EintragNotActiveError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError.fromJson(
          json,
        );

      case "EintragNotFoundError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError.fromJson(
          json,
        );

      case "Unauthenticated":
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
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
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors ||
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    on Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
    )
    anfrageNotFoundError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
    )
    anfrageStatusTransitionError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
    )
    eintragConflictError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
    )
    eintragNotActiveError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
    )
    eintragNotFoundError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
    )
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AnfrageNotFoundError":
        return anfrageNotFoundError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
        );

      case "AnfrageStatusTransitionError":
        return anfrageStatusTransitionError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
        );

      case "EintragConflictError":
        return eintragConflictError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
        );

      case "EintragNotActiveError":
        return eintragNotActiveError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
        );

      case "EintragNotFoundError":
        return eintragNotFoundError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
        );

      case "Unauthenticated":
        return unauthenticated(
          this
              as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
    )?
    anfrageNotFoundError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
    )?
    anfrageStatusTransitionError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
    )?
    eintragConflictError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
    )?
    eintragNotActiveError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
    )?
    eintragNotFoundError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
    )?
    notAllowedError,
    _T Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
    )?
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AnfrageNotFoundError":
        if (anfrageNotFoundError != null) {
          return anfrageNotFoundError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
          );
        } else {
          return orElse();
        }

      case "AnfrageStatusTransitionError":
        if (anfrageStatusTransitionError != null) {
          return anfrageStatusTransitionError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
          );
        } else {
          return orElse();
        }

      case "EintragConflictError":
        if (eintragConflictError != null) {
          return eintragConflictError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
          );
        } else {
          return orElse();
        }

      case "EintragNotActiveError":
        if (eintragNotActiveError != null) {
          return eintragNotActiveError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
          );
        } else {
          return orElse();
        }

      case "EintragNotFoundError":
        if (eintragNotFoundError != null) {
          return eintragNotFoundError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      case "Unauthenticated":
        if (unauthenticated != null) {
          return unauthenticated(
            this
                as Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError({
    required this.message,
    this.$__typename = 'AnfrageNotFoundError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError({
    required this.message,
    this.$__typename = 'AnfrageStatusTransitionError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__AnfrageStatusTransitionError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError({
    required this.message,
    this.$__typename = 'EintragConflictError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragConflictError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError({
    required this.message,
    this.$__typename = 'EintragNotActiveError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotActiveError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError({
    required this.message,
    this.$__typename = 'EintragNotFoundError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__EintragNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated
    implements
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors {
  Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated({
    required this.message,
    this.$__typename = 'Unauthenticated',
  });

  factory Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated
    on
        Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated {
  CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated
  >
  get copyWith =>
      CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
  TRes
> {
  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated
    instance,
    TRes Function(
      Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
    )
    then,
  ) = _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated;

  factory CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
          TRes
        > {
  _CopyWithImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
    this._instance,
    this._then,
  );

  final Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated
  _instance;

  final TRes Function(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated<
          TRes
        > {
  _CopyWithStubImpl_Mutation_UpdateVolunteerInterestStatus_updateEhrenamtsbankAnfrageStatus_errors__Unauthenticated(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Variables_Mutation_ProposeVolunteerInterestCompletion {
  factory Variables_Mutation_ProposeVolunteerInterestCompletion({
    required Input_ProposeEhrenamtsbankAbschlussInput input,
  }) => Variables_Mutation_ProposeVolunteerInterestCompletion._({
    r'input': input,
  });

  Variables_Mutation_ProposeVolunteerInterestCompletion._(this._$data);

  factory Variables_Mutation_ProposeVolunteerInterestCompletion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_ProposeEhrenamtsbankAbschlussInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_ProposeVolunteerInterestCompletion._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_ProposeEhrenamtsbankAbschlussInput get input =>
      (_$data['input'] as Input_ProposeEhrenamtsbankAbschlussInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion<
    Variables_Mutation_ProposeVolunteerInterestCompletion
  >
  get copyWith =>
      CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_ProposeVolunteerInterestCompletion ||
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

abstract class CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion<
  TRes
> {
  factory CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion(
    Variables_Mutation_ProposeVolunteerInterestCompletion instance,
    TRes Function(Variables_Mutation_ProposeVolunteerInterestCompletion) then,
  ) = _CopyWithImpl_Variables_Mutation_ProposeVolunteerInterestCompletion;

  factory CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Variables_Mutation_ProposeVolunteerInterestCompletion;

  TRes call({Input_ProposeEhrenamtsbankAbschlussInput? input});
}

class _CopyWithImpl_Variables_Mutation_ProposeVolunteerInterestCompletion<TRes>
    implements
        CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion<TRes> {
  _CopyWithImpl_Variables_Mutation_ProposeVolunteerInterestCompletion(
    this._instance,
    this._then,
  );

  final Variables_Mutation_ProposeVolunteerInterestCompletion _instance;

  final TRes Function(Variables_Mutation_ProposeVolunteerInterestCompletion)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_ProposeVolunteerInterestCompletion._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_ProposeEhrenamtsbankAbschlussInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_ProposeVolunteerInterestCompletion<
  TRes
>
    implements
        CopyWith_Variables_Mutation_ProposeVolunteerInterestCompletion<TRes> {
  _CopyWithStubImpl_Variables_Mutation_ProposeVolunteerInterestCompletion(
    this._res,
  );

  TRes _res;

  call({Input_ProposeEhrenamtsbankAbschlussInput? input}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion {
  Mutation_ProposeVolunteerInterestCompletion({
    required this.proposeEhrenamtsbankAbschluss,
    this.$__typename = 'Mutation',
  });

  factory Mutation_ProposeVolunteerInterestCompletion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$proposeEhrenamtsbankAbschluss =
        json['proposeEhrenamtsbankAbschluss'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion(
      proposeEhrenamtsbankAbschluss:
          Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss.fromJson(
            (l$proposeEhrenamtsbankAbschluss as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss
  proposeEhrenamtsbankAbschluss;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$proposeEhrenamtsbankAbschluss = proposeEhrenamtsbankAbschluss;
    _resultData['proposeEhrenamtsbankAbschluss'] =
        l$proposeEhrenamtsbankAbschluss.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$proposeEhrenamtsbankAbschluss = proposeEhrenamtsbankAbschluss;
    final l$$__typename = $__typename;
    return Object.hashAll([l$proposeEhrenamtsbankAbschluss, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_ProposeVolunteerInterestCompletion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$proposeEhrenamtsbankAbschluss = proposeEhrenamtsbankAbschluss;
    final lOther$proposeEhrenamtsbankAbschluss =
        other.proposeEhrenamtsbankAbschluss;
    if (l$proposeEhrenamtsbankAbschluss !=
        lOther$proposeEhrenamtsbankAbschluss) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion
    on Mutation_ProposeVolunteerInterestCompletion {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion<
    Mutation_ProposeVolunteerInterestCompletion
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion(this, (i) => i);
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion<TRes> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion(
    Mutation_ProposeVolunteerInterestCompletion instance,
    TRes Function(Mutation_ProposeVolunteerInterestCompletion) then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion.stub(TRes res) =
      _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion;

  TRes call({
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss?
    proposeEhrenamtsbankAbschluss,
    String? $__typename,
  });
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
    TRes
  >
  get proposeEhrenamtsbankAbschluss;
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion<TRes>
    implements CopyWith_Mutation_ProposeVolunteerInterestCompletion<TRes> {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion _instance;

  final TRes Function(Mutation_ProposeVolunteerInterestCompletion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? proposeEhrenamtsbankAbschluss = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion(
      proposeEhrenamtsbankAbschluss:
          proposeEhrenamtsbankAbschluss == _undefined ||
              proposeEhrenamtsbankAbschluss == null
          ? _instance.proposeEhrenamtsbankAbschluss
          : (proposeEhrenamtsbankAbschluss
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
    TRes
  >
  get proposeEhrenamtsbankAbschluss {
    final local$proposeEhrenamtsbankAbschluss =
        _instance.proposeEhrenamtsbankAbschluss;
    return CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
      local$proposeEhrenamtsbankAbschluss,
      (e) => call(proposeEhrenamtsbankAbschluss: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion<TRes>
    implements CopyWith_Mutation_ProposeVolunteerInterestCompletion<TRes> {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion(this._res);

  TRes _res;

  call({
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss?
    proposeEhrenamtsbankAbschluss,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
    TRes
  >
  get proposeEhrenamtsbankAbschluss =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss.stub(
        _res,
      );
}

const documentNodeMutationProposeVolunteerInterestCompletion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ProposeVolunteerInterestCompletion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ProposeEhrenamtsbankAbschlussInput'),
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
            name: NameNode(value: 'proposeEhrenamtsbankAbschluss'),
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
                  name: NameNode(value: 'ehrenamtsbankAnfrage'),
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
                        name: NameNode(value: 'status'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedMinutes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedDate'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedNote'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedById'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_ProposeVolunteerInterestCompletion
_parserFn_Mutation_ProposeVolunteerInterestCompletion(
  Map<String, dynamic> data,
) => Mutation_ProposeVolunteerInterestCompletion.fromJson(data);
typedef OnMutationCompleted_Mutation_ProposeVolunteerInterestCompletion =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_ProposeVolunteerInterestCompletion?,
    );

class Options_Mutation_ProposeVolunteerInterestCompletion
    extends
        graphql.MutationOptions<Mutation_ProposeVolunteerInterestCompletion> {
  Options_Mutation_ProposeVolunteerInterestCompletion({
    String? operationName,
    required Variables_Mutation_ProposeVolunteerInterestCompletion variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ProposeVolunteerInterestCompletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ProposeVolunteerInterestCompletion?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_ProposeVolunteerInterestCompletion>?
    update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_ProposeVolunteerInterestCompletion(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationProposeVolunteerInterestCompletion,
         parserFn: _parserFn_Mutation_ProposeVolunteerInterestCompletion,
       );

  final OnMutationCompleted_Mutation_ProposeVolunteerInterestCompletion?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_ProposeVolunteerInterestCompletion
    extends
        graphql.WatchQueryOptions<Mutation_ProposeVolunteerInterestCompletion> {
  WatchOptions_Mutation_ProposeVolunteerInterestCompletion({
    String? operationName,
    required Variables_Mutation_ProposeVolunteerInterestCompletion variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ProposeVolunteerInterestCompletion? typedOptimisticResult,
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
         document: documentNodeMutationProposeVolunteerInterestCompletion,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_ProposeVolunteerInterestCompletion,
       );
}

extension ClientExtension_Mutation_ProposeVolunteerInterestCompletion
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_ProposeVolunteerInterestCompletion>>
  mutate_ProposeVolunteerInterestCompletion(
    Options_Mutation_ProposeVolunteerInterestCompletion options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_ProposeVolunteerInterestCompletion>
  watchMutation_ProposeVolunteerInterestCompletion(
    WatchOptions_Mutation_ProposeVolunteerInterestCompletion options,
  ) => this.watchMutation(options);
}

class Mutation_ProposeVolunteerInterestCompletion_HookResult {
  Mutation_ProposeVolunteerInterestCompletion_HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation_Mutation_ProposeVolunteerInterestCompletion runMutation;

  final graphql.QueryResult<Mutation_ProposeVolunteerInterestCompletion> result;
}

Mutation_ProposeVolunteerInterestCompletion_HookResult
useMutation_ProposeVolunteerInterestCompletion([
  WidgetOptions_Mutation_ProposeVolunteerInterestCompletion? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_ProposeVolunteerInterestCompletion(),
  );
  return Mutation_ProposeVolunteerInterestCompletion_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_ProposeVolunteerInterestCompletion>
useWatchMutation_ProposeVolunteerInterestCompletion(
  WatchOptions_Mutation_ProposeVolunteerInterestCompletion options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_ProposeVolunteerInterestCompletion
    extends
        graphql.MutationOptions<Mutation_ProposeVolunteerInterestCompletion> {
  WidgetOptions_Mutation_ProposeVolunteerInterestCompletion({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ProposeVolunteerInterestCompletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ProposeVolunteerInterestCompletion?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_ProposeVolunteerInterestCompletion>?
    update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_ProposeVolunteerInterestCompletion(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationProposeVolunteerInterestCompletion,
         parserFn: _parserFn_Mutation_ProposeVolunteerInterestCompletion,
       );

  final OnMutationCompleted_Mutation_ProposeVolunteerInterestCompletion?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_ProposeVolunteerInterestCompletion =
    graphql.MultiSourceResult<Mutation_ProposeVolunteerInterestCompletion>
    Function(
      Variables_Mutation_ProposeVolunteerInterestCompletion, {
      Object? optimisticResult,
      Mutation_ProposeVolunteerInterestCompletion? typedOptimisticResult,
    });
typedef Builder_Mutation_ProposeVolunteerInterestCompletion =
    widgets.Widget Function(
      RunMutation_Mutation_ProposeVolunteerInterestCompletion,
      graphql.QueryResult<Mutation_ProposeVolunteerInterestCompletion>?,
    );

class Mutation_ProposeVolunteerInterestCompletion_Widget
    extends
        graphql_flutter.Mutation<Mutation_ProposeVolunteerInterestCompletion> {
  Mutation_ProposeVolunteerInterestCompletion_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_ProposeVolunteerInterestCompletion? options,
    required Builder_Mutation_ProposeVolunteerInterestCompletion builder,
  }) : super(
         key: key,
         options:
             options ??
             WidgetOptions_Mutation_ProposeVolunteerInterestCompletion(),
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

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss({
    this.ehrenamtsbankAnfrage,
    this.errors,
    this.$__typename = 'ProposeEhrenamtsbankAbschlussPayload',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankAnfrage = json['ehrenamtsbankAnfrage'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
      ehrenamtsbankAnfrage: l$ehrenamtsbankAnfrage == null
          ? null
          : Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.fromJson(
              (l$ehrenamtsbankAnfrage as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
  ehrenamtsbankAnfrage;

  final List<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    _resultData['ehrenamtsbankAnfrage'] = l$ehrenamtsbankAnfrage?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankAnfrage,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final lOther$ehrenamtsbankAnfrage = other.ehrenamtsbankAnfrage;
    if (l$ehrenamtsbankAnfrage != lOther$ehrenamtsbankAnfrage) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss
    on Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss;

  TRes call({
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    >?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage;
  TRes errors(
    Iterable<
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
          Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankAnfrage = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
      ehrenamtsbankAnfrage: ehrenamtsbankAnfrage == _undefined
          ? _instance.ehrenamtsbankAnfrage
          : (ehrenamtsbankAnfrage
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage {
    final local$ehrenamtsbankAnfrage = _instance.ehrenamtsbankAnfrage;
    return local$ehrenamtsbankAnfrage == null
        ? CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
            local$ehrenamtsbankAnfrage,
            (e) => call(ehrenamtsbankAnfrage: e),
          );
  }

  TRes errors(
    Iterable<
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
          Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss(
    this._res,
  );

  TRes _res;

  call({
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    >?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage({
    required this.id,
    required this.status,
    this.proposedMinutes,
    this.proposedDate,
    this.proposedNote,
    this.proposedById,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$proposedMinutes = json['proposedMinutes'];
    final l$proposedDate = json['proposedDate'];
    final l$proposedNote = json['proposedNote'];
    final l$proposedById = json['proposedById'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      proposedMinutes: (l$proposedMinutes as int?),
      proposedDate: l$proposedDate == null
          ? null
          : localDateFromJson(l$proposedDate),
      proposedNote: (l$proposedNote as String?),
      proposedById: (l$proposedById as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final int? proposedMinutes;

  final DateTime? proposedDate;

  final String? proposedNote;

  final String? proposedById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$proposedMinutes = proposedMinutes;
    _resultData['proposedMinutes'] = l$proposedMinutes;
    final l$proposedDate = proposedDate;
    _resultData['proposedDate'] = l$proposedDate == null
        ? null
        : localDateToJson(l$proposedDate);
    final l$proposedNote = proposedNote;
    _resultData['proposedNote'] = l$proposedNote;
    final l$proposedById = proposedById;
    _resultData['proposedById'] = l$proposedById;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$proposedMinutes = proposedMinutes;
    final l$proposedDate = proposedDate;
    final l$proposedNote = proposedNote;
    final l$proposedById = proposedById;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$proposedMinutes,
      l$proposedDate,
      l$proposedNote,
      l$proposedById,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$proposedMinutes = proposedMinutes;
    final lOther$proposedMinutes = other.proposedMinutes;
    if (l$proposedMinutes != lOther$proposedMinutes) {
      return false;
    }
    final l$proposedDate = proposedDate;
    final lOther$proposedDate = other.proposedDate;
    if (l$proposedDate != lOther$proposedDate) {
      return false;
    }
    final l$proposedNote = proposedNote;
    final lOther$proposedNote = other.proposedNote;
    if (l$proposedNote != lOther$proposedNote) {
      return false;
    }
    final l$proposedById = proposedById;
    final lOther$proposedById = other.proposedById;
    if (l$proposedById != lOther$proposedById) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage;

  TRes call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? proposedMinutes = _undefined,
    Object? proposedDate = _undefined,
    Object? proposedNote = _undefined,
    Object? proposedById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      proposedMinutes: proposedMinutes == _undefined
          ? _instance.proposedMinutes
          : (proposedMinutes as int?),
      proposedDate: proposedDate == _undefined
          ? _instance.proposedDate
          : (proposedDate as DateTime?),
      proposedNote: proposedNote == _undefined
          ? _instance.proposedNote
          : (proposedNote as String?),
      proposedById: proposedById == _undefined
          ? _instance.proposedById
          : (proposedById as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    String? $__typename,
  }) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors({
    required this.$__typename,
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "AbschlussDateInFutureError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError.fromJson(
          json,
        );

      case "AbschlussEintragNotAssignedError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.fromJson(
          json,
        );

      case "AbschlussMinutesOutOfRangeError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError.fromJson(
          json,
        );

      case "AbschlussNotVereinbartError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.fromJson(
          json,
        );

      case "AbschlussNoteTooLongError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError.fromJson(
          json,
        );

      case "AnfrageNotFoundError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.fromJson(
          json,
        );

      case "EintragNotFoundError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError.fromJson(
          json,
        );

      case "Unauthenticated":
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
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
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors ||
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
    )
    abschlussDateInFutureError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )
    abschlussEintragNotAssignedError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
    )
    abschlussMinutesOutOfRangeError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )
    abschlussNotVereinbartError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
    )
    abschlussNoteTooLongError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )
    anfrageNotFoundError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )
    eintragNotFoundError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
    )
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AbschlussDateInFutureError":
        return abschlussDateInFutureError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
        );

      case "AbschlussEintragNotAssignedError":
        return abschlussEintragNotAssignedError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
        );

      case "AbschlussMinutesOutOfRangeError":
        return abschlussMinutesOutOfRangeError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
        );

      case "AbschlussNotVereinbartError":
        return abschlussNotVereinbartError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
        );

      case "AbschlussNoteTooLongError":
        return abschlussNoteTooLongError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
        );

      case "AnfrageNotFoundError":
        return anfrageNotFoundError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
        );

      case "EintragNotFoundError":
        return eintragNotFoundError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
        );

      case "Unauthenticated":
        return unauthenticated(
          this
              as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
    )?
    abschlussDateInFutureError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )?
    abschlussEintragNotAssignedError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
    )?
    abschlussMinutesOutOfRangeError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )?
    abschlussNotVereinbartError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
    )?
    abschlussNoteTooLongError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )?
    anfrageNotFoundError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )?
    eintragNotFoundError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
    )?
    notAllowedError,
    _T Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
    )?
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AbschlussDateInFutureError":
        if (abschlussDateInFutureError != null) {
          return abschlussDateInFutureError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
          );
        } else {
          return orElse();
        }

      case "AbschlussEintragNotAssignedError":
        if (abschlussEintragNotAssignedError != null) {
          return abschlussEintragNotAssignedError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
          );
        } else {
          return orElse();
        }

      case "AbschlussMinutesOutOfRangeError":
        if (abschlussMinutesOutOfRangeError != null) {
          return abschlussMinutesOutOfRangeError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
          );
        } else {
          return orElse();
        }

      case "AbschlussNotVereinbartError":
        if (abschlussNotVereinbartError != null) {
          return abschlussNotVereinbartError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
          );
        } else {
          return orElse();
        }

      case "AbschlussNoteTooLongError":
        if (abschlussNoteTooLongError != null) {
          return abschlussNoteTooLongError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
          );
        } else {
          return orElse();
        }

      case "AnfrageNotFoundError":
        if (anfrageNotFoundError != null) {
          return anfrageNotFoundError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
          );
        } else {
          return orElse();
        }

      case "EintragNotFoundError":
        if (eintragNotFoundError != null) {
          return eintragNotFoundError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      case "Unauthenticated":
        if (unauthenticated != null) {
          return unauthenticated(
            this
                as Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError({
    required this.message,
    this.$__typename = 'AbschlussDateInFutureError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussDateInFutureError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError({
    required this.message,
    this.$__typename = 'AbschlussEintragNotAssignedError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError({
    required this.message,
    this.$__typename = 'AbschlussMinutesOutOfRangeError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussMinutesOutOfRangeError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError({
    required this.message,
    this.$__typename = 'AbschlussNotVereinbartError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError({
    required this.message,
    this.$__typename = 'AbschlussNoteTooLongError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AbschlussNoteTooLongError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError({
    required this.message,
    this.$__typename = 'AnfrageNotFoundError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError({
    required this.message,
    this.$__typename = 'EintragNotFoundError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated
    implements
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors {
  Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated({
    required this.message,
    this.$__typename = 'Unauthenticated',
  });

  factory Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated
    on
        Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated {
  CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated
  >
  get copyWith =>
      CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
> {
  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated
    instance,
    TRes Function(
      Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
    )
    then,
  ) = _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated;

  factory CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
          TRes
        > {
  _CopyWithImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
    this._instance,
    this._then,
  );

  final Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated
  _instance;

  final TRes Function(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ProposeVolunteerInterestCompletion_proposeEhrenamtsbankAbschluss_errors__Unauthenticated(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Variables_Mutation_ConfirmVolunteerInterestCompletion {
  factory Variables_Mutation_ConfirmVolunteerInterestCompletion({
    required Input_ConfirmEhrenamtsbankAbschlussInput input,
  }) => Variables_Mutation_ConfirmVolunteerInterestCompletion._({
    r'input': input,
  });

  Variables_Mutation_ConfirmVolunteerInterestCompletion._(this._$data);

  factory Variables_Mutation_ConfirmVolunteerInterestCompletion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input_ConfirmEhrenamtsbankAbschlussInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables_Mutation_ConfirmVolunteerInterestCompletion._(result$data);
  }

  Map<String, dynamic> _$data;

  Input_ConfirmEhrenamtsbankAbschlussInput get input =>
      (_$data['input'] as Input_ConfirmEhrenamtsbankAbschlussInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion<
    Variables_Mutation_ConfirmVolunteerInterestCompletion
  >
  get copyWith =>
      CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Mutation_ConfirmVolunteerInterestCompletion ||
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

abstract class CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion<
  TRes
> {
  factory CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion(
    Variables_Mutation_ConfirmVolunteerInterestCompletion instance,
    TRes Function(Variables_Mutation_ConfirmVolunteerInterestCompletion) then,
  ) = _CopyWithImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion;

  factory CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion;

  TRes call({Input_ConfirmEhrenamtsbankAbschlussInput? input});
}

class _CopyWithImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion<TRes>
    implements
        CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion<TRes> {
  _CopyWithImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion(
    this._instance,
    this._then,
  );

  final Variables_Mutation_ConfirmVolunteerInterestCompletion _instance;

  final TRes Function(Variables_Mutation_ConfirmVolunteerInterestCompletion)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables_Mutation_ConfirmVolunteerInterestCompletion._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input_ConfirmEhrenamtsbankAbschlussInput),
    }),
  );
}

class _CopyWithStubImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion<
  TRes
>
    implements
        CopyWith_Variables_Mutation_ConfirmVolunteerInterestCompletion<TRes> {
  _CopyWithStubImpl_Variables_Mutation_ConfirmVolunteerInterestCompletion(
    this._res,
  );

  TRes _res;

  call({Input_ConfirmEhrenamtsbankAbschlussInput? input}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion {
  Mutation_ConfirmVolunteerInterestCompletion({
    required this.confirmEhrenamtsbankAbschluss,
    this.$__typename = 'Mutation',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$confirmEhrenamtsbankAbschluss =
        json['confirmEhrenamtsbankAbschluss'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion(
      confirmEhrenamtsbankAbschluss:
          Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss.fromJson(
            (l$confirmEhrenamtsbankAbschluss as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss
  confirmEhrenamtsbankAbschluss;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmEhrenamtsbankAbschluss = confirmEhrenamtsbankAbschluss;
    _resultData['confirmEhrenamtsbankAbschluss'] =
        l$confirmEhrenamtsbankAbschluss.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmEhrenamtsbankAbschluss = confirmEhrenamtsbankAbschluss;
    final l$$__typename = $__typename;
    return Object.hashAll([l$confirmEhrenamtsbankAbschluss, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation_ConfirmVolunteerInterestCompletion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmEhrenamtsbankAbschluss = confirmEhrenamtsbankAbschluss;
    final lOther$confirmEhrenamtsbankAbschluss =
        other.confirmEhrenamtsbankAbschluss;
    if (l$confirmEhrenamtsbankAbschluss !=
        lOther$confirmEhrenamtsbankAbschluss) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion
    on Mutation_ConfirmVolunteerInterestCompletion {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion<
    Mutation_ConfirmVolunteerInterestCompletion
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion(this, (i) => i);
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion<TRes> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion(
    Mutation_ConfirmVolunteerInterestCompletion instance,
    TRes Function(Mutation_ConfirmVolunteerInterestCompletion) then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion.stub(TRes res) =
      _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion;

  TRes call({
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss?
    confirmEhrenamtsbankAbschluss,
    String? $__typename,
  });
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
    TRes
  >
  get confirmEhrenamtsbankAbschluss;
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion<TRes>
    implements CopyWith_Mutation_ConfirmVolunteerInterestCompletion<TRes> {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion _instance;

  final TRes Function(Mutation_ConfirmVolunteerInterestCompletion) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? confirmEhrenamtsbankAbschluss = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion(
      confirmEhrenamtsbankAbschluss:
          confirmEhrenamtsbankAbschluss == _undefined ||
              confirmEhrenamtsbankAbschluss == null
          ? _instance.confirmEhrenamtsbankAbschluss
          : (confirmEhrenamtsbankAbschluss
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
    TRes
  >
  get confirmEhrenamtsbankAbschluss {
    final local$confirmEhrenamtsbankAbschluss =
        _instance.confirmEhrenamtsbankAbschluss;
    return CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
      local$confirmEhrenamtsbankAbschluss,
      (e) => call(confirmEhrenamtsbankAbschluss: e),
    );
  }
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion<TRes>
    implements CopyWith_Mutation_ConfirmVolunteerInterestCompletion<TRes> {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion(this._res);

  TRes _res;

  call({
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss?
    confirmEhrenamtsbankAbschluss,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
    TRes
  >
  get confirmEhrenamtsbankAbschluss =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss.stub(
        _res,
      );
}

const documentNodeMutationConfirmVolunteerInterestCompletion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmVolunteerInterestCompletion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ConfirmEhrenamtsbankAbschlussInput'),
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
            name: NameNode(value: 'confirmEhrenamtsbankAbschluss'),
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
                  name: NameNode(value: 'ehrenamtsbankAnfrage'),
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
                        name: NameNode(value: 'status'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedMinutes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedDate'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedNote'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedById'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'transaktion'),
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
                              name: NameNode(value: 'minutes'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'performedOn'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'note'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'status'),
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
                  name: NameNode(value: 'errors'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'Error'),
                            isNonNull: false,
                          ),
                        ),
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'message'),
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
Mutation_ConfirmVolunteerInterestCompletion
_parserFn_Mutation_ConfirmVolunteerInterestCompletion(
  Map<String, dynamic> data,
) => Mutation_ConfirmVolunteerInterestCompletion.fromJson(data);
typedef OnMutationCompleted_Mutation_ConfirmVolunteerInterestCompletion =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation_ConfirmVolunteerInterestCompletion?,
    );

class Options_Mutation_ConfirmVolunteerInterestCompletion
    extends
        graphql.MutationOptions<Mutation_ConfirmVolunteerInterestCompletion> {
  Options_Mutation_ConfirmVolunteerInterestCompletion({
    String? operationName,
    required Variables_Mutation_ConfirmVolunteerInterestCompletion variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ConfirmVolunteerInterestCompletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ConfirmVolunteerInterestCompletion?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_ConfirmVolunteerInterestCompletion>?
    update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_ConfirmVolunteerInterestCompletion(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationConfirmVolunteerInterestCompletion,
         parserFn: _parserFn_Mutation_ConfirmVolunteerInterestCompletion,
       );

  final OnMutationCompleted_Mutation_ConfirmVolunteerInterestCompletion?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions_Mutation_ConfirmVolunteerInterestCompletion
    extends
        graphql.WatchQueryOptions<Mutation_ConfirmVolunteerInterestCompletion> {
  WatchOptions_Mutation_ConfirmVolunteerInterestCompletion({
    String? operationName,
    required Variables_Mutation_ConfirmVolunteerInterestCompletion variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ConfirmVolunteerInterestCompletion? typedOptimisticResult,
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
         document: documentNodeMutationConfirmVolunteerInterestCompletion,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Mutation_ConfirmVolunteerInterestCompletion,
       );
}

extension ClientExtension_Mutation_ConfirmVolunteerInterestCompletion
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation_ConfirmVolunteerInterestCompletion>>
  mutate_ConfirmVolunteerInterestCompletion(
    Options_Mutation_ConfirmVolunteerInterestCompletion options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation_ConfirmVolunteerInterestCompletion>
  watchMutation_ConfirmVolunteerInterestCompletion(
    WatchOptions_Mutation_ConfirmVolunteerInterestCompletion options,
  ) => this.watchMutation(options);
}

class Mutation_ConfirmVolunteerInterestCompletion_HookResult {
  Mutation_ConfirmVolunteerInterestCompletion_HookResult(
    this.runMutation,
    this.result,
  );

  final RunMutation_Mutation_ConfirmVolunteerInterestCompletion runMutation;

  final graphql.QueryResult<Mutation_ConfirmVolunteerInterestCompletion> result;
}

Mutation_ConfirmVolunteerInterestCompletion_HookResult
useMutation_ConfirmVolunteerInterestCompletion([
  WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion? options,
]) {
  final result = graphql_flutter.useMutation(
    options ?? WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion(),
  );
  return Mutation_ConfirmVolunteerInterestCompletion_HookResult(
    (variables, {optimisticResult, typedOptimisticResult}) =>
        result.runMutation(
          variables.toJson(),
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
        ),
    result.result,
  );
}

graphql.ObservableQuery<Mutation_ConfirmVolunteerInterestCompletion>
useWatchMutation_ConfirmVolunteerInterestCompletion(
  WatchOptions_Mutation_ConfirmVolunteerInterestCompletion options,
) => graphql_flutter.useWatchMutation(options);

class WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion
    extends
        graphql.MutationOptions<Mutation_ConfirmVolunteerInterestCompletion> {
  WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation_ConfirmVolunteerInterestCompletion? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted_Mutation_ConfirmVolunteerInterestCompletion?
    onCompleted,
    graphql.OnMutationUpdate<Mutation_ConfirmVolunteerInterestCompletion>?
    update,
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
                 data == null
                     ? null
                     : _parserFn_Mutation_ConfirmVolunteerInterestCompletion(
                         data,
                       ),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationConfirmVolunteerInterestCompletion,
         parserFn: _parserFn_Mutation_ConfirmVolunteerInterestCompletion,
       );

  final OnMutationCompleted_Mutation_ConfirmVolunteerInterestCompletion?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

typedef RunMutation_Mutation_ConfirmVolunteerInterestCompletion =
    graphql.MultiSourceResult<Mutation_ConfirmVolunteerInterestCompletion>
    Function(
      Variables_Mutation_ConfirmVolunteerInterestCompletion, {
      Object? optimisticResult,
      Mutation_ConfirmVolunteerInterestCompletion? typedOptimisticResult,
    });
typedef Builder_Mutation_ConfirmVolunteerInterestCompletion =
    widgets.Widget Function(
      RunMutation_Mutation_ConfirmVolunteerInterestCompletion,
      graphql.QueryResult<Mutation_ConfirmVolunteerInterestCompletion>?,
    );

class Mutation_ConfirmVolunteerInterestCompletion_Widget
    extends
        graphql_flutter.Mutation<Mutation_ConfirmVolunteerInterestCompletion> {
  Mutation_ConfirmVolunteerInterestCompletion_Widget({
    widgets.Key? key,
    WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion? options,
    required Builder_Mutation_ConfirmVolunteerInterestCompletion builder,
  }) : super(
         key: key,
         options:
             options ??
             WidgetOptions_Mutation_ConfirmVolunteerInterestCompletion(),
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

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss({
    this.ehrenamtsbankAnfrage,
    this.errors,
    this.$__typename = 'ConfirmEhrenamtsbankAbschlussPayload',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$ehrenamtsbankAnfrage = json['ehrenamtsbankAnfrage'];
    final l$errors = json['errors'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
      ehrenamtsbankAnfrage: l$ehrenamtsbankAnfrage == null
          ? null
          : Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.fromJson(
              (l$ehrenamtsbankAnfrage as Map<String, dynamic>),
            ),
      errors: (l$errors as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
  ehrenamtsbankAnfrage;

  final List<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
  >?
  errors;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    _resultData['ehrenamtsbankAnfrage'] = l$ehrenamtsbankAnfrage?.toJson();
    final l$errors = errors;
    _resultData['errors'] = l$errors?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final l$errors = errors;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$ehrenamtsbankAnfrage,
      l$errors == null ? null : Object.hashAll(l$errors.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ehrenamtsbankAnfrage = ehrenamtsbankAnfrage;
    final lOther$ehrenamtsbankAnfrage = other.ehrenamtsbankAnfrage;
    if (l$ehrenamtsbankAnfrage != lOther$ehrenamtsbankAnfrage) {
      return false;
    }
    final l$errors = errors;
    final lOther$errors = other.errors;
    if (l$errors != null && lOther$errors != null) {
      if (l$errors.length != lOther$errors.length) {
        return false;
      }
      for (int i = 0; i < l$errors.length; i++) {
        final l$errors$entry = l$errors[i];
        final lOther$errors$entry = lOther$errors[i];
        if (l$errors$entry != lOther$errors$entry) {
          return false;
        }
      }
    } else if (l$errors != lOther$errors) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss
    on Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss;

  TRes call({
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    >?
    errors,
    String? $__typename,
  });
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage;
  TRes errors(
    Iterable<
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
          Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ehrenamtsbankAnfrage = _undefined,
    Object? errors = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
      ehrenamtsbankAnfrage: ehrenamtsbankAnfrage == _undefined
          ? _instance.ehrenamtsbankAnfrage
          : (ehrenamtsbankAnfrage
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?),
      errors: errors == _undefined
          ? _instance.errors
          : (errors
                as List<
                  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage {
    final local$ehrenamtsbankAnfrage = _instance.ehrenamtsbankAnfrage;
    return local$ehrenamtsbankAnfrage == null
        ? CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
            local$ehrenamtsbankAnfrage,
            (e) => call(ehrenamtsbankAnfrage: e),
          );
  }

  TRes errors(
    Iterable<
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    >?
    Function(
      Iterable<
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
          Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
        >
      >?,
    )
    _fn,
  ) => call(
    errors: _fn(
      _instance.errors?.map(
        (e) =>
            CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss(
    this._res,
  );

  TRes _res;

  call({
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage?
    ehrenamtsbankAnfrage,
    List<
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    >?
    errors,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    TRes
  >
  get ehrenamtsbankAnfrage =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
        _res,
      );

  errors(_fn) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage({
    required this.id,
    required this.status,
    this.proposedMinutes,
    this.proposedDate,
    this.proposedNote,
    this.proposedById,
    this.transaktion,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$proposedMinutes = json['proposedMinutes'];
    final l$proposedDate = json['proposedDate'];
    final l$proposedNote = json['proposedNote'];
    final l$proposedById = json['proposedById'];
    final l$transaktion = json['transaktion'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      proposedMinutes: (l$proposedMinutes as int?),
      proposedDate: l$proposedDate == null
          ? null
          : localDateFromJson(l$proposedDate),
      proposedNote: (l$proposedNote as String?),
      proposedById: (l$proposedById as String?),
      transaktion: l$transaktion == null
          ? null
          : Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion.fromJson(
              (l$transaktion as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final int? proposedMinutes;

  final DateTime? proposedDate;

  final String? proposedNote;

  final String? proposedById;

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion?
  transaktion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$proposedMinutes = proposedMinutes;
    _resultData['proposedMinutes'] = l$proposedMinutes;
    final l$proposedDate = proposedDate;
    _resultData['proposedDate'] = l$proposedDate == null
        ? null
        : localDateToJson(l$proposedDate);
    final l$proposedNote = proposedNote;
    _resultData['proposedNote'] = l$proposedNote;
    final l$proposedById = proposedById;
    _resultData['proposedById'] = l$proposedById;
    final l$transaktion = transaktion;
    _resultData['transaktion'] = l$transaktion?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$proposedMinutes = proposedMinutes;
    final l$proposedDate = proposedDate;
    final l$proposedNote = proposedNote;
    final l$proposedById = proposedById;
    final l$transaktion = transaktion;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$proposedMinutes,
      l$proposedDate,
      l$proposedNote,
      l$proposedById,
      l$transaktion,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$proposedMinutes = proposedMinutes;
    final lOther$proposedMinutes = other.proposedMinutes;
    if (l$proposedMinutes != lOther$proposedMinutes) {
      return false;
    }
    final l$proposedDate = proposedDate;
    final lOther$proposedDate = other.proposedDate;
    if (l$proposedDate != lOther$proposedDate) {
      return false;
    }
    final l$proposedNote = proposedNote;
    final lOther$proposedNote = other.proposedNote;
    if (l$proposedNote != lOther$proposedNote) {
      return false;
    }
    final l$proposedById = proposedById;
    final lOther$proposedById = other.proposedById;
    if (l$proposedById != lOther$proposedById) {
      return false;
    }
    final l$transaktion = transaktion;
    final lOther$transaktion = other.transaktion;
    if (l$transaktion != lOther$transaktion) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage;

  TRes call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion?
    transaktion,
    String? $__typename,
  });
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
    TRes
  >
  get transaktion;
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? proposedMinutes = _undefined,
    Object? proposedDate = _undefined,
    Object? proposedNote = _undefined,
    Object? proposedById = _undefined,
    Object? transaktion = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      proposedMinutes: proposedMinutes == _undefined
          ? _instance.proposedMinutes
          : (proposedMinutes as int?),
      proposedDate: proposedDate == _undefined
          ? _instance.proposedDate
          : (proposedDate as DateTime?),
      proposedNote: proposedNote == _undefined
          ? _instance.proposedNote
          : (proposedNote as String?),
      proposedById: proposedById == _undefined
          ? _instance.proposedById
          : (proposedById as String?),
      transaktion: transaktion == _undefined
          ? _instance.transaktion
          : (transaktion
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
    TRes
  >
  get transaktion {
    final local$transaktion = _instance.transaktion;
    return local$transaktion == null
        ? CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion.stub(
            _then(_instance),
          )
        : CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
            local$transaktion,
            (e) => call(transaktion: e),
          );
  }
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion?
    transaktion,
    String? $__typename,
  }) => _res;

  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
    TRes
  >
  get transaktion =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion.stub(
        _res,
      );
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion({
    required this.id,
    required this.minutes,
    required this.performedOn,
    this.note,
    required this.status,
    this.$__typename = 'EhrenamtsbankTransaktion',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$minutes = json['minutes'];
    final l$performedOn = json['performedOn'];
    final l$note = json['note'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
      id: (l$id as String),
      minutes: (l$minutes as int),
      performedOn: localDateFromJson(l$performedOn),
      note: (l$note as String?),
      status: fromJson_Enum_EhrenamtsbankTransaktionStatus(
        (l$status as String),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int minutes;

  final DateTime performedOn;

  final String? note;

  final Enum_EhrenamtsbankTransaktionStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$minutes = minutes;
    _resultData['minutes'] = l$minutes;
    final l$performedOn = performedOn;
    _resultData['performedOn'] = localDateToJson(l$performedOn);
    final l$note = note;
    _resultData['note'] = l$note;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankTransaktionStatus(
      l$status,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$minutes = minutes;
    final l$performedOn = performedOn;
    final l$note = note;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$minutes,
      l$performedOn,
      l$note,
      l$status,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$minutes = minutes;
    final lOther$minutes = other.minutes;
    if (l$minutes != lOther$minutes) {
      return false;
    }
    final l$performedOn = performedOn;
    final lOther$performedOn = other.performedOn;
    if (l$performedOn != lOther$performedOn) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion;

  TRes call({
    String? id,
    int? minutes,
    DateTime? performedOn,
    String? note,
    Enum_EhrenamtsbankTransaktionStatus? status,
    String? $__typename,
  });
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? minutes = _undefined,
    Object? performedOn = _undefined,
    Object? note = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      minutes: minutes == _undefined || minutes == null
          ? _instance.minutes
          : (minutes as int),
      performedOn: performedOn == _undefined || performedOn == null
          ? _instance.performedOn
          : (performedOn as DateTime),
      note: note == _undefined ? _instance.note : (note as String?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankTransaktionStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_ehrenamtsbankAnfrage_transaktion(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? minutes,
    DateTime? performedOn,
    String? note,
    Enum_EhrenamtsbankTransaktionStatus? status,
    String? $__typename,
  }) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors({
    required this.$__typename,
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "AbschlussAlreadyBookedError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError.fromJson(
          json,
        );

      case "AbschlussEintragNotAssignedError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.fromJson(
          json,
        );

      case "AbschlussNoProposalError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError.fromJson(
          json,
        );

      case "AbschlussNotVereinbartError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.fromJson(
          json,
        );

      case "AbschlussSelfConfirmError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError.fromJson(
          json,
        );

      case "AnfrageNotFoundError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.fromJson(
          json,
        );

      case "EintragNotFoundError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError.fromJson(
          json,
        );

      case "NotAllowedError":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError.fromJson(
          json,
        );

      case "Unauthenticated":
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
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
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors ||
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
        this,
        (i) => i,
      );

  _T when<_T>({
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
    )
    abschlussAlreadyBookedError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )
    abschlussEintragNotAssignedError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
    )
    abschlussNoProposalError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )
    abschlussNotVereinbartError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
    )
    abschlussSelfConfirmError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )
    anfrageNotFoundError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )
    eintragNotFoundError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
    )
    notAllowedError,
    required _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
    )
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AbschlussAlreadyBookedError":
        return abschlussAlreadyBookedError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
        );

      case "AbschlussEintragNotAssignedError":
        return abschlussEintragNotAssignedError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
        );

      case "AbschlussNoProposalError":
        return abschlussNoProposalError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
        );

      case "AbschlussNotVereinbartError":
        return abschlussNotVereinbartError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
        );

      case "AbschlussSelfConfirmError":
        return abschlussSelfConfirmError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
        );

      case "AnfrageNotFoundError":
        return anfrageNotFoundError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
        );

      case "EintragNotFoundError":
        return eintragNotFoundError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
        );

      case "NotAllowedError":
        return notAllowedError(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
        );

      case "Unauthenticated":
        return unauthenticated(
          this
              as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
    )?
    abschlussAlreadyBookedError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )?
    abschlussEintragNotAssignedError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
    )?
    abschlussNoProposalError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )?
    abschlussNotVereinbartError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
    )?
    abschlussSelfConfirmError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )?
    anfrageNotFoundError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )?
    eintragNotFoundError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
    )?
    notAllowedError,
    _T Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
    )?
    unauthenticated,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "AbschlussAlreadyBookedError":
        if (abschlussAlreadyBookedError != null) {
          return abschlussAlreadyBookedError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
          );
        } else {
          return orElse();
        }

      case "AbschlussEintragNotAssignedError":
        if (abschlussEintragNotAssignedError != null) {
          return abschlussEintragNotAssignedError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
          );
        } else {
          return orElse();
        }

      case "AbschlussNoProposalError":
        if (abschlussNoProposalError != null) {
          return abschlussNoProposalError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
          );
        } else {
          return orElse();
        }

      case "AbschlussNotVereinbartError":
        if (abschlussNotVereinbartError != null) {
          return abschlussNotVereinbartError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
          );
        } else {
          return orElse();
        }

      case "AbschlussSelfConfirmError":
        if (abschlussSelfConfirmError != null) {
          return abschlussSelfConfirmError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
          );
        } else {
          return orElse();
        }

      case "AnfrageNotFoundError":
        if (anfrageNotFoundError != null) {
          return anfrageNotFoundError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
          );
        } else {
          return orElse();
        }

      case "EintragNotFoundError":
        if (eintragNotFoundError != null) {
          return eintragNotFoundError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
          );
        } else {
          return orElse();
        }

      case "NotAllowedError":
        if (notAllowedError != null) {
          return notAllowedError(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
          );
        } else {
          return orElse();
        }

      case "Unauthenticated":
        if (unauthenticated != null) {
          return unauthenticated(
            this
                as Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors;

  TRes call({String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError({
    required this.message,
    this.$__typename = 'AbschlussAlreadyBookedError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussAlreadyBookedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError({
    required this.message,
    this.$__typename = 'AbschlussEintragNotAssignedError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussEintragNotAssignedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError({
    required this.message,
    this.$__typename = 'AbschlussNoProposalError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNoProposalError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError({
    required this.message,
    this.$__typename = 'AbschlussNotVereinbartError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussNotVereinbartError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError({
    required this.message,
    this.$__typename = 'AbschlussSelfConfirmError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AbschlussSelfConfirmError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError({
    required this.message,
    this.$__typename = 'AnfrageNotFoundError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__AnfrageNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError({
    required this.message,
    this.$__typename = 'EintragNotFoundError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__EintragNotFoundError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError({
    required this.message,
    this.$__typename = 'NotAllowedError',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__NotAllowedError(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated
    implements
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors {
  Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated({
    required this.message,
    this.$__typename = 'Unauthenticated',
  });

  factory Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$message = json['message'];
    final l$$__typename = json['__typename'];
    return Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
      message: (l$message as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String message;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$message = message;
    _resultData['message'] = l$message;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$message = message;
    final l$$__typename = $__typename;
    return Object.hashAll([l$message, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$message = message;
    final lOther$message = other.message;
    if (l$message != lOther$message) {
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

extension UtilityExtension_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated
    on
        Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated {
  CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated
  >
  get copyWith =>
      CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
> {
  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated
    instance,
    TRes Function(
      Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
    )
    then,
  ) = _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated;

  factory CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated.stub(
    TRes res,
  ) = _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated;

  TRes call({String? message, String? $__typename});
}

class _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
          TRes
        > {
  _CopyWithImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
    this._instance,
    this._then,
  );

  final Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated
  _instance;

  final TRes Function(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? message = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
      message: message == _undefined || message == null
          ? _instance.message
          : (message as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
  TRes
>
    implements
        CopyWith_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated<
          TRes
        > {
  _CopyWithStubImpl_Mutation_ConfirmVolunteerInterestCompletion_confirmEhrenamtsbankAbschluss_errors__Unauthenticated(
    this._res,
  );

  TRes _res;

  call({String? message, String? $__typename}) => _res;
}

class Query_MyVolunteerTimeCredit {
  Query_MyVolunteerTimeCredit({
    required this.meinEhrenamtsbankZeitkonto,
    this.$__typename = 'Query',
  });

  factory Query_MyVolunteerTimeCredit.fromJson(Map<String, dynamic> json) {
    final l$meinEhrenamtsbankZeitkonto = json['meinEhrenamtsbankZeitkonto'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerTimeCredit(
      meinEhrenamtsbankZeitkonto:
          Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto.fromJson(
            (l$meinEhrenamtsbankZeitkonto as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto
  meinEhrenamtsbankZeitkonto;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$meinEhrenamtsbankZeitkonto = meinEhrenamtsbankZeitkonto;
    _resultData['meinEhrenamtsbankZeitkonto'] = l$meinEhrenamtsbankZeitkonto
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$meinEhrenamtsbankZeitkonto = meinEhrenamtsbankZeitkonto;
    final l$$__typename = $__typename;
    return Object.hashAll([l$meinEhrenamtsbankZeitkonto, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerTimeCredit ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$meinEhrenamtsbankZeitkonto = meinEhrenamtsbankZeitkonto;
    final lOther$meinEhrenamtsbankZeitkonto = other.meinEhrenamtsbankZeitkonto;
    if (l$meinEhrenamtsbankZeitkonto != lOther$meinEhrenamtsbankZeitkonto) {
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

extension UtilityExtension_Query_MyVolunteerTimeCredit
    on Query_MyVolunteerTimeCredit {
  CopyWith_Query_MyVolunteerTimeCredit<Query_MyVolunteerTimeCredit>
  get copyWith => CopyWith_Query_MyVolunteerTimeCredit(this, (i) => i);
}

abstract class CopyWith_Query_MyVolunteerTimeCredit<TRes> {
  factory CopyWith_Query_MyVolunteerTimeCredit(
    Query_MyVolunteerTimeCredit instance,
    TRes Function(Query_MyVolunteerTimeCredit) then,
  ) = _CopyWithImpl_Query_MyVolunteerTimeCredit;

  factory CopyWith_Query_MyVolunteerTimeCredit.stub(TRes res) =
      _CopyWithStubImpl_Query_MyVolunteerTimeCredit;

  TRes call({
    Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto?
    meinEhrenamtsbankZeitkonto,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes>
  get meinEhrenamtsbankZeitkonto;
}

class _CopyWithImpl_Query_MyVolunteerTimeCredit<TRes>
    implements CopyWith_Query_MyVolunteerTimeCredit<TRes> {
  _CopyWithImpl_Query_MyVolunteerTimeCredit(this._instance, this._then);

  final Query_MyVolunteerTimeCredit _instance;

  final TRes Function(Query_MyVolunteerTimeCredit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? meinEhrenamtsbankZeitkonto = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerTimeCredit(
      meinEhrenamtsbankZeitkonto:
          meinEhrenamtsbankZeitkonto == _undefined ||
              meinEhrenamtsbankZeitkonto == null
          ? _instance.meinEhrenamtsbankZeitkonto
          : (meinEhrenamtsbankZeitkonto
                as Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes>
  get meinEhrenamtsbankZeitkonto {
    final local$meinEhrenamtsbankZeitkonto =
        _instance.meinEhrenamtsbankZeitkonto;
    return CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
      local$meinEhrenamtsbankZeitkonto,
      (e) => call(meinEhrenamtsbankZeitkonto: e),
    );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerTimeCredit<TRes>
    implements CopyWith_Query_MyVolunteerTimeCredit<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerTimeCredit(this._res);

  TRes _res;

  call({
    Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto?
    meinEhrenamtsbankZeitkonto,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes>
  get meinEhrenamtsbankZeitkonto =>
      CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto.stub(
        _res,
      );
}

const documentNodeQueryMyVolunteerTimeCredit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyVolunteerTimeCredit'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'meinEhrenamtsbankZeitkonto'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'startCreditMinutes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'creditMinutes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'debitMinutes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'balanceMinutes'),
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
);
Query_MyVolunteerTimeCredit _parserFn_Query_MyVolunteerTimeCredit(
  Map<String, dynamic> data,
) => Query_MyVolunteerTimeCredit.fromJson(data);
typedef OnQueryComplete_Query_MyVolunteerTimeCredit =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_MyVolunteerTimeCredit?,
    );

class Options_Query_MyVolunteerTimeCredit
    extends graphql.QueryOptions<Query_MyVolunteerTimeCredit> {
  Options_Query_MyVolunteerTimeCredit({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerTimeCredit? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyVolunteerTimeCredit? onComplete,
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
                 data == null
                     ? null
                     : _parserFn_Query_MyVolunteerTimeCredit(data),
               ),
         onError: onError,
         document: documentNodeQueryMyVolunteerTimeCredit,
         parserFn: _parserFn_Query_MyVolunteerTimeCredit,
       );

  final OnQueryComplete_Query_MyVolunteerTimeCredit? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyVolunteerTimeCredit
    extends graphql.WatchQueryOptions<Query_MyVolunteerTimeCredit> {
  WatchOptions_Query_MyVolunteerTimeCredit({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerTimeCredit? typedOptimisticResult,
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
         document: documentNodeQueryMyVolunteerTimeCredit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyVolunteerTimeCredit,
       );
}

class FetchMoreOptions_Query_MyVolunteerTimeCredit
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyVolunteerTimeCredit({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryMyVolunteerTimeCredit,
       );
}

extension ClientExtension_Query_MyVolunteerTimeCredit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyVolunteerTimeCredit>>
  query_MyVolunteerTimeCredit([
    Options_Query_MyVolunteerTimeCredit? options,
  ]) async =>
      await this.query(options ?? Options_Query_MyVolunteerTimeCredit());

  graphql.ObservableQuery<Query_MyVolunteerTimeCredit>
  watchQuery_MyVolunteerTimeCredit([
    WatchOptions_Query_MyVolunteerTimeCredit? options,
  ]) => this.watchQuery(options ?? WatchOptions_Query_MyVolunteerTimeCredit());

  void writeQuery_MyVolunteerTimeCredit({
    required Query_MyVolunteerTimeCredit data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryMyVolunteerTimeCredit,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyVolunteerTimeCredit? readQuery_MyVolunteerTimeCredit({
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryMyVolunteerTimeCredit,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyVolunteerTimeCredit.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyVolunteerTimeCredit>
useQuery_MyVolunteerTimeCredit([
  Options_Query_MyVolunteerTimeCredit? options,
]) =>
    graphql_flutter.useQuery(options ?? Options_Query_MyVolunteerTimeCredit());
graphql.ObservableQuery<Query_MyVolunteerTimeCredit>
useWatchQuery_MyVolunteerTimeCredit([
  WatchOptions_Query_MyVolunteerTimeCredit? options,
]) => graphql_flutter.useWatchQuery(
  options ?? WatchOptions_Query_MyVolunteerTimeCredit(),
);

class Query_MyVolunteerTimeCredit_Widget
    extends graphql_flutter.Query<Query_MyVolunteerTimeCredit> {
  Query_MyVolunteerTimeCredit_Widget({
    widgets.Key? key,
    Options_Query_MyVolunteerTimeCredit? options,
    required graphql_flutter.QueryBuilder<Query_MyVolunteerTimeCredit> builder,
  }) : super(
         key: key,
         options: options ?? Options_Query_MyVolunteerTimeCredit(),
         builder: builder,
       );
}

class Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto {
  Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto({
    required this.startCreditMinutes,
    required this.creditMinutes,
    required this.debitMinutes,
    required this.balanceMinutes,
    this.$__typename = 'EhrenamtsbankZeitkonto',
  });

  factory Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$startCreditMinutes = json['startCreditMinutes'];
    final l$creditMinutes = json['creditMinutes'];
    final l$debitMinutes = json['debitMinutes'];
    final l$balanceMinutes = json['balanceMinutes'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
      startCreditMinutes: (l$startCreditMinutes as int),
      creditMinutes: (l$creditMinutes as int),
      debitMinutes: (l$debitMinutes as int),
      balanceMinutes: (l$balanceMinutes as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int startCreditMinutes;

  final int creditMinutes;

  final int debitMinutes;

  final int balanceMinutes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$startCreditMinutes = startCreditMinutes;
    _resultData['startCreditMinutes'] = l$startCreditMinutes;
    final l$creditMinutes = creditMinutes;
    _resultData['creditMinutes'] = l$creditMinutes;
    final l$debitMinutes = debitMinutes;
    _resultData['debitMinutes'] = l$debitMinutes;
    final l$balanceMinutes = balanceMinutes;
    _resultData['balanceMinutes'] = l$balanceMinutes;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$startCreditMinutes = startCreditMinutes;
    final l$creditMinutes = creditMinutes;
    final l$debitMinutes = debitMinutes;
    final l$balanceMinutes = balanceMinutes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$startCreditMinutes,
      l$creditMinutes,
      l$debitMinutes,
      l$balanceMinutes,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$startCreditMinutes = startCreditMinutes;
    final lOther$startCreditMinutes = other.startCreditMinutes;
    if (l$startCreditMinutes != lOther$startCreditMinutes) {
      return false;
    }
    final l$creditMinutes = creditMinutes;
    final lOther$creditMinutes = other.creditMinutes;
    if (l$creditMinutes != lOther$creditMinutes) {
      return false;
    }
    final l$debitMinutes = debitMinutes;
    final lOther$debitMinutes = other.debitMinutes;
    if (l$debitMinutes != lOther$debitMinutes) {
      return false;
    }
    final l$balanceMinutes = balanceMinutes;
    final lOther$balanceMinutes = other.balanceMinutes;
    if (l$balanceMinutes != lOther$balanceMinutes) {
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

extension UtilityExtension_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto
    on Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto {
  CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<
    Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<
  TRes
> {
  factory CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
    Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto instance,
    TRes Function(Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto) then,
  ) = _CopyWithImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto;

  factory CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto;

  TRes call({
    int? startCreditMinutes,
    int? creditMinutes,
    int? debitMinutes,
    int? balanceMinutes,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes>
    implements
        CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes> {
  _CopyWithImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto _instance;

  final TRes Function(Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startCreditMinutes = _undefined,
    Object? creditMinutes = _undefined,
    Object? debitMinutes = _undefined,
    Object? balanceMinutes = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
      startCreditMinutes:
          startCreditMinutes == _undefined || startCreditMinutes == null
          ? _instance.startCreditMinutes
          : (startCreditMinutes as int),
      creditMinutes: creditMinutes == _undefined || creditMinutes == null
          ? _instance.creditMinutes
          : (creditMinutes as int),
      debitMinutes: debitMinutes == _undefined || debitMinutes == null
          ? _instance.debitMinutes
          : (debitMinutes as int),
      balanceMinutes: balanceMinutes == _undefined || balanceMinutes == null
          ? _instance.balanceMinutes
          : (balanceMinutes as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerTimeCredit_meinEhrenamtsbankZeitkonto(
    this._res,
  );

  TRes _res;

  call({
    int? startCreditMinutes,
    int? creditMinutes,
    int? debitMinutes,
    int? balanceMinutes,
    String? $__typename,
  }) => _res;
}

class Variables_Query_MyVolunteerInterestForEntry {
  factory Variables_Query_MyVolunteerInterestForEntry({
    required String entryId,
  }) => Variables_Query_MyVolunteerInterestForEntry._({r'entryId': entryId});

  Variables_Query_MyVolunteerInterestForEntry._(this._$data);

  factory Variables_Query_MyVolunteerInterestForEntry.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entryId = data['entryId'];
    result$data['entryId'] = (l$entryId as String);
    return Variables_Query_MyVolunteerInterestForEntry._(result$data);
  }

  Map<String, dynamic> _$data;

  String get entryId => (_$data['entryId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$entryId = entryId;
    result$data['entryId'] = l$entryId;
    return result$data;
  }

  CopyWith_Variables_Query_MyVolunteerInterestForEntry<
    Variables_Query_MyVolunteerInterestForEntry
  >
  get copyWith =>
      CopyWith_Variables_Query_MyVolunteerInterestForEntry(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_MyVolunteerInterestForEntry ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$entryId = entryId;
    final lOther$entryId = other.entryId;
    if (l$entryId != lOther$entryId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$entryId = entryId;
    return Object.hashAll([l$entryId]);
  }
}

abstract class CopyWith_Variables_Query_MyVolunteerInterestForEntry<TRes> {
  factory CopyWith_Variables_Query_MyVolunteerInterestForEntry(
    Variables_Query_MyVolunteerInterestForEntry instance,
    TRes Function(Variables_Query_MyVolunteerInterestForEntry) then,
  ) = _CopyWithImpl_Variables_Query_MyVolunteerInterestForEntry;

  factory CopyWith_Variables_Query_MyVolunteerInterestForEntry.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_MyVolunteerInterestForEntry;

  TRes call({String? entryId});
}

class _CopyWithImpl_Variables_Query_MyVolunteerInterestForEntry<TRes>
    implements CopyWith_Variables_Query_MyVolunteerInterestForEntry<TRes> {
  _CopyWithImpl_Variables_Query_MyVolunteerInterestForEntry(
    this._instance,
    this._then,
  );

  final Variables_Query_MyVolunteerInterestForEntry _instance;

  final TRes Function(Variables_Query_MyVolunteerInterestForEntry) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? entryId = _undefined}) => _then(
    Variables_Query_MyVolunteerInterestForEntry._({
      ..._instance._$data,
      if (entryId != _undefined && entryId != null)
        'entryId': (entryId as String),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_MyVolunteerInterestForEntry<TRes>
    implements CopyWith_Variables_Query_MyVolunteerInterestForEntry<TRes> {
  _CopyWithStubImpl_Variables_Query_MyVolunteerInterestForEntry(this._res);

  TRes _res;

  call({String? entryId}) => _res;
}

class Query_MyVolunteerInterestForEntry {
  Query_MyVolunteerInterestForEntry({
    this.meineEhrenamtsbankAnfrageFuerEintrag,
    this.$__typename = 'Query',
  });

  factory Query_MyVolunteerInterestForEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$meineEhrenamtsbankAnfrageFuerEintrag =
        json['meineEhrenamtsbankAnfrageFuerEintrag'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterestForEntry(
      meineEhrenamtsbankAnfrageFuerEintrag:
          l$meineEhrenamtsbankAnfrageFuerEintrag == null
          ? null
          : Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag.fromJson(
              (l$meineEhrenamtsbankAnfrageFuerEintrag as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag?
  meineEhrenamtsbankAnfrageFuerEintrag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$meineEhrenamtsbankAnfrageFuerEintrag =
        meineEhrenamtsbankAnfrageFuerEintrag;
    _resultData['meineEhrenamtsbankAnfrageFuerEintrag'] =
        l$meineEhrenamtsbankAnfrageFuerEintrag?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$meineEhrenamtsbankAnfrageFuerEintrag =
        meineEhrenamtsbankAnfrageFuerEintrag;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$meineEhrenamtsbankAnfrageFuerEintrag,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerInterestForEntry ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$meineEhrenamtsbankAnfrageFuerEintrag =
        meineEhrenamtsbankAnfrageFuerEintrag;
    final lOther$meineEhrenamtsbankAnfrageFuerEintrag =
        other.meineEhrenamtsbankAnfrageFuerEintrag;
    if (l$meineEhrenamtsbankAnfrageFuerEintrag !=
        lOther$meineEhrenamtsbankAnfrageFuerEintrag) {
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

extension UtilityExtension_Query_MyVolunteerInterestForEntry
    on Query_MyVolunteerInterestForEntry {
  CopyWith_Query_MyVolunteerInterestForEntry<Query_MyVolunteerInterestForEntry>
  get copyWith => CopyWith_Query_MyVolunteerInterestForEntry(this, (i) => i);
}

abstract class CopyWith_Query_MyVolunteerInterestForEntry<TRes> {
  factory CopyWith_Query_MyVolunteerInterestForEntry(
    Query_MyVolunteerInterestForEntry instance,
    TRes Function(Query_MyVolunteerInterestForEntry) then,
  ) = _CopyWithImpl_Query_MyVolunteerInterestForEntry;

  factory CopyWith_Query_MyVolunteerInterestForEntry.stub(TRes res) =
      _CopyWithStubImpl_Query_MyVolunteerInterestForEntry;

  TRes call({
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag?
    meineEhrenamtsbankAnfrageFuerEintrag,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
    TRes
  >
  get meineEhrenamtsbankAnfrageFuerEintrag;
}

class _CopyWithImpl_Query_MyVolunteerInterestForEntry<TRes>
    implements CopyWith_Query_MyVolunteerInterestForEntry<TRes> {
  _CopyWithImpl_Query_MyVolunteerInterestForEntry(this._instance, this._then);

  final Query_MyVolunteerInterestForEntry _instance;

  final TRes Function(Query_MyVolunteerInterestForEntry) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? meineEhrenamtsbankAnfrageFuerEintrag = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterestForEntry(
      meineEhrenamtsbankAnfrageFuerEintrag:
          meineEhrenamtsbankAnfrageFuerEintrag == _undefined
          ? _instance.meineEhrenamtsbankAnfrageFuerEintrag
          : (meineEhrenamtsbankAnfrageFuerEintrag
                as Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
    TRes
  >
  get meineEhrenamtsbankAnfrageFuerEintrag {
    final local$meineEhrenamtsbankAnfrageFuerEintrag =
        _instance.meineEhrenamtsbankAnfrageFuerEintrag;
    return local$meineEhrenamtsbankAnfrageFuerEintrag == null
        ? CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
            local$meineEhrenamtsbankAnfrageFuerEintrag,
            (e) => call(meineEhrenamtsbankAnfrageFuerEintrag: e),
          );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerInterestForEntry<TRes>
    implements CopyWith_Query_MyVolunteerInterestForEntry<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerInterestForEntry(this._res);

  TRes _res;

  call({
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag?
    meineEhrenamtsbankAnfrageFuerEintrag,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
    TRes
  >
  get meineEhrenamtsbankAnfrageFuerEintrag =>
      CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag.stub(
        _res,
      );
}

const documentNodeQueryMyVolunteerInterestForEntry = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyVolunteerInterestForEntry'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entryId')),
          type: NamedTypeNode(name: NameNode(value: 'UUID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'meineEhrenamtsbankAnfrageFuerEintrag'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'eintragId'),
                value: VariableNode(name: NameNode(value: 'entryId')),
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
                  name: NameNode(value: 'status'),
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
                  name: NameNode(value: 'createdAt'),
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
);
Query_MyVolunteerInterestForEntry _parserFn_Query_MyVolunteerInterestForEntry(
  Map<String, dynamic> data,
) => Query_MyVolunteerInterestForEntry.fromJson(data);
typedef OnQueryComplete_Query_MyVolunteerInterestForEntry =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query_MyVolunteerInterestForEntry?,
    );

class Options_Query_MyVolunteerInterestForEntry
    extends graphql.QueryOptions<Query_MyVolunteerInterestForEntry> {
  Options_Query_MyVolunteerInterestForEntry({
    String? operationName,
    required Variables_Query_MyVolunteerInterestForEntry variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerInterestForEntry? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyVolunteerInterestForEntry? onComplete,
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
                     : _parserFn_Query_MyVolunteerInterestForEntry(data),
               ),
         onError: onError,
         document: documentNodeQueryMyVolunteerInterestForEntry,
         parserFn: _parserFn_Query_MyVolunteerInterestForEntry,
       );

  final OnQueryComplete_Query_MyVolunteerInterestForEntry? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyVolunteerInterestForEntry
    extends graphql.WatchQueryOptions<Query_MyVolunteerInterestForEntry> {
  WatchOptions_Query_MyVolunteerInterestForEntry({
    String? operationName,
    required Variables_Query_MyVolunteerInterestForEntry variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerInterestForEntry? typedOptimisticResult,
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
         document: documentNodeQueryMyVolunteerInterestForEntry,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyVolunteerInterestForEntry,
       );
}

class FetchMoreOptions_Query_MyVolunteerInterestForEntry
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyVolunteerInterestForEntry({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_MyVolunteerInterestForEntry variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMyVolunteerInterestForEntry,
       );
}

extension ClientExtension_Query_MyVolunteerInterestForEntry
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyVolunteerInterestForEntry>>
  query_MyVolunteerInterestForEntry(
    Options_Query_MyVolunteerInterestForEntry options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_MyVolunteerInterestForEntry>
  watchQuery_MyVolunteerInterestForEntry(
    WatchOptions_Query_MyVolunteerInterestForEntry options,
  ) => this.watchQuery(options);

  void writeQuery_MyVolunteerInterestForEntry({
    required Query_MyVolunteerInterestForEntry data,
    required Variables_Query_MyVolunteerInterestForEntry variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryMyVolunteerInterestForEntry,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyVolunteerInterestForEntry? readQuery_MyVolunteerInterestForEntry({
    required Variables_Query_MyVolunteerInterestForEntry variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryMyVolunteerInterestForEntry,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query_MyVolunteerInterestForEntry.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyVolunteerInterestForEntry>
useQuery_MyVolunteerInterestForEntry(
  Options_Query_MyVolunteerInterestForEntry options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_MyVolunteerInterestForEntry>
useWatchQuery_MyVolunteerInterestForEntry(
  WatchOptions_Query_MyVolunteerInterestForEntry options,
) => graphql_flutter.useWatchQuery(options);

class Query_MyVolunteerInterestForEntry_Widget
    extends graphql_flutter.Query<Query_MyVolunteerInterestForEntry> {
  Query_MyVolunteerInterestForEntry_Widget({
    widgets.Key? key,
    required Options_Query_MyVolunteerInterestForEntry options,
    required graphql_flutter.QueryBuilder<Query_MyVolunteerInterestForEntry>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag {
  Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag({
    required this.id,
    required this.status,
    this.nachricht,
    required this.createdAt,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$nachricht = json['nachricht'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
      id: (l$id as String),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      nachricht: (l$nachricht as String?),
      createdAt: DateTime.parse((l$createdAt as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final String? nachricht;

  final DateTime createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$nachricht = nachricht;
    _resultData['nachricht'] = l$nachricht;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$nachricht = nachricht;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$nachricht,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$nachricht = nachricht;
    final lOther$nachricht = other.nachricht;
    if (l$nachricht != lOther$nachricht) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag
    on Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag {
  CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag
    instance,
    TRes Function(
      Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag;

  factory CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag;

  TRes call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    String? nachricht,
    DateTime? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag
  _instance;

  final TRes Function(
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? nachricht = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterestForEntry_meineEhrenamtsbankAnfrageFuerEintrag(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum_EhrenamtsbankAnfrageStatus? status,
    String? nachricht,
    DateTime? createdAt,
    String? $__typename,
  }) => _res;
}

class Variables_Query_MyVolunteerInterests {
  factory Variables_Query_MyVolunteerInterests({
    required int skip,
    required int take,
  }) => Variables_Query_MyVolunteerInterests._({r'skip': skip, r'take': take});

  Variables_Query_MyVolunteerInterests._(this._$data);

  factory Variables_Query_MyVolunteerInterests.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$skip = data['skip'];
    result$data['skip'] = (l$skip as int);
    final l$take = data['take'];
    result$data['take'] = (l$take as int);
    return Variables_Query_MyVolunteerInterests._(result$data);
  }

  Map<String, dynamic> _$data;

  int get skip => (_$data['skip'] as int);

  int get take => (_$data['take'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$skip = skip;
    result$data['skip'] = l$skip;
    final l$take = take;
    result$data['take'] = l$take;
    return result$data;
  }

  CopyWith_Variables_Query_MyVolunteerInterests<
    Variables_Query_MyVolunteerInterests
  >
  get copyWith => CopyWith_Variables_Query_MyVolunteerInterests(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables_Query_MyVolunteerInterests ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$skip = skip;
    final lOther$skip = other.skip;
    if (l$skip != lOther$skip) {
      return false;
    }
    final l$take = take;
    final lOther$take = other.take;
    if (l$take != lOther$take) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$skip = skip;
    final l$take = take;
    return Object.hashAll([l$skip, l$take]);
  }
}

abstract class CopyWith_Variables_Query_MyVolunteerInterests<TRes> {
  factory CopyWith_Variables_Query_MyVolunteerInterests(
    Variables_Query_MyVolunteerInterests instance,
    TRes Function(Variables_Query_MyVolunteerInterests) then,
  ) = _CopyWithImpl_Variables_Query_MyVolunteerInterests;

  factory CopyWith_Variables_Query_MyVolunteerInterests.stub(TRes res) =
      _CopyWithStubImpl_Variables_Query_MyVolunteerInterests;

  TRes call({int? skip, int? take});
}

class _CopyWithImpl_Variables_Query_MyVolunteerInterests<TRes>
    implements CopyWith_Variables_Query_MyVolunteerInterests<TRes> {
  _CopyWithImpl_Variables_Query_MyVolunteerInterests(
    this._instance,
    this._then,
  );

  final Variables_Query_MyVolunteerInterests _instance;

  final TRes Function(Variables_Query_MyVolunteerInterests) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? skip = _undefined, Object? take = _undefined}) => _then(
    Variables_Query_MyVolunteerInterests._({
      ..._instance._$data,
      if (skip != _undefined && skip != null) 'skip': (skip as int),
      if (take != _undefined && take != null) 'take': (take as int),
    }),
  );
}

class _CopyWithStubImpl_Variables_Query_MyVolunteerInterests<TRes>
    implements CopyWith_Variables_Query_MyVolunteerInterests<TRes> {
  _CopyWithStubImpl_Variables_Query_MyVolunteerInterests(this._res);

  TRes _res;

  call({int? skip, int? take}) => _res;
}

class Query_MyVolunteerInterests {
  Query_MyVolunteerInterests({
    this.meineEhrenamtsbankAnfragen,
    this.$__typename = 'Query',
  });

  factory Query_MyVolunteerInterests.fromJson(Map<String, dynamic> json) {
    final l$meineEhrenamtsbankAnfragen = json['meineEhrenamtsbankAnfragen'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests(
      meineEhrenamtsbankAnfragen: l$meineEhrenamtsbankAnfragen == null
          ? null
          : Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen.fromJson(
              (l$meineEhrenamtsbankAnfragen as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen?
  meineEhrenamtsbankAnfragen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$meineEhrenamtsbankAnfragen = meineEhrenamtsbankAnfragen;
    _resultData['meineEhrenamtsbankAnfragen'] = l$meineEhrenamtsbankAnfragen
        ?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$meineEhrenamtsbankAnfragen = meineEhrenamtsbankAnfragen;
    final l$$__typename = $__typename;
    return Object.hashAll([l$meineEhrenamtsbankAnfragen, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerInterests ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$meineEhrenamtsbankAnfragen = meineEhrenamtsbankAnfragen;
    final lOther$meineEhrenamtsbankAnfragen = other.meineEhrenamtsbankAnfragen;
    if (l$meineEhrenamtsbankAnfragen != lOther$meineEhrenamtsbankAnfragen) {
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

extension UtilityExtension_Query_MyVolunteerInterests
    on Query_MyVolunteerInterests {
  CopyWith_Query_MyVolunteerInterests<Query_MyVolunteerInterests>
  get copyWith => CopyWith_Query_MyVolunteerInterests(this, (i) => i);
}

abstract class CopyWith_Query_MyVolunteerInterests<TRes> {
  factory CopyWith_Query_MyVolunteerInterests(
    Query_MyVolunteerInterests instance,
    TRes Function(Query_MyVolunteerInterests) then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests;

  factory CopyWith_Query_MyVolunteerInterests.stub(TRes res) =
      _CopyWithStubImpl_Query_MyVolunteerInterests;

  TRes call({
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen?
    meineEhrenamtsbankAnfragen,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes>
  get meineEhrenamtsbankAnfragen;
}

class _CopyWithImpl_Query_MyVolunteerInterests<TRes>
    implements CopyWith_Query_MyVolunteerInterests<TRes> {
  _CopyWithImpl_Query_MyVolunteerInterests(this._instance, this._then);

  final Query_MyVolunteerInterests _instance;

  final TRes Function(Query_MyVolunteerInterests) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? meineEhrenamtsbankAnfragen = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests(
      meineEhrenamtsbankAnfragen: meineEhrenamtsbankAnfragen == _undefined
          ? _instance.meineEhrenamtsbankAnfragen
          : (meineEhrenamtsbankAnfragen
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes>
  get meineEhrenamtsbankAnfragen {
    final local$meineEhrenamtsbankAnfragen =
        _instance.meineEhrenamtsbankAnfragen;
    return local$meineEhrenamtsbankAnfragen == null
        ? CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
            local$meineEhrenamtsbankAnfragen,
            (e) => call(meineEhrenamtsbankAnfragen: e),
          );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerInterests<TRes>
    implements CopyWith_Query_MyVolunteerInterests<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerInterests(this._res);

  TRes _res;

  call({
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen?
    meineEhrenamtsbankAnfragen,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes>
  get meineEhrenamtsbankAnfragen =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen.stub(_res);
}

const documentNodeQueryMyVolunteerInterests = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MyVolunteerInterests'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'skip')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'take')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'meineEhrenamtsbankAnfragen'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'skip'),
                value: VariableNode(name: NameNode(value: 'skip')),
              ),
              ArgumentNode(
                name: NameNode(value: 'take'),
                value: VariableNode(name: NameNode(value: 'take')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'items'),
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
                        name: NameNode(value: 'eintragId'),
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
                        name: NameNode(value: 'status'),
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
                        name: NameNode(value: 'updatedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'vereinbartAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedMinutes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedDate'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedNote'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'proposedById'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'typ'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'interessent'),
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
                              name: NameNode(value: 'vorname'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'nachname'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'phone'),
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
                        name: NameNode(value: 'eintrag'),
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
                              name: NameNode(value: 'description'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'estimatedDurationMinutes'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'owner'),
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
                                    name: NameNode(value: 'vorname'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'nachname'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'phone'),
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
                        name: NameNode(value: 'transaktion'),
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
                              name: NameNode(value: 'minutes'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'performedOn'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'note'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'status'),
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
                  name: NameNode(value: 'pageInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'hasNextPage'),
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
                  name: NameNode(value: 'totalCount'),
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
);
Query_MyVolunteerInterests _parserFn_Query_MyVolunteerInterests(
  Map<String, dynamic> data,
) => Query_MyVolunteerInterests.fromJson(data);
typedef OnQueryComplete_Query_MyVolunteerInterests =
    FutureOr<void> Function(Map<String, dynamic>?, Query_MyVolunteerInterests?);

class Options_Query_MyVolunteerInterests
    extends graphql.QueryOptions<Query_MyVolunteerInterests> {
  Options_Query_MyVolunteerInterests({
    String? operationName,
    required Variables_Query_MyVolunteerInterests variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerInterests? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete_Query_MyVolunteerInterests? onComplete,
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
                     : _parserFn_Query_MyVolunteerInterests(data),
               ),
         onError: onError,
         document: documentNodeQueryMyVolunteerInterests,
         parserFn: _parserFn_Query_MyVolunteerInterests,
       );

  final OnQueryComplete_Query_MyVolunteerInterests? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions_Query_MyVolunteerInterests
    extends graphql.WatchQueryOptions<Query_MyVolunteerInterests> {
  WatchOptions_Query_MyVolunteerInterests({
    String? operationName,
    required Variables_Query_MyVolunteerInterests variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query_MyVolunteerInterests? typedOptimisticResult,
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
         document: documentNodeQueryMyVolunteerInterests,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn_Query_MyVolunteerInterests,
       );
}

class FetchMoreOptions_Query_MyVolunteerInterests
    extends graphql.FetchMoreOptions {
  FetchMoreOptions_Query_MyVolunteerInterests({
    required graphql.UpdateQuery updateQuery,
    required Variables_Query_MyVolunteerInterests variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryMyVolunteerInterests,
       );
}

extension ClientExtension_Query_MyVolunteerInterests on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query_MyVolunteerInterests>>
  query_MyVolunteerInterests(
    Options_Query_MyVolunteerInterests options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query_MyVolunteerInterests>
  watchQuery_MyVolunteerInterests(
    WatchOptions_Query_MyVolunteerInterests options,
  ) => this.watchQuery(options);

  void writeQuery_MyVolunteerInterests({
    required Query_MyVolunteerInterests data,
    required Variables_Query_MyVolunteerInterests variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryMyVolunteerInterests,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query_MyVolunteerInterests? readQuery_MyVolunteerInterests({
    required Variables_Query_MyVolunteerInterests variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryMyVolunteerInterests,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query_MyVolunteerInterests.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query_MyVolunteerInterests>
useQuery_MyVolunteerInterests(Options_Query_MyVolunteerInterests options) =>
    graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query_MyVolunteerInterests>
useWatchQuery_MyVolunteerInterests(
  WatchOptions_Query_MyVolunteerInterests options,
) => graphql_flutter.useWatchQuery(options);

class Query_MyVolunteerInterests_Widget
    extends graphql_flutter.Query<Query_MyVolunteerInterests> {
  Query_MyVolunteerInterests_Widget({
    widgets.Key? key,
    required Options_Query_MyVolunteerInterests options,
    required graphql_flutter.QueryBuilder<Query_MyVolunteerInterests> builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen({
    this.items,
    required this.pageInfo,
    required this.totalCount,
    this.$__typename = 'MeineEhrenamtsbankAnfragenCollectionSegment',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$items = json['items'];
    final l$pageInfo = json['pageInfo'];
    final l$totalCount = json['totalCount'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
      items: (l$items as List<dynamic>?)
          ?.map(
            (e) =>
                Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      pageInfo:
          Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo.fromJson(
            (l$pageInfo as Map<String, dynamic>),
          ),
      totalCount: (l$totalCount as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items>?
  items;

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo pageInfo;

  final int totalCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$items = items;
    _resultData['items'] = l$items?.map((e) => e.toJson()).toList();
    final l$pageInfo = pageInfo;
    _resultData['pageInfo'] = l$pageInfo.toJson();
    final l$totalCount = totalCount;
    _resultData['totalCount'] = l$totalCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$items = items;
    final l$pageInfo = pageInfo;
    final l$totalCount = totalCount;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$items == null ? null : Object.hashAll(l$items.map((v) => v)),
      l$pageInfo,
      l$totalCount,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items != null && lOther$items != null) {
      if (l$items.length != lOther$items.length) {
        return false;
      }
      for (int i = 0; i < l$items.length; i++) {
        final l$items$entry = l$items[i];
        final lOther$items$entry = lOther$items[i];
        if (l$items$entry != lOther$items$entry) {
          return false;
        }
      }
    } else if (l$items != lOther$items) {
      return false;
    }
    final l$pageInfo = pageInfo;
    final lOther$pageInfo = other.pageInfo;
    if (l$pageInfo != lOther$pageInfo) {
      return false;
    }
    final l$totalCount = totalCount;
    final lOther$totalCount = other.totalCount;
    if (l$totalCount != lOther$totalCount) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen instance,
    TRes Function(Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen) then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen;

  TRes call({
    List<Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items>? items,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo? pageInfo,
    int? totalCount,
    String? $__typename,
  });
  TRes items(
    Iterable<Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items>?
    Function(
      Iterable<
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
          Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items
        >
      >?,
    )
    _fn,
  );
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<TRes>
  get pageInfo;
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes> {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen _instance;

  final TRes Function(Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? items = _undefined,
    Object? pageInfo = _undefined,
    Object? totalCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
      items: items == _undefined
          ? _instance.items
          : (items
                as List<
                  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items
                >?),
      pageInfo: pageInfo == _undefined || pageInfo == null
          ? _instance.pageInfo
          : (pageInfo
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo),
      totalCount: totalCount == _undefined || totalCount == null
          ? _instance.totalCount
          : (totalCount as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items>?
    Function(
      Iterable<
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
          Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items
        >
      >?,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items?.map(
        (e) =>
            CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<TRes>
  get pageInfo {
    final local$pageInfo = _instance.pageInfo;
    return CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
      local$pageInfo,
      (e) => call(pageInfo: e),
    );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen<TRes> {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen(
    this._res,
  );

  TRes _res;

  call({
    List<Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items>? items,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo? pageInfo,
    int? totalCount,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<TRes>
  get pageInfo =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo.stub(
        _res,
      );
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items({
    required this.id,
    required this.eintragId,
    this.nachricht,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.vereinbartAt,
    this.proposedMinutes,
    this.proposedDate,
    this.proposedNote,
    this.proposedById,
    required this.typ,
    this.interessent,
    this.eintrag,
    this.transaktion,
    this.$__typename = 'EhrenamtsbankAnfrage',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$eintragId = json['eintragId'];
    final l$nachricht = json['nachricht'];
    final l$status = json['status'];
    final l$createdAt = json['createdAt'];
    final l$updatedAt = json['updatedAt'];
    final l$vereinbartAt = json['vereinbartAt'];
    final l$proposedMinutes = json['proposedMinutes'];
    final l$proposedDate = json['proposedDate'];
    final l$proposedNote = json['proposedNote'];
    final l$proposedById = json['proposedById'];
    final l$typ = json['typ'];
    final l$interessent = json['interessent'];
    final l$eintrag = json['eintrag'];
    final l$transaktion = json['transaktion'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
      id: (l$id as String),
      eintragId: (l$eintragId as String),
      nachricht: (l$nachricht as String?),
      status: fromJson_Enum_EhrenamtsbankAnfrageStatus((l$status as String)),
      createdAt: DateTime.parse((l$createdAt as String)),
      updatedAt: DateTime.parse((l$updatedAt as String)),
      vereinbartAt: l$vereinbartAt == null
          ? null
          : DateTime.parse((l$vereinbartAt as String)),
      proposedMinutes: (l$proposedMinutes as int?),
      proposedDate: l$proposedDate == null
          ? null
          : localDateFromJson(l$proposedDate),
      proposedNote: (l$proposedNote as String?),
      proposedById: (l$proposedById as String?),
      typ: fromJson_Enum_EhrenamtsbankAnfrageTyp((l$typ as String)),
      interessent: l$interessent == null
          ? null
          : Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent.fromJson(
              (l$interessent as Map<String, dynamic>),
            ),
      eintrag: l$eintrag == null
          ? null
          : Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag.fromJson(
              (l$eintrag as Map<String, dynamic>),
            ),
      transaktion: l$transaktion == null
          ? null
          : Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion.fromJson(
              (l$transaktion as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String eintragId;

  final String? nachricht;

  final Enum_EhrenamtsbankAnfrageStatus status;

  final DateTime createdAt;

  final DateTime updatedAt;

  final DateTime? vereinbartAt;

  final int? proposedMinutes;

  final DateTime? proposedDate;

  final String? proposedNote;

  final String? proposedById;

  final Enum_EhrenamtsbankAnfrageTyp typ;

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent?
  interessent;

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag?
  eintrag;

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion?
  transaktion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$eintragId = eintragId;
    _resultData['eintragId'] = l$eintragId;
    final l$nachricht = nachricht;
    _resultData['nachricht'] = l$nachricht;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankAnfrageStatus(l$status);
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt.toIso8601String();
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt.toIso8601String();
    final l$vereinbartAt = vereinbartAt;
    _resultData['vereinbartAt'] = l$vereinbartAt?.toIso8601String();
    final l$proposedMinutes = proposedMinutes;
    _resultData['proposedMinutes'] = l$proposedMinutes;
    final l$proposedDate = proposedDate;
    _resultData['proposedDate'] = l$proposedDate == null
        ? null
        : localDateToJson(l$proposedDate);
    final l$proposedNote = proposedNote;
    _resultData['proposedNote'] = l$proposedNote;
    final l$proposedById = proposedById;
    _resultData['proposedById'] = l$proposedById;
    final l$typ = typ;
    _resultData['typ'] = toJson_Enum_EhrenamtsbankAnfrageTyp(l$typ);
    final l$interessent = interessent;
    _resultData['interessent'] = l$interessent?.toJson();
    final l$eintrag = eintrag;
    _resultData['eintrag'] = l$eintrag?.toJson();
    final l$transaktion = transaktion;
    _resultData['transaktion'] = l$transaktion?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$eintragId = eintragId;
    final l$nachricht = nachricht;
    final l$status = status;
    final l$createdAt = createdAt;
    final l$updatedAt = updatedAt;
    final l$vereinbartAt = vereinbartAt;
    final l$proposedMinutes = proposedMinutes;
    final l$proposedDate = proposedDate;
    final l$proposedNote = proposedNote;
    final l$proposedById = proposedById;
    final l$typ = typ;
    final l$interessent = interessent;
    final l$eintrag = eintrag;
    final l$transaktion = transaktion;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$eintragId,
      l$nachricht,
      l$status,
      l$createdAt,
      l$updatedAt,
      l$vereinbartAt,
      l$proposedMinutes,
      l$proposedDate,
      l$proposedNote,
      l$proposedById,
      l$typ,
      l$interessent,
      l$eintrag,
      l$transaktion,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$eintragId = eintragId;
    final lOther$eintragId = other.eintragId;
    if (l$eintragId != lOther$eintragId) {
      return false;
    }
    final l$nachricht = nachricht;
    final lOther$nachricht = other.nachricht;
    if (l$nachricht != lOther$nachricht) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    final l$vereinbartAt = vereinbartAt;
    final lOther$vereinbartAt = other.vereinbartAt;
    if (l$vereinbartAt != lOther$vereinbartAt) {
      return false;
    }
    final l$proposedMinutes = proposedMinutes;
    final lOther$proposedMinutes = other.proposedMinutes;
    if (l$proposedMinutes != lOther$proposedMinutes) {
      return false;
    }
    final l$proposedDate = proposedDate;
    final lOther$proposedDate = other.proposedDate;
    if (l$proposedDate != lOther$proposedDate) {
      return false;
    }
    final l$proposedNote = proposedNote;
    final lOther$proposedNote = other.proposedNote;
    if (l$proposedNote != lOther$proposedNote) {
      return false;
    }
    final l$proposedById = proposedById;
    final lOther$proposedById = other.proposedById;
    if (l$proposedById != lOther$proposedById) {
      return false;
    }
    final l$typ = typ;
    final lOther$typ = other.typ;
    if (l$typ != lOther$typ) {
      return false;
    }
    final l$interessent = interessent;
    final lOther$interessent = other.interessent;
    if (l$interessent != lOther$interessent) {
      return false;
    }
    final l$eintrag = eintrag;
    final lOther$eintrag = other.eintrag;
    if (l$eintrag != lOther$eintrag) {
      return false;
    }
    final l$transaktion = transaktion;
    final lOther$transaktion = other.transaktion;
    if (l$transaktion != lOther$transaktion) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items instance,
    TRes Function(Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items)
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items;

  TRes call({
    String? id,
    String? eintragId,
    String? nachricht,
    Enum_EhrenamtsbankAnfrageStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? vereinbartAt,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    Enum_EhrenamtsbankAnfrageTyp? typ,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent?
    interessent,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag?
    eintrag,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion?
    transaktion,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
    TRes
  >
  get interessent;
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
    TRes
  >
  get eintrag;
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
    TRes
  >
  get transaktion;
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? eintragId = _undefined,
    Object? nachricht = _undefined,
    Object? status = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? vereinbartAt = _undefined,
    Object? proposedMinutes = _undefined,
    Object? proposedDate = _undefined,
    Object? proposedNote = _undefined,
    Object? proposedById = _undefined,
    Object? typ = _undefined,
    Object? interessent = _undefined,
    Object? eintrag = _undefined,
    Object? transaktion = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      eintragId: eintragId == _undefined || eintragId == null
          ? _instance.eintragId
          : (eintragId as String),
      nachricht: nachricht == _undefined
          ? _instance.nachricht
          : (nachricht as String?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankAnfrageStatus),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as DateTime),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as DateTime),
      vereinbartAt: vereinbartAt == _undefined
          ? _instance.vereinbartAt
          : (vereinbartAt as DateTime?),
      proposedMinutes: proposedMinutes == _undefined
          ? _instance.proposedMinutes
          : (proposedMinutes as int?),
      proposedDate: proposedDate == _undefined
          ? _instance.proposedDate
          : (proposedDate as DateTime?),
      proposedNote: proposedNote == _undefined
          ? _instance.proposedNote
          : (proposedNote as String?),
      proposedById: proposedById == _undefined
          ? _instance.proposedById
          : (proposedById as String?),
      typ: typ == _undefined || typ == null
          ? _instance.typ
          : (typ as Enum_EhrenamtsbankAnfrageTyp),
      interessent: interessent == _undefined
          ? _instance.interessent
          : (interessent
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent?),
      eintrag: eintrag == _undefined
          ? _instance.eintrag
          : (eintrag
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag?),
      transaktion: transaktion == _undefined
          ? _instance.transaktion
          : (transaktion
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
    TRes
  >
  get interessent {
    final local$interessent = _instance.interessent;
    return local$interessent == null
        ? CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
            local$interessent,
            (e) => call(interessent: e),
          );
  }

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
    TRes
  >
  get eintrag {
    final local$eintrag = _instance.eintrag;
    return local$eintrag == null
        ? CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
            local$eintrag,
            (e) => call(eintrag: e),
          );
  }

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
    TRes
  >
  get transaktion {
    final local$transaktion = _instance.transaktion;
    return local$transaktion == null
        ? CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
            local$transaktion,
            (e) => call(transaktion: e),
          );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? eintragId,
    String? nachricht,
    Enum_EhrenamtsbankAnfrageStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? vereinbartAt,
    int? proposedMinutes,
    DateTime? proposedDate,
    String? proposedNote,
    String? proposedById,
    Enum_EhrenamtsbankAnfrageTyp? typ,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent?
    interessent,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag?
    eintrag,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion?
    transaktion,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
    TRes
  >
  get interessent =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent.stub(
        _res,
      );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
    TRes
  >
  get eintrag =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag.stub(
        _res,
      );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
    TRes
  >
  get transaktion =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion.stub(
        _res,
      );
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent({
    required this.id,
    this.vorname,
    this.nachname,
    this.phone,
    this.$__typename = 'EhrenamtsbankProfil',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$vorname = json['vorname'];
    final l$nachname = json['nachname'];
    final l$phone = json['phone'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
      id: (l$id as String),
      vorname: (l$vorname as String?),
      nachname: (l$nachname as String?),
      phone: (l$phone as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? vorname;

  final String? nachname;

  final String? phone;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$vorname = vorname;
    _resultData['vorname'] = l$vorname;
    final l$nachname = nachname;
    _resultData['nachname'] = l$nachname;
    final l$phone = phone;
    _resultData['phone'] = l$phone;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$vorname = vorname;
    final l$nachname = nachname;
    final l$phone = phone;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$vorname,
      l$nachname,
      l$phone,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$vorname = vorname;
    final lOther$vorname = other.vorname;
    if (l$vorname != lOther$vorname) {
      return false;
    }
    final l$nachname = nachname;
    final lOther$nachname = other.nachname;
    if (l$nachname != lOther$nachname) {
      return false;
    }
    final l$phone = phone;
    final lOther$phone = other.phone;
    if (l$phone != lOther$phone) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent
    instance,
    TRes Function(
      Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent;

  TRes call({
    String? id,
    String? vorname,
    String? nachname,
    String? phone,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent
  _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? vorname = _undefined,
    Object? nachname = _undefined,
    Object? phone = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      vorname: vorname == _undefined ? _instance.vorname : (vorname as String?),
      nachname: nachname == _undefined
          ? _instance.nachname
          : (nachname as String?),
      phone: phone == _undefined ? _instance.phone : (phone as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_interessent(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? vorname,
    String? nachname,
    String? phone,
    String? $__typename,
  }) => _res;
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag({
    required this.id,
    required this.title,
    required this.description,
    this.estimatedDurationMinutes,
    this.owner,
    this.$__typename = 'EhrenamtsbankEintrag',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$description = json['description'];
    final l$estimatedDurationMinutes = json['estimatedDurationMinutes'];
    final l$owner = json['owner'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
      id: (l$id as String),
      title: (l$title as String),
      description: (l$description as String),
      estimatedDurationMinutes: (l$estimatedDurationMinutes as int?),
      owner: l$owner == null
          ? null
          : Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner.fromJson(
              (l$owner as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final String description;

  final int? estimatedDurationMinutes;

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner?
  owner;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    _resultData['estimatedDurationMinutes'] = l$estimatedDurationMinutes;
    final l$owner = owner;
    _resultData['owner'] = l$owner?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$description = description;
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    final l$owner = owner;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$description,
      l$estimatedDurationMinutes,
      l$owner,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag ||
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
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$estimatedDurationMinutes = estimatedDurationMinutes;
    final lOther$estimatedDurationMinutes = other.estimatedDurationMinutes;
    if (l$estimatedDurationMinutes != lOther$estimatedDurationMinutes) {
      return false;
    }
    final l$owner = owner;
    final lOther$owner = other.owner;
    if (l$owner != lOther$owner) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag
    instance,
    TRes Function(
      Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag;

  TRes call({
    String? id,
    String? title,
    String? description,
    int? estimatedDurationMinutes,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner?
    owner,
    String? $__typename,
  });
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
    TRes
  >
  get owner;
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag
  _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? description = _undefined,
    Object? estimatedDurationMinutes = _undefined,
    Object? owner = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      description: description == _undefined || description == null
          ? _instance.description
          : (description as String),
      estimatedDurationMinutes: estimatedDurationMinutes == _undefined
          ? _instance.estimatedDurationMinutes
          : (estimatedDurationMinutes as int?),
      owner: owner == _undefined
          ? _instance.owner
          : (owner
                as Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
    TRes
  >
  get owner {
    final local$owner = _instance.owner;
    return local$owner == null
        ? CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner.stub(
            _then(_instance),
          )
        : CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
            local$owner,
            (e) => call(owner: e),
          );
  }
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    String? description,
    int? estimatedDurationMinutes,
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner?
    owner,
    String? $__typename,
  }) => _res;

  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
    TRes
  >
  get owner =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner.stub(
        _res,
      );
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner({
    required this.id,
    this.vorname,
    this.nachname,
    this.phone,
    this.$__typename = 'EhrenamtsbankProfil',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$vorname = json['vorname'];
    final l$nachname = json['nachname'];
    final l$phone = json['phone'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
      id: (l$id as String),
      vorname: (l$vorname as String?),
      nachname: (l$nachname as String?),
      phone: (l$phone as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? vorname;

  final String? nachname;

  final String? phone;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$vorname = vorname;
    _resultData['vorname'] = l$vorname;
    final l$nachname = nachname;
    _resultData['nachname'] = l$nachname;
    final l$phone = phone;
    _resultData['phone'] = l$phone;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$vorname = vorname;
    final l$nachname = nachname;
    final l$phone = phone;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$vorname,
      l$nachname,
      l$phone,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$vorname = vorname;
    final lOther$vorname = other.vorname;
    if (l$vorname != lOther$vorname) {
      return false;
    }
    final l$nachname = nachname;
    final lOther$nachname = other.nachname;
    if (l$nachname != lOther$nachname) {
      return false;
    }
    final l$phone = phone;
    final lOther$phone = other.phone;
    if (l$phone != lOther$phone) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner
    instance,
    TRes Function(
      Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner;

  TRes call({
    String? id,
    String? vorname,
    String? nachname,
    String? phone,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner
  _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? vorname = _undefined,
    Object? nachname = _undefined,
    Object? phone = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      vorname: vorname == _undefined ? _instance.vorname : (vorname as String?),
      nachname: nachname == _undefined
          ? _instance.nachname
          : (nachname as String?),
      phone: phone == _undefined ? _instance.phone : (phone as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_eintrag_owner(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? vorname,
    String? nachname,
    String? phone,
    String? $__typename,
  }) => _res;
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion({
    required this.id,
    required this.minutes,
    required this.performedOn,
    this.note,
    required this.status,
    this.$__typename = 'EhrenamtsbankTransaktion',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$minutes = json['minutes'];
    final l$performedOn = json['performedOn'];
    final l$note = json['note'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
      id: (l$id as String),
      minutes: (l$minutes as int),
      performedOn: localDateFromJson(l$performedOn),
      note: (l$note as String?),
      status: fromJson_Enum_EhrenamtsbankTransaktionStatus(
        (l$status as String),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int minutes;

  final DateTime performedOn;

  final String? note;

  final Enum_EhrenamtsbankTransaktionStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$minutes = minutes;
    _resultData['minutes'] = l$minutes;
    final l$performedOn = performedOn;
    _resultData['performedOn'] = localDateToJson(l$performedOn);
    final l$note = note;
    _resultData['note'] = l$note;
    final l$status = status;
    _resultData['status'] = toJson_Enum_EhrenamtsbankTransaktionStatus(
      l$status,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$minutes = minutes;
    final l$performedOn = performedOn;
    final l$note = note;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$minutes,
      l$performedOn,
      l$note,
      l$status,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$minutes = minutes;
    final lOther$minutes = other.minutes;
    if (l$minutes != lOther$minutes) {
      return false;
    }
    final l$performedOn = performedOn;
    final lOther$performedOn = other.performedOn;
    if (l$performedOn != lOther$performedOn) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion
    instance,
    TRes Function(
      Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion;

  TRes call({
    String? id,
    int? minutes,
    DateTime? performedOn,
    String? note,
    Enum_EhrenamtsbankTransaktionStatus? status,
    String? $__typename,
  });
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion
  _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? minutes = _undefined,
    Object? performedOn = _undefined,
    Object? note = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      minutes: minutes == _undefined || minutes == null
          ? _instance.minutes
          : (minutes as int),
      performedOn: performedOn == _undefined || performedOn == null
          ? _instance.performedOn
          : (performedOn as DateTime),
      note: note == _undefined ? _instance.note : (note as String?),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum_EhrenamtsbankTransaktionStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_items_transaktion(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? minutes,
    DateTime? performedOn,
    String? note,
    Enum_EhrenamtsbankTransaktionStatus? status,
    String? $__typename,
  }) => _res;
}

class Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo {
  Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo({
    required this.hasNextPage,
    this.$__typename = 'CollectionSegmentInfo',
  });

  factory Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$hasNextPage = json['hasNextPage'];
    final l$$__typename = json['__typename'];
    return Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
      hasNextPage: (l$hasNextPage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool hasNextPage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hasNextPage = hasNextPage;
    _resultData['hasNextPage'] = l$hasNextPage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hasNextPage = hasNextPage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$hasNextPage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hasNextPage = hasNextPage;
    final lOther$hasNextPage = other.hasNextPage;
    if (l$hasNextPage != lOther$hasNextPage) {
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

extension UtilityExtension_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo
    on Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo {
  CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo
  >
  get copyWith =>
      CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
        this,
        (i) => i,
      );
}

abstract class CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
  TRes
> {
  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo instance,
    TRes Function(
      Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo,
    )
    then,
  ) = _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo;

  factory CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo.stub(
    TRes res,
  ) = _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo;

  TRes call({bool? hasNextPage, String? $__typename});
}

class _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
          TRes
        > {
  _CopyWithImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
    this._instance,
    this._then,
  );

  final Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo
  _instance;

  final TRes Function(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hasNextPage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
      hasNextPage: hasNextPage == _undefined || hasNextPage == null
          ? _instance.hasNextPage
          : (hasNextPage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
  TRes
>
    implements
        CopyWith_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo<
          TRes
        > {
  _CopyWithStubImpl_Query_MyVolunteerInterests_meineEhrenamtsbankAnfragen_pageInfo(
    this._res,
  );

  TRes _res;

  call({bool? hasNextPage, String? $__typename}) => _res;
}
