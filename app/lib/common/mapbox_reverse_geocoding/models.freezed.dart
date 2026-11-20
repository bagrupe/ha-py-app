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
mixin _$MapboxReverseGeocodingResults {

 List<MapboxReverseGeocodingResult> get features;
/// Create a copy of MapboxReverseGeocodingResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxReverseGeocodingResultsCopyWith<MapboxReverseGeocodingResults> get copyWith => _$MapboxReverseGeocodingResultsCopyWithImpl<MapboxReverseGeocodingResults>(this as MapboxReverseGeocodingResults, _$identity);

  /// Serializes this MapboxReverseGeocodingResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxReverseGeocodingResults&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'MapboxReverseGeocodingResults(features: $features)';
}


}

/// @nodoc
abstract mixin class $MapboxReverseGeocodingResultsCopyWith<$Res>  {
  factory $MapboxReverseGeocodingResultsCopyWith(MapboxReverseGeocodingResults value, $Res Function(MapboxReverseGeocodingResults) _then) = _$MapboxReverseGeocodingResultsCopyWithImpl;
@useResult
$Res call({
 List<MapboxReverseGeocodingResult> features
});




}
/// @nodoc
class _$MapboxReverseGeocodingResultsCopyWithImpl<$Res>
    implements $MapboxReverseGeocodingResultsCopyWith<$Res> {
  _$MapboxReverseGeocodingResultsCopyWithImpl(this._self, this._then);

  final MapboxReverseGeocodingResults _self;
  final $Res Function(MapboxReverseGeocodingResults) _then;

/// Create a copy of MapboxReverseGeocodingResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? features = null,}) {
  return _then(_self.copyWith(
features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<MapboxReverseGeocodingResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapboxReverseGeocodingResults].
extension MapboxReverseGeocodingResultsPatterns on MapboxReverseGeocodingResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxReverseGeocodingResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxReverseGeocodingResults value)  $default,){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxReverseGeocodingResults value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapboxReverseGeocodingResult> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapboxReverseGeocodingResult> features)  $default,) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapboxReverseGeocodingResult> features)?  $default,) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResults() when $default != null:
return $default(_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxReverseGeocodingResults implements MapboxReverseGeocodingResults {
  const _MapboxReverseGeocodingResults({required final  List<MapboxReverseGeocodingResult> features}): _features = features;
  factory _MapboxReverseGeocodingResults.fromJson(Map<String, dynamic> json) => _$MapboxReverseGeocodingResultsFromJson(json);

 final  List<MapboxReverseGeocodingResult> _features;
@override List<MapboxReverseGeocodingResult> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of MapboxReverseGeocodingResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxReverseGeocodingResultsCopyWith<_MapboxReverseGeocodingResults> get copyWith => __$MapboxReverseGeocodingResultsCopyWithImpl<_MapboxReverseGeocodingResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxReverseGeocodingResultsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxReverseGeocodingResults&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'MapboxReverseGeocodingResults(features: $features)';
}


}

/// @nodoc
abstract mixin class _$MapboxReverseGeocodingResultsCopyWith<$Res> implements $MapboxReverseGeocodingResultsCopyWith<$Res> {
  factory _$MapboxReverseGeocodingResultsCopyWith(_MapboxReverseGeocodingResults value, $Res Function(_MapboxReverseGeocodingResults) _then) = __$MapboxReverseGeocodingResultsCopyWithImpl;
@override @useResult
$Res call({
 List<MapboxReverseGeocodingResult> features
});




}
/// @nodoc
class __$MapboxReverseGeocodingResultsCopyWithImpl<$Res>
    implements _$MapboxReverseGeocodingResultsCopyWith<$Res> {
  __$MapboxReverseGeocodingResultsCopyWithImpl(this._self, this._then);

  final _MapboxReverseGeocodingResults _self;
  final $Res Function(_MapboxReverseGeocodingResults) _then;

/// Create a copy of MapboxReverseGeocodingResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? features = null,}) {
  return _then(_MapboxReverseGeocodingResults(
features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<MapboxReverseGeocodingResult>,
  ));
}


}


/// @nodoc
mixin _$MapboxReverseGeocodingResult {

 String get id; List<String> get placeType; String? get placeNameDe;
/// Create a copy of MapboxReverseGeocodingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapboxReverseGeocodingResultCopyWith<MapboxReverseGeocodingResult> get copyWith => _$MapboxReverseGeocodingResultCopyWithImpl<MapboxReverseGeocodingResult>(this as MapboxReverseGeocodingResult, _$identity);

  /// Serializes this MapboxReverseGeocodingResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapboxReverseGeocodingResult&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.placeType, placeType)&&(identical(other.placeNameDe, placeNameDe) || other.placeNameDe == placeNameDe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(placeType),placeNameDe);

@override
String toString() {
  return 'MapboxReverseGeocodingResult(id: $id, placeType: $placeType, placeNameDe: $placeNameDe)';
}


}

/// @nodoc
abstract mixin class $MapboxReverseGeocodingResultCopyWith<$Res>  {
  factory $MapboxReverseGeocodingResultCopyWith(MapboxReverseGeocodingResult value, $Res Function(MapboxReverseGeocodingResult) _then) = _$MapboxReverseGeocodingResultCopyWithImpl;
@useResult
$Res call({
 String id, List<String> placeType, String? placeNameDe
});




}
/// @nodoc
class _$MapboxReverseGeocodingResultCopyWithImpl<$Res>
    implements $MapboxReverseGeocodingResultCopyWith<$Res> {
  _$MapboxReverseGeocodingResultCopyWithImpl(this._self, this._then);

  final MapboxReverseGeocodingResult _self;
  final $Res Function(MapboxReverseGeocodingResult) _then;

/// Create a copy of MapboxReverseGeocodingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeType = null,Object? placeNameDe = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeType: null == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as List<String>,placeNameDe: freezed == placeNameDe ? _self.placeNameDe : placeNameDe // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapboxReverseGeocodingResult].
extension MapboxReverseGeocodingResultPatterns on MapboxReverseGeocodingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapboxReverseGeocodingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapboxReverseGeocodingResult value)  $default,){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapboxReverseGeocodingResult value)?  $default,){
final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> placeType,  String? placeNameDe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult() when $default != null:
return $default(_that.id,_that.placeType,_that.placeNameDe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> placeType,  String? placeNameDe)  $default,) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult():
return $default(_that.id,_that.placeType,_that.placeNameDe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> placeType,  String? placeNameDe)?  $default,) {final _that = this;
switch (_that) {
case _MapboxReverseGeocodingResult() when $default != null:
return $default(_that.id,_that.placeType,_that.placeNameDe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapboxReverseGeocodingResult implements MapboxReverseGeocodingResult {
  const _MapboxReverseGeocodingResult({required this.id, required final  List<String> placeType, this.placeNameDe}): _placeType = placeType;
  factory _MapboxReverseGeocodingResult.fromJson(Map<String, dynamic> json) => _$MapboxReverseGeocodingResultFromJson(json);

@override final  String id;
 final  List<String> _placeType;
@override List<String> get placeType {
  if (_placeType is EqualUnmodifiableListView) return _placeType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placeType);
}

@override final  String? placeNameDe;

/// Create a copy of MapboxReverseGeocodingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapboxReverseGeocodingResultCopyWith<_MapboxReverseGeocodingResult> get copyWith => __$MapboxReverseGeocodingResultCopyWithImpl<_MapboxReverseGeocodingResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapboxReverseGeocodingResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapboxReverseGeocodingResult&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._placeType, _placeType)&&(identical(other.placeNameDe, placeNameDe) || other.placeNameDe == placeNameDe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_placeType),placeNameDe);

@override
String toString() {
  return 'MapboxReverseGeocodingResult(id: $id, placeType: $placeType, placeNameDe: $placeNameDe)';
}


}

/// @nodoc
abstract mixin class _$MapboxReverseGeocodingResultCopyWith<$Res> implements $MapboxReverseGeocodingResultCopyWith<$Res> {
  factory _$MapboxReverseGeocodingResultCopyWith(_MapboxReverseGeocodingResult value, $Res Function(_MapboxReverseGeocodingResult) _then) = __$MapboxReverseGeocodingResultCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> placeType, String? placeNameDe
});




}
/// @nodoc
class __$MapboxReverseGeocodingResultCopyWithImpl<$Res>
    implements _$MapboxReverseGeocodingResultCopyWith<$Res> {
  __$MapboxReverseGeocodingResultCopyWithImpl(this._self, this._then);

  final _MapboxReverseGeocodingResult _self;
  final $Res Function(_MapboxReverseGeocodingResult) _then;

/// Create a copy of MapboxReverseGeocodingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeType = null,Object? placeNameDe = freezed,}) {
  return _then(_MapboxReverseGeocodingResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeType: null == placeType ? _self._placeType : placeType // ignore: cast_nullable_to_non_nullable
as List<String>,placeNameDe: freezed == placeNameDe ? _self.placeNameDe : placeNameDe // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
