// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abfall_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbfallFilter {

 String? get ort; String? get strasse; String? get anfangsbuchstabe; String? get standort; String? get fraktionen;
/// Create a copy of AbfallFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbfallFilterCopyWith<AbfallFilter> get copyWith => _$AbfallFilterCopyWithImpl<AbfallFilter>(this as AbfallFilter, _$identity);

  /// Serializes this AbfallFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbfallFilter&&(identical(other.ort, ort) || other.ort == ort)&&(identical(other.strasse, strasse) || other.strasse == strasse)&&(identical(other.anfangsbuchstabe, anfangsbuchstabe) || other.anfangsbuchstabe == anfangsbuchstabe)&&(identical(other.standort, standort) || other.standort == standort)&&(identical(other.fraktionen, fraktionen) || other.fraktionen == fraktionen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ort,strasse,anfangsbuchstabe,standort,fraktionen);

@override
String toString() {
  return 'AbfallFilter(ort: $ort, strasse: $strasse, anfangsbuchstabe: $anfangsbuchstabe, standort: $standort, fraktionen: $fraktionen)';
}


}

/// @nodoc
abstract mixin class $AbfallFilterCopyWith<$Res>  {
  factory $AbfallFilterCopyWith(AbfallFilter value, $Res Function(AbfallFilter) _then) = _$AbfallFilterCopyWithImpl;
@useResult
$Res call({
 String? ort, String? strasse, String? anfangsbuchstabe, String? standort, String? fraktionen
});




}
/// @nodoc
class _$AbfallFilterCopyWithImpl<$Res>
    implements $AbfallFilterCopyWith<$Res> {
  _$AbfallFilterCopyWithImpl(this._self, this._then);

  final AbfallFilter _self;
  final $Res Function(AbfallFilter) _then;

/// Create a copy of AbfallFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ort = freezed,Object? strasse = freezed,Object? anfangsbuchstabe = freezed,Object? standort = freezed,Object? fraktionen = freezed,}) {
  return _then(_self.copyWith(
ort: freezed == ort ? _self.ort : ort // ignore: cast_nullable_to_non_nullable
as String?,strasse: freezed == strasse ? _self.strasse : strasse // ignore: cast_nullable_to_non_nullable
as String?,anfangsbuchstabe: freezed == anfangsbuchstabe ? _self.anfangsbuchstabe : anfangsbuchstabe // ignore: cast_nullable_to_non_nullable
as String?,standort: freezed == standort ? _self.standort : standort // ignore: cast_nullable_to_non_nullable
as String?,fraktionen: freezed == fraktionen ? _self.fraktionen : fraktionen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AbfallFilter].
extension AbfallFilterPatterns on AbfallFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbfallFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbfallFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbfallFilter value)  $default,){
final _that = this;
switch (_that) {
case _AbfallFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbfallFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AbfallFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ort,  String? strasse,  String? anfangsbuchstabe,  String? standort,  String? fraktionen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbfallFilter() when $default != null:
return $default(_that.ort,_that.strasse,_that.anfangsbuchstabe,_that.standort,_that.fraktionen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ort,  String? strasse,  String? anfangsbuchstabe,  String? standort,  String? fraktionen)  $default,) {final _that = this;
switch (_that) {
case _AbfallFilter():
return $default(_that.ort,_that.strasse,_that.anfangsbuchstabe,_that.standort,_that.fraktionen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ort,  String? strasse,  String? anfangsbuchstabe,  String? standort,  String? fraktionen)?  $default,) {final _that = this;
switch (_that) {
case _AbfallFilter() when $default != null:
return $default(_that.ort,_that.strasse,_that.anfangsbuchstabe,_that.standort,_that.fraktionen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbfallFilter implements AbfallFilter {
   _AbfallFilter({this.ort, this.strasse, this.anfangsbuchstabe, this.standort, this.fraktionen});
  factory _AbfallFilter.fromJson(Map<String, dynamic> json) => _$AbfallFilterFromJson(json);

@override final  String? ort;
@override final  String? strasse;
@override final  String? anfangsbuchstabe;
@override final  String? standort;
@override final  String? fraktionen;

/// Create a copy of AbfallFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbfallFilterCopyWith<_AbfallFilter> get copyWith => __$AbfallFilterCopyWithImpl<_AbfallFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbfallFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbfallFilter&&(identical(other.ort, ort) || other.ort == ort)&&(identical(other.strasse, strasse) || other.strasse == strasse)&&(identical(other.anfangsbuchstabe, anfangsbuchstabe) || other.anfangsbuchstabe == anfangsbuchstabe)&&(identical(other.standort, standort) || other.standort == standort)&&(identical(other.fraktionen, fraktionen) || other.fraktionen == fraktionen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ort,strasse,anfangsbuchstabe,standort,fraktionen);

@override
String toString() {
  return 'AbfallFilter(ort: $ort, strasse: $strasse, anfangsbuchstabe: $anfangsbuchstabe, standort: $standort, fraktionen: $fraktionen)';
}


}

/// @nodoc
abstract mixin class _$AbfallFilterCopyWith<$Res> implements $AbfallFilterCopyWith<$Res> {
  factory _$AbfallFilterCopyWith(_AbfallFilter value, $Res Function(_AbfallFilter) _then) = __$AbfallFilterCopyWithImpl;
@override @useResult
$Res call({
 String? ort, String? strasse, String? anfangsbuchstabe, String? standort, String? fraktionen
});




}
/// @nodoc
class __$AbfallFilterCopyWithImpl<$Res>
    implements _$AbfallFilterCopyWith<$Res> {
  __$AbfallFilterCopyWithImpl(this._self, this._then);

  final _AbfallFilter _self;
  final $Res Function(_AbfallFilter) _then;

/// Create a copy of AbfallFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ort = freezed,Object? strasse = freezed,Object? anfangsbuchstabe = freezed,Object? standort = freezed,Object? fraktionen = freezed,}) {
  return _then(_AbfallFilter(
ort: freezed == ort ? _self.ort : ort // ignore: cast_nullable_to_non_nullable
as String?,strasse: freezed == strasse ? _self.strasse : strasse // ignore: cast_nullable_to_non_nullable
as String?,anfangsbuchstabe: freezed == anfangsbuchstabe ? _self.anfangsbuchstabe : anfangsbuchstabe // ignore: cast_nullable_to_non_nullable
as String?,standort: freezed == standort ? _self.standort : standort // ignore: cast_nullable_to_non_nullable
as String?,fraktionen: freezed == fraktionen ? _self.fraktionen : fraktionen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
