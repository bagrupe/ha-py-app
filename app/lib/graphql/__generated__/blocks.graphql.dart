import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Fragment_RichTextBlock {
  Fragment_RichTextBlock({
    this.contentHtml,
    this.$__typename = 'RichTextBlock',
  });

  factory Fragment_RichTextBlock.fromJson(Map<String, dynamic> json) {
    final l$contentHtml = json['contentHtml'];
    final l$$__typename = json['__typename'];
    return Fragment_RichTextBlock(
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
    if (other is! Fragment_RichTextBlock || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_RichTextBlock on Fragment_RichTextBlock {
  CopyWith_Fragment_RichTextBlock<Fragment_RichTextBlock> get copyWith =>
      CopyWith_Fragment_RichTextBlock(this, (i) => i);
}

abstract class CopyWith_Fragment_RichTextBlock<TRes> {
  factory CopyWith_Fragment_RichTextBlock(
    Fragment_RichTextBlock instance,
    TRes Function(Fragment_RichTextBlock) then,
  ) = _CopyWithImpl_Fragment_RichTextBlock;

  factory CopyWith_Fragment_RichTextBlock.stub(TRes res) =
      _CopyWithStubImpl_Fragment_RichTextBlock;

  TRes call({String? contentHtml, String? $__typename});
}

class _CopyWithImpl_Fragment_RichTextBlock<TRes>
    implements CopyWith_Fragment_RichTextBlock<TRes> {
  _CopyWithImpl_Fragment_RichTextBlock(this._instance, this._then);

  final Fragment_RichTextBlock _instance;

  final TRes Function(Fragment_RichTextBlock) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? contentHtml = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_RichTextBlock(
      contentHtml: contentHtml == _undefined
          ? _instance.contentHtml
          : (contentHtml as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl_Fragment_RichTextBlock<TRes>
    implements CopyWith_Fragment_RichTextBlock<TRes> {
  _CopyWithStubImpl_Fragment_RichTextBlock(this._res);

  TRes _res;

  call({String? contentHtml, String? $__typename}) => _res;
}

const fragmentDefinitionRichTextBlock = FragmentDefinitionNode(
  name: NameNode(value: 'RichTextBlock'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'RichTextBlock'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'contentHtml'),
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
const documentNodeFragmentRichTextBlock = DocumentNode(
  definitions: [fragmentDefinitionRichTextBlock],
);

extension ClientExtension_Fragment_RichTextBlock on graphql.GraphQLClient {
  void writeFragment_RichTextBlock({
    required Fragment_RichTextBlock data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'RichTextBlock',
        document: documentNodeFragmentRichTextBlock,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_RichTextBlock? readFragment_RichTextBlock({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'RichTextBlock',
          document: documentNodeFragmentRichTextBlock,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_RichTextBlock.fromJson(result);
  }
}

class Fragment_ImageBlockMedien {
  Fragment_ImageBlockMedien({
    this.image,
    this.$__typename = 'ImageBlockMedien',
  });

  factory Fragment_ImageBlockMedien.fromJson(Map<String, dynamic> json) {
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Fragment_ImageBlockMedien(
      image: l$image == null
          ? null
          : Fragment_MedienImage.fromJson((l$image as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_MedienImage? image;

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
    if (other is! Fragment_ImageBlockMedien ||
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

extension UtilityExtension_Fragment_ImageBlockMedien
    on Fragment_ImageBlockMedien {
  CopyWith_Fragment_ImageBlockMedien<Fragment_ImageBlockMedien> get copyWith =>
      CopyWith_Fragment_ImageBlockMedien(this, (i) => i);
}

abstract class CopyWith_Fragment_ImageBlockMedien<TRes> {
  factory CopyWith_Fragment_ImageBlockMedien(
    Fragment_ImageBlockMedien instance,
    TRes Function(Fragment_ImageBlockMedien) then,
  ) = _CopyWithImpl_Fragment_ImageBlockMedien;

  factory CopyWith_Fragment_ImageBlockMedien.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ImageBlockMedien;

  TRes call({Fragment_MedienImage? image, String? $__typename});
  CopyWith_Fragment_MedienImage<TRes> get image;
}

class _CopyWithImpl_Fragment_ImageBlockMedien<TRes>
    implements CopyWith_Fragment_ImageBlockMedien<TRes> {
  _CopyWithImpl_Fragment_ImageBlockMedien(this._instance, this._then);

  final Fragment_ImageBlockMedien _instance;

  final TRes Function(Fragment_ImageBlockMedien) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? image = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_ImageBlockMedien(
          image: image == _undefined
              ? _instance.image
              : (image as Fragment_MedienImage?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith_Fragment_MedienImage<TRes> get image {
    final local$image = _instance.image;
    return local$image == null
        ? CopyWith_Fragment_MedienImage.stub(_then(_instance))
        : CopyWith_Fragment_MedienImage(local$image, (e) => call(image: e));
  }
}

class _CopyWithStubImpl_Fragment_ImageBlockMedien<TRes>
    implements CopyWith_Fragment_ImageBlockMedien<TRes> {
  _CopyWithStubImpl_Fragment_ImageBlockMedien(this._res);

  TRes _res;

  call({Fragment_MedienImage? image, String? $__typename}) => _res;

  CopyWith_Fragment_MedienImage<TRes> get image =>
      CopyWith_Fragment_MedienImage.stub(_res);
}

const fragmentDefinitionImageBlockMedien = FragmentDefinitionNode(
  name: NameNode(value: 'ImageBlockMedien'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ImageBlockMedien'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'image'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'MedienImage'),
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
const documentNodeFragmentImageBlockMedien = DocumentNode(
  definitions: [
    fragmentDefinitionImageBlockMedien,
    fragmentDefinitionMedienImage,
  ],
);

extension ClientExtension_Fragment_ImageBlockMedien on graphql.GraphQLClient {
  void writeFragment_ImageBlockMedien({
    required Fragment_ImageBlockMedien data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ImageBlockMedien',
        document: documentNodeFragmentImageBlockMedien,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ImageBlockMedien? readFragment_ImageBlockMedien({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ImageBlockMedien',
          document: documentNodeFragmentImageBlockMedien,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_ImageBlockMedien.fromJson(result);
  }
}

class Fragment_ImageBlockVeranstaltungsmedien {
  Fragment_ImageBlockVeranstaltungsmedien({
    this.image,
    this.$__typename = 'ImageBlockVeranstaltungsmedien',
  });

  factory Fragment_ImageBlockVeranstaltungsmedien.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Fragment_ImageBlockVeranstaltungsmedien(
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
    if (other is! Fragment_ImageBlockVeranstaltungsmedien ||
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

extension UtilityExtension_Fragment_ImageBlockVeranstaltungsmedien
    on Fragment_ImageBlockVeranstaltungsmedien {
  CopyWith_Fragment_ImageBlockVeranstaltungsmedien<
    Fragment_ImageBlockVeranstaltungsmedien
  >
  get copyWith =>
      CopyWith_Fragment_ImageBlockVeranstaltungsmedien(this, (i) => i);
}

abstract class CopyWith_Fragment_ImageBlockVeranstaltungsmedien<TRes> {
  factory CopyWith_Fragment_ImageBlockVeranstaltungsmedien(
    Fragment_ImageBlockVeranstaltungsmedien instance,
    TRes Function(Fragment_ImageBlockVeranstaltungsmedien) then,
  ) = _CopyWithImpl_Fragment_ImageBlockVeranstaltungsmedien;

  factory CopyWith_Fragment_ImageBlockVeranstaltungsmedien.stub(TRes res) =
      _CopyWithStubImpl_Fragment_ImageBlockVeranstaltungsmedien;

  TRes call({Fragment_VeranstaltungsmedienImage? image, String? $__typename});
  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image;
}

class _CopyWithImpl_Fragment_ImageBlockVeranstaltungsmedien<TRes>
    implements CopyWith_Fragment_ImageBlockVeranstaltungsmedien<TRes> {
  _CopyWithImpl_Fragment_ImageBlockVeranstaltungsmedien(
    this._instance,
    this._then,
  );

  final Fragment_ImageBlockVeranstaltungsmedien _instance;

  final TRes Function(Fragment_ImageBlockVeranstaltungsmedien) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? image = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_ImageBlockVeranstaltungsmedien(
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

class _CopyWithStubImpl_Fragment_ImageBlockVeranstaltungsmedien<TRes>
    implements CopyWith_Fragment_ImageBlockVeranstaltungsmedien<TRes> {
  _CopyWithStubImpl_Fragment_ImageBlockVeranstaltungsmedien(this._res);

  TRes _res;

  call({Fragment_VeranstaltungsmedienImage? image, String? $__typename}) =>
      _res;

  CopyWith_Fragment_VeranstaltungsmedienImage<TRes> get image =>
      CopyWith_Fragment_VeranstaltungsmedienImage.stub(_res);
}

const fragmentDefinitionImageBlockVeranstaltungsmedien = FragmentDefinitionNode(
  name: NameNode(value: 'ImageBlockVeranstaltungsmedien'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ImageBlockVeranstaltungsmedien'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'image'),
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
);
const documentNodeFragmentImageBlockVeranstaltungsmedien = DocumentNode(
  definitions: [
    fragmentDefinitionImageBlockVeranstaltungsmedien,
    fragmentDefinitionVeranstaltungsmedienImage,
  ],
);

extension ClientExtension_Fragment_ImageBlockVeranstaltungsmedien
    on graphql.GraphQLClient {
  void writeFragment_ImageBlockVeranstaltungsmedien({
    required Fragment_ImageBlockVeranstaltungsmedien data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ImageBlockVeranstaltungsmedien',
        document: documentNodeFragmentImageBlockVeranstaltungsmedien,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_ImageBlockVeranstaltungsmedien?
  readFragment_ImageBlockVeranstaltungsmedien({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ImageBlockVeranstaltungsmedien',
          document: documentNodeFragmentImageBlockVeranstaltungsmedien,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_ImageBlockVeranstaltungsmedien.fromJson(result);
  }
}

class Fragment_MedienImage {
  Fragment_MedienImage({this.url, this.$__typename = 'Medien'});

  factory Fragment_MedienImage.fromJson(Map<String, dynamic> json) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_MedienImage(
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
    if (other is! Fragment_MedienImage || runtimeType != other.runtimeType) {
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

extension UtilityExtension_Fragment_MedienImage on Fragment_MedienImage {
  CopyWith_Fragment_MedienImage<Fragment_MedienImage> get copyWith =>
      CopyWith_Fragment_MedienImage(this, (i) => i);
}

abstract class CopyWith_Fragment_MedienImage<TRes> {
  factory CopyWith_Fragment_MedienImage(
    Fragment_MedienImage instance,
    TRes Function(Fragment_MedienImage) then,
  ) = _CopyWithImpl_Fragment_MedienImage;

  factory CopyWith_Fragment_MedienImage.stub(TRes res) =
      _CopyWithStubImpl_Fragment_MedienImage;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_MedienImage<TRes>
    implements CopyWith_Fragment_MedienImage<TRes> {
  _CopyWithImpl_Fragment_MedienImage(this._instance, this._then);

  final Fragment_MedienImage _instance;

  final TRes Function(Fragment_MedienImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_MedienImage(
          url: url == _undefined ? _instance.url : (url as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_MedienImage<TRes>
    implements CopyWith_Fragment_MedienImage<TRes> {
  _CopyWithStubImpl_Fragment_MedienImage(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

const fragmentDefinitionMedienImage = FragmentDefinitionNode(
  name: NameNode(value: 'MedienImage'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Medien'), isNonNull: false),
  ),
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
);
const documentNodeFragmentMedienImage = DocumentNode(
  definitions: [fragmentDefinitionMedienImage],
);

extension ClientExtension_Fragment_MedienImage on graphql.GraphQLClient {
  void writeFragment_MedienImage({
    required Fragment_MedienImage data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'MedienImage',
        document: documentNodeFragmentMedienImage,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_MedienImage? readFragment_MedienImage({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'MedienImage',
          document: documentNodeFragmentMedienImage,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment_MedienImage.fromJson(result);
  }
}

class Fragment_VeranstaltungsmedienImage {
  Fragment_VeranstaltungsmedienImage({
    this.url,
    this.sourceUrl,
    this.sizes,
    this.$__typename = 'Veranstaltungsmedien',
  });

  factory Fragment_VeranstaltungsmedienImage.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$sourceUrl = json['sourceUrl'];
    final l$sizes = json['sizes'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungsmedienImage(
      url: (l$url as String?),
      sourceUrl: (l$sourceUrl as String?),
      sizes: l$sizes == null
          ? null
          : Fragment_VeranstaltungsmedienImage_sizes.fromJson(
              (l$sizes as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String? url;

  final String? sourceUrl;

  final Fragment_VeranstaltungsmedienImage_sizes? sizes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$sourceUrl = sourceUrl;
    _resultData['sourceUrl'] = l$sourceUrl;
    final l$sizes = sizes;
    _resultData['sizes'] = l$sizes?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$sourceUrl = sourceUrl;
    final l$sizes = sizes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$sourceUrl, l$sizes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungsmedienImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$sourceUrl = sourceUrl;
    final lOther$sourceUrl = other.sourceUrl;
    if (l$sourceUrl != lOther$sourceUrl) {
      return false;
    }
    final l$sizes = sizes;
    final lOther$sizes = other.sizes;
    if (l$sizes != lOther$sizes) {
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

extension UtilityExtension_Fragment_VeranstaltungsmedienImage
    on Fragment_VeranstaltungsmedienImage {
  CopyWith_Fragment_VeranstaltungsmedienImage<
    Fragment_VeranstaltungsmedienImage
  >
  get copyWith => CopyWith_Fragment_VeranstaltungsmedienImage(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungsmedienImage<TRes> {
  factory CopyWith_Fragment_VeranstaltungsmedienImage(
    Fragment_VeranstaltungsmedienImage instance,
    TRes Function(Fragment_VeranstaltungsmedienImage) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungsmedienImage;

  factory CopyWith_Fragment_VeranstaltungsmedienImage.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage;

  TRes call({
    String? url,
    String? sourceUrl,
    Fragment_VeranstaltungsmedienImage_sizes? sizes,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> get sizes;
}

class _CopyWithImpl_Fragment_VeranstaltungsmedienImage<TRes>
    implements CopyWith_Fragment_VeranstaltungsmedienImage<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungsmedienImage(this._instance, this._then);

  final Fragment_VeranstaltungsmedienImage _instance;

  final TRes Function(Fragment_VeranstaltungsmedienImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? url = _undefined,
    Object? sourceUrl = _undefined,
    Object? sizes = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungsmedienImage(
      url: url == _undefined ? _instance.url : (url as String?),
      sourceUrl: sourceUrl == _undefined
          ? _instance.sourceUrl
          : (sourceUrl as String?),
      sizes: sizes == _undefined
          ? _instance.sizes
          : (sizes as Fragment_VeranstaltungsmedienImage_sizes?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> get sizes {
    final local$sizes = _instance.sizes;
    return local$sizes == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage_sizes.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_VeranstaltungsmedienImage_sizes(
            local$sizes,
            (e) => call(sizes: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage<TRes>
    implements CopyWith_Fragment_VeranstaltungsmedienImage<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage(this._res);

  TRes _res;

  call({
    String? url,
    String? sourceUrl,
    Fragment_VeranstaltungsmedienImage_sizes? sizes,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> get sizes =>
      CopyWith_Fragment_VeranstaltungsmedienImage_sizes.stub(_res);
}

const fragmentDefinitionVeranstaltungsmedienImage = FragmentDefinitionNode(
  name: NameNode(value: 'VeranstaltungsmedienImage'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'Veranstaltungsmedien'),
      isNonNull: false,
    ),
  ),
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
        name: NameNode(value: 'sourceUrl'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sizes'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'thumbnail'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentVeranstaltungsmedienImage = DocumentNode(
  definitions: [fragmentDefinitionVeranstaltungsmedienImage],
);

extension ClientExtension_Fragment_VeranstaltungsmedienImage
    on graphql.GraphQLClient {
  void writeFragment_VeranstaltungsmedienImage({
    required Fragment_VeranstaltungsmedienImage data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'VeranstaltungsmedienImage',
        document: documentNodeFragmentVeranstaltungsmedienImage,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment_VeranstaltungsmedienImage? readFragment_VeranstaltungsmedienImage({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'VeranstaltungsmedienImage',
          document: documentNodeFragmentVeranstaltungsmedienImage,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment_VeranstaltungsmedienImage.fromJson(result);
  }
}

class Fragment_VeranstaltungsmedienImage_sizes {
  Fragment_VeranstaltungsmedienImage_sizes({
    this.thumbnail,
    this.$__typename = 'Veranstaltungsmedien_Sizes',
  });

  factory Fragment_VeranstaltungsmedienImage_sizes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$thumbnail = json['thumbnail'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungsmedienImage_sizes(
      thumbnail: l$thumbnail == null
          ? null
          : Fragment_VeranstaltungsmedienImage_sizes_thumbnail.fromJson(
              (l$thumbnail as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment_VeranstaltungsmedienImage_sizes_thumbnail? thumbnail;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$thumbnail = thumbnail;
    _resultData['thumbnail'] = l$thumbnail?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$thumbnail = thumbnail;
    final l$$__typename = $__typename;
    return Object.hashAll([l$thumbnail, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment_VeranstaltungsmedienImage_sizes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$thumbnail = thumbnail;
    final lOther$thumbnail = other.thumbnail;
    if (l$thumbnail != lOther$thumbnail) {
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

extension UtilityExtension_Fragment_VeranstaltungsmedienImage_sizes
    on Fragment_VeranstaltungsmedienImage_sizes {
  CopyWith_Fragment_VeranstaltungsmedienImage_sizes<
    Fragment_VeranstaltungsmedienImage_sizes
  >
  get copyWith =>
      CopyWith_Fragment_VeranstaltungsmedienImage_sizes(this, (i) => i);
}

abstract class CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> {
  factory CopyWith_Fragment_VeranstaltungsmedienImage_sizes(
    Fragment_VeranstaltungsmedienImage_sizes instance,
    TRes Function(Fragment_VeranstaltungsmedienImage_sizes) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes;

  factory CopyWith_Fragment_VeranstaltungsmedienImage_sizes.stub(TRes res) =
      _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes;

  TRes call({
    Fragment_VeranstaltungsmedienImage_sizes_thumbnail? thumbnail,
    String? $__typename,
  });
  CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes>
  get thumbnail;
}

class _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes<TRes>
    implements CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungsmedienImage_sizes _instance;

  final TRes Function(Fragment_VeranstaltungsmedienImage_sizes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? thumbnail = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment_VeranstaltungsmedienImage_sizes(
      thumbnail: thumbnail == _undefined
          ? _instance.thumbnail
          : (thumbnail as Fragment_VeranstaltungsmedienImage_sizes_thumbnail?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes>
  get thumbnail {
    final local$thumbnail = _instance.thumbnail;
    return local$thumbnail == null
        ? CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail.stub(
            _then(_instance),
          )
        : CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
            local$thumbnail,
            (e) => call(thumbnail: e),
          );
  }
}

class _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes<TRes>
    implements CopyWith_Fragment_VeranstaltungsmedienImage_sizes<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes(this._res);

  TRes _res;

  call({
    Fragment_VeranstaltungsmedienImage_sizes_thumbnail? thumbnail,
    String? $__typename,
  }) => _res;

  CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes>
  get thumbnail =>
      CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail.stub(_res);
}

class Fragment_VeranstaltungsmedienImage_sizes_thumbnail {
  Fragment_VeranstaltungsmedienImage_sizes_thumbnail({
    this.url,
    this.$__typename = 'Veranstaltungsmedien_Sizes_Thumbnail',
  });

  factory Fragment_VeranstaltungsmedienImage_sizes_thumbnail.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
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
    if (other is! Fragment_VeranstaltungsmedienImage_sizes_thumbnail ||
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

extension UtilityExtension_Fragment_VeranstaltungsmedienImage_sizes_thumbnail
    on Fragment_VeranstaltungsmedienImage_sizes_thumbnail {
  CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<
    Fragment_VeranstaltungsmedienImage_sizes_thumbnail
  >
  get copyWith => CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
    this,
    (i) => i,
  );
}

abstract class CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<
  TRes
> {
  factory CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
    Fragment_VeranstaltungsmedienImage_sizes_thumbnail instance,
    TRes Function(Fragment_VeranstaltungsmedienImage_sizes_thumbnail) then,
  ) = _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail;

  factory CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail.stub(
    TRes res,
  ) = _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes>
    implements
        CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes> {
  _CopyWithImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
    this._instance,
    this._then,
  );

  final Fragment_VeranstaltungsmedienImage_sizes_thumbnail _instance;

  final TRes Function(Fragment_VeranstaltungsmedienImage_sizes_thumbnail) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
          url: url == _undefined ? _instance.url : (url as String?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes>
    implements
        CopyWith_Fragment_VeranstaltungsmedienImage_sizes_thumbnail<TRes> {
  _CopyWithStubImpl_Fragment_VeranstaltungsmedienImage_sizes_thumbnail(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}
