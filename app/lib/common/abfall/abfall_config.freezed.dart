// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abfall_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AbfallConfig {

 AbfallFilter get filter; AbfallBenachrichtigungen get benachrichtigungen;
/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbfallConfigCopyWith<AbfallConfig> get copyWith => _$AbfallConfigCopyWithImpl<AbfallConfig>(this as AbfallConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbfallConfig&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.benachrichtigungen, benachrichtigungen) || other.benachrichtigungen == benachrichtigungen));
}


@override
int get hashCode => Object.hash(runtimeType,filter,benachrichtigungen);

@override
String toString() {
  return 'AbfallConfig(filter: $filter, benachrichtigungen: $benachrichtigungen)';
}


}

/// @nodoc
abstract mixin class $AbfallConfigCopyWith<$Res>  {
  factory $AbfallConfigCopyWith(AbfallConfig value, $Res Function(AbfallConfig) _then) = _$AbfallConfigCopyWithImpl;
@useResult
$Res call({
 AbfallFilter filter, AbfallBenachrichtigungen benachrichtigungen
});


$AbfallFilterCopyWith<$Res> get filter;$AbfallBenachrichtigungenCopyWith<$Res> get benachrichtigungen;

}
/// @nodoc
class _$AbfallConfigCopyWithImpl<$Res>
    implements $AbfallConfigCopyWith<$Res> {
  _$AbfallConfigCopyWithImpl(this._self, this._then);

  final AbfallConfig _self;
  final $Res Function(AbfallConfig) _then;

/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? benachrichtigungen = null,}) {
  return _then(_self.copyWith(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AbfallFilter,benachrichtigungen: null == benachrichtigungen ? _self.benachrichtigungen : benachrichtigungen // ignore: cast_nullable_to_non_nullable
as AbfallBenachrichtigungen,
  ));
}
/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbfallFilterCopyWith<$Res> get filter {
  
  return $AbfallFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbfallBenachrichtigungenCopyWith<$Res> get benachrichtigungen {
  
  return $AbfallBenachrichtigungenCopyWith<$Res>(_self.benachrichtigungen, (value) {
    return _then(_self.copyWith(benachrichtigungen: value));
  });
}
}


/// Adds pattern-matching-related methods to [AbfallConfig].
extension AbfallConfigPatterns on AbfallConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbfallConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbfallConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbfallConfig value)  $default,){
final _that = this;
switch (_that) {
case _AbfallConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbfallConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AbfallConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AbfallFilter filter,  AbfallBenachrichtigungen benachrichtigungen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbfallConfig() when $default != null:
return $default(_that.filter,_that.benachrichtigungen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AbfallFilter filter,  AbfallBenachrichtigungen benachrichtigungen)  $default,) {final _that = this;
switch (_that) {
case _AbfallConfig():
return $default(_that.filter,_that.benachrichtigungen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AbfallFilter filter,  AbfallBenachrichtigungen benachrichtigungen)?  $default,) {final _that = this;
switch (_that) {
case _AbfallConfig() when $default != null:
return $default(_that.filter,_that.benachrichtigungen);case _:
  return null;

}
}

}

/// @nodoc


class _AbfallConfig implements AbfallConfig {
  const _AbfallConfig({required this.filter, required this.benachrichtigungen});
  

@override final  AbfallFilter filter;
@override final  AbfallBenachrichtigungen benachrichtigungen;

/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbfallConfigCopyWith<_AbfallConfig> get copyWith => __$AbfallConfigCopyWithImpl<_AbfallConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbfallConfig&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.benachrichtigungen, benachrichtigungen) || other.benachrichtigungen == benachrichtigungen));
}


@override
int get hashCode => Object.hash(runtimeType,filter,benachrichtigungen);

@override
String toString() {
  return 'AbfallConfig(filter: $filter, benachrichtigungen: $benachrichtigungen)';
}


}

/// @nodoc
abstract mixin class _$AbfallConfigCopyWith<$Res> implements $AbfallConfigCopyWith<$Res> {
  factory _$AbfallConfigCopyWith(_AbfallConfig value, $Res Function(_AbfallConfig) _then) = __$AbfallConfigCopyWithImpl;
@override @useResult
$Res call({
 AbfallFilter filter, AbfallBenachrichtigungen benachrichtigungen
});


@override $AbfallFilterCopyWith<$Res> get filter;@override $AbfallBenachrichtigungenCopyWith<$Res> get benachrichtigungen;

}
/// @nodoc
class __$AbfallConfigCopyWithImpl<$Res>
    implements _$AbfallConfigCopyWith<$Res> {
  __$AbfallConfigCopyWithImpl(this._self, this._then);

  final _AbfallConfig _self;
  final $Res Function(_AbfallConfig) _then;

/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? benachrichtigungen = null,}) {
  return _then(_AbfallConfig(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AbfallFilter,benachrichtigungen: null == benachrichtigungen ? _self.benachrichtigungen : benachrichtigungen // ignore: cast_nullable_to_non_nullable
as AbfallBenachrichtigungen,
  ));
}

/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbfallFilterCopyWith<$Res> get filter {
  
  return $AbfallFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}/// Create a copy of AbfallConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbfallBenachrichtigungenCopyWith<$Res> get benachrichtigungen {
  
  return $AbfallBenachrichtigungenCopyWith<$Res>(_self.benachrichtigungen, (value) {
    return _then(_self.copyWith(benachrichtigungen: value));
  });
}
}

// dart format on
