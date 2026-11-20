// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_sizer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextSizeState implements DiagnosticableTreeMixin {

 double get textSizeModifier;
/// Create a copy of TextSizeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextSizeStateCopyWith<TextSizeState> get copyWith => _$TextSizeStateCopyWithImpl<TextSizeState>(this as TextSizeState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TextSizeState'))
    ..add(DiagnosticsProperty('textSizeModifier', textSizeModifier));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextSizeState&&(identical(other.textSizeModifier, textSizeModifier) || other.textSizeModifier == textSizeModifier));
}


@override
int get hashCode => Object.hash(runtimeType,textSizeModifier);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TextSizeState(textSizeModifier: $textSizeModifier)';
}


}

/// @nodoc
abstract mixin class $TextSizeStateCopyWith<$Res>  {
  factory $TextSizeStateCopyWith(TextSizeState value, $Res Function(TextSizeState) _then) = _$TextSizeStateCopyWithImpl;
@useResult
$Res call({
 double textSizeModifier
});




}
/// @nodoc
class _$TextSizeStateCopyWithImpl<$Res>
    implements $TextSizeStateCopyWith<$Res> {
  _$TextSizeStateCopyWithImpl(this._self, this._then);

  final TextSizeState _self;
  final $Res Function(TextSizeState) _then;

/// Create a copy of TextSizeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? textSizeModifier = null,}) {
  return _then(_self.copyWith(
textSizeModifier: null == textSizeModifier ? _self.textSizeModifier : textSizeModifier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TextSizeState].
extension TextSizeStatePatterns on TextSizeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextSizeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextSizeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextSizeState value)  $default,){
final _that = this;
switch (_that) {
case _TextSizeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextSizeState value)?  $default,){
final _that = this;
switch (_that) {
case _TextSizeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double textSizeModifier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextSizeState() when $default != null:
return $default(_that.textSizeModifier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double textSizeModifier)  $default,) {final _that = this;
switch (_that) {
case _TextSizeState():
return $default(_that.textSizeModifier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double textSizeModifier)?  $default,) {final _that = this;
switch (_that) {
case _TextSizeState() when $default != null:
return $default(_that.textSizeModifier);case _:
  return null;

}
}

}

/// @nodoc


class _TextSizeState extends TextSizeState with DiagnosticableTreeMixin {
  const _TextSizeState(this.textSizeModifier): super._();
  

@override final  double textSizeModifier;

/// Create a copy of TextSizeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextSizeStateCopyWith<_TextSizeState> get copyWith => __$TextSizeStateCopyWithImpl<_TextSizeState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TextSizeState'))
    ..add(DiagnosticsProperty('textSizeModifier', textSizeModifier));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextSizeState&&(identical(other.textSizeModifier, textSizeModifier) || other.textSizeModifier == textSizeModifier));
}


@override
int get hashCode => Object.hash(runtimeType,textSizeModifier);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TextSizeState(textSizeModifier: $textSizeModifier)';
}


}

/// @nodoc
abstract mixin class _$TextSizeStateCopyWith<$Res> implements $TextSizeStateCopyWith<$Res> {
  factory _$TextSizeStateCopyWith(_TextSizeState value, $Res Function(_TextSizeState) _then) = __$TextSizeStateCopyWithImpl;
@override @useResult
$Res call({
 double textSizeModifier
});




}
/// @nodoc
class __$TextSizeStateCopyWithImpl<$Res>
    implements _$TextSizeStateCopyWith<$Res> {
  __$TextSizeStateCopyWithImpl(this._self, this._then);

  final _TextSizeState _self;
  final $Res Function(_TextSizeState) _then;

/// Create a copy of TextSizeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? textSizeModifier = null,}) {
  return _then(_TextSizeState(
null == textSizeModifier ? _self.textSizeModifier : textSizeModifier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
