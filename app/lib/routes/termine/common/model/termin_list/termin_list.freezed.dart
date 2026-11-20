// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'termin_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermineList {

 List<VeranstaltungsTermin> get veranstaltungen; List<AbfallkalenderTermin> get abfallkalenderTermine; int get currentPage; bool get hasNextPage;
/// Create a copy of TermineList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermineListCopyWith<TermineList> get copyWith => _$TermineListCopyWithImpl<TermineList>(this as TermineList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermineList&&const DeepCollectionEquality().equals(other.veranstaltungen, veranstaltungen)&&const DeepCollectionEquality().equals(other.abfallkalenderTermine, abfallkalenderTermine)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(veranstaltungen),const DeepCollectionEquality().hash(abfallkalenderTermine),currentPage,hasNextPage);

@override
String toString() {
  return 'TermineList(veranstaltungen: $veranstaltungen, abfallkalenderTermine: $abfallkalenderTermine, currentPage: $currentPage, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class $TermineListCopyWith<$Res>  {
  factory $TermineListCopyWith(TermineList value, $Res Function(TermineList) _then) = _$TermineListCopyWithImpl;
@useResult
$Res call({
 List<VeranstaltungsTermin> veranstaltungen, List<AbfallkalenderTermin> abfallkalenderTermine, int currentPage, bool hasNextPage
});




}
/// @nodoc
class _$TermineListCopyWithImpl<$Res>
    implements $TermineListCopyWith<$Res> {
  _$TermineListCopyWithImpl(this._self, this._then);

  final TermineList _self;
  final $Res Function(TermineList) _then;

/// Create a copy of TermineList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? veranstaltungen = null,Object? abfallkalenderTermine = null,Object? currentPage = null,Object? hasNextPage = null,}) {
  return _then(_self.copyWith(
veranstaltungen: null == veranstaltungen ? _self.veranstaltungen : veranstaltungen // ignore: cast_nullable_to_non_nullable
as List<VeranstaltungsTermin>,abfallkalenderTermine: null == abfallkalenderTermine ? _self.abfallkalenderTermine : abfallkalenderTermine // ignore: cast_nullable_to_non_nullable
as List<AbfallkalenderTermin>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TermineList].
extension TermineListPatterns on TermineList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermineList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermineList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermineList value)  $default,){
final _that = this;
switch (_that) {
case _TermineList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermineList value)?  $default,){
final _that = this;
switch (_that) {
case _TermineList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VeranstaltungsTermin> veranstaltungen,  List<AbfallkalenderTermin> abfallkalenderTermine,  int currentPage,  bool hasNextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermineList() when $default != null:
return $default(_that.veranstaltungen,_that.abfallkalenderTermine,_that.currentPage,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VeranstaltungsTermin> veranstaltungen,  List<AbfallkalenderTermin> abfallkalenderTermine,  int currentPage,  bool hasNextPage)  $default,) {final _that = this;
switch (_that) {
case _TermineList():
return $default(_that.veranstaltungen,_that.abfallkalenderTermine,_that.currentPage,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VeranstaltungsTermin> veranstaltungen,  List<AbfallkalenderTermin> abfallkalenderTermine,  int currentPage,  bool hasNextPage)?  $default,) {final _that = this;
switch (_that) {
case _TermineList() when $default != null:
return $default(_that.veranstaltungen,_that.abfallkalenderTermine,_that.currentPage,_that.hasNextPage);case _:
  return null;

}
}

}

/// @nodoc


class _TermineList implements TermineList {
  const _TermineList({required final  List<VeranstaltungsTermin> veranstaltungen, required final  List<AbfallkalenderTermin> abfallkalenderTermine, this.currentPage = 1, this.hasNextPage = false}): _veranstaltungen = veranstaltungen,_abfallkalenderTermine = abfallkalenderTermine;
  

 final  List<VeranstaltungsTermin> _veranstaltungen;
@override List<VeranstaltungsTermin> get veranstaltungen {
  if (_veranstaltungen is EqualUnmodifiableListView) return _veranstaltungen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_veranstaltungen);
}

 final  List<AbfallkalenderTermin> _abfallkalenderTermine;
@override List<AbfallkalenderTermin> get abfallkalenderTermine {
  if (_abfallkalenderTermine is EqualUnmodifiableListView) return _abfallkalenderTermine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_abfallkalenderTermine);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasNextPage;

/// Create a copy of TermineList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermineListCopyWith<_TermineList> get copyWith => __$TermineListCopyWithImpl<_TermineList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermineList&&const DeepCollectionEquality().equals(other._veranstaltungen, _veranstaltungen)&&const DeepCollectionEquality().equals(other._abfallkalenderTermine, _abfallkalenderTermine)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_veranstaltungen),const DeepCollectionEquality().hash(_abfallkalenderTermine),currentPage,hasNextPage);

@override
String toString() {
  return 'TermineList(veranstaltungen: $veranstaltungen, abfallkalenderTermine: $abfallkalenderTermine, currentPage: $currentPage, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class _$TermineListCopyWith<$Res> implements $TermineListCopyWith<$Res> {
  factory _$TermineListCopyWith(_TermineList value, $Res Function(_TermineList) _then) = __$TermineListCopyWithImpl;
@override @useResult
$Res call({
 List<VeranstaltungsTermin> veranstaltungen, List<AbfallkalenderTermin> abfallkalenderTermine, int currentPage, bool hasNextPage
});




}
/// @nodoc
class __$TermineListCopyWithImpl<$Res>
    implements _$TermineListCopyWith<$Res> {
  __$TermineListCopyWithImpl(this._self, this._then);

  final _TermineList _self;
  final $Res Function(_TermineList) _then;

/// Create a copy of TermineList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? veranstaltungen = null,Object? abfallkalenderTermine = null,Object? currentPage = null,Object? hasNextPage = null,}) {
  return _then(_TermineList(
veranstaltungen: null == veranstaltungen ? _self._veranstaltungen : veranstaltungen // ignore: cast_nullable_to_non_nullable
as List<VeranstaltungsTermin>,abfallkalenderTermine: null == abfallkalenderTermine ? _self._abfallkalenderTermine : abfallkalenderTermine // ignore: cast_nullable_to_non_nullable
as List<AbfallkalenderTermin>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
