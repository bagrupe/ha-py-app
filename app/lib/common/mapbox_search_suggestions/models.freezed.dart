// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapboxSuggestions {

 List<MapboxSuggestion>? get suggestions;
/// Create a copy of MapboxSuggestions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxSuggestionsCopyWith<MapboxSuggestions> get copyWith => _$MapboxSuggestionsCopyWithImpl<MapboxSuggestions>(this as MapboxSuggestions, _$identity);

  /// Serializes this MapboxSuggestions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxSuggestions&&const DeepCollectionEquality().equals(other.suggestions, suggestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(suggestions));

@override
String toString() {
  return 'MapboxSuggestions(suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class $MapboxSuggestionsCopyWith<$Res>  {
  factory $MapboxSuggestionsCopyWith(MapboxSuggestions value, $Res Function(MapboxSuggestions) _then) = _$MapboxSuggestionsCopyWithImpl;
@useResult
$Res call({
 List<MapboxSuggestion>? suggestions
});




}
/// @nodoc
class _$MapboxSuggestionsCopyWithImpl<$Res>
    implements $MapboxSuggestionsCopyWith<$Res> {
  _$MapboxSuggestionsCopyWithImpl(this._self, this._then);

  final MapboxSuggestions _self;
  final $Res Function(MapboxSuggestions) _then;

/// Create a copy of MapboxSuggestions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suggestions = freezed,}) {
  return _then(_self.copyWith(
suggestions: freezed == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<MapboxSuggestion>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapboxSuggestions].
extension MapboxSuggestionsPatterns on MapboxSuggestions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxSuggestions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxSuggestions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxSuggestions value)  $default,){
final _that = this;
switch (_that) {
case _MapboxSuggestions():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxSuggestions value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxSuggestions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapboxSuggestion>? suggestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxSuggestions() when $default != null:
return $default(_that.suggestions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapboxSuggestion>? suggestions)  $default,) {final _that = this;
switch (_that) {
case _MapboxSuggestions():
return $default(_that.suggestions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapboxSuggestion>? suggestions)?  $default,) {final _that = this;
switch (_that) {
case _MapboxSuggestions() when $default != null:
return $default(_that.suggestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxSuggestions implements MapboxSuggestions {
  const _MapboxSuggestions({final  List<MapboxSuggestion>? suggestions}): _suggestions = suggestions;
  factory _MapboxSuggestions.fromJson(Map<String, dynamic> json) => _$MapboxSuggestionsFromJson(json);

 final  List<MapboxSuggestion>? _suggestions;
@override List<MapboxSuggestion>? get suggestions {
  final value = _suggestions;
  if (value == null) return null;
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MapboxSuggestions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxSuggestionsCopyWith<_MapboxSuggestions> get copyWith => __$MapboxSuggestionsCopyWithImpl<_MapboxSuggestions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxSuggestionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxSuggestions&&const DeepCollectionEquality().equals(other._suggestions, _suggestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_suggestions));

@override
String toString() {
  return 'MapboxSuggestions(suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class _$MapboxSuggestionsCopyWith<$Res> implements $MapboxSuggestionsCopyWith<$Res> {
  factory _$MapboxSuggestionsCopyWith(_MapboxSuggestions value, $Res Function(_MapboxSuggestions) _then) = __$MapboxSuggestionsCopyWithImpl;
@override @useResult
$Res call({
 List<MapboxSuggestion>? suggestions
});




}
/// @nodoc
class __$MapboxSuggestionsCopyWithImpl<$Res>
    implements _$MapboxSuggestionsCopyWith<$Res> {
  __$MapboxSuggestionsCopyWithImpl(this._self, this._then);

  final _MapboxSuggestions _self;
  final $Res Function(_MapboxSuggestions) _then;

/// Create a copy of MapboxSuggestions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suggestions = freezed,}) {
  return _then(_MapboxSuggestions(
suggestions: freezed == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<MapboxSuggestion>?,
  ));
}


}


/// @nodoc
mixin _$MapboxSuggestion {

 String get name; String get mapboxId; String? get fullAddress; String? get placeFormatted;
/// Create a copy of MapboxSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxSuggestionCopyWith<MapboxSuggestion> get copyWith => _$MapboxSuggestionCopyWithImpl<MapboxSuggestion>(this as MapboxSuggestion, _$identity);

  /// Serializes this MapboxSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxSuggestion&&(identical(other.name, name) || other.name == name)&&(identical(other.mapboxId, mapboxId) || other.mapboxId == mapboxId)&&(identical(other.fullAddress, fullAddress) || other.fullAddress == fullAddress)&&(identical(other.placeFormatted, placeFormatted) || other.placeFormatted == placeFormatted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mapboxId,fullAddress,placeFormatted);

@override
String toString() {
  return 'MapboxSuggestion(name: $name, mapboxId: $mapboxId, fullAddress: $fullAddress, placeFormatted: $placeFormatted)';
}


}

/// @nodoc
abstract mixin class $MapboxSuggestionCopyWith<$Res>  {
  factory $MapboxSuggestionCopyWith(MapboxSuggestion value, $Res Function(MapboxSuggestion) _then) = _$MapboxSuggestionCopyWithImpl;
@useResult
$Res call({
 String name, String mapboxId, String? fullAddress, String? placeFormatted
});




}
/// @nodoc
class _$MapboxSuggestionCopyWithImpl<$Res>
    implements $MapboxSuggestionCopyWith<$Res> {
  _$MapboxSuggestionCopyWithImpl(this._self, this._then);

  final MapboxSuggestion _self;
  final $Res Function(MapboxSuggestion) _then;

/// Create a copy of MapboxSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? mapboxId = null,Object? fullAddress = freezed,Object? placeFormatted = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mapboxId: null == mapboxId ? _self.mapboxId : mapboxId // ignore: cast_nullable_to_non_nullable
as String,fullAddress: freezed == fullAddress ? _self.fullAddress : fullAddress // ignore: cast_nullable_to_non_nullable
as String?,placeFormatted: freezed == placeFormatted ? _self.placeFormatted : placeFormatted // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapboxSuggestion].
extension MapboxSuggestionPatterns on MapboxSuggestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxSuggestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _MapboxSuggestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxSuggestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String mapboxId,  String? fullAddress,  String? placeFormatted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxSuggestion() when $default != null:
return $default(_that.name,_that.mapboxId,_that.fullAddress,_that.placeFormatted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String mapboxId,  String? fullAddress,  String? placeFormatted)  $default,) {final _that = this;
switch (_that) {
case _MapboxSuggestion():
return $default(_that.name,_that.mapboxId,_that.fullAddress,_that.placeFormatted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String mapboxId,  String? fullAddress,  String? placeFormatted)?  $default,) {final _that = this;
switch (_that) {
case _MapboxSuggestion() when $default != null:
return $default(_that.name,_that.mapboxId,_that.fullAddress,_that.placeFormatted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxSuggestion implements MapboxSuggestion {
  const _MapboxSuggestion({required this.name, required this.mapboxId, this.fullAddress, this.placeFormatted});
  factory _MapboxSuggestion.fromJson(Map<String, dynamic> json) => _$MapboxSuggestionFromJson(json);

@override final  String name;
@override final  String mapboxId;
@override final  String? fullAddress;
@override final  String? placeFormatted;

/// Create a copy of MapboxSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxSuggestionCopyWith<_MapboxSuggestion> get copyWith => __$MapboxSuggestionCopyWithImpl<_MapboxSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxSuggestion&&(identical(other.name, name) || other.name == name)&&(identical(other.mapboxId, mapboxId) || other.mapboxId == mapboxId)&&(identical(other.fullAddress, fullAddress) || other.fullAddress == fullAddress)&&(identical(other.placeFormatted, placeFormatted) || other.placeFormatted == placeFormatted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mapboxId,fullAddress,placeFormatted);

@override
String toString() {
  return 'MapboxSuggestion(name: $name, mapboxId: $mapboxId, fullAddress: $fullAddress, placeFormatted: $placeFormatted)';
}


}

/// @nodoc
abstract mixin class _$MapboxSuggestionCopyWith<$Res> implements $MapboxSuggestionCopyWith<$Res> {
  factory _$MapboxSuggestionCopyWith(_MapboxSuggestion value, $Res Function(_MapboxSuggestion) _then) = __$MapboxSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String name, String mapboxId, String? fullAddress, String? placeFormatted
});




}
/// @nodoc
class __$MapboxSuggestionCopyWithImpl<$Res>
    implements _$MapboxSuggestionCopyWith<$Res> {
  __$MapboxSuggestionCopyWithImpl(this._self, this._then);

  final _MapboxSuggestion _self;
  final $Res Function(_MapboxSuggestion) _then;

/// Create a copy of MapboxSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? mapboxId = null,Object? fullAddress = freezed,Object? placeFormatted = freezed,}) {
  return _then(_MapboxSuggestion(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mapboxId: null == mapboxId ? _self.mapboxId : mapboxId // ignore: cast_nullable_to_non_nullable
as String,fullAddress: freezed == fullAddress ? _self.fullAddress : fullAddress // ignore: cast_nullable_to_non_nullable
as String?,placeFormatted: freezed == placeFormatted ? _self.placeFormatted : placeFormatted // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MapboxRetrievals {

 List<MapboxRetrievalFeature> get features;
/// Create a copy of MapboxRetrievals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxRetrievalsCopyWith<MapboxRetrievals> get copyWith => _$MapboxRetrievalsCopyWithImpl<MapboxRetrievals>(this as MapboxRetrievals, _$identity);

  /// Serializes this MapboxRetrievals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxRetrievals&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'MapboxRetrievals(features: $features)';
}


}

/// @nodoc
abstract mixin class $MapboxRetrievalsCopyWith<$Res>  {
  factory $MapboxRetrievalsCopyWith(MapboxRetrievals value, $Res Function(MapboxRetrievals) _then) = _$MapboxRetrievalsCopyWithImpl;
@useResult
$Res call({
 List<MapboxRetrievalFeature> features
});




}
/// @nodoc
class _$MapboxRetrievalsCopyWithImpl<$Res>
    implements $MapboxRetrievalsCopyWith<$Res> {
  _$MapboxRetrievalsCopyWithImpl(this._self, this._then);

  final MapboxRetrievals _self;
  final $Res Function(MapboxRetrievals) _then;

/// Create a copy of MapboxRetrievals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? features = null,}) {
  return _then(_self.copyWith(
features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<MapboxRetrievalFeature>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapboxRetrievals].
extension MapboxRetrievalsPatterns on MapboxRetrievals {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxRetrievals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxRetrievals() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxRetrievals value)  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievals():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxRetrievals value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievals() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapboxRetrievalFeature> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxRetrievals() when $default != null:
return $default(_that.features);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapboxRetrievalFeature> features)  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievals():
return $default(_that.features);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapboxRetrievalFeature> features)?  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievals() when $default != null:
return $default(_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxRetrievals implements MapboxRetrievals {
  const _MapboxRetrievals({required final  List<MapboxRetrievalFeature> features}): _features = features;
  factory _MapboxRetrievals.fromJson(Map<String, dynamic> json) => _$MapboxRetrievalsFromJson(json);

 final  List<MapboxRetrievalFeature> _features;
@override List<MapboxRetrievalFeature> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of MapboxRetrievals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxRetrievalsCopyWith<_MapboxRetrievals> get copyWith => __$MapboxRetrievalsCopyWithImpl<_MapboxRetrievals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxRetrievalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxRetrievals&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'MapboxRetrievals(features: $features)';
}


}

/// @nodoc
abstract mixin class _$MapboxRetrievalsCopyWith<$Res> implements $MapboxRetrievalsCopyWith<$Res> {
  factory _$MapboxRetrievalsCopyWith(_MapboxRetrievals value, $Res Function(_MapboxRetrievals) _then) = __$MapboxRetrievalsCopyWithImpl;
@override @useResult
$Res call({
 List<MapboxRetrievalFeature> features
});




}
/// @nodoc
class __$MapboxRetrievalsCopyWithImpl<$Res>
    implements _$MapboxRetrievalsCopyWith<$Res> {
  __$MapboxRetrievalsCopyWithImpl(this._self, this._then);

  final _MapboxRetrievals _self;
  final $Res Function(_MapboxRetrievals) _then;

/// Create a copy of MapboxRetrievals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? features = null,}) {
  return _then(_MapboxRetrievals(
features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<MapboxRetrievalFeature>,
  ));
}


}


/// @nodoc
mixin _$MapboxRetrievalFeature {

 MapboxRetrievalFeatureProperties get properties;
/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxRetrievalFeatureCopyWith<MapboxRetrievalFeature> get copyWith => _$MapboxRetrievalFeatureCopyWithImpl<MapboxRetrievalFeature>(this as MapboxRetrievalFeature, _$identity);

  /// Serializes this MapboxRetrievalFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxRetrievalFeature&&(identical(other.properties, properties) || other.properties == properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,properties);

@override
String toString() {
  return 'MapboxRetrievalFeature(properties: $properties)';
}


}

/// @nodoc
abstract mixin class $MapboxRetrievalFeatureCopyWith<$Res>  {
  factory $MapboxRetrievalFeatureCopyWith(MapboxRetrievalFeature value, $Res Function(MapboxRetrievalFeature) _then) = _$MapboxRetrievalFeatureCopyWithImpl;
@useResult
$Res call({
 MapboxRetrievalFeatureProperties properties
});


$MapboxRetrievalFeaturePropertiesCopyWith<$Res> get properties;

}
/// @nodoc
class _$MapboxRetrievalFeatureCopyWithImpl<$Res>
    implements $MapboxRetrievalFeatureCopyWith<$Res> {
  _$MapboxRetrievalFeatureCopyWithImpl(this._self, this._then);

  final MapboxRetrievalFeature _self;
  final $Res Function(MapboxRetrievalFeature) _then;

/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? properties = null,}) {
  return _then(_self.copyWith(
properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as MapboxRetrievalFeatureProperties,
  ));
}
/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapboxRetrievalFeaturePropertiesCopyWith<$Res> get properties {
  
  return $MapboxRetrievalFeaturePropertiesCopyWith<$Res>(_self.properties, (value) {
    return _then(_self.copyWith(properties: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapboxRetrievalFeature].
extension MapboxRetrievalFeaturePatterns on MapboxRetrievalFeature {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxRetrievalFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeature() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxRetrievalFeature value)  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeature():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxRetrievalFeature value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeature() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapboxRetrievalFeatureProperties properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeature() when $default != null:
return $default(_that.properties);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapboxRetrievalFeatureProperties properties)  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeature():
return $default(_that.properties);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapboxRetrievalFeatureProperties properties)?  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeature() when $default != null:
return $default(_that.properties);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxRetrievalFeature implements MapboxRetrievalFeature {
  const _MapboxRetrievalFeature({required this.properties});
  factory _MapboxRetrievalFeature.fromJson(Map<String, dynamic> json) => _$MapboxRetrievalFeatureFromJson(json);

@override final  MapboxRetrievalFeatureProperties properties;

/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxRetrievalFeatureCopyWith<_MapboxRetrievalFeature> get copyWith => __$MapboxRetrievalFeatureCopyWithImpl<_MapboxRetrievalFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxRetrievalFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxRetrievalFeature&&(identical(other.properties, properties) || other.properties == properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,properties);

@override
String toString() {
  return 'MapboxRetrievalFeature(properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$MapboxRetrievalFeatureCopyWith<$Res> implements $MapboxRetrievalFeatureCopyWith<$Res> {
  factory _$MapboxRetrievalFeatureCopyWith(_MapboxRetrievalFeature value, $Res Function(_MapboxRetrievalFeature) _then) = __$MapboxRetrievalFeatureCopyWithImpl;
@override @useResult
$Res call({
 MapboxRetrievalFeatureProperties properties
});


@override $MapboxRetrievalFeaturePropertiesCopyWith<$Res> get properties;

}
/// @nodoc
class __$MapboxRetrievalFeatureCopyWithImpl<$Res>
    implements _$MapboxRetrievalFeatureCopyWith<$Res> {
  __$MapboxRetrievalFeatureCopyWithImpl(this._self, this._then);

  final _MapboxRetrievalFeature _self;
  final $Res Function(_MapboxRetrievalFeature) _then;

/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? properties = null,}) {
  return _then(_MapboxRetrievalFeature(
properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as MapboxRetrievalFeatureProperties,
  ));
}

/// Create a copy of MapboxRetrievalFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapboxRetrievalFeaturePropertiesCopyWith<$Res> get properties {
  
  return $MapboxRetrievalFeaturePropertiesCopyWith<$Res>(_self.properties, (value) {
    return _then(_self.copyWith(properties: value));
  });
}
}


/// @nodoc
mixin _$MapboxRetrievalFeatureProperties {

 Coordinates get coordinates;
/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxRetrievalFeaturePropertiesCopyWith<MapboxRetrievalFeatureProperties> get copyWith => _$MapboxRetrievalFeaturePropertiesCopyWithImpl<MapboxRetrievalFeatureProperties>(this as MapboxRetrievalFeatureProperties, _$identity);

  /// Serializes this MapboxRetrievalFeatureProperties to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxRetrievalFeatureProperties&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coordinates);

@override
String toString() {
  return 'MapboxRetrievalFeatureProperties(coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $MapboxRetrievalFeaturePropertiesCopyWith<$Res>  {
  factory $MapboxRetrievalFeaturePropertiesCopyWith(MapboxRetrievalFeatureProperties value, $Res Function(MapboxRetrievalFeatureProperties) _then) = _$MapboxRetrievalFeaturePropertiesCopyWithImpl;
@useResult
$Res call({
 Coordinates coordinates
});


$CoordinatesCopyWith<$Res> get coordinates;

}
/// @nodoc
class _$MapboxRetrievalFeaturePropertiesCopyWithImpl<$Res>
    implements $MapboxRetrievalFeaturePropertiesCopyWith<$Res> {
  _$MapboxRetrievalFeaturePropertiesCopyWithImpl(this._self, this._then);

  final MapboxRetrievalFeatureProperties _self;
  final $Res Function(MapboxRetrievalFeatureProperties) _then;

/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coordinates = null,}) {
  return _then(_self.copyWith(
coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates,
  ));
}
/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res> get coordinates {
  
  return $CoordinatesCopyWith<$Res>(_self.coordinates, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapboxRetrievalFeatureProperties].
extension MapboxRetrievalFeaturePropertiesPatterns on MapboxRetrievalFeatureProperties {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxRetrievalFeatureProperties value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxRetrievalFeatureProperties value)  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxRetrievalFeatureProperties value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Coordinates coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties() when $default != null:
return $default(_that.coordinates);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Coordinates coordinates)  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties():
return $default(_that.coordinates);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Coordinates coordinates)?  $default,) {final _that = this;
switch (_that) {
case _MapboxRetrievalFeatureProperties() when $default != null:
return $default(_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxRetrievalFeatureProperties implements MapboxRetrievalFeatureProperties {
  const _MapboxRetrievalFeatureProperties({required this.coordinates});
  factory _MapboxRetrievalFeatureProperties.fromJson(Map<String, dynamic> json) => _$MapboxRetrievalFeaturePropertiesFromJson(json);

@override final  Coordinates coordinates;

/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxRetrievalFeaturePropertiesCopyWith<_MapboxRetrievalFeatureProperties> get copyWith => __$MapboxRetrievalFeaturePropertiesCopyWithImpl<_MapboxRetrievalFeatureProperties>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxRetrievalFeaturePropertiesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxRetrievalFeatureProperties&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coordinates);

@override
String toString() {
  return 'MapboxRetrievalFeatureProperties(coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$MapboxRetrievalFeaturePropertiesCopyWith<$Res> implements $MapboxRetrievalFeaturePropertiesCopyWith<$Res> {
  factory _$MapboxRetrievalFeaturePropertiesCopyWith(_MapboxRetrievalFeatureProperties value, $Res Function(_MapboxRetrievalFeatureProperties) _then) = __$MapboxRetrievalFeaturePropertiesCopyWithImpl;
@override @useResult
$Res call({
 Coordinates coordinates
});


@override $CoordinatesCopyWith<$Res> get coordinates;

}
/// @nodoc
class __$MapboxRetrievalFeaturePropertiesCopyWithImpl<$Res>
    implements _$MapboxRetrievalFeaturePropertiesCopyWith<$Res> {
  __$MapboxRetrievalFeaturePropertiesCopyWithImpl(this._self, this._then);

  final _MapboxRetrievalFeatureProperties _self;
  final $Res Function(_MapboxRetrievalFeatureProperties) _then;

/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coordinates = null,}) {
  return _then(_MapboxRetrievalFeatureProperties(
coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates,
  ));
}

/// Create a copy of MapboxRetrievalFeatureProperties
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res> get coordinates {
  
  return $CoordinatesCopyWith<$Res>(_self.coordinates, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// @nodoc
mixin _$Coordinates {

 double get latitude; double get longitude;
/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<Coordinates> get copyWith => _$CoordinatesCopyWithImpl<Coordinates>(this as Coordinates, _$identity);

  /// Serializes this Coordinates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'Coordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $CoordinatesCopyWith<$Res>  {
  factory $CoordinatesCopyWith(Coordinates value, $Res Function(Coordinates) _then) = _$CoordinatesCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$CoordinatesCopyWithImpl<$Res>
    implements $CoordinatesCopyWith<$Res> {
  _$CoordinatesCopyWithImpl(this._self, this._then);

  final Coordinates _self;
  final $Res Function(Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Coordinates].
extension CoordinatesPatterns on Coordinates {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coordinates value)  $default,){
final _that = this;
switch (_that) {
case _Coordinates():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coordinates value)?  $default,){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _Coordinates():
return $default(_that.latitude,_that.longitude);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coordinates extends Coordinates {
  const _Coordinates({required this.latitude, required this.longitude}): super._();
  factory _Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatesCopyWith<_Coordinates> get copyWith => __$CoordinatesCopyWithImpl<_Coordinates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'Coordinates(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$CoordinatesCopyWith<$Res> implements $CoordinatesCopyWith<$Res> {
  factory _$CoordinatesCopyWith(_Coordinates value, $Res Function(_Coordinates) _then) = __$CoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$CoordinatesCopyWithImpl<$Res>
    implements _$CoordinatesCopyWith<$Res> {
  __$CoordinatesCopyWithImpl(this._self, this._then);

  final _Coordinates _self;
  final $Res Function(_Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_Coordinates(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
