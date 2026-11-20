// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'antrag_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AntragProgress {

 Prozess get prozess; ProzessVersion get prozessVersion; Kommune get kommune; List<Fragment_Schritt> get schritte; int get index; EditableSlots get slots; EditableSlots get slotErrors; AntragClientStatus get clientStatus; String? get ausfuehrungId; String? get sharedKeyEncryptedForBuerger;
/// Create a copy of AntragProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AntragProgressCopyWith<AntragProgress> get copyWith => _$AntragProgressCopyWithImpl<AntragProgress>(this as AntragProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AntragProgress&&(identical(other.prozess, prozess) || other.prozess == prozess)&&(identical(other.prozessVersion, prozessVersion) || other.prozessVersion == prozessVersion)&&(identical(other.kommune, kommune) || other.kommune == kommune)&&const DeepCollectionEquality().equals(other.schritte, schritte)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.slots, slots)&&const DeepCollectionEquality().equals(other.slotErrors, slotErrors)&&(identical(other.clientStatus, clientStatus) || other.clientStatus == clientStatus)&&(identical(other.ausfuehrungId, ausfuehrungId) || other.ausfuehrungId == ausfuehrungId)&&(identical(other.sharedKeyEncryptedForBuerger, sharedKeyEncryptedForBuerger) || other.sharedKeyEncryptedForBuerger == sharedKeyEncryptedForBuerger));
}


@override
int get hashCode => Object.hash(runtimeType,prozess,prozessVersion,kommune,const DeepCollectionEquality().hash(schritte),index,const DeepCollectionEquality().hash(slots),const DeepCollectionEquality().hash(slotErrors),clientStatus,ausfuehrungId,sharedKeyEncryptedForBuerger);

@override
String toString() {
  return 'AntragProgress(prozess: $prozess, prozessVersion: $prozessVersion, kommune: $kommune, schritte: $schritte, index: $index, slots: $slots, slotErrors: $slotErrors, clientStatus: $clientStatus, ausfuehrungId: $ausfuehrungId, sharedKeyEncryptedForBuerger: $sharedKeyEncryptedForBuerger)';
}


}

/// @nodoc
abstract mixin class $AntragProgressCopyWith<$Res>  {
  factory $AntragProgressCopyWith(AntragProgress value, $Res Function(AntragProgress) _then) = _$AntragProgressCopyWithImpl;
@useResult
$Res call({
 Prozess prozess, ProzessVersion prozessVersion, Kommune kommune, List<Fragment_Schritt> schritte, int index, EditableSlots slots, EditableSlots slotErrors, AntragClientStatus clientStatus, String? ausfuehrungId, String? sharedKeyEncryptedForBuerger
});




}
/// @nodoc
class _$AntragProgressCopyWithImpl<$Res>
    implements $AntragProgressCopyWith<$Res> {
  _$AntragProgressCopyWithImpl(this._self, this._then);

  final AntragProgress _self;
  final $Res Function(AntragProgress) _then;

/// Create a copy of AntragProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prozess = null,Object? prozessVersion = null,Object? kommune = null,Object? schritte = null,Object? index = null,Object? slots = null,Object? slotErrors = null,Object? clientStatus = null,Object? ausfuehrungId = freezed,Object? sharedKeyEncryptedForBuerger = freezed,}) {
  return _then(_self.copyWith(
prozess: null == prozess ? _self.prozess : prozess // ignore: cast_nullable_to_non_nullable
as Prozess,prozessVersion: null == prozessVersion ? _self.prozessVersion : prozessVersion // ignore: cast_nullable_to_non_nullable
as ProzessVersion,kommune: null == kommune ? _self.kommune : kommune // ignore: cast_nullable_to_non_nullable
as Kommune,schritte: null == schritte ? _self.schritte : schritte // ignore: cast_nullable_to_non_nullable
as List<Fragment_Schritt>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as EditableSlots,slotErrors: null == slotErrors ? _self.slotErrors : slotErrors // ignore: cast_nullable_to_non_nullable
as EditableSlots,clientStatus: null == clientStatus ? _self.clientStatus : clientStatus // ignore: cast_nullable_to_non_nullable
as AntragClientStatus,ausfuehrungId: freezed == ausfuehrungId ? _self.ausfuehrungId : ausfuehrungId // ignore: cast_nullable_to_non_nullable
as String?,sharedKeyEncryptedForBuerger: freezed == sharedKeyEncryptedForBuerger ? _self.sharedKeyEncryptedForBuerger : sharedKeyEncryptedForBuerger // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AntragProgress].
extension AntragProgressPatterns on AntragProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AntragProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AntragProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AntragProgress value)  $default,){
final _that = this;
switch (_that) {
case _AntragProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AntragProgress value)?  $default,){
final _that = this;
switch (_that) {
case _AntragProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Prozess prozess,  ProzessVersion prozessVersion,  Kommune kommune,  List<Fragment_Schritt> schritte,  int index,  EditableSlots slots,  EditableSlots slotErrors,  AntragClientStatus clientStatus,  String? ausfuehrungId,  String? sharedKeyEncryptedForBuerger)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AntragProgress() when $default != null:
return $default(_that.prozess,_that.prozessVersion,_that.kommune,_that.schritte,_that.index,_that.slots,_that.slotErrors,_that.clientStatus,_that.ausfuehrungId,_that.sharedKeyEncryptedForBuerger);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Prozess prozess,  ProzessVersion prozessVersion,  Kommune kommune,  List<Fragment_Schritt> schritte,  int index,  EditableSlots slots,  EditableSlots slotErrors,  AntragClientStatus clientStatus,  String? ausfuehrungId,  String? sharedKeyEncryptedForBuerger)  $default,) {final _that = this;
switch (_that) {
case _AntragProgress():
return $default(_that.prozess,_that.prozessVersion,_that.kommune,_that.schritte,_that.index,_that.slots,_that.slotErrors,_that.clientStatus,_that.ausfuehrungId,_that.sharedKeyEncryptedForBuerger);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Prozess prozess,  ProzessVersion prozessVersion,  Kommune kommune,  List<Fragment_Schritt> schritte,  int index,  EditableSlots slots,  EditableSlots slotErrors,  AntragClientStatus clientStatus,  String? ausfuehrungId,  String? sharedKeyEncryptedForBuerger)?  $default,) {final _that = this;
switch (_that) {
case _AntragProgress() when $default != null:
return $default(_that.prozess,_that.prozessVersion,_that.kommune,_that.schritte,_that.index,_that.slots,_that.slotErrors,_that.clientStatus,_that.ausfuehrungId,_that.sharedKeyEncryptedForBuerger);case _:
  return null;

}
}

}

/// @nodoc


class _AntragProgress extends AntragProgress {
  const _AntragProgress({required this.prozess, required this.prozessVersion, required this.kommune, required final  List<Fragment_Schritt> schritte, this.index = 0, final  EditableSlots slots = const <String, dynamic>{}, final  EditableSlots slotErrors = const <String, dynamic>{}, this.clientStatus = AntragClientStatus.editing, this.ausfuehrungId, this.sharedKeyEncryptedForBuerger}): _schritte = schritte,_slots = slots,_slotErrors = slotErrors,super._();
  

@override final  Prozess prozess;
@override final  ProzessVersion prozessVersion;
@override final  Kommune kommune;
 final  List<Fragment_Schritt> _schritte;
@override List<Fragment_Schritt> get schritte {
  if (_schritte is EqualUnmodifiableListView) return _schritte;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schritte);
}

@override@JsonKey() final  int index;
 final  EditableSlots _slots;
@override@JsonKey() EditableSlots get slots {
  if (_slots is EqualUnmodifiableMapView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_slots);
}

 final  EditableSlots _slotErrors;
@override@JsonKey() EditableSlots get slotErrors {
  if (_slotErrors is EqualUnmodifiableMapView) return _slotErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_slotErrors);
}

@override@JsonKey() final  AntragClientStatus clientStatus;
@override final  String? ausfuehrungId;
@override final  String? sharedKeyEncryptedForBuerger;

/// Create a copy of AntragProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AntragProgressCopyWith<_AntragProgress> get copyWith => __$AntragProgressCopyWithImpl<_AntragProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AntragProgress&&(identical(other.prozess, prozess) || other.prozess == prozess)&&(identical(other.prozessVersion, prozessVersion) || other.prozessVersion == prozessVersion)&&(identical(other.kommune, kommune) || other.kommune == kommune)&&const DeepCollectionEquality().equals(other._schritte, _schritte)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other._slots, _slots)&&const DeepCollectionEquality().equals(other._slotErrors, _slotErrors)&&(identical(other.clientStatus, clientStatus) || other.clientStatus == clientStatus)&&(identical(other.ausfuehrungId, ausfuehrungId) || other.ausfuehrungId == ausfuehrungId)&&(identical(other.sharedKeyEncryptedForBuerger, sharedKeyEncryptedForBuerger) || other.sharedKeyEncryptedForBuerger == sharedKeyEncryptedForBuerger));
}


@override
int get hashCode => Object.hash(runtimeType,prozess,prozessVersion,kommune,const DeepCollectionEquality().hash(_schritte),index,const DeepCollectionEquality().hash(_slots),const DeepCollectionEquality().hash(_slotErrors),clientStatus,ausfuehrungId,sharedKeyEncryptedForBuerger);

@override
String toString() {
  return 'AntragProgress(prozess: $prozess, prozessVersion: $prozessVersion, kommune: $kommune, schritte: $schritte, index: $index, slots: $slots, slotErrors: $slotErrors, clientStatus: $clientStatus, ausfuehrungId: $ausfuehrungId, sharedKeyEncryptedForBuerger: $sharedKeyEncryptedForBuerger)';
}


}

/// @nodoc
abstract mixin class _$AntragProgressCopyWith<$Res> implements $AntragProgressCopyWith<$Res> {
  factory _$AntragProgressCopyWith(_AntragProgress value, $Res Function(_AntragProgress) _then) = __$AntragProgressCopyWithImpl;
@override @useResult
$Res call({
 Prozess prozess, ProzessVersion prozessVersion, Kommune kommune, List<Fragment_Schritt> schritte, int index, EditableSlots slots, EditableSlots slotErrors, AntragClientStatus clientStatus, String? ausfuehrungId, String? sharedKeyEncryptedForBuerger
});




}
/// @nodoc
class __$AntragProgressCopyWithImpl<$Res>
    implements _$AntragProgressCopyWith<$Res> {
  __$AntragProgressCopyWithImpl(this._self, this._then);

  final _AntragProgress _self;
  final $Res Function(_AntragProgress) _then;

/// Create a copy of AntragProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prozess = null,Object? prozessVersion = null,Object? kommune = null,Object? schritte = null,Object? index = null,Object? slots = null,Object? slotErrors = null,Object? clientStatus = null,Object? ausfuehrungId = freezed,Object? sharedKeyEncryptedForBuerger = freezed,}) {
  return _then(_AntragProgress(
prozess: null == prozess ? _self.prozess : prozess // ignore: cast_nullable_to_non_nullable
as Prozess,prozessVersion: null == prozessVersion ? _self.prozessVersion : prozessVersion // ignore: cast_nullable_to_non_nullable
as ProzessVersion,kommune: null == kommune ? _self.kommune : kommune // ignore: cast_nullable_to_non_nullable
as Kommune,schritte: null == schritte ? _self._schritte : schritte // ignore: cast_nullable_to_non_nullable
as List<Fragment_Schritt>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as EditableSlots,slotErrors: null == slotErrors ? _self._slotErrors : slotErrors // ignore: cast_nullable_to_non_nullable
as EditableSlots,clientStatus: null == clientStatus ? _self.clientStatus : clientStatus // ignore: cast_nullable_to_non_nullable
as AntragClientStatus,ausfuehrungId: freezed == ausfuehrungId ? _self.ausfuehrungId : ausfuehrungId // ignore: cast_nullable_to_non_nullable
as String?,sharedKeyEncryptedForBuerger: freezed == sharedKeyEncryptedForBuerger ? _self.sharedKeyEncryptedForBuerger : sharedKeyEncryptedForBuerger // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
