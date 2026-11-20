// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abfall_benachrichtigungen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbfallBenachrichtigungen {

 AbfallBenachrichtigungenPresets get preset; bool get enabled;@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get zeitpunkt;
/// Create a copy of AbfallBenachrichtigungen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbfallBenachrichtigungenCopyWith<AbfallBenachrichtigungen> get copyWith => _$AbfallBenachrichtigungenCopyWithImpl<AbfallBenachrichtigungen>(this as AbfallBenachrichtigungen, _$identity);

  /// Serializes this AbfallBenachrichtigungen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbfallBenachrichtigungen&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.zeitpunkt, zeitpunkt) || other.zeitpunkt == zeitpunkt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preset,enabled,zeitpunkt);

@override
String toString() {
  return 'AbfallBenachrichtigungen(preset: $preset, enabled: $enabled, zeitpunkt: $zeitpunkt)';
}


}

/// @nodoc
abstract mixin class $AbfallBenachrichtigungenCopyWith<$Res>  {
  factory $AbfallBenachrichtigungenCopyWith(AbfallBenachrichtigungen value, $Res Function(AbfallBenachrichtigungen) _then) = _$AbfallBenachrichtigungenCopyWithImpl;
@useResult
$Res call({
 AbfallBenachrichtigungenPresets preset, bool enabled,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay zeitpunkt
});




}
/// @nodoc
class _$AbfallBenachrichtigungenCopyWithImpl<$Res>
    implements $AbfallBenachrichtigungenCopyWith<$Res> {
  _$AbfallBenachrichtigungenCopyWithImpl(this._self, this._then);

  final AbfallBenachrichtigungen _self;
  final $Res Function(AbfallBenachrichtigungen) _then;

/// Create a copy of AbfallBenachrichtigungen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preset = null,Object? enabled = null,Object? zeitpunkt = null,}) {
  return _then(_self.copyWith(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as AbfallBenachrichtigungenPresets,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,zeitpunkt: null == zeitpunkt ? _self.zeitpunkt : zeitpunkt // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [AbfallBenachrichtigungen].
extension AbfallBenachrichtigungenPatterns on AbfallBenachrichtigungen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbfallBenachrichtigungen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbfallBenachrichtigungen value)  $default,){
final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbfallBenachrichtigungen value)?  $default,){
final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AbfallBenachrichtigungenPresets preset,  bool enabled, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay zeitpunkt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen() when $default != null:
return $default(_that.preset,_that.enabled,_that.zeitpunkt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AbfallBenachrichtigungenPresets preset,  bool enabled, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay zeitpunkt)  $default,) {final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen():
return $default(_that.preset,_that.enabled,_that.zeitpunkt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AbfallBenachrichtigungenPresets preset,  bool enabled, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay zeitpunkt)?  $default,) {final _that = this;
switch (_that) {
case _AbfallBenachrichtigungen() when $default != null:
return $default(_that.preset,_that.enabled,_that.zeitpunkt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbfallBenachrichtigungen implements AbfallBenachrichtigungen {
   _AbfallBenachrichtigungen({required this.preset, required this.enabled, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) required this.zeitpunkt});
  factory _AbfallBenachrichtigungen.fromJson(Map<String, dynamic> json) => _$AbfallBenachrichtigungenFromJson(json);

@override final  AbfallBenachrichtigungenPresets preset;
@override final  bool enabled;
@override@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay zeitpunkt;

/// Create a copy of AbfallBenachrichtigungen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbfallBenachrichtigungenCopyWith<_AbfallBenachrichtigungen> get copyWith => __$AbfallBenachrichtigungenCopyWithImpl<_AbfallBenachrichtigungen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbfallBenachrichtigungenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbfallBenachrichtigungen&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.zeitpunkt, zeitpunkt) || other.zeitpunkt == zeitpunkt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preset,enabled,zeitpunkt);

@override
String toString() {
  return 'AbfallBenachrichtigungen(preset: $preset, enabled: $enabled, zeitpunkt: $zeitpunkt)';
}


}

/// @nodoc
abstract mixin class _$AbfallBenachrichtigungenCopyWith<$Res> implements $AbfallBenachrichtigungenCopyWith<$Res> {
  factory _$AbfallBenachrichtigungenCopyWith(_AbfallBenachrichtigungen value, $Res Function(_AbfallBenachrichtigungen) _then) = __$AbfallBenachrichtigungenCopyWithImpl;
@override @useResult
$Res call({
 AbfallBenachrichtigungenPresets preset, bool enabled,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay zeitpunkt
});




}
/// @nodoc
class __$AbfallBenachrichtigungenCopyWithImpl<$Res>
    implements _$AbfallBenachrichtigungenCopyWith<$Res> {
  __$AbfallBenachrichtigungenCopyWithImpl(this._self, this._then);

  final _AbfallBenachrichtigungen _self;
  final $Res Function(_AbfallBenachrichtigungen) _then;

/// Create a copy of AbfallBenachrichtigungen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preset = null,Object? enabled = null,Object? zeitpunkt = null,}) {
  return _then(_AbfallBenachrichtigungen(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as AbfallBenachrichtigungenPresets,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,zeitpunkt: null == zeitpunkt ? _self.zeitpunkt : zeitpunkt // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
